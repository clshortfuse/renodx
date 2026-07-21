// Mechanically reconstructed from 0x574CE58C.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);

struct PS_INPUT
{
    float4 v0 : TEXCOORD2;
    float4 v1 : TEXCOORD4;
    float4 v2 : TEXCOORD5;
    float4 v3 : TEXCOORD6;
    float4 v4 : TEXCOORD7;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(0.5f, 0.449999988f, 0.330000013f, 0.0900000036f);
    const float4 c2 = float4(1.0f, 0.0f, 9.99999975e-05f, 0.100000001f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 oC0 = 0.0f;

    r1 = (v1.xyzx) * (c2.xxxy) + (c2.yyyx);
    r0.w = dot(r1, c[22]);
    r0.w = 1.0f / (r0.w);
    r0.x = dot(r1, c[11]);
    r0.y = dot(r1, c[20]);
    r0 = (r0.wwww) * (r0.xxyy);
    r2 = (r0) * (c[23].zwxy);
    r2.x = log2(abs(r2.x));
    r2.y = log2(abs(r2.y));
    r2.z = log2(abs(r2.z));
    r2.w = log2(abs(r2.w));
    r2 = (r2) * (c[24].xxxx);
    r2.x = exp2(r2.x);
    r2.y = exp2(r2.y);
    r2.z = exp2(r2.z);
    r2.w = exp2(r2.w);
    r2.xy = (r2.zw) + (r2.xy);
    r2.x = log2(abs(r2.x));
    r2.y = log2(abs(r2.y));
    r2.xy = (r2.xy) * (c[24].yy);
    r2.x = exp2(r2.x);
    r2.y = exp2(r2.y);
    r2.z = dot(r1, c[21]);
    r0.z = (r2.x) * (c[25].x);
    r0.y = (r2.y) * (c[25].y) + (-(r0.z));
    r0.z = c[25].y;
    r0.z = (r2.y) * (r0.z) + (-(c[24].z));
    r0.y = 1.0f / (r0.y);
    r2.xy = abs(r0.xw);
    r3.w = saturate((r0.z) * (r0.y));
    r1 = c[9];
    r1 = saturate((r2.zyxz) * (r1) + (c[10]));
    r3.x = (r1.w) * (r1.x);
    r3.yz = r1.yz;
    r1 = (r3) * (r3);
    r3 = (c[25].zzzz) * (r3) + (c[25].wwww);
    r1 = (r1) * (r3);
    r0.y = (r1.z) * (r1.y);
    r0.z = abs(c[24].w);
    r2.w = (r2.z) * (r2.z);
    r0.y = ((-(r0.z)) >= 0.0f ? (r0.y) : (r1.w));
    r0.z = dot(c[8].yz, r2.zw) + (c[8].x);
    r0.z = (r0.y) * (r0.z);
    r2.w = (r1.x) * (r0.z);
    r1 = c[26];
    r1.x = dot(r0.xw, r1.xy) + (c[7].x);
    r1.y = dot(r0.xw, r1.zw) + (c[7].z);
    r0 = tex2D(s0, r1.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r2.www) * (r0.xyz);
    r4.xyz = (r0.xyz) * (c[6].xyz);
    r0.xyz = v2.xyz;
    r1.xyz = (r0.zxy) * (v0.yzx);
    r2.xyz = (r0.yzx) * (v0.zxy) + (-(r1.xyz));
    r0.xy = (v4.xy) * (c[28].xy);
    r1 = tex2D(s1, r0.xy);
    r0 = tex2D(s2, r0.xy);
    r1.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r3.xy = (r1.xy) * (c[29].xx);
    r1.xyz = (-(r2.xyz)) * (r3.yyy);
    r1.xyz = (r3.xxx) * (v0.xyz) + (r1.xyz);
    r1.xyz = (r1.xyz) + (v2.xyz);
    r2.xyz = (-(v1.xyz)) + (c[5].xyz);
    r3.xyz = normalize(r1.xyz);
    r1.xyz = normalize(r2.xyz);
    r2.w = saturate(dot(r3.xyz, r1.xyz));
    r2.xyz = normalize(-(v1.xyz));
    r1.w = saturate(dot(r3.xyz, r2.xyz));
    r1.z = dot(r1.xyz, r2.xyz);
    r3.w = saturate((r2.w) * (-(r1.w)) + (r1.z));
    r1.z = (c[30].x) * (c[30].x);
    r1.y = c[30].x;
    r3.xy = (r1.yy) * (r1.yy) + (c1.zw);
    r1.xy = (r1.zz) * (c1.xy);
    r3.x = 1.0f / (r3.x);
    r3.y = 1.0f / (r3.y);
    r1.w = 1.0f / (r1.w);
    r1.z = (r1.y) * (r3.y);
    r1.z = (r3.w) * (r1.z);
    r1.y = saturate((r2.w) * (r1.w));
    r1.w = (r1.x) * (-(r3.x)) + (c2.x);
    r1.z = (r1.z) * (r1.y);
    r1.w = (r1.w) * (r2.w) + (r1.z);
    r3.xyz = normalize(v2.xyz);
    r1.xyz = (r4.xyz) * (r1.www);
    r1.w = dot(r2.xyz, r3.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2.w = max(c2.z, r1.w);
    r1.w = (r0.w) + (-(c2.x));
    r0.w = pow(abs(r2.w), c2.w);
    r0.xyz = (r1.xyz) * (r0.xyz);
    r0.w = (r0.w) * (r1.w) + (c2.x);
    r0.xyz = (r0.xyz) * (r0.www) + (-(v3.xyz));
    r1.x = v0.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[27].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
