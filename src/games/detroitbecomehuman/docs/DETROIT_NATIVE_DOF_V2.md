# Detroit: Native DOF v2

## Русская документация

### Назначение

Native DOF v2 исправляет заметную квадратность и ступенчатые переходы глубины
резкости в **Detroit: Become Human**, не заменяя DOF внешним ReShade-эффектом.
Все четыре SPIR-V-замены встроены в
`renodx-detroitbecomehuman.addon64` и работают в нативной Vulkan-цепочке игры.

Цель исправления — сохранить авторские параметры фокуса, форму апертуры,
максимальный радиус и характерное глубокое боке Detroit, но убрать влияние
грубой tile-классификации на видимые границы размытия.

### Почему Vanilla выглядел квадратным

Часть нативной DOF-цепочки работает в половинном разрешении. Группа `8x8`
DOF-пикселей соответствует приблизительно `16x16` пикселям финального кадра.
Coarse CoC-карта используется для классификации near/far-размытия в таком
тайле. Когда это значение становится радиусом или маской видимости всего
тайла, переходы фокуса приобретают квадратную периодичность.

Полностью перевести промежуточные текстуры на full resolution одними
SPIR-V-заменами нельзя: размеры ресурсов и dispatch создаёт движок. Это также
увеличило бы стоимость 49-tap gather примерно в четыре раза. Поэтому Native
DOF v2 оставляет нативные half-resolution слои для глубокого боке и
восстанавливает точные границы там, где они заметны.

### Изменённые проходы

| Hash | Pass | Изменение |
| --- | --- | --- |
| `0xE9907978` | Split | Рассчитывает локальный far CoC из depth и сохраняет authored native near CoC/color. |
| `0x747E19D2` | Gather | Берёт far-радиус из локального CoC и выполняет near gather с нативным CoC/радиусом. |
| `0x508514FB` | Fill | Масштабирует только far fill, сохраняя нативные near color и alpha. |
| `0xAC7A8193` | Composite | Выполняет depth/CoC-aware full-resolution far resolve, затем композитит authored near-слой по Vanilla alpha. |

Остальные нативные reduction-проходы остаются в игре. Их coarse-данные не
являются итоговым источником радиуса или видимости в Clean/Cinematic/Retinal.

### Как работает исправление

```text
Full-resolution depth
        |
        +--> local near/far CoC --> depth-aware full-resolution resolve
        |                                 |
        |                                 +--> плавные границы фокуса
        |
Native half-resolution DOF
        |
        +--> authored deep far bokeh --> Cinematic / Retinal base

Native foreground layer --> preserved at exact Vanilla strength
```

В `High` используются все 49 authoring aperture taps. Для каждого tap
выполняется до четырёх depth-aware bilinear-подвыборок, поэтому переход
размытия не восстанавливается из R8 alpha-карты. В `Balanced` используются
четыре aperture taps для меньшей нагрузки на GPU.

На границе глубины Cinematic после основного resolve проверяет полноразмерные
лучи и в каждом из восьми секторов использует только первую видимую дальнюю
поверхность с положительным Far CoC.
`Edge Bokeh Width` задаёт максимальную ширину проникновения готового far-color:
`0 px` отключает эффект, `8 px` используется по умолчанию, максимум — `16 px`.
Полноразмерные depth и Far CoC подтверждают допустимый источник фона, но не
уменьшают выбранную ширину. На крупных изогнутых силуэтах поиск отслеживает
локальный градиент глубины, чтобы плавная поверхность лица не принималась за
отдельный слой. При нативной дистанции фокуса coarse CoC служит только булевым
early-out; при изменённой дистанции он вообще не может отбрасывать пиксели.
Итоговая маска берётся по ближайшему подтверждённому фону, а не по количеству
секторов, и плавно затухает на всей выбранной ширине. Поэтому кривой силуэт не
становится слабее прямого края. Максимальная авторская сила равна `60%` при
`Background Bokeh = 100%`; существующий ползунок фонового боке масштабирует её.
Нативная R8 alpha выбирает между готовым authored far-color и ограниченным
полноразмерным depth/CoC-aware fallback, но никогда не отключает coverage. Финальную visibility
определяют исключительно полноразмерные depth и CoC. Это сохраняет мягкость
Vanilla без квадратной маски и одинаковую ширину на диагональных границах.

### Режимы

| Режим | Поведение |
| --- | --- |
| **Vanilla** | Точная референсная ветвь портов. Custom payload равен нулю, ползунки не применяются. |
| **Clean** | Full-resolution far-границы без deep far-слоя; authored foreground bokeh сохраняется с силой Vanilla. Минимум banding, более нейтральный фон. |
| **Cinematic** | Границы из Clean плюс авторское deep far-bokeh Detroit; foreground bokeh сохраняется с силой Vanilla. |
| **Retinal** | База Cinematic плюс full-resolution модель пространственной остроты зрения Watson вокруг настраиваемой точки фиксации. |

