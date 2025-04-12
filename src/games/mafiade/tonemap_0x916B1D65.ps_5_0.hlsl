#include "./common.hlsl"
// https://www.elopezr.com/the-rendering-of-mafia-definitive-edition/

Texture3D<float4> t9 : register(t9);
Texture2D<float4> t8 : register(t8);
Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[9];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : VDATA0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = (int)cb0[3].x;
  r0.yz = t4.Load(float4(0,0,0,0)).yw;
  r1.xyz = t1.Sample(s1_s, v1.yz).xyz;
  r2.xyzw = cmp(float4(0,0,0,0) < cb0[5].xyzw);
  if (r2.x != 0) {
    r3.xy = max(float2(0.00999999978,0), cb1[6].zw);
    r3.zw = v1.yz * float2(2,2) + float2(-1,-1);
    r3.zw = r3.zw * r3.zw;
    r0.w = r3.z + r3.w;
    r0.w = sqrt(r0.w);
    r2.x = 0.00499999989 * r3.y;
    r0.w = max(9.99999975e-06, r0.w);
    r0.w = log2(r0.w);
    r0.w = r3.x * r0.w;
    r0.w = exp2(r0.w);
    r3.z = r2.x * r0.w;
    r3.x = -r3.z;
    r3.yw = float2(0,0);
    r3.xyzw = v1.yzyz + r3.xyzw;
    r3.x = t1.Sample(s1_s, r3.xy).x;
    r3.y = t1.Sample(s1_s, r3.zw).z;
    r3.xy = r3.xy + r1.xz;
    r1.xz = float2(0.5,0.5) * r3.xy;
  }
