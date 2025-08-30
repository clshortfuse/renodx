float4 UniformPixelVector_0 : register(c0);
float4 UniformPixelScalars_1 : register(c4);
float MatInverseGamma : register(c5);


struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float4 texcoord4 : TEXCOORD4;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	
	r0.x = 0.32 + i.texcoord.x;                            // add r0.x, c2.x, v0.x
	r0.y = frac(r0.x);                                     // frac r0.y, r0.x
	r0.x = -r0.y + r0.x;                                   // add r0.x, -r0.y, r0.x
	r1 = float4(0.68, 0.013, 0.987, -1) + i.texcoord.xyyx; // add r1, c1, v0.xyyx
	r0.yzw = (frac(r1.xxyz)).yzw;                          // frac r0.yzw, r1.xxy
	r0.yzw = (-r0.xyzw + r1.xxyz).yzw;                     // add r0.yzw, -r0.xyz, r1.xxy
	r0.x = -r0.y + r0.x;                                   // add r0.x, -r0.y, r0.x
	r0.y = -r0.w + r0.z;                                   // add r0.y, -r0.w, r0.z
	r0.x = r0.x + 1;                                       // add r0.x, r0.x, c2.y
	r0.x = r0.y + r0.x;                                    // add r0.x, r0.y, r0.x
	r0.x = saturate(r0.x + 1);                             // add_sat r0.x, r0.x, c2.y
	r0.y = frac(-r1.w);                                    // frac r0.y, -r1.w
	r0.y = r0.y + r1.w;                                    // add r0.y, r0.y, r1.w
	r0.y = -r0.y + -r0.x;                                  // add r0.y, -r0.y, -r0.x
	r0.x = -r0.x + 1;                                      // add r0.x, -r0.x, c2.y
	r0.y = saturate(r0.y + 1);                             // add_sat r0.y, r0.y, c2.y
	r0.x = UniformPixelScalars_1.y * r0.x + r0.y;          // mad r0.x, c4.y, r0.x, r0.y
	o.w = saturate(r0.x);                                  // mov_sat_pp oC0.w, r0.x
	r0.xyz = r0.x + UniformPixelVector_0.xyz;              // add_pp r0.xyz, r0.x, c0.xyz
	r0.xyz = r0.xyz * i.texcoord4.w + i.texcoord4.xyz;     // mad_pp r0.xyz, r0.xyz, v1.w, v1.xyz
	r1.xyz = max(abs(r0.xyz), 9.99999997e-007);            // max r1.xyz, r0.xyz_abs, c2.z
	r0.x = log2(r1.x);                                     // log r0.x, r1.x
	r0.y = log2(r1.y);                                     // log r0.y, r1.y
	r0.z = log2(r1.z);                                     // log r0.z, r1.z
	r0.xyz = r0.xyz * MatInverseGamma.x;                   // mul r0.xyz, r0.xyz, c5.x
	o.x = exp2(r0.x);                                      // exp_pp oC0.x, r0.x
	o.y = exp2(r0.y);                                      // exp_pp oC0.y, r0.y
	o.z = exp2(r0.z);                                      // exp_pp oC0.z, r0.z
	o.rgb = saturate(o.rgb);

	return o;
}
