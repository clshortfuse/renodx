# HLSL decompiling

* `x + 4294967295u`        = `x - 1u`
* `mad(a, b, c)`           = `(a * b) + c`
  
* `exp2(log2(abs(x)) * y)` = `pow(x, y)`
* `exp2(log2(x) * y)`      = `pow(x, y)`
* `exp2(y * log2(x))`      = `pow(x, y)`

* `((b-a) * t) + a`        = `lerp(a, b, t)`
* `(t * (b-a)) + a`        = `lerp(a, b, t)`
* `(1-t)*a + t*b`          = `lerp(a, b, t)`
* `b*t + (a*(1-t))`        = `lerp(a, b, t)`
* `mad((b-a), t, a)`       = `lerp(a, b, t)`
* `mad(t, (b-a), a)`       = `lerp(a, b, t)`

* `log2(x)`                = `log10(x)/log10(2)`
* `log2(x*y)`              = `log2(x) + log2(y)`
* `log2(x) * y`            = `log10(x) * (z*log10(2))`

* `log10(x)`               = `log2(x) * log10(2)`
* `log10(x)`               = `log(x) / log(10)` 

* `exp2(x)`                = `log10(x) * (z*log10(2))`

* `0.416666657`            = `1 / 2.4`