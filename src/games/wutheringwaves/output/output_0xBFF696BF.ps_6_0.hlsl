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
  float cb0_069x : packoffset(c069.x);
  float cb0_069y : packoffset(c069.y);
  float cb0_069z : packoffset(c069.z);
  float cb0_071x : packoffset(c071.x);
  float cb0_071z : packoffset(c071.z);
  float cb0_071w : packoffset(c071.w);
  float cb0_072x : packoffset(c072.x);
  float cb0_072y : packoffset(c072.y);
  float cb0_072z : packoffset(c072.z);
  float cb0_072w : packoffset(c072.w);
  float cb0_073x : packoffset(c073.x);
  float cb0_073y : packoffset(c073.y);
  float cb0_074x : packoffset(c074.x);
  float cb0_074z : packoffset(c074.z);
  float cb0_074w : packoffset(c074.w);
  float cb0_075x : packoffset(c075.x);
  float cb0_075y : packoffset(c075.y);
  float cb0_075z : packoffset(c075.z);
  float cb0_075w : packoffset(c075.w);
  float cb0_076x : packoffset(c076.x);
  float cb0_076y : packoffset(c076.y);
  float cb0_079x : packoffset(c079.x);
  float cb0_079y : packoffset(c079.y);
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
  float cb0_084x : packoffset(c084.x);
  float cb0_084y : packoffset(c084.y);
  float cb0_084z : packoffset(c084.z);
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
  float cb0_088w : packoffset(c088.w);
  uint cb0_089x : packoffset(c089.x);
  uint cb0_089y : packoffset(c089.y);
  uint cb0_089z : packoffset(c089.z);
  uint cb0_089w : packoffset(c089.w);
};

