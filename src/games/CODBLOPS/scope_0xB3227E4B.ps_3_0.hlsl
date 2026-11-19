// Scope lens: preserve stock distortion and channel dispersion.

sampler2D Normal_Map : register(s1);
sampler2D Scene : register(s2);
float4 cameraUp : register(c5);
float4 cameraLook : register(c6);
float4 scriptVector1 : register(c7);
float4 WarpHeight : register(c8);
float4 DispersionAmount : register(c9);
float4 main(float2 uv : TEXCOORD1) : COLOR0 {
 float4 n=tex2D(Normal_Map,uv);
 float2 offset=n.wy*float2(4.07999992,4.06451607)+float2(-2.07999992,-2.06451607);
 offset*=WarpHeight.x*scriptVector1.w/cameraLook.y;
 float2 base=lerp(cameraUp.xy,cameraUp.zw,uv);
 float2 redUV=base-offset*DispersionAmount.x;
 float2 greenUV=redUV-offset*DispersionAmount.y;
 float2 blueUV=greenUV-offset*DispersionAmount.z;
 float3 color=float3(tex2D(Scene,redUV).r,tex2D(Scene,greenUV).g,tex2D(Scene,blueUV).b);
 return float4(color,1);
}
