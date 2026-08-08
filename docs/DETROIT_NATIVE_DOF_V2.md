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
| `0xE9907978` | Split | Рассчитывает локальный near/far CoC из depth для улучшенных режимов. |
| `0x747E19D2` | Gather | Берёт радиус и маски из локального CoC, а не из coarse-тайла. |
| `0x508514FB` | Fill | Сохраняет нативный порог fill, но учитывает масштаб радиуса. |
| `0xAC7A8193` | Composite | Выполняет depth/CoC-aware full-resolution resolve и соединяет художественные слои. |

Остальные нативные reduction-проходы остаются в игре. Их coarse-данные не
являются итоговым источником радиуса или видимости в Clean/Cinematic.

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
        +--> authored deep far bokeh / foreground bokeh
                                            |
                                            +--> Cinematic composite
```

В `High` используются все 49 authoring aperture taps. Для каждого tap
выполняется до четырёх depth-aware bilinear-подвыборок, поэтому переход
размытия не восстанавливается из R8 alpha-карты. В `Balanced` используются
четыре aperture taps для меньшей нагрузки на GPU.

На границе глубины Cinematic измеряет поддержку локальных far-выборок и,
когда она недостаточна, расширяет full-resolution resolve. Нативный far-color
используется только как художественный цвет глубокого боке; его R8 alpha не
используется как финальная visibility-mask. Это предотвращает жёсткую маску
вокруг персонажа.

### Режимы

| Режим | Поведение |
| --- | --- |
| **Vanilla** | Точная референсная ветвь портов. Custom payload равен нулю, ползунки не применяются. |
| **Clean** | Full-resolution границы и far resolve без low-resolution художественных near/deep слоёв. Минимум banding, более нейтральный вид. |
| **Cinematic** | Границы из Clean плюс авторские deep far-bokeh и foreground-bokeh Detroit. Рекомендуемый художественный режим. |

`Vanilla` — значение по умолчанию. Все четыре замены зарегистрированы всегда,
а выбор режима происходит внутри шейдеров. Это не позволяет случайно оставить
частично заменённую цепочку.

### Настройки RenoDX

Все параметры находятся в разделе **Depth of Field**.

| Настройка | Диапазон | Назначение |
| --- | --- | --- |
| `Depth of Field` | Vanilla / Clean / Cinematic | Выбор архитектуры DOF. |
| `DOF Quality` | Balanced / High | Число выборок full-resolution resolve. |
| `Focus Distance` | 0–200% | Масштаб авторской дистанции фокуса. |
| `Blur Radius` | 0–200% | Масштаб CoC и радиуса размытия. |
| `Foreground Bokeh` | 0–200% | Сила near-слоя в Cinematic. |
| `Background Bokeh` | 0–200% | Сила дальнего боке. |
| `Edge Bokeh` | 0–200% | Расширение resolve на границах глубины в Cinematic. |

Значение `100%` нейтрально. В Vanilla все ползунки и настройка качества
отключены и не влияют на картинку. `Foreground Bokeh` и `Edge Bokeh` доступны
только для Cinematic, поскольку Clean не использует эти художественные слои.

#### Пример: рекомендуемый профиль

```ini
DepthOfFieldMode=2
DepthOfFieldQuality=1
DepthOfFieldFocusDistance=100
DepthOfFieldBlurRadius=100
DepthOfFieldNearStrength=100
DepthOfFieldFarStrength=100
DepthOfFieldEdgeBokeh=100
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

Это `Clean High`: full-resolution границы без native foreground/deep layers.

#### Пример: усилить размытие фона

