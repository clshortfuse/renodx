#include "./common.hlsl"

Texture2D<float4> t1 : register(t1);

cbuffer cb3 : register(b3) {
  float4 CustomPixelConsts_000 : packoffset(c000.x);
  float4 CustomPixelConsts_016 : packoffset(c001.x);
  float4 CustomPixelConsts_032 : packoffset(c002.x);
  float4 CustomPixelConsts_048 : packoffset(c003.x);
  float4 CustomPixelConsts_064 : packoffset(c004.x);
  float4 CustomPixelConsts_080 : packoffset(c005.x);
  float4 CustomPixelConsts_096 : packoffset(c006.x);
  float4 CustomPixelConsts_112 : packoffset(c007.x);
  float4 CustomPixelConsts_128 : packoffset(c008.x);
  float4 CustomPixelConsts_144 : packoffset(c009.x);
  float4 CustomPixelConsts_160 : packoffset(c010.x);
  float4 CustomPixelConsts_176 : packoffset(c011.x);
  float4 CustomPixelConsts_192 : packoffset(c012.x);
  float4 CustomPixelConsts_208 : packoffset(c013.x);
  float4 CustomPixelConsts_224 : packoffset(c014.x);
  float4 CustomPixelConsts_240 : packoffset(c015.x);
  float4 CustomPixelConsts_256 : packoffset(c016.x);
  float4 CustomPixelConsts_272 : packoffset(c017.x);
  float4 CustomPixelConsts_288 : packoffset(c018.x);
  float4 CustomPixelConsts_304 : packoffset(c019.x);
  float4 CustomPixelConsts_320 : packoffset(c020.x);
  float4 CustomPixelConsts_336[4] : packoffset(c021.x);
};

float4 main(
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;

  //float scale = 0.5f;

  uint _12 = (int)(int(SV_Position.x)) - (int)(int(CustomPixelConsts_160.z));
  uint _13 = (int)(int(SV_Position.y)) - (int)(int(CustomPixelConsts_160.w));
  int _17 = int(CustomPixelConsts_192.x);
  int _18 = int(CustomPixelConsts_192.y);
  int _21 = int(CustomPixelConsts_192.z);
  int _22 = int(CustomPixelConsts_192.w);
  int _26 = int(CustomPixelConsts_176.x);
  int _27 = int(CustomPixelConsts_176.y);
  int _34 = int(CustomPixelConsts_160.x);
  int _35 = int(CustomPixelConsts_160.y);
  float4 _42 = t1.Load(int3(min(max(((uint)(((_26 * -4) + _12) + _34)), _17), _21), min(max(((uint)(((_27 * -4) + _13) + _35)), _18), _22), 0));
  float4 _56 = t1.Load(int3(min(max(((uint)(((_26 * -3) + _12) + _34)), _17), _21), min(max(((uint)(((_27 * -3) + _13) + _35)), _18), _22), 0));
  float4 _70 = t1.Load(int3(min(max(((uint)(((_26 * -2) + _12) + _34)), _17), _21), min(max(((uint)(((_27 * -2) + _13) + _35)), _18), _22), 0));
  float4 _82 = t1.Load(int3(min(max(((uint)((_12 - _26) + _34)), _17), _21), min(max(((uint)((_13 - _27) + _35)), _18), _22), 0));
  float4 _92 = t1.Load(int3(min(max(((uint)(_34 + _12)), _17), _21), min(max(((uint)(_35 + _13)), _18), _22), 0));
  float4 _107 = t1.Load(int3(min(max(((uint)((_26 + _12) + _34)), _17), _21), min(max(((uint)((_27 + _13) + _35)), _18), _22), 0));
  float4 _121 = t1.Load(int3(min(max(((uint)(((_26 << 1) + _12) + _34)), _17), _21), min(max(((uint)(((_27 << 1) + _13) + _35)), _18), _22), 0));
  float4 _135 = t1.Load(int3(min(max(((uint)(((_26 * 3) + _12) + _34)), _17), _21), min(max(((uint)(((_27 * 3) + _13) + _35)), _18), _22), 0));
  float4 _149 = t1.Load(int3(min(max(((uint)(((_26 << 2) + _12) + _34)), _17), _21), min(max(((uint)(((_27 << 2) + _13) + _35)), _18), _22), 0));

  SV_Target.x = ((((((_107.x + _82.x) * 0.1790439933538437f) + (_92.x * 0.20236000418663025f)) + ((_121.x + _70.x) * 0.12400899827480316f)) + ((_135.x + _56.x) * 0.06723400205373764f)) + ((_149.x + _42.x) * 0.02853200025856495f));
  SV_Target.y = ((((((_107.y + _82.y) * 0.1790439933538437f) + (_92.y * 0.20236000418663025f)) + ((_121.y + _70.y) * 0.12400899827480316f)) + ((_135.y + _56.y) * 0.06723400205373764f)) + ((_149.y + _42.y) * 0.02853200025856495f));
  SV_Target.z = ((((((_107.z + _82.z) * 0.1790439933538437f) + (_92.z * 0.20236000418663025f)) + ((_121.z + _70.z) * 0.12400899827480316f)) + ((_135.z + _56.z) * 0.06723400205373764f)) + ((_149.z + _42.z) * 0.02853200025856495f));
  SV_Target.w = 0.0f;

  SV_Target.rgb *= CUSTOM_BLOOM;
  return SV_Target;
}