cbuffer cb1 : register(b1) {
  float4 dx_alignment_legacy_View_000[4] : packoffset(c000.x);
  float4 dx_alignment_legacy_View_064[4] : packoffset(c004.x);
  float4 dx_alignment_legacy_View_128[4] : packoffset(c008.x);
  float4 dx_alignment_legacy_View_192[4] : packoffset(c012.x);
  float4 dx_alignment_legacy_View_256[4] : packoffset(c016.x);
  float4 dx_alignment_legacy_View_320[4] : packoffset(c020.x);
  float4 dx_alignment_legacy_View_384[4] : packoffset(c024.x);
  float4 dx_alignment_legacy_View_448[4] : packoffset(c028.x);
  float4 dx_alignment_legacy_View_512[4] : packoffset(c032.x);
  float4 dx_alignment_legacy_View_576[4] : packoffset(c036.x);
  float4 dx_alignment_legacy_View_640[4] : packoffset(c040.x);
  float4 dx_alignment_legacy_View_704[4] : packoffset(c044.x);
  float4 dx_alignment_legacy_View_768[4] : packoffset(c048.x);
  float4 dx_alignment_legacy_View_832[4] : packoffset(c052.x);
  float4 dx_alignment_legacy_View_896[4] : packoffset(c056.x);
  float3 dx_alignment_legacy_View_960 : packoffset(c060.x);
  float dx_alignment_legacy_View_972 : packoffset(c060.w);
  float3 dx_alignment_legacy_View_976 : packoffset(c061.x);
  float dx_alignment_legacy_View_988 : packoffset(c061.w);
  float3 dx_alignment_legacy_View_992 : packoffset(c062.x);
  float dx_alignment_legacy_View_1004 : packoffset(c062.w);
  float3 dx_alignment_legacy_View_1008 : packoffset(c063.x);
  float dx_alignment_legacy_View_1020 : packoffset(c063.w);
  float3 dx_alignment_legacy_View_1024 : packoffset(c064.x);
  float dx_alignment_legacy_View_1036 : packoffset(c064.w);
  float4 dx_alignment_legacy_View_1040 : packoffset(c065.x);
  float4 dx_alignment_legacy_View_1056 : packoffset(c066.x);
  float3 dx_alignment_legacy_View_1072 : packoffset(c067.x);
  float dx_alignment_legacy_View_1084 : packoffset(c067.w);
  float3 dx_alignment_legacy_View_1088 : packoffset(c068.x);
  float dx_alignment_legacy_View_1100 : packoffset(c068.w);
  float3 dx_alignment_legacy_View_1104 : packoffset(c069.x);
  float dx_alignment_legacy_View_1116 : packoffset(c069.w);
  float3 dx_alignment_legacy_View_1120 : packoffset(c070.x);
  float dx_alignment_legacy_View_1132 : packoffset(c070.w);
  float4 dx_alignment_legacy_View_1136[4] : packoffset(c071.x);
  float4 dx_alignment_legacy_View_1200[4] : packoffset(c075.x);
  float4 dx_alignment_legacy_View_1264[4] : packoffset(c079.x);
  float4 dx_alignment_legacy_View_1328[4] : packoffset(c083.x);
  float4 dx_alignment_legacy_View_1392[4] : packoffset(c087.x);
  float4 dx_alignment_legacy_View_1456[4] : packoffset(c091.x);
  float4 dx_alignment_legacy_View_1520[4] : packoffset(c095.x);
  float4 dx_alignment_legacy_View_1584[4] : packoffset(c099.x);
  float4 dx_alignment_legacy_View_1648[4] : packoffset(c103.x);
  float4 dx_alignment_legacy_View_1712[4] : packoffset(c107.x);
  float4 dx_alignment_legacy_View_1776[4] : packoffset(c111.x);
  float3 dx_alignment_legacy_View_1840 : packoffset(c115.x);
  float dx_alignment_legacy_View_1852 : packoffset(c115.w);
  float3 dx_alignment_legacy_View_1856 : packoffset(c116.x);
  float dx_alignment_legacy_View_1868 : packoffset(c116.w);
  float3 dx_alignment_legacy_View_1872 : packoffset(c117.x);
  float dx_alignment_legacy_View_1884 : packoffset(c117.w);
  float4 dx_alignment_legacy_View_1888[4] : packoffset(c118.x);
  float4 dx_alignment_legacy_View_1952[4] : packoffset(c122.x);
  float4 dx_alignment_legacy_View_2016 : packoffset(c126.x);
  float4 dx_alignment_legacy_View_2032[4] : packoffset(c127.x);
  float4 dx_alignment_legacy_View_2096 : packoffset(c131.x);
  float4 dx_alignment_legacy_View_2112 : packoffset(c132.x);
  float2 dx_alignment_legacy_View_2128 : packoffset(c133.x);
  float2 dx_alignment_legacy_View_2136 : packoffset(c133.z);
  float4 dx_alignment_legacy_View_2144 : packoffset(c134.x);
  float4 dx_alignment_legacy_View_2160 : packoffset(c135.x);
  int4 dx_alignment_legacy_View_2176 : packoffset(c136.x);
  float4 dx_alignment_legacy_View_2192 : packoffset(c137.x);
  float4 dx_alignment_legacy_View_2208 : packoffset(c138.x);
  float4 dx_alignment_legacy_View_2224 : packoffset(c139.x);
  float4 dx_alignment_legacy_View_2240 : packoffset(c140.x);
  int dx_alignment_legacy_View_2256 : packoffset(c141.x);
  float dx_alignment_legacy_View_2260 : packoffset(c141.y);
  float dx_alignment_legacy_View_2264 : packoffset(c141.z);
  float dx_alignment_legacy_View_2268 : packoffset(c141.w);
  float4 dx_alignment_legacy_View_2272 : packoffset(c142.x);
  float4 dx_alignment_legacy_View_2288 : packoffset(c143.x);
  float4 dx_alignment_legacy_View_2304 : packoffset(c144.x);
  float2 dx_alignment_legacy_View_2320 : packoffset(c145.x);
  float dx_alignment_legacy_View_2328 : packoffset(c145.z);
  float dx_alignment_legacy_View_2332 : packoffset(c145.w);
  float dx_alignment_legacy_View_2336 : packoffset(c146.x);
  float dx_alignment_legacy_View_2340 : packoffset(c146.y);
  float dx_alignment_legacy_View_2344 : packoffset(c146.z);
  float dx_alignment_legacy_View_2348 : packoffset(c146.w);
  float3 dx_alignment_legacy_View_2352 : packoffset(c147.x);
  float dx_alignment_legacy_View_2364 : packoffset(c147.w);
  float dx_alignment_legacy_View_2368 : packoffset(c148.x);
  float dx_alignment_legacy_View_2372 : packoffset(c148.y);
  float dx_alignment_legacy_View_2376 : packoffset(c148.z);
  float dx_alignment_legacy_View_2380 : packoffset(c148.w);
  float dx_alignment_legacy_View_2384 : packoffset(c149.x);
  float dx_alignment_legacy_View_2388 : packoffset(c149.y);
  float dx_alignment_legacy_View_2392 : packoffset(c149.z);
  int dx_alignment_legacy_View_2396 : packoffset(c149.w);
  int dx_alignment_legacy_View_2400 : packoffset(c150.x);
  int dx_alignment_legacy_View_2404 : packoffset(c150.y);
  int dx_alignment_legacy_View_2408 : packoffset(c150.z);
  int dx_alignment_legacy_View_2412 : packoffset(c150.w);
  float dx_alignment_legacy_View_2416 : packoffset(c151.x);
  float dx_alignment_legacy_View_2420 : packoffset(c151.y);
  float dx_alignment_legacy_View_2424 : packoffset(c151.z);
  float dx_alignment_legacy_View_2428 : packoffset(c151.w);
  float4 dx_alignment_legacy_View_2432 : packoffset(c152.x);
  float3 dx_alignment_legacy_View_2448 : packoffset(c153.x);
  float dx_alignment_legacy_View_2460 : packoffset(c153.w);
  float4 dx_alignment_legacy_View_2464[2] : packoffset(c154.x);
  float4 dx_alignment_legacy_View_2496[2] : packoffset(c156.x);
  float4 dx_alignment_legacy_View_2528 : packoffset(c158.x);
  float4 dx_alignment_legacy_View_2544 : packoffset(c159.x);
  int dx_alignment_legacy_View_2560 : packoffset(c160.x);
  float dx_alignment_legacy_View_2564 : packoffset(c160.y);
  float dx_alignment_legacy_View_2568 : packoffset(c160.z);
  float dx_alignment_legacy_View_2572 : packoffset(c160.w);
  float dx_alignment_legacy_View_2576 : packoffset(c161.x);
  float dx_alignment_legacy_View_2580 : packoffset(c161.y);
  float dx_alignment_legacy_View_2584 : packoffset(c161.z);
  float dx_alignment_legacy_View_2588 : packoffset(c161.w);
  float dx_alignment_legacy_View_2592 : packoffset(c162.x);
  float dx_alignment_legacy_View_2596 : packoffset(c162.y);
  float dx_alignment_legacy_View_2600 : packoffset(c162.z);
  float dx_alignment_legacy_View_2604 : packoffset(c162.w);
  float3 dx_alignment_legacy_View_2608 : packoffset(c163.x);
  float dx_alignment_legacy_View_2620 : packoffset(c163.w);
  float dx_alignment_legacy_View_2624 : packoffset(c164.x);
  float dx_alignment_legacy_View_2628 : packoffset(c164.y);
  float dx_alignment_legacy_View_2632 : packoffset(c164.z);
  float dx_alignment_legacy_View_2636 : packoffset(c164.w);
  float dx_alignment_legacy_View_2640 : packoffset(c165.x);
  float dx_alignment_legacy_View_2644 : packoffset(c165.y);
  float dx_alignment_legacy_View_2648 : packoffset(c165.z);
  float dx_alignment_legacy_View_2652 : packoffset(c165.w);
  float dx_alignment_legacy_View_2656 : packoffset(c166.x);
  float dx_alignment_legacy_View_2660 : packoffset(c166.y);
  float dx_alignment_legacy_View_2664 : packoffset(c166.z);
  float dx_alignment_legacy_View_2668 : packoffset(c166.w);
  float4 dx_alignment_legacy_View_2672[2] : packoffset(c167.x);
  float4 dx_alignment_legacy_View_2704[2] : packoffset(c169.x);
  float4 dx_alignment_legacy_View_2736[2] : packoffset(c171.x);
  float4 dx_alignment_legacy_View_2768[2] : packoffset(c173.x);
  float4 dx_alignment_legacy_View_2800[2] : packoffset(c175.x);
  float4 dx_alignment_legacy_View_2832 : packoffset(c177.x);
  float3 dx_alignment_legacy_View_2848 : packoffset(c178.x);
  float dx_alignment_legacy_View_2860 : packoffset(c178.w);
  float4 dx_alignment_legacy_View_2864 : packoffset(c179.x);
  float4 dx_alignment_legacy_View_2880[4] : packoffset(c180.x);
  float4 dx_alignment_legacy_View_2944 : packoffset(c184.x);
  float dx_alignment_legacy_View_2960 : packoffset(c185.x);
  float dx_alignment_legacy_View_2964 : packoffset(c185.y);
  float dx_alignment_legacy_View_2968 : packoffset(c185.z);
  float dx_alignment_legacy_View_2972 : packoffset(c185.w);
  float4 dx_alignment_legacy_View_2976 : packoffset(c186.x);
  float dx_alignment_legacy_View_2992 : packoffset(c187.x);
  float dx_alignment_legacy_View_2996 : packoffset(c187.y);
  float dx_alignment_legacy_View_3000 : packoffset(c187.z);
  float dx_alignment_legacy_View_3004 : packoffset(c187.w);
  float dx_alignment_legacy_View_3008 : packoffset(c188.x);
  float dx_alignment_legacy_View_3012 : packoffset(c188.y);
  int dx_alignment_legacy_View_3016 : packoffset(c188.z);
  int dx_alignment_legacy_View_3020 : packoffset(c188.w);
  float3 dx_alignment_legacy_View_3024 : packoffset(c189.x);
  float dx_alignment_legacy_View_3036 : packoffset(c189.w);
  float dx_alignment_legacy_View_3040 : packoffset(c190.x);
  float dx_alignment_legacy_View_3044 : packoffset(c190.y);
  float dx_alignment_legacy_View_3048 : packoffset(c190.z);
  float dx_alignment_legacy_View_3052 : packoffset(c190.w);
  float4 dx_alignment_legacy_View_3056 : packoffset(c191.x);
  float dx_alignment_legacy_View_3072 : packoffset(c192.x);
  float dx_alignment_legacy_View_3076 : packoffset(c192.y);
  float dx_alignment_legacy_View_3080 : packoffset(c192.z);
  float dx_alignment_legacy_View_3084 : packoffset(c192.w);
  float4 dx_alignment_legacy_View_3088 : packoffset(c193.x);
  float dx_alignment_legacy_View_3104 : packoffset(c194.x);
  float dx_alignment_legacy_View_3108 : packoffset(c194.y);
  float dx_alignment_legacy_View_3112 : packoffset(c194.z);
  float dx_alignment_legacy_View_3116 : packoffset(c194.w);
  float4 dx_alignment_legacy_View_3120 : packoffset(c195.x);
  float4 dx_alignment_legacy_View_3136 : packoffset(c196.x);
  float4 dx_alignment_legacy_View_3152 : packoffset(c197.x);
  float dx_alignment_legacy_View_3168 : packoffset(c198.x);
  float dx_alignment_legacy_View_3172 : packoffset(c198.y);
  float dx_alignment_legacy_View_3176 : packoffset(c198.z);
  float dx_alignment_legacy_View_3180 : packoffset(c198.w);
  float dx_alignment_legacy_View_3184 : packoffset(c199.x);
  float dx_alignment_legacy_View_3188 : packoffset(c199.y);
  float dx_alignment_legacy_View_3192 : packoffset(c199.z);
  float dx_alignment_legacy_View_3196 : packoffset(c199.w);
  float4 dx_alignment_legacy_View_3200 : packoffset(c200.x);
  float4 dx_alignment_legacy_View_3216[7] : packoffset(c201.x);
  float dx_alignment_legacy_View_3328 : packoffset(c208.x);
  float dx_alignment_legacy_View_3332 : packoffset(c208.y);
  float dx_alignment_legacy_View_3336 : packoffset(c208.z);
  float dx_alignment_legacy_View_3340 : packoffset(c208.w);
  int dx_alignment_legacy_View_3344 : packoffset(c209.x);
  float dx_alignment_legacy_View_3348 : packoffset(c209.y);
  float dx_alignment_legacy_View_3352 : packoffset(c209.z);
  float dx_alignment_legacy_View_3356 : packoffset(c209.w);
  float3 dx_alignment_legacy_View_3360 : packoffset(c210.x);
  int dx_alignment_legacy_View_3372 : packoffset(c210.w);
  float4 dx_alignment_legacy_View_3376[4] : packoffset(c211.x);
  float4 dx_alignment_legacy_View_3440[4] : packoffset(c215.x);
  float dx_alignment_legacy_View_3504 : packoffset(c219.x);
  float dx_alignment_legacy_View_3508 : packoffset(c219.y);
  float dx_alignment_legacy_View_3512 : packoffset(c219.z);
  float dx_alignment_legacy_View_3516 : packoffset(c219.w);
  int2 dx_alignment_legacy_View_3520 : packoffset(c220.x);
  float dx_alignment_legacy_View_3528 : packoffset(c220.z);
  float dx_alignment_legacy_View_3532 : packoffset(c220.w);
  float3 dx_alignment_legacy_View_3536 : packoffset(c221.x);
  float dx_alignment_legacy_View_3548 : packoffset(c221.w);
  float3 dx_alignment_legacy_View_3552 : packoffset(c222.x);
  float dx_alignment_legacy_View_3564 : packoffset(c222.w);
  float2 dx_alignment_legacy_View_3568 : packoffset(c223.x);
  float dx_alignment_legacy_View_3576 : packoffset(c223.z);
  float dx_alignment_legacy_View_3580 : packoffset(c223.w);
  float3 dx_alignment_legacy_View_3584 : packoffset(c224.x);
  float dx_alignment_legacy_View_3596 : packoffset(c224.w);
  float3 dx_alignment_legacy_View_3600 : packoffset(c225.x);
  float dx_alignment_legacy_View_3612 : packoffset(c225.w);
  float3 dx_alignment_legacy_View_3616 : packoffset(c226.x);
  float dx_alignment_legacy_View_3628 : packoffset(c226.w);
  float3 dx_alignment_legacy_View_3632 : packoffset(c227.x);
  float dx_alignment_legacy_View_3644 : packoffset(c227.w);
  float dx_alignment_legacy_View_3648 : packoffset(c228.x);
  float dx_alignment_legacy_View_3652 : packoffset(c228.y);
  float dx_alignment_legacy_View_3656 : packoffset(c228.z);
  float dx_alignment_legacy_View_3660 : packoffset(c228.w);
  float4 dx_alignment_legacy_View_3664[4] : packoffset(c229.x);
  float4 dx_alignment_legacy_View_3728[2] : packoffset(c233.x);
  int dx_alignment_legacy_View_3760 : packoffset(c235.x);
  float dx_alignment_legacy_View_3764 : packoffset(c235.y);
  float dx_alignment_legacy_View_3768 : packoffset(c235.z);
  float dx_alignment_legacy_View_3772 : packoffset(c235.w);
  float4 dx_alignment_legacy_View_3776 : packoffset(c236.x);
  float2 dx_alignment_legacy_View_3792 : packoffset(c237.x);
  float dx_alignment_legacy_View_3800 : packoffset(c237.z);
  float dx_alignment_legacy_View_3804 : packoffset(c237.w);
  float4 dx_alignment_legacy_View_3808 : packoffset(c238.x);
  int dx_alignment_legacy_View_3824 : packoffset(c239.x);
  float dx_alignment_legacy_View_3828 : packoffset(c239.y);
  float dx_alignment_legacy_View_3832 : packoffset(c239.z);
  float dx_alignment_legacy_View_3836 : packoffset(c239.w);
  float4 dx_alignment_legacy_View_3840 : packoffset(c240.x);
  int dx_alignment_legacy_View_3856 : packoffset(c241.x);
  int dx_alignment_legacy_View_3860 : packoffset(c241.y);
  int dx_alignment_legacy_View_3864 : packoffset(c241.z);
  float dx_alignment_legacy_View_3868 : packoffset(c241.w);
  float dx_alignment_legacy_View_3872 : packoffset(c242.x);
  float dx_alignment_legacy_View_3876 : packoffset(c242.y);
  float dx_alignment_legacy_View_3880 : packoffset(c242.z);
  float dx_alignment_legacy_View_3884 : packoffset(c242.w);
  float4 dx_alignment_legacy_View_3888 : packoffset(c243.x);
  float4 dx_alignment_legacy_View_3904 : packoffset(c244.x);
  float4 dx_alignment_legacy_View_3920 : packoffset(c245.x);
  float4 dx_alignment_legacy_View_3936 : packoffset(c246.x);
  float4 dx_alignment_legacy_View_3952 : packoffset(c247.x);
  float4 dx_alignment_legacy_View_3968 : packoffset(c248.x);
  int dx_alignment_legacy_View_3984 : packoffset(c249.x);
  float dx_alignment_legacy_View_3988 : packoffset(c249.y);
  float dx_alignment_legacy_View_3992 : packoffset(c249.z);
  float dx_alignment_legacy_View_3996 : packoffset(c249.w);
  float4 dx_alignment_legacy_View_4000 : packoffset(c250.x);
  float4 dx_alignment_legacy_View_4016 : packoffset(c251.x);
  float dx_alignment_legacy_View_4032 : packoffset(c252.x);
  float dx_alignment_legacy_View_4036 : packoffset(c252.y);
  float dx_alignment_legacy_View_4040 : packoffset(c252.z);
  float dx_alignment_legacy_View_4044 : packoffset(c252.w);
  float dx_alignment_legacy_View_4048 : packoffset(c253.x);
  float dx_alignment_legacy_View_4052 : packoffset(c253.y);
  float dx_alignment_legacy_View_4056 : packoffset(c253.z);
  float dx_alignment_legacy_View_4060 : packoffset(c253.w);
  float4 dx_alignment_legacy_View_4064 : packoffset(c254.x);
  int dx_alignment_legacy_View_4080 : packoffset(c255.x);
  int dx_alignment_legacy_View_4084 : packoffset(c255.y);
  int dx_alignment_legacy_View_4088 : packoffset(c255.z);
  float dx_alignment_legacy_View_4092 : packoffset(c255.w);
  float4 dx_alignment_legacy_View_4096 : packoffset(c256.x);
  float4 dx_alignment_legacy_View_4112 : packoffset(c257.x);
  float4 dx_alignment_legacy_View_4128 : packoffset(c258.x);
  float4 dx_alignment_legacy_View_4144 : packoffset(c259.x);
  float dx_alignment_legacy_View_4160 : packoffset(c260.x);
  float dx_alignment_legacy_View_4164 : packoffset(c260.y);
  float dx_alignment_legacy_View_4168 : packoffset(c260.z);
  float dx_alignment_legacy_View_4172 : packoffset(c260.w);
  float4 dx_alignment_legacy_View_4176 : packoffset(c261.x);
  float4 dx_alignment_legacy_View_4192 : packoffset(c262.x);
  float4 dx_alignment_legacy_View_4208 : packoffset(c263.x);
  float4 dx_alignment_legacy_View_4224 : packoffset(c264.x);
  float4 dx_alignment_legacy_View_4240 : packoffset(c265.x);
  float dx_alignment_legacy_View_4256 : packoffset(c266.x);
  float dx_alignment_legacy_View_4260 : packoffset(c266.y);
  float dx_alignment_legacy_View_4264 : packoffset(c266.z);
  float dx_alignment_legacy_View_4268 : packoffset(c266.w);
  float4 dx_alignment_legacy_View_4272 : packoffset(c267.x);
  float4 dx_alignment_legacy_View_4288 : packoffset(c268.x);
  float dx_alignment_legacy_View_4304 : packoffset(c269.x);
  float dx_alignment_legacy_View_4308 : packoffset(c269.y);
  float dx_alignment_legacy_View_4312 : packoffset(c269.z);
  float dx_alignment_legacy_View_4316 : packoffset(c269.w);
  float4 dx_alignment_legacy_View_4320 : packoffset(c270.x);
  float4 dx_alignment_legacy_View_4336 : packoffset(c271.x);
  float dx_alignment_legacy_View_4352 : packoffset(c272.x);
  float dx_alignment_legacy_View_4356 : packoffset(c272.y);
  float dx_alignment_legacy_View_4360 : packoffset(c272.z);
  float dx_alignment_legacy_View_4364 : packoffset(c272.w);
  float dx_alignment_legacy_View_4368 : packoffset(c273.x);
  float dx_alignment_legacy_View_4372 : packoffset(c273.y);
  float dx_alignment_legacy_View_4376 : packoffset(c273.z);
  float dx_alignment_legacy_View_4380 : packoffset(c273.w);
  float dx_alignment_legacy_View_4384 : packoffset(c274.x);
  float dx_alignment_legacy_View_4388 : packoffset(c274.y);
  float dx_alignment_legacy_View_4392 : packoffset(c274.z);
  float dx_alignment_legacy_View_4396 : packoffset(c274.w);
  float dx_alignment_legacy_View_4400 : packoffset(c275.x);
  float dx_alignment_legacy_View_4404 : packoffset(c275.y);
  float dx_alignment_legacy_View_4408 : packoffset(c275.z);
  float dx_alignment_legacy_View_4412 : packoffset(c275.w);
  float dx_alignment_legacy_View_4416 : packoffset(c276.x);
  float dx_alignment_legacy_View_4420 : packoffset(c276.y);
  float dx_alignment_legacy_View_4424 : packoffset(c276.z);
  float dx_alignment_legacy_View_4428 : packoffset(c276.w);
  float dx_alignment_legacy_View_4432 : packoffset(c277.x);
  float dx_alignment_legacy_View_4436 : packoffset(c277.y);
  float dx_alignment_legacy_View_4440 : packoffset(c277.z);
  float dx_alignment_legacy_View_4444 : packoffset(c277.w);
  float dx_alignment_legacy_View_4448 : packoffset(c278.x);
  float dx_alignment_legacy_View_4452 : packoffset(c278.y);
  float dx_alignment_legacy_View_4456 : packoffset(c278.z);
  float dx_alignment_legacy_View_4460 : packoffset(c278.w);
  float dx_alignment_legacy_View_4464 : packoffset(c279.x);
  float dx_alignment_legacy_View_4468 : packoffset(c279.y);
  float dx_alignment_legacy_View_4472 : packoffset(c279.z);
  float dx_alignment_legacy_View_4476 : packoffset(c279.w);
  float dx_alignment_legacy_View_4480 : packoffset(c280.x);
  float dx_alignment_legacy_View_4484 : packoffset(c280.y);
  float dx_alignment_legacy_View_4488 : packoffset(c280.z);
  float dx_alignment_legacy_View_4492 : packoffset(c280.w);
  float dx_alignment_legacy_View_4496 : packoffset(c281.x);
  float dx_alignment_legacy_View_4500 : packoffset(c281.y);
  float dx_alignment_legacy_View_4504 : packoffset(c281.z);
  float dx_alignment_legacy_View_4508 : packoffset(c281.w);
  float dx_alignment_legacy_View_4512 : packoffset(c282.x);
  float dx_alignment_legacy_View_4516 : packoffset(c282.y);
  float dx_alignment_legacy_View_4520 : packoffset(c282.z);
  float dx_alignment_legacy_View_4524 : packoffset(c282.w);
  float dx_alignment_legacy_View_4528 : packoffset(c283.x);
  float dx_alignment_legacy_View_4532 : packoffset(c283.y);
  float dx_alignment_legacy_View_4536 : packoffset(c283.z);
  float dx_alignment_legacy_View_4540 : packoffset(c283.w);
  float dx_alignment_legacy_View_4544 : packoffset(c284.x);
  float dx_alignment_legacy_View_4548 : packoffset(c284.y);
  float dx_alignment_legacy_View_4552 : packoffset(c284.z);
  float dx_alignment_legacy_View_4556 : packoffset(c284.w);
  float dx_alignment_legacy_View_4560 : packoffset(c285.x);
  float dx_alignment_legacy_View_4564 : packoffset(c285.y);
  float dx_alignment_legacy_View_4568 : packoffset(c285.z);
  float dx_alignment_legacy_View_4572 : packoffset(c285.w);
  float dx_alignment_legacy_View_4576 : packoffset(c286.x);
  float dx_alignment_legacy_View_4580 : packoffset(c286.y);
  float dx_alignment_legacy_View_4584 : packoffset(c286.z);
  float dx_alignment_legacy_View_4588 : packoffset(c286.w);
  float dx_alignment_legacy_View_4592 : packoffset(c287.x);
  float dx_alignment_legacy_View_4596 : packoffset(c287.y);
  float dx_alignment_legacy_View_4600 : packoffset(c287.z);
  float dx_alignment_legacy_View_4604 : packoffset(c287.w);
  float dx_alignment_legacy_View_4608 : packoffset(c288.x);
  float dx_alignment_legacy_View_4612 : packoffset(c288.y);
  float dx_alignment_legacy_View_4616 : packoffset(c288.z);
  float dx_alignment_legacy_View_4620 : packoffset(c288.w);
  float dx_alignment_legacy_View_4624 : packoffset(c289.x);
  float dx_alignment_legacy_View_4628 : packoffset(c289.y);
  float dx_alignment_legacy_View_4632 : packoffset(c289.z);
  float dx_alignment_legacy_View_4636 : packoffset(c289.w);
  float dx_alignment_legacy_View_4640 : packoffset(c290.x);
  float dx_alignment_legacy_View_4644 : packoffset(c290.y);
  float dx_alignment_legacy_View_4648 : packoffset(c290.z);
  float dx_alignment_legacy_View_4652 : packoffset(c290.w);
  float dx_alignment_legacy_View_4656 : packoffset(c291.x);
  float dx_alignment_legacy_View_4660 : packoffset(c291.y);
  float dx_alignment_legacy_View_4664 : packoffset(c291.z);
  float dx_alignment_legacy_View_4668 : packoffset(c291.w);
  float dx_alignment_legacy_View_4672 : packoffset(c292.x);
  float dx_alignment_legacy_View_4676 : packoffset(c292.y);
  float dx_alignment_legacy_View_4680 : packoffset(c292.z);
  float dx_alignment_legacy_View_4684 : packoffset(c292.w);
  float dx_alignment_legacy_View_4688 : packoffset(c293.x);
  float dx_alignment_legacy_View_4692 : packoffset(c293.y);
  float dx_alignment_legacy_View_4696 : packoffset(c293.z);
  float dx_alignment_legacy_View_4700 : packoffset(c293.w);
  float dx_alignment_legacy_View_4704 : packoffset(c294.x);
  float dx_alignment_legacy_View_4708 : packoffset(c294.y);
  float dx_alignment_legacy_View_4712 : packoffset(c294.z);
  float dx_alignment_legacy_View_4716 : packoffset(c294.w);
  float dx_alignment_legacy_View_4720 : packoffset(c295.x);
  float dx_alignment_legacy_View_4724 : packoffset(c295.y);
  float dx_alignment_legacy_View_4728 : packoffset(c295.z);
  float dx_alignment_legacy_View_4732 : packoffset(c295.w);
  float dx_alignment_legacy_View_4736 : packoffset(c296.x);
  float dx_alignment_legacy_View_4740 : packoffset(c296.y);
  float dx_alignment_legacy_View_4744 : packoffset(c296.z);
  float dx_alignment_legacy_View_4748 : packoffset(c296.w);
  float dx_alignment_legacy_View_4752 : packoffset(c297.x);
  float dx_alignment_legacy_View_4756 : packoffset(c297.y);
  float dx_alignment_legacy_View_4760 : packoffset(c297.z);
  float dx_alignment_legacy_View_4764 : packoffset(c297.w);
  float dx_alignment_legacy_View_4768 : packoffset(c298.x);
  float dx_alignment_legacy_View_4772 : packoffset(c298.y);
  float dx_alignment_legacy_View_4776 : packoffset(c298.z);
  float dx_alignment_legacy_View_4780 : packoffset(c298.w);
  float dx_alignment_legacy_View_4784 : packoffset(c299.x);
  float dx_alignment_legacy_View_4788 : packoffset(c299.y);
  float dx_alignment_legacy_View_4792 : packoffset(c299.z);
  float dx_alignment_legacy_View_4796 : packoffset(c299.w);
  float dx_alignment_legacy_View_4800 : packoffset(c300.x);
  float dx_alignment_legacy_View_4804 : packoffset(c300.y);
  float dx_alignment_legacy_View_4808 : packoffset(c300.z);
  float dx_alignment_legacy_View_4812 : packoffset(c300.w);
  float dx_alignment_legacy_View_4816 : packoffset(c301.x);
  float dx_alignment_legacy_View_4820 : packoffset(c301.y);
  float dx_alignment_legacy_View_4824 : packoffset(c301.z);
  float dx_alignment_legacy_View_4828 : packoffset(c301.w);
  float dx_alignment_legacy_View_4832 : packoffset(c302.x);
  float dx_alignment_legacy_View_4836 : packoffset(c302.y);
  float dx_alignment_legacy_View_4840 : packoffset(c302.z);
  float dx_alignment_legacy_View_4844 : packoffset(c302.w);
  float dx_alignment_legacy_View_4848 : packoffset(c303.x);
  float dx_alignment_legacy_View_4852 : packoffset(c303.y);
  float dx_alignment_legacy_View_4856 : packoffset(c303.z);
  float dx_alignment_legacy_View_4860 : packoffset(c303.w);
  float dx_alignment_legacy_View_4864 : packoffset(c304.x);
  float dx_alignment_legacy_View_4868 : packoffset(c304.y);
  float dx_alignment_legacy_View_4872 : packoffset(c304.z);
  float dx_alignment_legacy_View_4876 : packoffset(c304.w);
  float dx_alignment_legacy_View_4880 : packoffset(c305.x);
  float dx_alignment_legacy_View_4884 : packoffset(c305.y);
  float dx_alignment_legacy_View_4888 : packoffset(c305.z);
  float dx_alignment_legacy_View_4892 : packoffset(c305.w);
  float dx_alignment_legacy_View_4896 : packoffset(c306.x);
  float dx_alignment_legacy_View_4900 : packoffset(c306.y);
  float dx_alignment_legacy_View_4904 : packoffset(c306.z);
  float dx_alignment_legacy_View_4908 : packoffset(c306.w);
  float dx_alignment_legacy_View_4912 : packoffset(c307.x);
  float dx_alignment_legacy_View_4916 : packoffset(c307.y);
  float dx_alignment_legacy_View_4920 : packoffset(c307.z);
  float dx_alignment_legacy_View_4924 : packoffset(c307.w);
  float dx_alignment_legacy_View_4928 : packoffset(c308.x);
  float dx_alignment_legacy_View_4932 : packoffset(c308.y);
  float dx_alignment_legacy_View_4936 : packoffset(c308.z);
  float dx_alignment_legacy_View_4940 : packoffset(c308.w);
  float dx_alignment_legacy_View_4944 : packoffset(c309.x);
  float dx_alignment_legacy_View_4948 : packoffset(c309.y);
  float dx_alignment_legacy_View_4952 : packoffset(c309.z);
  float dx_alignment_legacy_View_4956 : packoffset(c309.w);
  float dx_alignment_legacy_View_4960 : packoffset(c310.x);
  float dx_alignment_legacy_View_4964 : packoffset(c310.y);
  float dx_alignment_legacy_View_4968 : packoffset(c310.z);
  float dx_alignment_legacy_View_4972 : packoffset(c310.w);
  float dx_alignment_legacy_View_4976 : packoffset(c311.x);
  float dx_alignment_legacy_View_4980 : packoffset(c311.y);
  float dx_alignment_legacy_View_4984 : packoffset(c311.z);
  float dx_alignment_legacy_View_4988 : packoffset(c311.w);
  float dx_alignment_legacy_View_4992 : packoffset(c312.x);
  float dx_alignment_legacy_View_4996 : packoffset(c312.y);
  float dx_alignment_legacy_View_5000 : packoffset(c312.z);
  float dx_alignment_legacy_View_5004 : packoffset(c312.w);
  float dx_alignment_legacy_View_5008 : packoffset(c313.x);
  float dx_alignment_legacy_View_5012 : packoffset(c313.y);
  float dx_alignment_legacy_View_5016 : packoffset(c313.z);
  float dx_alignment_legacy_View_5020 : packoffset(c313.w);
  float4 dx_alignment_legacy_View_5024 : packoffset(c314.x);
  float dx_alignment_legacy_View_5040 : packoffset(c315.x);
  float dx_alignment_legacy_View_5044 : packoffset(c315.y);
  float dx_alignment_legacy_View_5048 : packoffset(c315.z);
  float dx_alignment_legacy_View_5052 : packoffset(c315.w);
  float4 dx_alignment_legacy_View_5056 : packoffset(c316.x);
  float dx_alignment_legacy_View_5072 : packoffset(c317.x);
  float dx_alignment_legacy_View_5076 : packoffset(c317.y);
  float dx_alignment_legacy_View_5080 : packoffset(c317.z);
  float dx_alignment_legacy_View_5084 : packoffset(c317.w);
  float dx_alignment_legacy_View_5088 : packoffset(c318.x);
  float dx_alignment_legacy_View_5092 : packoffset(c318.y);
  float dx_alignment_legacy_View_5096 : packoffset(c318.z);
  float dx_alignment_legacy_View_5100 : packoffset(c318.w);
  float dx_alignment_legacy_View_5104 : packoffset(c319.x);
  float dx_alignment_legacy_View_5108 : packoffset(c319.y);
  float dx_alignment_legacy_View_5112 : packoffset(c319.z);
  float dx_alignment_legacy_View_5116 : packoffset(c319.w);
  float2 dx_alignment_legacy_View_5120 : packoffset(c320.x);
  float dx_alignment_legacy_View_5128 : packoffset(c320.z);
  float dx_alignment_legacy_View_5132 : packoffset(c320.w);
  float3 dx_alignment_legacy_View_5136 : packoffset(c321.x);
  float dx_alignment_legacy_View_5148 : packoffset(c321.w);
  float dx_alignment_legacy_View_5152 : packoffset(c322.x);
  float dx_alignment_legacy_View_5156 : packoffset(c322.y);
  float dx_alignment_legacy_View_5160 : packoffset(c322.z);
  float dx_alignment_legacy_View_5164 : packoffset(c322.w);
  float4 dx_alignment_legacy_View_5168 : packoffset(c323.x);
  float3 dx_alignment_legacy_View_5184 : packoffset(c324.x);
  float dx_alignment_legacy_View_5196 : packoffset(c324.w);
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
  float _23 = cb0_064z * cb0_064y;
  float _24 = TEXCOORD_3.x * 0.5f;
  float _25 = TEXCOORD_3.y * 0.5f;
  float _96;
  float _97;
  float _105;
  float _106;
  float _204;
  float _205;
  float _206;
  float _228;
  float _235;
  float _242;
  float _249;
  float _284;
  float _285;
  float _286;
  float _321;
  float _322;
  float _323;
  float _351;
  float _352;
  float _374;
  float _405;
  float _406;
  float _482;
  float _483;
  float _484;
  float _512;
  float _513;
  float _514;
  float _667;
  float _668;
  float _669;
  float _701;
  float _702;
  float _703;
  float _750;
  float _751;
  float _752;
  float _865;
  float _866;
  float _867;
  if (!(!(cb0_084x != 0.0f))) {
    float _30 = cb0_084x * 2.0f;
    if (_30 > 0.0f) {
      float _34 = abs(_30) * 0.5f;
      float _35 = tan(_34);
      float _36 = _23 * TEXCOORD_3.x;
      float _46 = rsqrt(dot(float2(_36, TEXCOORD_3.y), float2(_36, TEXCOORD_3.y)));
      float _50 = rsqrt(dot(float2(_23, 1.0f), float2(_23, 1.0f)));
      float _55 = tan((sqrt((_36 * _36) + (TEXCOORD_3.y * TEXCOORD_3.y)) / sqrt((_23 * _23) + 1.0f)) * _34);
      _96 = (((_55 * ((_46 * _36) / (_50 * _23))) / _35) * 0.5f);
      _97 = (((_55 * ((_46 * TEXCOORD_3.y) / _50)) / _35) * 0.5f);
    } else {
      if (_30 < 0.0f) {
        float _69 = sqrt(((TEXCOORD_3.y * TEXCOORD_3.y) + (TEXCOORD_3.x * TEXCOORD_3.x)) * 0.25f);
        float _74 = (((_69 * _69) * (cb0_084x * 0.699999988079071f)) + 1.0f) * _69;
        float _76 = atan(_24 / _25);
        bool _79 = (_25 < 0.0f);
        bool _80 = (_25 == 0.0f);
        bool _81 = (_24 >= 0.0f);
        bool _82 = (_24 < 0.0f);
        float _90 = select((_81 && _80), 1.5707963705062866f, select((_82 && _80), -1.5707963705062866f, select((_82 && _79), (_76 + -3.1415927410125732f), select((_81 && _79), (_76 + 3.1415927410125732f), _76))));
        _96 = (sin(_90) * _74);
        _97 = (cos(_90) * _74);
      } else {
        _96 = _24;
        _97 = _25;
      }
    }
    _105 = (((_96 + 0.5f) * 2.0f) + -1.0f);
    _106 = (((_97 + 0.5f) * 2.0f) + -1.0f);
  } else {
    _105 = TEXCOORD_3.x;
    _106 = TEXCOORD_3.y;
  }
  float _119 = ((cb0_048x * _105) + cb0_048z) * cb0_047z;
  float _120 = ((cb0_048y * _106) + cb0_048w) * cb0_047w;
  float4 _121 = t3.SampleLevel(s3, float2(_119, _120), 0.0f);
  // float _133 = ((dx.alignment.legacy.View_1040.x * _121.x) + dx.alignment.legacy.View_1040.y) + (1.0f / ((dx.alignment.legacy.View_1040.z * _121.x) - dx.alignment.legacy.View_1040.w));
  float _133 = ((dx_alignment_legacy_View_1040.x * _121.x) + dx_alignment_legacy_View_1040.y) + (1.0f / ((dx_alignment_legacy_View_1040.z * _121.x) - dx_alignment_legacy_View_1040.w));
  float4 _134 = t2.Sample(s2, float2(_119, _120));
  // float _142 = 1.0f / ((dx.alignment.legacy.View_1040.w + _133) * dx.alignment.legacy.View_1040.z);
  float _142 = 1.0f / ((dx_alignment_legacy_View_1040.w + _133) * dx_alignment_legacy_View_1040.z);
  if (((bool)(!(cb0_079y == 0.0f))) || ((bool)(((bool)(((bool)(((bool)(((bool)(!(cb0_080y == 0.0f))) || ((bool)(!(cb0_084y == 0.0f))))) || ((bool)(!(cb0_085y == 0.0f))))) || ((bool)(!(cb0_086y == 0.0f))))) || ((bool)(!(cb0_087y == 0.0f)))))) {
    float _187 = 1.5f - (saturate(cb0_080z) * 1.4900000095367432f);
    float _192 = saturate(((sqrt((_106 * _106) + (_105 * _105)) - cb0_080y) - _187) / (-0.0f - _187));
    float _196 = (_192 * _192) * (3.0f - (_192 * 2.0f));
    _204 = (1.0f - (_196 * max(cb0_079y, cb0_084y)));
    _205 = (1.0f - (_196 * max(cb0_079y, cb0_085y)));
    _206 = (1.0f - (_196 * max(cb0_079y, cb0_086y)));
  } else {
    _204 = 1.0f;
    _205 = 1.0f;
    _206 = 1.0f;
  }
  bool _212 = !(cb0_079z == 0.0f);
  bool _213 = !(cb0_084z == 0.0f);
  bool _215 = !(cb0_085z == 0.0f);
  bool _217 = !(cb0_086z == 0.0f);
  if (((bool)(((bool)(((bool)(_212 || _213)) || _215)) || _217)) || ((bool)(!(cb0_087z == 0.0f)))) {
    if (_212) {
      _228 = exp2(log2(saturate(cb0_079z)) * 3.0f);
    } else {
      _228 = cb0_079z;
    }
    if (_213) {
      _235 = exp2(log2(saturate(cb0_084z)) * 3.0f);
    } else {
      _235 = cb0_084z;
    }
    if (_215) {
      _242 = exp2(log2(saturate(cb0_085z)) * 3.0f);
    } else {
      _242 = cb0_085z;
    }
    if (_217) {
      _249 = exp2(log2(saturate(cb0_086z)) * 3.0f);
    } else {
      _249 = cb0_086z;
    }
    float _250 = max(_228, _235);
    float _251 = max(_228, _242);
    float _252 = max(_228, _249);
    float _268 = saturate((_133 - (_250 * 1000.0f)) / ((_250 * 9999.990234375f) + 0.009999999776482582f));
    float _269 = saturate((_133 - (_251 * 1000.0f)) / ((_251 * 9999.990234375f) + 0.009999999776482582f));
    float _270 = saturate((_133 - (_252 * 1000.0f)) / ((_252 * 9999.990234375f) + 0.009999999776482582f));
    _284 = ((_268 * _268) * (3.0f - (_268 * 2.0f)));
    _285 = ((_269 * _269) * (3.0f - (_269 * 2.0f)));
    _286 = ((_270 * _270) * (3.0f - (_270 * 2.0f)));
  } else {
    _284 = 1.0f;
    _285 = 1.0f;
    _286 = 1.0f;
  }
  if (((bool)(((bool)(((bool)(((bool)(!(cb0_080x == 0.0f))) || ((bool)(!(cb0_085x == 0.0f))))) || ((bool)(!(cb0_086x == 0.0f))))) || ((bool)(!(cb0_087x == 0.0f))))) || ((bool)(!(cb0_088x == 0.0f)))) {
    // float _307 = saturate(select((((_142 - _134.x) + ((((dx.alignment.legacy.View_448[3].z) - _142) + ((dx.alignment.legacy.View_448[2].z) * _133)) * select(((dx.alignment.legacy.View_448[3].w) < 1.0f), 0.0f, 1.0f))) > 0.0005000000237487257f), 1.0f, 0.0f) + select((_134.x > 0.0005000000237487257f), 0.0f, 1.0f));
    float _307 = saturate(select((((_142 - _134.x) + ((((dx_alignment_legacy_View_448[3].z) - _142) + ((dx_alignment_legacy_View_448[2].z) * _133)) * select(((dx_alignment_legacy_View_448[3].w) < 1.0f), 0.0f, 1.0f))) > 0.0005000000237487257f), 1.0f, 0.0f) + select((_134.x > 0.0005000000237487257f), 0.0f, 1.0f));
    _321 = max(_307, (1.0f - saturate(max(cb0_080x, cb0_085x))));
    _322 = max(_307, (1.0f - saturate(max(cb0_080x, cb0_086x))));
    _323 = max(_307, (1.0f - saturate(max(cb0_080x, cb0_087x))));
  } else {
    _321 = 1.0f;
    _322 = 1.0f;
    _323 = 1.0f;
  }
  float _324 = TEXCOORD_2.w * 543.3099975585938f;
  float _328 = frac(sin(_324 + TEXCOORD_2.z) * 493013.0f);
  if (cb0_079x > 0.0f) {
    _351 = ((cb0_079x * (frac((sin((TEXCOORD_2.z + 33.9900016784668f) + _324) * 493013.0f) + 7.177000045776367f) - _328)) + _328);
    _352 = ((cb0_079x * (frac((sin((TEXCOORD_2.z + 66.98999786376953f) + _324) * 493013.0f) + 14.298999786376953f) - _328)) + _328);
  } else {
    _351 = _328;
    _352 = _328;
  }
  if (cb0_082z > 0.0f) {
    // _374 = (((((_286 * _206) * _323) * cb0_082z) * ((sin((((TEXCOORD_3.y * 10.0f) + 10.0f) + (_328 * 0.0020000000949949026f)) + (dx.alignment.legacy.View_2376 * 4.0f)) * 0.5f) + 0.5f)) + 1.0f);
    _374 = (((((_286 * _206) * _323) * cb0_082z) * ((sin((((TEXCOORD_3.y * 10.0f) + 10.0f) + (_328 * 0.0020000000949949026f)) + (dx_alignment_legacy_View_2376 * 4.0f)) * 0.5f) + 0.5f)) + 1.0f);
  } else {
    _374 = 1.0f;
  }
  float _377 = (_285 * _205) * _322;
  float _378 = _377 * cb0_082y;
  if (cb0_082y > 0.0f) {
    // float _383 = dx.alignment.legacy.View_2376 * 0.00016666666488163173f;
    float _383 = dx_alignment_legacy_View_2376 * 0.00016666666488163173f;
    float _387 = frac(abs(_383));
    float _392 = ((TEXCOORD_3.y * 111000.0f) + 111000.0f) * select((_383 >= (-0.0f - _383)), _387, (-0.0f - _387));
    float _398 = (0.5f - frac(sin(dot(float2(_392, _392), float2(12.989800453186035f, 78.23300170898438f))) * 43758.546875f)) * 0.014999999664723873f;
    _405 = (((_378 * 0.5f) * _398) + _119);
    _406 = ((_398 * _378) + _120);
  } else {
    _405 = _119;
    _406 = _120;
  }
  float4 _407 = t0.Sample(s0, float2(_405, _406));
  float _413 = saturate(cb0_081x);
  float _415 = saturate(cb0_081y);
  if (_413 > 0.0f) {
    float _426 = saturate(((_407.x * 0.29899999499320984f) + (_407.y * 0.5870000123977661f)) + (_407.z * 0.11400000005960464f));
    float _432 = ((_426 * _426) * (saturate(1.0f - cb0_081z) * 2.0f)) * (3.0f - (_426 * 2.0f));
    float _439 = max(sqrt(((_407.x * _407.x) + (_407.y * _407.y)) + (_407.z * _407.z)), 0.014999999664723873f);
    float _440 = _407.x / _439;
    float _441 = _407.y / _439;
    float _442 = _407.z / _439;
    float _452 = log2(_432);
    float _471 = ((_284 * _204) * _321) * _413;
    _482 = (((((lerp(_440, 1.0f, 0.25f)) * (((_415 * 0.17000000178813934f) + 0.029999999329447746f) + _432)) - _407.x) * _471) + _407.x);
    _483 = (((((((_415 * 0.18000000715255737f) + 0.05000000074505806f) + exp2(_452 * 0.8999999761581421f)) * (lerp(_441, 1.0f, 0.25f))) - _407.y) * _471) + _407.y);
    _484 = (((((((_415 * 0.17999999225139618f) + 0.07999999821186066f) + exp2(_452 * 0.949999988079071f)) * (lerp(_442, 1.0f, 0.25f))) - _407.z) * _471) + _407.z);
  } else {
    _482 = _407.x;
    _483 = _407.y;
    _484 = _407.z;
  }
  float _486 = saturate(cb0_082x);
  float _487 = _377 * _486;
  if (_486 > 0.0f) {
    // float _498 = (sin(((_106 * 640.0f) + 640.0f) - (dx.alignment.legacy.View_2376 * 10.0f)) * 0.5f) + 1.0f;
    float _498 = (sin(((_106 * 640.0f) + 640.0f) - (dx_alignment_legacy_View_2376 * 10.0f)) * 0.5f) + 1.0f;
    _512 = ((((_498 * _482) - _482) * _487) + _482);
    _513 = ((((_498 * _483) - _483) * _487) + _483);
    _514 = ((((_498 * _484) - _484) * _487) + _484);
  } else {
    _512 = _482;
    _513 = _483;
    _514 = _484;
  }

  float4 _537 = t1.Sample(s1, float2(min(max(((cb0_068x * _405) + cb0_068z), cb0_060x), cb0_060z), min(max(((cb0_068y * _406) + cb0_068w), cb0_060y), cb0_060w)));
  _537.rgb *= RENODX_WUWA_BLOOM;

  float _564 = TEXCOORD_1.z + -1.0f;
  float _566 = TEXCOORD_1.w + -1.0f;
  float _569 = ((_564 + (cb0_073x * 2.0f)) * cb0_071z) * cb0_071x;
  float _571 = ((_566 + (cb0_073y * 2.0f)) * cb0_071w) * cb0_071x;
  float _578 = 1.0f / ((((saturate(cb0_072w) * 9.0f) + 1.0f) * dot(float2(_569, _571), float2(_569, _571))) + 1.0f);
  float _579 = _578 * _578;
  float _606 = ((_564 + (cb0_076x * 2.0f)) * cb0_074z) * cb0_074x;
  float _608 = ((_566 + (cb0_076y * 2.0f)) * cb0_074w) * cb0_074x;
  float _615 = 1.0f / ((((saturate(cb0_075w) * 9.0f) + 1.0f) * dot(float2(_606, _608), float2(_606, _608))) + 1.0f);
  float _616 = _615 * _615;
  float _630 = ((_537.x + ((_512 * TEXCOORD_1.x) * cb0_069x)) * _374) * min(((_579 * (1.0f - cb0_072x)) + cb0_072x), ((_616 * (1.0f - cb0_075x)) + cb0_075x));
  float _632 = ((_537.y + ((_513 * TEXCOORD_1.x) * cb0_069y)) * _374) * min(((_579 * (1.0f - cb0_072y)) + cb0_072y), ((_616 * (1.0f - cb0_075y)) + cb0_075y));
  float _634 = ((_537.z + ((_514 * TEXCOORD_1.x) * cb0_069z)) * _374) * min(((_579 * (1.0f - cb0_072z)) + cb0_072z), ((_616 * (1.0f - cb0_075z)) + cb0_075z));

  CAPTURE_UNTONEMAPPED(float3(_630, _632, _634));

  [branch]
  // if (!((uint)(cb0_089y) == 0)) {
  if (((uint)(RENODX_WUWA_TM) == 1)) {
    // _667 = saturate((((_630 * 1.3600000143051147f) + 0.04699999839067459f) * _630) / ((((_630 * 0.9599999785423279f) + 0.5600000023841858f) * _630) + 0.14000000059604645f));
    // _668 = saturate((((_632 * 1.3600000143051147f) + 0.04699999839067459f) * _632) / ((((_632 * 0.9599999785423279f) + 0.5600000023841858f) * _632) + 0.14000000059604645f));
    // _669 = saturate((((_634 * 1.3600000143051147f) + 0.04699999839067459f) * _634) / ((((_634 * 0.9599999785423279f) + 0.5600000023841858f) * _634) + 0.14000000059604645f));
    _667 = ((((_630 * 1.3600000143051147f) + 0.04699999839067459f) * _630) / ((((_630 * 0.9599999785423279f) + 0.5600000023841858f) * _630) + 0.14000000059604645f));
    _668 = ((((_632 * 1.3600000143051147f) + 0.04699999839067459f) * _632) / ((((_632 * 0.9599999785423279f) + 0.5600000023841858f) * _632) + 0.14000000059604645f));
    _669 = ((((_634 * 1.3600000143051147f) + 0.04699999839067459f) * _634) / ((((_634 * 0.9599999785423279f) + 0.5600000023841858f) * _634) + 0.14000000059604645f));
  } else {
    _667 = _630;
    _668 = _632;
    _669 = _634;
  }
  [branch]
  // if (!((uint)(cb0_089z) == 0)) {
  if (((uint)(RENODX_WUWA_TM) == 2)) {
    float _679 = 1.0049500465393066f - (0.16398000717163086f / (_667 + -0.19505000114440918f));
    float _680 = 1.0049500465393066f - (0.16398000717163086f / (_668 + -0.19505000114440918f));
    float _681 = 1.0049500465393066f - (0.16398000717163086f / (_669 + -0.19505000114440918f));
    // _701 = saturate(((_667 - _679) * select((_667 > 0.6000000238418579f), 0.0f, 1.0f)) + _679);
    // _702 = saturate(((_668 - _680) * select((_668 > 0.6000000238418579f), 0.0f, 1.0f)) + _680);
    // _703 = saturate(((_669 - _681) * select((_669 > 0.6000000238418579f), 0.0f, 1.0f)) + _681);
    _701 = (((_667 - _679) * select((_667 > 0.6000000238418579f), 0.0f, 1.0f)) + _679);
    _702 = (((_668 - _680) * select((_668 > 0.6000000238418579f), 0.0f, 1.0f)) + _680);
    _703 = (((_669 - _681) * select((_669 > 0.6000000238418579f), 0.0f, 1.0f)) + _681);
  } else {
    _701 = _667;
    _702 = _668;
    _703 = _669;
  }
  [branch]
  // if (!((uint)(cb0_089w) == 0)) {
  if (((uint)(RENODX_WUWA_TM) == 3)) {
    float _709 = cb0_037y * _701;
    float _710 = cb0_037y * _702;
    float _711 = cb0_037y * _703;
    float _714 = cb0_037z * cb0_037w;
    float _724 = cb0_038y * cb0_038x;
    float _735 = cb0_038z * cb0_038x;
    float _742 = cb0_038y / cb0_038z;
    // _750 = saturate(((((_714 + _709) * _701) + _724) / (_735 + ((_709 + cb0_037z) * _701))) - _742);
    // _751 = saturate(((((_714 + _710) * _702) + _724) / (_735 + ((_710 + cb0_037z) * _702))) - _742);
    // _752 = saturate(((((_714 + _711) * _703) + _724) / (_735 + ((_711 + cb0_037z) * _703))) - _742);
    _750 = (((((_714 + _709) * _701) + _724) / (_735 + ((_709 + cb0_037z) * _701))) - _742);
    _751 = (((((_714 + _710) * _702) + _724) / (_735 + ((_710 + cb0_037z) * _702))) - _742);
    _752 = (((((_714 + _711) * _703) + _724) / (_735 + ((_711 + cb0_037z) * _703))) - _742);
  } else {
    _750 = _701;
    _751 = _702;
    _752 = _703;
  }

  CLAMP_IF_SDR(_750); CLAMP_IF_SDR(_751); CLAMP_IF_SDR(_752);
  CAPTURE_TONEMAPPED(float3(_750, _751, _752));

  float4 _774 = t4.Sample(s4, float3(((saturate((log2(_750 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_751 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_752 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f)));
  _774.rgb = HandleLUTOutput(_774.rgb, untonemapped, tonemapped);

  float _778 = _774.x * 1.0499999523162842f;
  float _779 = _774.y * 1.0499999523162842f;
  float _780 = _774.z * 1.0499999523162842f;

  // float _788 = ((_328 * 0.00390625f) + -0.001953125f) + _778;
  // float _789 = ((_351 * 0.00390625f) + -0.001953125f) + _779;
  // float _790 = ((_352 * 0.00390625f) + -0.001953125f) + _780;
  float _788 = RENODX_WUWA_GRAIN * ((_328 * 0.00390625f) + -0.001953125f) + _778;
  float _789 = RENODX_WUWA_GRAIN * ((_351 * 0.00390625f) + -0.001953125f) + _779;
  float _790 = RENODX_WUWA_GRAIN * ((_352 * 0.00390625f) + -0.001953125f) + _780;

  [branch]
  if (!((uint)(cb0_089x) == 0)) {
    float _802 = (pow(_788, 0.012683313339948654f));
    float _803 = (pow(_789, 0.012683313339948654f));
    float _804 = (pow(_790, 0.012683313339948654f));
    float _837 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_802 + -0.8359375f)) / (18.8515625f - (_802 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_088w));
    float _838 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_803 + -0.8359375f)) / (18.8515625f - (_803 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_088w));
    float _839 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_804 + -0.8359375f)) / (18.8515625f - (_804 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_088w));
    _865 = min((_837 * 12.920000076293945f), ((exp2(log2(max(_837, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _866 = min((_838 * 12.920000076293945f), ((exp2(log2(max(_838, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _867 = min((_839 * 12.920000076293945f), ((exp2(log2(max(_839, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _865 = _788;
    _866 = _789;
    _867 = _790;
  }
  SV_Target.x = _865;
  SV_Target.y = _866;
  SV_Target.z = _867;

  // SV_Target.w = saturate(dot(float3(_778, _779, _780), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  SV_Target.w = (dot(float3(_778, _779, _780), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);

  return SV_Target;
}
