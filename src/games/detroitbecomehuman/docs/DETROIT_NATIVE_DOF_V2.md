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
| `0x508514FB` | Fill | В High попиксельно реконструирует coarse far CoC для hidden-background RGB; нативные near color и Gather alpha остаются неизменными. |
| `0xAC7A8193` | Composite | Восстанавливает готовые Gather/Fill RGB и coverage, ограничивает far-слой full-resolution CoC текущего пикселя и затем композитит authored near-слой по Vanilla alpha. |

Остальные нативные reduction-проходы остаются в игре. Их coarse-данные не
являются итоговым источником радиуса или видимости в Clean/Cinematic/Retinal.

### Как работает исправление

```text
Custom focus/radius --> Split --> local near/far CoC and separated color
                              |
                              v
                  authored 49-tap Gather
                              |
                 RGB + fractional coverage
                              |
                              v
             Fill extends hidden-background RGB only
                  and preserves coverage unchanged
                              |
                              v
Full-resolution color/depth --> small-CoC 3x3 bridge --> High
                              |
Authored Gather/Fill RGB+alpha --> Composite --> Clean / Cinematic / Retinal

Native foreground layer --> preserved at exact Vanilla strength
```

Оригинальный 49-tap aperture kernel остаётся в Gather во всех enhanced-режимах.
`Balanced` использует оригинальный четырёхточечный resolve готового FarDofMap.
`High` не использует reduced-resolution RGB в диапазоне малого CoC. Вместо
этого он применяет к исходному full-resolution цвету круговой 3x3 kernel из
FidelityFX DOF с custom-CoC rejection, поэтому foreground и глубокий background
не протекают друг в друга. Bridge плавно включается между `0.35` и `1.5 px`,
а authored FarDofMap перекрывается с ним по S-кривой между `1.0` и `2.5 px`.
Так смена двух разных blur-kernel не образует изолинию на волосах или коже.
Gather/Fill alpha пространственно не размывается.

Cinematic и Retinal не строят второй DOF внутри Composite. Split уже отделяет
far color по локальной depth, Gather уже вычисляет source-CoC aperture coverage,
а Fill расширяет только hidden-background RGB и сохраняет alpha неизменной.
Composite доверяет authored coverage как Vanilla для большого CoC. В High малый
CoC строится из full-resolution цвета — именно там сетка reduced-resolution RGB
заметнее всего. Пиксель с `farCoc == 0` не получает ни один far-путь. В
Split/Composite CoC текущего пикселя остаётся authoritative; в High Fill coarse
CoC используется только как вход непрерывной локальной реконструкции RGB, а не
как один switch для всей группы `8x8`. Готовый Gather/Fill слой не проходит
повторный depth rejection.

#### Почему последнее исправление находится в Fill

Debug overlay показал точное пространственное совпадение грубых стыков на
лице/волосах с `DOF Coarse CoC`. Диагностическое отключение far Fill только в
High почти полностью убрало стыки, но создало силуэтную маску. Это подтвердило
сразу две разные семантики:

- одно shared coarse-решение Fill на группу `8x8` становилось видимым RGB;
- сам Fill необходим как источник hidden-background RGB, тогда как Gather alpha
  продолжает отдельно задавать authored aperture coverage.

Split уже уточняет enhanced far CoC локально, но его shared-данные не переживают
границу dispatch и не доступны Fill. В интерфейсе Fill также нет full-resolution
depth или локальной far-CoC текстуры. Поэтому High теперь вручную билинейно
реконструирует CoC из четырёх соседних texel `dofPrepassCocMap` для каждого
DOF-пикселя, плавно включает `FilterFar` через
`smoothstep(2.0, 4.0, interpolatedFarCoc * 8.0)` и смешивает только RGB.
Итоговая alpha по-прежнему копируется непосредственно из
`dofAlphaMapFar`.

Практическое правило Detroit: если coarse-grid впервые становится видимым в
Fill, сначала реконструировать coarse decision локально в Fill. Не переносить
решение в Split и не увеличивать физически engine-owned CoC texture, пока не
доказано отсутствие данных, а не только их слишком грубое downstream-
использование.

### Режимы