`Vanilla` — значение по умолчанию. Все четыре замены зарегистрированы всегда,
а выбор режима происходит внутри шейдеров. Это не позволяет случайно оставить
частично заменённую цепочку.

### Настройки RenoDX

Основные параметры находятся в разделе **Depth of Field**, а параметры модели
Watson — в разделе **Retinal DOF**.

| Настройка | Диапазон | Назначение |
| --- | --- | --- |
| `Depth of Field` | Vanilla / Clean / Cinematic / Retinal | Выбор архитектуры DOF. |
| `DOF Quality` | Balanced / High | Качество full-resolution aperture resolve и поддержка Retinal Gaussian. |
| `Focus Distance` | 0–200% | Масштаб авторской дистанции фокуса. |
| `Blur Radius` | 0–200% | Масштаб CoC и радиуса размытия. |
| `Background Bokeh` | 0–200% | Сила дальнего боке. |
| `Edge Bokeh Width` | 0–16 px | Полноразмерная ширина проникновения дальнего боке на ближний силуэт; depth и Far CoC проверяют источник, но не уменьшают заданную ширину. |

Значение `8 px` используется по умолчанию. В Vanilla все ползунки и настройка качества
отключены и не влияют на картинку. Во всех enhanced-режимах near/foreground
слой сохраняет нативные CoC, радиус, цвет и alpha с точной силой Vanilla;
отдельного ползунка для него нет. `Edge Bokeh Width` применяется к Cinematic и Retinal; `0 px` полностью отключает эффект.

| Настройка Retinal | Диапазон | Назначение |
| --- | --- | --- |
| `Fixation X / Y` | 0–100% | Точка фиксации в экранных координатах. |
| `Retinal Strength` | 0–100% | Сила дополнительной дисперсии модели Watson. |
| `Horizontal View Angle` | 30–120° | Физический горизонтальный угол обзора для перевода пикселей в градусы зрения. |
| `Maximum Peripheral Sigma` | 0–8 px | Верхняя граница периферического Gaussian-радиуса. |

Retinal использует separable Gaussian: соседние фиксированные веса объединены
в hardware-linear выборки. `Balanced` сохраняет поддержку `3σ`, `High` — `4σ`;
это не меняет 49-tap depth-aware aperture resolve основного High DOF. Горизонтальный
проход вычисляет обе axis sigma и передаёт вертикальную через приватный RGBA16F
scratch, после чего финальный проход восстанавливает alpha `1`. При нулевой
`Retinal Strength` или sigma дополнительный capture, barriers и оба dispatch
полностью пропускаются.

#### Пример: рекомендуемый профиль

```ini
DepthOfFieldMode=2
DepthOfFieldQuality=1
DepthOfFieldFocusDistance=100
DepthOfFieldBlurRadius=100
DepthOfFieldFarStrength=100
DepthOfFieldEdgeBokehWidth=8
```

Это `Cinematic High` с нейтральными параметрами.

#### Пример: чистый переход фокуса

```ini
DepthOfFieldMode=1
DepthOfFieldQuality=1
DepthOfFieldFocusDistance=100
DepthOfFieldBlurRadius=100
DepthOfFieldFarStrength=100
```

Это `Clean High`: full-resolution far-границы без native deep far layer, но с authored foreground bokeh Vanilla.

#### Пример: усилить размытие фона

```ini
DepthOfFieldMode=2
DepthOfFieldQuality=1
DepthOfFieldBlurRadius=125
DepthOfFieldFarStrength=130
DepthOfFieldEdgeBokehWidth=8
```

Начинайте с шагов в `5–10%`: большие значения специально допускаются, но могут
выглядеть чрезмерно в сценах с близкими силуэтами.

### Безопасность runtime

Enhanced-режим включается только после того, как в одном кадре обнаружены все
четыре обязательных прохода и подтверждён поддерживаемый executable. Первый
кадр полной цепочки всегда остаётся Vanilla. Addon возвращается к Vanilla при:

- неподдерживаемой версии игры;
- неполной цепочке шейдеров;
- пересоздании Vulkan-устройства;
- RenoDX `Preset Off`.

Размер `ShaderInjectData` сохранён равным 112 байтам. Бывшее неиспользуемое
поле `psychov_padding` переименовано в `dof_runtime_mode`; в нём компактно
упакованы режим, три процентные настройки и точная ширина Edge Bokeh `0..16 px`
в бывших битах настройки near strength `16..20`. Foreground использует фиксированную
нативную силу и не нуждается в payload; прежние edge-биты `26..29` зарезервированы
с нулевым значением. Это сохраняет исходный интерфейс ресурсов
и push payload.

