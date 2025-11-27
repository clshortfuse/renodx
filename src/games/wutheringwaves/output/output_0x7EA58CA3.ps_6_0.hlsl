#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

Texture3D<float4> t4 : register(t4);

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
  float cb0_064w : packoffset(c064.w);
  float cb0_065x : packoffset(c065.x);
  float cb0_068z : packoffset(c068.z);
  float cb0_068w : packoffset(c068.w);
  float cb0_069x : packoffset(c069.x);
  float cb0_069y : packoffset(c069.y);
  float cb0_070x : packoffset(c070.x);
  float cb0_070y : packoffset(c070.y);
  float cb0_070z : packoffset(c070.z);
  float cb0_072x : packoffset(c072.x);
  float cb0_072z : packoffset(c072.z);
  float cb0_072w : packoffset(c072.w);
  float cb0_073x : packoffset(c073.x);
  float cb0_073y : packoffset(c073.y);
  float cb0_073z : packoffset(c073.z);
  float cb0_073w : packoffset(c073.w);
  float cb0_074x : packoffset(c074.x);
  float cb0_074y : packoffset(c074.y);
  float cb0_074z : packoffset(c074.z);
  float cb0_075x : packoffset(c075.x);
  float cb0_075z : packoffset(c075.z);
  float cb0_075w : packoffset(c075.w);
  float cb0_076x : packoffset(c076.x);
  float cb0_076y : packoffset(c076.y);
  float cb0_076z : packoffset(c076.z);
  float cb0_076w : packoffset(c076.w);
  float cb0_077x : packoffset(c077.x);
  float cb0_077y : packoffset(c077.y);
  float cb0_077z : packoffset(c077.z);
  float cb0_079z : packoffset(c079.z);
  float cb0_080x : packoffset(c080.x);
  float cb0_080y : packoffset(c080.y);
  float cb0_080z : packoffset(c080.z);
  float cb0_081x : packoffset(c081.x);
  float cb0_081y : packoffset(c081.y);
  float cb0_081z : packoffset(c081.z);
  float cb0_082x : packoffset(c082.x);
  float cb0_082y : packoffset(c082.y);
  float cb0_082z : packoffset(c082.z);
  float cb0_083x : packoffset(c083.x);
  float cb0_083y : packoffset(c083.y);
  float cb0_083z : packoffset(c083.z);
  float cb0_085x : packoffset(c085.x);
  float cb0_085y : packoffset(c085.y);
  float cb0_085z : packoffset(c085.z);
  float cb0_086x : packoffset(c086.x);
  float cb0_086y : packoffset(c086.y);
  float cb0_086z : packoffset(c086.z);
  float cb0_087x : packoffset(c087.x);
  float cb0_087y : packoffset(c087.y);
  float cb0_087z : packoffset(c087.z);
  float cb0_088x : packoffset(c088.x);
  float cb0_088y : packoffset(c088.y);
  float cb0_088z : packoffset(c088.z);
  float cb0_089x : packoffset(c089.x);
  uint cb0_089w : packoffset(c089.w);
  float cb0_090x : packoffset(c090.x);
  float cb0_090z : packoffset(c090.z);
  uint cb0_090w : packoffset(c090.w);
  uint cb0_091x : packoffset(c091.x);
  uint cb0_091y : packoffset(c091.y);
  uint cb0_091z : packoffset(c091.z);
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
  float4 View_3376[4] : packoffset(c211.x);
  float4 View_3440[4] : packoffset(c215.x);
  float View_3504 : packoffset(c219.x);
  float View_3508 : packoffset(c219.y);
  float View_3512 : packoffset(c219.z);
  float View_3516 : packoffset(c219.w);
  int2 View_3520 : packoffset(c220.x);
  float View_3528 : packoffset(c220.z);
  float View_3532 : packoffset(c220.w);
  float3 View_3536 : packoffset(c221.x);
  float View_3548 : packoffset(c221.w);
  float3 View_3552 : packoffset(c222.x);
  float View_3564 : packoffset(c222.w);
  float2 View_3568 : packoffset(c223.x);
  float2 View_3576 : packoffset(c223.z);
  float2 View_3584 : packoffset(c224.x);
  float2 View_3592 : packoffset(c224.z);
  float2 View_3600 : packoffset(c225.x);
  float View_3608 : packoffset(c225.z);
  float View_3612 : packoffset(c225.w);
  float3 View_3616 : packoffset(c226.x);
  float View_3628 : packoffset(c226.w);
  float2 View_3632 : packoffset(c227.x);
  float2 View_3640 : packoffset(c227.z);
  float View_3648 : packoffset(c228.x);
  float View_3652 : packoffset(c228.y);
  float View_3656 : packoffset(c228.z);
  float View_3660 : packoffset(c228.w);
  float3 View_3664 : packoffset(c229.x);
  float View_3676 : packoffset(c229.w);
  float3 View_3680 : packoffset(c230.x);
  float View_3692 : packoffset(c230.w);
  float3 View_3696 : packoffset(c231.x);
  float View_3708 : packoffset(c231.w);
  float3 View_3712 : packoffset(c232.x);
  float View_3724 : packoffset(c232.w);
  float View_3728 : packoffset(c233.x);
  float View_3732 : packoffset(c233.y);
  float View_3736 : packoffset(c233.z);
  float View_3740 : packoffset(c233.w);
  float4 View_3744[4] : packoffset(c234.x);
  float4 View_3808[2] : packoffset(c238.x);
  int View_3840 : packoffset(c240.x);
  float View_3844 : packoffset(c240.y);
  float View_3848 : packoffset(c240.z);
  float View_3852 : packoffset(c240.w);
  float4 View_3856 : packoffset(c241.x);
  float2 View_3872 : packoffset(c242.x);
  float View_3880 : packoffset(c242.z);
  float View_3884 : packoffset(c242.w);
  float4 View_3888 : packoffset(c243.x);
  int View_3904 : packoffset(c244.x);
  float View_3908 : packoffset(c244.y);
  float View_3912 : packoffset(c244.z);
  float View_3916 : packoffset(c244.w);
  float4 View_3920 : packoffset(c245.x);
  int View_3936 : packoffset(c246.x);
  int View_3940 : packoffset(c246.y);
  int View_3944 : packoffset(c246.z);
  float View_3948 : packoffset(c246.w);
  float View_3952 : packoffset(c247.x);
  float View_3956 : packoffset(c247.y);
  float View_3960 : packoffset(c247.z);
  float View_3964 : packoffset(c247.w);
  float4 View_3968 : packoffset(c248.x);
  float4 View_3984 : packoffset(c249.x);
  float4 View_4000 : packoffset(c250.x);
  float4 View_4016 : packoffset(c251.x);
  float4 View_4032 : packoffset(c252.x);
  float4 View_4048 : packoffset(c253.x);
  int View_4064 : packoffset(c254.x);
  float View_4068 : packoffset(c254.y);
  float View_4072 : packoffset(c254.z);
  float View_4076 : packoffset(c254.w);
  float4 View_4080 : packoffset(c255.x);
  float4 View_4096 : packoffset(c256.x);
  float View_4112 : packoffset(c257.x);
  float View_4116 : packoffset(c257.y);
  float View_4120 : packoffset(c257.z);
  float View_4124 : packoffset(c257.w);
  int View_4128 : packoffset(c258.x);
  float View_4132 : packoffset(c258.y);
  float View_4136 : packoffset(c258.z);
  float View_4140 : packoffset(c258.w);
  float View_4144 : packoffset(c259.x);
  float View_4148 : packoffset(c259.y);
  float View_4152 : packoffset(c259.z);
  float View_4156 : packoffset(c259.w);
  float4 View_4160 : packoffset(c260.x);
  int View_4176 : packoffset(c261.x);
  int View_4180 : packoffset(c261.y);
  int View_4184 : packoffset(c261.z);
  float View_4188 : packoffset(c261.w);
  float4 View_4192 : packoffset(c262.x);
  float4 View_4208 : packoffset(c263.x);
  float4 View_4224 : packoffset(c264.x);
  float4 View_4240 : packoffset(c265.x);
  float View_4256 : packoffset(c266.x);
  float View_4260 : packoffset(c266.y);
  float View_4264 : packoffset(c266.z);
  float View_4268 : packoffset(c266.w);
  float4 View_4272 : packoffset(c267.x);
  float4 View_4288 : packoffset(c268.x);
  float4 View_4304 : packoffset(c269.x);
  float4 View_4320 : packoffset(c270.x);
  float4 View_4336 : packoffset(c271.x);
  float View_4352 : packoffset(c272.x);
  float View_4356 : packoffset(c272.y);
  float View_4360 : packoffset(c272.z);
  float View_4364 : packoffset(c272.w);
  float4 View_4368 : packoffset(c273.x);
  float4 View_4384 : packoffset(c274.x);
  float View_4400 : packoffset(c275.x);
  float View_4404 : packoffset(c275.y);
  float View_4408 : packoffset(c275.z);
  float View_4412 : packoffset(c275.w);
  float4 View_4416 : packoffset(c276.x);
  float4 View_4432 : packoffset(c277.x);
  float View_4448 : packoffset(c278.x);
  float View_4452 : packoffset(c278.y);
  float View_4456 : packoffset(c278.z);
  float View_4460 : packoffset(c278.w);
  float View_4464 : packoffset(c279.x);
  float View_4468 : packoffset(c279.y);
  float View_4472 : packoffset(c279.z);
  float View_4476 : packoffset(c279.w);
  float View_4480 : packoffset(c280.x);
  float View_4484 : packoffset(c280.y);
  float View_4488 : packoffset(c280.z);
  float View_4492 : packoffset(c280.w);
  float View_4496 : packoffset(c281.x);
  float View_4500 : packoffset(c281.y);
  float View_4504 : packoffset(c281.z);
  float View_4508 : packoffset(c281.w);
  float View_4512 : packoffset(c282.x);
  float View_4516 : packoffset(c282.y);
  float View_4520 : packoffset(c282.z);
  float View_4524 : packoffset(c282.w);
  float View_4528 : packoffset(c283.x);
  float View_4532 : packoffset(c283.y);
  float View_4536 : packoffset(c283.z);
  float View_4540 : packoffset(c283.w);
  float View_4544 : packoffset(c284.x);
  float View_4548 : packoffset(c284.y);
  float View_4552 : packoffset(c284.z);
  float View_4556 : packoffset(c284.w);
  float View_4560 : packoffset(c285.x);
  float View_4564 : packoffset(c285.y);
  float View_4568 : packoffset(c285.z);
  float View_4572 : packoffset(c285.w);
  float View_4576 : packoffset(c286.x);
  float View_4580 : packoffset(c286.y);
  float View_4584 : packoffset(c286.z);
  float View_4588 : packoffset(c286.w);
  float View_4592 : packoffset(c287.x);
  float View_4596 : packoffset(c287.y);
  float View_4600 : packoffset(c287.z);
  float View_4604 : packoffset(c287.w);
  float View_4608 : packoffset(c288.x);
  float View_4612 : packoffset(c288.y);
  float View_4616 : packoffset(c288.z);
  float View_4620 : packoffset(c288.w);
  float View_4624 : packoffset(c289.x);
  float View_4628 : packoffset(c289.y);
  float View_4632 : packoffset(c289.z);
  float View_4636 : packoffset(c289.w);
  float View_4640 : packoffset(c290.x);
  float View_4644 : packoffset(c290.y);
  float View_4648 : packoffset(c290.z);
  float View_4652 : packoffset(c290.w);
  float View_4656 : packoffset(c291.x);
  float View_4660 : packoffset(c291.y);
  float View_4664 : packoffset(c291.z);
  float View_4668 : packoffset(c291.w);
  float View_4672 : packoffset(c292.x);
  float View_4676 : packoffset(c292.y);
  float View_4680 : packoffset(c292.z);
  float View_4684 : packoffset(c292.w);
  float View_4688 : packoffset(c293.x);
  float View_4692 : packoffset(c293.y);
  float View_4696 : packoffset(c293.z);
  float View_4700 : packoffset(c293.w);
  float View_4704 : packoffset(c294.x);
  float View_4708 : packoffset(c294.y);
  float View_4712 : packoffset(c294.z);
  float View_4716 : packoffset(c294.w);
  float View_4720 : packoffset(c295.x);
  float View_4724 : packoffset(c295.y);
  float View_4728 : packoffset(c295.z);
  float View_4732 : packoffset(c295.w);
  float View_4736 : packoffset(c296.x);
  float View_4740 : packoffset(c296.y);
  float View_4744 : packoffset(c296.z);
  float View_4748 : packoffset(c296.w);
  float View_4752 : packoffset(c297.x);
  float View_4756 : packoffset(c297.y);
  float View_4760 : packoffset(c297.z);
  float View_4764 : packoffset(c297.w);
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
  float4 View_5120 : packoffset(c320.x);
  float View_5136 : packoffset(c321.x);
  float View_5140 : packoffset(c321.y);
  float View_5144 : packoffset(c321.z);
  float View_5148 : packoffset(c321.w);
  float4 View_5152 : packoffset(c322.x);
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
  float2 View_5216 : packoffset(c326.x);
  float View_5224 : packoffset(c326.z);
  float View_5228 : packoffset(c326.w);
  float3 View_5232 : packoffset(c327.x);
  float View_5244 : packoffset(c327.w);
  float3 View_5248 : packoffset(c328.x);
  float View_5260 : packoffset(c328.w);
  float3 View_5264 : packoffset(c329.x);
  float View_5276 : packoffset(c329.w);
  float View_5280 : packoffset(c330.x);
  float View_5284 : packoffset(c330.y);
  float View_5288 : packoffset(c330.z);
  float View_5292 : packoffset(c330.w);
  float View_5296 : packoffset(c331.x);
  float View_5300 : packoffset(c331.y);
  float View_5304 : packoffset(c331.z);
  float View_5308 : packoffset(c331.w);
  float4 View_5312 : packoffset(c332.x);
  float3 View_5328 : packoffset(c333.x);
  float View_5340 : packoffset(c333.w);
  float View_5344 : packoffset(c334.x);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

