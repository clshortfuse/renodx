#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t4 : register(t4);

Texture3D<float4> t5 : register(t5);

Texture3D<float4> t6 : register(t6);

cbuffer cb0 : register(b0) {
  float cb0_037y : packoffset(c037.y);
  float cb0_037z : packoffset(c037.z);
  float cb0_037w : packoffset(c037.w);
  float cb0_038x : packoffset(c038.x);
  float cb0_038y : packoffset(c038.y);
  float cb0_038z : packoffset(c038.z);
  float cb0_048x : packoffset(c048.x);
  float cb0_048y : packoffset(c048.y);
  float cb0_048z : packoffset(c048.z);
  float cb0_048w : packoffset(c048.w);
  float cb0_049x : packoffset(c049.x);
  float cb0_049y : packoffset(c049.y);
  float cb0_060z : packoffset(c060.z);
  float cb0_060w : packoffset(c060.w);
  float cb0_061x : packoffset(c061.x);
  float cb0_061y : packoffset(c061.y);
  float cb0_068z : packoffset(c068.z);
  float cb0_068w : packoffset(c068.w);
  float cb0_069x : packoffset(c069.x);
  float cb0_069y : packoffset(c069.y);
  float cb0_075z : packoffset(c075.z);
  float cb0_075w : packoffset(c075.w);
  float cb0_076x : packoffset(c076.x);
  float cb0_076y : packoffset(c076.y);
  float cb0_076z : packoffset(c076.z);
  float cb0_076w : packoffset(c076.w);
  float cb0_077x : packoffset(c077.x);
  float cb0_077y : packoffset(c077.y);
  uint cb0_077z : packoffset(c077.z);
  float cb0_078x : packoffset(c078.x);
  float cb0_078y : packoffset(c078.y);
  float cb0_078z : packoffset(c078.z);
  float cb0_080x : packoffset(c080.x);
  float cb0_080z : packoffset(c080.z);
  float cb0_080w : packoffset(c080.w);
  float cb0_081x : packoffset(c081.x);
  float cb0_081y : packoffset(c081.y);
  float cb0_081z : packoffset(c081.z);
  float cb0_081w : packoffset(c081.w);
  float cb0_082x : packoffset(c082.x);
  float cb0_082y : packoffset(c082.y);
  float cb0_082z : packoffset(c082.z);
  float cb0_083x : packoffset(c083.x);
  float cb0_083z : packoffset(c083.z);
  float cb0_083w : packoffset(c083.w);
  float cb0_084x : packoffset(c084.x);
  float cb0_084y : packoffset(c084.y);
  float cb0_084z : packoffset(c084.z);
  float cb0_084w : packoffset(c084.w);
  float cb0_085x : packoffset(c085.x);
  float cb0_085y : packoffset(c085.y);
  float cb0_085z : packoffset(c085.z);
  float cb0_088x : packoffset(c088.x);
  uint cb0_097w : packoffset(c097.w);
  float cb0_098x : packoffset(c098.x);
  float cb0_098z : packoffset(c098.z);
  uint cb0_098w : packoffset(c098.w);
  uint cb0_099x : packoffset(c099.x);
  uint cb0_099y : packoffset(c099.y);
  uint cb0_099z : packoffset(c099.z);
  uint cb0_099w : packoffset(c099.w);
  float cb0_105x : packoffset(c105.x);
  float cb0_105y : packoffset(c105.y);
  float cb0_105z : packoffset(c105.z);
  float cb0_105w : packoffset(c105.w);
  float cb0_106x : packoffset(c106.x);
  float cb0_106y : packoffset(c106.y);
  float cb0_106z : packoffset(c106.z);
  float cb0_106w : packoffset(c106.w);
  float cb0_108x : packoffset(c108.x);
  float cb0_108y : packoffset(c108.y);
  float cb0_108z : packoffset(c108.z);
  float cb0_109x : packoffset(c109.x);
  float cb0_109y : packoffset(c109.y);
  float cb0_109z : packoffset(c109.z);
  float cb0_109w : packoffset(c109.w);
};

