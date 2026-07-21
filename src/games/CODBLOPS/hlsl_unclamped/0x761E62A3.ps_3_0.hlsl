// Mechanically reconstructed from 0x761E62A3.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);
sampler2D s4 : register(s4);
sampler2D s5 : register(s5);

struct PS_INPUT
{
    float4 v0 : TEXCOORD1;
    float4 v1 : TEXCOORD2;
    float4 v2 : TEXCOORD3;
    float4 v3 : TEXCOORD4;
    float4 v4 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(0.0f, 0.25f, -1.0f, 1.0f);
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c2 = float4(0.5f, 2.0f, -1.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = (v0.xyzx) * (c0.wwwx) + (c0.xxxw);
    r1.x = dot(r0, c[23]);
    r1.x = 1.0f / (r1.x);
    r1.y = dot(r0, c[20]);
    r1.z = dot(r0, c[21]);
    r0.z = dot(r0, c[22]);
    r1 = (r1.xxxx) * (r1.yyzz);
    r2 = (r1) * (c[24].zwxy);
    r3.x = log2(abs(r2.x));
    r3.y = log2(abs(r2.y));
    r3.z = log2(abs(r2.z));
    r3.w = log2(abs(r2.w));
    r2 = (r3) * (c[25].xxxx);
    r1.x = exp2(r2.x);
    r1.z = exp2(r2.y);
    r2.x = exp2(r2.z);
    r2.y = exp2(r2.w);
    r1.xz = (r1.xz) + (r2.xy);
    r2.x = log2(abs(r1.x));
    r2.y = log2(abs(r1.z));
    r1.xz = (r2.xy) * (c[25].yy);
    r1.x = exp2(r1.x);
    r1.z = exp2(r1.z);
    r1.x = (r1.x) * (c[26].x);
    r1.x = (r1.z) * (c[26].y) + (-(r1.x));
    r2.y = c[26].y;
    r1.z = (r1.z) * (r2.y) + (-(c[25].z));
    r1.x = 1.0f / (r1.x);
    r2.w = saturate((r1.z) * (r1.x));
    r0.xy = abs(r1.yw);
    r3 = c[10];
    r3 = saturate((r0.zyxz) * (r3) + (c[11]));
    r2.x = (r3.w) * (r3.x);
    r2.yz = r3.yz;
    r3 = (r2) * (r2);
    r2 = (c[26].zzzz) * (r2) + (c[26].wwww);
    r2 = (r3) * (r2);
    r0.x = (r2.z) * (r2.y);
    r0.y = abs(c[25].w);
    r0.x = ((-(r0.y)) >= 0.0f ? (r0.x) : (r2.w));
    r0.w = (r0.z) * (r0.z);
    r0.y = dot(c[9].yz, r0.zw) + (c[9].x);
    r0.x = (r0.x) * (r0.y);
    r0.x = (r2.x) * (r0.x);
    r2.xzw = c[8].xzw;
    r0.y = dot(r1.yw, c[27].xy) + (r2.x);
    r0.z = dot(r1.yw, c[27].zw) + (r2.z);
    r1 = tex2D(s2, r0.yz);
    r0.y = (r1.x) * (r1.x);
    r0.x = (r0.x) * (r0.y);
    r1.xy = (c[28].xy) * (v4.ww);
    r1.zw = c0.xx;
    r3 = (r1.xyww) + (v4);
    r1 = (-(r1)) + (v4);
    r1 = tex2Dproj(s1, r1);
    r1.y = r1.x;
    r3 = tex2Dproj(s1, r3);
    r1.x = r3.x;
    r3.xy = (c[28].zw) * (v4.ww);
    r3.zw = c0.xx;
    r4 = (r3.xyww) + (v4);
    r3 = (-(r3)) + (v4);
    r3 = tex2Dproj(s1, r3);
    r1.w = r3.x;
    r3 = tex2Dproj(s1, r4);
    r1.z = r3.x;
    r0.y = dot(r1, c0.yyyy);
    r0.y = (r0.y) + (c0.z);
    r0.y = (r2.w) * (r0.y) + (c0.w);
    r0.x = (r0.x) * (r0.y);
    r0.y = dot(v1.xyz, v1.xyz);
    r0.y = rsqrt(r0.y);
    r1.xyz = (r0.yyy) * (v1.xyz);
    r2.xyz = (r1.zxy) * (v2.yzx);
    r1.xyz = (r1.yzx) * (v2.zxy) + (-(r2.xyz));
    r1.xyz = (r1.xyz) * (v2.www);
    r0.z = (c[29].w) + (v3.x);
    r0.w = v3.y;
    r2.xy = frac(abs(r0.zw));
    r0.zw = float2(((r0.z) >= 0.0f ? (r2.x) : (-(r2.x))), ((r0.w) >= 0.0f ? (r2.y) : (-(r2.y))));
    r2 = tex2D(s3, r0.zw);
    r2.xy = (r2.wy) * (c1.xy) + (c1.zw);
    r2.xy = (r2.xy) * (c2.xx) + (c2.xx);
    r2.xy = (r2.xy) * (c2.yy) + (c2.zz);
    r2.xy = (r2.xy) + (r2.xy);
    r1.xyz = (r1.xyz) * (r2.yyy);
    r1.xyz = (r2.xxx) * (v2.xyz) + (r1.xyz);
    r1.xyz = (v1.xyz) * (r0.yyy) + (r1.xyz);
    r2.xyz = normalize(r1.xyz);
    r1.xyz = (c0.www) + (-(v0.xyz));
    r3.xyz = normalize(r1.xyz);
    r0.y = dot(-(r3.xyz), r2.xyz);
    r0.y = (r0.y) + (r0.y);
    r1.xyz = (r2.xyz) * (-(r0.yyy)) + (-(r3.xyz));
    r0.y = saturate(dot(r2.xyz, r3.xyz));
    r2.xyz = normalize(v0.xyz);
    r1.x = saturate(dot(r1.xyz, -(r2.xyz)));
    r1.y = dot(r3.xyz, r2.xyz);
    r1.y = saturate((r1.y) * (c2.x) + (c2.x));
    r2.y = c2.y;
    r3.x = lerp(c[32].x, r2.y, r1.y);
    r1.y = (r1.y) + (c0.w);
    r2.x = pow(abs(r1.x), r3.x);
    r3.xy = c[7].xy;
    r1.xzw = (r3.yyy) * (c[6].xyz);
    r1.xzw = (r2.xxx) * (r1.xzw);
    r1.xyz = (r1.yyy) * (r1.xzw);
    r1.xyz = (r1.xyz) * (c[31].xxx);
    r2 = tex2D(s4, r0.zw);
    r4 = tex2D(s5, r0.zw);
    r3.yzw = (r4.xyz) * (r4.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r1.xyz = (r1.xyz) * (r2.xyz);
    r2.xyz = (r3.xxx) * (c[5].xyz);
    r0.yzw = (r0.yyy) * (r2.xyz);
    r0.yzw = (r0.yzw) * (r3.yzw) + (r1.xyz);
    r1.xyz = max(r0.yzw, c0.xxx);
    r0.xyz = (r0.xxx) * (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[30].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = c0.w;

    return oC0;
}
