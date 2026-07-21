// Mechanically reconstructed from 0x31BE9A1F.ps_3_0.cso.
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

struct PS_INPUT
{
    float4 v0 : TEXCOORD1;
    float4 v1 : TEXCOORD2;
    float4 v2 : TEXCOORD3;
    float4 v3 : TEXCOORD4;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(1.0f, 0.0f, 0.5f, -2.0f);
    const float4 c2 = float4(-101.222f, 103.222f, 8.0f, 0.0f);
    const float4 c3 = float4(1.16412354f, 1.59579468f, -0.87065506f, 0.0f);
    const float4 c4 = float4(1.16412354f, -0.813476562f, -0.391448975f, 0.529705048f);
    const float4 c12 = float4(1.16412354f, 2.01782227f, -1.08166885f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = lerp(c[29].xy, c[29].zw, v3.xy);
    r1 = tex2D(s3, r0.xy);
    r1.y = r1.x;
    r2 = tex2D(s4, r0.xy);
    r0 = tex2D(s2, r0.xy);
    r1.xw = (r0.xx) * (c1.xy) + (c1.yx);
    r1.z = r2.x;
    r0.y = dot(c4, r1);
    r0.x = dot(c3.xyz, r1.xyw);
    r0.z = dot(c12.xyz, r1.xzw);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c2.zzz);
    r1 = tex2D(s6, v3.xy);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r2.z = c1.z;
    r0.w = (-(r2.z)) + (c[28].x);
    r0.xyz = float3(((r0.w) >= 0.0f ? (r0.x) : (r1.x)), ((r0.w) >= 0.0f ? (r0.y) : (r1.y)), ((r0.w) >= 0.0f ? (r0.z) : (r1.z)));
    r0.w = dot(v1.xyz, v1.xyz);
    r0.w = rsqrt(r0.w);
    r1.xyz = (r0.www) * (v1.xyz);
    r2.xyz = (r1.zxy) * (v2.yzx);
    r1.xyz = (r1.yzx) * (v2.zxy) + (-(r2.xyz));
    r1.xyz = (r1.xyz) * (v2.www);
    r2 = tex2D(s5, v3.xy);
    r2.xy = (r2.wy) * (c0.xy) + (c0.zw);
    r2.xy = (r2.xy) * (c1.zz) + (c1.zz);
    r2.xy = (r2.xy) * (-(c1.ww)) + (-(c1.xx));
    r1.xyz = (r1.xyz) * (r2.yyy);
    r1.xyz = (r2.xxx) * (v2.xyz) + (r1.xyz);
    r1.xyz = (v1.xyz) * (r0.www) + (r1.xyz);
    r2.xyz = normalize(r1.xyz);
    r1.xyz = (c1.xxx) + (-(v0.xyz));
    r3.xyz = normalize(r1.xyz);
    r0.w = dot(-(r3.xyz), r2.xyz);
    r0.w = (r0.w) + (r0.w);
    r1.xyz = (r2.xyz) * (-(r0.www)) + (-(r3.xyz));
    r0.w = saturate(dot(r2.xyz, r3.xyz));
    r2.xyz = normalize(v0.xyz);
    r1.x = saturate(dot(r1.xyz, -(r2.xyz)));
    r1.y = dot(r3.xyz, r2.xyz);
    r1.y = saturate((r1.y) * (c1.z) + (c1.z));
    r1.z = (r1.y) * (c2.x) + (c2.y);
    r1.y = (r1.y) + (c1.x);
    r2.x = pow(abs(r1.x), r1.z);
    r3.xy = c[7].xy;
    r1.xzw = (r3.yyy) * (c[6].xyz);
    r1.xzw = (r2.xxx) * (r1.xzw);
    r1.xyz = (r1.yyy) * (r1.xzw);
    r1.xyz = (r1.xyz) * (c[31].xxx);
    r2.xyz = (r3.xxx) * (c[5].xyz);
    r2.xyz = (r0.www) * (r2.xyz);
    r0.xyz = (r2.xyz) * (r0.xyz) + (r1.xyz);
    r1.xyz = max(r0.xyz, c1.yyy);
    r0 = (v0.xyzx) * (c1.xxxy) + (c1.yyyx);
    r1.w = dot(r0, c[23]);
    r1.w = 1.0f / (r1.w);
    r2.x = dot(r0, c[20]);
    r2.y = dot(r0, c[21]);
    r0.z = dot(r0, c[22]);
    r2 = (r1.wwww) * (r2.xxyy);
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
    r1.w = exp2(r2.x);
    r2.x = exp2(r2.z);
    r1.w = (r1.w) * (c[26].x);
    r1.w = (r2.x) * (c[26].y) + (-(r1.w));
    r3.y = c[26].y;
    r2.x = (r2.x) * (r3.y) + (-(c[25].z));
    r1.w = 1.0f / (r1.w);
    r3.w = saturate((r2.x) * (r1.w));
    r0.xy = abs(r2.yw);
    r4 = c[10];
    r4 = saturate((r0.zyxz) * (r4) + (c[11]));
    r3.x = (r4.w) * (r4.x);
    r3.yz = r4.yz;
    r4 = (r3) * (r3);
    r3 = (c[26].zzzz) * (r3) + (c[26].wwww);
    r3 = (r4) * (r3);
    r0.x = (r3.z) * (r3.y);
    r0.y = abs(c[25].w);
    r0.x = ((-(r0.y)) >= 0.0f ? (r0.x) : (r3.w));
    r0.w = (r0.z) * (r0.z);
    r0.y = dot(c[9].yz, r0.zw) + (c[9].x);
    r0.x = (r0.x) * (r0.y);
    r0.x = (r3.x) * (r0.x);
    r3 = c[27];
    r0.y = dot(r2.yw, r3.xy) + (c[8].x);
    r0.z = dot(r2.yw, r3.zw) + (c[8].z);
    r2 = tex2D(s1, r0.yz);
    r0.y = (r2.x) * (r2.x);
    r0.x = (r0.x) * (r0.y);
    r0.xyz = (r1.xyz) * (r0.xxx);
    r0.xyz = max(((r0.xyz) * (c[30].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = c1.x;

    return oC0;
}