// Lens dirt
  if (r2.y != 0) {
    r3.xyz = t7.Sample(s2_s, v1.yz).xyz;
    r0.w = t3.Sample(s2_s, v1.yz).x;
    r2.x = t6.Sample(s2_s, v1.yz).x;
    r0.w = 0.100000001 * r0.w;
    r0.w = r0.w * r0.w;
    r3.xyz = r0.www * r3.xyz;
    r0.w = r2.x * 100 + 5;
    r3.xyz = r3.xyz * r0.www;
    r1.w = r1.y;
    r1.xyz = r3.xyz * cb1[0].zzz * injectedData.fxLensDirt + r1.xwz;
  } 
 // bloom
  if (r2.z != 0) {
    r2.xyz = t2.Sample(s2_s, v1.yz).xyz;
    r0.w = cmp(0 < cb0[4].x);
    if (r0.w != 0) {
      r3.xyz = t0.Sample(s2_s, v1.yz).xyz;
      r2.xyz = r3.xyz * cb0[4].xxx + r2.xyz;
    }
    r1.xyz = r2.xyz * injectedData.fxBloom + r1.xyz;
  } 
  r3.xyzw = cmp(float4(0,0,0,0) < cb0[6].xyzw);
  if (r3.x != 0) {
    r2.xyz = r1.xyz * cb1[2].xyz + cb1[1].xyz;
      r1.rgb = r2.rgb;
  }
        float3 untonemapped;
        float linearWhite;
  if (r2.w != 0) {
    switch (r0.x) {
      case 0 :
      r2.xyz = r1.xyz * r0.yyy;
      r2.xyz = log2(r2.xyz);
      r2.xyz = exp2(r2.xyz);
      r1.xyz = min(float3(1,1,1), r2.xyz);
      break;
      case 1 :
      r0.w = r0.y * r0.z;
          linearWhite = r0.w;
      r1.w = cb1[5].y / cb1[5].z;
      r2.x = cb1[4].z * cb1[4].y;
      r2.y = cb1[4].x * r0.w + r2.x;
      r2.zw = cb1[5].xx * cb1[5].yz;
      r2.y = r0.w * r2.y + r2.z;
      r3.x = cb1[4].x * r0.w + cb1[4].y;
      r0.w = r0.w * r3.x + r2.w;
      r0.w = r2.y / r0.w;
      r0.w = r0.w + -r1.w;
      r0.w = 1 / r0.w;
      r4.xyz = r1.xyz * r0.yyy;
            untonemapped = r4.rgb;
      r5.xyz = cb1[4].xxx * r4.xyz + r2.xxx;
      r2.xyz = r4.xyz * r5.xyz + r2.zzz;
      r5.xyz = cb1[4].xxx * r4.xyz + cb1[4].yyy;
      r4.xyz = r4.xyz * r5.xyz + r2.www;
      r2.xyz = r2.xyz / r4.xyz;
      r2.xyz = r2.xyz + -r1.www;
      r2.xyz = saturate(r2.xyz * r0.www);
      r2.xyz = log2(r2.xyz);
      r2.xyz = exp2(r2.xyz);
      r1.xyz = min(float3(1,1,1), r2.xyz);
      break;
      case -1 :
      r2.xyz = r1.xyz * r0.yyy;
      r2.xyz = log2(r2.xyz);
      r1.xyz = exp2(r2.xyz);
      break;
      case -2 :
      r2.xyz = r1.xyz * r0.yyy;
      r2.xyz = log2(r2.xyz);
      r1.xyz = exp2(r2.xyz);
      break;
      case -3 :
      r2.xyz = r1.xyz * r0.yyy;
      r4.xyz = r2.xyz * float3(2708.71411,2708.71411,2708.71411) + float3(6801.15234,6801.15234,6801.15234);
      r4.xyz = r2.xyz * r4.xyz + float3(1079.54736,1079.54736,1079.54736);
      r4.xyz = r2.xyz * r4.xyz + float3(1.16146493,1.16146493,1.16146493);
      r4.xyz = r2.xyz * r4.xyz + float3(-4.13937487e-05,-4.13937487e-05,-4.13937487e-05);
      r5.xyz = r2.xyz * float3(983.389343,983.389343,983.389343) + float3(4132.06641,4132.06641,4132.06641);
      r5.xyz = r2.xyz * r5.xyz + float3(2881.6521,2881.6521,2881.6521);
      r5.xyz = r2.xyz * r5.xyz + float3(128.359116,128.359116,128.359116);
      r2.xyz = r2.xyz * r5.xyz + float3(1,1,1);
      r2.xyz = r4.xyz / r2.xyz;
      r2.xyz = max(float3(0,0,0), r2.xyz);
      r2.xyz = log2(r2.xyz);
      r2.xyz = float3(2.20000005,2.20000005,2.20000005) * r2.xyz;
      r1.xyz = exp2(r2.xyz);
      break;
      case -4 :
      r2.xyz = r1.xyz * r0.yyy;
      r4.xyz = float3(0.600000024,0.600000024,0.600000024) * r2.xyz;
      r5.xyz = r2.xyz * float3(1625.22852,1625.22852,1625.22852) + float3(6801.15234,6801.15234,6801.15234);
      r5.xyz = r4.xyz * r5.xyz + float3(1079.54736,1079.54736,1079.54736);
      r5.xyz = r4.xyz * r5.xyz + float3(1.16146493,1.16146493,1.16146493);
      r5.xyz = r4.xyz * r5.xyz + float3(-4.13937487e-05,-4.13937487e-05,-4.13937487e-05);
      r2.xyz = r2.xyz * float3(590.03363,590.03363,590.03363) + float3(4132.06641,4132.06641,4132.06641);
      r2.xyz = r4.xyz * r2.xyz + float3(2881.6521,2881.6521,2881.6521);
      r2.xyz = r4.xyz * r2.xyz + float3(128.359116,128.359116,128.359116);
      r2.xyz = r4.xyz * r2.xyz + float3(1,1,1);
      r2.xyz = r5.xyz / r2.xyz;
      r2.xyz = max(float3(0,0,0), r2.xyz);
      r2.xyz = log2(r2.xyz);
      r2.xyz = float3(2.20000005,2.20000005,2.20000005) * r2.xyz;
      r1.xyz = exp2(r2.xyz);
      break;
      default :
      break;
    }
  } else {
    r2.xyz = max(float3(0,0,0), r1.xyz);
    r1.xyz = min(float3(65504,65504,65504), r2.xyz);
  }
  if (r3.y != 0) {
    r0.x = cmp((int)r0.x < 0);
    if (r0.x != 0) {
      r0.x = (int)cb0[3].y;
      r0.w = max(r1.x, r1.y);
      r0.w = max(r0.w, r1.z);
      r0.w = max(9.99999997e-07, r0.w);
      r1.w = dot(float3(0.212500006,0.715399981,0.0720999986), r1.xyz);
      r1.w = max(9.99999997e-07, r1.w);
      if (r0.x == 0) {
        r2.x = -r0.w * 1.90476203 + 5.80952358;
        r2.x = r0.w * r2.x + -0.429761916;
        r2.x = 0.25 * r2.x;
        r2.y = 1 + -r0.w;
        r2.y = cmp(abs(r2.y) < 0.524999976);
        r2.z = min(1, r0.w);
        r2.x = r2.y ? r2.x : r2.z;
        r2.xyz = r2.xxx / r0.www;
      } else {
        r2.w = cmp((int)r0.x == 1);
        if (r2.w != 0) {
          r2.w = r0.y * r0.z;
          r3.x = cb1[5].y / cb1[5].z;
          r3.y = cb1[4].z * cb1[4].y;
          r4.x = cb1[4].x * r2.w + r3.y;
          r4.yz = cb1[5].xx * cb1[5].yz;
          r4.x = r2.w * r4.x + r4.y;
          r4.w = cb1[4].x * r2.w + cb1[4].y;
          r2.w = r2.w * r4.w + r4.z;
          r2.w = r4.x / r2.w;
          r2.w = r2.w + -r3.x;
          r2.w = 1 / r2.w;
          r4.x = r0.y * r0.w;
          r3.y = cb1[4].x * r4.x + r3.y;
          r3.y = r4.x * r3.y + r4.y;
          r4.y = cb1[4].x * r4.x + cb1[4].y;
          r4.x = r4.x * r4.y + r4.z;
          r3.y = r3.y / r4.x;
          r3.x = r3.y + -r3.x;
          r2.w = saturate(r3.x * r2.w);
          r2.w = log2(r2.w);
          r2.w = cb0[2].x * r2.w;
          r2.w = exp2(r2.w);
          r2.w = min(1, r2.w);
          r2.xyz = r2.www / r0.www;
        } else {
          r2.w = cmp((int)r0.x == 2);
          if (r2.w != 0) {
            r2.w = r0.y * r0.z;
            r3.x = cb1[5].y / cb1[5].z;
            r3.y = cb1[4].z * cb1[4].y;
            r4.x = cb1[4].x * r2.w + r3.y;
            r4.yz = cb1[5].xx * cb1[5].yz;
            r4.x = r2.w * r4.x + r4.y;
            r4.w = cb1[4].x * r2.w + cb1[4].y;
            r2.w = r2.w * r4.w + r4.z;
            r2.w = r4.x / r2.w;
            r2.w = r2.w + -r3.x;
            r2.w = 1 / r2.w;
            r5.xyz = r1.xyz * r0.yyy;
            r6.xyz = cb1[4].xxx * r5.xyz + r3.yyy;
            r4.xyw = r5.xyz * r6.xyz + r4.yyy;
            r6.xyz = cb1[4].xxx * r5.xyz + cb1[4].yyy;
            r5.xyz = r5.xyz * r6.xyz + r4.zzz;
            r4.xyz = r4.xyw / r5.xyz;
            r4.xyz = r4.xyz + -r3.xxx;
              r4.xyz = r4.xyz * r2.www;
            r4.xyz = log2(r4.xyz);
            r4.xyz = cb0[2].xxx * r4.xyz;
            r4.xyz = exp2(r4.xyz);
            r4.xyz = min(float3(1,1,1), r4.xyz);
            r2.xyz = r4.xyz / r1.xyz;
          } else {
            r2.w = cmp((int)r0.x == 3);
            if (r2.w != 0) {
              r0.z = r0.y * r0.z;
              r2.w = cb1[5].y / cb1[5].z;
              r3.x = cb1[4].z * cb1[4].y;
              r3.y = cb1[4].x * r0.z + r3.x;
              r4.xy = cb1[5].xx * cb1[5].yz;
              r3.y = r0.z * r3.y + r4.x;
              r4.z = cb1[4].x * r0.z + cb1[4].y;
              r0.z = r0.z * r4.z + r4.y;
              r0.z = r3.y / r0.z;
              r0.z = r0.z + -r2.w;
              r0.z = 1 / r0.z;
              r0.y = r1.w * r0.y;
              r3.x = cb1[4].x * r0.y + r3.x;
              r3.x = r0.y * r3.x + r4.x;
              r3.y = cb1[4].x * r0.y + cb1[4].y;
              r0.y = r0.y * r3.y + r4.y;
              r0.y = r3.x / r0.y;
              r0.y = r0.y + -r2.w;
              r0.y = saturate(r0.y * r0.z);
              r0.y = log2(r0.y);
              r0.y = cb0[2].x * r0.y;
              r0.y = exp2(r0.y);
              r0.y = min(1, r0.y);
              r2.xyz = r0.yyy / r0.www;
            } else {
              r0.x = cmp((int)r0.x == 4);
              r0.y = -r1.w * 1.90476203 + 5.80952358;
              r0.y = r1.w * r0.y + -0.429761916;
              r0.y = 0.25 * r0.y;
              r0.z = 1 + -r1.w;
              r0.z = cmp(abs(r0.z) < 0.524999976);
              r0.w = min(1, r1.w);
              r0.y = r0.z ? r0.y : r0.w;
              r0.y = r0.y / r1.w;
              r2.xyz = r0.xxx ? r0.yyy : float3(1,1,1);
            }
          }
        }
      }
      // seemingly not used?
      r0.xyz = r2.xyz * r1.xyz;
      r4.xyz = max(float3(9.99999975e-06,9.99999975e-06,9.99999975e-06), r0.xyz);
      r4.xyz = log2(r4.xyz);
      r4.xyz = float3(0.454545468,0.454545468,0.454545468) * r4.xyz;
      r4.xyz = exp2(r4.xyz);
      r4.xyz = r4.xyz * float3(0.9375,0.9375,0.9375) + float3(0.03125,0.03125,0.03125);
      r4.xyz = t9.Sample(s2_s, r4.xyz).xyz;
      r0.w = saturate(cb1[6].y);
      r4.xyz = -r1.xyz * r2.xyz + r4.xyz;
      r0.xyz = r0.www * r4.xyz + r0.xyz;
        r1.rgb = applyUserTonemap(untonemapped, t9, s2_s, cb1[4].xyz, float4(cb1[5].xyz, linearWhite), cb1[6].y == 1.f);
      r1.xyz = r0.xyz / r2.xyz;
    } else {
      // color grading LUT
      r0.xyz = max(float3(9.99999975e-06,9.99999975e-06,9.99999975e-06), r1.xyz);
      r0.xyz = log2(r0.xyz);
      r0.xyz = float3(0.454545468,0.454545468,0.454545468) * r0.xyz;
      r0.xyz = exp2(r0.xyz);
      r0.xyz = r0.xyz * float3(0.9375,0.9375,0.9375) + float3(0.03125,0.03125,0.03125);
      r0.xyz = t9.Sample(s2_s, r0.xyz).xyz;
      r0.rgb = applyUserTonemap(untonemapped, t9, s2_s, cb1[4].xyz, float4(cb1[5].xyz, linearWhite), cb1[6].y == 1.f);
      r0.w = saturate(cb1[6].y);
      r0.xyz = r0.xyz + -r1.xyz;
      r1.xyz = r0.www * r0.xyz + r1.xyz;
    }
  } 
  if (r3.z != 0) {
    r0.x = saturate(cb1[6].x);
      r0.yzw = r1.xyz;
    r0.yzw = min(float3(65504,65504,65504), r0.yzw);
    r0.y = dot(r0.yzw, float3(0.212500006,0.715399981,0.0720999986));
    r0.yzw = r0.yyy + -r1.xyz;
    r1.xyz = r0.xxx * r0.yzw + r1.xyz;
  }
  // film grain
  if (r3.w != 0) {
    r0.xy = cb0[0].xx * v1.yz;
    r2.x = dot(cb0[1].xy, r0.xy);
    r2.y = dot(cb0[1].zw, r0.xy);
    r0.xyz = t8.Sample(s0_s, r2.xy).xyz;
        if(injectedData.fxFilmGrainType == 0){  
    r1.xyz = r0.xyz * cb0[0].yyy * injectedData.fxFilmGrain + r1.xyz;
    } else {
    r1.rgb = applyFilmGrain(r1.rgb, v1.yz);
    }
  }
  // vignette
  r0.x = cmp(0 < cb0[7].x);
  if (r0.x != 0) {
    r0.xyz = float3(-1,-1,-1) + cb1[3].xyz;
    r0.xyz = v1.xxx * r0.xyz * injectedData.fxVignette + float3(1,1,1);
    r1.xyz = r1.xyz * r0.xyz;
  }
  // sensor noise
  r0.x = cmp(0 < cb0[8].z);
  if (r0.x != 0) {
    r0.xy = cb0[8].xy + v0.xy;
    r0.xy = (int2)r0.xy;
    r0.xy = (int2)r0.xy & int2(63,63);
    r0.zw = float2(0,0);
    r0.xyz = t5.Load(r0.xyz).xyz;
    r0.xyz = r0.xyz * float3(2,2,2) + float3(-1,-1,-1);
      r2.rgb = renodx::math::SignSqrt(r1.rgb);
    r3.xyz = cb0[8].www + r2.xyz;
    r3.xyz = min(cb0[8].zzz, r3.xyz);
    r0.xyz = r0.xyz * r3.xyz * injectedData.fxNoise + r2.xyz;
      r1.rgb = renodx::color::gamma::DecodeSafe(r0.rgb, 2.f);
    }
        if(injectedData.is_swapchain_write == true){
      r1.rgb = PostToneMapScale(r1.rgb);
      }
  o0.xyz = r1.xyz;
  o0.w = 1;
  return;
}