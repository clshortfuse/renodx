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
  float cb0_053x : packoffset(c053.x);
  float cb0_053y : packoffset(c053.y);
  float cb0_053z : packoffset(c053.z);
  float cb0_053w : packoffset(c053.w);
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
  float cb0_078x : packoffset(c078.x);
  float cb0_078y : packoffset(c078.y);
  float cb0_078z : packoffset(c078.z);
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
  float cb0_095x : packoffset(c095.x);
  float cb0_095y : packoffset(c095.y);
  float cb0_095z : packoffset(c095.z);
  float cb0_095w : packoffset(c095.w);
  float cb0_096x : packoffset(c096.x);
  float cb0_096y : packoffset(c096.y);
  float cb0_096z : packoffset(c096.z);
  float cb0_096w : packoffset(c096.w);
  float cb0_098x : packoffset(c098.x);
  float cb0_098y : packoffset(c098.y);
  float cb0_098z : packoffset(c098.z);
  float cb0_099x : packoffset(c099.x);
  float cb0_099y : packoffset(c099.y);
  float cb0_099z : packoffset(c099.z);
  float cb0_099w : packoffset(c099.w);
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
  float _25 = cb0_064z * cb0_064y;
  float _26 = TEXCOORD_3.x * 0.5f;
  float _27 = TEXCOORD_3.y * 0.5f;
  float _98;
  float _99;
  float _107;
  float _108;
  float _206;
  float _207;
  float _208;
  float _230;
  float _237;
  float _244;
  float _251;
  float _286;
  float _287;
  float _288;
  float _323;
  float _324;
  float _325;
  float _353;
  float _354;
  float _376;
  float _407;
  float _408;
  float _496;
  float _497;
  float _588;
  float _589;
  float _661;
  float _662;
  float _663;
  float _692;
  float _693;
  float _694;
  float _859;
  float _860;
  float _861;
  float _893;
  float _894;
  float _895;
  float _942;
  float _943;
  float _944;
  float _1057;
  float _1058;
  float _1059;
  if (!(!(cb0_084x != 0.0f))) {
    float _32 = cb0_084x * 2.0f;
    if (_32 > 0.0f) {
      float _36 = abs(_32) * 0.5f;
      float _37 = tan(_36);
      float _38 = _25 * TEXCOORD_3.x;
      float _48 = rsqrt(dot(float2(_38, TEXCOORD_3.y), float2(_38, TEXCOORD_3.y)));
      float _52 = rsqrt(dot(float2(_25, 1.0f), float2(_25, 1.0f)));
      float _57 = tan((sqrt((_38 * _38) + (TEXCOORD_3.y * TEXCOORD_3.y)) / sqrt((_25 * _25) + 1.0f)) * _36);
      _98 = (((_57 * ((_48 * _38) / (_52 * _25))) / _37) * 0.5f);
      _99 = (((_57 * ((_48 * TEXCOORD_3.y) / _52)) / _37) * 0.5f);
    } else {
      if (_32 < 0.0f) {
        float _71 = sqrt(((TEXCOORD_3.y * TEXCOORD_3.y) + (TEXCOORD_3.x * TEXCOORD_3.x)) * 0.25f);
        float _76 = (((_71 * _71) * (cb0_084x * 0.699999988079071f)) + 1.0f) * _71;
        float _78 = atan(_26 / _27);
        bool _81 = (_27 < 0.0f);
        bool _82 = (_27 == 0.0f);
        bool _83 = (_26 >= 0.0f);
        bool _84 = (_26 < 0.0f);
        float _92 = select((_83 && _82), 1.5707963705062866f, select((_84 && _82), -1.5707963705062866f, select((_84 && _81), (_78 + -3.1415927410125732f), select((_83 && _81), (_78 + 3.1415927410125732f), _78))));
        _98 = (sin(_92) * _76);
        _99 = (cos(_92) * _76);
      } else {
        _98 = _26;
        _99 = _27;
      }
    }
    _107 = (((_98 + 0.5f) * 2.0f) + -1.0f);
    _108 = (((_99 + 0.5f) * 2.0f) + -1.0f);
  } else {
    _107 = TEXCOORD_3.x;
    _108 = TEXCOORD_3.y;
  }
  float _121 = ((cb0_048x * _107) + cb0_048z) * cb0_047z;
  float _122 = ((cb0_048y * _108) + cb0_048w) * cb0_047w;
  float4 _123 = t3.SampleLevel(s3, float2(_121, _122), 0.0f);
  float _135 = ((dx_alignment_legacy_View_1040.x * _123.x) + dx_alignment_legacy_View_1040.y) + (1.0f / ((dx_alignment_legacy_View_1040.z * _123.x) - dx_alignment_legacy_View_1040.w));
  float4 _136 = t2.Sample(s2, float2(_121, _122));
  float _144 = 1.0f / ((dx_alignment_legacy_View_1040.w + _135) * dx_alignment_legacy_View_1040.z);
  if (((bool)(!(cb0_079y == 0.0f))) || ((bool)(((bool)(((bool)(((bool)(((bool)(!(cb0_080y == 0.0f))) || ((bool)(!(cb0_084y == 0.0f))))) || ((bool)(!(cb0_085y == 0.0f))))) || ((bool)(!(cb0_086y == 0.0f))))) || ((bool)(!(cb0_087y == 0.0f)))))) {
    float _189 = 1.5f - (saturate(cb0_080z) * 1.4900000095367432f);
    float _194 = saturate(((sqrt((_108 * _108) + (_107 * _107)) - cb0_080y) - _189) / (-0.0f - _189));
    float _198 = (_194 * _194) * (3.0f - (_194 * 2.0f));
    _206 = (1.0f - (_198 * max(cb0_079y, cb0_084y)));
    _207 = (1.0f - (_198 * max(cb0_079y, cb0_085y)));
    _208 = (1.0f - (_198 * max(cb0_079y, cb0_086y)));
  } else {
    _206 = 1.0f;
    _207 = 1.0f;
    _208 = 1.0f;
  }
  bool _214 = !(cb0_079z == 0.0f);
  bool _215 = !(cb0_084z == 0.0f);
  bool _217 = !(cb0_085z == 0.0f);
  bool _219 = !(cb0_086z == 0.0f);
  if (((bool)(((bool)(((bool)(_214 || _215)) || _217)) || _219)) || ((bool)(!(cb0_087z == 0.0f)))) {
    if (_214) {
      _230 = exp2(log2(saturate(cb0_079z)) * 3.0f);
    } else {
      _230 = cb0_079z;
    }
    if (_215) {
      _237 = exp2(log2(saturate(cb0_084z)) * 3.0f);
    } else {
      _237 = cb0_084z;
    }
    if (_217) {
      _244 = exp2(log2(saturate(cb0_085z)) * 3.0f);
    } else {
      _244 = cb0_085z;
    }
    if (_219) {
      _251 = exp2(log2(saturate(cb0_086z)) * 3.0f);
    } else {
      _251 = cb0_086z;
    }
    float _252 = max(_230, _237);
    float _253 = max(_230, _244);
    float _254 = max(_230, _251);
    float _270 = saturate((_135 - (_252 * 1000.0f)) / ((_252 * 9999.990234375f) + 0.009999999776482582f));
    float _271 = saturate((_135 - (_253 * 1000.0f)) / ((_253 * 9999.990234375f) + 0.009999999776482582f));
    float _272 = saturate((_135 - (_254 * 1000.0f)) / ((_254 * 9999.990234375f) + 0.009999999776482582f));
    _286 = ((_270 * _270) * (3.0f - (_270 * 2.0f)));
    _287 = ((_271 * _271) * (3.0f - (_271 * 2.0f)));
    _288 = ((_272 * _272) * (3.0f - (_272 * 2.0f)));
  } else {
    _286 = 1.0f;
    _287 = 1.0f;
    _288 = 1.0f;
  }
  if (((bool)(((bool)(((bool)(((bool)(!(cb0_080x == 0.0f))) || ((bool)(!(cb0_085x == 0.0f))))) || ((bool)(!(cb0_086x == 0.0f))))) || ((bool)(!(cb0_087x == 0.0f))))) || ((bool)(!(cb0_088x == 0.0f)))) {
    float _309 = saturate(select((((_144 - _136.x) + ((((dx_alignment_legacy_View_448[3].z) - _144) + ((dx_alignment_legacy_View_448[2].z) * _135)) * select(((dx_alignment_legacy_View_448[3].w) < 1.0f), 0.0f, 1.0f))) > 0.0005000000237487257f), 1.0f, 0.0f) + select((_136.x > 0.0005000000237487257f), 0.0f, 1.0f));
    _323 = max(_309, (1.0f - saturate(max(cb0_080x, cb0_085x))));
    _324 = max(_309, (1.0f - saturate(max(cb0_080x, cb0_086x))));
    _325 = max(_309, (1.0f - saturate(max(cb0_080x, cb0_087x))));
  } else {
    _323 = 1.0f;
    _324 = 1.0f;
    _325 = 1.0f;
  }
  float _326 = TEXCOORD_2.w * 543.3099975585938f;
  float _330 = frac(sin(_326 + TEXCOORD_2.z) * 493013.0f);
  if (cb0_079x > 0.0f) {
    _353 = ((cb0_079x * (frac((sin((TEXCOORD_2.z + 33.9900016784668f) + _326) * 493013.0f) + 7.177000045776367f) - _330)) + _330);
    _354 = ((cb0_079x * (frac((sin((TEXCOORD_2.z + 66.98999786376953f) + _326) * 493013.0f) + 14.298999786376953f) - _330)) + _330);
  } else {
    _353 = _330;
    _354 = _330;
  }
  if (cb0_082z > 0.0f) {
    _376 = (((((_288 * _208) * _325) * cb0_082z) * ((sin((((TEXCOORD_3.y * 10.0f) + 10.0f) + (_330 * 0.0020000000949949026f)) + (dx_alignment_legacy_View_2376 * 4.0f)) * 0.5f) + 0.5f)) + 1.0f);
  } else {
    _376 = 1.0f;
  }
  float _379 = (_287 * _207) * _324;
  float _380 = _379 * cb0_082y;
  if (cb0_082y > 0.0f) {
    float _385 = dx_alignment_legacy_View_2376 * 0.00016666666488163173f;
    float _389 = frac(abs(_385));
    float _394 = ((TEXCOORD_3.y * 111000.0f) + 111000.0f) * select((_385 >= (-0.0f - _385)), _389, (-0.0f - _389));
    float _400 = (0.5f - frac(sin(dot(float2(_394, _394), float2(12.989800453186035f, 78.23300170898438f))) * 43758.546875f)) * 0.014999999664723873f;
    _407 = (((_380 * 0.5f) * _400) + _121);
    _408 = ((_400 * _380) + _122);
  } else {
    _407 = _121;
    _408 = _122;
  }
  float _413 = cb0_078z * (1.0f - (_330 * _330));
  float _418 = (_413 * (TEXCOORD_2.x - _407)) + _407;
  float _419 = (_413 * (TEXCOORD_2.y - _408)) + _408;
  float _434 = _418 - (((cb0_048x * _107) + cb0_048z) * cb0_047z);
  float _435 = _419 - (((cb0_048y * _108) + cb0_048w) * cb0_047w);
  float _445 = cb0_099z * cb0_098x;
  float _446 = cb0_099z * cb0_098y;
  bool _447 = (cb0_099x == 0.0f);
  float _457 = (cb0_095z * _107) + cb0_095x;
  float _458 = (cb0_095w * _108) + cb0_095y;
  float _469 = float(((int)(uint)((bool)(_457 > 0.0f))) - ((int)(uint)((bool)(_457 < 0.0f))));
  float _470 = float(((int)(uint)((bool)(_458 > 0.0f))) - ((int)(uint)((bool)(_458 < 0.0f))));
  float _475 = saturate(abs(_457) - cb0_098z);
  float _476 = saturate(abs(_458) - cb0_098z);
  float _486 = _458 - ((_476 * _445) * _470);
  float _488 = _458 - ((_476 * _446) * _470);
  bool _489 = (cb0_099x > 0.0f);
  if (_489) {
    _496 = (_486 - (cb0_099w * 0.4000000059604645f));
    _497 = (_488 - (cb0_099w * 0.20000000298023224f));
  } else {
    _496 = _486;
    _497 = _488;
  }
  float4 _532 = t0.Sample(s0, float2(min(max(_418, cb0_053x), cb0_053z), min(max(_419, cb0_053y), cb0_053w)));
  float4 _547 = t0.Sample(s0, float2(min(max(((((cb0_048x * ((cb0_096z * (_457 - ((_475 * select(_447, _445, cb0_098x)) * _469))) + cb0_096x)) + cb0_048z) * cb0_047z) + _434), cb0_053x), cb0_053z), min(max(((((cb0_048y * ((cb0_096w * _496) + cb0_096y)) + cb0_048w) * cb0_047w) + _435), cb0_053y), cb0_053w)));
  float4 _560 = t0.Sample(s0, float2(min(max(((((cb0_048x * ((cb0_096z * (_457 - ((_475 * select(_447, _446, cb0_098y)) * _469))) + cb0_096x)) + cb0_048z) * cb0_047z) + _434), cb0_053x), cb0_053z), min(max(((((cb0_048y * ((cb0_096w * _497) + cb0_096y)) + cb0_048w) * cb0_047w) + _435), cb0_053y), cb0_053w)));
  if (_489) {
    float _570 = saturate(((((_532.y * 0.5870000123977661f) - cb0_099y) + (_532.x * 0.29899999499320984f)) + (_532.z * 0.11400000005960464f)) * 10.0f);
    float _574 = (_570 * _570) * (3.0f - (_570 * 2.0f));
    _588 = (RENODX_WUWA_CA * (((_532.x - _547.x) + (_574 * (_547.x - _532.x))) * cb0_099x) + _547.x);
    _589 = (RENODX_WUWA_CA * (((_532.y - _560.y) + (_574 * (_560.y - _532.y))) * cb0_099x) + _560.y);
  } else {
    _588 = _547.x;
    _589 = _560.y;
  }
  float _592 = saturate(cb0_081x);
  float _594 = saturate(cb0_081y);
  if (_592 > 0.0f) {
    float _605 = saturate(((_588 * 0.29899999499320984f) + (_532.z * 0.11400000005960464f)) + (_589 * 0.5870000123977661f));
    float _611 = ((_605 * _605) * (saturate(1.0f - cb0_081z) * 2.0f)) * (3.0f - (_605 * 2.0f));
    float _618 = max(sqrt(((_588 * _588) + (_532.z * _532.z)) + (_589 * _589)), 0.014999999664723873f);
    float _619 = _588 / _618;
    float _620 = _589 / _618;
    float _621 = _532.z / _618;
    float _631 = log2(_611);
    float _650 = ((_286 * _206) * _323) * _592;
    _661 = (((((lerp(_619, 1.0f, 0.25f)) * (((_594 * 0.17000000178813934f) + 0.029999999329447746f) + _611)) - _588) * _650) + _588);
    _662 = (((((((_594 * 0.18000000715255737f) + 0.05000000074505806f) + exp2(_631 * 0.8999999761581421f)) * (lerp(_620, 1.0f, 0.25f))) - _589) * _650) + _589);
    _663 = (((((((_594 * 0.17999999225139618f) + 0.07999999821186066f) + exp2(_631 * 0.949999988079071f)) * (lerp(_621, 1.0f, 0.25f))) - _532.z) * _650) + _532.z);
  } else {
    _661 = _588;
    _662 = _589;
    _663 = _532.z;
  }
  float _666 = saturate(cb0_082x);
  float _667 = _379 * _666;
  if (_666 > 0.0f) {
    float _678 = (sin(((_108 * 640.0f) + 640.0f) - (dx_alignment_legacy_View_2376 * 10.0f)) * 0.5f) + 1.0f;
    _692 = ((((_678 * _661) - _661) * _667) + _661);
    _693 = ((((_678 * _662) - _662) * _667) + _662);
    _694 = ((((_678 * _663) - _663) * _667) + _663);
  } else {
    _692 = _661;
    _693 = _662;
    _694 = _663;
  }

  float4 _717 = t1.Sample(s1, float2(min(max(((cb0_068x * _418) + cb0_068z), cb0_060x), cb0_060z), min(max(((cb0_068y * _419) + cb0_068w), cb0_060y), cb0_060w)));
  _717.rgb *= RENODX_WUWA_BLOOM;

  float _744 = TEXCOORD_1.z + -1.0f;
  float _746 = TEXCOORD_1.w + -1.0f;
  float _749 = ((_744 + (cb0_073x * 2.0f)) * cb0_071z) * cb0_071x;
  float _751 = ((_746 + (cb0_073y * 2.0f)) * cb0_071w) * cb0_071x;
  float _758 = 1.0f / ((((saturate(cb0_072w) * 9.0f) + 1.0f) * dot(float2(_749, _751), float2(_749, _751))) + 1.0f);
  float _759 = _758 * _758;
  float _786 = ((_744 + (cb0_076x * 2.0f)) * cb0_074z) * cb0_074x;
  float _788 = ((_746 + (cb0_076y * 2.0f)) * cb0_074w) * cb0_074x;
  float _795 = 1.0f / ((((saturate(cb0_075w) * 9.0f) + 1.0f) * dot(float2(_786, _788), float2(_786, _788))) + 1.0f);
  float _796 = _795 * _795;
  float _820 = (((_717.x + ((_692 * TEXCOORD_1.x) * cb0_069x)) * _376) * min(((_759 * (1.0f - cb0_072x)) + cb0_072x), ((_796 * (1.0f - cb0_075x)) + cb0_075x))) * ((cb0_078x * _330) + cb0_078y);
  float _823 = (((_717.y + ((_693 * TEXCOORD_1.x) * cb0_069y)) * _376) * min(((_759 * (1.0f - cb0_072y)) + cb0_072y), ((_796 * (1.0f - cb0_075y)) + cb0_075y))) * ((cb0_078x * _353) + cb0_078y);
  float _826 = (((_717.z + ((_694 * TEXCOORD_1.x) * cb0_069z)) * _376) * min(((_759 * (1.0f - cb0_072z)) + cb0_072z), ((_796 * (1.0f - cb0_075z)) + cb0_075z))) * ((cb0_078x * _354) + cb0_078y);

  CAPTURE_UNTONEMAPPED(float3(_820, _823, _826));

  [branch]
  // if (!((uint)(cb0_089y) == 0)) {
  if (((uint)(RENODX_WUWA_TM) == 1)) {
    // _859 = saturate((((_820 * 1.3600000143051147f) + 0.04699999839067459f) * _820) / ((((_820 * 0.9599999785423279f) + 0.5600000023841858f) * _820) + 0.14000000059604645f));
    // _860 = saturate((((_823 * 1.3600000143051147f) + 0.04699999839067459f) * _823) / ((((_823 * 0.9599999785423279f) + 0.5600000023841858f) * _823) + 0.14000000059604645f));
    // _861 = saturate((((_826 * 1.3600000143051147f) + 0.04699999839067459f) * _826) / ((((_826 * 0.9599999785423279f) + 0.5600000023841858f) * _826) + 0.14000000059604645f));
    _859 = ((((_820 * 1.3600000143051147f) + 0.04699999839067459f) * _820) / ((((_820 * 0.9599999785423279f) + 0.5600000023841858f) * _820) + 0.14000000059604645f));
    _860 = ((((_823 * 1.3600000143051147f) + 0.04699999839067459f) * _823) / ((((_823 * 0.9599999785423279f) + 0.5600000023841858f) * _823) + 0.14000000059604645f));
    _861 = ((((_826 * 1.3600000143051147f) + 0.04699999839067459f) * _826) / ((((_826 * 0.9599999785423279f) + 0.5600000023841858f) * _826) + 0.14000000059604645f));
  } else {
    _859 = _820;
    _860 = _823;
    _861 = _826;
  }
  [branch]
  // if (!((uint)(cb0_089z) == 0)) {
  if (((uint)(RENODX_WUWA_TM) == 2)) {
    float _871 = 1.0049500465393066f - (0.16398000717163086f / (_859 + -0.19505000114440918f));
    float _872 = 1.0049500465393066f - (0.16398000717163086f / (_860 + -0.19505000114440918f));
    float _873 = 1.0049500465393066f - (0.16398000717163086f / (_861 + -0.19505000114440918f));
    // _893 = saturate(((_859 - _871) * select((_859 > 0.6000000238418579f), 0.0f, 1.0f)) + _871);
    // _894 = saturate(((_860 - _872) * select((_860 > 0.6000000238418579f), 0.0f, 1.0f)) + _872);
    // _895 = saturate(((_861 - _873) * select((_861 > 0.6000000238418579f), 0.0f, 1.0f)) + _873);
    _893 = (((_859 - _871) * select((_859 > 0.6000000238418579f), 0.0f, 1.0f)) + _871);
    _894 = (((_860 - _872) * select((_860 > 0.6000000238418579f), 0.0f, 1.0f)) + _872);
    _895 = (((_861 - _873) * select((_861 > 0.6000000238418579f), 0.0f, 1.0f)) + _873);
  } else {
    _893 = _859;
    _894 = _860;
    _895 = _861;
  }
  [branch]
  // if (!((uint)(cb0_089w) == 0)) {
  if (((uint)(RENODX_WUWA_TM) == 3)) {
    float _901 = cb0_037y * _893;
    float _902 = cb0_037y * _894;
    float _903 = cb0_037y * _895;
    float _906 = cb0_037z * cb0_037w;
    float _916 = cb0_038y * cb0_038x;
    float _927 = cb0_038z * cb0_038x;
    float _934 = cb0_038y / cb0_038z;
    // _942 = saturate(((((_906 + _901) * _893) + _916) / (_927 + ((_901 + cb0_037z) * _893))) - _934);
    // _943 = saturate(((((_906 + _902) * _894) + _916) / (_927 + ((_902 + cb0_037z) * _894))) - _934);
    // _944 = saturate(((((_906 + _903) * _895) + _916) / (_927 + ((_903 + cb0_037z) * _895))) - _934);
    _942 = (((((_906 + _901) * _893) + _916) / (_927 + ((_901 + cb0_037z) * _893))) - _934);
    _943 = (((((_906 + _902) * _894) + _916) / (_927 + ((_902 + cb0_037z) * _894))) - _934);
    _944 = (((((_906 + _903) * _895) + _916) / (_927 + ((_903 + cb0_037z) * _895))) - _934);
  } else {
    _942 = _893;
    _943 = _894;
    _944 = _895;
  }

  CLAMP_IF_SDR(_942); CLAMP_IF_SDR(_943); CLAMP_IF_SDR(_944);
  CAPTURE_TONEMAPPED(float3(_942, _943, _944));

  float4 _966 = t4.Sample(s4, float3(((saturate((log2(_942 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_943 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_944 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f)));
  _966.rgb = HandleLUTOutput(_966.rgb, untonemapped, tonemapped);

  float _970 = _966.x * 1.0499999523162842f;
  float _971 = _966.y * 1.0499999523162842f;
  float _972 = _966.z * 1.0499999523162842f;

  // float _980 = ((_330 * 0.00390625f) + -0.001953125f) + _970;
  // float _981 = ((_353 * 0.00390625f) + -0.001953125f) + _971;
  // float _982 = ((_354 * 0.00390625f) + -0.001953125f) + _972;
  float _980 = RENODX_WUWA_GRAIN * ((_330 * 0.00390625f) + -0.001953125f) + _970;
  float _981 = RENODX_WUWA_GRAIN * ((_353 * 0.00390625f) + -0.001953125f) + _971;
  float _982 = RENODX_WUWA_GRAIN * ((_354 * 0.00390625f) + -0.001953125f) + _972;

  [branch]
  if (!((uint)(cb0_089x) == 0)) {
    float _994 = (pow(_980, 0.012683313339948654f));
    float _995 = (pow(_981, 0.012683313339948654f));
    float _996 = (pow(_982, 0.012683313339948654f));
    float _1029 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_994 + -0.8359375f)) / (18.8515625f - (_994 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_088w));
    float _1030 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_995 + -0.8359375f)) / (18.8515625f - (_995 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_088w));
    float _1031 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_996 + -0.8359375f)) / (18.8515625f - (_996 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_088w));
    _1057 = min((_1029 * 12.920000076293945f), ((exp2(log2(max(_1029, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _1058 = min((_1030 * 12.920000076293945f), ((exp2(log2(max(_1030, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _1059 = min((_1031 * 12.920000076293945f), ((exp2(log2(max(_1031, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _1057 = _980;
    _1058 = _981;
    _1059 = _982;
  }
  SV_Target.x = _1057;
  SV_Target.y = _1058;
  SV_Target.z = _1059;

  // SV_Target.w = saturate(dot(float3(_970, _971, _972), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  SV_Target.w = (dot(float3(_970, _971, _972), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);

  return SV_Target;
}