cbuffer cb1 : register(b1) {
  float4 View_000[4] : packoffset(c000.x);
  float4 View_064[4] : packoffset(c004.x);
  float4 View_128[4] : packoffset(c008.x);
  float4 View_192[4] : packoffset(c012.x);
  float4 View_256[4] : packoffset(c016.x);
  float4 View_320[4] : packoffset(c020.x);
  float4 View_384[4] : packoffset(c024.x);
  float4 View_448[4] : packoffset(c028.x);
  float4 View_512[4] : packoffset(c032.x);
  float4 View_576[4] : packoffset(c036.x);
  float4 View_640[4] : packoffset(c040.x);
  float4 View_704[4] : packoffset(c044.x);
  float4 View_768[4] : packoffset(c048.x);
  float4 View_832[4] : packoffset(c052.x);
  float4 View_896[4] : packoffset(c056.x);
  float3 View_960 : packoffset(c060.x);
  float View_972 : packoffset(c060.w);
  float3 View_976 : packoffset(c061.x);
  float View_988 : packoffset(c061.w);
  float3 View_992 : packoffset(c062.x);
  float View_1004 : packoffset(c062.w);
  float3 View_1008 : packoffset(c063.x);
  float View_1020 : packoffset(c063.w);
  float3 View_1024 : packoffset(c064.x);
  float View_1036 : packoffset(c064.w);
  float4 View_1040 : packoffset(c065.x);
  float4 View_1056 : packoffset(c066.x);
  float3 View_1072 : packoffset(c067.x);
  float View_1084 : packoffset(c067.w);
  float3 View_1088 : packoffset(c068.x);
  float View_1100 : packoffset(c068.w);
  float3 View_1104 : packoffset(c069.x);
  float View_1116 : packoffset(c069.w);
  float3 View_1120 : packoffset(c070.x);
  float View_1132 : packoffset(c070.w);
  float4 View_1136[4] : packoffset(c071.x);
  float4 View_1200[4] : packoffset(c075.x);
  float4 View_1264[4] : packoffset(c079.x);
  float4 View_1328[4] : packoffset(c083.x);
  float4 View_1392[4] : packoffset(c087.x);
  float4 View_1456[4] : packoffset(c091.x);
  float4 View_1520[4] : packoffset(c095.x);
  float4 View_1584[4] : packoffset(c099.x);
  float4 View_1648[4] : packoffset(c103.x);
  float4 View_1712[4] : packoffset(c107.x);
  float4 View_1776[4] : packoffset(c111.x);
  float3 View_1840 : packoffset(c115.x);
  float View_1852 : packoffset(c115.w);
  float3 View_1856 : packoffset(c116.x);
  float View_1868 : packoffset(c116.w);
  float3 View_1872 : packoffset(c117.x);
  float View_1884 : packoffset(c117.w);
  float4 View_1888[4] : packoffset(c118.x);
  float4 View_1952[4] : packoffset(c122.x);
  float4 View_2016 : packoffset(c126.x);
  float4 View_2032[4] : packoffset(c127.x);
  float4 View_2096 : packoffset(c131.x);
  float4 View_2112 : packoffset(c132.x);
  float2 View_2128 : packoffset(c133.x);
  float2 View_2136 : packoffset(c133.z);
  float4 View_2144 : packoffset(c134.x);
  float4 View_2160 : packoffset(c135.x);
  int4 View_2176 : packoffset(c136.x);
  float4 View_2192 : packoffset(c137.x);
  float4 View_2208 : packoffset(c138.x);
  float4 View_2224 : packoffset(c139.x);
  float4 View_2240 : packoffset(c140.x);
  int View_2256 : packoffset(c141.x);
  float View_2260 : packoffset(c141.y);
  float View_2264 : packoffset(c141.z);
  float View_2268 : packoffset(c141.w);
  float4 View_2272 : packoffset(c142.x);
  float4 View_2288 : packoffset(c143.x);
  float4 View_2304 : packoffset(c144.x);
  float2 View_2320 : packoffset(c145.x);
  float View_2328 : packoffset(c145.z);
  float View_2332 : packoffset(c145.w);
  float View_2336 : packoffset(c146.x);
  float View_2340 : packoffset(c146.y);
  float View_2344 : packoffset(c146.z);
  float View_2348 : packoffset(c146.w);
  float3 View_2352 : packoffset(c147.x);
  float View_2364 : packoffset(c147.w);
  float View_2368 : packoffset(c148.x);
  float View_2372 : packoffset(c148.y);
  float View_2376 : packoffset(c148.z);
  float View_2380 : packoffset(c148.w);
  float View_2384 : packoffset(c149.x);
  float View_2388 : packoffset(c149.y);
  float View_2392 : packoffset(c149.z);
  int View_2396 : packoffset(c149.w);
  int View_2400 : packoffset(c150.x);
  int View_2404 : packoffset(c150.y);
  int View_2408 : packoffset(c150.z);
  int View_2412 : packoffset(c150.w);
  float View_2416 : packoffset(c151.x);
  float View_2420 : packoffset(c151.y);
  float View_2424 : packoffset(c151.z);
  float View_2428 : packoffset(c151.w);
  float4 View_2432 : packoffset(c152.x);
  float3 View_2448 : packoffset(c153.x);
  float View_2460 : packoffset(c153.w);
  float4 View_2464[2] : packoffset(c154.x);
  float4 View_2496[2] : packoffset(c156.x);
  float4 View_2528 : packoffset(c158.x);
  float4 View_2544 : packoffset(c159.x);
  int View_2560 : packoffset(c160.x);
  float View_2564 : packoffset(c160.y);
  float View_2568 : packoffset(c160.z);
  float View_2572 : packoffset(c160.w);
  float View_2576 : packoffset(c161.x);
  float View_2580 : packoffset(c161.y);
  float View_2584 : packoffset(c161.z);
  float View_2588 : packoffset(c161.w);
  float View_2592 : packoffset(c162.x);
  float View_2596 : packoffset(c162.y);
  float View_2600 : packoffset(c162.z);
  float View_2604 : packoffset(c162.w);
  float3 View_2608 : packoffset(c163.x);
  float View_2620 : packoffset(c163.w);
  float View_2624 : packoffset(c164.x);
  float View_2628 : packoffset(c164.y);
  float View_2632 : packoffset(c164.z);
  float View_2636 : packoffset(c164.w);
  float View_2640 : packoffset(c165.x);
  float View_2644 : packoffset(c165.y);
  float View_2648 : packoffset(c165.z);
  float View_2652 : packoffset(c165.w);
  float View_2656 : packoffset(c166.x);
  float View_2660 : packoffset(c166.y);
  float View_2664 : packoffset(c166.z);
  float View_2668 : packoffset(c166.w);
  float4 View_2672[2] : packoffset(c167.x);
  float4 View_2704[2] : packoffset(c169.x);
  float4 View_2736[2] : packoffset(c171.x);
  float4 View_2768[2] : packoffset(c173.x);
  float4 View_2800[2] : packoffset(c175.x);
  float4 View_2832 : packoffset(c177.x);
  float3 View_2848 : packoffset(c178.x);
  float View_2860 : packoffset(c178.w);
  float4 View_2864 : packoffset(c179.x);
  float4 View_2880[4] : packoffset(c180.x);
  float4 View_2944 : packoffset(c184.x);
  float View_2960 : packoffset(c185.x);
  float View_2964 : packoffset(c185.y);
  float View_2968 : packoffset(c185.z);
  float View_2972 : packoffset(c185.w);
  float4 View_2976 : packoffset(c186.x);
  float View_2992 : packoffset(c187.x);
  float View_2996 : packoffset(c187.y);
  float View_3000 : packoffset(c187.z);
  float View_3004 : packoffset(c187.w);
  float View_3008 : packoffset(c188.x);
  float View_3012 : packoffset(c188.y);
  int View_3016 : packoffset(c188.z);
  int View_3020 : packoffset(c188.w);
  float3 View_3024 : packoffset(c189.x);
  float View_3036 : packoffset(c189.w);
  float View_3040 : packoffset(c190.x);
  float View_3044 : packoffset(c190.y);
  float View_3048 : packoffset(c190.z);
  float View_3052 : packoffset(c190.w);
  float4 View_3056 : packoffset(c191.x);
  float View_3072 : packoffset(c192.x);
  float View_3076 : packoffset(c192.y);
  float View_3080 : packoffset(c192.z);
  float View_3084 : packoffset(c192.w);
  float4 View_3088 : packoffset(c193.x);
  float View_3104 : packoffset(c194.x);
  float View_3108 : packoffset(c194.y);
  float View_3112 : packoffset(c194.z);
  float View_3116 : packoffset(c194.w);
  float4 View_3120 : packoffset(c195.x);
  float4 View_3136 : packoffset(c196.x);
  float4 View_3152 : packoffset(c197.x);
  float View_3168 : packoffset(c198.x);
  float View_3172 : packoffset(c198.y);
  float View_3176 : packoffset(c198.z);
  float View_3180 : packoffset(c198.w);
  float View_3184 : packoffset(c199.x);
  float View_3188 : packoffset(c199.y);
  float View_3192 : packoffset(c199.z);
  float View_3196 : packoffset(c199.w);
  float4 View_3200 : packoffset(c200.x);
  float4 View_3216[7] : packoffset(c201.x);
  float View_3328 : packoffset(c208.x);
  float View_3332 : packoffset(c208.y);
  float View_3336 : packoffset(c208.z);
  float View_3340 : packoffset(c208.w);
  int View_3344 : packoffset(c209.x);
  float View_3348 : packoffset(c209.y);
  float View_3352 : packoffset(c209.z);
  float View_3356 : packoffset(c209.w);
  float3 View_3360 : packoffset(c210.x);
  int View_3372 : packoffset(c210.w);
  float4 View_3376[6] : packoffset(c211.x);
  float4 View_3472[6] : packoffset(c217.x);
  float4 View_3568[6] : packoffset(c223.x);
  float4 View_3664[6] : packoffset(c229.x);
  float View_3760 : packoffset(c235.x);
  float View_3764 : packoffset(c235.y);
  int View_3768 : packoffset(c235.z);
  float View_3772 : packoffset(c235.w);
  float3 View_3776 : packoffset(c236.x);
  float View_3788 : packoffset(c236.w);
  float3 View_3792 : packoffset(c237.x);
  float View_3804 : packoffset(c237.w);
  float View_3808 : packoffset(c238.x);
  float View_3812 : packoffset(c238.y);
  int View_3816 : packoffset(c238.z);
  float View_3820 : packoffset(c238.w);
  float View_3824 : packoffset(c239.x);
  float View_3828 : packoffset(c239.y);
  float View_3832 : packoffset(c239.z);
  float View_3836 : packoffset(c239.w);
  int2 View_3840 : packoffset(c240.x);
  float View_3848 : packoffset(c240.z);
  float View_3852 : packoffset(c240.w);
  float3 View_3856 : packoffset(c241.x);
  float View_3868 : packoffset(c241.w);
  float3 View_3872 : packoffset(c242.x);
  float View_3884 : packoffset(c242.w);
  float2 View_3888 : packoffset(c243.x);
  float2 View_3896 : packoffset(c243.z);
  float2 View_3904 : packoffset(c244.x);
  float2 View_3912 : packoffset(c244.z);
  float2 View_3920 : packoffset(c245.x);
  float View_3928 : packoffset(c245.z);
  float View_3932 : packoffset(c245.w);
  float3 View_3936 : packoffset(c246.x);
  float View_3948 : packoffset(c246.w);
  float2 View_3952 : packoffset(c247.x);
  float2 View_3960 : packoffset(c247.z);
  float View_3968 : packoffset(c248.x);
  float View_3972 : packoffset(c248.y);
  float View_3976 : packoffset(c248.z);
  float View_3980 : packoffset(c248.w);
  float3 View_3984 : packoffset(c249.x);
  float View_3996 : packoffset(c249.w);
  float3 View_4000 : packoffset(c250.x);
  float View_4012 : packoffset(c250.w);
  float3 View_4016 : packoffset(c251.x);
  float View_4028 : packoffset(c251.w);
  float3 View_4032 : packoffset(c252.x);
  float View_4044 : packoffset(c252.w);
  float View_4048 : packoffset(c253.x);
  float View_4052 : packoffset(c253.y);
  float View_4056 : packoffset(c253.z);
  float View_4060 : packoffset(c253.w);
  float4 View_4064[4] : packoffset(c254.x);
  float4 View_4128[2] : packoffset(c258.x);
  int View_4160 : packoffset(c260.x);
  float View_4164 : packoffset(c260.y);
  float View_4168 : packoffset(c260.z);
  float View_4172 : packoffset(c260.w);
  float4 View_4176 : packoffset(c261.x);
  float2 View_4192 : packoffset(c262.x);
  float View_4200 : packoffset(c262.z);
  float View_4204 : packoffset(c262.w);
  float4 View_4208 : packoffset(c263.x);
  int View_4224 : packoffset(c264.x);
  float View_4228 : packoffset(c264.y);
  float View_4232 : packoffset(c264.z);
  float View_4236 : packoffset(c264.w);
  float4 View_4240 : packoffset(c265.x);
  int View_4256 : packoffset(c266.x);
  int View_4260 : packoffset(c266.y);
  int View_4264 : packoffset(c266.z);
  float View_4268 : packoffset(c266.w);
  float View_4272 : packoffset(c267.x);
  float View_4276 : packoffset(c267.y);
  float View_4280 : packoffset(c267.z);
  float View_4284 : packoffset(c267.w);
  float4 View_4288 : packoffset(c268.x);
  float4 View_4304 : packoffset(c269.x);
  float4 View_4320 : packoffset(c270.x);
  float4 View_4336 : packoffset(c271.x);
  float4 View_4352 : packoffset(c272.x);
  float4 View_4368 : packoffset(c273.x);
  int View_4384 : packoffset(c274.x);
  float View_4388 : packoffset(c274.y);
  float View_4392 : packoffset(c274.z);
  float View_4396 : packoffset(c274.w);
  float4 View_4400 : packoffset(c275.x);
  float4 View_4416 : packoffset(c276.x);
  float View_4432 : packoffset(c277.x);
  float View_4436 : packoffset(c277.y);
  float View_4440 : packoffset(c277.z);
  float View_4444 : packoffset(c277.w);
  int View_4448 : packoffset(c278.x);
  float View_4452 : packoffset(c278.y);
  float View_4456 : packoffset(c278.z);
  float View_4460 : packoffset(c278.w);
  float View_4464 : packoffset(c279.x);
  float View_4468 : packoffset(c279.y);
  float View_4472 : packoffset(c279.z);
  float View_4476 : packoffset(c279.w);
  float4 View_4480 : packoffset(c280.x);
  int View_4496 : packoffset(c281.x);
  int View_4500 : packoffset(c281.y);
  int View_4504 : packoffset(c281.z);
  float View_4508 : packoffset(c281.w);
  float4 View_4512 : packoffset(c282.x);
  float4 View_4528 : packoffset(c283.x);
  float4 View_4544 : packoffset(c284.x);
  float4 View_4560 : packoffset(c285.x);
  float View_4576 : packoffset(c286.x);
  float View_4580 : packoffset(c286.y);
  float View_4584 : packoffset(c286.z);
  float View_4588 : packoffset(c286.w);
  float4 View_4592 : packoffset(c287.x);
  float4 View_4608 : packoffset(c288.x);
  float4 View_4624 : packoffset(c289.x);
  float4 View_4640 : packoffset(c290.x);
  float4 View_4656 : packoffset(c291.x);
  float View_4672 : packoffset(c292.x);
  float View_4676 : packoffset(c292.y);
  float View_4680 : packoffset(c292.z);
  float View_4684 : packoffset(c292.w);
  float4 View_4688 : packoffset(c293.x);
  float4 View_4704 : packoffset(c294.x);
  float View_4720 : packoffset(c295.x);
  float View_4724 : packoffset(c295.y);
  float View_4728 : packoffset(c295.z);
  float View_4732 : packoffset(c295.w);
  float4 View_4736 : packoffset(c296.x);
  float4 View_4752 : packoffset(c297.x);
  float View_4768 : packoffset(c298.x);
  float View_4772 : packoffset(c298.y);
  float View_4776 : packoffset(c298.z);
  float View_4780 : packoffset(c298.w);
  float View_4784 : packoffset(c299.x);
  float View_4788 : packoffset(c299.y);
  float View_4792 : packoffset(c299.z);
  float View_4796 : packoffset(c299.w);
  float View_4800 : packoffset(c300.x);
  float View_4804 : packoffset(c300.y);
  float View_4808 : packoffset(c300.z);
  float View_4812 : packoffset(c300.w);
  float View_4816 : packoffset(c301.x);
  float View_4820 : packoffset(c301.y);
  float View_4824 : packoffset(c301.z);
  float View_4828 : packoffset(c301.w);
  float View_4832 : packoffset(c302.x);
  float View_4836 : packoffset(c302.y);
  float View_4840 : packoffset(c302.z);
  float View_4844 : packoffset(c302.w);
  float View_4848 : packoffset(c303.x);
  float View_4852 : packoffset(c303.y);
  float View_4856 : packoffset(c303.z);
  float View_4860 : packoffset(c303.w);
  float View_4864 : packoffset(c304.x);
  float View_4868 : packoffset(c304.y);
  float View_4872 : packoffset(c304.z);
  float View_4876 : packoffset(c304.w);
  float View_4880 : packoffset(c305.x);
  float View_4884 : packoffset(c305.y);
  float View_4888 : packoffset(c305.z);
  float View_4892 : packoffset(c305.w);
  float View_4896 : packoffset(c306.x);
  float View_4900 : packoffset(c306.y);
  float View_4904 : packoffset(c306.z);
  float View_4908 : packoffset(c306.w);
  float View_4912 : packoffset(c307.x);
  float View_4916 : packoffset(c307.y);
  float View_4920 : packoffset(c307.z);
  float View_4924 : packoffset(c307.w);
  float View_4928 : packoffset(c308.x);
  float View_4932 : packoffset(c308.y);
  float View_4936 : packoffset(c308.z);
  float View_4940 : packoffset(c308.w);
  float View_4944 : packoffset(c309.x);
  float View_4948 : packoffset(c309.y);
  float View_4952 : packoffset(c309.z);
  float View_4956 : packoffset(c309.w);
  float View_4960 : packoffset(c310.x);
  float View_4964 : packoffset(c310.y);
  float View_4968 : packoffset(c310.z);
  float View_4972 : packoffset(c310.w);
  float View_4976 : packoffset(c311.x);
  float View_4980 : packoffset(c311.y);
  float View_4984 : packoffset(c311.z);
  float View_4988 : packoffset(c311.w);
  float View_4992 : packoffset(c312.x);
  float View_4996 : packoffset(c312.y);
  float View_5000 : packoffset(c312.z);
  float View_5004 : packoffset(c312.w);
  float View_5008 : packoffset(c313.x);
  float View_5012 : packoffset(c313.y);
  float View_5016 : packoffset(c313.z);
  float View_5020 : packoffset(c313.w);
  float View_5024 : packoffset(c314.x);
  float View_5028 : packoffset(c314.y);
  float View_5032 : packoffset(c314.z);
  float View_5036 : packoffset(c314.w);
  float View_5040 : packoffset(c315.x);
  float View_5044 : packoffset(c315.y);
  float View_5048 : packoffset(c315.z);
  float View_5052 : packoffset(c315.w);
  float View_5056 : packoffset(c316.x);
  float View_5060 : packoffset(c316.y);
  float View_5064 : packoffset(c316.z);
  float View_5068 : packoffset(c316.w);
  float View_5072 : packoffset(c317.x);
  float View_5076 : packoffset(c317.y);
  float View_5080 : packoffset(c317.z);
  float View_5084 : packoffset(c317.w);
  float View_5088 : packoffset(c318.x);
  float View_5092 : packoffset(c318.y);
  float View_5096 : packoffset(c318.z);
  float View_5100 : packoffset(c318.w);
  float View_5104 : packoffset(c319.x);
  float View_5108 : packoffset(c319.y);
  float View_5112 : packoffset(c319.z);
  float View_5116 : packoffset(c319.w);
  float View_5120 : packoffset(c320.x);
  float View_5124 : packoffset(c320.y);
  float View_5128 : packoffset(c320.z);
  float View_5132 : packoffset(c320.w);
  float View_5136 : packoffset(c321.x);
  float View_5140 : packoffset(c321.y);
  float View_5144 : packoffset(c321.z);
  float View_5148 : packoffset(c321.w);
  float View_5152 : packoffset(c322.x);
  float View_5156 : packoffset(c322.y);
  float View_5160 : packoffset(c322.z);
  float View_5164 : packoffset(c322.w);
  float View_5168 : packoffset(c323.x);
  float View_5172 : packoffset(c323.y);
  float View_5176 : packoffset(c323.z);
  float View_5180 : packoffset(c323.w);
  float View_5184 : packoffset(c324.x);
  float View_5188 : packoffset(c324.y);
  float View_5192 : packoffset(c324.z);
  float View_5196 : packoffset(c324.w);
  float View_5200 : packoffset(c325.x);
  float View_5204 : packoffset(c325.y);
  float View_5208 : packoffset(c325.z);
  float View_5212 : packoffset(c325.w);
  float View_5216 : packoffset(c326.x);
  float View_5220 : packoffset(c326.y);
  float View_5224 : packoffset(c326.z);
  float View_5228 : packoffset(c326.w);
  float View_5232 : packoffset(c327.x);
  float View_5236 : packoffset(c327.y);
  float View_5240 : packoffset(c327.z);
  float View_5244 : packoffset(c327.w);
  float View_5248 : packoffset(c328.x);
  float View_5252 : packoffset(c328.y);
  float View_5256 : packoffset(c328.z);
  float View_5260 : packoffset(c328.w);
  float View_5264 : packoffset(c329.x);
  float View_5268 : packoffset(c329.y);
  float View_5272 : packoffset(c329.z);
  float View_5276 : packoffset(c329.w);
  float View_5280 : packoffset(c330.x);
  float View_5284 : packoffset(c330.y);
  float View_5288 : packoffset(c330.z);
  float View_5292 : packoffset(c330.w);
  float View_5296 : packoffset(c331.x);
  float View_5300 : packoffset(c331.y);
  float View_5304 : packoffset(c331.z);
  float View_5308 : packoffset(c331.w);
  float View_5312 : packoffset(c332.x);
  float View_5316 : packoffset(c332.y);
  float View_5320 : packoffset(c332.z);
  float View_5324 : packoffset(c332.w);
  float View_5328 : packoffset(c333.x);
  float View_5332 : packoffset(c333.y);
  float View_5336 : packoffset(c333.z);
  float View_5340 : packoffset(c333.w);
  float View_5344 : packoffset(c334.x);
  float View_5348 : packoffset(c334.y);
  float View_5352 : packoffset(c334.z);
  float View_5356 : packoffset(c334.w);
  float View_5360 : packoffset(c335.x);
  float View_5364 : packoffset(c335.y);
  float View_5368 : packoffset(c335.z);
  float View_5372 : packoffset(c335.w);
  float View_5376 : packoffset(c336.x);
  float View_5380 : packoffset(c336.y);
  float View_5384 : packoffset(c336.z);
  float View_5388 : packoffset(c336.w);
  float View_5392 : packoffset(c337.x);
  float View_5396 : packoffset(c337.y);
  float View_5400 : packoffset(c337.z);
  float View_5404 : packoffset(c337.w);
  float View_5408 : packoffset(c338.x);
  float View_5412 : packoffset(c338.y);
  float View_5416 : packoffset(c338.z);
  float View_5420 : packoffset(c338.w);
  float View_5424 : packoffset(c339.x);
  float View_5428 : packoffset(c339.y);
  float View_5432 : packoffset(c339.z);
  float View_5436 : packoffset(c339.w);
  float4 View_5440 : packoffset(c340.x);
  float View_5456 : packoffset(c341.x);
  float View_5460 : packoffset(c341.y);
  float View_5464 : packoffset(c341.z);
  float View_5468 : packoffset(c341.w);
  float4 View_5472 : packoffset(c342.x);
  float View_5488 : packoffset(c343.x);
  float View_5492 : packoffset(c343.y);
  float View_5496 : packoffset(c343.z);
  float View_5500 : packoffset(c343.w);
  float View_5504 : packoffset(c344.x);
  float View_5508 : packoffset(c344.y);
  float View_5512 : packoffset(c344.z);
  float View_5516 : packoffset(c344.w);
  float View_5520 : packoffset(c345.x);
  float View_5524 : packoffset(c345.y);
  float View_5528 : packoffset(c345.z);
  float View_5532 : packoffset(c345.w);
  float2 View_5536 : packoffset(c346.x);
  float View_5544 : packoffset(c346.z);
  float View_5548 : packoffset(c346.w);
  float3 View_5552 : packoffset(c347.x);
  float View_5564 : packoffset(c347.w);
  float3 View_5568 : packoffset(c348.x);
  float View_5580 : packoffset(c348.w);
  float3 View_5584 : packoffset(c349.x);
  float View_5596 : packoffset(c349.w);
  float View_5600 : packoffset(c350.x);
  float View_5604 : packoffset(c350.y);
  float View_5608 : packoffset(c350.z);
  float View_5612 : packoffset(c350.w);
  float View_5616 : packoffset(c351.x);
  float View_5620 : packoffset(c351.y);
  float View_5624 : packoffset(c351.z);
  float View_5628 : packoffset(c351.w);
  float4 View_5632 : packoffset(c352.x);
  float3 View_5648 : packoffset(c353.x);
  float View_5660 : packoffset(c353.w);
  float View_5664 : packoffset(c354.x);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

SamplerState s2 : register(s2);

SamplerState s3 : register(s3);

SamplerState s4 : register(s4);

SamplerState s5 : register(s5);

SamplerState s6 : register(s6);



float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float4 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 TEXCOORD_2 : TEXCOORD2,
  noperspective float2 TEXCOORD_3 : TEXCOORD3,
  noperspective float2 TEXCOORD_4 : TEXCOORD4,
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _36 = ((cb0_048z * TEXCOORD_3.x) + cb0_049x) * cb0_048x;
  float _37 = ((cb0_048w * TEXCOORD_3.y) + cb0_049y) * cb0_048y;
  float _76;
  float _77;
  float _104;
  float _105;
  float _164;
  float _165;
  float _233;
  float _234;
  float _294;
  float _295;
  float _296;
  float _424;
  float _425;
  float _426;
  float _458;
  float _459;
  float _460;
  float _507;
  float _508;
  float _509;
  float _566;
  float _569;
  float _570;
  float _571;
  float _606;
  float _607;
  float _608;
  float _654;
  float _655;
  float _656;
  float _744;
  float _745;
  float _746;
  float _754;
  [branch]
  if (!((uint)(cb0_099w) == 0)) {
    float4 _42 = t4.SampleLevel(s4, float2(_36, _37), 0.0f);
    float _54 = ((1.0f / ((View_1040.z * _42.x) - View_1040.w)) + View_1040.y) + (View_1040.x * _42.x);
    float4 _55 = t3.Sample(s3, float2(_36, _37));
    float _63 = 1.0f / ((_54 + View_1040.w) * View_1040.z);
    _76 = _55.x;
    _77 = select((((_63 - _55.x) + ((((View_448[3].z) - _63) + ((View_448[2].z) * _54)) * select(((View_448[3].w) < 1.0f), 0.0f, 1.0f))) > 0.0005000000237487257f), 0.0f, 1.0f);
  } else {
    _76 = 0.0f;
    _77 = 0.0f;
  }
  float _79 = (TEXCOORD_2.w * 543.3099975585938f) + TEXCOORD_2.z;
  float _82 = frac(sin(_79) * 493013.0f);
  if (cb0_088x > 0.0f) {
    _104 = (((frac((sin(_79 + 33.9900016784668f) * 493013.0f) + 7.177000045776367f) - _82) * cb0_088x) + _82);
    _105 = (((frac((sin(_79 + 66.98999786376953f) * 493013.0f) + 14.298999786376953f) - _82) * cb0_088x) + _82);
  } else {
    _104 = _82;
    _105 = _82;
  }
  float _115 = cb0_109z * cb0_108x;
  float _116 = cb0_109z * cb0_108y;
  bool _117 = (cb0_109x == 0.0f);
  float _127 = (cb0_105z * TEXCOORD_3.x) + cb0_105x;
  float _128 = (cb0_105w * TEXCOORD_3.y) + cb0_105y;
  float _147 = float(((int)(uint)((bool)(_127 > 0.0f))) - ((int)(uint)((bool)(_127 < 0.0f)))) * saturate(abs(_127) - cb0_108z);
  float _149 = float(((int)(uint)((bool)(_128 > 0.0f))) - ((int)(uint)((bool)(_128 < 0.0f)))) * saturate(abs(_128) - cb0_108z);
  float _154 = _128 - (_149 * _115);
  float _156 = _128 - (_149 * _116);
  bool _157 = (cb0_109x > 0.0f);
  if (_157) {
    _164 = (_154 - (cb0_109w * 0.4000000059604645f));
    _165 = (_156 - (cb0_109w * 0.20000000298023224f));
  } else {
    _164 = _154;
    _165 = _156;
  }
  float4 _199 = t0.Sample(s0, float2(_36, _37));
  float4 _203 = t0.Sample(s0, float2((((((cb0_106z * (_127 - (_147 * select(_117, _115, cb0_108x)))) + cb0_106x) * cb0_048z) + cb0_049x) * cb0_048x), (((((cb0_106w * _164) + cb0_106y) * cb0_048w) + cb0_049y) * cb0_048y)));
  float4 _205 = t0.Sample(s0, float2((((((cb0_106z * (_127 - (_147 * select(_117, _116, cb0_108y)))) + cb0_106x) * cb0_048z) + cb0_049x) * cb0_048x), (((((cb0_106w * _165) + cb0_106y) * cb0_048w) + cb0_049y) * cb0_048y)));
  if (_157) {
    float _215 = saturate(((((_199.y * 0.5870000123977661f) - cb0_109y) + (_199.x * 0.29899999499320984f)) + (_199.z * 0.11400000005960464f)) * 10.0f);
    float _219 = (_215 * _215) * (3.0f - (_215 * 2.0f));
    _233 = ((((_199.x - _203.x) + (_219 * (_203.x - _199.x))) * cb0_109x) + _203.x);
    _234 = ((((_199.y - _205.y) + (_219 * (_205.y - _199.y))) * cb0_109x) + _205.y);
  } else {
    _233 = _203.x;
    _234 = _205.y;
  }

  float4 _259 = t1.Sample(s1, float2(min(max(((cb0_068z * _36) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _37) + cb0_069y), cb0_060w), cb0_061y)));
  APPLY_BLOOM(_259);

  [branch]
  if (!((uint)(cb0_077z) == 0)) {
    float4 _286 = t2.Sample(s2, float2(min(max(((cb0_076z * _36) + cb0_077x), cb0_075z), cb0_076x), min(max(((cb0_076w * _37) + cb0_077y), cb0_075w), cb0_076y)));
    _294 = (_286.x + _259.x);
    _295 = (_286.y + _259.y);
    _296 = (_286.z + _259.z);
  } else {
    _294 = _259.x;
    _295 = _259.y;
    _296 = _259.z;
  }
  float _321 = TEXCOORD_1.z + -1.0f;
  float _323 = TEXCOORD_1.w + -1.0f;
  float _326 = (((cb0_082x * 2.0f) + _321) * cb0_080z) * cb0_080x;
  float _328 = (((cb0_082y * 2.0f) + _323) * cb0_080w) * cb0_080x;
  float _335 = 1.0f / ((((saturate(cb0_081w) * 9.0f) + 1.0f) * dot(float2(_326, _328), float2(_326, _328))) + 1.0f);
  float _336 = _335 * _335;
  float _337 = cb0_082z + 1.0f;
  float _365 = (((cb0_085x * 2.0f) + _321) * cb0_083z) * cb0_083x;
  float _367 = (((cb0_085y * 2.0f) + _323) * cb0_083w) * cb0_083x;
  float _374 = 1.0f / ((((saturate(cb0_084w) * 9.0f) + 1.0f) * dot(float2(_365, _367), float2(_365, _367))) + 1.0f);
  float _375 = _374 * _374;
  float _376 = cb0_085z + 1.0f;
  float _387 = (((_336 * (_337 - cb0_081x)) + cb0_081x) * (_294 + ((_233 * TEXCOORD_1.x) * cb0_078x))) * ((_375 * (_376 - cb0_084x)) + cb0_084x);
  float _389 = (((_336 * (_337 - cb0_081y)) + cb0_081y) * (_295 + ((_234 * TEXCOORD_1.x) * cb0_078y))) * ((_375 * (_376 - cb0_084y)) + cb0_084y);
  float _391 = (((_336 * (_337 - cb0_081z)) + cb0_081z) * (_296 + ((_199.z * TEXCOORD_1.x) * cb0_078z))) * ((_375 * (_376 - cb0_084z)) + cb0_084z);

  CAPTURE_UNTONEMAPPED(float3(_387, _389, _391));

  [branch]
  if (WUWA_TM_IS(1)) {
    _424 = ((((_387 * 1.3600000143051147f) + 0.04699999839067459f) * _387) / ((((_387 * 0.9599999785423279f) + 0.5600000023841858f) * _387) + 0.14000000059604645f));
    _425 = ((((_389 * 1.3600000143051147f) + 0.04699999839067459f) * _389) / ((((_389 * 0.9599999785423279f) + 0.5600000023841858f) * _389) + 0.14000000059604645f));
    _426 = ((((_391 * 1.3600000143051147f) + 0.04699999839067459f) * _391) / ((((_391 * 0.9599999785423279f) + 0.5600000023841858f) * _391) + 0.14000000059604645f));
  } else {
    _424 = _387;
    _425 = _389;
    _426 = _391;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    float _436 = 1.0049500465393066f - (0.16398000717163086f / (_424 + -0.19505000114440918f));
    float _437 = 1.0049500465393066f - (0.16398000717163086f / (_425 + -0.19505000114440918f));
    float _438 = 1.0049500465393066f - (0.16398000717163086f / (_426 + -0.19505000114440918f));
    _458 = (((_424 - _436) * select((_424 > 0.6000000238418579f), 0.0f, 1.0f)) + _436);
    _459 = (((_425 - _437) * select((_425 > 0.6000000238418579f), 0.0f, 1.0f)) + _437);
    _460 = (((_426 - _438) * select((_426 > 0.6000000238418579f), 0.0f, 1.0f)) + _438);
  } else {
    _458 = _424;
    _459 = _425;
    _460 = _426;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    float _466 = cb0_037y * _458;
    float _467 = cb0_037y * _459;
    float _468 = cb0_037y * _460;
    float _471 = cb0_037z * cb0_037w;
    float _481 = cb0_038y * cb0_038x;
    float _492 = cb0_038z * cb0_038x;
    float _499 = cb0_038y / cb0_038z;
    _507 = (((((_471 + _466) * _458) + _481) / (((_466 + cb0_037z) * _458) + _492)) - _499);
    _508 = (((((_471 + _467) * _459) + _481) / (((_467 + cb0_037z) * _459) + _492)) - _499);
    _509 = (((((_471 + _468) * _460) + _481) / (((_468 + cb0_037z) * _460) + _492)) - _499);
  } else {
    _507 = _458;
    _508 = _459;
    _509 = _460;
  }
  [branch]
  if (!((uint)(cb0_097w) == 0)) {
    if (!(cb0_098x == 1.0f)) {
      float _518 = dot(float3(_507, _508, _509), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      if (!(_518 <= 9.999999747378752e-05f)) {
        float _527 = (pow(_507, 0.1593017578125f));
        float _528 = (pow(_508, 0.1593017578125f));
        float _529 = (pow(_509, 0.1593017578125f));
        float _551 = exp2(log2(((_527 * 18.8515625f) + 0.8359375f) / ((_527 * 18.6875f) + 1.0f)) * 78.84375f);
        float _552 = exp2(log2(((_528 * 18.8515625f) + 0.8359375f) / ((_528 * 18.6875f) + 1.0f)) * 78.84375f);
        float _553 = exp2(log2(((_529 * 18.8515625f) + 0.8359375f) / ((_529 * 18.6875f) + 1.0f)) * 78.84375f);
        if ((_518 * 200.0f) > 1.0f) {
          float _557 = 1.0f - cb0_098x;
          do {
            if (_551 > 0.44028136134147644f) {
              float _560 = _551 + -0.44028136134147644f;
              _566 = ((_560 / ((_560 * _557) + 1.0f)) + 0.44028136134147644f);
            } else {
              _566 = _551;
            }
            do {
              if (_552 > 0.44028136134147644f) {
                float _748 = _552 + -0.44028136134147644f;
                _754 = ((_748 / ((_748 * _557) + 1.0f)) + 0.44028136134147644f);
                if (_553 > 0.44028136134147644f) {
                  float _757 = _553 + -0.44028136134147644f;
                  _569 = ((_757 / ((_757 * _557) + 1.0f)) + 0.44028136134147644f);
                  _570 = _754;
                  _571 = _566;
                } else {
                  _569 = _553;
                  _570 = _754;
                  _571 = _566;
                }
              } else {
                _754 = _552;
                if (_553 > 0.44028136134147644f) {
                  float _757 = _553 + -0.44028136134147644f;
                  _569 = ((_757 / ((_757 * _557) + 1.0f)) + 0.44028136134147644f);
                  _570 = _754;
                  _571 = _566;
                } else {
                  _569 = _553;
                  _570 = _754;
                  _571 = _566;
                }
              }
              while(true) {
                float _578 = (pow(_571, 0.012683313339948654f));
                float _579 = (pow(_570, 0.012683313339948654f));
                float _580 = (pow(_569, 0.012683313339948654f));
                _606 = exp2(log2(max((_578 + -0.8359375f), 0.0f) / (18.8515625f - (_578 * 18.6875f))) * 6.277394771575928f);
                _607 = exp2(log2(max((_579 + -0.8359375f), 0.0f) / (18.8515625f - (_579 * 18.6875f))) * 6.277394771575928f);
                _608 = exp2(log2(max((_580 + -0.8359375f), 0.0f) / (18.8515625f - (_580 * 18.6875f))) * 6.277394771575928f);
                break;
              }
            } while (false);
          } while (false);
        } else {
          _569 = _553;
          _570 = _552;
          _571 = _551;
          while(true) {
            float _578 = (pow(_571, 0.012683313339948654f));
            float _579 = (pow(_570, 0.012683313339948654f));
            float _580 = (pow(_569, 0.012683313339948654f));
            _606 = exp2(log2(max((_578 + -0.8359375f), 0.0f) / (18.8515625f - (_578 * 18.6875f))) * 6.277394771575928f);
            _607 = exp2(log2(max((_579 + -0.8359375f), 0.0f) / (18.8515625f - (_579 * 18.6875f))) * 6.277394771575928f);
            _608 = exp2(log2(max((_580 + -0.8359375f), 0.0f) / (18.8515625f - (_580 * 18.6875f))) * 6.277394771575928f);
            break;
          }
        }
      } else {
        _606 = _507;
        _607 = _508;
        _608 = _509;
      }
    } else {
      _606 = _507;
      _607 = _508;
      _608 = _509;
    }
  } else {
    _606 = _507;
    _607 = _508;
    _608 = _509;
  }

  CLAMP_IF_SDR3(_606, _607, _608);
  CAPTURE_TONEMAPPED(float3(_606, _607, _608));

  float _629 = (saturate((log2(_606 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _630 = (saturate((log2(_607 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _631 = (saturate((log2(_608 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float4 _632 = t5.Sample(s5, float3(_629, _630, _631));

  HANDLE_LUT_OUTPUT_FADE(_632, t5, s5);

  [branch]
  if (false) {
    float _639 = select(((_77 * _76) > 0.0f), 0.0f, 1.0f);
    float4 _640 = t6.Sample(s6, float3(_629, _630, _631));
    _654 = (lerp(_632.x, _640.x, _639));
    _655 = (lerp(_632.y, _640.y, _639));
    _656 = (lerp(_632.z, _640.z, _639));
  } else {
    _654 = _632.x;
    _655 = _632.y;
    _656 = _632.z;
  }
  float _657 = _654 * 1.0499999523162842f;
  float _658 = _655 * 1.0499999523162842f;
  float _659 = _656 * 1.0499999523162842f;
  float _667 = ((_82 * 0.00390625f) + -0.001953125f) + _657;
  float _668 = ((_104 * 0.00390625f) + -0.001953125f) + _658;
  float _669 = ((_105 * 0.00390625f) + -0.001953125f) + _659;
  [branch]
  if (!((uint)(cb0_098w) == 0)) {
    float _681 = (pow(_667, 0.012683313339948654f));
    float _682 = (pow(_668, 0.012683313339948654f));
    float _683 = (pow(_669, 0.012683313339948654f));
    float _716 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_681 + -0.8359375f)) / (18.8515625f - (_681 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_098z));
    float _717 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_682 + -0.8359375f)) / (18.8515625f - (_682 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_098z));
    float _718 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_683 + -0.8359375f)) / (18.8515625f - (_683 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_098z));
    _744 = min((_716 * 12.920000076293945f), ((exp2(log2(max(_716, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _745 = min((_717 * 12.920000076293945f), ((exp2(log2(max(_717, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _746 = min((_718 * 12.920000076293945f), ((exp2(log2(max(_718, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _744 = _667;
    _745 = _668;
    _746 = _669;
  }
  SV_Target.x = _744;
  SV_Target.y = _745;
  SV_Target.z = _746;

  SV_Target.w = (dot(float3(_657, _658, _659), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);

  return SV_Target;
}
