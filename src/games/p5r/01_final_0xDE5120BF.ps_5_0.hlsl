#include "../../shaders/color.hlsl"
#include "./shared.h"

cbuffer GFD_PSCONST_GAMMA : register(b13) {
  float4 clearColor : packoffset(c0);
  float4 gammaTable : packoffset(c1);
}

SamplerState sourceSampler_s : register(s0);
Texture2D<float4> sourceTexture : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
  float4 v0 : SV_POSITION0,
              float2 v1 : TEXCOORD0,
                          out float4 o0 : SV_TARGET0
) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  const float4 inputColor = sourceTexture.Sample(sourceSampler_s, v1.xy);
  r0.xyz = inputColor.rgb;
  r0.xyz = r0.xyz;
  r0.xyz = r0.xyz;
  r0.x = r0.x;
  r0.x = 4 * r0.x;
  r0.w = cmp(r0.x < 1);
  if (r0.w != 0) {
    r1.y = 0;
    r1.z = gammaTable.x;
    r1.x = 0;
  } else {
    r0.w = cmp(r0.x < 2);
    if (r0.w != 0) {
      r1.y = gammaTable.x;
      r1.z = gammaTable.y;
      r1.x = 1;
    } else {
      r0.w = cmp(r0.x < 3);
      if (r0.w != 0) {
        r1.y = gammaTable.y;
        r1.z = gammaTable.z;
        r1.x = 2;
      } else {
        r1.y = gammaTable.z;
        r1.z = gammaTable.w;
        r1.x = 3;
      }
    }
  }
  r0.w = -r1.x;
  r0.x = r0.x + r0.w;
  r0.w = -r1.y;
  r0.w = r1.z + r0.w;
  r0.x = r0.x * r0.w;
  r1.x = r1.y + r0.x;
  r1.x = r1.x;
  r0.y = r0.y;
  r0.x = 4 * r0.y;
  r0.y = cmp(r0.x < 1);
  if (r0.y != 0) {
    r2.y = 0;
    r2.z = gammaTable.x;
    r2.x = 0;
  } else {
    r0.y = cmp(r0.x < 2);
    if (r0.y != 0) {
      r2.y = gammaTable.x;
      r2.z = gammaTable.y;
      r2.x = 1;
    } else {
      r0.y = cmp(r0.x < 3);
      if (r0.y != 0) {
        r2.y = gammaTable.y;
        r2.z = gammaTable.z;
        r2.x = 2;
      } else {
        r2.y = gammaTable.z;
        r2.z = gammaTable.w;
        r2.x = 3;
      }
    }
  }
  r0.y = -r2.x;
  r0.x = r0.x + r0.y;
  r0.y = -r2.y;
  r0.y = r2.z + r0.y;
  r0.x = r0.x * r0.y;
  r1.y = r2.y + r0.x;
  r1.y = r1.y;
  r0.z = r0.z;
  r0.x = 4 * r0.z;
  r0.y = cmp(r0.x < 1);
  if (r0.y != 0) {
    r2.y = 0;
    r2.z = gammaTable.x;
    r2.x = 0;
  } else {
    r0.y = cmp(r0.x < 2);
    if (r0.y != 0) {
      r2.y = gammaTable.x;
      r2.z = gammaTable.y;
      r2.x = 1;
    } else {
      r0.y = cmp(r0.x < 3);
      if (r0.y != 0) {
        r2.y = gammaTable.y;
        r2.z = gammaTable.z;
        r2.x = 2;
      } else {
        r2.y = gammaTable.z;
        r2.z = gammaTable.w;
        r2.x = 3;
      }
    }
  }
  r0.y = -r2.x;
  r0.x = r0.x + r0.y;
  r0.y = -r2.y;
  r0.y = r2.z + r0.y;
  r0.x = r0.x * r0.y;
  r1.z = r2.y + r0.x;
  r1.z = r1.z;
  r1.x = r1.x;
  r1.y = r1.y;
  r1.z = r1.z;
  r1.xyz = r1.xyz;
  r1.w = 1;
  r0.x = clearColor.x;
  r0.x = (int)r0.x & 255;
  r0.x = (uint)r0.x;
  r0.x = r0.x / 255;
  r0.x = cmp(0 < r0.x);
  if (r0.x != 0) {
    r1.xyz = r1.xyz;
    r1.w = r1.w;
    r0.xyz = float3(-0.5, -0.5, -0.5);
    r0.xyz = r1.xyz + r0.xyz;
    r0.w = clearColor.x;
    r0.w = (int)r0.w & 255;
    r0.w = (uint)r0.w;
    r0.w = r0.w / 255;
    r0.w = 0.112000003 * r0.w;
    r0.w = 1 + r0.w;
    r0.xyz = r0.xyz * r0.www;
    r0.xyz = float3(0.5, 0.5, 0.5) + r0.xyz;
    r0.w = clearColor.x;
    r0.w = (int)r0.w & 255;
    r0.w = (uint)r0.w;
    r0.w = r0.w / 255;
    r0.w = 0.075000003 * r0.w;
    r0.w = -r0.w;
    r0.w = 0 + r0.w;
    r1.xyz = r0.xyz + r0.www;
    r0.x = clearColor.x;
    r0.x = (int)r0.x & 255;
    r0.x = (uint)r0.x;
    r0.x = r0.x / 255;
    r0.x = r1.w * r0.x;
    r0.yzw = r1.xyz;
    r1.w = r1.w;
    r0.yzw = r0.yzw;
    r0.yzw = r0.yzw;
    r2.x = 17.8824005 * r0.y;
    r2.y = 43.5161018 * r0.z;
    r2.x = r2.x + r2.y;
    r2.y = 4.11934996 * r0.w;
    r2.x = r2.x + r2.y;
    r2.w = 3.45565009 * r0.y;
    r3.x = 27.1553993 * r0.z;
    r2.w = r3.x + r2.w;
    r3.x = 3.86714005 * r0.w;
    r2.y = r3.x + r2.w;
    r2.w = 0.0299565997 * r0.y;
    r3.x = 0.184309006 * r0.z;
    r2.w = r3.x + r2.w;
    r3.x = 1.46709001 * r0.w;
    r2.z = r3.x + r2.w;
    r2.x = r2.x;
    r2.y = r2.y;
    r2.z = r2.z;
    r2.xyz = r2.xyz;
    r2.w = 2.02343988 * r2.y;
    r3.x = -2.52810001 * r2.z;
    r2.w = r3.x + r2.w;
    r3.x = clearColor.x;
    r3.x = (int)r3.x & 0xff000000;
    r3.y = 24;
    r3.x = (uint)r3.x >> (uint)r3.y;
    r3.x = (uint)r3.x;
    r3.x = r3.x / 255;
    r2.w = r3.x * r2.w;
    r3.x = clearColor.x;
    r3.x = (int)r3.x & 0xff000000;
    r3.y = 24;
    r3.x = (uint)r3.x >> (uint)r3.y;
    r3.x = (uint)r3.x;
    r3.x = r3.x / 255;
    r3.x = -r3.x;
    r3.x = 1 + r3.x;
    r3.x = r3.x * r2.x;
    r2.w = r3.x + r2.w;
    r3.x = 0.494206995 * r2.x;
    r3.y = 1.24827003 * r2.z;
    r3.x = r3.x + r3.y;
    r3.y = clearColor.x;
    r3.y = (int)r3.y & 0x00ff0000;
    r3.z = 16;
    r3.y = (uint)r3.y >> (uint)r3.z;
    r3.y = (uint)r3.y;
    r3.y = r3.y / 255;
    r3.x = r3.x * r3.y;
    r3.y = clearColor.x;
    r3.y = (int)r3.y & 0x00ff0000;
    r3.z = 16;
    r3.y = (uint)r3.y >> (uint)r3.z;
    r3.y = (uint)r3.y;
    r3.y = r3.y / 255;
    r3.y = -r3.y;
    r3.y = 1 + r3.y;
    r3.y = r3.y * r2.y;
    r3.x = r3.x + r3.y;
    r2.x = -0.395913005 * r2.x;
    r2.y = 0.801109016 * r2.y;
    r2.x = r2.x + r2.y;
    r2.y = clearColor.x;
    r2.y = (int)r2.y & 0x0000ff00;
    r3.y = 8;
    r2.y = (uint)r2.y >> (uint)r3.y;
    r2.y = (uint)r2.y;
    r2.y = r2.y / 255;
    r2.x = r2.x * r2.y;
    r2.y = clearColor.x;
    r2.y = (int)r2.y & 0x0000ff00;
    r3.y = 8;
    r2.y = (uint)r2.y >> (uint)r3.y;
    r2.y = (uint)r2.y;
    r2.y = r2.y / 255;
    r2.y = -r2.y;
    r2.y = 1 + r2.y;
    r2.y = r2.z * r2.y;
    r2.x = r2.x + r2.y;
    r2.w = r2.w;
    r3.x = r3.x;
    r2.x = r2.x;
    r2.y = 0.0809444487 * r2.w;
    r2.z = -0.130504414 * r3.x;
    r2.y = r2.y + r2.z;
    r2.z = 0.116721064 * r2.x;
    r4.x = r2.y + r2.z;
    r2.y = -0.0102485335 * r2.w;
    r2.z = 0.0540193282 * r3.x;
    r2.y = r2.y + r2.z;
    r2.z = -0.113614708 * r2.x;
    r4.y = r2.y + r2.z;
    r2.y = -0.000365296932 * r2.w;
    r2.z = -0.00412161462 * r3.x;
    r2.y = r2.y + r2.z;
    r2.x = 0.693511426 * r2.x;
    r4.z = r2.y + r2.x;
    r4.x = r4.x;
    r4.y = r4.y;
    r4.z = r4.z;
    r4.xyz = r4.xyz;
    r2.xyz = -r4.xyz;
    r2.xyz = r2.xyz + r0.yzw;
    r3.x = 0;
    r2.w = 0.699999988 * r2.x;
    r3.y = r2.y + r2.w;
    r2.x = 0.699999988 * r2.x;
    r3.z = r2.z + r2.x;
    r0.yzw = r3.xyz + r0.yzw;
    r2.xyz = max(float3(0, 0, 0), r0.yzw);
    r2.w = max(0, r1.w);
    r2.xyzw = min(float4(1, 1, 1, 1), r2.xyzw);
    r2.xyzw = r2.xyzw;
    r2.xyzw = r2.xyzw * r0.xxxx;
    r0.x = -r0.x;
    r0.x = 1 + r0.x;
    r0.xyzw = r1.xyzw * r0.xxxx;
    r0.xyzw = r2.xyzw + r0.xyzw;
    r0.xyzw = max(float4(0, 0, 0, 0), r0.xyzw);
    r1.xyzw = min(float4(1, 1, 1, 1), r0.xyzw);
    r1.xyzw = r1.xyzw;
    r1.xyzw = r1.xyzw;
  }
  // o0.xyzw = r1.xyzw;
  o0.rgb = inputColor.rgb;
  o0.a = saturate(inputColor.a);
  float3 signs = sign(o0.rgb);
  o0.rgb = abs(o0.rgb);
  o0.rgb = (injectedData.toneMapGammaCorrection ? pow(o0.rgb, 2.2f) : linearFromSRGB(o0.rgb));
  o0.rgb *= signs;
  o0.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}
