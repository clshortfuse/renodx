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
  float _354;
  float _355;
  float _377;
  float _408;
  float _409;
  float _506;
  float _507;
  float _508;
  float _537;
  float _538;
  float _539;
  float _698;
  float _699;
  float _700;
  float _732;
  float _733;
  float _734;
  float _782;
  float _783;
  float _784;
  float _857;
  float _860;
  float _861;
  float _862;
  float _886;
  float _889;
  float _890;
  float _891;
  float _926;
  float _927;
  float _928;
  float _1041;
  float _1042;
  float _1043;
  float _1050;
  float _1064;
  if (!(!(cb0_085x != 0.0f))) {
    float _33 = cb0_085x * 2.0f;
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
  } else {
    _108 = TEXCOORD_3.x;
    _109 = TEXCOORD_3.y;
  }
  float _122 = ((cb0_048z * _108) + cb0_049x) * cb0_048x;
  float _123 = ((cb0_048w * _109) + cb0_049y) * cb0_048y;
  float4 _124 = t3.SampleLevel(s3, float2(_122, _123), 0.0f);
  float _136 = ((dx_alignment_legacy_View_1040.x * _124.x) + dx_alignment_legacy_View_1040.y) + (1.0f / ((dx_alignment_legacy_View_1040.z * _124.x) - dx_alignment_legacy_View_1040.w));
  float4 _137 = t2.Sample(s2, float2(_122, _123));
  float _145 = 1.0f / ((dx_alignment_legacy_View_1040.w + _136) * dx_alignment_legacy_View_1040.z);
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
    if (_215) {
      _231 = exp2(log2(saturate(cb0_080z)) * 3.0f);
    } else {
      _231 = cb0_080z;
    }
    if (_216) {
      _238 = exp2(log2(saturate(cb0_085z)) * 3.0f);
    } else {
      _238 = cb0_085z;
    }
    if (_218) {
      _245 = exp2(log2(saturate(cb0_086z)) * 3.0f);
    } else {
      _245 = cb0_086z;
    }
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
  } else {
    _287 = 1.0f;
    _288 = 1.0f;
    _289 = 1.0f;
  }
  if (((bool)(((bool)(((bool)(((bool)(!(cb0_081x == 0.0f))) || ((bool)(!(cb0_086x == 0.0f))))) || ((bool)(!(cb0_087x == 0.0f))))) || ((bool)(!(cb0_088x == 0.0f))))) || ((bool)(!(cb0_089x == 0.0f)))) {
    float _310 = saturate(select((((_145 - _137.x) + ((((dx_alignment_legacy_View_448[3].z) - _145) + ((dx_alignment_legacy_View_448[2].z) * _136)) * select(((dx_alignment_legacy_View_448[3].w) < 1.0f), 0.0f, 1.0f))) > 0.0005000000237487257f), 1.0f, 0.0f) + select((_137.x > 0.0005000000237487257f), 0.0f, 1.0f));
    _324 = max(_310, (1.0f - saturate(max(cb0_081x, cb0_086x))));
    _325 = max(_310, (1.0f - saturate(max(cb0_081x, cb0_087x))));
    _326 = max(_310, (1.0f - saturate(max(cb0_081x, cb0_088x))));
  } else {
    _324 = 1.0f;
    _325 = 1.0f;
    _326 = 1.0f;
  }
  float _327 = TEXCOORD_2.w * 543.3099975585938f;
  float _331 = frac(sin(_327 + TEXCOORD_2.z) * 493013.0f);
  if (cb0_080x > 0.0f) {
    _354 = ((cb0_080x * (frac((sin((TEXCOORD_2.z + 33.9900016784668f) + _327) * 493013.0f) + 7.177000045776367f) - _331)) + _331);
    _355 = ((cb0_080x * (frac((sin((TEXCOORD_2.z + 66.98999786376953f) + _327) * 493013.0f) + 14.298999786376953f) - _331)) + _331);
  } else {
    _354 = _331;
    _355 = _331;
  }
  if (cb0_083z > 0.0f) {
    _377 = (((((_289 * _209) * _326) * cb0_083z) * ((sin((((TEXCOORD_3.y * 10.0f) + 10.0f) + (_331 * 0.0020000000949949026f)) + (dx_alignment_legacy_View_2376 * 4.0f)) * 0.5f) + 0.5f)) + 1.0f);
  } else {
    _377 = 1.0f;
  }
  float _380 = (_288 * _208) * _325;
  float _381 = _380 * cb0_083y;
  if (cb0_083y > 0.0f) {
    float _386 = dx_alignment_legacy_View_2376 * 0.00016666666488163173f;
    float _390 = frac(abs(_386));
    float _395 = ((TEXCOORD_3.y * 111000.0f) + 111000.0f) * select((_386 >= (-0.0f - _386)), _390, (-0.0f - _390));
    float _401 = (0.5f - frac(sin(dot(float2(_395, _395), float2(12.989800453186035f, 78.23300170898438f))) * 43758.546875f)) * 0.014999999664723873f;
    _408 = (((_381 * 0.5f) * _401) + _122);
    _409 = ((_401 * _381) + _123);
  } else {
    _408 = _122;
    _409 = _123;
  }
  float _414 = cb0_079z * (1.0f - (_331 * _331));
  float _419 = (_414 * (TEXCOORD_2.x - _408)) + _408;
  float _420 = (_414 * (TEXCOORD_2.y - _409)) + _409;
  float4 _431 = t0.Sample(s0, float2(min(max(_419, cb0_053z), cb0_054x), min(max(_420, cb0_053w), cb0_054y)));
  float _437 = saturate(cb0_082x);
  float _439 = saturate(cb0_082y);
  if (_437 > 0.0f) {
    float _450 = saturate(((_431.x * 0.29899999499320984f) + (_431.y * 0.5870000123977661f)) + (_431.z * 0.11400000005960464f));
    float _456 = ((_450 * _450) * (saturate(1.0f - cb0_082z) * 2.0f)) * (3.0f - (_450 * 2.0f));
    float _463 = max(sqrt(((_431.x * _431.x) + (_431.y * _431.y)) + (_431.z * _431.z)), 0.014999999664723873f);
    float _464 = _431.x / _463;
    float _465 = _431.y / _463;
    float _466 = _431.z / _463;
    float _476 = log2(_456);
    float _495 = ((_287 * _207) * _324) * _437;
    _506 = (((((lerp(_464, 1.0f, 0.25f)) * (((_439 * 0.17000000178813934f) + 0.029999999329447746f) + _456)) - _431.x) * _495) + _431.x);
    _507 = (((((((_439 * 0.18000000715255737f) + 0.05000000074505806f) + exp2(_476 * 0.8999999761581421f)) * (lerp(_465, 1.0f, 0.25f))) - _431.y) * _495) + _431.y);
    _508 = (((((((_439 * 0.17999999225139618f) + 0.07999999821186066f) + exp2(_476 * 0.949999988079071f)) * (lerp(_466, 1.0f, 0.25f))) - _431.z) * _495) + _431.z);
  } else {
    _506 = _431.x;
    _507 = _431.y;
    _508 = _431.z;
  }
  float _511 = saturate(cb0_083x);
  float _512 = _380 * _511;
  if (_511 > 0.0f) {
    float _523 = (sin(((_109 * 640.0f) + 640.0f) - (dx_alignment_legacy_View_2376 * 10.0f)) * 0.5f) + 1.0f;
    _537 = ((((_523 * _506) - _506) * _512) + _506);
    _538 = ((((_523 * _507) - _507) * _512) + _507);
    _539 = ((((_523 * _508) - _508) * _512) + _508);
  } else {
    _537 = _506;
    _538 = _507;
    _539 = _508;
  }

  float4 _564 = t1.Sample(s1, float2(min(max(((cb0_068z * _419) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _420) + cb0_069y), cb0_060w), cb0_061y)));
  _564.rgb *= RENODX_WUWA_BLOOM;

  float _592 = TEXCOORD_1.z + -1.0f;
  float _594 = TEXCOORD_1.w + -1.0f;
  float _597 = ((_592 + (cb0_074x * 2.0f)) * cb0_072z) * cb0_072x;
  float _599 = ((_594 + (cb0_074y * 2.0f)) * cb0_072w) * cb0_072x;
  float _606 = 1.0f / ((((saturate(cb0_073w) * 9.0f) + 1.0f) * dot(float2(_597, _599), float2(_597, _599))) + 1.0f);
  float _607 = _606 * _606;
  float _608 = cb0_074z + 1.0f;
  float _636 = ((_592 + (cb0_077x * 2.0f)) * cb0_075z) * cb0_075x;
  float _638 = ((_594 + (cb0_077y * 2.0f)) * cb0_075w) * cb0_075x;
  float _645 = 1.0f / ((((saturate(cb0_076w) * 9.0f) + 1.0f) * dot(float2(_636, _638), float2(_636, _638))) + 1.0f);
  float _646 = _645 * _645;
  float _647 = cb0_077z + 1.0f;
  float _659 = (((_564.x + ((_537 * TEXCOORD_1.x) * cb0_070x)) * _377) * ((_607 * (_608 - cb0_073x)) + cb0_073x)) * ((_646 * (_647 - cb0_076x)) + cb0_076x);
  float _662 = (((_564.y + ((_538 * TEXCOORD_1.x) * cb0_070y)) * _377) * ((_607 * (_608 - cb0_073y)) + cb0_073y)) * ((_646 * (_647 - cb0_076y)) + cb0_076y);
  float _665 = (((_564.z + ((_539 * TEXCOORD_1.x) * cb0_070z)) * _377) * ((_607 * (_608 - cb0_073z)) + cb0_073z)) * ((_646 * (_647 - cb0_076z)) + cb0_076z);

  CAPTURE_UNTONEMAPPED(untonemapped, float3(_659, _662, _665));

  [branch]
  // if (!((uint)(cb0_091z) == 0)) {
  if (!((uint)(RENODX_WUWA_TM) == 1)) {
    // _698 = saturate((((_659 * 1.3600000143051147f) + 0.04699999839067459f) * _659) / ((((_659 * 0.9599999785423279f) + 0.5600000023841858f) * _659) + 0.14000000059604645f));
    // _699 = saturate((((_662 * 1.3600000143051147f) + 0.04699999839067459f) * _662) / ((((_662 * 0.9599999785423279f) + 0.5600000023841858f) * _662) + 0.14000000059604645f));
    // _700 = saturate((((_665 * 1.3600000143051147f) + 0.04699999839067459f) * _665) / ((((_665 * 0.9599999785423279f) + 0.5600000023841858f) * _665) + 0.14000000059604645f));
    _698 = ((((_659 * 1.3600000143051147f) + 0.04699999839067459f) * _659) / ((((_659 * 0.9599999785423279f) + 0.5600000023841858f) * _659) + 0.14000000059604645f));
    _699 = ((((_662 * 1.3600000143051147f) + 0.04699999839067459f) * _662) / ((((_662 * 0.9599999785423279f) + 0.5600000023841858f) * _662) + 0.14000000059604645f));
    _700 = ((((_665 * 1.3600000143051147f) + 0.04699999839067459f) * _665) / ((((_665 * 0.9599999785423279f) + 0.5600000023841858f) * _665) + 0.14000000059604645f));
  } else {
    _698 = _659;
    _699 = _662;
    _700 = _665;
  }
  [branch]
  // if (!((uint)(cb0_091w) == 0)) {
  if (!((uint)(RENODX_WUWA_TM) == 2)) {
    float _710 = 1.0049500465393066f - (0.16398000717163086f / (_698 + -0.19505000114440918f));
    float _711 = 1.0049500465393066f - (0.16398000717163086f / (_699 + -0.19505000114440918f));
    float _712 = 1.0049500465393066f - (0.16398000717163086f / (_700 + -0.19505000114440918f));
    // _732 = saturate(((_698 - _710) * select((_698 > 0.6000000238418579f), 0.0f, 1.0f)) + _710);
    // _733 = saturate(((_699 - _711) * select((_699 > 0.6000000238418579f), 0.0f, 1.0f)) + _711);
    // _734 = saturate(((_700 - _712) * select((_700 > 0.6000000238418579f), 0.0f, 1.0f)) + _712);
    _732 = (((_698 - _710) * select((_698 > 0.6000000238418579f), 0.0f, 1.0f)) + _710);
    _733 = (((_699 - _711) * select((_699 > 0.6000000238418579f), 0.0f, 1.0f)) + _711);
    _734 = (((_700 - _712) * select((_700 > 0.6000000238418579f), 0.0f, 1.0f)) + _712);
  } else {
    _732 = _698;
    _733 = _699;
    _734 = _700;
  }
  [branch]
  // if (!((uint)(cb0_092x) == 0)) {
  if (!((uint)(RENODX_WUWA_TM) == 3)) {
    float _741 = cb0_037y * _732;
    float _742 = cb0_037y * _733;
    float _743 = cb0_037y * _734;
    float _746 = cb0_037z * cb0_037w;
    float _756 = cb0_038y * cb0_038x;
    float _767 = cb0_038z * cb0_038x;
    float _774 = cb0_038y / cb0_038z;
    // _782 = saturate(((((_746 + _741) * _732) + _756) / (_767 + ((_741 + cb0_037z) * _732))) - _774);
    // _783 = saturate(((((_746 + _742) * _733) + _756) / (_767 + ((_742 + cb0_037z) * _733))) - _774);
    // _784 = saturate(((((_746 + _743) * _734) + _756) / (_767 + ((_743 + cb0_037z) * _734))) - _774);
    _782 = (((((_746 + _741) * _732) + _756) / (_767 + ((_741 + cb0_037z) * _732))) - _774);
    _783 = (((((_746 + _742) * _733) + _756) / (_767 + ((_742 + cb0_037z) * _733))) - _774);
    _784 = (((((_746 + _743) * _734) + _756) / (_767 + ((_743 + cb0_037z) * _734))) - _774);
  } else {
    _782 = _732;
    _783 = _733;
    _784 = _734;
  }
  [branch]
  if (!((uint)(cb0_089w) == 0)) {
    if (!((bool)(cb0_090x <= 0.0f) && (bool)(cb0_090y <= 0.0f))) {
      float _796 = dot(float3(_782, _783, _784), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      if (!(_796 <= 9.999999747378752e-05f)) {
        float _805 = (pow(_782, 0.1593017578125f));
        float _806 = (pow(_783, 0.1593017578125f));
        float _807 = (pow(_784, 0.1593017578125f));
        float _829 = exp2(log2(((_805 * 18.8515625f) + 0.8359375f) / ((_805 * 18.6875f) + 1.0f)) * 78.84375f);
        float _830 = exp2(log2(((_806 * 18.8515625f) + 0.8359375f) / ((_806 * 18.6875f) + 1.0f)) * 78.84375f);
        float _831 = exp2(log2(((_807 * 18.8515625f) + 0.8359375f) / ((_807 * 18.6875f) + 1.0f)) * 78.84375f);
        if ((bool)(cb0_090y > 0.0f) && (bool)((_796 / cb0_090y) > 1.0f)) {
          float _840 = (pow(cb0_090y, 0.1593017578125f));
          float _848 = exp2(log2(((_840 * 18.8515625f) + 0.8359375f) / ((_840 * 18.6875f) + 1.0f)) * 78.84375f);
          if (_829 > _848) {
            float _851 = _829 - _848;
            _857 = ((_851 / ((_851 * cb0_090z) + 1.0f)) + _848);
          } else {
            _857 = _829;
          }
          if (_830 > _848) {
            float _1058 = _830 - _848;
            _1064 = ((_1058 / ((_1058 * cb0_090z) + 1.0f)) + _848);
            if (_831 > _848) {
              float _1067 = _831 - _848;
              _860 = ((_1067 / ((_1067 * cb0_090z) + 1.0f)) + _848);
              _861 = _1064;
              _862 = _857;
            } else {
              _860 = _831;
              _861 = _1064;
              _862 = _857;
            }
          } else {
            _1064 = _830;
            if (_831 > _848) {
              float _1067 = _831 - _848;
              _860 = ((_1067 / ((_1067 * cb0_090z) + 1.0f)) + _848);
              _861 = _1064;
              _862 = _857;
            } else {
              _860 = _831;
              _861 = _1064;
              _862 = _857;
            }
          }
          while(true) {
            if (cb0_090x > 0.0f) {
              if (_796 < cb0_090x) {
                float _870 = (pow(cb0_090x, 0.1593017578125f));
                float _878 = exp2(log2(((_870 * 18.8515625f) + 0.8359375f) / ((_870 * 18.6875f) + 1.0f)) * 78.84375f);
                if (_862 < _878) {
                  _886 = (((cb0_090z * 0.30000001192092896f) * (_878 - _862)) + _862);
                } else {
                  _886 = _862;
                }
                if (_861 < _878) {
                  _1050 = (((cb0_090z * 0.30000001192092896f) * (_878 - _861)) + _861);
                  if (_860 < _878) {
                    _889 = (((cb0_090z * 0.30000001192092896f) * (_878 - _860)) + _860);
                    _890 = _1050;
                    _891 = _886;
                  } else {
                    _889 = _860;
                    _890 = _1050;
                    _891 = _886;
                  }
                } else {
                  _1050 = _861;
                  if (_860 < _878) {
                    _889 = (((cb0_090z * 0.30000001192092896f) * (_878 - _860)) + _860);
                    _890 = _1050;
                    _891 = _886;
                  } else {
                    _889 = _860;
                    _890 = _1050;
                    _891 = _886;
                  }
                }
              } else {
                _889 = _860;
                _890 = _861;
                _891 = _862;
              }
            } else {
              _889 = _860;
              _890 = _861;
              _891 = _862;
            }
            while(true) {
              float _898 = (pow(_891, 0.012683313339948654f));
              float _899 = (pow(_890, 0.012683313339948654f));
              float _900 = (pow(_889, 0.012683313339948654f));
              _926 = exp2(log2(max((_898 + -0.8359375f), 0.0f) / (18.8515625f - (_898 * 18.6875f))) * 6.277394771575928f);
              _927 = exp2(log2(max((_899 + -0.8359375f), 0.0f) / (18.8515625f - (_899 * 18.6875f))) * 6.277394771575928f);
              _928 = exp2(log2(max((_900 + -0.8359375f), 0.0f) / (18.8515625f - (_900 * 18.6875f))) * 6.277394771575928f);
              break;
            }
            break;
          }
        } else {
          _860 = _831;
          _861 = _830;
          _862 = _829;
          while(true) {
            if (cb0_090x > 0.0f) {
              if (_796 < cb0_090x) {
                float _870 = (pow(cb0_090x, 0.1593017578125f));
                float _878 = exp2(log2(((_870 * 18.8515625f) + 0.8359375f) / ((_870 * 18.6875f) + 1.0f)) * 78.84375f);
                if (_862 < _878) {
                  _886 = (((cb0_090z * 0.30000001192092896f) * (_878 - _862)) + _862);
                } else {
                  _886 = _862;
                }
                if (_861 < _878) {
                  _1050 = (((cb0_090z * 0.30000001192092896f) * (_878 - _861)) + _861);
                  if (_860 < _878) {
                    _889 = (((cb0_090z * 0.30000001192092896f) * (_878 - _860)) + _860);
                    _890 = _1050;
                    _891 = _886;
                  } else {
                    _889 = _860;
                    _890 = _1050;
                    _891 = _886;
                  }
                } else {
                  _1050 = _861;
                  if (_860 < _878) {
                    _889 = (((cb0_090z * 0.30000001192092896f) * (_878 - _860)) + _860);
                    _890 = _1050;
                    _891 = _886;
                  } else {
                    _889 = _860;
                    _890 = _1050;
                    _891 = _886;
                  }
                }
              } else {
                _889 = _860;
                _890 = _861;
                _891 = _862;
              }
            } else {
              _889 = _860;
              _890 = _861;
              _891 = _862;
            }
            while(true) {
              float _898 = (pow(_891, 0.012683313339948654f));
              float _899 = (pow(_890, 0.012683313339948654f));
              float _900 = (pow(_889, 0.012683313339948654f));
              _926 = exp2(log2(max((_898 + -0.8359375f), 0.0f) / (18.8515625f - (_898 * 18.6875f))) * 6.277394771575928f);
              _927 = exp2(log2(max((_899 + -0.8359375f), 0.0f) / (18.8515625f - (_899 * 18.6875f))) * 6.277394771575928f);
              _928 = exp2(log2(max((_900 + -0.8359375f), 0.0f) / (18.8515625f - (_900 * 18.6875f))) * 6.277394771575928f);
              break;
            }
            break;
          }
        }
      } else {
        _926 = _782;
        _927 = _783;
        _928 = _784;
      }
    } else {
      _926 = _782;
      _927 = _783;
      _928 = _784;
    }
  } else {
    _926 = _782;
    _927 = _783;
    _928 = _784;
  }

  CLAMP_IF_SDR(_926); CLAMP_IF_SDR(_927); CLAMP_IF_SDR(_928);
  CAPTURE_TONEMAPPED(tonemapped, float3(_926, _927, _928));

  float4 _950 = t4.Sample(s4, float3(((saturate((log2(_926 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_927 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f), ((saturate((log2(_928 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f)));
  _950.rgb = HandleLUTOutput(_950.rgb, untonemapped, tonemapped);

  float _954 = _950.x * 1.0499999523162842f;
  float _955 = _950.y * 1.0499999523162842f;
  float _956 = _950.z * 1.0499999523162842f;
  float _964 = ((_331 * 0.00390625f) + -0.001953125f) + _954;
  float _965 = ((_354 * 0.00390625f) + -0.001953125f) + _955;
  float _966 = ((_355 * 0.00390625f) + -0.001953125f) + _956;
  [branch]
  if (!((uint)(cb0_091y) == 0)) {
    float _978 = (pow(_964, 0.012683313339948654f));
    float _979 = (pow(_965, 0.012683313339948654f));
    float _980 = (pow(_966, 0.012683313339948654f));
    float _1013 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_978 + -0.8359375f)) / (18.8515625f - (_978 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_091x));
    float _1014 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_979 + -0.8359375f)) / (18.8515625f - (_979 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_091x));
    float _1015 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_980 + -0.8359375f)) / (18.8515625f - (_980 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_091x));
    _1041 = min((_1013 * 12.920000076293945f), ((exp2(log2(max(_1013, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _1042 = min((_1014 * 12.920000076293945f), ((exp2(log2(max(_1014, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _1043 = min((_1015 * 12.920000076293945f), ((exp2(log2(max(_1015, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _1041 = _964;
    _1042 = _965;
    _1043 = _966;
  }
  SV_Target.x = _1041;
  SV_Target.y = _1042;
  SV_Target.z = _1043;

  // SV_Target.w = saturate(dot(float3(_954, _955, _956), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  SV_Target.w = (dot(float3(_954, _955, _956), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f)));
  CLAMP_IF_SDR(SV_Target.w);

  return SV_Target;
}