| Режим | Поведение |
| --- | --- |
| **Vanilla** | Точная референсная ветвь портов. Custom payload равен нулю, ползунки не применяются. |
| **Clean** | Готовый authored far RGB композитится по точному full-resolution CoC; authored foreground bokeh сохраняется с силой Vanilla. |
| **Cinematic** | Плавно заменяет точную Clean visibility authored aperture coverage из Gather/Fill, сохраняя foreground bokeh с силой Vanilla. |
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
| `DOF Quality` | Balanced / High | Оригинальный reduced-resolution resolve или CoC-aware full-resolution 3x3 bridge для малого размытия; также управляет Retinal Gaussian. |
| `Focus Distance` | 0–200% | Масштаб авторской дистанции фокуса. |
| `Blur Radius` | 0–200% | Масштаб CoC и радиуса размытия. |
| `Background Bokeh` | 0–200% | Сила дальнего боке. |
| `Vanilla Transition Blend` | 0–100% | Доля authored Gather coverage относительно точной Clean visibility. |

Значение `100%` используется по умолчанию. В Vanilla все ползунки и настройка качества
отключены и не влияют на картинку. Во всех enhanced-режимах near/foreground
слой сохраняет нативные CoC, радиус, цвет и alpha с точной силой Vanilla;
отдельного ползунка для него нет. `Vanilla Transition Blend` применяется к Cinematic и Retinal; `0%` оставляет Clean visibility, `100%` восстанавливает authored aperture coverage.

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
DepthOfFieldVanillaTransition=100
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
DepthOfFieldVanillaTransition=100
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
упакованы режим, три процентные настройки и сила Vanilla Transition Blend `0..100%`
в бывших битах настройки near strength `16..20`. Foreground использует фиксированную
нативную силу и не нуждается в payload; прежние дополнительные edge-биты `26..29` зарезервированы
с нулевым значением. Это сохраняет исходный интерфейс ресурсов
и push payload.

### Проверка и ограничения

Текущие четыре исходника напрямую скомпилированы в SPIR-V и прошли `spirv-val`;
проверены workgroup `8x8`, исходные set/binding и форматы ресурсов. RenoDX
DevKit подтвердил их live dispatch в порядке Split → Gather → Fill → Composite
и полный pass mask `0x0F`.

В проблемной сцене live/file replacement с локальной реконструкцией High Fill
заметно ослабил coarse-стыки и был оценён как «намного лучше». После этой
проверки собраны Debug и Release target `detroitbecomehuman`, прямой DOF
contract прошёл, а Release CTest с label `detroitbecomehuman` завершился
`25/25`. Release-аддон установлен локально, но его загрузка и embedded-source
после следующего запуска игры ещё не проверены.

Одна визуально проверенная сцена не является численным доказательством
попиксельной идентичности Vanilla или полной совместимости во всех главах;
120-кадровое измерение GPU-времени также ещё не выполнено.

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
| `0x508514FB` | Fill | In High, reconstructs coarse far CoC per pixel for hidden-background RGB while preserving native near color and Gather alpha. |
| `0xAC7A8193` | Composite | Resolves the finished Gather/Fill RGB and coverage, confines the far layer with the current pixel's full-resolution CoC, then composites authored near bokeh with Vanilla alpha. |

The game's other reduction passes remain native. Their coarse results are not
the final source of blur radius or visibility in Clean, Cinematic, or Retinal.

### How the fix works

```text
Custom focus/radius --> Split --> local near/far CoC and separated color
                              |
                              v
                  authored 49-tap Gather
                              |
                 RGB + fractional coverage
                              |
                              v
             Fill extends hidden-background RGB only
                  and preserves coverage unchanged
                              |
                              v
Full-resolution color/depth --> small-CoC 3x3 bridge --> High
                              |
Authored Gather/Fill RGB+alpha --> Composite --> Clean / Cinematic / Retinal

Native foreground layer --> preserved at exact Vanilla strength
```

The original 49-tap aperture kernel remains in Gather for every enhanced mode.
`Balanced` uses the original four-point resolve of the finished FarDofMap.
`High` avoids using reduced-resolution RGB in the small-CoC interval. It applies
the FidelityFX DOF circle-coverage 3x3 kernel to Detroit's original
full-resolution color, with custom-CoC rejection so foreground and deep
background cannot leak into each other. The bridge fades in smoothly between
`0.35` and `1.5 px`, while the authored FarDofMap overlaps it through an
S-curve between `1.0` and `2.5 px`. This prevents the two different blur
kernels from forming an isocontour on hair or skin. Gather/Fill alpha is not
spatially blurred.

Cinematic and Retinal do not build a second DOF inside Composite. Split already
separates far color from local depth, Gather already computes source-CoC aperture
coverage, and Fill extends hidden-background RGB while preserving alpha.
Composite trusts authored coverage like Vanilla for large CoC. In High, small
CoC is reconstructed from full-resolution color, where the reduced-resolution
RGB grid is most visible. A pixel with zero far CoC receives neither far path.
The current-pixel CoC remains authoritative in Split/Composite; High Fill uses
coarse CoC only as the input to a continuous local RGB reconstruction, not as
one switch for the entire `8x8` group. The completed Gather/Fill layer does not
undergo a second depth rejection.