### Проверка и ограничения

Проверены Debug и Release-сборки, SPIR-V reflection, workgroup `8x8`, исходные
set/binding и форматы ресурсов. RenoDX DevKit подтвердил реальные dispatch
четырёх встроенных шейдеров без loose/live-замен.

Исправление визуально подтверждено в выбранной проблемной сцене. Это не
означает численно доказанную идентичность Vanilla для каждого пикселя или
полную совместимость DOF во всех главах: Vulkan readback промежуточных ресурсов
и 120-кадровое измерение GPU-времени в этой среде не были доступны.

---

## English documentation

### Purpose

Native DOF v2 fixes visible blockiness and stepped depth-of-field transitions
in **Detroit: Become Human** without replacing the game effect with an external
ReShade shader. All four SPIR-V replacements are embedded in
`renodx-detroitbecomehuman.addon64` and run in Detroit's native Vulkan DOF
pipeline.

The goal is to preserve Detroit's authored focus parameters, aperture shape,
maximum blur radius, and deep cinematic bokeh while preventing coarse tile
classification from defining visible focus boundaries.

### Why Vanilla can look blocky

Part of the native pipeline runs at half resolution. An `8x8` DOF workgroup
corresponds to roughly `16x16` output pixels. Its coarse CoC map classifies
near/far blur per tile. When that coarse value is used as the radius or the
visibility mask for the entire tile, focus transitions can reveal a square
pattern.

Changing the intermediate resources to full resolution cannot be done with
SPIR-V replacement shaders alone: the engine owns resource allocation and
dispatch dimensions. It would also make the native 49-tap gather roughly four
times more expensive. Native DOF v2 therefore keeps the half-resolution layers
for deep bokeh while restoring accurate boundaries where they are visible.

### Replaced passes

| Hash | Pass | Change |
| --- | --- | --- |
| `0xE9907978` | Split | Computes local far CoC from depth while retaining authored native near CoC/color. |
| `0x747E19D2` | Gather | Uses local far CoC for the far radius and native CoC/radius for foreground gather. |
| `0x508514FB` | Fill | Scales only far fill while preserving native near color and alpha. |
| `0xAC7A8193` | Composite | Performs the depth/CoC-aware full-resolution far resolve, then composites authored near bokeh with Vanilla alpha. |

The game's other reduction passes remain native. Their coarse results are not
the final source of blur radius or visibility in Clean, Cinematic, or Retinal.

### How the fix works

```text
Full-resolution depth
        |
        +--> local near/far CoC --> depth-aware full-resolution resolve
        |                                 |
        |                                 +--> smooth focus boundaries
        |
Native half-resolution DOF
        |
        +--> authored deep far bokeh --> Cinematic / Retinal base

Native foreground layer --> preserved at exact Vanilla strength
```

`High` uses all 49 authored aperture taps. Each tap can use four depth-aware
bilinear subsamples, so the transition is not reconstructed from an R8 alpha
map. `Balanced` uses four aperture taps to reduce GPU cost.

After the main resolve, Cinematic walks full-resolution rays and uses only the
first visible farther surface with positive Far CoC in each of eight sectors.
`Edge Bokeh Width` sets the maximum reach of resolved far color onto the nearer
silhouette: `0 px` disables it, `8 px` is the default, and `16 px` is the maximum.
Full-resolution depth and Far CoC validate the background source without
shrinking the requested width. On large curved silhouettes, the search follows
the local depth gradient so smooth facial curvature is not mistaken for a
separate layer. At the authored
focus distance coarse CoC is only a boolean early-out; once focus distance is
adjusted, it cannot reject pixels at all. Native R8 alpha selects between the
authored far color and a bounded full-resolution depth/CoC-aware fallback, but never disables
coverage; full-resolution depth and CoC exclusively determine final visibility.
Final coverage follows the nearest validated background rather than the number
of visible sectors and fades across the entire selected width, so curved edges
are not weaker than straight ones. Authored strength tops out at `60%` when
`Background Bokeh = 100%`; the existing background control scales that value.

### Modes

| Mode | Behavior |
| --- | --- |
| **Vanilla** | Reference branch of the exact ports. The custom payload is zero and no control is applied. |
| **Clean** | Full-resolution far boundaries without the deep far layer; authored foreground bokeh remains at Vanilla strength. It minimizes banding and keeps the background more neutral. |
| **Cinematic** | Clean boundaries plus Detroit's authored deep far-bokeh and the native foreground layer at exact Vanilla strength. |
| **Retinal** | The Cinematic base plus a full-resolution Watson spatial-acuity model around a configurable fixation point. |

