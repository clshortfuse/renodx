#include "../../common.hlsl"

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
  float cb0_041z : packoffset(c041.z);
  float cb0_041w : packoffset(c041.w);
  float cb0_042x : packoffset(c042.x);
  float cb0_043x : packoffset(c043.x);
  float cb0_043y : packoffset(c043.y);
  float cb0_043z : packoffset(c043.z);
  float cb0_045y : packoffset(c045.y);
  float cb0_045z : packoffset(c045.z);
  float cb0_045w : packoffset(c045.w);
  float cb0_046x : packoffset(c046.x);
  float cb0_046y : packoffset(c046.y);
  float cb0_046z : packoffset(c046.z);
  float cb0_046w : packoffset(c046.w);
  float cb0_047x : packoffset(c047.x);
  float cb0_047y : packoffset(c047.y);
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
  float cb0_075z : packoffset(c075.z);
  float cb0_075w : packoffset(c075.w);
  float cb0_076x : packoffset(c076.x);
  float cb0_076y : packoffset(c076.y);
  float cb0_076z : packoffset(c076.z);
  float cb0_076w : packoffset(c076.w);
  float cb0_077x : packoffset(c077.x);
  float cb0_077y : packoffset(c077.y);
  float cb0_083z : packoffset(c083.z);
  float cb0_083w : packoffset(c083.w);
  float cb0_084x : packoffset(c084.x);
  float cb0_084y : packoffset(c084.y);
  float cb0_084z : packoffset(c084.z);
  float cb0_084w : packoffset(c084.w);
  float cb0_085x : packoffset(c085.x);
  float cb0_085y : packoffset(c085.y);
  int cb0_085z : packoffset(c085.z);
  int cb0_085w : packoffset(c085.w);
  int cb0_086x : packoffset(c086.x);
  float cb0_087x : packoffset(c087.x);
  float cb0_087y : packoffset(c087.y);
  float cb0_087z : packoffset(c087.z);
  float cb0_089x : packoffset(c089.x);
  float cb0_089z : packoffset(c089.z);
  float cb0_089w : packoffset(c089.w);
  float cb0_090x : packoffset(c090.x);
  float cb0_090y : packoffset(c090.y);
  float cb0_090z : packoffset(c090.z);
  float cb0_090w : packoffset(c090.w);
  float cb0_091x : packoffset(c091.x);
  float cb0_091y : packoffset(c091.y);
  float cb0_091z : packoffset(c091.z);
  float cb0_092x : packoffset(c092.x);
  float cb0_092z : packoffset(c092.z);
  float cb0_092w : packoffset(c092.w);
  float cb0_093x : packoffset(c093.x);
  float cb0_093y : packoffset(c093.y);
  float cb0_093z : packoffset(c093.z);
  float cb0_093w : packoffset(c093.w);
  float cb0_094x : packoffset(c094.x);
  float cb0_094y : packoffset(c094.y);
  float cb0_094z : packoffset(c094.z);
  float cb0_097x : packoffset(c097.x);
  float cb0_097y : packoffset(c097.y);
  float cb0_097z : packoffset(c097.z);
  float cb0_098x : packoffset(c098.x);
  float cb0_098y : packoffset(c098.y);
  float cb0_098z : packoffset(c098.z);
  float cb0_099x : packoffset(c099.x);
  float cb0_099y : packoffset(c099.y);
  float cb0_099z : packoffset(c099.z);
  float cb0_100x : packoffset(c100.x);
  float cb0_100y : packoffset(c100.y);
  float cb0_100z : packoffset(c100.z);
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
  float cb0_105y : packoffset(c105.y);
  float cb0_105z : packoffset(c105.z);
  float cb0_106x : packoffset(c106.x);
  int cb0_106w : packoffset(c106.w);
  float cb0_107x : packoffset(c107.x);
  float cb0_107z : packoffset(c107.z);
  int cb0_107w : packoffset(c107.w);
  int cb0_108x : packoffset(c108.x);
  int cb0_108y : packoffset(c108.y);
  int cb0_108z : packoffset(c108.z);
  int cb0_108w : packoffset(c108.w);
  float cb0_114x : packoffset(c114.x);
  float cb0_114y : packoffset(c114.y);
  float cb0_114z : packoffset(c114.z);
  float cb0_114w : packoffset(c114.w);
  float cb0_115x : packoffset(c115.x);
  float cb0_115y : packoffset(c115.y);
  float cb0_115z : packoffset(c115.z);
  float cb0_115w : packoffset(c115.w);
  float cb0_117x : packoffset(c117.x);
  float cb0_117y : packoffset(c117.y);
  float cb0_117z : packoffset(c117.z);
  float cb0_118x : packoffset(c118.x);
  float cb0_118y : packoffset(c118.y);
  float cb0_118z : packoffset(c118.z);
  float cb0_118w : packoffset(c118.w);
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
  float4 View_4480 : packoffset(c280.x);
  float View_4496 : packoffset(c281.x);
  float View_4500 : packoffset(c281.y);
  float View_4504 : packoffset(c281.z);
  float View_4508 : packoffset(c281.w);
  float View_4512 : packoffset(c282.x);
  float View_4516 : packoffset(c282.y);
  float View_4520 : packoffset(c282.z);
  float View_4524 : packoffset(c282.w);
  float4 View_4528 : packoffset(c283.x);
  int View_4544 : packoffset(c284.x);
  int View_4548 : packoffset(c284.y);
  int View_4552 : packoffset(c284.z);
  float View_4556 : packoffset(c284.w);
  float View_4560 : packoffset(c285.x);
  float View_4564 : packoffset(c285.y);
  float View_4568 : packoffset(c285.z);
  float View_4572 : packoffset(c285.w);
  float4 View_4576 : packoffset(c286.x);
  float4 View_4592 : packoffset(c287.x);
  float4 View_4608 : packoffset(c288.x);
  float4 View_4624 : packoffset(c289.x);
  float View_4640 : packoffset(c290.x);
  float View_4644 : packoffset(c290.y);
  float View_4648 : packoffset(c290.z);
  float View_4652 : packoffset(c290.w);
  float4 View_4656 : packoffset(c291.x);
  float4 View_4672 : packoffset(c292.x);
  float4 View_4688 : packoffset(c293.x);
  float4 View_4704 : packoffset(c294.x);
  float4 View_4720 : packoffset(c295.x);
  float View_4736 : packoffset(c296.x);
  float View_4740 : packoffset(c296.y);
  float View_4744 : packoffset(c296.z);
  float View_4748 : packoffset(c296.w);
  float4 View_4752 : packoffset(c297.x);
  float4 View_4768 : packoffset(c298.x);
  float View_4784 : packoffset(c299.x);
  float View_4788 : packoffset(c299.y);
  float View_4792 : packoffset(c299.z);
  float View_4796 : packoffset(c299.w);
  float4 View_4800 : packoffset(c300.x);
  float4 View_4816 : packoffset(c301.x);
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
  float View_5472 : packoffset(c342.x);
  float View_5476 : packoffset(c342.y);
  float View_5480 : packoffset(c342.z);
  float View_5484 : packoffset(c342.w);
  float View_5488 : packoffset(c343.x);
  float View_5492 : packoffset(c343.y);
  float View_5496 : packoffset(c343.z);
  float View_5500 : packoffset(c343.w);
  float4 View_5504 : packoffset(c344.x);
  float View_5520 : packoffset(c345.x);
  float View_5524 : packoffset(c345.y);
  float View_5528 : packoffset(c345.z);
  float View_5532 : packoffset(c345.w);
  float4 View_5536 : packoffset(c346.x);
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
  float2 View_5600 : packoffset(c350.x);
  float View_5608 : packoffset(c350.z);
  float View_5612 : packoffset(c350.w);
  float3 View_5616 : packoffset(c351.x);
  float View_5628 : packoffset(c351.w);
  float3 View_5632 : packoffset(c352.x);
  float View_5644 : packoffset(c352.w);
  float3 View_5648 : packoffset(c353.x);
  float View_5660 : packoffset(c353.w);
  float View_5664 : packoffset(c354.x);
  float View_5668 : packoffset(c354.y);
  float View_5672 : packoffset(c354.z);
  float View_5676 : packoffset(c354.w);
  float View_5680 : packoffset(c355.x);
  float View_5684 : packoffset(c355.y);
  float View_5688 : packoffset(c355.z);
  float View_5692 : packoffset(c355.w);
  float4 View_5696 : packoffset(c356.x);
  float3 View_5712 : packoffset(c357.x);
  float View_5724 : packoffset(c357.w);
  float View_5728 : packoffset(c358.x);
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

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float2 TEXCOORD_3 : TEXCOORD3,
  noperspective float4 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 TEXCOORD_2 : TEXCOORD2,
  noperspective float2 TEXCOORD_4 : TEXCOORD4,
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _39 = cb0_065x * cb0_064w;
  float _40 = TEXCOORD_3.x * 0.5f;
  float _41 = TEXCOORD_3.y * 0.5f;
  float _112;
  float _113;
  float _121;
  float _122;
  float _220;
  float _221;
  float _222;
  float _244;
  float _251;
  float _258;
  float _265;
  float _300;
  float _301;
  float _302;
  float _337;
  float _338;
  float _339;
  float _367;
  float _368;
  float _390;
  float _421;
  float _422;
  float _483;
  float _484;
  float _552;
  float _553;
  float _625;
  float _626;
  float _627;
  float _656;
  float _657;
  float _658;
  float _717;
  float _789;
  float _790;
  float _791;
  float _803;
  float _804;
  float _805;
  float _937;
  float _938;
  float _939;
  float _971;
  float _972;
  float _973;
  float _1020;
  float _1021;
  float _1022;
  float _1037;
  float _1038;
  float _1039;
  float _1112;
  float _1113;
  float _1114;
  float _1202;
  float _1203;
  float _1204;
  if (!(!(cb0_102x != 0.0f))) {
    float _46 = cb0_102x * 2.0f;
    do {
      if (_46 > 0.0f) {
        float _50 = abs(_46) * 0.5f;
        float _51 = tan(_50);
        float _52 = _39 * TEXCOORD_3.x;
        float _62 = rsqrt(dot(float2(_52, TEXCOORD_3.y), float2(_52, TEXCOORD_3.y)));
        float _66 = rsqrt(dot(float2(_39, 1.0f), float2(_39, 1.0f)));
        float _71 = tan((sqrt((_52 * _52) + (TEXCOORD_3.y * TEXCOORD_3.y)) / sqrt((_39 * _39) + 1.0f)) * _50);
        _112 = (((_71 * ((_62 * _52) / (_66 * _39))) / _51) * 0.5f);
        _113 = (((_71 * ((_62 * TEXCOORD_3.y) / _66)) / _51) * 0.5f);
      } else {
        if (_46 < 0.0f) {
          float _85 = sqrt(((TEXCOORD_3.y * TEXCOORD_3.y) + (TEXCOORD_3.x * TEXCOORD_3.x)) * 0.25f);
          float _90 = (((_85 * _85) * (cb0_102x * 0.699999988079071f)) + 1.0f) * _85;
          float _92 = atan(_40 / _41);
          bool _95 = (_41 < 0.0f);
          bool _96 = (_41 == 0.0f);
          bool _97 = (_40 >= 0.0f);
          bool _98 = (_40 < 0.0f);
          float _106 = select((_97 && _96), 1.5707963705062866f, select((_98 && _96), -1.5707963705062866f, select((_98 && _95), (_92 + -3.1415927410125732f), select((_97 && _95), (_92 + 3.1415927410125732f), _92))));
          _112 = (sin(_106) * _90);
          _113 = (cos(_106) * _90);
        } else {
          _112 = _40;
          _113 = _41;
        }
      }
      _121 = (((_112 + 0.5f) * 2.0f) + -1.0f);
      _122 = (((_113 + 0.5f) * 2.0f) + -1.0f);
    } while (false);
  } else {
    _121 = TEXCOORD_3.x;
    _122 = TEXCOORD_3.y;
  }
  float _135 = ((cb0_048z * _121) + cb0_049x) * cb0_048x;
  float _136 = ((cb0_048w * _122) + cb0_049y) * cb0_048y;
  float4 _137 = t5.SampleLevel(s5, float2(_135, _136), 0.0f);
  float _149 = ((View_1040.x * _137.x) + View_1040.y) + (1.0f / ((View_1040.z * _137.x) - View_1040.w));
  float4 _150 = t4.Sample(s4, float2(_135, _136));
  float _158 = 1.0f / ((View_1040.w + _149) * View_1040.z);
  if (((bool)(!(cb0_097y == 0.0f))) || ((bool)(((bool)(((bool)(((bool)(((bool)(!(cb0_098y == 0.0f))) || ((bool)(!(cb0_102y == 0.0f))))) || ((bool)(!(cb0_103y == 0.0f))))) || ((bool)(!(cb0_104y == 0.0f))))) || ((bool)(!(cb0_105y == 0.0f)))))) {
    float _203 = 1.5f - (saturate(cb0_098z) * 1.4900000095367432f);
    float _208 = saturate(((sqrt((_122 * _122) + (_121 * _121)) - cb0_098y) - _203) / (-0.0f - _203));
    float _212 = (_208 * _208) * (3.0f - (_208 * 2.0f));
    _220 = (1.0f - (_212 * max(cb0_097y, cb0_102y)));
    _221 = (1.0f - (_212 * max(cb0_097y, cb0_103y)));
    _222 = (1.0f - (_212 * max(cb0_097y, cb0_104y)));
  } else {
    _220 = 1.0f;
    _221 = 1.0f;
    _222 = 1.0f;
  }
  bool _228 = !(cb0_097z == 0.0f);
  bool _229 = !(cb0_102z == 0.0f);
  bool _231 = !(cb0_103z == 0.0f);
  bool _233 = !(cb0_104z == 0.0f);
  if (((bool)(((bool)(((bool)(_228 || _229)) || _231)) || _233)) || ((bool)(!(cb0_105z == 0.0f)))) {
    do {
      if (_228) {
        _244 = exp2(log2(saturate(cb0_097z)) * 3.0f);
      } else {
        _244 = cb0_097z;
      }
      do {
        if (_229) {
          _251 = exp2(log2(saturate(cb0_102z)) * 3.0f);
        } else {
          _251 = cb0_102z;
        }
        do {
          if (_231) {
            _258 = exp2(log2(saturate(cb0_103z)) * 3.0f);
          } else {
            _258 = cb0_103z;
          }
          do {
            if (_233) {
              _265 = exp2(log2(saturate(cb0_104z)) * 3.0f);
            } else {
              _265 = cb0_104z;
            }
            float _266 = max(_244, _251);
            float _267 = max(_244, _258);
            float _268 = max(_244, _265);
            float _284 = saturate((_149 - (_266 * 1000.0f)) / ((_266 * 9999.990234375f) + 0.009999999776482582f));
            float _285 = saturate((_149 - (_267 * 1000.0f)) / ((_267 * 9999.990234375f) + 0.009999999776482582f));
            float _286 = saturate((_149 - (_268 * 1000.0f)) / ((_268 * 9999.990234375f) + 0.009999999776482582f));
            _300 = ((_284 * _284) * (3.0f - (_284 * 2.0f)));
            _301 = ((_285 * _285) * (3.0f - (_285 * 2.0f)));
            _302 = ((_286 * _286) * (3.0f - (_286 * 2.0f)));
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _300 = 1.0f;
    _301 = 1.0f;
    _302 = 1.0f;
  }
  if (((bool)(((bool)(((bool)(((bool)(!(cb0_098x == 0.0f))) || ((bool)(!(cb0_103x == 0.0f))))) || ((bool)(!(cb0_104x == 0.0f))))) || ((bool)(!(cb0_105x == 0.0f))))) || ((bool)(!(cb0_106x == 0.0f)))) {
    float _323 = saturate(select((((_158 - _150.x) + ((((View_448[3].z) - _158) + ((View_448[2].z) * _149)) * select(((View_448[3].w) < 1.0f), 0.0f, 1.0f))) > 0.0005000000237487257f), 1.0f, 0.0f) + select((_150.x > 0.0005000000237487257f), 0.0f, 1.0f));
    _337 = max(_323, (1.0f - saturate(max(cb0_098x, cb0_103x))));
    _338 = max(_323, (1.0f - saturate(max(cb0_098x, cb0_104x))));
    _339 = max(_323, (1.0f - saturate(max(cb0_098x, cb0_105x))));
  } else {
    _337 = 1.0f;
    _338 = 1.0f;
    _339 = 1.0f;
  }
  float _340 = TEXCOORD_2.w * 543.3099975585938f;
  float _344 = frac(sin(_340 + TEXCOORD_2.z) * 493013.0f);
  if (cb0_097x > 0.0f) {
    _367 = ((cb0_097x * (frac((sin((TEXCOORD_2.z + 33.9900016784668f) + _340) * 493013.0f) + 7.177000045776367f) - _344)) + _344);
    _368 = ((cb0_097x * (frac((sin((TEXCOORD_2.z + 66.98999786376953f) + _340) * 493013.0f) + 14.298999786376953f) - _344)) + _344);
  } else {
    _367 = _344;
    _368 = _344;
  }
  if (cb0_100z > 0.0f) {
    _390 = (((((_302 * _222) * _339) * cb0_100z) * ((sin((((TEXCOORD_3.y * 10.0f) + 10.0f) + (_344 * 0.0020000000949949026f)) + (View_2376 * 4.0f)) * 0.5f) + 0.5f)) + 1.0f);
  } else {
    _390 = 1.0f;
  }
  float _393 = (_301 * _221) * _338;
  float _394 = _393 * cb0_100y;
  if (cb0_100y > 0.0f) {
    float _399 = View_2376 * 0.00016666666488163173f;
    float _403 = frac(abs(_399));
    float _408 = ((TEXCOORD_3.y * 111000.0f) + 111000.0f) * select((_399 >= (-0.0f - _399)), _403, (-0.0f - _403));
    float _414 = (0.5f - frac(sin(dot(float2(_408, _408), float2(12.989800453186035f, 78.23300170898438f))) * 43758.546875f)) * 0.014999999664723873f;
    _421 = (((_394 * 0.5f) * _414) + _135);
    _422 = ((_414 * _394) + _136);
  } else {
    _421 = _135;
    _422 = _136;
  }
  float _432 = cb0_118z * cb0_117x;
  float _433 = cb0_118z * cb0_117y;
  bool _434 = (cb0_118x == 0.0f);
  float _444 = (cb0_114z * _121) + cb0_114x;
  float _445 = (cb0_114w * _122) + cb0_114y;
  float _456 = float((int)(((int)(uint)((bool)(_444 > 0.0f))) - ((int)(uint)((bool)(_444 < 0.0f)))));
  float _457 = float((int)(((int)(uint)((bool)(_445 > 0.0f))) - ((int)(uint)((bool)(_445 < 0.0f)))));
  float _462 = saturate(abs(_444) - cb0_117z);
  float _463 = saturate(abs(_445) - cb0_117z);
  float _473 = _445 - ((_463 * _432) * _457);
  float _475 = _445 - ((_463 * _433) * _457);
  bool _476 = (cb0_118x > 0.0f);
  if (_476) {
    _483 = (_473 - (cb0_118w * 0.4000000059604645f));
    _484 = (_475 - (cb0_118w * 0.20000000298023224f));
  } else {
    _483 = _473;
    _484 = _475;
  }
  float4 _518 = t0.Sample(s0, float2(_421, _422));
  float4 _522 = t0.Sample(s0, float2((((cb0_048z * ((cb0_115z * (_444 - ((_462 * select(_434, _432, cb0_117x)) * _456))) + cb0_115x)) + cb0_049x) * cb0_048x), (((cb0_048w * ((cb0_115w * _483) + cb0_115y)) + cb0_049y) * cb0_048y)));
  float4 _524 = t0.Sample(s0, float2((((cb0_048z * ((cb0_115z * (_444 - ((_462 * select(_434, _433, cb0_117y)) * _456))) + cb0_115x)) + cb0_049x) * cb0_048x), (((cb0_048w * ((cb0_115w * _484) + cb0_115y)) + cb0_049y) * cb0_048y)));
  if (_476) {
    float _534 = saturate(((((_518.y * 0.5870000123977661f) - cb0_118y) + (_518.x * 0.29899999499320984f)) + (_518.z * 0.11400000005960464f)) * 10.0f);
    float _538 = (_534 * _534) * (3.0f - (_534 * 2.0f));
    _552 = ((((_518.x - _522.x) + (_538 * (_522.x - _518.x))) * cb0_118x) + _522.x);
    _553 = ((((_518.y - _524.y) + (_538 * (_524.y - _518.y))) * cb0_118x) + _524.y);
  } else {
    _552 = _522.x;
    _553 = _524.y;
  }
  float _556 = saturate(cb0_099x);
  float _558 = saturate(cb0_099y);
  if (_556 > 0.0f) {
    float _569 = saturate(((_552 * 0.29899999499320984f) + (_518.z * 0.11400000005960464f)) + (_553 * 0.5870000123977661f));
    float _575 = ((_569 * _569) * (saturate(1.0f - cb0_099z) * 2.0f)) * (3.0f - (_569 * 2.0f));
    float _582 = max(sqrt(((_552 * _552) + (_518.z * _518.z)) + (_553 * _553)), 0.014999999664723873f);
    float _583 = _552 / _582;
    float _584 = _553 / _582;
    float _585 = _518.z / _582;
    float _595 = log2(_575);
    float _614 = ((_300 * _220) * _337) * _556;
    _625 = (((((lerp(_583, 1.0f, 0.25f)) * (((_558 * 0.17000000178813934f) + 0.029999999329447746f) + _575)) - _552) * _614) + _552);
    _626 = (((((((_558 * 0.18000000715255737f) + 0.05000000074505806f) + exp2(_595 * 0.8999999761581421f)) * (lerp(_584, 1.0f, 0.25f))) - _553) * _614) + _553);
    _627 = (((((((_558 * 0.17999999225139618f) + 0.07999999821186066f) + exp2(_595 * 0.949999988079071f)) * (lerp(_585, 1.0f, 0.25f))) - _518.z) * _614) + _518.z);
  } else {
    _625 = _552;
    _626 = _553;
    _627 = _518.z;
  }
  float _630 = saturate(cb0_100x);
  float _631 = _393 * _630;
  if (_630 > 0.0f) {
    float _642 = (sin(((_122 * 640.0f) + 640.0f) - (View_2376 * 10.0f)) * 0.5f) + 1.0f;
    _656 = ((((_642 * _625) - _625) * _631) + _625);
    _657 = ((((_642 * _626) - _626) * _631) + _626);
    _658 = ((((_642 * _627) - _627) * _631) + _627);
  } else {
    _656 = _625;
    _657 = _626;
    _658 = _627;
  }
  float _667 = log2(max(dot(float3(_656, _657, _658), float3(cb0_043x, cb0_043y, cb0_043z)), cb0_042x));
  float4 _685 = t7.Sample(s7, float3((cb0_046z * TEXCOORD_4.x), (cb0_046w * TEXCOORD_4.y), ((((cb0_041z * _667) + cb0_041w) * 0.96875f) + 0.015625f)));
  float4 _689 = t8.Sample(s8, float2(TEXCOORD_4.x, TEXCOORD_4.y));
  float _692 = select((_685.y < 0.0010000000474974513f), _689.x, (_685.x / _685.y));
  float _695 = log2(TEXCOORD_1.x);
  float _697 = (_692 + _695) + ((_689.x - _692) * cb0_046x);
  float _702 = _695 + _667;
  float _704 = _697 - log2((TEXCOORD_1.y * 0.18000000715255737f) * cb0_046y);
  bool _705 = (_704 > 0.0f);
  if (_705) {
    _717 = max(0.0f, (_704 - cb0_047x));
  } else {
    _717 = min(0.0f, (cb0_047y + _704));
  }
  float4 _749 = t1.Sample(s1, float2(min(max(((cb0_068z * _421) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _422) + cb0_069y), cb0_060w), cb0_061y)));
  APPLY_BLOOM(_749);
  [branch]
  if (!(cb0_085z == 0)) {
    bool _778 = (cb0_086x != 0);
    float4 _781 = t2.Sample(s2, float2(select(_778, _421, min(max(((cb0_076z * _421) + cb0_077x), cb0_075z), cb0_076x)), select(_778, _422, min(max(((cb0_076w * _422) + cb0_077y), cb0_075w), cb0_076y))));
    _789 = (_781.x + _749.x);
    _790 = (_781.y + _749.y);
    _791 = (_781.z + _749.z);
  } else {
    _789 = _749.x;
    _790 = _749.y;
    _791 = _749.z;
  }
  [branch]
  if (!(cb0_085w == 0)) {
    float4 _795 = t3.Sample(s3, float2(_421, _422));
    _803 = (_795.x + _789);
    _804 = (_795.y + _790);
    _805 = (_795.z + _791);
  } else {
    _803 = _789;
    _804 = _790;
    _805 = _791;
  }
  float _806 = exp2((((_697 - _702) + ((_702 - _697) * cb0_045w)) - _717) + (_717 * select(_705, cb0_045y, cb0_045z))) * TEXCOORD_1.x;
  float _831 = TEXCOORD_1.z + -1.0f;
  float _833 = TEXCOORD_1.w + -1.0f;
  float _836 = ((_831 + (cb0_091x * 2.0f)) * cb0_089z) * cb0_089x;
  float _838 = ((_833 + (cb0_091y * 2.0f)) * cb0_089w) * cb0_089x;
  float _845 = 1.0f / ((((saturate(cb0_090w) * 9.0f) + 1.0f) * dot(float2(_836, _838), float2(_836, _838))) + 1.0f);
  float _846 = _845 * _845;
  float _847 = cb0_091z + 1.0f;
  float _875 = ((_831 + (cb0_094x * 2.0f)) * cb0_092z) * cb0_092x;
  float _877 = ((_833 + (cb0_094y * 2.0f)) * cb0_092w) * cb0_092x;
  float _884 = 1.0f / ((((saturate(cb0_093w) * 9.0f) + 1.0f) * dot(float2(_875, _877), float2(_875, _877))) + 1.0f);
  float _885 = _884 * _884;
  float _886 = cb0_094z + 1.0f;
  float _898 = (((_803 + ((_806 * _656) * cb0_087x)) * _390) * ((_846 * (_847 - cb0_090x)) + cb0_090x)) * ((_885 * (_886 - cb0_093x)) + cb0_093x);
  float _901 = (((_804 + ((_806 * _657) * cb0_087y)) * _390) * ((_846 * (_847 - cb0_090y)) + cb0_090y)) * ((_885 * (_886 - cb0_093y)) + cb0_093y);
  float _904 = (((_805 + ((_806 * _658) * cb0_087z)) * _390) * ((_846 * (_847 - cb0_090z)) + cb0_090z)) * ((_885 * (_886 - cb0_093z)) + cb0_093z);

  CAPTURE_UNTONEMAPPED(float3(_898, _901, _904));
  [branch]
  if (WUWA_TM_IS(1)) {
    _937 = ((((_898 * 1.3600000143051147f) + 0.04699999839067459f) * _898) / ((((_898 * 0.9599999785423279f) + 0.5600000023841858f) * _898) + 0.14000000059604645f));
    _938 = ((((_901 * 1.3600000143051147f) + 0.04699999839067459f) * _901) / ((((_901 * 0.9599999785423279f) + 0.5600000023841858f) * _901) + 0.14000000059604645f));
    _939 = ((((_904 * 1.3600000143051147f) + 0.04699999839067459f) * _904) / ((((_904 * 0.9599999785423279f) + 0.5600000023841858f) * _904) + 0.14000000059604645f));
  } else {
    _937 = _898;
    _938 = _901;
    _939 = _904;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    float _949 = 1.0049500465393066f - (0.16398000717163086f / (_937 + -0.19505000114440918f));
    float _950 = 1.0049500465393066f - (0.16398000717163086f / (_938 + -0.19505000114440918f));
    float _951 = 1.0049500465393066f - (0.16398000717163086f / (_939 + -0.19505000114440918f));
    _971 = (((_937 - _949) * select((_937 > 0.6000000238418579f), 0.0f, 1.0f)) + _949);
    _972 = (((_938 - _950) * select((_938 > 0.6000000238418579f), 0.0f, 1.0f)) + _950);
    _973 = (((_939 - _951) * select((_939 > 0.6000000238418579f), 0.0f, 1.0f)) + _951);
  } else {
    _971 = _937;
    _972 = _938;
    _973 = _939;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    float _979 = cb0_037y * _971;
    float _980 = cb0_037y * _972;
    float _981 = cb0_037y * _973;
    float _984 = cb0_037z * cb0_037w;
    float _994 = cb0_038y * cb0_038x;
    float _1005 = cb0_038z * cb0_038x;
    float _1012 = cb0_038y / cb0_038z;
    _1020 = (((((_984 + _979) * _971) + _994) / (_1005 + ((_979 + cb0_037z) * _971))) - _1012);
    _1021 = (((((_984 + _980) * _972) + _994) / (_1005 + ((_980 + cb0_037z) * _972))) - _1012);
    _1022 = (((((_984 + _981) * _973) + _994) / (_1005 + ((_981 + cb0_037z) * _973))) - _1012);
  } else {
    _1020 = _971;
    _1021 = _972;
    _1022 = _973;
  }
  [branch]
  if (!(cb0_106w == 0)) {
    if (!(cb0_107x == 1.0f)) {
      float _1032 = (cb0_107x * 0.699999988079071f) + 0.30000001192092896f;
      _1037 = (_1032 * _1020);
      _1038 = (_1032 * _1021);
      _1039 = (_1032 * _1022);
    } else {
      _1037 = _1020;
      _1038 = _1021;
      _1039 = _1022;
    }
  } else {
    _1037 = _1020;
    _1038 = _1021;
    _1039 = _1022;
  }
  APPLY_EXTENDED_TONEMAP(_1037, _1038, _1039);
  float _1060 = (saturate((log2(_1037 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _1061 = (saturate((log2(_1038 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _1062 = (saturate((log2(_1039 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float4 _1063 = t9.Sample(s9, float3(_1060, _1061, _1062));
  [branch]
  if (!(cb0_108w == 0)) {
    float4 _1087 = t6.Sample(s6, float2(min(max(((cb0_084z * _421) + cb0_085x), cb0_083z), cb0_084x), min(max(((cb0_084w * _422) + cb0_085y), cb0_083w), cb0_084y)));
    float _1097 = select((((uint)(uint(float((uint)((int)((uint)(uint(round(_1087.w * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    float4 _1098 = t10.Sample(s10, float3(_1060, _1061, _1062));
    _1112 = (lerp(_1098.x, _1063.x, _1097));
    _1113 = (lerp(_1098.y, _1063.y, _1097));
    _1114 = (lerp(_1098.z, _1063.z, _1097));
  } else {
    _1112 = _1063.x;
    _1113 = _1063.y;
    _1114 = _1063.z;
  }
  float _1115 = _1114 * 1.0499999523162842f;
  float _1116 = _1113 * 1.0499999523162842f;
  float _1117 = _1112 * 1.0499999523162842f;
  float _1125 = ((_344 * 0.00390625f) + -0.001953125f) + _1117;
  float _1126 = ((_367 * 0.00390625f) + -0.001953125f) + _1116;
  float _1127 = ((_368 * 0.00390625f) + -0.001953125f) + _1115;
  [branch]
  if (!(cb0_107w == 0)) {
    float _1139 = (pow(_1125, 0.012683313339948654f));
    float _1140 = (pow(_1126, 0.012683313339948654f));
    float _1141 = (pow(_1127, 0.012683313339948654f));
    float _1174 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_1139 + -0.8359375f)) / (18.8515625f - (_1139 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    float _1175 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_1140 + -0.8359375f)) / (18.8515625f - (_1140 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    float _1176 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_1141 + -0.8359375f)) / (18.8515625f - (_1141 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    _1202 = min((_1174 * 12.920000076293945f), ((exp2(log2(max(_1174, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _1203 = min((_1175 * 12.920000076293945f), ((exp2(log2(max(_1175, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _1204 = min((_1176 * 12.920000076293945f), ((exp2(log2(max(_1176, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _1202 = _1125;
    _1203 = _1126;
    _1204 = _1127;
  }
  SV_Target.x = _1202;
  SV_Target.y = _1203;
  SV_Target.z = _1204;
  SV_Target.xyz = wuwa::InvertAndApplyDisplayMap(SV_Target.xyz);
  SV_Target.w = dot(float3(_1117, _1116, _1115), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}
