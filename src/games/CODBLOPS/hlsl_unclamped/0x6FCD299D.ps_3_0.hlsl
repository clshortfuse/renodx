// Mechanically reconstructed from 0x6FCD299D.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s1 : register(s1);

struct PS_INPUT
{
    float4 v0 : TEXCOORD2;
    float4 v1 : TEXCOORD3;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    const float4 c0 = float4(-0.100000001f, -0.5f, 0.100000001f, 0.5f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 oC0 = 0.0f;

    r0.w = c[5].w;
    r0.x = (r0.w) * (c[11].x);
    r0.y = (c[20].y) * (c[20].x);
    r0.z = 1.0f / (r0.y);
    r0.x = (r0.x) * (r0.z);
    r0.z = frac(abs(r0.x));
    r0.x = ((r0.x) >= 0.0f ? (r0.z) : (-(r0.z)));
    r0.x = (r0.y) * (r0.x);
    r0.y = frac(r0.x);
    r0.x = (r0.x) + (-(r0.y));
    r0.y = 1.0f / (c[20].x);
    r0.x = (r0.x) * (r0.y);
    r0.w = frac(abs(r0.x));
    r0.w = ((r0.x) >= 0.0f ? (r0.w) : (-(r0.w)));
    r1.x = (r0.w) * (c[20].x);
    r0.w = frac(r0.x);
    r1.y = (r0.x) + (-(r0.w));
    r0.z = 1.0f / (c[20].y);
    r0.xw = (r0.yz) * (r1.xy);
    r1.xy = (c0.xy) + (v1.xy);
    r1.zw = c0.zw;
    r1.xy = (r1.xy) * (c[10].xx) + (r1.zw);
    r1.zw = frac(r1.xy);
    r1.zw = (r1.zw) + (c0.yy);
    r1.zw = (r1.zw) * (c0.ww) + (c0.ww);
    r0.xw = (r1.zw) * (r0.yz) + (r0.xw);
    r1.zw = ddx(r1.xy);
    r1.xy = ddy(r1.xy);
    r1.xy = (r0.yz) * (r1.xy);
    r1 = (r1) * (c0.wwww);
    r0.yz = (r0.yz) * (r1.zw);
    r0 = tex2Dgrad(s1, r0.xw, r0.yz, r1.xy);
    r0.x = (r0.w) * (r0.w);
    oC0.w = (r0.x) * (v0.w);
    r0.x = c[6].x;
    r0.y = max(((r0.x) * (c[7].w)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.y = rsqrt(r0.y);
    oC0.x = 1.0f / (r0.y);
    r0.y = max(((r0.x) * (c[8].w)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.y = rsqrt(r0.y);
    oC0.y = 1.0f / (r0.y);
    r0.x = max(((r0.x) * (c[9].w)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.z = 1.0f / (r0.x);

    return oC0;
}
