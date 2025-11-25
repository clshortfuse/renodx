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
  float _24 = cb0_065x * cb0_064w;
  float _25 = TEXCOORD_3.x * 0.5f;
  float _26 = TEXCOORD_3.y * 0.5f;
  float _97;
  float _98;
  float _106;
  float _107;
  float _205;
  float _206;
  float _207;
  float _229;
  float _236;
  float _243;
  float _250;
  float _285;
  float _286;
  float _287;
  float _322;
  float _323;
  float _324;
  float _350;
  float _351;
  float _373;
  float _403;
  float _404;
  float _479;
  float _480;
  float _481;
  float _509;
  float _510;
  float _511;
  float _670;
  float _671;
  float _672;
  float _704;
  float _705;
  float _706;
  float _753;
  float _754;
  float _755;
  float _812;
  float _815;
  float _816;
  float _817;
  float _852;
  float _853;
  float _854;
  float _967;
  float _968;
  float _969;
  float _977;
  if (!(!(cb0_085x != 0.0f))) {
    float _31 = cb0_085x * 2.0f;
    do {
      if (_31 > 0.0f) {
        float _35 = abs(_31) * 0.5f;
        float _36 = tan(_35);
        float _37 = _24 * TEXCOORD_3.x;
        float _47 = rsqrt(dot(float2(_37, TEXCOORD_3.y), float2(_37, TEXCOORD_3.y)));
        float _51 = rsqrt(dot(float2(_24, 1.0f), float2(_24, 1.0f)));
        float _56 = tan((sqrt((_37 * _37) + (TEXCOORD_3.y * TEXCOORD_3.y)) / sqrt((_24 * _24) + 1.0f)) * _35);
        _97 = (((_56 * ((_47 * _37) / (_51 * _24))) / _36) * 0.5f);
        _98 = (((_56 * ((_47 * TEXCOORD_3.y) / _51)) / _36) * 0.5f);
      } else {
        if (_31 < 0.0f) {
          float _70 = sqrt(((TEXCOORD_3.y * TEXCOORD_3.y) + (TEXCOORD_3.x * TEXCOORD_3.x)) * 0.25f);
          float _75 = (((_70 * _70) * (cb0_085x * 0.699999988079071f)) + 1.0f) * _70;
          float _77 = atan(_25 / _26);
          bool _80 = (_26 < 0.0f);
          bool _81 = (_26 == 0.0f);
          bool _82 = (_25 >= 0.0f);
          bool _83 = (_25 < 0.0f);
          float _91 = select((_82 && _81), 1.5707963705062866f, select((_83 && _81), -1.5707963705062866f, select((_83 && _80), (_77 + -3.1415927410125732f), select((_82 && _80), (_77 + 3.1415927410125732f), _77))));
          _97 = (sin(_91) * _75);
          _98 = (cos(_91) * _75);
        } else {
          _97 = _25;
          _98 = _26;
        }
      }
      _106 = (((_97 + 0.5f) * 2.0f) + -1.0f);
      _107 = (((_98 + 0.5f) * 2.0f) + -1.0f);
    } while (false);
  } else {
    _106 = TEXCOORD_3.x;
    _107 = TEXCOORD_3.y;
  }
  float _120 = ((cb0_048z * _106) + cb0_049x) * cb0_048x;
  float _121 = ((cb0_048w * _107) + cb0_049y) * cb0_048y;
  float4 _122 = t3.SampleLevel(s3, float2(_120, _121), 0.0f);
  float _134 = ((1.0f / ((View_1040.z * _122.x) - View_1040.w)) + View_1040.y) + (View_1040.x * _122.x);
  float4 _135 = t2.Sample(s2, float2(_120, _121));
  float _143 = 1.0f / ((_134 + View_1040.w) * View_1040.z);
  if (((bool)(!(cb0_080y == 0.0f))) || ((bool)(((bool)(((bool)(((bool)(((bool)(!(cb0_081y == 0.0f))) || ((bool)(!(cb0_085y == 0.0f))))) || ((bool)(!(cb0_086y == 0.0f))))) || ((bool)(!(cb0_087y == 0.0f))))) || ((bool)(!(cb0_088y == 0.0f)))))) {
    float _188 = 1.5f - (saturate(cb0_081z) * 1.4900000095367432f);
    float _193 = saturate(((sqrt((_107 * _107) + (_106 * _106)) - cb0_081y) - _188) / (-0.0f - _188));
    float _197 = (_193 * _193) * (3.0f - (_193 * 2.0f));
    _205 = (1.0f - (_197 * max(cb0_080y, cb0_085y)));
    _206 = (1.0f - (_197 * max(cb0_080y, cb0_086y)));
    _207 = (1.0f - (_197 * max(cb0_080y, cb0_087y)));
  } else {
    _205 = 1.0f;
    _206 = 1.0f;
    _207 = 1.0f;
  }
  bool _213 = !(cb0_080z == 0.0f);
  bool _214 = !(cb0_085z == 0.0f);
  bool _216 = !(cb0_086z == 0.0f);
  bool _218 = !(cb0_087z == 0.0f);
  if (((bool)(((bool)(((bool)(_213 || _214)) || _216)) || _218)) || ((bool)(!(cb0_088z == 0.0f)))) {
    do {
      if (_213) {
        _229 = exp2(log2(saturate(cb0_080z)) * 3.0f);
      } else {
        _229 = cb0_080z;
      }
      do {
        if (_214) {
          _236 = exp2(log2(saturate(cb0_085z)) * 3.0f);
        } else {
          _236 = cb0_085z;
        }
        do {
          if (_216) {
            _243 = exp2(log2(saturate(cb0_086z)) * 3.0f);
          } else {
            _243 = cb0_086z;
          }
          do {
            if (_218) {
              _250 = exp2(log2(saturate(cb0_087z)) * 3.0f);
            } else {
              _250 = cb0_087z;
            }
            float _251 = max(_229, _236);
            float _252 = max(_229, _243);
            float _253 = max(_229, _250);
            float _269 = saturate((_134 - (_251 * 1000.0f)) / ((_251 * 9999.990234375f) + 0.009999999776482582f));
            float _270 = saturate((_134 - (_252 * 1000.0f)) / ((_252 * 9999.990234375f) + 0.009999999776482582f));
            float _271 = saturate((_134 - (_253 * 1000.0f)) / ((_253 * 9999.990234375f) + 0.009999999776482582f));
            _285 = ((_269 * _269) * (3.0f - (_269 * 2.0f)));
            _286 = ((_270 * _270) * (3.0f - (_270 * 2.0f)));
            _287 = ((_271 * _271) * (3.0f - (_271 * 2.0f)));
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _285 = 1.0f;
    _286 = 1.0f;
    _287 = 1.0f;
  }
  if (((bool)(((bool)(((bool)(((bool)(!(cb0_081x == 0.0f))) || ((bool)(!(cb0_086x == 0.0f))))) || ((bool)(!(cb0_087x == 0.0f))))) || ((bool)(!(cb0_088x == 0.0f))))) || ((bool)(!(cb0_089x == 0.0f)))) {
    float _308 = saturate(select((((_143 - _135.x) + ((((View_448[3].z) - _143) + ((View_448[2].z) * _134)) * select(((View_448[3].w) < 1.0f), 0.0f, 1.0f))) > 0.0005000000237487257f), 1.0f, 0.0f) + select((_135.x > 0.0005000000237487257f), 0.0f, 1.0f));
    _322 = max(_308, (1.0f - saturate(max(cb0_081x, cb0_086x))));
    _323 = max(_308, (1.0f - saturate(max(cb0_081x, cb0_087x))));
    _324 = max(_308, (1.0f - saturate(max(cb0_081x, cb0_088x))));
  } else {
    _322 = 1.0f;
    _323 = 1.0f;
    _324 = 1.0f;
  }
  float _326 = (TEXCOORD_2.w * 543.3099975585938f) + TEXCOORD_2.z;
  float _329 = frac(sin(_326) * 493013.0f);
  if (cb0_080x > 0.0f) {
    _350 = (((frac((sin(_326 + 33.9900016784668f) * 493013.0f) + 7.177000045776367f) - _329) * cb0_080x) + _329);
    _351 = (((frac((sin(_326 + 66.98999786376953f) * 493013.0f) + 14.298999786376953f) - _329) * cb0_080x) + _329);
  } else {
    _350 = _329;
    _351 = _329;
  }
  if (cb0_083z > 0.0f) {
    _373 = (((((_287 * _207) * _324) * cb0_083z) * ((sin((((TEXCOORD_3.y * 10.0f) + 10.0f) + (_329 * 0.0020000000949949026f)) + (View_2376 * 4.0f)) * 0.5f) + 0.5f)) + 1.0f);
  } else {
    _373 = 1.0f;
  }
  float _376 = (_286 * _206) * _323;
  if (cb0_083y > 0.0f) {
    float _381 = View_2376 * 0.00016666666488163173f;
    float _385 = frac(abs(_381));
    float _390 = select((_381 >= (-0.0f - _381)), _385, (-0.0f - _385)) * ((TEXCOORD_3.y * 111000.0f) + 111000.0f);
    float _398 = ((_376 * 0.014999999664723873f) * cb0_083y) * (0.5f - frac(sin(dot(float2(_390, _390), float2(12.989800453186035f, 78.23300170898438f))) * 43758.546875f));
    _403 = ((_398 * 0.5f) + _120);
    _404 = (_398 + _121);
  } else {
    _403 = _120;
    _404 = _121;
  }
  float4 _405 = t0.Sample(s0, float2(_403, _404));
  float _411 = saturate(cb0_082x);
  float _413 = saturate(cb0_082y);
  if (_411 > 0.0f) {
    float _424 = saturate(((_405.x * 0.29899999499320984f) + (_405.y * 0.5870000123977661f)) + (_405.z * 0.11400000005960464f));
    float _425 = _424 * 2.0f;
    float _429 = ((_424 * saturate(1.0f - cb0_082z)) * _425) * (3.0f - _425);
    float _436 = max(sqrt(((_405.x * _405.x) + (_405.y * _405.y)) + (_405.z * _405.z)), 0.014999999664723873f);
    float _437 = _405.x / _436;
    float _438 = _405.y / _436;
    float _439 = _405.z / _436;
    float _449 = log2(_429);
    float _468 = ((_285 * _205) * _322) * _411;
    _479 = (((((lerp(_437, 1.0f, 0.25f)) * (((_413 * 0.17000000178813934f) + 0.029999999329447746f) + _429)) - _405.x) * _468) + _405.x);
    _480 = (((((((_413 * 0.18000000715255737f) + 0.05000000074505806f) + exp2(_449 * 0.8999999761581421f)) * (lerp(_438, 1.0f, 0.25f))) - _405.y) * _468) + _405.y);
    _481 = (((((((_413 * 0.17999999225139618f) + 0.07999999821186066f) + exp2(_449 * 0.949999988079071f)) * (lerp(_439, 1.0f, 0.25f))) - _405.z) * _468) + _405.z);
  } else {
    _479 = _405.x;
    _480 = _405.y;
    _481 = _405.z;
  }
  float _483 = saturate(cb0_083x);
  float _484 = _483 * _376;
  if (_483 > 0.0f) {
    float _495 = (sin(((_107 * 640.0f) + 640.0f) - (View_2376 * 10.0f)) * 0.5f) + 1.0f;
    _509 = ((((_495 * _479) - _479) * _484) + _479);
    _510 = ((((_495 * _480) - _480) * _484) + _480);
    _511 = ((((_495 * _481) - _481) * _484) + _481);
  } else {
    _509 = _479;
    _510 = _480;
    _511 = _481;
  }

  float4 _536 = t1.Sample(s1, float2(min(max(((cb0_068z * _403) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _404) + cb0_069y), cb0_060w), cb0_061y)));
  _536.rgb *= RENODX_WUWA_BLOOM;

  float _564 = TEXCOORD_1.z + -1.0f;
  float _566 = TEXCOORD_1.w + -1.0f;
  float _569 = (((cb0_074x * 2.0f) + _564) * cb0_072z) * cb0_072x;
  float _571 = (((cb0_074y * 2.0f) + _566) * cb0_072w) * cb0_072x;
  float _578 = 1.0f / ((((saturate(cb0_073w) * 9.0f) + 1.0f) * dot(float2(_569, _571), float2(_569, _571))) + 1.0f);
  float _579 = _578 * _578;
  float _580 = cb0_074z + 1.0f;
  float _608 = (((cb0_077x * 2.0f) + _564) * cb0_075z) * cb0_075x;
  float _610 = (((cb0_077y * 2.0f) + _566) * cb0_075w) * cb0_075x;
  float _617 = 1.0f / ((((saturate(cb0_076w) * 9.0f) + 1.0f) * dot(float2(_608, _610), float2(_608, _610))) + 1.0f);
  float _618 = _617 * _617;
  float _619 = cb0_077z + 1.0f;
  float _631 = (((_536.x + ((_509 * TEXCOORD_1.x) * cb0_070x)) * _373) * ((_579 * (_580 - cb0_073x)) + cb0_073x)) * ((_618 * (_619 - cb0_076x)) + cb0_076x);
  float _634 = (((_536.y + ((_510 * TEXCOORD_1.x) * cb0_070y)) * _373) * ((_579 * (_580 - cb0_073y)) + cb0_073y)) * ((_618 * (_619 - cb0_076y)) + cb0_076y);
  float _637 = (((_536.z + ((_511 * TEXCOORD_1.x) * cb0_070z)) * _373) * ((_579 * (_580 - cb0_073z)) + cb0_073z)) * ((_618 * (_619 - cb0_076z)) + cb0_076z);

  CAPTURE_UNTONEMAPPED(float3(_631, _634, _637));

  [branch]
  if (((uint)(RENODX_WUWA_TM) == 1)) {
    _670 = ((((_631 * 1.3600000143051147f) + 0.04699999839067459f) * _631) / ((((_631 * 0.9599999785423279f) + 0.5600000023841858f) * _631) + 0.14000000059604645f));
    _671 = ((((_634 * 1.3600000143051147f) + 0.04699999839067459f) * _634) / ((((_634 * 0.9599999785423279f) + 0.5600000023841858f) * _634) + 0.14000000059604645f));
    _672 = ((((_637 * 1.3600000143051147f) + 0.04699999839067459f) * _637) / ((((_637 * 0.9599999785423279f) + 0.5600000023841858f) * _637) + 0.14000000059604645f));
  } else {
    _670 = _631;
    _671 = _634;
    _672 = _637;
  }
  [branch]
  if (((uint)(RENODX_WUWA_TM) == 2)) {
    float _682 = 1.0049500465393066f - (0.16398000717163086f / (_670 + -0.19505000114440918f));
    float _683 = 1.0049500465393066f - (0.16398000717163086f / (_671 + -0.19505000114440918f));
    float _684 = 1.0049500465393066f - (0.16398000717163086f / (_672 + -0.19505000114440918f));
    _704 = (((_670 - _682) * select((_670 > 0.6000000238418579f), 0.0f, 1.0f)) + _682);
    _705 = (((_671 - _683) * select((_671 > 0.6000000238418579f), 0.0f, 1.0f)) + _683);
    _706 = (((_672 - _684) * select((_672 > 0.6000000238418579f), 0.0f, 1.0f)) + _684);
  } else {
    _704 = _670;
    _705 = _671;
    _706 = _672;
  }
  [branch]
  if (((uint)(RENODX_WUWA_TM) == 3)) {
    float _712 = cb0_037y * _704;
    float _713 = cb0_037y * _705;
    float _714 = cb0_037y * _706;
    float _717 = cb0_037z * cb0_037w;
    float _727 = cb0_038y * cb0_038x;
    float _738 = cb0_038z * cb0_038x;
    float _745 = cb0_038y / cb0_038z;
    _753 = (((((_717 + _712) * _704) + _727) / (((_712 + cb0_037z) * _704) + _738)) - _745);
    _754 = (((((_717 + _713) * _705) + _727) / (((_713 + cb0_037z) * _705) + _738)) - _745);
    _755 = (((((_717 + _714) * _706) + _727) / (((_714 + cb0_037z) * _706) + _738)) - _745);
  } else {
    _753 = _704;
    _754 = _705;
    _755 = _706;
  }
  [branch]
  if (!((uint)(cb0_089w) == 0)) {
    if (!(cb0_090x == 1.0f)) {
      float _764 = dot(float3(_753, _754, _755), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      if (!(_764 <= 9.999999747378752e-05f)) {
        float _773 = (pow(_753, 0.1593017578125f));
        float _774 = (pow(_754, 0.1593017578125f));
        float _775 = (pow(_755, 0.1593017578125f));
        float _797 = exp2(log2(((_773 * 18.8515625f) + 0.8359375f) / ((_773 * 18.6875f) + 1.0f)) * 78.84375f);
        float _798 = exp2(log2(((_774 * 18.8515625f) + 0.8359375f) / ((_774 * 18.6875f) + 1.0f)) * 78.84375f);
        float _799 = exp2(log2(((_775 * 18.8515625f) + 0.8359375f) / ((_775 * 18.6875f) + 1.0f)) * 78.84375f);
        if ((_764 * 200.0f) > 1.0f) {
          float _803 = 1.0f - cb0_090x;
          do {
            if (_797 > 0.44028136134147644f) {
              float _806 = _797 + -0.44028136134147644f;
              _812 = ((_806 / ((_806 * _803) + 1.0f)) + 0.44028136134147644f);
            } else {
              _812 = _797;
            }
            do {
              if (_798 > 0.44028136134147644f) {
                float _971 = _798 + -0.44028136134147644f;
                _977 = ((_971 / ((_971 * _803) + 1.0f)) + 0.44028136134147644f);
                if (_799 > 0.44028136134147644f) {
                  float _980 = _799 + -0.44028136134147644f;
                  _815 = ((_980 / ((_980 * _803) + 1.0f)) + 0.44028136134147644f);
                  _816 = _977;
                  _817 = _812;
                } else {
                  _815 = _799;
                  _816 = _977;
                  _817 = _812;
                }
              } else {
                _977 = _798;
                if (_799 > 0.44028136134147644f) {
                  float _980 = _799 + -0.44028136134147644f;
                  _815 = ((_980 / ((_980 * _803) + 1.0f)) + 0.44028136134147644f);
                  _816 = _977;
                  _817 = _812;
                } else {
                  _815 = _799;
                  _816 = _977;
                  _817 = _812;
                }
              }
              while(true) {
                float _824 = (pow(_817, 0.012683313339948654f));
                float _825 = (pow(_816, 0.012683313339948654f));
                float _826 = (pow(_815, 0.012683313339948654f));
                _852 = exp2(log2(max((_824 + -0.8359375f), 0.0f) / (18.8515625f - (_824 * 18.6875f))) * 6.277394771575928f);
                _853 = exp2(log2(max((_825 + -0.8359375f), 0.0f) / (18.8515625f - (_825 * 18.6875f))) * 6.277394771575928f);
                _854 = exp2(log2(max((_826 + -0.8359375f), 0.0f) / (18.8515625f - (_826 * 18.6875f))) * 6.277394771575928f);
                break;
              }
            } while (false);
          } while (false);
        } else {
          _815 = _799;
          _816 = _798;
          _817 = _797;
          while(true) {
            float _824 = (pow(_817, 0.012683313339948654f));
            float _825 = (pow(_816, 0.012683313339948654f));
            float _826 = (pow(_815, 0.012683313339948654f));
            _852 = exp2(log2(max((_824 + -0.8359375f), 0.0f) / (18.8515625f - (_824 * 18.6875f))) * 6.277394771575928f);
            _853 = exp2(log2(max((_825 + -0.8359375f), 0.0f) / (18.8515625f - (_825 * 18.6875f))) * 6.277394771575928f);
            _854 = exp2(log2(max((_826 + -0.8359375f), 0.0f) / (18.8515625f - (_826 * 18.6875f))) * 6.277394771575928f);
            break;
          }
        }
      } else {
        _852 = _753;
        _853 = _754;
        _854 = _755;
      }
    } else {
      _852 = _753;
      _853 = _754;
      _854 = _755;
    }
  } else {
    _852 = _753;
    _853 = _754;
    _854 = _755;
  }

  CLAMP_IF_SDR(_852); CLAMP_IF_SDR(_853); CLAMP_IF_SDR(_854);
  CAPTURE_TONEMAPPED(float3(_852, _853, _854));

  float4 _876 = t4.Sample(s4, float3(((saturate((log2(_852 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_853 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_854 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f)));
  _876.rgb = HandleLUTOutput(_876.rgb, untonemapped, tonemapped);

  float _880 = _876.x * 1.0499999523162842f;
  float _881 = _876.y * 1.0499999523162842f;
  float _882 = _876.z * 1.0499999523162842f;
  float _890 = ((_329 * 0.00390625f) + -0.001953125f) + _880;
  float _891 = ((_350 * 0.00390625f) + -0.001953125f) + _881;
  float _892 = ((_351 * 0.00390625f) + -0.001953125f) + _882;
  [branch]
  if (!((uint)(cb0_090w) == 0)) {
    float _904 = (pow(_890, 0.012683313339948654f));
    float _905 = (pow(_891, 0.012683313339948654f));
    float _906 = (pow(_892, 0.012683313339948654f));
    float _939 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_904 + -0.8359375f)) / (18.8515625f - (_904 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_090z));
    float _940 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_905 + -0.8359375f)) / (18.8515625f - (_905 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_090z));
    float _941 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_906 + -0.8359375f)) / (18.8515625f - (_906 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_090z));
    _967 = min((_939 * 12.920000076293945f), ((exp2(log2(max(_939, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _968 = min((_940 * 12.920000076293945f), ((exp2(log2(max(_940, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _969 = min((_941 * 12.920000076293945f), ((exp2(log2(max(_941, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _967 = _890;
    _968 = _891;
    _969 = _892;
  }
  SV_Target.x = _967;
  SV_Target.y = _968;
  SV_Target.z = _969;

  SV_Target.w = (dot(float3(_880, _881, _882), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);

  return SV_Target;
}
