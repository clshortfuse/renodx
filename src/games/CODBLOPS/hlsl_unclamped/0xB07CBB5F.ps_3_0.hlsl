// Mechanically reconstructed from 0xB07CBB5F.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler3D s11 : register(s11);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD5;
    float4 v5 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(1.0f, 0.0f, 31.875f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 oC0 = 0.0f;

    r1 = (v4.xyzx) * (c0.xxxy) + (c0.yyyx);
    r0.w = dot(r1, c[24]);
    r0.w = 1.0f / (r0.w);
    r0.x = dot(r1, c[21]);
    r0.y = dot(r1, c[22]);
    r0 = (r0.wwww) * (r0.xxyy);
    r2 = (r0) * (c[25].zwxy);
    r2.x = log2(abs(r2.x));
    r2.y = log2(abs(r2.y));
    r2.z = log2(abs(r2.z));
    r2.w = log2(abs(r2.w));
    r2 = (r2) * (c[26].xxxx);
    r2.x = exp2(r2.x);
    r2.y = exp2(r2.y);
    r2.z = exp2(r2.z);
    r2.w = exp2(r2.w);
    r2.xy = (r2.zw) + (r2.xy);
    r2.x = log2(abs(r2.x));
    r2.y = log2(abs(r2.y));
    r2.xy = (r2.xy) * (c[26].yy);
    r2.x = exp2(r2.x);
    r2.y = exp2(r2.y);
    r2.z = dot(r1, c[23]);
    r0.z = (r2.x) * (c[27].x);
    r0.y = (r2.y) * (c[27].y) + (-(r0.z));
    r0.z = c[27].y;
    r0.z = (r2.y) * (r0.z) + (-(c[26].z));
    r0.y = 1.0f / (r0.y);
    r2.xy = abs(r0.xw);
    r3.w = saturate((r0.z) * (r0.y));
    r1 = c[11];
    r1 = saturate((r2.zyxz) * (r1) + (c[20]));
    r3.x = (r1.w) * (r1.x);
    r3.yz = r1.yz;
    r1 = (r3) * (r3);
    r3 = (c[27].zzzz) * (r3) + (c[27].wwww);
    r1 = (r1) * (r3);
    r0.y = (r1.z) * (r1.y);
    r0.z = abs(c[26].w);
    r2.w = (r2.z) * (r2.z);
    r0.y = ((-(r0.z)) >= 0.0f ? (r0.y) : (r1.w));
    r0.z = dot(c[10].yz, r2.zw) + (c[10].x);
    r0.z = (r0.y) * (r0.z);
    r2.w = (r1.x) * (r0.z);
    r1 = c[28];
    r1.x = dot(r0.xw, r1.xy) + (c[9].x);
    r1.y = dot(r0.xw, r1.zw) + (c[9].z);
    r0 = tex2D(s1, r1.xy);
    r3.xyz = normalize(v2.xyz);
    r1.w = max(abs(r3.y), abs(r3.z));
    r1.xyz = (r0.xyz) * (r0.xyz);
    r0.w = max(abs(r3.x), r1.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r3.xyz) * (c[5].xyz);
    r1.xyz = (r2.www) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (v5.xyz);
    r0 = tex3D(s11, r0.xyz);
    r1.xyz = (r1.xyz) * (r0.www);
    r4.xyz = (-(v4.xyz)) + (c[6].xyz);
    r2.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = normalize(r4.xyz);
    r0.w = saturate(dot(r0.xyz, r3.xyz));
    r0.xyz = c[7].xyz;
    r0.xyz = (r0.xyz) * (c[8].xxx);
    r3.xyz = (r2.xyz) * (c0.zzz);
    r2.xyz = (r0.www) * (r0.xyz);
    r0 = tex2D(s0, v1.xy);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r1.xyz = (r1.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r1.xyz) * (r0.xyz);
    r0.w = c0.x;
    r1.x = dot(r0, c[30]);
    r1.y = dot(r0, c[31]);
    r1.z = dot(r0, c[32]);
    r0.xyz = (r1.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[29].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.x;

    return oC0;
}
