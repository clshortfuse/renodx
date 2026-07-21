// Mechanically reconstructed from 0x2A5ADF83.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);

struct PS_INPUT
{
    float4 v0 : TEXCOORD1;
    float4 v1 : TEXCOORD2;
    float4 v2 : TEXCOORD4;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    const float4 c0 = float4(6.0f, 13.0f, 8.0f, 12.0f);
    const float4 c1 = float4(1.0f, 0.0f, 0.75f, 0.5f);
    const float4 c2 = float4(-28.0f, 30.0f, 9.99999997e-07f, 0.136841998f);
    const float4 c3 = float4(0.38647899f, 0.392856985f, 0.364796013f, 10.0f);
    const float4 c4 = float4(9.0f, 15.0f, 4.0f, 11.0f);
    const float4 c12 = float4(9.99999994e-09f, 0.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = c[7].xy;
    r0.yzw = (r0.yyy) * (c[6].xyz);
    r1.xyz = (c1.xxx) + (-(v0.xyz));
    r2.xyz = normalize(r1.xyz);
    r1.xyz = normalize(v1.xyz);
    r1.w = dot(-(r2.xyz), r1.xyz);
    r1.w = (r1.w) + (r1.w);
    r3.xyz = (r1.xyz) * (-(r1.www)) + (-(r2.xyz));
    r4.xyz = normalize(v0.xyz);
    r1.w = saturate(dot(r3.xyz, -(r4.xyz)));
    r2.w = dot(r2.xyz, r4.xyz);
    r2.x = saturate(dot(r1.xyz, r2.xyz));
    r2.y = saturate((r2.w) * (c1.w) + (c1.w));
    r2.z = (r2.y) * (c2.x) + (c2.y);
    r2.y = (r2.y) + (c1.x);
    r3.x = pow(abs(r1.w), r2.z);
    r0.yzw = (r0.yzw) * (r3.xxx);
    r0.yzw = (r2.yyy) * (r0.yzw);
    r2.yzw = (r0.xxx) * (c[5].xyz);
    r2.xyz = (r2.xxx) * (r2.yzw);
    r3.x = log2(abs(r2.x));
    r3.y = log2(abs(r2.y));
    r3.z = log2(abs(r2.z));
    r3.xyz = (r3.xyz) * (c1.zzz);
    r5.x = exp2(r3.x);
    r5.y = exp2(r3.y);
    r5.z = exp2(r3.z);
    r0.x = c[32].x;
    r3 = (-(r0.xxxx)) + (c0);
    r2.xyz = float3(((-abs(r3.x)) >= 0.0f ? (r2.x) : (c1.y)), ((-abs(r3.x)) >= 0.0f ? (r2.y) : (c1.y)), ((-abs(r3.x)) >= 0.0f ? (r2.z) : (c1.y)));
    r2.xyz = float3(((-abs(r3.y)) >= 0.0f ? (r5.x) : (r2.x)), ((-abs(r3.y)) >= 0.0f ? (r5.y) : (r2.y)), ((-abs(r3.y)) >= 0.0f ? (r5.z) : (r2.z)));
    r2.xyz = float3(((-abs(r3.z)) >= 0.0f ? (r5.x) : (r2.x)), ((-abs(r3.z)) >= 0.0f ? (r5.y) : (r2.y)), ((-abs(r3.z)) >= 0.0f ? (r5.z) : (r2.z)));
    r2.xyz = float3(((-abs(r3.w)) >= 0.0f ? (r0.y) : (r2.x)), ((-abs(r3.w)) >= 0.0f ? (r0.z) : (r2.y)), ((-abs(r3.w)) >= 0.0f ? (r0.w) : (r2.z)));
    r3.xyz = (r0.yzw) * (c3.xyz);
    r6 = (-(r0.xxxx)) + (c4);
    r2.xyz = float3(((-abs(r6.x)) >= 0.0f ? (r3.x) : (r2.x)), ((-abs(r6.x)) >= 0.0f ? (r3.y) : (r2.y)), ((-abs(r6.x)) >= 0.0f ? (r3.z) : (r2.z)));
    r1.y = dot(r4.xyz, r1.xyz);
    r1.y = (r1.y) + (r1.y);
    r1.x = (r1.x) * (-(r1.y)) + (r4.x);
    r1.x = (r1.x) * (c2.z);
    r1.yzw = float3(((-abs(r6.y)) >= 0.0f ? (r1.x) : (r2.x)), ((-abs(r6.y)) >= 0.0f ? (r1.x) : (r2.y)), ((-abs(r6.y)) >= 0.0f ? (r1.x) : (r2.z)));
    r1.x = (r1.x) * (c[34].x);
    r1.yzw = float3(((-abs(r6.z)) >= 0.0f ? (r1.x) : (r1.y)), ((-abs(r6.z)) >= 0.0f ? (r1.x) : (r1.z)), ((-abs(r6.z)) >= 0.0f ? (r1.x) : (r1.w)));
    r0.yzw = (r0.yzw) * (c3.xyz) + (r1.xxx);
    r1.xyz = float3(((-abs(r6.w)) >= 0.0f ? (r0.y) : (r1.y)), ((-abs(r6.w)) >= 0.0f ? (r0.z) : (r1.z)), ((-abs(r6.w)) >= 0.0f ? (r0.w) : (r1.w)));
    r0.yzw = (r0.yzw) * (c2.www);
    r2.xy = (v2.xy) * (c[33].xy) + (c[33].zw);
    r2 = tex2D(s2, r2.xy);
    r0.yzw = (r5.xyz) * (r2.xyz) + (r0.yzw);
    r2.xyz = max(r0.yzw, c1.yyy);
    r0.x = (-(r0.x)) + (c3.w);
    r0.xyz = float3(((-abs(r0.x)) >= 0.0f ? (r2.x) : (r1.x)), ((-abs(r0.x)) >= 0.0f ? (r2.y) : (r1.y)), ((-abs(r0.x)) >= 0.0f ? (r2.z) : (r1.z)));
    r0.w = abs(c[32].x);
    r0.xyz = float3(((-(r0.w)) >= 0.0f ? (r2.x) : (r0.x)), ((-(r0.w)) >= 0.0f ? (r2.y) : (r0.y)), ((-(r0.w)) >= 0.0f ? (r2.z) : (r0.z)));
    r0.xyz = (r2.xyz) * (c12.xxx) + (r0.xyz);
    r0.xyz = float3(((c[32].x) >= 0.0f ? (r0.x) : (r2.x)), ((c[32].x) >= 0.0f ? (r0.y) : (r2.y)), ((c[32].x) >= 0.0f ? (r0.z) : (r2.z)));
    r1 = (v0.xyzx) * (c1.xxxy) + (c1.yyyx);
    r0.w = dot(r1, c[23]);
    r0.w = 1.0f / (r0.w);
    r2.x = dot(r1, c[20]);
    r2.y = dot(r1, c[21]);
    r1.z = dot(r1, c[22]);
    r2 = (r0.wwww) * (r2.xxyy);
    r3 = (r2) * (c[24].zwxy);
    r4.x = log2(abs(r3.x));
    r4.y = log2(abs(r3.y));
    r4.z = log2(abs(r3.z));
    r4.w = log2(abs(r3.w));
    r3 = (r4) * (c[25].xxxx);
    r2.x = exp2(r3.x);
    r2.z = exp2(r3.y);
    r3.x = exp2(r3.z);
    r3.y = exp2(r3.w);
    r2.xz = (r2.xz) + (r3.xy);
    r3.x = log2(abs(r2.x));
    r3.y = log2(abs(r2.z));
    r2.xz = (r3.xy) * (c[25].yy);
    r0.w = exp2(r2.x);
    r2.x = exp2(r2.z);
    r0.w = (r0.w) * (c[26].x);
    r0.w = (r2.x) * (c[26].y) + (-(r0.w));
    r3.y = c[26].y;
    r2.x = (r2.x) * (r3.y) + (-(c[25].z));
    r0.w = 1.0f / (r0.w);
    r3.w = saturate((r2.x) * (r0.w));
    r1.xy = abs(r2.yw);
    r4 = c[10];
    r4 = saturate((r1.zyxz) * (r4) + (c[11]));
    r3.x = (r4.w) * (r4.x);
    r3.yz = r4.yz;
    r4 = (r3) * (r3);
    r3 = (c[26].zzzz) * (r3) + (c[26].wwww);
    r3 = (r4) * (r3);
    r0.w = (r3.z) * (r3.y);
    r1.x = abs(c[25].w);
    r0.w = ((-(r1.x)) >= 0.0f ? (r0.w) : (r3.w));
    r1.w = (r1.z) * (r1.z);
    r1.x = dot(c[9].yz, r1.zw) + (c[9].x);
    r0.w = (r0.w) * (r1.x);
    r0.w = (r3.x) * (r0.w);
    r1 = c[27];
    r1.x = dot(r2.yw, r1.xy) + (c[8].x);
    r1.y = dot(r2.yw, r1.zw) + (c[8].z);
    r1 = tex2D(s1, r1.xy);
    r1.x = (r1.x) * (r1.x);
    r0.w = (r0.w) * (r1.x);
    r0.xyz = (r0.xyz) * (r0.www);
    r0.w = c1.x;
    r1.x = dot(r0, c[29]);
    r1.y = dot(r0, c[30]);
    r1.z = dot(r0, c[31]);
    r0.xyz = max(((r1.xyz) * (c[28].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = c1.x;

    return oC0;
}
