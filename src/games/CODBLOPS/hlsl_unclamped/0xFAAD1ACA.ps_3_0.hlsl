// Mechanically reconstructed from 0xFAAD1ACA.ps_3_0.cso.
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
sampler2D s6 : register(s6);
sampler2D s7 : register(s7);

struct PS_INPUT
{
    float4 v0 : TEXCOORD1;
    float4 v1 : TEXCOORD2;
    float4 v2 : TEXCOORD3;
    float4 v3 : TEXCOORD4;
    float4 v4 : TEXCOORD7;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(2.0f, -1.0f, 0.142857f, 2.00000002e-07f);
    const float4 c1 = float4(1.0f, 0.0f, 7.0f, 0.5f);
    const float4 c2 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 oC0 = 0.0f;

    r0.x = dot(v1.xyz, v1.xyz);
    r0.x = rsqrt(r0.x);
    r0.yzw = (r0.xxx) * (v1.xyz);
    r1.xyz = (r0.wyz) * (v2.yzx);
    r0.yzw = (r0.zwy) * (v2.zxy) + (-(r1.xyz));
    r0.yzw = (r0.yzw) * (v2.www);
    r1 = tex2D(s3, v3.xy);
    r1.xy = (r1.wy) * (c2.xy) + (c2.zw);
    r1.xy = (r1.xy) * (c1.ww) + (c1.ww);
    r1.xy = (r1.xy) * (c0.xx) + (c0.yy);
    r0.yzw = (r0.yzw) * (r1.yyy);
    r0.yzw = (r1.xxx) * (v2.xyz) + (r0.yzw);
    r0.xyz = (v1.xyz) * (r0.xxx) + (r0.yzw);
    r1.xyz = normalize(r0.xyz);
    r0.xyz = normalize(v0.xyz);
    r0.y = dot(r0.xyz, r1.xyz);
    r0.y = (r0.y) + (r0.y);
    r0.x = (r1.x) * (-(r0.y)) + (r0.x);
    r0.x = (r0.x) * (c0.w);
    r2 = tex2D(s4, v3.xy);
    r0.yzw = (r2.xyz) * (r2.xyz);
    r0.xyz = (r0.xxx) * (r0.yzw);
    r2.xyz = (c1.xxx) + (-(v0.xyz));
    r3.xyz = normalize(r2.xyz);
    r0.w = saturate(dot(r1.xyz, r3.xyz));
    r1.xyz = c[5].xyz;
    r1.xyz = (r1.xyz) * (c[6].xxx);
    r1.xyz = (r0.www) * (r1.xyz);
    r1.xyz = (r1.xyz) * (c0.zzz);
    r2 = tex2D(s5, v3.xy);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r1.xyz) * (r2.xyz) + (r0.xyz);
    r1.xyz = max(r0.xyz, c1.yyy);
    r0.w = c[27].w;
    r0.xy = (r0.ww) * (c[33].xy);
    r0.xy = (r0.xy) * (c[32].xx);
    r0.xy = (v3.xy) * (c[32].xx) + (r0.xy);
    r2 = tex2D(s7, r0.xy);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (v4.xxx);
    r0.xyz = (r0.xyz) * (c1.zzz);
    r2.xy = (r0.ww) * (c[34].xy);
    r2.xy = (r2.xy) * (c[35].xx);
    r2.xy = (v3.xy) * (c[35].xx) + (r2.xy);
    r2 = tex2D(s6, r2.xy);
    r1.xyz = (r0.xyz) * (-(r2.xyz)) + (r1.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz);
    r2 = tex2D(s2, v3.xy);
    r0.w = (-(r2.x)) + (c1.x);
    r0.xyz = (r0.www) * (r1.xyz) + (r0.xyz);
    r1 = (v0.xyzx) * (c1.xxxy) + (c1.yyyx);
    r0.w = dot(r1, c[22]);
    r0.w = 1.0f / (r0.w);
    r2.x = dot(r1, c[11]);
    r2.y = dot(r1, c[20]);
    r1.z = dot(r1, c[21]);
    r2 = (r0.wwww) * (r2.xxyy);
    r3 = (r2) * (c[23].zwxy);
    r4.x = log2(abs(r3.x));
    r4.y = log2(abs(r3.y));
    r4.z = log2(abs(r3.z));
    r4.w = log2(abs(r3.w));
    r3 = (r4) * (c[24].xxxx);
    r2.x = exp2(r3.x);
    r2.z = exp2(r3.y);
    r3.x = exp2(r3.z);
    r3.y = exp2(r3.w);
    r2.xz = (r2.xz) + (r3.xy);
    r3.x = log2(abs(r2.x));
    r3.y = log2(abs(r2.z));
    r2.xz = (r3.xy) * (c[24].yy);
    r0.w = exp2(r2.x);
    r2.x = exp2(r2.z);
    r0.w = (r0.w) * (c[25].x);
    r0.w = (r2.x) * (c[25].y) + (-(r0.w));
    r3.y = c[25].y;
    r2.x = (r2.x) * (r3.y) + (-(c[24].z));
    r0.w = 1.0f / (r0.w);
    r3.w = saturate((r2.x) * (r0.w));
    r1.xy = abs(r2.yw);
    r4 = c[9];
    r4 = saturate((r1.zyxz) * (r4) + (c[10]));
    r3.x = (r4.w) * (r4.x);
    r3.yz = r4.yz;
    r4 = (r3) * (r3);
    r3 = (c[25].zzzz) * (r3) + (c[25].wwww);
    r3 = (r4) * (r3);
    r0.w = (r3.z) * (r3.y);
    r1.x = abs(c[24].w);
    r0.w = ((-(r1.x)) >= 0.0f ? (r0.w) : (r3.w));
    r1.w = (r1.z) * (r1.z);
    r1.x = dot(c[8].yz, r1.zw) + (c[8].x);
    r0.w = (r0.w) * (r1.x);
    r0.w = (r3.x) * (r0.w);
    r1 = c[26];
    r1.x = dot(r2.yw, r1.xy) + (c[7].x);
    r1.y = dot(r2.yw, r1.zw) + (c[7].z);
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
