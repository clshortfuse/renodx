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
  float cb0_053z : packoffset(c053.z);
  float cb0_053w : packoffset(c053.w);
  float cb0_054x : packoffset(c054.x);
  float cb0_054y : packoffset(c054.y);
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
  uint cb0_077w : packoffset(c077.w);
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
  float cb0_087z : packoffset(c087.z);
  float cb0_088x : packoffset(c088.x);
  uint cb0_097w : packoffset(c097.w);
  float cb0_098x : packoffset(c098.x);
  float cb0_098z : packoffset(c098.z);
  uint cb0_098w : packoffset(c098.w);
  uint cb0_099x : packoffset(c099.x);
  uint cb0_099y : packoffset(c099.y);
  uint cb0_099z : packoffset(c099.z);
  uint cb0_099w : packoffset(c099.w);
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
  float4 View_3168 : packoffset(c198.x);
  float View_3184 : packoffset(c199.x);
  float View_3188 : packoffset(c199.y);
  float View_3192 : packoffset(c199.z);
  float View_3196 : packoffset(c199.w);
  float View_3200 : packoffset(c200.x);
  float View_3204 : packoffset(c200.y);
  float View_3208 : packoffset(c200.z);
  float View_3212 : packoffset(c200.w);
  float4 View_3216 : packoffset(c201.x);
  float4 View_3232[7] : packoffset(c202.x);
  float View_3344 : packoffset(c209.x);
  float View_3348 : packoffset(c209.y);
  float View_3352 : packoffset(c209.z);
  float View_3356 : packoffset(c209.w);
  int View_3360 : packoffset(c210.x);
  float View_3364 : packoffset(c210.y);
  float View_3368 : packoffset(c210.z);
  float View_3372 : packoffset(c210.w);
  float3 View_3376 : packoffset(c211.x);
  int View_3388 : packoffset(c211.w);
  float4 View_3392[6] : packoffset(c212.x);
  float4 View_3488[6] : packoffset(c218.x);
  float4 View_3584[6] : packoffset(c224.x);
  float4 View_3680[6] : packoffset(c230.x);
  float View_3776 : packoffset(c236.x);
  float View_3780 : packoffset(c236.y);
  int View_3784 : packoffset(c236.z);
  float View_3788 : packoffset(c236.w);
  float3 View_3792 : packoffset(c237.x);
  float View_3804 : packoffset(c237.w);
  float3 View_3808 : packoffset(c238.x);
  float View_3820 : packoffset(c238.w);
  float View_3824 : packoffset(c239.x);
  float View_3828 : packoffset(c239.y);
  int View_3832 : packoffset(c239.z);
  float View_3836 : packoffset(c239.w);
  float View_3840 : packoffset(c240.x);
  float View_3844 : packoffset(c240.y);
  float View_3848 : packoffset(c240.z);
  float View_3852 : packoffset(c240.w);
  int2 View_3856 : packoffset(c241.x);
  float View_3864 : packoffset(c241.z);
  float View_3868 : packoffset(c241.w);
  float3 View_3872 : packoffset(c242.x);
  float View_3884 : packoffset(c242.w);
  float3 View_3888 : packoffset(c243.x);
  float View_3900 : packoffset(c243.w);
  float2 View_3904 : packoffset(c244.x);
  float2 View_3912 : packoffset(c244.z);
  float2 View_3920 : packoffset(c245.x);
  float2 View_3928 : packoffset(c245.z);
  float2 View_3936 : packoffset(c246.x);
  float View_3944 : packoffset(c246.z);
  float View_3948 : packoffset(c246.w);
  float3 View_3952 : packoffset(c247.x);
  float View_3964 : packoffset(c247.w);
  float2 View_3968 : packoffset(c248.x);
  float2 View_3976 : packoffset(c248.z);
  float View_3984 : packoffset(c249.x);
  float View_3988 : packoffset(c249.y);
  float View_3992 : packoffset(c249.z);
  float View_3996 : packoffset(c249.w);
  float3 View_4000 : packoffset(c250.x);
  float View_4012 : packoffset(c250.w);
  float3 View_4016 : packoffset(c251.x);
  float View_4028 : packoffset(c251.w);
  float3 View_4032 : packoffset(c252.x);
  float View_4044 : packoffset(c252.w);
  float3 View_4048 : packoffset(c253.x);
  float View_4060 : packoffset(c253.w);
  float View_4064 : packoffset(c254.x);
  float View_4068 : packoffset(c254.y);
  float View_4072 : packoffset(c254.z);
  float View_4076 : packoffset(c254.w);
  float4 View_4080[4] : packoffset(c255.x);
  float4 View_4144[2] : packoffset(c259.x);
  int View_4176 : packoffset(c261.x);
  float View_4180 : packoffset(c261.y);
  float View_4184 : packoffset(c261.z);
  float View_4188 : packoffset(c261.w);
  float4 View_4192 : packoffset(c262.x);
  float2 View_4208 : packoffset(c263.x);
  float View_4216 : packoffset(c263.z);
  float View_4220 : packoffset(c263.w);
  float4 View_4224 : packoffset(c264.x);
  int View_4240 : packoffset(c265.x);
  float View_4244 : packoffset(c265.y);
  float View_4248 : packoffset(c265.z);
  float View_4252 : packoffset(c265.w);
  float4 View_4256 : packoffset(c266.x);
  int View_4272 : packoffset(c267.x);
  int View_4276 : packoffset(c267.y);
  int View_4280 : packoffset(c267.z);
  float View_4284 : packoffset(c267.w);
  float View_4288 : packoffset(c268.x);
  float View_4292 : packoffset(c268.y);
  float View_4296 : packoffset(c268.z);
  float View_4300 : packoffset(c268.w);
  float4 View_4304 : packoffset(c269.x);
  float4 View_4320 : packoffset(c270.x);
  float4 View_4336 : packoffset(c271.x);
  float4 View_4352 : packoffset(c272.x);
  float4 View_4368 : packoffset(c273.x);
  float4 View_4384 : packoffset(c274.x);
  int View_4400 : packoffset(c275.x);
  float View_4404 : packoffset(c275.y);
  float View_4408 : packoffset(c275.z);
  float View_4412 : packoffset(c275.w);
  float4 View_4416 : packoffset(c276.x);
  float4 View_4432 : packoffset(c277.x);
  float View_4448 : packoffset(c278.x);
  float View_4452 : packoffset(c278.y);
  float View_4456 : packoffset(c278.z);
  float View_4460 : packoffset(c278.w);
  int View_4464 : packoffset(c279.x);
  float View_4468 : packoffset(c279.y);
  float View_4472 : packoffset(c279.z);
  float View_4476 : packoffset(c279.w);
  float View_4480 : packoffset(c280.x);
  float View_4484 : packoffset(c280.y);
  float View_4488 : packoffset(c280.z);
  float View_4492 : packoffset(c280.w);
  float4 View_4496 : packoffset(c281.x);
  int View_4512 : packoffset(c282.x);
  int View_4516 : packoffset(c282.y);
  int View_4520 : packoffset(c282.z);
  float View_4524 : packoffset(c282.w);
  float View_4528 : packoffset(c283.x);
  float View_4532 : packoffset(c283.y);
  float View_4536 : packoffset(c283.z);
  float View_4540 : packoffset(c283.w);
  float4 View_4544 : packoffset(c284.x);
  float4 View_4560 : packoffset(c285.x);
  float4 View_4576 : packoffset(c286.x);
  float4 View_4592 : packoffset(c287.x);
  float View_4608 : packoffset(c288.x);
  float View_4612 : packoffset(c288.y);
  float View_4616 : packoffset(c288.z);
  float View_4620 : packoffset(c288.w);
  float4 View_4624 : packoffset(c289.x);
  float4 View_4640 : packoffset(c290.x);
  float4 View_4656 : packoffset(c291.x);
  float4 View_4672 : packoffset(c292.x);
  float4 View_4688 : packoffset(c293.x);
  float View_4704 : packoffset(c294.x);
  float View_4708 : packoffset(c294.y);
  float View_4712 : packoffset(c294.z);
  float View_4716 : packoffset(c294.w);
  float4 View_4720 : packoffset(c295.x);
  float4 View_4736 : packoffset(c296.x);
  float View_4752 : packoffset(c297.x);
  float View_4756 : packoffset(c297.y);
  float View_4760 : packoffset(c297.z);
  float View_4764 : packoffset(c297.w);
  float4 View_4768 : packoffset(c298.x);
  float4 View_4784 : packoffset(c299.x);
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
  float View_5440 : packoffset(c340.x);
  float View_5444 : packoffset(c340.y);
  float View_5448 : packoffset(c340.z);
  float View_5452 : packoffset(c340.w);
  float View_5456 : packoffset(c341.x);
  float View_5460 : packoffset(c341.y);
  float View_5464 : packoffset(c341.z);
  float View_5468 : packoffset(c341.w);
  float4 View_5472 : packoffset(c342.x);
  float View_5488 : packoffset(c343.x);
  float View_5492 : packoffset(c343.y);
  float View_5496 : packoffset(c343.z);
  float View_5500 : packoffset(c343.w);
  float4 View_5504 : packoffset(c344.x);
  float View_5520 : packoffset(c345.x);
  float View_5524 : packoffset(c345.y);
  float View_5528 : packoffset(c345.z);
  float View_5532 : packoffset(c345.w);
  float View_5536 : packoffset(c346.x);
  float View_5540 : packoffset(c346.y);
  float View_5544 : packoffset(c346.z);
  float View_5548 : packoffset(c346.w);
  float View_5552 : packoffset(c347.x);
  float View_5556 : packoffset(c347.y);
  float View_5560 : packoffset(c347.z);
  float View_5564 : packoffset(c347.w);
  float2 View_5568 : packoffset(c348.x);
  float View_5576 : packoffset(c348.z);
  float View_5580 : packoffset(c348.w);
  float3 View_5584 : packoffset(c349.x);
  float View_5596 : packoffset(c349.w);
  float3 View_5600 : packoffset(c350.x);
  float View_5612 : packoffset(c350.w);
  float3 View_5616 : packoffset(c351.x);
  float View_5628 : packoffset(c351.w);
  float View_5632 : packoffset(c352.x);
  float View_5636 : packoffset(c352.y);
  float View_5640 : packoffset(c352.z);
  float View_5644 : packoffset(c352.w);
  float View_5648 : packoffset(c353.x);
  float View_5652 : packoffset(c353.y);
  float View_5656 : packoffset(c353.z);
  float View_5660 : packoffset(c353.w);
  float4 View_5664 : packoffset(c354.x);
  float3 View_5680 : packoffset(c355.x);
  float View_5692 : packoffset(c355.w);
  float View_5696 : packoffset(c356.x);
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
  float _38 = ((cb0_048z * TEXCOORD_3.x) + cb0_049x) * cb0_048x;
  float _39 = ((cb0_048w * TEXCOORD_3.y) + cb0_049y) * cb0_048y;
  float _78;
  float _79;
  float _106;
  float _107;
  float _196;
  float _197;
  float _198;
  float _326;
  float _327;
  float _328;
  float _360;
  float _361;
  float _362;
  float _409;
  float _410;
  float _411;
  float _468;
  float _471;
  float _472;
  float _473;
  float _508;
  float _509;
  float _510;
  float _556;
  float _557;
  float _558;
  float _646;
  float _647;
  float _648;
  float _656;
  [branch]
  if (!((uint)(cb0_099w) == 0)) {
    float4 _44 = t4.SampleLevel(s4, float2(_38, _39), 0.0f);
    float _56 = ((1.0f / ((View_1040.z * _44.x) - View_1040.w)) + View_1040.y) + (View_1040.x * _44.x);
    float4 _57 = t3.Sample(s3, float2(_38, _39));
    float _65 = 1.0f / ((_56 + View_1040.w) * View_1040.z);
    _78 = _57.x;
    _79 = select((((_65 - _57.x) + ((((View_448[3].z) - _65) + ((View_448[2].z) * _56)) * select(((View_448[3].w) < 1.0f), 0.0f, 1.0f))) > 0.0005000000237487257f), 0.0f, 1.0f);
  } else {
    _78 = 0.0f;
    _79 = 0.0f;
  }
  float _81 = (TEXCOORD_2.w * 543.3099975585938f) + TEXCOORD_2.z;
  float _84 = frac(sin(_81) * 493013.0f);
  if (cb0_088x > 0.0f) {
    _106 = (((frac((sin(_81 + 33.9900016784668f) * 493013.0f) + 7.177000045776367f) - _84) * cb0_088x) + _84);
    _107 = (((frac((sin(_81 + 66.98999786376953f) * 493013.0f) + 14.298999786376953f) - _84) * cb0_088x) + _84);
  } else {
    _106 = _84;
    _107 = _84;
  }
  float _112 = cb0_087z * (1.0f - (_84 * _84));
  float _117 = (_112 * (TEXCOORD_2.x - _38)) + _38;
  float _118 = (_112 * (TEXCOORD_2.y - _39)) + _39;
  float4 _129 = t0.Sample(s0, float2(min(max(_117, cb0_053z), cb0_054x), min(max(_118, cb0_053w), cb0_054y)));

  float4 _157 = t1.Sample(s1, float2(min(max(((cb0_068z * _117) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _118) + cb0_069y), cb0_060w), cb0_061y)));
  APPLY_BLOOM(_157);

  [branch]
  if (!((uint)(cb0_077z) == 0)) {
    bool _185 = ((uint)(cb0_077w) != 0);
    float4 _188 = t2.Sample(s2, float2(select(_185, _117, min(max(((cb0_076z * _117) + cb0_077x), cb0_075z), cb0_076x)), select(_185, _118, min(max(((cb0_076w * _118) + cb0_077y), cb0_075w), cb0_076y))));
    _196 = (_188.x + _157.x);
    _197 = (_188.y + _157.y);
    _198 = (_188.z + _157.z);
  } else {
    _196 = _157.x;
    _197 = _157.y;
    _198 = _157.z;
  }
  float _223 = TEXCOORD_1.z + -1.0f;
  float _225 = TEXCOORD_1.w + -1.0f;
  float _228 = (((cb0_082x * 2.0f) + _223) * cb0_080z) * cb0_080x;
  float _230 = (((cb0_082y * 2.0f) + _225) * cb0_080w) * cb0_080x;
  float _237 = 1.0f / ((((saturate(cb0_081w) * 9.0f) + 1.0f) * dot(float2(_228, _230), float2(_228, _230))) + 1.0f);
  float _238 = _237 * _237;
  float _239 = cb0_082z + 1.0f;
  float _267 = (((cb0_085x * 2.0f) + _223) * cb0_083z) * cb0_083x;
  float _269 = (((cb0_085y * 2.0f) + _225) * cb0_083w) * cb0_083x;
  float _276 = 1.0f / ((((saturate(cb0_084w) * 9.0f) + 1.0f) * dot(float2(_267, _269), float2(_267, _269))) + 1.0f);
  float _277 = _276 * _276;
  float _278 = cb0_085z + 1.0f;
  float _289 = (((_238 * (_239 - cb0_081x)) + cb0_081x) * (_196 + ((_129.x * TEXCOORD_1.x) * cb0_078x))) * ((_277 * (_278 - cb0_084x)) + cb0_084x);
  float _291 = (((_238 * (_239 - cb0_081y)) + cb0_081y) * (_197 + ((_129.y * TEXCOORD_1.x) * cb0_078y))) * ((_277 * (_278 - cb0_084y)) + cb0_084y);
  float _293 = (((_238 * (_239 - cb0_081z)) + cb0_081z) * (_198 + ((_129.z * TEXCOORD_1.x) * cb0_078z))) * ((_277 * (_278 - cb0_084z)) + cb0_084z);

  CAPTURE_UNTONEMAPPED(float3(_289, _291, _293));

  [branch]
  if (WUWA_TM_IS(1)) {
    _326 = ((((_289 * 1.3600000143051147f) + 0.04699999839067459f) * _289) / ((((_289 * 0.9599999785423279f) + 0.5600000023841858f) * _289) + 0.14000000059604645f));
    _327 = ((((_291 * 1.3600000143051147f) + 0.04699999839067459f) * _291) / ((((_291 * 0.9599999785423279f) + 0.5600000023841858f) * _291) + 0.14000000059604645f));
    _328 = ((((_293 * 1.3600000143051147f) + 0.04699999839067459f) * _293) / ((((_293 * 0.9599999785423279f) + 0.5600000023841858f) * _293) + 0.14000000059604645f));
  } else {
    _326 = _289;
    _327 = _291;
    _328 = _293;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    float _338 = 1.0049500465393066f - (0.16398000717163086f / (_326 + -0.19505000114440918f));
    float _339 = 1.0049500465393066f - (0.16398000717163086f / (_327 + -0.19505000114440918f));
    float _340 = 1.0049500465393066f - (0.16398000717163086f / (_328 + -0.19505000114440918f));
    _360 = (((_326 - _338) * select((_326 > 0.6000000238418579f), 0.0f, 1.0f)) + _338);
    _361 = (((_327 - _339) * select((_327 > 0.6000000238418579f), 0.0f, 1.0f)) + _339);
    _362 = (((_328 - _340) * select((_328 > 0.6000000238418579f), 0.0f, 1.0f)) + _340);
  } else {
    _360 = _326;
    _361 = _327;
    _362 = _328;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    float _368 = cb0_037y * _360;
    float _369 = cb0_037y * _361;
    float _370 = cb0_037y * _362;
    float _373 = cb0_037z * cb0_037w;
    float _383 = cb0_038y * cb0_038x;
    float _394 = cb0_038z * cb0_038x;
    float _401 = cb0_038y / cb0_038z;
    _409 = (((((_373 + _368) * _360) + _383) / (((_368 + cb0_037z) * _360) + _394)) - _401);
    _410 = (((((_373 + _369) * _361) + _383) / (((_369 + cb0_037z) * _361) + _394)) - _401);
    _411 = (((((_373 + _370) * _362) + _383) / (((_370 + cb0_037z) * _362) + _394)) - _401);
  } else {
    _409 = _360;
    _410 = _361;
    _411 = _362;
  }
  [branch]
  if (!((uint)(cb0_097w) == 0)) {
    if (!(cb0_098x == 1.0f)) {
      float _420 = dot(float3(_409, _410, _411), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      if (!(_420 <= 9.999999747378752e-05f)) {
        float _429 = (pow(_409, 0.1593017578125f));
        float _430 = (pow(_410, 0.1593017578125f));
        float _431 = (pow(_411, 0.1593017578125f));
        float _453 = exp2(log2(((_429 * 18.8515625f) + 0.8359375f) / ((_429 * 18.6875f) + 1.0f)) * 78.84375f);
        float _454 = exp2(log2(((_430 * 18.8515625f) + 0.8359375f) / ((_430 * 18.6875f) + 1.0f)) * 78.84375f);
        float _455 = exp2(log2(((_431 * 18.8515625f) + 0.8359375f) / ((_431 * 18.6875f) + 1.0f)) * 78.84375f);
        if ((_420 * 200.0f) > 1.0f) {
          float _459 = 1.0f - cb0_098x;
          do {
            if (_453 > 0.44028136134147644f) {
              float _462 = _453 + -0.44028136134147644f;
              _468 = ((_462 / ((_462 * _459) + 1.0f)) + 0.44028136134147644f);
            } else {
              _468 = _453;
            }
            do {
              if (_454 > 0.44028136134147644f) {
                float _650 = _454 + -0.44028136134147644f;
                _656 = ((_650 / ((_650 * _459) + 1.0f)) + 0.44028136134147644f);
                if (_455 > 0.44028136134147644f) {
                  float _659 = _455 + -0.44028136134147644f;
                  _471 = ((_659 / ((_659 * _459) + 1.0f)) + 0.44028136134147644f);
                  _472 = _656;
                  _473 = _468;
                } else {
                  _471 = _455;
                  _472 = _656;
                  _473 = _468;
                }
              } else {
                _656 = _454;
                if (_455 > 0.44028136134147644f) {
                  float _659 = _455 + -0.44028136134147644f;
                  _471 = ((_659 / ((_659 * _459) + 1.0f)) + 0.44028136134147644f);
                  _472 = _656;
                  _473 = _468;
                } else {
                  _471 = _455;
                  _472 = _656;
                  _473 = _468;
                }
              }
              while(true) {
                float _480 = (pow(_473, 0.012683313339948654f));
                float _481 = (pow(_472, 0.012683313339948654f));
                float _482 = (pow(_471, 0.012683313339948654f));
                _508 = exp2(log2(max((_480 + -0.8359375f), 0.0f) / (18.8515625f - (_480 * 18.6875f))) * 6.277394771575928f);
                _509 = exp2(log2(max((_481 + -0.8359375f), 0.0f) / (18.8515625f - (_481 * 18.6875f))) * 6.277394771575928f);
                _510 = exp2(log2(max((_482 + -0.8359375f), 0.0f) / (18.8515625f - (_482 * 18.6875f))) * 6.277394771575928f);
                break;
              }
            } while (false);
          } while (false);
        } else {
          _471 = _455;
          _472 = _454;
          _473 = _453;
          while(true) {
            float _480 = (pow(_473, 0.012683313339948654f));
            float _481 = (pow(_472, 0.012683313339948654f));
            float _482 = (pow(_471, 0.012683313339948654f));
            _508 = exp2(log2(max((_480 + -0.8359375f), 0.0f) / (18.8515625f - (_480 * 18.6875f))) * 6.277394771575928f);
            _509 = exp2(log2(max((_481 + -0.8359375f), 0.0f) / (18.8515625f - (_481 * 18.6875f))) * 6.277394771575928f);
            _510 = exp2(log2(max((_482 + -0.8359375f), 0.0f) / (18.8515625f - (_482 * 18.6875f))) * 6.277394771575928f);
            break;
          }
        }
      } else {
        _508 = _409;
        _509 = _410;
        _510 = _411;
      }
    } else {
      _508 = _409;
      _509 = _410;
      _510 = _411;
    }
  } else {
    _508 = _409;
    _509 = _410;
    _510 = _411;
  }

  CLAMP_IF_SDR3(_508, _509, _510);
  CAPTURE_TONEMAPPED(float3(_508, _509, _510));

  float _531 = (saturate((log2(_508 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _532 = (saturate((log2(_509 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _533 = (saturate((log2(_510 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float4 _534 = t5.Sample(s5, float3(_531, _532, _533));

  HANDLE_LUT_OUTPUT(_534);

  [branch]
  if (false) {
    float _541 = select(((_79 * _78) > 0.0f), 0.0f, 1.0f);
    float4 _542 = t6.Sample(s6, float3(_531, _532, _533));
    _556 = (lerp(_534.x, _542.x, _541));
    _557 = (lerp(_534.y, _542.y, _541));
    _558 = (lerp(_534.z, _542.z, _541));
  } else {
    _556 = _534.x;
    _557 = _534.y;
    _558 = _534.z;
  }
  float _559 = _556 * 1.0499999523162842f;
  float _560 = _557 * 1.0499999523162842f;
  float _561 = _558 * 1.0499999523162842f;
  float _569 = ((_84 * 0.00390625f) + -0.001953125f) + _559;
  float _570 = ((_106 * 0.00390625f) + -0.001953125f) + _560;
  float _571 = ((_107 * 0.00390625f) + -0.001953125f) + _561;
  [branch]
  if (!((uint)(cb0_098w) == 0)) {
    float _583 = (pow(_569, 0.012683313339948654f));
    float _584 = (pow(_570, 0.012683313339948654f));
    float _585 = (pow(_571, 0.012683313339948654f));
    float _618 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_583 + -0.8359375f)) / (18.8515625f - (_583 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_098z));
    float _619 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_584 + -0.8359375f)) / (18.8515625f - (_584 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_098z));
    float _620 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_585 + -0.8359375f)) / (18.8515625f - (_585 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_098z));
    _646 = min((_618 * 12.920000076293945f), ((exp2(log2(max(_618, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _647 = min((_619 * 12.920000076293945f), ((exp2(log2(max(_619, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _648 = min((_620 * 12.920000076293945f), ((exp2(log2(max(_620, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _646 = _569;
    _647 = _570;
    _648 = _571;
  }
  SV_Target.x = _646;
  SV_Target.y = _647;
  SV_Target.z = _648;

  SV_Target.w = (dot(float3(_559, _560, _561), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);

  return SV_Target;
}
