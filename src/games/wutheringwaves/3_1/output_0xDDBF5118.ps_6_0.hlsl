#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t5 : register(t5);

Texture3D<float4> t6 : register(t6);

Texture3D<float4> t7 : register(t7);

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
  uint cb0_085z : packoffset(c085.z);
  uint cb0_085w : packoffset(c085.w);
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
  float cb0_095z : packoffset(c095.z);
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
  uint cb0_105w : packoffset(c105.w);
  float cb0_106x : packoffset(c106.x);
  float cb0_106z : packoffset(c106.z);
  uint cb0_106w : packoffset(c106.w);
  uint cb0_107x : packoffset(c107.x);
  uint cb0_107y : packoffset(c107.y);
  uint cb0_107z : packoffset(c107.z);
  uint cb0_107w : packoffset(c107.w);
  float cb0_108y : packoffset(c108.y);
  float cb0_108z : packoffset(c108.z);
  float cb0_108w : packoffset(c108.w);
  float cb0_109x : packoffset(c109.x);
  float cb0_109y : packoffset(c109.y);
  float cb0_109z : packoffset(c109.z);
  float cb0_110x : packoffset(c110.x);
  float cb0_110y : packoffset(c110.y);
  float cb0_110z : packoffset(c110.z);
  float cb0_111x : packoffset(c111.x);
  float cb0_111y : packoffset(c111.y);
  float cb0_111z : packoffset(c111.z);
  uint cb0_111w : packoffset(c111.w);
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

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float4 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 TEXCOORD_2 : TEXCOORD2,
  noperspective float2 TEXCOORD_3 : TEXCOORD3,
  noperspective float2 TEXCOORD_4 : TEXCOORD4,
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _32 = cb0_065x * cb0_064w;
  float _33 = TEXCOORD_3.x * 0.5f;
  float _34 = TEXCOORD_3.y * 0.5f;
  float _105;
  float _106;
  float _114;
  float _115;
  float _213;
  float _214;
  float _215;
  float _237;
  float _244;
  float _251;
  float _258;
  float _293;
  float _294;
  float _295;
  float _330;
  float _331;
  float _332;
  float _358;
  float _359;
  float _381;
  float _411;
  float _412;
  float _498;
  float _499;
  float _593;
  float _594;
  float _665;
  float _666;
  float _667;
  float _696;
  float _697;
  float _698;
  float _762;
  float _763;
  float _764;
  float _887;
  float _888;
  float _889;
  float _922;
  float _923;
  float _924;
  float _956;
  float _957;
  float _958;
  float _1005;
  float _1006;
  float _1007;
  float _1022;
  float _1023;
  float _1024;
  float _1111;
  float _1112;
  float _1113;
  float _1198;
  float _1199;
  float _1200;
  float _1249;
  float _1250;
  float _1251;
  float _1252;
  float _1253;
  float _1254;
  if (!(!(cb0_101x != 0.0f))) {
    float _39 = cb0_101x * 2.0f;
    do {
      if (_39 > 0.0f) {
        float _43 = abs(_39) * 0.5f;
        float _44 = tan(_43);
        float _45 = _32 * TEXCOORD_3.x;
        float _55 = rsqrt(dot(float2(_45, TEXCOORD_3.y), float2(_45, TEXCOORD_3.y)));
        float _59 = rsqrt(dot(float2(_32, 1.0f), float2(_32, 1.0f)));
        float _64 = tan((sqrt((_45 * _45) + (TEXCOORD_3.y * TEXCOORD_3.y)) / sqrt((_32 * _32) + 1.0f)) * _43);
        _105 = (((_64 * ((_55 * _45) / (_59 * _32))) / _44) * 0.5f);
        _106 = (((_64 * ((_55 * TEXCOORD_3.y) / _59)) / _44) * 0.5f);
      } else {
        if (_39 < 0.0f) {
          float _78 = sqrt(((TEXCOORD_3.y * TEXCOORD_3.y) + (TEXCOORD_3.x * TEXCOORD_3.x)) * 0.25f);
          float _83 = (((_78 * _78) * (cb0_101x * 0.699999988079071f)) + 1.0f) * _78;
          float _85 = atan(_33 / _34);
          bool _88 = (_34 < 0.0f);
          bool _89 = (_34 == 0.0f);
          bool _90 = (_33 >= 0.0f);
          bool _91 = (_33 < 0.0f);
          float _99 = select((_90 && _89), 1.5707963705062866f, select((_91 && _89), -1.5707963705062866f, select((_91 && _88), (_85 + -3.1415927410125732f), select((_90 && _88), (_85 + 3.1415927410125732f), _85))));
          _105 = (sin(_99) * _83);
          _106 = (cos(_99) * _83);
        } else {
          _105 = _33;
          _106 = _34;
        }
      }
      _114 = (((_105 + 0.5f) * 2.0f) + -1.0f);
      _115 = (((_106 + 0.5f) * 2.0f) + -1.0f);
    } while (false);
  } else {
    _114 = TEXCOORD_3.x;
    _115 = TEXCOORD_3.y;
  }
  float _128 = ((cb0_048z * _114) + cb0_049x) * cb0_048x;
  float _129 = ((cb0_048w * _115) + cb0_049y) * cb0_048y;
  float4 _130 = t4.SampleLevel(s4, float2(_128, _129), 0.0f);
  float _142 = ((1.0f / ((View_1040.z * _130.x) - View_1040.w)) + View_1040.y) + (View_1040.x * _130.x);
  float4 _143 = t3.Sample(s3, float2(_128, _129));
  float _151 = 1.0f / ((_142 + View_1040.w) * View_1040.z);
  if (((bool)(!(cb0_096y == 0.0f))) || ((bool)(((bool)(((bool)(((bool)(((bool)(!(cb0_097y == 0.0f))) || ((bool)(!(cb0_101y == 0.0f))))) || ((bool)(!(cb0_102y == 0.0f))))) || ((bool)(!(cb0_103y == 0.0f))))) || ((bool)(!(cb0_104y == 0.0f)))))) {
    float _196 = 1.5f - (saturate(cb0_097z) * 1.4900000095367432f);
    float _201 = saturate(((sqrt((_115 * _115) + (_114 * _114)) - cb0_097y) - _196) / (-0.0f - _196));
    float _205 = (_201 * _201) * (3.0f - (_201 * 2.0f));
    _213 = (1.0f - (_205 * max(cb0_096y, cb0_101y)));
    _214 = (1.0f - (_205 * max(cb0_096y, cb0_102y)));
    _215 = (1.0f - (_205 * max(cb0_096y, cb0_103y)));
  } else {
    _213 = 1.0f;
    _214 = 1.0f;
    _215 = 1.0f;
  }
  bool _221 = !(cb0_096z == 0.0f);
  bool _222 = !(cb0_101z == 0.0f);
  bool _224 = !(cb0_102z == 0.0f);
  bool _226 = !(cb0_103z == 0.0f);
  if (((bool)(((bool)(((bool)(_221 || _222)) || _224)) || _226)) || ((bool)(!(cb0_104z == 0.0f)))) {
    do {
      if (_221) {
        _237 = exp2(log2(saturate(cb0_096z)) * 3.0f);
      } else {
        _237 = cb0_096z;
      }
      do {
        if (_222) {
          _244 = exp2(log2(saturate(cb0_101z)) * 3.0f);
        } else {
          _244 = cb0_101z;
        }
        do {
          if (_224) {
            _251 = exp2(log2(saturate(cb0_102z)) * 3.0f);
          } else {
            _251 = cb0_102z;
          }
          do {
            if (_226) {
              _258 = exp2(log2(saturate(cb0_103z)) * 3.0f);
            } else {
              _258 = cb0_103z;
            }
            float _259 = max(_237, _244);
            float _260 = max(_237, _251);
            float _261 = max(_237, _258);
            float _277 = saturate((_142 - (_259 * 1000.0f)) / ((_259 * 9999.990234375f) + 0.009999999776482582f));
            float _278 = saturate((_142 - (_260 * 1000.0f)) / ((_260 * 9999.990234375f) + 0.009999999776482582f));
            float _279 = saturate((_142 - (_261 * 1000.0f)) / ((_261 * 9999.990234375f) + 0.009999999776482582f));
            _293 = ((_277 * _277) * (3.0f - (_277 * 2.0f)));
            _294 = ((_278 * _278) * (3.0f - (_278 * 2.0f)));
            _295 = ((_279 * _279) * (3.0f - (_279 * 2.0f)));
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _293 = 1.0f;
    _294 = 1.0f;
    _295 = 1.0f;
  }
  if (((bool)(((bool)(((bool)(((bool)(!(cb0_097x == 0.0f))) || ((bool)(!(cb0_102x == 0.0f))))) || ((bool)(!(cb0_103x == 0.0f))))) || ((bool)(!(cb0_104x == 0.0f))))) || ((bool)(!(cb0_105x == 0.0f)))) {
    float _316 = saturate(select((((_151 - _143.x) + ((((View_448[3].z) - _151) + ((View_448[2].z) * _142)) * select(((View_448[3].w) < 1.0f), 0.0f, 1.0f))) > 0.0005000000237487257f), 1.0f, 0.0f) + select((_143.x > 0.0005000000237487257f), 0.0f, 1.0f));
    _330 = max(_316, (1.0f - saturate(max(cb0_097x, cb0_102x))));
    _331 = max(_316, (1.0f - saturate(max(cb0_097x, cb0_103x))));
    _332 = max(_316, (1.0f - saturate(max(cb0_097x, cb0_104x))));
  } else {
    _330 = 1.0f;
    _331 = 1.0f;
    _332 = 1.0f;
  }
  float _334 = (TEXCOORD_2.w * 543.3099975585938f) + TEXCOORD_2.z;
  float _337 = frac(sin(_334) * 493013.0f);
  if (cb0_096x > 0.0f) {
    _358 = (((frac((sin(_334 + 33.9900016784668f) * 493013.0f) + 7.177000045776367f) - _337) * cb0_096x) + _337);
    _359 = (((frac((sin(_334 + 66.98999786376953f) * 493013.0f) + 14.298999786376953f) - _337) * cb0_096x) + _337);
  } else {
    _358 = _337;
    _359 = _337;
  }
  if (cb0_099z > 0.0f) {
    _381 = (((((_295 * _215) * _332) * cb0_099z) * ((sin((((TEXCOORD_3.y * 10.0f) + 10.0f) + (_337 * 0.0020000000949949026f)) + (View_2376 * 4.0f)) * 0.5f) + 0.5f)) + 1.0f);
  } else {
    _381 = 1.0f;
  }
  float _384 = (_294 * _214) * _331;
  if (cb0_099y > 0.0f) {
    float _389 = View_2376 * 0.00016666666488163173f;
    float _393 = frac(abs(_389));
    float _398 = select((_389 >= (-0.0f - _389)), _393, (-0.0f - _393)) * ((TEXCOORD_3.y * 111000.0f) + 111000.0f);
    float _406 = ((_384 * 0.014999999664723873f) * cb0_099y) * (0.5f - frac(sin(dot(float2(_398, _398), float2(12.989800453186035f, 78.23300170898438f))) * 43758.546875f));
    _411 = ((_406 * 0.5f) + _128);
    _412 = (_406 + _129);
  } else {
    _411 = _128;
    _412 = _129;
  }
  float _417 = cb0_095z * (1.0f - (_337 * _337));
  float _422 = (_417 * (TEXCOORD_2.x - _411)) + _411;
  float _423 = (_417 * (TEXCOORD_2.y - _412)) + _412;
  float _438 = _422 - (((cb0_048z * _114) + cb0_049x) * cb0_048x);
  float _439 = _423 - (((cb0_048w * _115) + cb0_049y) * cb0_048y);
  float _449 = cb0_118z * cb0_117x;
  float _450 = cb0_118z * cb0_117y;
  bool _451 = (cb0_118x == 0.0f);
  float _461 = (cb0_114z * _114) + cb0_114x;
  float _462 = (cb0_114w * _115) + cb0_114y;
  float _481 = float(((int)(uint)((bool)(_461 > 0.0f))) - ((int)(uint)((bool)(_461 < 0.0f)))) * saturate(abs(_461) - cb0_117z);
  float _483 = float(((int)(uint)((bool)(_462 > 0.0f))) - ((int)(uint)((bool)(_462 < 0.0f)))) * saturate(abs(_462) - cb0_117z);
  float _488 = _462 - (_483 * _449);
  float _490 = _462 - (_483 * _450);
  bool _491 = (cb0_118x > 0.0f);
  if (_491) {
    _498 = (_488 - (cb0_118w * 0.4000000059604645f));
    _499 = (_490 - (cb0_118w * 0.20000000298023224f));
  } else {
    _498 = _488;
    _499 = _490;
  }
  float4 _535 = t0.Sample(s0, float2(min(max(_422, cb0_053z), cb0_054x), min(max(_423, cb0_053w), cb0_054y)));
  float4 _551 = t0.Sample(s0, float2(min(max(((((((cb0_115z * (_461 - (_481 * select(_451, _449, cb0_117x)))) + cb0_115x) * cb0_048z) + cb0_049x) * cb0_048x) + _438), cb0_053z), cb0_054x), min(max(((((((cb0_115w * _498) + cb0_115y) * cb0_048w) + cb0_049y) * cb0_048y) + _439), cb0_053w), cb0_054y)));
  float4 _565 = t0.Sample(s0, float2(min(max(((((((cb0_115z * (_461 - (_481 * select(_451, _450, cb0_117y)))) + cb0_115x) * cb0_048z) + cb0_049x) * cb0_048x) + _438), cb0_053z), cb0_054x), min(max(((((((cb0_115w * _499) + cb0_115y) * cb0_048w) + cb0_049y) * cb0_048y) + _439), cb0_053w), cb0_054y)));
  if (_491) {
    float _575 = saturate(((((_535.y * 0.5870000123977661f) - cb0_118y) + (_535.x * 0.29899999499320984f)) + (_535.z * 0.11400000005960464f)) * 10.0f);
    float _579 = (_575 * _575) * (3.0f - (_575 * 2.0f));
    _593 = ((((_535.x - _551.x) + (_579 * (_551.x - _535.x))) * cb0_118x) + _551.x);
    _594 = ((((_535.y - _565.y) + (_579 * (_565.y - _535.y))) * cb0_118x) + _565.y);
  } else {
    _593 = _551.x;
    _594 = _565.y;
  }
  float _597 = saturate(cb0_098x);
  float _599 = saturate(cb0_098y);
  if (_597 > 0.0f) {
    float _610 = saturate(((_593 * 0.29899999499320984f) + (_535.z * 0.11400000005960464f)) + (_594 * 0.5870000123977661f));
    float _611 = _610 * 2.0f;
    float _615 = ((_610 * saturate(1.0f - cb0_098z)) * _611) * (3.0f - _611);
    float _622 = max(sqrt(((_593 * _593) + (_535.z * _535.z)) + (_594 * _594)), 0.014999999664723873f);
    float _623 = _593 / _622;
    float _624 = _594 / _622;
    float _625 = _535.z / _622;
    float _635 = log2(_615);
    float _654 = ((_293 * _213) * _330) * _597;
    _665 = (((((lerp(_623, 1.0f, 0.25f)) * (((_599 * 0.17000000178813934f) + 0.029999999329447746f) + _615)) - _593) * _654) + _593);
    _666 = (((((((_599 * 0.18000000715255737f) + 0.05000000074505806f) + exp2(_635 * 0.8999999761581421f)) * (lerp(_624, 1.0f, 0.25f))) - _594) * _654) + _594);
    _667 = (((((((_599 * 0.17999999225139618f) + 0.07999999821186066f) + exp2(_635 * 0.949999988079071f)) * (lerp(_625, 1.0f, 0.25f))) - _535.z) * _654) + _535.z);
  } else {
    _665 = _593;
    _666 = _594;
    _667 = _535.z;
  }
  float _670 = saturate(cb0_099x);
  float _671 = _670 * _384;
  if (_670 > 0.0f) {
    float _682 = (sin(((_115 * 640.0f) + 640.0f) - (View_2376 * 10.0f)) * 0.5f) + 1.0f;
    _696 = ((((_682 * _665) - _665) * _671) + _665);
    _697 = ((((_682 * _666) - _666) * _671) + _666);
    _698 = ((((_682 * _667) - _667) * _671) + _667);
  } else {
    _696 = _665;
    _697 = _666;
    _698 = _667;
  }

  float4 _723 = t1.Sample(s1, float2(min(max(((cb0_068z * _422) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _423) + cb0_069y), cb0_060w), cb0_061y)));
  APPLY_BLOOM(_723);

  [branch]
  if (!((uint)(cb0_085z) == 0)) {
    bool _751 = ((uint)(cb0_085w) != 0);
    float4 _754 = t2.Sample(s2, float2(select(_751, _422, min(max(((cb0_076z * _422) + cb0_077x), cb0_075z), cb0_076x)), select(_751, _423, min(max(((cb0_076w * _423) + cb0_077y), cb0_075w), cb0_076y))));
    _762 = (_754.x + _723.x);
    _763 = (_754.y + _723.y);
    _764 = (_754.z + _723.z);
  } else {
    _762 = _723.x;
    _763 = _723.y;
    _764 = _723.z;
  }
  float _789 = TEXCOORD_1.z + -1.0f;
  float _791 = TEXCOORD_1.w + -1.0f;
  float _794 = (((cb0_090x * 2.0f) + _789) * cb0_088z) * cb0_088x;
  float _796 = (((cb0_090y * 2.0f) + _791) * cb0_088w) * cb0_088x;
  float _803 = 1.0f / ((((saturate(cb0_089w) * 9.0f) + 1.0f) * dot(float2(_794, _796), float2(_794, _796))) + 1.0f);
  float _804 = _803 * _803;
  float _805 = cb0_090z + 1.0f;
  float _833 = (((cb0_093x * 2.0f) + _789) * cb0_091z) * cb0_091x;
  float _835 = (((cb0_093y * 2.0f) + _791) * cb0_091w) * cb0_091x;
  float _842 = 1.0f / ((((saturate(cb0_092w) * 9.0f) + 1.0f) * dot(float2(_833, _835), float2(_833, _835))) + 1.0f);
  float _843 = _842 * _842;
  float _844 = cb0_093z + 1.0f;
  float _856 = (((_762 + ((_696 * TEXCOORD_1.x) * cb0_086x)) * _381) * ((_804 * (_805 - cb0_089x)) + cb0_089x)) * ((_843 * (_844 - cb0_092x)) + cb0_092x);
  float _859 = (((_763 + ((_697 * TEXCOORD_1.x) * cb0_086y)) * _381) * ((_804 * (_805 - cb0_089y)) + cb0_089y)) * ((_843 * (_844 - cb0_092y)) + cb0_092y);
  float _862 = (((_764 + ((_698 * TEXCOORD_1.x) * cb0_086z)) * _381) * ((_804 * (_805 - cb0_089z)) + cb0_089z)) * ((_843 * (_844 - cb0_092z)) + cb0_092z);

  CAPTURE_UNTONEMAPPED(float3(_856, _859, _862));

  [branch]
  if (false) {
    float _876 = ((((cb0_111z + 1.0f) * 0.009900989942252636f) * (cb0_111x - cb0_111y)) + cb0_111y) * -1.4426950216293335f;
    _887 = (1.0f - exp2(_876 * _856));
    _888 = (1.0f - exp2(_876 * _859));
    _889 = (1.0f - exp2(_876 * _862));
  } else {
    _887 = _856;
    _888 = _859;
    _889 = _862;
  }
  [branch]
  if (WUWA_TM_IS(1)) {
    _922 = ((((_887 * 1.3600000143051147f) + 0.04699999839067459f) * _887) / ((((_887 * 0.9599999785423279f) + 0.5600000023841858f) * _887) + 0.14000000059604645f));
    _923 = ((((_888 * 1.3600000143051147f) + 0.04699999839067459f) * _888) / ((((_888 * 0.9599999785423279f) + 0.5600000023841858f) * _888) + 0.14000000059604645f));
    _924 = ((((_889 * 1.3600000143051147f) + 0.04699999839067459f) * _889) / ((((_889 * 0.9599999785423279f) + 0.5600000023841858f) * _889) + 0.14000000059604645f));
  } else {
    _922 = _887;
    _923 = _888;
    _924 = _889;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    float _934 = 1.0049500465393066f - (0.16398000717163086f / (_922 + -0.19505000114440918f));
    float _935 = 1.0049500465393066f - (0.16398000717163086f / (_923 + -0.19505000114440918f));
    float _936 = 1.0049500465393066f - (0.16398000717163086f / (_924 + -0.19505000114440918f));
    _956 = (((_922 - _934) * select((_922 > 0.6000000238418579f), 0.0f, 1.0f)) + _934);
    _957 = (((_923 - _935) * select((_923 > 0.6000000238418579f), 0.0f, 1.0f)) + _935);
    _958 = (((_924 - _936) * select((_924 > 0.6000000238418579f), 0.0f, 1.0f)) + _936);
  } else {
    _956 = _922;
    _957 = _923;
    _958 = _924;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    float _964 = cb0_037y * _956;
    float _965 = cb0_037y * _957;
    float _966 = cb0_037y * _958;
    float _969 = cb0_037z * cb0_037w;
    float _979 = cb0_038y * cb0_038x;
    float _990 = cb0_038z * cb0_038x;
    float _997 = cb0_038y / cb0_038z;
    _1005 = (((((_969 + _964) * _956) + _979) / (((_964 + cb0_037z) * _956) + _990)) - _997);
    _1006 = (((((_969 + _965) * _957) + _979) / (((_965 + cb0_037z) * _957) + _990)) - _997);
    _1007 = (((((_969 + _966) * _958) + _979) / (((_966 + cb0_037z) * _958) + _990)) - _997);
  } else {
    _1005 = _956;
    _1006 = _957;
    _1007 = _958;
  }
  [branch]
  if (!((uint)(cb0_105w) == 0)) {
    if (!(cb0_106x == 1.0f)) {
      float _1017 = (cb0_106x * 0.699999988079071f) + 0.30000001192092896f;
      _1022 = (_1017 * _1005);
      _1023 = (_1017 * _1006);
      _1024 = (_1017 * _1007);
    } else {
      _1022 = _1005;
      _1023 = _1006;
      _1024 = _1007;
    }
  } else {
    _1022 = _1005;
    _1023 = _1006;
    _1024 = _1007;
  }

  CLAMP_IF_SDR3(_1022, _1023, _1024);
  CAPTURE_TONEMAPPED(float3(_1022, _1023, _1024));

  float _1039 = (saturate((log2(_1024 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _1043 = (saturate((log2(_1023 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _1047 = (saturate((log2(_1022 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  [branch]
  if (!((uint)(cb0_107w) == 0)) {
    float4 _1068 = t5.Sample(s5, float2(min(max(((cb0_084z * _422) + cb0_085x), cb0_083z), cb0_084x), min(max(((cb0_084w * _423) + cb0_085y), cb0_083w), cb0_084y)));
    float _1078 = select((((uint)(uint(float((uint)((int)((uint)(uint(round(_1068.w * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    float4 _1079 = t7.Sample(s7, float3(_1047, _1043, _1039));
    float4 _1086 = t6.Sample(s6, float3(_1047, _1043, _1039));
    _1111 = ((((_1086.x - _1079.x) * 1.0499999523162842f) * _1078) + (_1079.x * 1.0499999523162842f));
    _1112 = ((((_1086.y - _1079.y) * 1.0499999523162842f) * _1078) + (_1079.y * 1.0499999523162842f));
    _1113 = ((((_1086.z - _1079.z) * 1.0499999523162842f) * _1078) + (_1079.z * 1.0499999523162842f));
  } else {
    float4 _1103 = t6.Sample(s6, float3(_1047, _1043, _1039));
    _1111 = (_1103.x * 1.0499999523162842f);
    _1112 = (_1103.y * 1.0499999523162842f);
    _1113 = (_1103.z * 1.0499999523162842f);
  }
  HANDLE_LUT_OUTPUT3(_1111, _1112, _1113);

  float _1121 = ((_337 * 0.00390625f) + -0.001953125f) + _1111;
  float _1122 = ((_358 * 0.00390625f) + -0.001953125f) + _1112;
  float _1123 = ((_359 * 0.00390625f) + -0.001953125f) + _1113;
  [branch]
  if (!((uint)(cb0_106w) == 0)) {
    float _1135 = (pow(_1121, 0.012683313339948654f));
    float _1136 = (pow(_1122, 0.012683313339948654f));
    float _1137 = (pow(_1123, 0.012683313339948654f));
    float _1170 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_1135 + -0.8359375f)) / (18.8515625f - (_1135 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    float _1171 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_1136 + -0.8359375f)) / (18.8515625f - (_1136 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    float _1172 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_1137 + -0.8359375f)) / (18.8515625f - (_1137 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_106z));
    _1198 = min((_1170 * 12.920000076293945f), ((exp2(log2(max(_1170, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _1199 = min((_1171 * 12.920000076293945f), ((exp2(log2(max(_1171, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _1200 = min((_1172 * 12.920000076293945f), ((exp2(log2(max(_1172, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _1198 = _1121;
    _1199 = _1122;
    _1200 = _1123;
  }

  GENERATE_INVERSION(_1198, _1199, _1200);

  float _1209 = ((((_1199 * 587.0f) + (_1198 * 299.0f)) + (_1200 * 114.0f)) * 0.0010000000474974513f) - cb0_108w;
  float _1216 = saturate(float(((int)(uint)((bool)(_1209 > 0.0f))) - ((int)(uint)((bool)(_1209 < 0.0f)))));
  float _1223 = cb0_109x - _1198;
  float _1224 = cb0_109y - _1199;
  float _1225 = cb0_109z - _1200;

  float _1230 = WUWA_PEAK_SCALING * cb0_110x - _1198;
  float _1231 = WUWA_PEAK_SCALING * cb0_110y - _1199;
  float _1232 = WUWA_PEAK_SCALING * cb0_110z - _1200;

  [branch]
  if (cb0_108z > 0.0f) {
    _1249 = (_1223 * cb0_108z);
    _1250 = (_1224 * cb0_108z);
    _1251 = (_1225 * cb0_108z);
    _1252 = (_1230 * cb0_108z);
    _1253 = (_1231 * cb0_108z);
    _1254 = (_1232 * cb0_108z);
  } else {
    float _1241 = abs(cb0_108z);
    _1249 = (_1241 * _1230);
    _1250 = (_1241 * _1231);
    _1251 = (_1241 * _1232);
    _1252 = (_1241 * _1223);
    _1253 = (_1241 * _1224);
    _1254 = (_1241 * _1225);
  }
  SV_Target.x = (((lerp(_1249, _1252, _1216)) * cb0_108y) + _1198);
  SV_Target.y = (((lerp(_1250, _1253, _1216)) * cb0_108y) + _1199);
  SV_Target.z = (((lerp(_1251, _1254, _1216)) * cb0_108y) + _1200);

  SV_Target.rgb = renodx::draw::RenderIntermediatePass(SV_Target.rgb);

  SV_Target.w = (dot(float3(_1111, _1112, _1113), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);

  return SV_Target;
}
