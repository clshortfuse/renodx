Core-transparent bloom/flare shader set

All seven shaders retain the earlier original-size / transparent-halo changes.

Default core density/alpha cap: 0.70
Halo density/alpha remains at the prior ~0.30-0.35 values.

The two particle shaders 0x1832D7DB and 0x039025BC preserve their RGB path and reduce core alpha separately.
The bloom/additive shaders have no independent opacity channel, so their hot-core bloom contribution is capped to 70% density instead.