#### Why the latest fix belongs in Fill

The debug overlay showed an exact spatial match between the rough face/hair
seams and `DOF Coarse CoC`. A High-only far-Fill bypass made those seams nearly
disappear but created a silhouette matte. This proved two separate semantics:

- one shared coarse Fill decision per `8x8` group was becoming visible in RGB;
- Fill itself is required for hidden-background RGB, while Gather alpha
  independently retains authored aperture coverage.

Split already refines enhanced far CoC locally, but its shared data cannot
survive the dispatch boundary into Fill. Fill also has no full-resolution depth
or local far-CoC texture binding. High therefore bilinearly reconstructs CoC
from four neighboring `dofPrepassCocMap` texels for each DOF pixel, fades
`FilterFar` in with
`smoothstep(2.0, 4.0, interpolatedFarCoc * 8.0)`, and blends RGB only. Final
alpha is still copied directly from `dofAlphaMapFar`.

Detroit rule: when a coarse grid first becomes visible in Fill, reconstruct the
coarse decision locally in Fill. Do not move the decision into Split or
physically resize the engine-owned CoC texture until evidence proves missing
information rather than merely over-uniform downstream reuse.

### Modes

| Mode | Behavior |
| --- | --- |
| **Vanilla** | Reference branch of the exact ports. The custom payload is zero and no control is applied. |
| **Clean** | Finished authored far RGB is composited by precise full-resolution CoC; authored foreground bokeh remains at Vanilla strength. |
| **Cinematic** | Smoothly replaces precise Clean visibility with authored aperture coverage from Gather/Fill while preserving foreground bokeh at Vanilla strength. |
| **Retinal** | The Cinematic base plus a full-resolution Watson spatial-acuity model around a configurable fixation point. |

`Vanilla` is the default. All four replacements are always registered and the
mode is selected inside the shaders, preventing a partially replaced chain.

### RenoDX controls

Core controls are in **Depth of Field**; Watson-model controls are in
**Retinal DOF**.

| Control | Range | Purpose |
| --- | --- | --- |
| `Depth of Field` | Vanilla / Clean / Cinematic / Retinal | Selects the DOF architecture. |
| `DOF Quality` | Balanced / High | Original reduced-resolution resolve or a CoC-aware full-resolution 3x3 bridge for small blur; also controls Retinal Gaussian support. |
| `Focus Distance` | 0–200% | Scales the authored focus distance. |
| `Blur Radius` | 0–200% | Scales CoC and blur radius. |
| `Background Bokeh` | 0–200% | Far-bokeh strength. |
| `Vanilla Transition Blend` | 0–100% | Share of authored Gather coverage relative to precise Clean visibility. |

`100%` is the default. In Vanilla, quality and all sliders are disabled and have no
effect. Every enhanced mode preserves native near CoC, radius, color, and
alpha at exact Vanilla strength; foreground bokeh has no custom strength control.
`Vanilla Transition Blend` applies to Cinematic and Retinal; `0%` leaves Clean
visibility and `100%` restores authored aperture coverage.

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
DepthOfFieldVanillaTransition=100
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
DepthOfFieldVanillaTransition=100
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
the mode, three percentage controls, and `0..100%` Vanilla Transition Blend
in the former near-strength bits `16..20`. Foreground uses fixed native strength
and needs no payload control; former extra Edge bits `26..29` stay reserved at zero.
The original resource interface and push payload size are
preserved.

### Validation and limits

All four current sources were compiled directly to SPIR-V and passed
`spirv-val`; their `8x8` workgroups, original set/binding layouts, and resource
formats were checked. RenoDX DevKit confirmed live dispatch in Split → Gather →
Fill → Composite order with the complete `0x0F` pass mask.

In the problem scene, the live/file replacement with local High-Fill
reconstruction substantially reduced the coarse seams and was judged “much
better.” The `detroitbecomehuman` Debug and Release targets were then built,
the direct DOF contract passed, and the Release CTest set labeled
`detroitbecomehuman` passed `25/25`. The Release addon was installed locally,
but its next-start load and embedded source have not yet been verified.

One visually checked scene is not numeric proof of per-pixel Vanilla identity
or complete compatibility across every chapter; a 120-frame GPU timing
measurement also remains outstanding.