`Vanilla` is the default. All four replacements are always registered and the
mode is selected inside the shaders, preventing a partially replaced chain.

### RenoDX controls

Core controls are in **Depth of Field**; Watson-model controls are in
**Retinal DOF**.

| Control | Range | Purpose |
| --- | --- | --- |
| `Depth of Field` | Vanilla / Clean / Cinematic / Retinal | Selects the DOF architecture. |
| `DOF Quality` | Balanced / High | Full-resolution aperture-resolve quality and Retinal Gaussian support. |
| `Focus Distance` | 0–200% | Scales the authored focus distance. |
| `Blur Radius` | 0–200% | Scales CoC and blur radius. |
| `Background Bokeh` | 0–200% | Far-bokeh strength. |
| `Edge Bokeh Width` | 0–16 px | Full-resolution reach of farther background bokeh onto a nearer silhouette; depth and Far CoC validate the source without shrinking the requested width. |

`8 px` is the default. In Vanilla, quality and all sliders are disabled and have no
effect. Every enhanced mode preserves native near CoC, radius, color, and
alpha at exact Vanilla strength; foreground bokeh has no custom strength control.
`Edge Bokeh Width` applies to Cinematic and Retinal; `0 px` disables it exactly.

| Retinal control | Range | Purpose |
| --- | --- | --- |
| `Fixation X / Y` | 0–100% | Fixation point in screen coordinates. |
| `Retinal Strength` | 0–100% | Strength of the additional Watson-model variance. |
| `Horizontal View Angle` | 30–120° | Physical horizontal viewing angle used to convert pixels to visual degrees. |
| `Maximum Peripheral Sigma` | 0–8 px | Upper bound for the peripheral Gaussian radius. |

Retinal uses a separable Gaussian whose adjacent fixed weights are combined
into hardware-linear samples. `Balanced` retains `3σ` support and `High` retains
`4σ`; this does not change the main High DOF's 49-tap depth-aware aperture
resolve. The horizontal pass computes both axis sigmas and carries the vertical
value through private RGBA16F scratch alpha; the final pass restores alpha `1`.
At zero `Retinal Strength` or sigma, capture, barriers, and both additional
dispatches are bypassed completely.

#### Example: recommended profile

```ini
DepthOfFieldMode=2
DepthOfFieldQuality=1
DepthOfFieldFocusDistance=100
DepthOfFieldBlurRadius=100
DepthOfFieldFarStrength=100
DepthOfFieldEdgeBokehWidth=8
```

This is `Cinematic High` with neutral controls.

#### Example: clean focus transition

```ini
DepthOfFieldMode=1
DepthOfFieldQuality=1
DepthOfFieldFocusDistance=100
DepthOfFieldBlurRadius=100
DepthOfFieldFarStrength=100
```

This is `Clean High`: full-resolution far boundaries without the native deep
far layer, while authored Vanilla foreground bokeh remains enabled.

#### Example: stronger background blur

```ini
DepthOfFieldMode=2
DepthOfFieldQuality=1
DepthOfFieldBlurRadius=125
DepthOfFieldFarStrength=130
DepthOfFieldEdgeBokehWidth=8
```

Start in `5–10%` increments. Larger values are intentionally available, but
may look excessive in scenes with close silhouettes.

### Runtime safety

An enhanced mode is enabled only after all four required passes are observed in
one frame and the executable is confirmed as supported. The first complete
chain frame is always Vanilla. The addon returns to Vanilla on:

- an unsupported game build;
- an incomplete shader chain;
- Vulkan device recreation;
- RenoDX `Preset Off`.

`ShaderInjectData` remains 112 bytes. The previously unused
`psychov_padding` field was renamed to `dof_runtime_mode` and compactly packs
the mode, three percentage controls, and an exact `0..16 px` Edge Bokeh width
in the former near-strength bits `16..20`. Foreground uses fixed native strength
and needs no payload control; former Edge bits `26..29` stay reserved at zero.
The original resource interface and push payload size are
preserved.

### Validation and limits

Debug and Release builds, SPIR-V reflection, `8x8` workgroups, original
set/binding layouts, and resource formats were checked. RenoDX DevKit confirmed
the live dispatch of all four embedded shaders with no loose/live replacements.

The fix was visually confirmed in the selected problem scene. This is not a
numeric proof of per-pixel Vanilla identity or complete DOF compatibility across
every chapter: Vulkan intermediate-resource readback and a 120-frame GPU timing
measurement were unavailable in this environment.