SamplerState s2 : register(s2);

SamplerState s3 : register(s3);

SamplerState s4 : register(s4);

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float4 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 TEXCOORD_2 : TEXCOORD2,
  noperspective float2 TEXCOORD_3 : TEXCOORD3,
  noperspective float2 TEXCOORD_4 : TEXCOORD4,
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _26 = cb0_065x * cb0_064w;
  float _27 = TEXCOORD_3.x * 0.5f;
  float _28 = TEXCOORD_3.y * 0.5f;
  float _99;
  float _100;
  float _108;
  float _109;
  float _207;
  float _208;
  float _209;
  float _231;
  float _238;
  float _245;
  float _252;
  float _287;
  float _288;
  float _289;
  float _324;
  float _325;
  float _326;
  float _352;
  float _353;
  float _375;
  float _405;
  float _406;
  float _502;
  float _503;
  float _504;
  float _533;
  float _534;
  float _535;
  float _694;
  float _695;
  float _696;
  float _728;
  float _729;
  float _730;
  float _777;
  float _778;
  float _779;
  float _836;
  float _839;
  float _840;
  float _841;
  float _876;
  float _877;
  float _878;
  float _991;
  float _992;
  float _993;
  float _1001;
  if (!(!(cb0_085x != 0.0f))) {
    float _33 = cb0_085x * 2.0f;
    do {
      if (_33 > 0.0f) {
        float _37 = abs(_33) * 0.5f;
        float _38 = tan(_37);
        float _39 = _26 * TEXCOORD_3.x;
        float _49 = rsqrt(dot(float2(_39, TEXCOORD_3.y), float2(_39, TEXCOORD_3.y)));
        float _53 = rsqrt(dot(float2(_26, 1.0f), float2(_26, 1.0f)));
        float _58 = tan((sqrt((_39 * _39) + (TEXCOORD_3.y * TEXCOORD_3.y)) / sqrt((_26 * _26) + 1.0f)) * _37);
        _99 = (((_58 * ((_49 * _39) / (_53 * _26))) / _38) * 0.5f);
        _100 = (((_58 * ((_49 * TEXCOORD_3.y) / _53)) / _38) * 0.5f);
      } else {
        if (_33 < 0.0f) {
          float _72 = sqrt(((TEXCOORD_3.y * TEXCOORD_3.y) + (TEXCOORD_3.x * TEXCOORD_3.x)) * 0.25f);
          float _77 = (((_72 * _72) * (cb0_085x * 0.699999988079071f)) + 1.0f) * _72;
          float _79 = atan(_27 / _28);
          bool _82 = (_28 < 0.0f);
          bool _83 = (_28 == 0.0f);
          bool _84 = (_27 >= 0.0f);
          bool _85 = (_27 < 0.0f);
          float _93 = select((_84 && _83), 1.5707963705062866f, select((_85 && _83), -1.5707963705062866f, select((_85 && _82), (_79 + -3.1415927410125732f), select((_84 && _82), (_79 + 3.1415927410125732f), _79))));
          _99 = (sin(_93) * _77);
          _100 = (cos(_93) * _77);
        } else {
          _99 = _27;
          _100 = _28;
        }
      }
      _108 = (((_99 + 0.5f) * 2.0f) + -1.0f);
      _109 = (((_100 + 0.5f) * 2.0f) + -1.0f);
    } while (false);
  } else {
    _108 = TEXCOORD_3.x;
    _109 = TEXCOORD_3.y;
  }
  float _122 = ((cb0_048z * _108) + cb0_049x) * cb0_048x;
  float _123 = ((cb0_048w * _109) + cb0_049y) * cb0_048y;
  float4 _124 = t3.SampleLevel(s3, float2(_122, _123), 0.0f);
  float _136 = ((1.0f / ((View_1040.z * _124.x) - View_1040.w)) + View_1040.y) + (View_1040.x * _124.x);
  float4 _137 = t2.Sample(s2, float2(_122, _123));
  float _145 = 1.0f / ((_136 + View_1040.w) * View_1040.z);
  if (((bool)(!(cb0_080y == 0.0f))) || ((bool)(((bool)(((bool)(((bool)(((bool)(!(cb0_081y == 0.0f))) || ((bool)(!(cb0_085y == 0.0f))))) || ((bool)(!(cb0_086y == 0.0f))))) || ((bool)(!(cb0_087y == 0.0f))))) || ((bool)(!(cb0_088y == 0.0f)))))) {
    float _190 = 1.5f - (saturate(cb0_081z) * 1.4900000095367432f);
    float _195 = saturate(((sqrt((_109 * _109) + (_108 * _108)) - cb0_081y) - _190) / (-0.0f - _190));
    float _199 = (_195 * _195) * (3.0f - (_195 * 2.0f));
    _207 = (1.0f - (_199 * max(cb0_080y, cb0_085y)));
    _208 = (1.0f - (_199 * max(cb0_080y, cb0_086y)));
    _209 = (1.0f - (_199 * max(cb0_080y, cb0_087y)));
  } else {
    _207 = 1.0f;
    _208 = 1.0f;
    _209 = 1.0f;
  }
  bool _215 = !(cb0_080z == 0.0f);
  bool _216 = !(cb0_085z == 0.0f);
  bool _218 = !(cb0_086z == 0.0f);
  bool _220 = !(cb0_087z == 0.0f);
  if (((bool)(((bool)(((bool)(_215 || _216)) || _218)) || _220)) || ((bool)(!(cb0_088z == 0.0f)))) {
    do {
      if (_215) {
        _231 = exp2(log2(saturate(cb0_080z)) * 3.0f);
      } else {
        _231 = cb0_080z;
      }
      do {
        if (_216) {
          _238 = exp2(log2(saturate(cb0_085z)) * 3.0f);
        } else {
          _238 = cb0_085z;
        }
        do {
          if (_218) {
            _245 = exp2(log2(saturate(cb0_086z)) * 3.0f);
          } else {
            _245 = cb0_086z;
          }
          do {
            if (_220) {
              _252 = exp2(log2(saturate(cb0_087z)) * 3.0f);
            } else {
              _252 = cb0_087z;
            }
            float _253 = max(_231, _238);
            float _254 = max(_231, _245);
            float _255 = max(_231, _252);
            float _271 = saturate((_136 - (_253 * 1000.0f)) / ((_253 * 9999.990234375f) + 0.009999999776482582f));
            float _272 = saturate((_136 - (_254 * 1000.0f)) / ((_254 * 9999.990234375f) + 0.009999999776482582f));
            float _273 = saturate((_136 - (_255 * 1000.0f)) / ((_255 * 9999.990234375f) + 0.009999999776482582f));
            _287 = ((_271 * _271) * (3.0f - (_271 * 2.0f)));
            _288 = ((_272 * _272) * (3.0f - (_272 * 2.0f)));
            _289 = ((_273 * _273) * (3.0f - (_273 * 2.0f)));
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _287 = 1.0f;
    _288 = 1.0f;
    _289 = 1.0f;
  }
  if (((bool)(((bool)(((bool)(((bool)(!(cb0_081x == 0.0f))) || ((bool)(!(cb0_086x == 0.0f))))) || ((bool)(!(cb0_087x == 0.0f))))) || ((bool)(!(cb0_088x == 0.0f))))) || ((bool)(!(cb0_089x == 0.0f)))) {
    float _310 = saturate(select((((_145 - _137.x) + ((((View_448[3].z) - _145) + ((View_448[2].z) * _136)) * select(((View_448[3].w) < 1.0f), 0.0f, 1.0f))) > 0.0005000000237487257f), 1.0f, 0.0f) + select((_137.x > 0.0005000000237487257f), 0.0f, 1.0f));
    _324 = max(_310, (1.0f - saturate(max(cb0_081x, cb0_086x))));
    _325 = max(_310, (1.0f - saturate(max(cb0_081x, cb0_087x))));
    _326 = max(_310, (1.0f - saturate(max(cb0_081x, cb0_088x))));
  } else {
    _324 = 1.0f;
    _325 = 1.0f;
    _326 = 1.0f;
  }
  float _328 = (TEXCOORD_2.w * 543.3099975585938f) + TEXCOORD_2.z;
  float _331 = frac(sin(_328) * 493013.0f);
  if (cb0_080x > 0.0f) {
    _352 = (((frac((sin(_328 + 33.9900016784668f) * 493013.0f) + 7.177000045776367f) - _331) * cb0_080x) + _331);
    _353 = (((frac((sin(_328 + 66.98999786376953f) * 493013.0f) + 14.298999786376953f) - _331) * cb0_080x) + _331);
  } else {
    _352 = _331;
    _353 = _331;
  }
  if (cb0_083z > 0.0f) {
    _375 = (((((_289 * _209) * _326) * cb0_083z) * ((sin((((TEXCOORD_3.y * 10.0f) + 10.0f) + (_331 * 0.0020000000949949026f)) + (View_2376 * 4.0f)) * 0.5f) + 0.5f)) + 1.0f);
  } else {
    _375 = 1.0f;
  }
  float _378 = (_288 * _208) * _325;
  if (cb0_083y > 0.0f) {
    float _383 = View_2376 * 0.00016666666488163173f;
    float _387 = frac(abs(_383));
    float _392 = select((_383 >= (-0.0f - _383)), _387, (-0.0f - _387)) * ((TEXCOORD_3.y * 111000.0f) + 111000.0f);
    float _400 = ((_378 * 0.014999999664723873f) * cb0_083y) * (0.5f - frac(sin(dot(float2(_392, _392), float2(12.989800453186035f, 78.23300170898438f))) * 43758.546875f));
    _405 = ((_400 * 0.5f) + _122);
    _406 = (_400 + _123);
  } else {
    _405 = _122;
    _406 = _123;
  }
  float _411 = cb0_079z * (1.0f - (_331 * _331));
  float _416 = (_411 * (TEXCOORD_2.x - _405)) + _405;
  float _417 = (_411 * (TEXCOORD_2.y - _406)) + _406;
  float4 _428 = t0.Sample(s0, float2(min(max(_416, cb0_053z), cb0_054x), min(max(_417, cb0_053w), cb0_054y)));
  float _434 = saturate(cb0_082x);
  float _436 = saturate(cb0_082y);
  if (_434 > 0.0f) {
    float _447 = saturate(((_428.x * 0.29899999499320984f) + (_428.y * 0.5870000123977661f)) + (_428.z * 0.11400000005960464f));
    float _448 = _447 * 2.0f;
    float _452 = ((_447 * saturate(1.0f - cb0_082z)) * _448) * (3.0f - _448);
    float _459 = max(sqrt(((_428.x * _428.x) + (_428.y * _428.y)) + (_428.z * _428.z)), 0.014999999664723873f);
    float _460 = _428.x / _459;
    float _461 = _428.y / _459;
    float _462 = _428.z / _459;
    float _472 = log2(_452);
    float _491 = ((_287 * _207) * _324) * _434;
    _502 = (((((lerp(_460, 1.0f, 0.25f)) * (((_436 * 0.17000000178813934f) + 0.029999999329447746f) + _452)) - _428.x) * _491) + _428.x);
    _503 = (((((((_436 * 0.18000000715255737f) + 0.05000000074505806f) + exp2(_472 * 0.8999999761581421f)) * (lerp(_461, 1.0f, 0.25f))) - _428.y) * _491) + _428.y);
    _504 = (((((((_436 * 0.17999999225139618f) + 0.07999999821186066f) + exp2(_472 * 0.949999988079071f)) * (lerp(_462, 1.0f, 0.25f))) - _428.z) * _491) + _428.z);
  } else {
    _502 = _428.x;
    _503 = _428.y;
    _504 = _428.z;
  }
  float _507 = saturate(cb0_083x);
  float _508 = _507 * _378;
  if (_507 > 0.0f) {
    float _519 = (sin(((_109 * 640.0f) + 640.0f) - (View_2376 * 10.0f)) * 0.5f) + 1.0f;
    _533 = ((((_519 * _502) - _502) * _508) + _502);
    _534 = ((((_519 * _503) - _503) * _508) + _503);
    _535 = ((((_519 * _504) - _504) * _508) + _504);
  } else {
    _533 = _502;
    _534 = _503;
    _535 = _504;
  }

  float4 _560 = t1.Sample(s1, float2(min(max(((cb0_068z * _416) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _417) + cb0_069y), cb0_060w), cb0_061y)));
  _560.rgb *= RENODX_WUWA_BLOOM;

  float _588 = TEXCOORD_1.z + -1.0f;
  float _590 = TEXCOORD_1.w + -1.0f;
  float _593 = (((cb0_074x * 2.0f) + _588) * cb0_072z) * cb0_072x;
  float _595 = (((cb0_074y * 2.0f) + _590) * cb0_072w) * cb0_072x;
  float _602 = 1.0f / ((((saturate(cb0_073w) * 9.0f) + 1.0f) * dot(float2(_593, _595), float2(_593, _595))) + 1.0f);
  float _603 = _602 * _602;
  float _604 = cb0_074z + 1.0f;
  float _632 = (((cb0_077x * 2.0f) + _588) * cb0_075z) * cb0_075x;
  float _634 = (((cb0_077y * 2.0f) + _590) * cb0_075w) * cb0_075x;
  float _641 = 1.0f / ((((saturate(cb0_076w) * 9.0f) + 1.0f) * dot(float2(_632, _634), float2(_632, _634))) + 1.0f);
  float _642 = _641 * _641;
  float _643 = cb0_077z + 1.0f;
  float _655 = (((_560.x + ((_533 * TEXCOORD_1.x) * cb0_070x)) * _375) * ((_603 * (_604 - cb0_073x)) + cb0_073x)) * ((_642 * (_643 - cb0_076x)) + cb0_076x);
  float _658 = (((_560.y + ((_534 * TEXCOORD_1.x) * cb0_070y)) * _375) * ((_603 * (_604 - cb0_073y)) + cb0_073y)) * ((_642 * (_643 - cb0_076y)) + cb0_076y);
  float _661 = (((_560.z + ((_535 * TEXCOORD_1.x) * cb0_070z)) * _375) * ((_603 * (_604 - cb0_073z)) + cb0_073z)) * ((_642 * (_643 - cb0_076z)) + cb0_076z);

  CAPTURE_UNTONEMAPPED(float3(_655, _658, _661));

  [branch]
  if (((uint)(RENODX_WUWA_TM) == 1)) {
    _694 = ((((_655 * 1.3600000143051147f) + 0.04699999839067459f) * _655) / ((((_655 * 0.9599999785423279f) + 0.5600000023841858f) * _655) + 0.14000000059604645f));
    _695 = ((((_658 * 1.3600000143051147f) + 0.04699999839067459f) * _658) / ((((_658 * 0.9599999785423279f) + 0.5600000023841858f) * _658) + 0.14000000059604645f));
    _696 = ((((_661 * 1.3600000143051147f) + 0.04699999839067459f) * _661) / ((((_661 * 0.9599999785423279f) + 0.5600000023841858f) * _661) + 0.14000000059604645f));
  } else {
    _694 = _655;
    _695 = _658;
    _696 = _661;
  }
  [branch]
  if (((uint)(RENODX_WUWA_TM) == 2)) {
    float _706 = 1.0049500465393066f - (0.16398000717163086f / (_694 + -0.19505000114440918f));
    float _707 = 1.0049500465393066f - (0.16398000717163086f / (_695 + -0.19505000114440918f));
    float _708 = 1.0049500465393066f - (0.16398000717163086f / (_696 + -0.19505000114440918f));
    _728 = (((_694 - _706) * select((_694 > 0.6000000238418579f), 0.0f, 1.0f)) + _706);
    _729 = (((_695 - _707) * select((_695 > 0.6000000238418579f), 0.0f, 1.0f)) + _707);
    _730 = (((_696 - _708) * select((_696 > 0.6000000238418579f), 0.0f, 1.0f)) + _708);
  } else {
    _728 = _694;
    _729 = _695;
    _730 = _696;
  }
  [branch]
  if (((uint)(RENODX_WUWA_TM) == 3)) {
    float _736 = cb0_037y * _728;
    float _737 = cb0_037y * _729;
    float _738 = cb0_037y * _730;
    float _741 = cb0_037z * cb0_037w;
    float _751 = cb0_038y * cb0_038x;
    float _762 = cb0_038z * cb0_038x;
    float _769 = cb0_038y / cb0_038z;
    _777 = (((((_741 + _736) * _728) + _751) / (((_736 + cb0_037z) * _728) + _762)) - _769);
    _778 = (((((_741 + _737) * _729) + _751) / (((_737 + cb0_037z) * _729) + _762)) - _769);
    _779 = (((((_741 + _738) * _730) + _751) / (((_738 + cb0_037z) * _730) + _762)) - _769);
  } else {
    _777 = _728;
    _778 = _729;
    _779 = _730;
  }
  [branch]
  if (!((uint)(cb0_089w) == 0)) {
    if (!(cb0_090x == 1.0f)) {
      float _788 = dot(float3(_777, _778, _779), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      if (!(_788 <= 9.999999747378752e-05f)) {
        float _797 = (pow(_777, 0.1593017578125f));
        float _798 = (pow(_778, 0.1593017578125f));
        float _799 = (pow(_779, 0.1593017578125f));
        float _821 = exp2(log2(((_797 * 18.8515625f) + 0.8359375f) / ((_797 * 18.6875f) + 1.0f)) * 78.84375f);
        float _822 = exp2(log2(((_798 * 18.8515625f) + 0.8359375f) / ((_798 * 18.6875f) + 1.0f)) * 78.84375f);
        float _823 = exp2(log2(((_799 * 18.8515625f) + 0.8359375f) / ((_799 * 18.6875f) + 1.0f)) * 78.84375f);
        if ((_788 * 200.0f) > 1.0f) {
          float _827 = 1.0f - cb0_090x;
          do {
            if (_821 > 0.44028136134147644f) {
              float _830 = _821 + -0.44028136134147644f;
              _836 = ((_830 / ((_830 * _827) + 1.0f)) + 0.44028136134147644f);
            } else {
              _836 = _821;
            }
            do {
              if (_822 > 0.44028136134147644f) {
                float _995 = _822 + -0.44028136134147644f;
                _1001 = ((_995 / ((_995 * _827) + 1.0f)) + 0.44028136134147644f);
                if (_823 > 0.44028136134147644f) {
                  float _1004 = _823 + -0.44028136134147644f;
                  _839 = ((_1004 / ((_1004 * _827) + 1.0f)) + 0.44028136134147644f);
                  _840 = _1001;
                  _841 = _836;
                } else {
                  _839 = _823;
                  _840 = _1001;
                  _841 = _836;
                }
              } else {
                _1001 = _822;
                if (_823 > 0.44028136134147644f) {
                  float _1004 = _823 + -0.44028136134147644f;
                  _839 = ((_1004 / ((_1004 * _827) + 1.0f)) + 0.44028136134147644f);
                  _840 = _1001;
                  _841 = _836;
                } else {
                  _839 = _823;
                  _840 = _1001;
                  _841 = _836;
                }
              }
              while(true) {
                float _848 = (pow(_841, 0.012683313339948654f));
                float _849 = (pow(_840, 0.012683313339948654f));
                float _850 = (pow(_839, 0.012683313339948654f));
                _876 = exp2(log2(max((_848 + -0.8359375f), 0.0f) / (18.8515625f - (_848 * 18.6875f))) * 6.277394771575928f);
                _877 = exp2(log2(max((_849 + -0.8359375f), 0.0f) / (18.8515625f - (_849 * 18.6875f))) * 6.277394771575928f);
                _878 = exp2(log2(max((_850 + -0.8359375f), 0.0f) / (18.8515625f - (_850 * 18.6875f))) * 6.277394771575928f);
                break;
              }
            } while (false);
          } while (false);
        } else {
          _839 = _823;
          _840 = _822;
          _841 = _821;
          while(true) {
            float _848 = (pow(_841, 0.012683313339948654f));
            float _849 = (pow(_840, 0.012683313339948654f));
            float _850 = (pow(_839, 0.012683313339948654f));
            _876 = exp2(log2(max((_848 + -0.8359375f), 0.0f) / (18.8515625f - (_848 * 18.6875f))) * 6.277394771575928f);
            _877 = exp2(log2(max((_849 + -0.8359375f), 0.0f) / (18.8515625f - (_849 * 18.6875f))) * 6.277394771575928f);
            _878 = exp2(log2(max((_850 + -0.8359375f), 0.0f) / (18.8515625f - (_850 * 18.6875f))) * 6.277394771575928f);
            break;
          }
        }
      } else {
        _876 = _777;
        _877 = _778;
        _878 = _779;
      }
    } else {
      _876 = _777;
      _877 = _778;
      _878 = _779;
    }
  } else {
    _876 = _777;
    _877 = _778;
    _878 = _779;
  }

  CLAMP_IF_SDR(_876); CLAMP_IF_SDR(_877); CLAMP_IF_SDR(_878);
  CAPTURE_TONEMAPPED(float3(_876, _877, _878));

  float4 _900 = t4.Sample(s4, float3(((saturate((log2(_876 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_877 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_878 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f)));
  _900.rgb = HandleLUTOutput(_900.rgb, untonemapped, tonemapped);

  float _904 = _900.x * 1.0499999523162842f;
  float _905 = _900.y * 1.0499999523162842f;
  float _906 = _900.z * 1.0499999523162842f;
  float _914 = ((_331 * 0.00390625f) + -0.001953125f) + _904;
  float _915 = ((_352 * 0.00390625f) + -0.001953125f) + _905;
  float _916 = ((_353 * 0.00390625f) + -0.001953125f) + _906;
  [branch]
  if (!((uint)(cb0_090w) == 0)) {
    float _928 = (pow(_914, 0.012683313339948654f));
    float _929 = (pow(_915, 0.012683313339948654f));
    float _930 = (pow(_916, 0.012683313339948654f));
    float _963 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_928 + -0.8359375f)) / (18.8515625f - (_928 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_090z));
    float _964 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_929 + -0.8359375f)) / (18.8515625f - (_929 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_090z));
    float _965 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_930 + -0.8359375f)) / (18.8515625f - (_930 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_090z));
    _991 = min((_963 * 12.920000076293945f), ((exp2(log2(max(_963, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _992 = min((_964 * 12.920000076293945f), ((exp2(log2(max(_964, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _993 = min((_965 * 12.920000076293945f), ((exp2(log2(max(_965, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _991 = _914;
    _992 = _915;
    _993 = _916;
  }
  SV_Target.x = _991;
  SV_Target.y = _992;
  SV_Target.z = _993;

  SV_Target.w = (dot(float3(_904, _905, _906), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);

  return SV_Target;
}
