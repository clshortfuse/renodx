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
  float cb0_090y : packoffset(c090.y);
  float cb0_090z : packoffset(c090.z);
  float cb0_091x : packoffset(c091.x);
  uint cb0_091y : packoffset(c091.y);
  uint cb0_091z : packoffset(c091.z);
  uint cb0_091w : packoffset(c091.w);
  uint cb0_092x : packoffset(c092.x);
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
  float2 dx_alignment_legacy_View_3576 : packoffset(c223.z);
  float2 dx_alignment_legacy_View_3584 : packoffset(c224.x);
  float2 dx_alignment_legacy_View_3592 : packoffset(c224.z);
  float2 dx_alignment_legacy_View_3600 : packoffset(c225.x);
  float dx_alignment_legacy_View_3608 : packoffset(c225.z);
  float dx_alignment_legacy_View_3612 : packoffset(c225.w);
  float3 dx_alignment_legacy_View_3616 : packoffset(c226.x);
  float dx_alignment_legacy_View_3628 : packoffset(c226.w);
  float2 dx_alignment_legacy_View_3632 : packoffset(c227.x);
  float2 dx_alignment_legacy_View_3640 : packoffset(c227.z);
  float dx_alignment_legacy_View_3648 : packoffset(c228.x);
  float dx_alignment_legacy_View_3652 : packoffset(c228.y);
  float dx_alignment_legacy_View_3656 : packoffset(c228.z);
  float dx_alignment_legacy_View_3660 : packoffset(c228.w);
  float3 dx_alignment_legacy_View_3664 : packoffset(c229.x);
  float dx_alignment_legacy_View_3676 : packoffset(c229.w);
  float3 dx_alignment_legacy_View_3680 : packoffset(c230.x);
  float dx_alignment_legacy_View_3692 : packoffset(c230.w);
  float3 dx_alignment_legacy_View_3696 : packoffset(c231.x);
  float dx_alignment_legacy_View_3708 : packoffset(c231.w);
  float3 dx_alignment_legacy_View_3712 : packoffset(c232.x);
  float dx_alignment_legacy_View_3724 : packoffset(c232.w);
  float dx_alignment_legacy_View_3728 : packoffset(c233.x);
  float dx_alignment_legacy_View_3732 : packoffset(c233.y);
  float dx_alignment_legacy_View_3736 : packoffset(c233.z);
  float dx_alignment_legacy_View_3740 : packoffset(c233.w);
  float4 dx_alignment_legacy_View_3744[4] : packoffset(c234.x);
  float4 dx_alignment_legacy_View_3808[2] : packoffset(c238.x);
  int dx_alignment_legacy_View_3840 : packoffset(c240.x);
  float dx_alignment_legacy_View_3844 : packoffset(c240.y);
  float dx_alignment_legacy_View_3848 : packoffset(c240.z);
  float dx_alignment_legacy_View_3852 : packoffset(c240.w);
  float4 dx_alignment_legacy_View_3856 : packoffset(c241.x);
  float2 dx_alignment_legacy_View_3872 : packoffset(c242.x);
  float dx_alignment_legacy_View_3880 : packoffset(c242.z);
  float dx_alignment_legacy_View_3884 : packoffset(c242.w);
  float4 dx_alignment_legacy_View_3888 : packoffset(c243.x);
  int dx_alignment_legacy_View_3904 : packoffset(c244.x);
  float dx_alignment_legacy_View_3908 : packoffset(c244.y);
  float dx_alignment_legacy_View_3912 : packoffset(c244.z);
  float dx_alignment_legacy_View_3916 : packoffset(c244.w);
  float4 dx_alignment_legacy_View_3920 : packoffset(c245.x);
  int dx_alignment_legacy_View_3936 : packoffset(c246.x);
  int dx_alignment_legacy_View_3940 : packoffset(c246.y);
  int dx_alignment_legacy_View_3944 : packoffset(c246.z);
  float dx_alignment_legacy_View_3948 : packoffset(c246.w);
  float dx_alignment_legacy_View_3952 : packoffset(c247.x);
  float dx_alignment_legacy_View_3956 : packoffset(c247.y);
  float dx_alignment_legacy_View_3960 : packoffset(c247.z);
  float dx_alignment_legacy_View_3964 : packoffset(c247.w);
  float4 dx_alignment_legacy_View_3968 : packoffset(c248.x);
  float4 dx_alignment_legacy_View_3984 : packoffset(c249.x);
  float4 dx_alignment_legacy_View_4000 : packoffset(c250.x);
  float4 dx_alignment_legacy_View_4016 : packoffset(c251.x);
  float4 dx_alignment_legacy_View_4032 : packoffset(c252.x);
  float4 dx_alignment_legacy_View_4048 : packoffset(c253.x);
  int dx_alignment_legacy_View_4064 : packoffset(c254.x);
  float dx_alignment_legacy_View_4068 : packoffset(c254.y);
  float dx_alignment_legacy_View_4072 : packoffset(c254.z);
  float dx_alignment_legacy_View_4076 : packoffset(c254.w);
  float4 dx_alignment_legacy_View_4080 : packoffset(c255.x);
  float4 dx_alignment_legacy_View_4096 : packoffset(c256.x);
  float dx_alignment_legacy_View_4112 : packoffset(c257.x);
  float dx_alignment_legacy_View_4116 : packoffset(c257.y);
  float dx_alignment_legacy_View_4120 : packoffset(c257.z);
  float dx_alignment_legacy_View_4124 : packoffset(c257.w);
  float dx_alignment_legacy_View_4128 : packoffset(c258.x);
  float dx_alignment_legacy_View_4132 : packoffset(c258.y);
  float dx_alignment_legacy_View_4136 : packoffset(c258.z);
  float dx_alignment_legacy_View_4140 : packoffset(c258.w);
  float4 dx_alignment_legacy_View_4144 : packoffset(c259.x);
  int dx_alignment_legacy_View_4160 : packoffset(c260.x);
  int dx_alignment_legacy_View_4164 : packoffset(c260.y);
  int dx_alignment_legacy_View_4168 : packoffset(c260.z);
  float dx_alignment_legacy_View_4172 : packoffset(c260.w);
  float4 dx_alignment_legacy_View_4176 : packoffset(c261.x);
  float4 dx_alignment_legacy_View_4192 : packoffset(c262.x);
  float4 dx_alignment_legacy_View_4208 : packoffset(c263.x);
  float4 dx_alignment_legacy_View_4224 : packoffset(c264.x);
  float dx_alignment_legacy_View_4240 : packoffset(c265.x);
  float dx_alignment_legacy_View_4244 : packoffset(c265.y);
  float dx_alignment_legacy_View_4248 : packoffset(c265.z);
  float dx_alignment_legacy_View_4252 : packoffset(c265.w);
  float4 dx_alignment_legacy_View_4256 : packoffset(c266.x);
  float4 dx_alignment_legacy_View_4272 : packoffset(c267.x);
  float4 dx_alignment_legacy_View_4288 : packoffset(c268.x);
  float4 dx_alignment_legacy_View_4304 : packoffset(c269.x);
  float4 dx_alignment_legacy_View_4320 : packoffset(c270.x);
  float dx_alignment_legacy_View_4336 : packoffset(c271.x);
  float dx_alignment_legacy_View_4340 : packoffset(c271.y);
  float dx_alignment_legacy_View_4344 : packoffset(c271.z);
  float dx_alignment_legacy_View_4348 : packoffset(c271.w);
  float4 dx_alignment_legacy_View_4352 : packoffset(c272.x);
  float4 dx_alignment_legacy_View_4368 : packoffset(c273.x);
  float dx_alignment_legacy_View_4384 : packoffset(c274.x);
  float dx_alignment_legacy_View_4388 : packoffset(c274.y);
  float dx_alignment_legacy_View_4392 : packoffset(c274.z);
  float dx_alignment_legacy_View_4396 : packoffset(c274.w);
  float4 dx_alignment_legacy_View_4400 : packoffset(c275.x);
  float4 dx_alignment_legacy_View_4416 : packoffset(c276.x);
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
  float dx_alignment_legacy_View_5024 : packoffset(c314.x);
  float dx_alignment_legacy_View_5028 : packoffset(c314.y);
  float dx_alignment_legacy_View_5032 : packoffset(c314.z);
  float dx_alignment_legacy_View_5036 : packoffset(c314.w);
  float dx_alignment_legacy_View_5040 : packoffset(c315.x);
  float dx_alignment_legacy_View_5044 : packoffset(c315.y);
  float dx_alignment_legacy_View_5048 : packoffset(c315.z);
  float dx_alignment_legacy_View_5052 : packoffset(c315.w);
  float dx_alignment_legacy_View_5056 : packoffset(c316.x);
  float dx_alignment_legacy_View_5060 : packoffset(c316.y);
  float dx_alignment_legacy_View_5064 : packoffset(c316.z);
  float dx_alignment_legacy_View_5068 : packoffset(c316.w);
  float dx_alignment_legacy_View_5072 : packoffset(c317.x);
  float dx_alignment_legacy_View_5076 : packoffset(c317.y);
  float dx_alignment_legacy_View_5080 : packoffset(c317.z);
  float dx_alignment_legacy_View_5084 : packoffset(c317.w);
  float dx_alignment_legacy_View_5088 : packoffset(c318.x);
  float dx_alignment_legacy_View_5092 : packoffset(c318.y);
  float dx_alignment_legacy_View_5096 : packoffset(c318.z);
  float dx_alignment_legacy_View_5100 : packoffset(c318.w);
  float4 dx_alignment_legacy_View_5104 : packoffset(c319.x);
  float dx_alignment_legacy_View_5120 : packoffset(c320.x);
  float dx_alignment_legacy_View_5124 : packoffset(c320.y);
  float dx_alignment_legacy_View_5128 : packoffset(c320.z);
  float dx_alignment_legacy_View_5132 : packoffset(c320.w);
  float4 dx_alignment_legacy_View_5136 : packoffset(c321.x);
  float dx_alignment_legacy_View_5152 : packoffset(c322.x);
  float dx_alignment_legacy_View_5156 : packoffset(c322.y);
  float dx_alignment_legacy_View_5160 : packoffset(c322.z);
  float dx_alignment_legacy_View_5164 : packoffset(c322.w);
  float dx_alignment_legacy_View_5168 : packoffset(c323.x);
  float dx_alignment_legacy_View_5172 : packoffset(c323.y);
  float dx_alignment_legacy_View_5176 : packoffset(c323.z);
  float dx_alignment_legacy_View_5180 : packoffset(c323.w);
  float dx_alignment_legacy_View_5184 : packoffset(c324.x);
  float dx_alignment_legacy_View_5188 : packoffset(c324.y);
  float dx_alignment_legacy_View_5192 : packoffset(c324.z);
  float dx_alignment_legacy_View_5196 : packoffset(c324.w);
  float2 dx_alignment_legacy_View_5200 : packoffset(c325.x);
  float dx_alignment_legacy_View_5208 : packoffset(c325.z);
  float dx_alignment_legacy_View_5212 : packoffset(c325.w);
  float3 dx_alignment_legacy_View_5216 : packoffset(c326.x);
  float dx_alignment_legacy_View_5228 : packoffset(c326.w);
  float dx_alignment_legacy_View_5232 : packoffset(c327.x);
  float dx_alignment_legacy_View_5236 : packoffset(c327.y);
  float dx_alignment_legacy_View_5240 : packoffset(c327.z);
  float dx_alignment_legacy_View_5244 : packoffset(c327.w);
  float4 dx_alignment_legacy_View_5248 : packoffset(c328.x);
  float3 dx_alignment_legacy_View_5264 : packoffset(c329.x);
  float dx_alignment_legacy_View_5276 : packoffset(c329.w);
  float dx_alignment_legacy_View_5280 : packoffset(c330.x);
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
  float _352;
  float _353;
  float _375;
  float _406;
  float _407;
  float _483;
  float _484;
  float _485;
  float _513;
  float _514;
  float _515;
  float _674;
  float _675;
  float _676;
  float _708;
  float _709;
  float _710;
  float _758;
  float _759;
  float _760;
  float _833;
  float _836;
  float _837;
  float _838;
  float _862;
  float _865;
  float _866;
  float _867;
  float _902;
  float _903;
  float _904;
  float _1017;
  float _1018;
  float _1019;
  float _1026;
  float _1040;
  if (!(!(cb0_085x != 0.0f))) {
    float _31 = cb0_085x * 2.0f;
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
  } else {
    _106 = TEXCOORD_3.x;
    _107 = TEXCOORD_3.y;
  }
  float _120 = ((cb0_048z * _106) + cb0_049x) * cb0_048x;
  float _121 = ((cb0_048w * _107) + cb0_049y) * cb0_048y;
  float4 _122 = t3.SampleLevel(s3, float2(_120, _121), 0.0f);
  float _134 = ((dx_alignment_legacy_View_1040.x * _122.x) + dx_alignment_legacy_View_1040.y) + (1.0f / ((dx_alignment_legacy_View_1040.z * _122.x) - dx_alignment_legacy_View_1040.w));
  float4 _135 = t2.Sample(s2, float2(_120, _121));
  float _143 = 1.0f / ((dx_alignment_legacy_View_1040.w + _134) * dx_alignment_legacy_View_1040.z);
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
    if (_213) {
      _229 = exp2(log2(saturate(cb0_080z)) * 3.0f);
    } else {
      _229 = cb0_080z;
    }
    if (_214) {
      _236 = exp2(log2(saturate(cb0_085z)) * 3.0f);
    } else {
      _236 = cb0_085z;
    }
    if (_216) {
      _243 = exp2(log2(saturate(cb0_086z)) * 3.0f);
    } else {
      _243 = cb0_086z;
    }
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
  } else {
    _285 = 1.0f;
    _286 = 1.0f;
    _287 = 1.0f;
  }
  if (((bool)(((bool)(((bool)(((bool)(!(cb0_081x == 0.0f))) || ((bool)(!(cb0_086x == 0.0f))))) || ((bool)(!(cb0_087x == 0.0f))))) || ((bool)(!(cb0_088x == 0.0f))))) || ((bool)(!(cb0_089x == 0.0f)))) {
    float _308 = saturate(select((((_143 - _135.x) + ((((dx_alignment_legacy_View_448[3].z) - _143) + ((dx_alignment_legacy_View_448[2].z) * _134)) * select(((dx_alignment_legacy_View_448[3].w) < 1.0f), 0.0f, 1.0f))) > 0.0005000000237487257f), 1.0f, 0.0f) + select((_135.x > 0.0005000000237487257f), 0.0f, 1.0f));
    _322 = max(_308, (1.0f - saturate(max(cb0_081x, cb0_086x))));
    _323 = max(_308, (1.0f - saturate(max(cb0_081x, cb0_087x))));
    _324 = max(_308, (1.0f - saturate(max(cb0_081x, cb0_088x))));
  } else {
    _322 = 1.0f;
    _323 = 1.0f;
    _324 = 1.0f;
  }
  float _325 = TEXCOORD_2.w * 543.3099975585938f;
  float _329 = frac(sin(_325 + TEXCOORD_2.z) * 493013.0f);
  if (cb0_080x > 0.0f) {
    _352 = ((cb0_080x * (frac((sin((TEXCOORD_2.z + 33.9900016784668f) + _325) * 493013.0f) + 7.177000045776367f) - _329)) + _329);
    _353 = ((cb0_080x * (frac((sin((TEXCOORD_2.z + 66.98999786376953f) + _325) * 493013.0f) + 14.298999786376953f) - _329)) + _329);
  } else {
    _352 = _329;
    _353 = _329;
  }
  if (cb0_083z > 0.0f) {
    _375 = (((((_287 * _207) * _324) * cb0_083z) * ((sin((((TEXCOORD_3.y * 10.0f) + 10.0f) + (_329 * 0.0020000000949949026f)) + (dx_alignment_legacy_View_2376 * 4.0f)) * 0.5f) + 0.5f)) + 1.0f);
  } else {
    _375 = 1.0f;
  }
  float _378 = (_286 * _206) * _323;
  float _379 = _378 * cb0_083y;
  if (cb0_083y > 0.0f) {
    float _384 = dx_alignment_legacy_View_2376 * 0.00016666666488163173f;
    float _388 = frac(abs(_384));
    float _393 = ((TEXCOORD_3.y * 111000.0f) + 111000.0f) * select((_384 >= (-0.0f - _384)), _388, (-0.0f - _388));
    float _399 = (0.5f - frac(sin(dot(float2(_393, _393), float2(12.989800453186035f, 78.23300170898438f))) * 43758.546875f)) * 0.014999999664723873f;
    _406 = (((_379 * 0.5f) * _399) + _120);
    _407 = ((_399 * _379) + _121);
  } else {
    _406 = _120;
    _407 = _121;
  }
  float4 _408 = t0.Sample(s0, float2(_406, _407));
  float _414 = saturate(cb0_082x);
  float _416 = saturate(cb0_082y);
  if (_414 > 0.0f) {
    float _427 = saturate(((_408.x * 0.29899999499320984f) + (_408.y * 0.5870000123977661f)) + (_408.z * 0.11400000005960464f));
    float _433 = ((_427 * _427) * (saturate(1.0f - cb0_082z) * 2.0f)) * (3.0f - (_427 * 2.0f));
    float _440 = max(sqrt(((_408.x * _408.x) + (_408.y * _408.y)) + (_408.z * _408.z)), 0.014999999664723873f);
    float _441 = _408.x / _440;
    float _442 = _408.y / _440;
    float _443 = _408.z / _440;
    float _453 = log2(_433);
    float _472 = ((_285 * _205) * _322) * _414;
    _483 = (((((lerp(_441, 1.0f, 0.25f)) * (((_416 * 0.17000000178813934f) + 0.029999999329447746f) + _433)) - _408.x) * _472) + _408.x);
    _484 = (((((((_416 * 0.18000000715255737f) + 0.05000000074505806f) + exp2(_453 * 0.8999999761581421f)) * (lerp(_442, 1.0f, 0.25f))) - _408.y) * _472) + _408.y);
    _485 = (((((((_416 * 0.17999999225139618f) + 0.07999999821186066f) + exp2(_453 * 0.949999988079071f)) * (lerp(_443, 1.0f, 0.25f))) - _408.z) * _472) + _408.z);
  } else {
    _483 = _408.x;
    _484 = _408.y;
    _485 = _408.z;
  }
  float _487 = saturate(cb0_083x);
  float _488 = _378 * _487;
  if (_487 > 0.0f) {
    float _499 = (sin(((_107 * 640.0f) + 640.0f) - (dx_alignment_legacy_View_2376 * 10.0f)) * 0.5f) + 1.0f;
    _513 = ((((_499 * _483) - _483) * _488) + _483);
    _514 = ((((_499 * _484) - _484) * _488) + _484);
    _515 = ((((_499 * _485) - _485) * _488) + _485);
  } else {
    _513 = _483;
    _514 = _484;
    _515 = _485;
  }

  float4 _540 = t1.Sample(s1, float2(min(max(((cb0_068z * _406) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _407) + cb0_069y), cb0_060w), cb0_061y)));
  _540.rgb *= RENODX_WUWA_BLOOM;

  float _568 = TEXCOORD_1.z + -1.0f;
  float _570 = TEXCOORD_1.w + -1.0f;
  float _573 = ((_568 + (cb0_074x * 2.0f)) * cb0_072z) * cb0_072x;
  float _575 = ((_570 + (cb0_074y * 2.0f)) * cb0_072w) * cb0_072x;
  float _582 = 1.0f / ((((saturate(cb0_073w) * 9.0f) + 1.0f) * dot(float2(_573, _575), float2(_573, _575))) + 1.0f);
  float _583 = _582 * _582;
  float _584 = cb0_074z + 1.0f;
  float _612 = ((_568 + (cb0_077x * 2.0f)) * cb0_075z) * cb0_075x;
  float _614 = ((_570 + (cb0_077y * 2.0f)) * cb0_075w) * cb0_075x;
  float _621 = 1.0f / ((((saturate(cb0_076w) * 9.0f) + 1.0f) * dot(float2(_612, _614), float2(_612, _614))) + 1.0f);
  float _622 = _621 * _621;
  float _623 = cb0_077z + 1.0f;
  float _635 = (((_540.x + ((_513 * TEXCOORD_1.x) * cb0_070x)) * _375) * ((_583 * (_584 - cb0_073x)) + cb0_073x)) * ((_622 * (_623 - cb0_076x)) + cb0_076x);
  float _638 = (((_540.y + ((_514 * TEXCOORD_1.x) * cb0_070y)) * _375) * ((_583 * (_584 - cb0_073y)) + cb0_073y)) * ((_622 * (_623 - cb0_076y)) + cb0_076y);
  float _641 = (((_540.z + ((_515 * TEXCOORD_1.x) * cb0_070z)) * _375) * ((_583 * (_584 - cb0_073z)) + cb0_073z)) * ((_622 * (_623 - cb0_076z)) + cb0_076z);

  CAPTURE_UNTONEMAPPED(float3(_635, _638, _641));

  [branch]
  // if (!((uint)(cb0_091z) == 0)) {
  if (!((uint)(RENODX_WUWA_TM) == 1)) {
    // _674 = saturate((((_635 * 1.3600000143051147f) + 0.04699999839067459f) * _635) / ((((_635 * 0.9599999785423279f) + 0.5600000023841858f) * _635) + 0.14000000059604645f));
    // _675 = saturate((((_638 * 1.3600000143051147f) + 0.04699999839067459f) * _638) / ((((_638 * 0.9599999785423279f) + 0.5600000023841858f) * _638) + 0.14000000059604645f));
    // _676 = saturate((((_641 * 1.3600000143051147f) + 0.04699999839067459f) * _641) / ((((_641 * 0.9599999785423279f) + 0.5600000023841858f) * _641) + 0.14000000059604645f));
    _674 = ((((_635 * 1.3600000143051147f) + 0.04699999839067459f) * _635) / ((((_635 * 0.9599999785423279f) + 0.5600000023841858f) * _635) + 0.14000000059604645f));
    _675 = ((((_638 * 1.3600000143051147f) + 0.04699999839067459f) * _638) / ((((_638 * 0.9599999785423279f) + 0.5600000023841858f) * _638) + 0.14000000059604645f));
    _676 = ((((_641 * 1.3600000143051147f) + 0.04699999839067459f) * _641) / ((((_641 * 0.9599999785423279f) + 0.5600000023841858f) * _641) + 0.14000000059604645f));
  } else {
    _674 = _635;
    _675 = _638;
    _676 = _641;
  }
  [branch]
  // if (!((uint)(cb0_091w) == 0)) {
  if (!((uint)(RENODX_WUWA_TM) == 2)) {
    float _686 = 1.0049500465393066f - (0.16398000717163086f / (_674 + -0.19505000114440918f));
    float _687 = 1.0049500465393066f - (0.16398000717163086f / (_675 + -0.19505000114440918f));
    float _688 = 1.0049500465393066f - (0.16398000717163086f / (_676 + -0.19505000114440918f));
    // _708 = saturate(((_674 - _686) * select((_674 > 0.6000000238418579f), 0.0f, 1.0f)) + _686);
    // _709 = saturate(((_675 - _687) * select((_675 > 0.6000000238418579f), 0.0f, 1.0f)) + _687);
    // _710 = saturate(((_676 - _688) * select((_676 > 0.6000000238418579f), 0.0f, 1.0f)) + _688);
    _708 = (((_674 - _686) * select((_674 > 0.6000000238418579f), 0.0f, 1.0f)) + _686);
    _709 = (((_675 - _687) * select((_675 > 0.6000000238418579f), 0.0f, 1.0f)) + _687);
    _710 = (((_676 - _688) * select((_676 > 0.6000000238418579f), 0.0f, 1.0f)) + _688);
  } else {
    _708 = _674;
    _709 = _675;
    _710 = _676;
  }
  [branch]
  // if (!((uint)(cb0_092x) == 0)) {
  if (!((uint)(RENODX_WUWA_TM) == 3)) {
    float _717 = cb0_037y * _708;
    float _718 = cb0_037y * _709;
    float _719 = cb0_037y * _710;
    float _722 = cb0_037z * cb0_037w;
    float _732 = cb0_038y * cb0_038x;
    float _743 = cb0_038z * cb0_038x;
    float _750 = cb0_038y / cb0_038z;
    // _758 = saturate(((((_722 + _717) * _708) + _732) / (_743 + ((_717 + cb0_037z) * _708))) - _750);
    // _759 = saturate(((((_722 + _718) * _709) + _732) / (_743 + ((_718 + cb0_037z) * _709))) - _750);
    // _760 = saturate(((((_722 + _719) * _710) + _732) / (_743 + ((_719 + cb0_037z) * _710))) - _750);
    _758 = (((((_722 + _717) * _708) + _732) / (_743 + ((_717 + cb0_037z) * _708))) - _750);
    _759 = (((((_722 + _718) * _709) + _732) / (_743 + ((_718 + cb0_037z) * _709))) - _750);
    _760 = (((((_722 + _719) * _710) + _732) / (_743 + ((_719 + cb0_037z) * _710))) - _750);
  } else {
    _758 = _708;
    _759 = _709;
    _760 = _710;
  }
  [branch]
  if (!((uint)(cb0_089w) == 0)) {
    if (!((bool)(cb0_090x <= 0.0f) && (bool)(cb0_090y <= 0.0f))) {
      float _772 = dot(float3(_758, _759, _760), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      if (!(_772 <= 9.999999747378752e-05f)) {
        float _781 = (pow(_758, 0.1593017578125f));
        float _782 = (pow(_759, 0.1593017578125f));
        float _783 = (pow(_760, 0.1593017578125f));
        float _805 = exp2(log2(((_781 * 18.8515625f) + 0.8359375f) / ((_781 * 18.6875f) + 1.0f)) * 78.84375f);
        float _806 = exp2(log2(((_782 * 18.8515625f) + 0.8359375f) / ((_782 * 18.6875f) + 1.0f)) * 78.84375f);
        float _807 = exp2(log2(((_783 * 18.8515625f) + 0.8359375f) / ((_783 * 18.6875f) + 1.0f)) * 78.84375f);
        if ((bool)(cb0_090y > 0.0f) && (bool)((_772 / cb0_090y) > 1.0f)) {
          float _816 = (pow(cb0_090y, 0.1593017578125f));
          float _824 = exp2(log2(((_816 * 18.8515625f) + 0.8359375f) / ((_816 * 18.6875f) + 1.0f)) * 78.84375f);
          if (_805 > _824) {
            float _827 = _805 - _824;
            _833 = ((_827 / ((_827 * cb0_090z) + 1.0f)) + _824);
          } else {
            _833 = _805;
          }
          if (_806 > _824) {
            float _1034 = _806 - _824;
            _1040 = ((_1034 / ((_1034 * cb0_090z) + 1.0f)) + _824);
            if (_807 > _824) {
              float _1043 = _807 - _824;
              _836 = ((_1043 / ((_1043 * cb0_090z) + 1.0f)) + _824);
              _837 = _1040;
              _838 = _833;
            } else {
              _836 = _807;
              _837 = _1040;
              _838 = _833;
            }
          } else {
            _1040 = _806;
            if (_807 > _824) {
              float _1043 = _807 - _824;
              _836 = ((_1043 / ((_1043 * cb0_090z) + 1.0f)) + _824);
              _837 = _1040;
              _838 = _833;
            } else {
              _836 = _807;
              _837 = _1040;
              _838 = _833;
            }
          }
          while(true) {
            if (cb0_090x > 0.0f) {
              if (_772 < cb0_090x) {
                float _846 = (pow(cb0_090x, 0.1593017578125f));
                float _854 = exp2(log2(((_846 * 18.8515625f) + 0.8359375f) / ((_846 * 18.6875f) + 1.0f)) * 78.84375f);
                if (_838 < _854) {
                  _862 = (((cb0_090z * 0.30000001192092896f) * (_854 - _838)) + _838);
                } else {
                  _862 = _838;
                }
                if (_837 < _854) {
                  _1026 = (((cb0_090z * 0.30000001192092896f) * (_854 - _837)) + _837);
                  if (_836 < _854) {
                    _865 = (((cb0_090z * 0.30000001192092896f) * (_854 - _836)) + _836);
                    _866 = _1026;
                    _867 = _862;
                  } else {
                    _865 = _836;
                    _866 = _1026;
                    _867 = _862;
                  }
                } else {
                  _1026 = _837;
                  if (_836 < _854) {
                    _865 = (((cb0_090z * 0.30000001192092896f) * (_854 - _836)) + _836);
                    _866 = _1026;
                    _867 = _862;
                  } else {
                    _865 = _836;
                    _866 = _1026;
                    _867 = _862;
                  }
                }
              } else {
                _865 = _836;
                _866 = _837;
                _867 = _838;
              }
            } else {
              _865 = _836;
              _866 = _837;
              _867 = _838;
            }
            while(true) {
              float _874 = (pow(_867, 0.012683313339948654f));
              float _875 = (pow(_866, 0.012683313339948654f));
              float _876 = (pow(_865, 0.012683313339948654f));
              _902 = exp2(log2(max((_874 + -0.8359375f), 0.0f) / (18.8515625f - (_874 * 18.6875f))) * 6.277394771575928f);
              _903 = exp2(log2(max((_875 + -0.8359375f), 0.0f) / (18.8515625f - (_875 * 18.6875f))) * 6.277394771575928f);
              _904 = exp2(log2(max((_876 + -0.8359375f), 0.0f) / (18.8515625f - (_876 * 18.6875f))) * 6.277394771575928f);
              break;
            }
            break;
          }
        } else {
          _836 = _807;
          _837 = _806;
          _838 = _805;
          while(true) {
            if (cb0_090x > 0.0f) {
              if (_772 < cb0_090x) {
                float _846 = (pow(cb0_090x, 0.1593017578125f));
                float _854 = exp2(log2(((_846 * 18.8515625f) + 0.8359375f) / ((_846 * 18.6875f) + 1.0f)) * 78.84375f);
                if (_838 < _854) {
                  _862 = (((cb0_090z * 0.30000001192092896f) * (_854 - _838)) + _838);
                } else {
                  _862 = _838;
                }
                if (_837 < _854) {
                  _1026 = (((cb0_090z * 0.30000001192092896f) * (_854 - _837)) + _837);
                  if (_836 < _854) {
                    _865 = (((cb0_090z * 0.30000001192092896f) * (_854 - _836)) + _836);
                    _866 = _1026;
                    _867 = _862;
                  } else {
                    _865 = _836;
                    _866 = _1026;
                    _867 = _862;
                  }
                } else {
                  _1026 = _837;
                  if (_836 < _854) {
                    _865 = (((cb0_090z * 0.30000001192092896f) * (_854 - _836)) + _836);
                    _866 = _1026;
                    _867 = _862;
                  } else {
                    _865 = _836;
                    _866 = _1026;
                    _867 = _862;
                  }
                }
              } else {
                _865 = _836;
                _866 = _837;
                _867 = _838;
              }
            } else {
              _865 = _836;
              _866 = _837;
              _867 = _838;
            }
            while(true) {
              float _874 = (pow(_867, 0.012683313339948654f));
              float _875 = (pow(_866, 0.012683313339948654f));
              float _876 = (pow(_865, 0.012683313339948654f));
              _902 = exp2(log2(max((_874 + -0.8359375f), 0.0f) / (18.8515625f - (_874 * 18.6875f))) * 6.277394771575928f);
              _903 = exp2(log2(max((_875 + -0.8359375f), 0.0f) / (18.8515625f - (_875 * 18.6875f))) * 6.277394771575928f);
              _904 = exp2(log2(max((_876 + -0.8359375f), 0.0f) / (18.8515625f - (_876 * 18.6875f))) * 6.277394771575928f);
              break;
            }
            break;
          }
        }
      } else {
        _902 = _758;
        _903 = _759;
        _904 = _760;
      }
    } else {
      _902 = _758;
      _903 = _759;
      _904 = _760;
    }
  } else {
    _902 = _758;
    _903 = _759;
    _904 = _760;
  }

  CLAMP_IF_SDR(_902); CLAMP_IF_SDR(_903); CLAMP_IF_SDR(_904);
  CAPTURE_TONEMAPPED(float3(_902, _903, _904));

  float4 _926 = t4.Sample(s4, float3(((saturate((log2(_902 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_903 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_904 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f)));
  _926.rgb = HandleLUTOutput(_926.rgb, untonemapped, tonemapped);

  float _930 = _926.x * 1.0499999523162842f;
  float _931 = _926.y * 1.0499999523162842f;
  float _932 = _926.z * 1.0499999523162842f;
  float _940 = ((_329 * 0.00390625f) + -0.001953125f) + _930;
  float _941 = ((_352 * 0.00390625f) + -0.001953125f) + _931;
  float _942 = ((_353 * 0.00390625f) + -0.001953125f) + _932;
  [branch]
  if (!((uint)(cb0_091y) == 0)) {
    float _954 = (pow(_940, 0.012683313339948654f));
    float _955 = (pow(_941, 0.012683313339948654f));
    float _956 = (pow(_942, 0.012683313339948654f));
    float _989 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_954 + -0.8359375f)) / (18.8515625f - (_954 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_091x));
    float _990 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_955 + -0.8359375f)) / (18.8515625f - (_955 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_091x));
    float _991 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_956 + -0.8359375f)) / (18.8515625f - (_956 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_091x));
    _1017 = min((_989 * 12.920000076293945f), ((exp2(log2(max(_989, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _1018 = min((_990 * 12.920000076293945f), ((exp2(log2(max(_990, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _1019 = min((_991 * 12.920000076293945f), ((exp2(log2(max(_991, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _1017 = _940;
    _1018 = _941;
    _1019 = _942;
  }
  SV_Target.x = _1017;
  SV_Target.y = _1018;
  SV_Target.z = _1019;

  // SV_Target.w = saturate(dot(float3(_930, _931, _932), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  SV_Target.w = (dot(float3(_930, _931, _932), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);

  return SV_Target;
}
