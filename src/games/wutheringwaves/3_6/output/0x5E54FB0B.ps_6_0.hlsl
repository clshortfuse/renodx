#include "../../common.hlsli"
Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t6 : register(t6);

Texture3D<float4> t7 : register(t7);

Texture2D<float4> t8 : register(t8);

Texture3D<float4> t9 : register(t9);

Texture3D<float4> t10 : register(t10);

cbuffer cb0 : register(b0) {
  float cb0_037y : packoffset(c037.y);
  float cb0_037z : packoffset(c037.z);
  float cb0_037w : packoffset(c037.w);
  float cb0_038x : packoffset(c038.x);
  float cb0_038y : packoffset(c038.y);
  float cb0_038z : packoffset(c038.z);
  float cb0_041x : packoffset(c041.x);
  float cb0_041y : packoffset(c041.y);
  float cb0_041z : packoffset(c041.z);
  float cb0_042y : packoffset(c042.y);
  float cb0_042z : packoffset(c042.z);
  float cb0_042w : packoffset(c042.w);
  float cb0_044z : packoffset(c044.z);
  float cb0_044w : packoffset(c044.w);
  float cb0_045x : packoffset(c045.x);
  float cb0_045y : packoffset(c045.y);
  float cb0_045z : packoffset(c045.z);
  float cb0_046x : packoffset(c046.x);
  float cb0_046y : packoffset(c046.y);
  float cb0_046z : packoffset(c046.z);
  float cb0_046w : packoffset(c046.w);
  float cb0_047z : packoffset(c047.z);
  float cb0_047w : packoffset(c047.w);
  float cb0_048x : packoffset(c048.x);
  float cb0_048y : packoffset(c048.y);
  float cb0_048z : packoffset(c048.z);
  float cb0_048w : packoffset(c048.w);
  float cb0_060x : packoffset(c060.x);
  float cb0_060y : packoffset(c060.y);
  float cb0_060z : packoffset(c060.z);
  float cb0_060w : packoffset(c060.w);
  float cb0_064y : packoffset(c064.y);
  float cb0_064z : packoffset(c064.z);
  float cb0_068x : packoffset(c068.x);
  float cb0_068y : packoffset(c068.y);
  float cb0_068z : packoffset(c068.z);
  float cb0_068w : packoffset(c068.w);
  float cb0_075x : packoffset(c075.x);
  float cb0_075y : packoffset(c075.y);
  float cb0_075z : packoffset(c075.z);
  float cb0_075w : packoffset(c075.w);
  float cb0_076x : packoffset(c076.x);
  float cb0_076y : packoffset(c076.y);
  float cb0_076z : packoffset(c076.z);
  float cb0_076w : packoffset(c076.w);
  float cb0_083x : packoffset(c083.x);
  float cb0_083y : packoffset(c083.y);
  float cb0_083z : packoffset(c083.z);
  float cb0_083w : packoffset(c083.w);
  float cb0_084x : packoffset(c084.x);
  float cb0_084y : packoffset(c084.y);
  float cb0_084z : packoffset(c084.z);
  float cb0_084w : packoffset(c084.w);
  int cb0_085x : packoffset(c085.x);
  int cb0_085y : packoffset(c085.y);
  int cb0_085z : packoffset(c085.z);
  float cb0_086x : packoffset(c086.x);
  float cb0_086y : packoffset(c086.y);
  float cb0_086z : packoffset(c086.z);
  float cb0_088x : packoffset(c088.x);
  float cb0_088z : packoffset(c088.z);
  float cb0_088w : packoffset(c088.w);
  float cb0_089x : packoffset(c089.x);
  float cb0_089y : packoffset(c089.y);
  float cb0_089z : packoffset(c089.z);
  float cb0_089w : packoffset(c089.w);
  float cb0_090x : packoffset(c090.x);
  float cb0_090y : packoffset(c090.y);
  float cb0_090z : packoffset(c090.z);
  float cb0_091x : packoffset(c091.x);
  float cb0_091z : packoffset(c091.z);
  float cb0_091w : packoffset(c091.w);
  float cb0_092x : packoffset(c092.x);
  float cb0_092y : packoffset(c092.y);
  float cb0_092z : packoffset(c092.z);
  float cb0_092w : packoffset(c092.w);
  float cb0_093x : packoffset(c093.x);
  float cb0_093y : packoffset(c093.y);
  float cb0_093z : packoffset(c093.z);
  float cb0_096x : packoffset(c096.x);
  float cb0_096y : packoffset(c096.y);
  float cb0_096z : packoffset(c096.z);
  float cb0_097x : packoffset(c097.x);
  float cb0_097y : packoffset(c097.y);
  float cb0_097z : packoffset(c097.z);
  float cb0_098x : packoffset(c098.x);
  float cb0_098y : packoffset(c098.y);
  float cb0_098z : packoffset(c098.z);
  float cb0_099x : packoffset(c099.x);
  float cb0_099y : packoffset(c099.y);
  float cb0_099z : packoffset(c099.z);
  float cb0_101x : packoffset(c101.x);
  float cb0_101y : packoffset(c101.y);
  float cb0_101z : packoffset(c101.z);
  float cb0_102x : packoffset(c102.x);
  float cb0_102y : packoffset(c102.y);
  float cb0_102z : packoffset(c102.z);
  float cb0_103x : packoffset(c103.x);
  float cb0_103y : packoffset(c103.y);
  float cb0_103z : packoffset(c103.z);
  float cb0_104x : packoffset(c104.x);
  float cb0_104y : packoffset(c104.y);
  float cb0_104z : packoffset(c104.z);
  float cb0_105x : packoffset(c105.x);
  int cb0_105w : packoffset(c105.w);
  float cb0_106x : packoffset(c106.x);
  float cb0_106z : packoffset(c106.z);
  int cb0_106w : packoffset(c106.w);
  int cb0_107x : packoffset(c107.x);
  int cb0_107y : packoffset(c107.y);
  int cb0_107z : packoffset(c107.z);
  int cb0_107w : packoffset(c107.w);
  float cb0_113x : packoffset(c113.x);
  float cb0_113y : packoffset(c113.y);
  float cb0_113z : packoffset(c113.z);
  float cb0_113w : packoffset(c113.w);
  float cb0_114x : packoffset(c114.x);
  float cb0_114y : packoffset(c114.y);
  float cb0_114z : packoffset(c114.z);
  float cb0_114w : packoffset(c114.w);
  float cb0_116x : packoffset(c116.x);
  float cb0_116y : packoffset(c116.y);
  float cb0_116z : packoffset(c116.z);
  float cb0_117x : packoffset(c117.x);
  float cb0_117y : packoffset(c117.y);
  float cb0_117z : packoffset(c117.z);
  float cb0_117w : packoffset(c117.w);
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
  int View_4180 : packoffset(c261.y);
  int View_4184 : packoffset(c261.z);
  int View_4188 : packoffset(c261.w);
  int View_4192 : packoffset(c262.x);
  float View_4196 : packoffset(c262.y);
  float View_4200 : packoffset(c262.z);
  float View_4204 : packoffset(c262.w);
  float4 View_4208 : packoffset(c263.x);
  float2 View_4224 : packoffset(c264.x);
  float View_4232 : packoffset(c264.z);
  float View_4236 : packoffset(c264.w);
  float4 View_4240 : packoffset(c265.x);
  int View_4256 : packoffset(c266.x);
  float View_4260 : packoffset(c266.y);
  float View_4264 : packoffset(c266.z);
  float View_4268 : packoffset(c266.w);
  float4 View_4272 : packoffset(c267.x);
  int View_4288 : packoffset(c268.x);
  int View_4292 : packoffset(c268.y);
  int View_4296 : packoffset(c268.z);
  float View_4300 : packoffset(c268.w);
  float View_4304 : packoffset(c269.x);
  float View_4308 : packoffset(c269.y);
  float View_4312 : packoffset(c269.z);
  float View_4316 : packoffset(c269.w);
  float4 View_4320 : packoffset(c270.x);
  float4 View_4336 : packoffset(c271.x);
  float4 View_4352 : packoffset(c272.x);
  float4 View_4368 : packoffset(c273.x);
  float4 View_4384 : packoffset(c274.x);
  float4 View_4400 : packoffset(c275.x);
  int View_4416 : packoffset(c276.x);
  float View_4420 : packoffset(c276.y);
  float View_4424 : packoffset(c276.z);
  float View_4428 : packoffset(c276.w);
  float4 View_4432 : packoffset(c277.x);
  float4 View_4448 : packoffset(c278.x);
  float View_4464 : packoffset(c279.x);
  float View_4468 : packoffset(c279.y);
  float View_4472 : packoffset(c279.z);
  float View_4476 : packoffset(c279.w);
  float View_4480 : packoffset(c280.x);
  int View_4484 : packoffset(c280.y);
  float View_4488 : packoffset(c280.z);
  float View_4492 : packoffset(c280.w);
  float4 View_4496 : packoffset(c281.x);
  float4 View_4512 : packoffset(c282.x);
  float View_4528 : packoffset(c283.x);
  float View_4532 : packoffset(c283.y);
  float View_4536 : packoffset(c283.z);
  float View_4540 : packoffset(c283.w);
  float View_4544 : packoffset(c284.x);
  float View_4548 : packoffset(c284.y);
  float View_4552 : packoffset(c284.z);
  float View_4556 : packoffset(c284.w);
  float4 View_4560 : packoffset(c285.x);
  int View_4576 : packoffset(c286.x);
  int View_4580 : packoffset(c286.y);
  int View_4584 : packoffset(c286.z);
  float View_4588 : packoffset(c286.w);
  float View_4592 : packoffset(c287.x);
  float View_4596 : packoffset(c287.y);
  float View_4600 : packoffset(c287.z);
  float View_4604 : packoffset(c287.w);
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
  float4 View_4768 : packoffset(c298.x);
  float4 View_4784 : packoffset(c299.x);
  float4 View_4800 : packoffset(c300.x);
  float View_4816 : packoffset(c301.x);
  float View_4820 : packoffset(c301.y);
  float View_4824 : packoffset(c301.z);
  float View_4828 : packoffset(c301.w);
  float4 View_4832 : packoffset(c302.x);
  float4 View_4848 : packoffset(c303.x);
  float4 View_4864 : packoffset(c304.x);
  int View_4880 : packoffset(c305.x);
  float View_4884 : packoffset(c305.y);
  float View_4888 : packoffset(c305.z);
  float View_4892 : packoffset(c305.w);
  float4 View_4896 : packoffset(c306.x);
  float4 View_4912 : packoffset(c307.x);
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
  float View_5472 : packoffset(c342.x);
  float View_5476 : packoffset(c342.y);
  float View_5480 : packoffset(c342.z);
  float View_5484 : packoffset(c342.w);
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
  float View_5536 : packoffset(c346.x);
  float View_5540 : packoffset(c346.y);
  float View_5544 : packoffset(c346.z);
  float View_5548 : packoffset(c346.w);
  float View_5552 : packoffset(c347.x);
  float View_5556 : packoffset(c347.y);
  float View_5560 : packoffset(c347.z);
  float View_5564 : packoffset(c347.w);
  float View_5568 : packoffset(c348.x);
  float View_5572 : packoffset(c348.y);
  float View_5576 : packoffset(c348.z);
  float View_5580 : packoffset(c348.w);
  float View_5584 : packoffset(c349.x);
  float View_5588 : packoffset(c349.y);
  float View_5592 : packoffset(c349.z);
  float View_5596 : packoffset(c349.w);
  float4 View_5600 : packoffset(c350.x);
  float View_5616 : packoffset(c351.x);
  float View_5620 : packoffset(c351.y);
  float View_5624 : packoffset(c351.z);
  float View_5628 : packoffset(c351.w);
  float4 View_5632 : packoffset(c352.x);
  float View_5648 : packoffset(c353.x);
  float View_5652 : packoffset(c353.y);
  float View_5656 : packoffset(c353.z);
  float View_5660 : packoffset(c353.w);
  int View_5664 : packoffset(c354.x);
  float View_5668 : packoffset(c354.y);
  float View_5672 : packoffset(c354.z);
  float View_5676 : packoffset(c354.w);
  float View_5680 : packoffset(c355.x);
  float View_5684 : packoffset(c355.y);
  float View_5688 : packoffset(c355.z);
  float View_5692 : packoffset(c355.w);
  float View_5696 : packoffset(c356.x);
  float View_5700 : packoffset(c356.y);
  float2 View_5704 : packoffset(c356.z);
  float3 View_5712 : packoffset(c357.x);
  float View_5724 : packoffset(c357.w);
  float3 View_5728 : packoffset(c358.x);
  float View_5740 : packoffset(c358.w);
  float3 View_5744 : packoffset(c359.x);
  float View_5756 : packoffset(c359.w);
  float View_5760 : packoffset(c360.x);
  float View_5764 : packoffset(c360.y);
  float View_5768 : packoffset(c360.z);
  float View_5772 : packoffset(c360.w);
  float View_5776 : packoffset(c361.x);
  float View_5780 : packoffset(c361.y);
  float View_5784 : packoffset(c361.z);
  float View_5788 : packoffset(c361.w);
  float4 View_5792 : packoffset(c362.x);
  float3 View_5808 : packoffset(c363.x);
  float View_5820 : packoffset(c363.w);
  float View_5824 : packoffset(c364.x);
  float View_5828 : packoffset(c364.y);
  float View_5832 : packoffset(c364.z);
  float View_5836 : packoffset(c364.w);
  float3 View_5840 : packoffset(c365.x);
  float View_5852 : packoffset(c365.w);
  float View_5856 : packoffset(c366.x);
  float View_5860 : packoffset(c366.y);
  float View_5864 : packoffset(c366.z);
  float View_5868 : packoffset(c366.w);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

SamplerState s2 : register(s2);

SamplerState s3 : register(s3);

SamplerState s4 : register(s4);

SamplerState s5 : register(s5);

SamplerState s6 : register(s6);

SamplerState s7 : register(s7);

SamplerState s8 : register(s8);

SamplerState s9 : register(s9);

SamplerState s10 : register(s10);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float2 TEXCOORD_3 : TEXCOORD3,
  noperspective float4 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 TEXCOORD_2 : TEXCOORD2,
  noperspective float2 TEXCOORD_4 : TEXCOORD4,
  precise noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _38;
  float _39;
  float _40;
  float _111;
  float _112;
  float _120;
  float _121;
  float _219;
  float _220;
  float _221;
  float _243;
  float _250;
  float _257;
  float _264;
  float _299;
  float _300;
  float _301;
  float _336;
  float _337;
  float _338;
  float _366;
  float _367;
  float _389;
  float _420;
  float _421;
  float _482;
  float _483;
  float _551;
  float _552;
  float _624;
  float _625;
  float _626;
  float _655;
  float _656;
  float _657;
  float _717;
  float _785;
  float _786;
  float _787;
  float _799;
  float _800;
  float _801;
  float _933;
  float _934;
  float _935;
  float _967;
  float _968;
  float _969;
  float _1016;
  float _1017;
  float _1018;
  float _1033;
  float _1034;
  float _1035;
  float _1107;
  float _1108;
  float _1109;
  float _1197;
  float _1198;
  float _1199;
  float _45;
  float _49;
  float _50;
  float _51;
  float _61;
  float _65;
  float _70;
  float _84;
  float _89;
  float _91;
  bool _94;
  bool _95;
  bool _96;
  bool _97;
  float _105;
  float _134;
  float _135;
  float _148;
  float _157;
  float _202;
  float _207;
  float _211;
  bool _227;
  bool _228;
  bool _230;
  bool _232;
  float _265;
  float _266;
  float _267;
  float _283;
  float _284;
  float _285;
  float _322;
  float _339;
  float _343;
  float _392;
  float _393;
  float _398;
  float _402;
  float _407;
  float _413;
  float _431;
  float _432;
  bool _433;
  float _443;
  float _444;
  float _455;
  float _456;
  float _461;
  float _462;
  float _472;
  float _474;
  bool _475;
  float4 _517;
  float _533;
  float _537;
  float _555;
  float _557;
  float _568;
  float _574;
  float _581;
  float _582;
  float _583;
  float _584;
  float _594;
  float _613;
  float _629;
  float _630;
  float _641;
  float _666;
  float4 _684;
  float _691;
  float _694;
  float _696;
  float _702;
  float _704;
  bool _705;
  float4 _747;
  bool _774;
  float4 _777;
  float4 _791;
  float _802;
  float _827;
  float _829;
  float _832;
  float _834;
  float _841;
  float _842;
  float _843;
  float _871;
  float _873;
  float _880;
  float _881;
  float _882;
  float _894;
  float _897;
  float _900;
  float _945;
  float _946;
  float _947;
  float _975;
  float _976;
  float _977;
  float _980;
  float _990;
  float _1001;
  float _1008;
  float _1028;
  float _1056;
  float _1057;
  float _1058;
  float4 _1059;
  float _1092;
  float4 _1093;
  float _1110;
  float _1111;
  float _1112;
  float _1120;
  float _1121;
  float _1122;
  float _1134;
  float _1135;
  float _1136;
  float _1169;
  float _1170;
  float _1171;
  _38 = cb0_064z * cb0_064y;
  _39 = TEXCOORD_3.x * 0.5f;
  _40 = TEXCOORD_3.y * 0.5f;
  if (!(!(cb0_101x != 0.0f))) {
    _45 = cb0_101x * 2.0f;
    if (_45 > 0.0f) {
      _49 = abs(_45) * 0.5f;
      _50 = tan(_49);
      _51 = _38 * TEXCOORD_3.x;
      _61 = rsqrt(dot(float2(_51, TEXCOORD_3.y), float2(_51, TEXCOORD_3.y)));
      _65 = rsqrt(dot(float2(_38, 1.0f), float2(_38, 1.0f)));
      _70 = tan((sqrt((_51 * _51) + (TEXCOORD_3.y * TEXCOORD_3.y)) / sqrt((_38 * _38) + 1.0f)) * _49);
      _111 = (((_70 * ((_61 * _51) / (_65 * _38))) / _50) * 0.5f);
      _112 = (((_70 * ((_61 * TEXCOORD_3.y) / _65)) / _50) * 0.5f);
    } else {
      if (_45 < 0.0f) {
        _84 = sqrt(((TEXCOORD_3.y * TEXCOORD_3.y) + (TEXCOORD_3.x * TEXCOORD_3.x)) * 0.25f);
        _89 = (((_84 * _84) * (cb0_101x * 0.699999988079071f)) + 1.0f) * _84;
        _91 = atan(_39 / _40);
        _94 = (_40 < 0.0f);
        _95 = (_40 == 0.0f);
        _96 = (_39 >= 0.0f);
        _97 = (_39 < 0.0f);
        _105 = select((_96 && _95), 1.5707963705062866f, select((_97 && _95), -1.5707963705062866f, select((_97 && _94), (_91 + -3.1415927410125732f), select((_96 && _94), (_91 + 3.1415927410125732f), _91))));
        _111 = (sin(_105) * _89);
        _112 = (cos(_105) * _89);
      } else {
        _111 = _39;
        _112 = _40;
      }
    }
    _120 = (((_111 + 0.5f) * 2.0f) + -1.0f);
    _121 = (((_112 + 0.5f) * 2.0f) + -1.0f);
  } else {
    _120 = TEXCOORD_3.x;
    _121 = TEXCOORD_3.y;
  }
  _134 = ((cb0_048x * _120) + cb0_048z) * cb0_047z;
  _135 = ((cb0_048y * _121) + cb0_048w) * cb0_047w;
  _148 = ((View_1040.x * (((float4)(t5.SampleLevel(s5, float2(_134, _135), 0.0f))).x)) + View_1040.y) + (1.0f / ((View_1040.z * (((float4)(t5.SampleLevel(s5, float2(_134, _135), 0.0f))).x)) - View_1040.w));
  _157 = 1.0f / ((View_1040.w + _148) * View_1040.z);
  if (((bool)(!(cb0_096y == 0.0f))) || ((bool)(((bool)(((bool)(((bool)(((bool)(!(cb0_097y == 0.0f))) || ((bool)(!(cb0_101y == 0.0f))))) || ((bool)(!(cb0_102y == 0.0f))))) || ((bool)(!(cb0_103y == 0.0f))))) || ((bool)(!(cb0_104y == 0.0f)))))) {
    _202 = 1.5f - (saturate(cb0_097z) * 1.4900000095367432f);
    _207 = saturate(((sqrt((_121 * _121) + (_120 * _120)) - cb0_097y) - _202) / (-0.0f - _202));
    _211 = (_207 * _207) * (3.0f - (_207 * 2.0f));
    _219 = (1.0f - (_211 * max(cb0_096y, cb0_101y)));
    _220 = (1.0f - (_211 * max(cb0_096y, cb0_102y)));
    _221 = (1.0f - (_211 * max(cb0_096y, cb0_103y)));
  } else {
    _219 = 1.0f;
    _220 = 1.0f;
    _221 = 1.0f;
  }
  _227 = !(cb0_096z == 0.0f);
  _228 = !(cb0_101z == 0.0f);
  _230 = !(cb0_102z == 0.0f);
  _232 = !(cb0_103z == 0.0f);
  if (((bool)(((bool)(((bool)(_227 || _228)) || _230)) || _232)) || ((bool)(!(cb0_104z == 0.0f)))) {
    if (_227) {
      _243 = exp2(log2(saturate(cb0_096z)) * 3.0f);
    } else {
      _243 = cb0_096z;
    }
    if (_228) {
      _250 = exp2(log2(saturate(cb0_101z)) * 3.0f);
    } else {
      _250 = cb0_101z;
    }
    if (_230) {
      _257 = exp2(log2(saturate(cb0_102z)) * 3.0f);
    } else {
      _257 = cb0_102z;
    }
    if (_232) {
      _264 = exp2(log2(saturate(cb0_103z)) * 3.0f);
    } else {
      _264 = cb0_103z;
    }
    _265 = max(_243, _250);
    _266 = max(_243, _257);
    _267 = max(_243, _264);
    _283 = saturate((_148 - (_265 * 1000.0f)) / ((_265 * 9999.990234375f) + 0.009999999776482582f));
    _284 = saturate((_148 - (_266 * 1000.0f)) / ((_266 * 9999.990234375f) + 0.009999999776482582f));
    _285 = saturate((_148 - (_267 * 1000.0f)) / ((_267 * 9999.990234375f) + 0.009999999776482582f));
    _299 = ((_283 * _283) * (3.0f - (_283 * 2.0f)));
    _300 = ((_284 * _284) * (3.0f - (_284 * 2.0f)));
    _301 = ((_285 * _285) * (3.0f - (_285 * 2.0f)));
  } else {
    _299 = 1.0f;
    _300 = 1.0f;
    _301 = 1.0f;
  }
  if (((bool)(((bool)(((bool)(((bool)(!(cb0_097x == 0.0f))) || ((bool)(!(cb0_102x == 0.0f))))) || ((bool)(!(cb0_103x == 0.0f))))) || ((bool)(!(cb0_104x == 0.0f))))) || ((bool)(!(cb0_105x == 0.0f)))) {
    _322 = saturate(select((((_157 - (((float4)(t4.Sample(s4, float2(_134, _135)))).x)) + ((((View_448[3].z) - _157) + ((View_448[2].z) * _148)) * select(((View_448[3].w) < 1.0f), 0.0f, 1.0f))) > 0.0005000000237487257f), 1.0f, 0.0f) + select(((((float4)(t4.Sample(s4, float2(_134, _135)))).x) > 0.0005000000237487257f), 0.0f, 1.0f));
    _336 = max(_322, (1.0f - saturate(max(cb0_097x, cb0_102x))));
    _337 = max(_322, (1.0f - saturate(max(cb0_097x, cb0_103x))));
    _338 = max(_322, (1.0f - saturate(max(cb0_097x, cb0_104x))));
  } else {
    _336 = 1.0f;
    _337 = 1.0f;
    _338 = 1.0f;
  }
  _339 = TEXCOORD_2.w * 543.3099975585938f;
  _343 = frac(sin(_339 + TEXCOORD_2.z) * 493013.0f);
  if (cb0_096x > 0.0f) {
    _366 = ((cb0_096x * (frac((sin((TEXCOORD_2.z + 33.9900016784668f) + _339) * 493013.0f) + 7.177000045776367f) - _343)) + _343);
    _367 = ((cb0_096x * (frac((sin((TEXCOORD_2.z + 66.98999786376953f) + _339) * 493013.0f) + 14.298999786376953f) - _343)) + _343);
  } else {
    _366 = _343;
    _367 = _343;
  }
  if (cb0_099z > 0.0f) {
    _389 = (((((_301 * _221) * _338) * cb0_099z) * ((sin((((TEXCOORD_3.y * 10.0f) + 10.0f) + (_343 * 0.0020000000949949026f)) + (View_2376 * 4.0f)) * 0.5f) + 0.5f)) + 1.0f);
  } else {
    _389 = 1.0f;
  }
  _392 = (_300 * _220) * _337;
  _393 = _392 * cb0_099y;
  if (cb0_099y > 0.0f) {
    _398 = View_2376 * 0.00016666666488163173f;
    _402 = frac(abs(_398));
    _407 = ((TEXCOORD_3.y * 111000.0f) + 111000.0f) * select((_398 >= (-0.0f - _398)), _402, (-0.0f - _402));
    _413 = (0.5f - frac(sin(dot(float2(_407, _407), float2(12.989800453186035f, 78.23300170898438f))) * 43758.546875f)) * 0.014999999664723873f;
    _420 = (((_393 * 0.5f) * _413) + _134);
    _421 = ((_413 * _393) + _135);
  } else {
    _420 = _134;
    _421 = _135;
  }
  _431 = cb0_117z * cb0_116x;
  _432 = cb0_117z * cb0_116y;
  _433 = (cb0_117x == 0.0f);
  _443 = (cb0_113z * _120) + cb0_113x;
  _444 = (cb0_113w * _121) + cb0_113y;
  _455 = float((int)(((int)(uint)((bool)(_443 > 0.0f))) - ((int)(uint)((bool)(_443 < 0.0f)))));
  _456 = float((int)(((int)(uint)((bool)(_444 > 0.0f))) - ((int)(uint)((bool)(_444 < 0.0f)))));
  _461 = saturate(abs(_443) - cb0_116z);
  _462 = saturate(abs(_444) - cb0_116z);
  _472 = _444 - ((_462 * _431) * _456);
  _474 = _444 - ((_462 * _432) * _456);
  _475 = (cb0_117x > 0.0f);
  if (_475) {
    _482 = (_472 - (cb0_117w * 0.4000000059604645f));
    _483 = (_474 - (cb0_117w * 0.20000000298023224f));
  } else {
    _482 = _472;
    _483 = _474;
  }
  _517 = t0.Sample(s0, float2(_420, _421));
  if (_475) {
    _533 = saturate(((((_517.y * 0.5870000123977661f) - cb0_117y) + (_517.x * 0.29899999499320984f)) + (_517.z * 0.11400000005960464f)) * 10.0f);
    _537 = (_533 * _533) * (3.0f - (_533 * 2.0f));
    _551 = ((((_517.x - (((float4)(t0.Sample(s0, float2((((cb0_048x * ((cb0_114z * (_443 - ((_461 * select(_433, _431, cb0_116x)) * _455))) + cb0_114x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_114w * _482) + cb0_114y)) + cb0_048w) * cb0_047w))))).x)) + (_537 * ((((float4)(t0.Sample(s0, float2((((cb0_048x * ((cb0_114z * (_443 - ((_461 * select(_433, _431, cb0_116x)) * _455))) + cb0_114x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_114w * _482) + cb0_114y)) + cb0_048w) * cb0_047w))))).x) - _517.x))) * cb0_117x) + (((float4)(t0.Sample(s0, float2((((cb0_048x * ((cb0_114z * (_443 - ((_461 * select(_433, _431, cb0_116x)) * _455))) + cb0_114x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_114w * _482) + cb0_114y)) + cb0_048w) * cb0_047w))))).x));
    _552 = ((((_517.y - (((float4)(t0.Sample(s0, float2((((cb0_048x * ((cb0_114z * (_443 - ((_461 * select(_433, _432, cb0_116y)) * _455))) + cb0_114x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_114w * _483) + cb0_114y)) + cb0_048w) * cb0_047w))))).y)) + (_537 * ((((float4)(t0.Sample(s0, float2((((cb0_048x * ((cb0_114z * (_443 - ((_461 * select(_433, _432, cb0_116y)) * _455))) + cb0_114x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_114w * _483) + cb0_114y)) + cb0_048w) * cb0_047w))))).y) - _517.y))) * cb0_117x) + (((float4)(t0.Sample(s0, float2((((cb0_048x * ((cb0_114z * (_443 - ((_461 * select(_433, _432, cb0_116y)) * _455))) + cb0_114x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_114w * _483) + cb0_114y)) + cb0_048w) * cb0_047w))))).y));
  } else {
    _551 = (((float4)(t0.Sample(s0, float2((((cb0_048x * ((cb0_114z * (_443 - ((_461 * select(_433, _431, cb0_116x)) * _455))) + cb0_114x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_114w * _482) + cb0_114y)) + cb0_048w) * cb0_047w))))).x);
    _552 = (((float4)(t0.Sample(s0, float2((((cb0_048x * ((cb0_114z * (_443 - ((_461 * select(_433, _432, cb0_116y)) * _455))) + cb0_114x)) + cb0_048z) * cb0_047z), (((cb0_048y * ((cb0_114w * _483) + cb0_114y)) + cb0_048w) * cb0_047w))))).y);
  }
  _555 = saturate(cb0_098x);
  _557 = saturate(cb0_098y);
  if (_555 > 0.0f) {
    _568 = saturate(((_551 * 0.29899999499320984f) + (_517.z * 0.11400000005960464f)) + (_552 * 0.5870000123977661f));
    _574 = ((_568 * _568) * (saturate(1.0f - cb0_098z) * 2.0f)) * (3.0f - (_568 * 2.0f));
    _581 = max(sqrt(((_551 * _551) + (_517.z * _517.z)) + (_552 * _552)), 0.014999999664723873f);
    _582 = _551 / _581;
    _583 = _552 / _581;
    _584 = _517.z / _581;
    _594 = log2(_574);
    _613 = ((_299 * _219) * _336) * _555;
    _624 = (((((lerp(_582, 1.0f, 0.25f)) * (((_557 * 0.17000000178813934f) + 0.029999999329447746f) + _574)) - _551) * _613) + _551);
    _625 = (((((((_557 * 0.18000000715255737f) + 0.05000000074505806f) + exp2(_594 * 0.8999999761581421f)) * (lerp(_583, 1.0f, 0.25f))) - _552) * _613) + _552);
    _626 = (((((((_557 * 0.17999999225139618f) + 0.07999999821186066f) + exp2(_594 * 0.949999988079071f)) * (lerp(_584, 1.0f, 0.25f))) - _517.z) * _613) + _517.z);
  } else {
    _624 = _551;
    _625 = _552;
    _626 = _517.z;
  }
  _629 = saturate(cb0_099x);
  _630 = _392 * _629;
  if (_629 > 0.0f) {
    _641 = (sin(((_121 * 640.0f) + 640.0f) - (View_2376 * 10.0f)) * 0.5f) + 1.0f;
    _655 = ((((_641 * _624) - _624) * _630) + _624);
    _656 = ((((_641 * _625) - _625) * _630) + _625);
    _657 = ((((_641 * _626) - _626) * _630) + _626);
  } else {
    _655 = _624;
    _656 = _625;
    _657 = _626;
  }
  _666 = log2(max(dot(float3(_655, _656, _657), float3(cb0_042y, cb0_042z, cb0_042w)), cb0_041z));
  _684 = t7.Sample(s7, float3((cb0_046x * TEXCOORD_4.x), (cb0_046y * TEXCOORD_4.y), ((((cb0_041x * _666) + cb0_041y) * 0.96875f) + 0.015625f)));
  _691 = select((_684.y < 0.0010000000474974513f), (((float4)(t8.Sample(s8, float2(TEXCOORD_4.x, TEXCOORD_4.y)))).x), (_684.x / _684.y));
  _694 = log2(TEXCOORD_1.x);
  _696 = (_691 + _694) + (((((float4)(t8.Sample(s8, float2(TEXCOORD_4.x, TEXCOORD_4.y)))).x) - _691) * cb0_045y);
  _702 = _694 + _666;
  _704 = _696 - log2((TEXCOORD_1.y * 0.18000000715255737f) * cb0_045z);
  _705 = (_704 > 0.0f);
  if (_705) {
    _717 = max(0.0f, (_704 - cb0_046z));
  } else {
    _717 = min(0.0f, (cb0_046w + _704));
  }
  _747 = t1.Sample(s1, float2(min(max(((cb0_068x * _420) + cb0_068z), cb0_060x), cb0_060z), min(max(((cb0_068y * _421) + cb0_068w), cb0_060y), cb0_060w)));
  APPLY_BLOOM(_747);
  [branch]
  if (!(cb0_085x == 0)) {
    _774 = (cb0_085z != 0);
    _777 = t2.Sample(s2, float2(select(_774, _420, min(max(((cb0_076x * _420) + cb0_076z), cb0_075x), cb0_075z)), select(_774, _421, min(max(((cb0_076y * _421) + cb0_076w), cb0_075y), cb0_075w))));
    _785 = (_777.x + _747.x);
    _786 = (_777.y + _747.y);
    _787 = (_777.z + _747.z);
  } else {
    _785 = _747.x;
    _786 = _747.y;
    _787 = _747.z;
  }
  [branch]
  if (!(cb0_085y == 0)) {
    _791 = t3.Sample(s3, float2(_420, _421));
    _799 = (_791.x + _785);
    _800 = (_791.y + _786);
    _801 = (_791.z + _787);
  } else {
    _799 = _785;
    _800 = _786;
    _801 = _787;
  }
  _802 = exp2((((_696 - _702) + ((_702 - _696) * cb0_045x)) - _717) + (_717 * select(_705, cb0_044z, cb0_044w))) * TEXCOORD_1.x;
  _827 = TEXCOORD_1.z + -1.0f;
  _829 = TEXCOORD_1.w + -1.0f;
  _832 = ((_827 + (cb0_090x * 2.0f)) * cb0_088z) * cb0_088x;
  _834 = ((_829 + (cb0_090y * 2.0f)) * cb0_088w) * cb0_088x;
  _841 = 1.0f / ((((saturate(cb0_089w) * 9.0f) + 1.0f) * dot(float2(_832, _834), float2(_832, _834))) + 1.0f);
  _842 = _841 * _841;
  _843 = cb0_090z + 1.0f;
  _871 = ((_827 + (cb0_093x * 2.0f)) * cb0_091z) * cb0_091x;
  _873 = ((_829 + (cb0_093y * 2.0f)) * cb0_091w) * cb0_091x;
  _880 = 1.0f / ((((saturate(cb0_092w) * 9.0f) + 1.0f) * dot(float2(_871, _873), float2(_871, _873))) + 1.0f);
  _881 = _880 * _880;
  _882 = cb0_093z + 1.0f;
  _894 = (((_799 + ((_802 * _655) * cb0_086x)) * _389) * ((_842 * (_843 - cb0_089x)) + cb0_089x)) * ((_881 * (_882 - cb0_092x)) + cb0_092x);
  _897 = (((_800 + ((_802 * _656) * cb0_086y)) * _389) * ((_842 * (_843 - cb0_089y)) + cb0_089y)) * ((_881 * (_882 - cb0_092y)) + cb0_092y);
  _900 = (((_801 + ((_802 * _657) * cb0_086z)) * _389) * ((_842 * (_843 - cb0_089z)) + cb0_089z)) * ((_881 * (_882 - cb0_092z)) + cb0_092z);
  CAPTURE_UNTONEMAPPED(float3(_894, _897, _900));
  [branch]
  if (WUWA_TM_IS(1)) {
    _933 = ((((_894 * 1.3600000143051147f) + 0.04699999839067459f) * _894) / ((((_894 * 0.9599999785423279f) + 0.5600000023841858f) * _894) + 0.14000000059604645f));
    _934 = ((((_897 * 1.3600000143051147f) + 0.04699999839067459f) * _897) / ((((_897 * 0.9599999785423279f) + 0.5600000023841858f) * _897) + 0.14000000059604645f));
    _935 = ((((_900 * 1.3600000143051147f) + 0.04699999839067459f) * _900) / ((((_900 * 0.9599999785423279f) + 0.5600000023841858f) * _900) + 0.14000000059604645f));
  } else {
    _933 = _894;
    _934 = _897;
    _935 = _900;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    _945 = 1.0049500465393066f - (0.16398000717163086f / (_933 + -0.19505000114440918f));
    _946 = 1.0049500465393066f - (0.16398000717163086f / (_934 + -0.19505000114440918f));
    _947 = 1.0049500465393066f - (0.16398000717163086f / (_935 + -0.19505000114440918f));
    _967 = (((_933 - _945) * select((_933 > 0.6000000238418579f), 0.0f, 1.0f)) + _945);
    _968 = (((_934 - _946) * select((_934 > 0.6000000238418579f), 0.0f, 1.0f)) + _946);
    _969 = (((_935 - _947) * select((_935 > 0.6000000238418579f), 0.0f, 1.0f)) + _947);
  } else {
    _967 = _933;
    _968 = _934;
    _969 = _935;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    _975 = cb0_037y * _967;
    _976 = cb0_037y * _968;
    _977 = cb0_037y * _969;
    _980 = cb0_037z * cb0_037w;
    _990 = cb0_038y * cb0_038x;
    _1001 = cb0_038z * cb0_038x;
    _1008 = cb0_038y / cb0_038z;
    _1016 = (((((_980 + _975) * _967) + _990) / (_1001 + ((_975 + cb0_037z) * _967))) - _1008);
    _1017 = (((((_980 + _976) * _968) + _990) / (_1001 + ((_976 + cb0_037z) * _968))) - _1008);
    _1018 = (((((_980 + _977) * _969) + _990) / (_1001 + ((_977 + cb0_037z) * _969))) - _1008);
  } else {
    _1016 = _967;
    _1017 = _968;
    _1018 = _969;
  }
  [branch]
  if (!(cb0_105w == 0)) {
    if (!(cb0_106x == 1.0f)) {
      _1028 = (cb0_106x * 0.699999988079071f) + 0.30000001192092896f;
      _1033 = (_1028 * _1016);
      _1034 = (_1028 * _1017);
      _1035 = (_1028 * _1018);
    } else {
      _1033 = _1016;
      _1034 = _1017;
      _1035 = _1018;
    }
  } else {
    _1033 = _1016;
    _1034 = _1017;
    _1035 = _1018;
  }
  APPLY_EXTENDED_TONEMAP(_1033, _1034, _1035);
  _1056 = (saturate((log2(_1033 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _1057 = (saturate((log2(_1034 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _1058 = (saturate((log2(_1035 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  _1059 = t9.Sample(s9, float3(_1056, _1057, _1058));
  [branch]
  if (!(cb0_107w == 0)) {
    _1092 = select((((uint)(uint(float((uint)((int)((uint)(uint(round((((float4)(t6.Sample(s6, float2(min(max(((cb0_084x * _420) + cb0_084z), cb0_083x), cb0_083z), min(max(((cb0_084y * _421) + cb0_084w), cb0_083y), cb0_083w))))).w) * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    _1093 = t10.Sample(s10, float3(_1056, _1057, _1058));
    _1107 = (lerp(_1093.x, _1059.x, _1092));
    _1108 = (lerp(_1093.y, _1059.y, _1092));
    _1109 = (lerp(_1093.z, _1059.z, _1092));
  } else {
    _1107 = _1059.x;
    _1108 = _1059.y;
    _1109 = _1059.z;
  }
  _1110 = _1109 * 1.0499999523162842f;
  _1111 = _1108 * 1.0499999523162842f;
  _1112 = _1107 * 1.0499999523162842f;
  _1120 = ((_343 * 0.00390625f) + -0.001953125f) + _1112;
  _1121 = ((_366 * 0.00390625f) + -0.001953125f) + _1111;
  _1122 = ((_367 * 0.00390625f) + -0.001953125f) + _1110;
  [branch]
  if (!(cb0_106w == 0)) {
    _1134 = (pow(_1120, 0.012683313339948654f));
    _1135 = (pow(_1121, 0.012683313339948654f));
    _1136 = (pow(_1122, 0.012683313339948654f));
    _1169 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_1134 + -0.8359375f)) / (18.8515625f - (_1134 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _1170 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_1135 + -0.8359375f)) / (18.8515625f - (_1135 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _1171 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_1136 + -0.8359375f)) / (18.8515625f - (_1136 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _1197 = min((_1169 * 12.920000076293945f), ((exp2(log2(max(_1169, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _1198 = min((_1170 * 12.920000076293945f), ((exp2(log2(max(_1170, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _1199 = min((_1171 * 12.920000076293945f), ((exp2(log2(max(_1171, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _1197 = _1120;
    _1198 = _1121;
    _1199 = _1122;
  }
  SV_Target.x = _1197;
  SV_Target.y = _1198;
  SV_Target.z = _1199;
  SV_Target.xyz = wuwa::InvertAndApplyDisplayMap(SV_Target.xyz, SV_Position.xy);
  SV_Target.w = (dot(float3(_1112, _1111, _1110), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}