```ini
DepthOfFieldMode=2
DepthOfFieldQuality=1
DepthOfFieldBlurRadius=125
DepthOfFieldFarStrength=130
DepthOfFieldNearStrength=100
DepthOfFieldEdgeBokeh=100
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
упакованы режим и пять процентных настроек. Это сохраняет исходный интерфейс
ресурсов и push payload.

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
| `0xE9907978` | Split | Computes local near/far CoC from depth in enhanced modes. |
| `0x747E19D2` | Gather | Uses local CoC radii and masks instead of the coarse tile value. |
| `0x508514FB` | Fill | Keeps the authored fill threshold while honoring the blur-radius scale. |
| `0xAC7A8193` | Composite | Performs a depth/CoC-aware full-resolution resolve and combines artistic layers. |

The game's other reduction passes remain native. Their coarse results are not
the final source of blur radius or visibility in Clean and Cinematic.

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
        +--> authored deep far bokeh / foreground bokeh
                                            |
                                            +--> Cinematic composite
```

`High` uses all 49 authored aperture taps. Each tap can use four depth-aware
bilinear subsamples, so the transition is not reconstructed from an R8 alpha
map. `Balanced` uses four aperture taps to reduce GPU cost.

At a depth discontinuity, Cinematic measures local far-sample support and
expands the full-resolution resolve when support is insufficient. Native
far-layer color is used only as authored deep-bokeh color; its R8 alpha is
never used as the final visibility mask. This avoids a hard character outline.

### Modes

| Mode | Behavior |
| --- | --- |
| **Vanilla** | Reference branch of the exact ports. The custom payload is zero and no control is applied. |
| **Clean** | Full-resolution boundaries and far resolve, without low-resolution artistic near/deep layers. It minimizes banding and has a more neutral look. |
| **Cinematic** | Clean boundaries plus Detroit's authored deep far-bokeh and foreground-bokeh. Recommended artistic mode. |

`Vanilla` is the default. All four replacements are always registered and the
mode is selected inside the shaders, preventing a partially replaced chain.

### RenoDX controls

All controls are in the **Depth of Field** section.

| Control | Range | Purpose |
| --- | --- | --- |
| `Depth of Field` | Vanilla / Clean / Cinematic | Selects the DOF architecture. |
| `DOF Quality` | Balanced / High | Number of full-resolution resolve samples. |
| `Focus Distance` | 0–200% | Scales the authored focus distance. |
| `Blur Radius` | 0–200% | Scales CoC and blur radius. |
| `Foreground Bokeh` | 0–200% | Near-layer strength in Cinematic. |
| `Background Bokeh` | 0–200% | Far-bokeh strength. |
| `Edge Bokeh` | 0–200% | Resolve expansion at depth boundaries in Cinematic. |

`100%` is neutral. In Vanilla, quality and all sliders are disabled and have no
effect. `Foreground Bokeh` and `Edge Bokeh` are Cinematic-only because Clean
does not use those artistic layers.

#### Example: recommended profile

```ini
DepthOfFieldMode=2
DepthOfFieldQuality=1
DepthOfFieldFocusDistance=100
DepthOfFieldBlurRadius=100
DepthOfFieldNearStrength=100
DepthOfFieldFarStrength=100
DepthOfFieldEdgeBokeh=100
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

This is `Clean High`: full-resolution boundaries without the native
foreground/deep layers.

#### Example: stronger background blur

```ini
DepthOfFieldMode=2
DepthOfFieldQuality=1
DepthOfFieldBlurRadius=125
DepthOfFieldFarStrength=130
DepthOfFieldNearStrength=100
DepthOfFieldEdgeBokeh=100
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
the mode plus five percentage controls. The original resource interface and
push payload size are preserved.

### Validation and limits

Debug and Release builds, SPIR-V reflection, `8x8` workgroups, original
set/binding layouts, and resource formats were checked. RenoDX DevKit confirmed
the live dispatch of all four embedded shaders with no loose/live replacements.

The fix was visually confirmed in the selected problem scene. This is not a
numeric proof of per-pixel Vanilla identity or complete DOF compatibility across
every chapter: Vulkan intermediate-resource readback and a 120-frame GPU timing
measurement were unavailable in this environment.
