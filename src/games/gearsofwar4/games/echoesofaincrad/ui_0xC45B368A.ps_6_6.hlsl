#include "../../common.hlsli"

// Echoes of Aincrad UI shader - translucent base pass with volumetric fog
// Hash: 0xC45B368A

StructuredBuffer<float4> t0 : register(t0);  // Scene_GPUScene_GPUScenePrimitiveSceneData

Texture3D<float4> t1 : register(t1);  // TranslucentBasePass_Shared_Fog_IntegratedLightScattering

Texture2D<float4> t2 : register(t2);  // Material_Texture2D_0

SamplerState s0 : register(s0);  // View_MaterialTextureBilinearClampedSampler
SamplerState s1 : register(s1);  // View_SharedBilinearClampedSampler

// CB0: UniformBufferConstants_View (b0, 5500 bytes)
// Only declaring registers actually loaded: 4-7, 44-47, 60-61, 132, 137, 225-226, 229
cbuffer cb0 : register(b0) {
  float4 View_c4[4] : packoffset(c4);    // regs 4,5,6,7 (View_TranslatedWorldToClip rows - offset 64 = c4..c7)
  float4 View_c44[4] : packoffset(c44);  // regs 44,45,46,47 (View_SVPositionToTranslatedWorld - offset 704 = c44..c47)
  float4 View_c60 : packoffset(c60);     // reg 60 (View_ViewTilePosition - offset 960)
  float4 View_c61 : packoffset(c61);     // reg 61 (View_MatrixTilePosition - offset 976)
  float4 View_c132 : packoffset(c132);   // reg 132 (View_PreExposure at .2, View_OneOverPreExposure at .3 - offset 2112)
  float4 View_c137 : packoffset(c137);   // reg 137 (View_OutOfBoundsMask at .0 - offset 2192)
  float4 View_c225 : packoffset(c225);   // reg 225 (View_VolumetricFogSVPosToVolumeUV - offset 3600)
  float4 View_c226 : packoffset(c226);   // reg 226 (View_VolumetricFogGridZParams - offset 3616)
  float4 View_c229 : packoffset(c229);   // reg 229 (View_VolumetricFogMaxDistance - offset 3664)
}

// CB1: UniformBufferConstants_TranslucentBasePass (b1, 3404 bytes)
// Only declaring registers actually loaded: 124, 125
cbuffer cb1 : register(b1) {
  float4 TranslucentBasePass_c124 : packoffset(c124);  // reg 124 (Fog ApplyVolumetricFog at .3, offset ~1996)
  float4 TranslucentBasePass_c125 : packoffset(c125);  // reg 125 (Fog VolumetricFogStartDistance at .0)
}

// CB2: UniformBufferConstants_Material (b2, 140 bytes)
// Only declaring registers actually loaded: 4, 5, 6
cbuffer cb2 : register(b2) {
  float4 Material_c4 : packoffset(c4);  // reg 4 (Material_PreshaderBuffer[4])
  float4 Material_c5 : packoffset(c5);  // reg 5 (Material_PreshaderBuffer[5])
  float4 Material_c6 : packoffset(c6);  // reg 6 (Material_PreshaderBuffer[6])
}

struct PSInput {
  linear float4 TEXCOORD10_centroid : TEXCOORD10_centroid;  // sigId 0, reg 0
  linear float4 TEXCOORD11_centroid : TEXCOORD11_centroid;  // sigId 1, reg 1
  linear float4 TEXCOORD0 : TEXCOORD0;                     // sigId 2, reg 2
  nointerpolation uint PRIMITIVE_ID : PRIMITIVE_ID;         // sigId 3, reg 3.x
  nointerpolation uint SV_IsFrontFace : SV_IsFrontFace;    // sigId 7, reg 3.y
  linear float4 TEXCOORD7 : TEXCOORD7;                     // sigId 4, reg 4
  linear float3 TEXCOORD9 : TEXCOORD9;                     // sigId 5, reg 5
  noperspective float4 SV_Position : SV_Position;          // sigId 6, reg 6
};

float4 main(PSInput input) : SV_Target {
  // Load inputs
  // sigId 6 = SV_Position
  float SV_Position_x = input.SV_Position.x;  // %12
  float SV_Position_y = input.SV_Position.y;  // %13
  float SV_Position_z = input.SV_Position.z;  // %14
  float SV_Position_w = input.SV_Position.w;  // %123 (loaded later in branch)

  // sigId 5 = TEXCOORD9
  float TEXCOORD9_x = input.TEXCOORD9.x;  // %15
  float TEXCOORD9_y = input.TEXCOORD9.y;  // %16
  float TEXCOORD9_z = input.TEXCOORD9.z;  // %17

  // sigId 4 = TEXCOORD7
  float TEXCOORD7_x = input.TEXCOORD7.x;  // %18
  float TEXCOORD7_y = input.TEXCOORD7.y;  // %19
  float TEXCOORD7_z = input.TEXCOORD7.z;  // %20
  float TEXCOORD7_w = input.TEXCOORD7.w;  // %21

  // sigId 3 = PRIMITIVE_ID
  uint PRIMITIVE_ID = input.PRIMITIVE_ID;  // %22

  // sigId 2 = TEXCOORD0
  float TEXCOORD0_x = input.TEXCOORD0.x;  // %59
  float TEXCOORD0_y = input.TEXCOORD0.y;  // %60

  // CB1 loads: reg 124, 125
  // %23 = cbufferLoadLegacy(cb1, 124) -> TranslucentBasePass_c124
  float cb1_124_w = TranslucentBasePass_c124.w;  // %24 = ApplyVolumetricFog flag
  // %25 = cbufferLoadLegacy(cb1, 125)
  float cb1_125_x = TranslucentBasePass_c125.x;  // %122 (VolumetricFogStartDistance)

  // CB0 loads: regs 4,5,6,7 (View_TranslatedWorldToClip rows at c4-c7, offsets 64-127)
  // %26 = cbufferLoadLegacy(cb0, 4)
  float4 cb0_4 = View_c4[0];
  // %27 = cbufferLoadLegacy(cb0, 5)
  float4 cb0_5 = View_c4[1];
  // %28 = cbufferLoadLegacy(cb0, 6)
  float4 cb0_6 = View_c4[2];
  // %29 = cbufferLoadLegacy(cb0, 7)
  float4 cb0_7 = View_c4[3];

  // CB0 loads: regs 44-47 (View_SVPositionToTranslatedWorld rows at c44-c47)
  // %30 = cbufferLoadLegacy(cb0, 44) -> {%31, %32, %33, %34}
  float4 cb0_44 = View_c44[0];
  // %35 = cbufferLoadLegacy(cb0, 45) -> {%36, %37, %38, %39}
  float4 cb0_45 = View_c44[1];
  // %40 = cbufferLoadLegacy(cb0, 46) -> {%41, %42, %43, %44}
  float4 cb0_46 = View_c44[2];
  // %45 = cbufferLoadLegacy(cb0, 47) -> {%46, %47, %48, %49}
  float4 cb0_47 = View_c44[3];

  // CB0 loads: reg 60 (View_ViewTilePosition) -> {%51, %52, %53}
  // %50 = cbufferLoadLegacy(cb0, 60)
  float cb0_60_x = View_c60.x;  // %51
  float cb0_60_y = View_c60.y;  // %52
  float cb0_60_z = View_c60.z;  // %53

  // CB0 loads: reg 61 (View_MatrixTilePosition) -> {%56, %57, %58}
  // %55 = cbufferLoadLegacy(cb0, 61) (actually extractvalue from %54 which is reg 61)
  // Note: %54 is the same load as reg 61 per the IR naming
  float cb0_61_x = View_c61.x;  // %56 = extractvalue %55, 0  (actually %126 in branch context)
  float cb0_61_y = View_c61.y;  // %57 = extractvalue %55, 1  (actually %125)
  float cb0_61_z = View_c61.z;  // %58 = extractvalue %55, 2  (actually %124)

  // SVPositionToTranslatedWorld transform: multiply SV_Position by the 4x4 matrix
  // %61 = cb0_44.x * SV_Position_x
  // %62 = mad(SV_Position_y, cb0_45.x, %61)
  // %63 = mad(SV_Position_z, cb0_46.x, %62)
  // %64 = %63 + cb0_47.x
  float v64 = mad(SV_Position_z, cb0_46.x, mad(SV_Position_y, cb0_45.x, cb0_44.x * SV_Position_x)) + cb0_47.x;

  // %65 = cb0_44.y * SV_Position_x
  // %66 = mad(SV_Position_y, cb0_45.y, %65)
  // %67 = mad(SV_Position_z, cb0_46.y, %66)
  // %68 = %67 + cb0_47.y
  float v68 = mad(SV_Position_z, cb0_46.y, mad(SV_Position_y, cb0_45.y, cb0_44.y * SV_Position_x)) + cb0_47.y;

  // %69 = cb0_44.z * SV_Position_x
  // %70 = mad(SV_Position_y, cb0_45.z, %69)
  // %71 = mad(SV_Position_z, cb0_46.z, %70)
  // %72 = %71 + cb0_47.z
  float v72 = mad(SV_Position_z, cb0_46.z, mad(SV_Position_y, cb0_45.z, cb0_44.z * SV_Position_x)) + cb0_47.z;

  // %73 = cb0_44.w * SV_Position_x
  // %74 = mad(SV_Position_y, cb0_45.w, %73)
  // %75 = mad(SV_Position_z, cb0_46.w, %74)
  // %76 = %75 + cb0_47.w
  float v76 = mad(SV_Position_z, cb0_46.w, mad(SV_Position_y, cb0_45.w, cb0_44.w * SV_Position_x)) + cb0_47.w;

  // Perspective divide: TranslatedWorldPosition = xyz / w
  // %77 = v64 / v76
  // %78 = v68 / v76
  // %79 = v72 / v76
  float v77 = v64 / v76;
  float v78 = v68 / v76;
  float v79 = v72 / v76;

  // RelativeWorldPosition = TranslatedWorldPosition - MatrixTilePosition
  // %80 = v77 - cb0_61_x
  // %81 = v78 - cb0_61_y
  // %82 = v79 - cb0_61_z
  float v80 = v77 - cb0_61_x;
  float v81 = v78 - cb0_61_y;
  float v82 = v79 - cb0_61_z;

  // Sample Material_Texture2D_0 at TEXCOORD0
  // %85 = sample(t2, s0, TEXCOORD0_x, TEXCOORD0_y)
  float4 texSample = t2.Sample(s0, float2(TEXCOORD0_x, TEXCOORD0_y));
  float v86 = texSample.x;  // %86
  float v87 = texSample.y;  // %87
  float v88 = texSample.z;  // %88
  float v89 = texSample.w;  // %89 (alpha)

  // CB2 loads: reg 4 (Material_PreshaderBuffer[4])
  // %90 = cbufferLoadLegacy(cb2, 4)
  float v91 = Material_c4.x;  // %91
  float v92 = Material_c4.y;  // %92
  float v93 = Material_c4.z;  // %93

  // Multiply texture RGB by material color, divide by alpha (premultiplied alpha decode)
  // %94 = v91 * v86
  // %95 = v92 * v87
  // %96 = v93 * v88
  float v94 = v91 * v86;
  float v95 = v92 * v87;
  float v96 = v93 * v88;

  // %97 = v94 / v89
  // %98 = v95 / v89
  // %99 = v96 / v89
  float v97 = v94 / v89;
  float v98 = v95 / v89;
  float v99 = v96 / v89;

  // %100 = Material_c4.w (lerp factor)
  float v100 = Material_c4.w;

  // CB2 loads: reg 5 (Material_PreshaderBuffer[5])
  // %101 = cbufferLoadLegacy(cb2, 5)
  float v102 = Material_c5.x;  // %102
  float v103 = Material_c5.y;  // %103
  float v104 = Material_c5.z;  // %104

  // Lerp between decoded texture color and Material_c5.xyz based on Material_c4.w
  // %105 = v102 - v97
  // %106 = v103 - v98
  // %107 = v104 - v99
  float v105 = v102 - v97;
  float v106 = v103 - v98;
  float v107 = v104 - v99;

  // %108 = v105 * v100
  // %109 = v106 * v100
  // %110 = v107 * v100
  float v108 = v105 * v100;
  float v109 = v106 * v100;
  float v110 = v107 * v100;

  // %111 = v108 + v97
  // %112 = v109 + v98
  // %113 = v110 + v99
  float v111 = v108 + v97;
  float v112 = v109 + v98;
  float v113 = v110 + v99;

  // Opacity calculation
  // %114 = Material_c5.w
  float v114 = Material_c5.w;
  // %115 = v114 * v89
  float v115 = v114 * v89;

  // CB2 loads: reg 6 (Material_PreshaderBuffer[6])
  // %116 = cbufferLoadLegacy(cb2, 6)
  float v117 = Material_c6.x;  // %117
  // %118 = v115 * v117
  float v118 = v115 * v117;
  // %119 = saturate(v118)
  float v119 = saturate(v118);

  // Branch: if (cb1_124_w > 0.0) apply volumetric fog
  // %120 = cb1_124_w > 0.0
  float fogResult_x, fogResult_y, fogResult_z, fogResult_w;
  [branch]
  if (cb1_124_w > 0.0f) {
    // Volumetric fog computation
    // %122 = cb1_125_x (VolumetricFogStartDistance)
    // %123 = SV_Position.w
    SV_Position_w = input.SV_Position.w;

    // %124 = cb0_61_z (MatrixTilePosition.z) -- reusing from %54 extractvalue 2
    // %125 = cb0_61_y
    // %126 = cb0_61_x
    // NOTE: In the branch, %124/%125/%126 refer to extractvalue %54, 2/1/0 which is cb0 reg 61
    float matTileX = cb0_61_x;  // %126
    float matTileY = cb0_61_y;  // %125
    float matTileZ = cb0_61_z;  // %124

    // %127 = cb0_7.w (View_TranslatedWorldToClip row3.w)
    float v127 = cb0_7.w;
    // %128 = cb0_6.w
    float v128 = cb0_6.w;
    // %129 = cb0_5.w
    float v129 = cb0_5.w;
    // %130 = cb0_4.w
    float v130 = cb0_4.w;

    // Compute camera-to-pixel offset using ViewTilePosition - MatrixTilePosition
    // %131 = cb0_60_x - matTileX
    // %132 = cb0_60_y - matTileY
    // %133 = cb0_60_z - matTileZ
    float v131 = cb0_60_x - matTileX;
    float v132 = cb0_60_y - matTileY;
    float v133 = cb0_60_z - matTileZ;

    // Scale by 2097152.0 (2^21) for double precision tile offset
    // %134 = v131 * 2097152.0
    // %135 = v132 * 2097152.0
    // %136 = v133 * 2097152.0
    float v134 = v131 * 2097152.0f;
    float v135 = v132 * 2097152.0f;
    float v136 = v133 * 2097152.0f;

    // Add relative world position
    // %137 = v80 + v134
    // %138 = v81 + v135
    // %139 = v82 + v136
    float v137 = v80 + v134;
    float v138 = v81 + v135;
    float v139 = v82 + v136;

    // Clip space W from TranslatedWorldToClip * worldPos
    // %140 = v137 * v130
    // %141 = mad(v138, v129, %140)
    // %142 = mad(v139, v128, %141)
    // %143 = %142 + v127
    float v143 = mad(v139, v128, mad(v138, v129, v137 * v130)) + v127;

    // CB0 reg 229 = View_c229 (VolumetricFogUVMax + related)
    float4 cb0_229 = View_c229;

    // CB0 reg 226 = View_c226 (VolumetricFogGridZParams)
    float4 cb0_226 = View_c226;
    // %146 = cb0_226.x
    float v146 = cb0_226.x;
    // %147 = v146 * v143
    float v147 = v146 * v143;
    // %148 = cb0_226.y
    float v148 = cb0_226.y;
    // %149 = v147 + v148
    float v149 = v147 + v148;
    // %150 = log2(v149)
    float v150 = log2(v149);
    // %151 = cb0_226.z
    float v151 = cb0_226.z;
    // %152 = v151 * v150
    float v152 = v151 * v150;

    // CB0 reg 225 = View_c225 (VolumetricFogSVPosToVolumeUV)
    float4 cb0_225 = View_c225;
    // %154 = cb0_225.z (VolumetricFogGridZParams depth resolution scale)
    float v154 = cb0_225.z;
    // %155 = v152 * v154
    float v155 = v152 * v154;
    // %156 = min(v155, 1.0)
    float v156 = min(v155, 1.0f);

    // Clip-space Y from TranslatedWorldToClip
    // %157 = cb0_7.y
    float v157 = cb0_7.y;
    // %158 = cb0_6.y
    float v158 = cb0_6.y;
    // %159 = cb0_5.y
    float v159 = cb0_5.y;
    // %160 = cb0_4.y
    float v160 = cb0_4.y;

    // %161 = v137 * v160
    // %162 = mad(v138, v159, %161)
    // %163 = mad(v139, v158, %162)
    // %164 = %163 + v157
    float v164 = mad(v139, v158, mad(v138, v159, v137 * v160)) + v157;
    // %165 = v164 / v143
    float v165 = v164 / v143;
    // %166 = v165 * 0.5
    float v166 = v165 * 0.5f;
    // %167 = 0.5 - v166
    float v167 = 0.5f - v166;
    // %168 = cb0_229.y
    float v168 = cb0_229.y;
    // %169 = v167 * v168
    float v169 = v167 * v168;
    // %170 = cb0_229.w
    float v170 = cb0_229.w;
    // %171 = min(v169, v170)
    float v171 = min(v169, v170);

    // Clip-space X from TranslatedWorldToClip
    // %172 = cb0_7.x
    float v172 = cb0_7.x;
    // %173 = cb0_6.x
    float v173 = cb0_6.x;
    // %174 = cb0_5.x
    float v174 = cb0_5.x;
    // %175 = cb0_4.x
    float v175 = cb0_4.x;

    // %176 = v137 * v175
    // %177 = mad(v138, v174, %176)
    // %178 = mad(v139, v173, %177)
    // %179 = %178 + v172
    float v179 = mad(v139, v173, mad(v138, v174, v137 * v175)) + v172;
    // %180 = v179 / v143
    float v180 = v179 / v143;
    // %181 = v180 * 0.5
    float v181 = v180 * 0.5f;
    // %182 = v181 + 0.5
    float v182 = v181 + 0.5f;
    // %183 = cb0_229.x
    float v183 = cb0_229.x;
    // %184 = v182 * v183
    float v184 = v182 * v183;
    // %185 = cb0_229.z
    float v185 = cb0_229.z;
    // %186 = min(v184, v185)
    float v186 = min(v184, v185);

    // Sample IntegratedLightScattering 3D texture
    // %189 = sampleLevel(t1, s1, float3(v186, v171, v156), 0.0)
    float4 fogSample = t1.SampleLevel(s1, float3(v186, v171, v156), 0.0f);
    float v190 = fogSample.x;  // %190
    float v191 = fogSample.y;  // %191
    float v192 = fogSample.z;  // %192
    float v193 = fogSample.w;  // %193

    // CB0 reg 132 = View_c132 (PreExposure related)
    // %194 = cbufferLoadLegacy(cb0, 132)
    // %195 = cb0_132.w (OneOverPreExposure)
    float v195 = View_c132.w;

    // Scale fog by OneOverPreExposure
    // %196 = v195 * v190
    // %197 = v195 * v191
    // %198 = v195 * v192
    float v196 = v195 * v190;
    float v197 = v195 * v191;
    float v198 = v195 * v192;

    // %199 = v193 + (-1.0) [non-fast, preserves NaN]
    float v199 = v193 + (-1.0f);

    // Distance fade for volumetric fog
    // %200 = SV_Position_w - cb1_125_x
    float v200 = SV_Position_w - cb1_125_x;
    // %201 = v200 * 1.0e+08
    float v201 = v200 * 100000000.0f;
    // %202 = saturate(v201)
    float v202 = saturate(v201);

    // Apply fade to fog color and transmittance
    // %203 = v202 * v196
    // %204 = v202 * v197
    // %205 = v202 * v198
    float v203 = v202 * v196;
    float v204 = v202 * v197;
    float v205 = v202 * v198;

    // %206 = v202 * v199
    float v206 = v202 * v199;
    // %207 = v206 + 1.0 (transmittance)
    float v207 = v206 + 1.0f;

    // Apply transmittance to TEXCOORD7 (scene color input)
    // %208 = v207 * TEXCOORD7_x
    // %209 = v207 * TEXCOORD7_y
    // %210 = v207 * TEXCOORD7_z
    float v208 = v207 * TEXCOORD7_x;
    float v209 = v207 * TEXCOORD7_y;
    float v210 = v207 * TEXCOORD7_z;

    // Add in-scattered light
    // %211 = v208 + v203
    // %212 = v209 + v204
    // %213 = v210 + v205
    fogResult_x = v208 + v203;
    fogResult_y = v209 + v204;
    fogResult_z = v210 + v205;

    // %214 = v207 * TEXCOORD7_w
    fogResult_w = v207 * TEXCOORD7_w;
  } else {
    // No fog: pass through TEXCOORD7 directly
    fogResult_x = TEXCOORD7_x;
    fogResult_y = TEXCOORD7_y;
    fogResult_z = TEXCOORD7_z;
    fogResult_w = TEXCOORD7_w;
  }

  // Phi merge: %216-219
  float v216 = fogResult_x;
  float v217 = fogResult_y;
  float v218 = fogResult_z;
  float v219 = fogResult_w;

  // Clamp emissive color to >= 0
  // %220 = max(v111, 0.0)
  // %221 = max(v112, 0.0)
  // %222 = max(v113, 0.0)
  float v220 = max(v111, 0.0f);
  float v221 = max(v112, 0.0f);
  float v222 = max(v113, 0.0f);

  // OutOfBoundsMask check
  // %223 = cbufferLoadLegacy(cb0, 137)
  // %224 = cb0_137.x (View_OutOfBoundsMask)
  float v224 = View_c137.x;

  // Phi outputs for the bounds check branch
  float v310, v311, v312, v313;

  // %225 = v224 > 0.0
  [branch]
  if (v224 > 0.0f) {
    // Out of bounds mask visualization
    // %227 = PRIMITIVE_ID * 41
    uint v227 = PRIMITIVE_ID * 41u;
    // %228 = v227 + 1
    uint v228 = v227 + 1u;

    // Load primitive data from StructuredBuffer
    // %230 = rawBufferLoad(t0, v228, 0) -> float4
    float4 primData1 = t0[v228];  // index = primId*41 + 1
    float v231 = primData1.x;  // %231
    float v232 = primData1.y;  // %232
    float v233 = primData1.z;  // %233

    // %234 = v227 + 18
    uint v234 = v227 + 18u;
    // %235 = rawBufferLoad(t0, v234, 0) -> float4
    float4 primData18 = t0[v234];  // index = primId*41 + 18
    float v236 = primData18.x;  // %236
    float v237 = primData18.y;  // %237
    float v238 = primData18.z;  // %238

    // %239 = v227 + 17
    uint v239 = v227 + 17u;
    // %240 = rawBufferLoad(t0, v239, 0) -> float4
    float4 primData17 = t0[v239];  // index = primId*41 + 17
    float v241 = primData17.w;  // %241 (.w component)

    // %242 = v227 + 24
    uint v242 = v227 + 24u;
    // %243 = rawBufferLoad(t0, v242, 0)
    float4 primData24 = t0[v242];
    float v244 = primData24.w;  // %244

    // %245 = v227 + 25
    uint v245 = v227 + 25u;
    // %246 = rawBufferLoad(t0, v245, 0)
    float4 primData25 = t0[v245];
    float v247 = primData25.w;  // %247

    // %248 = v227 + 31
    uint v248 = v227 + 31u;
    // %249 = rawBufferLoad(t0, v248, 0)
    float4 primData31 = t0[v248];
    float v250 = primData31.x;  // %250 (custom bounds radius)

    // Compute relative position to primitive origin
    // %251 = cb0_60_x - v231
    // %252 = cb0_60_y - v232
    // %253 = cb0_60_z - v233
    float v251 = cb0_60_x - v231;
    float v252 = cb0_60_y - v232;
    float v253 = cb0_60_z - v233;

    // Scale and offset
    // %254 = v251 * 2097152.0
    // %255 = v252 * 2097152.0
    // %256 = v253 * 2097152.0
    float v254 = v251 * 2097152.0f;
    float v255 = v252 * 2097152.0f;
    float v256 = v253 * 2097152.0f;

    // %257 = v254 + v80
    // %258 = v257 - v236
    float v258 = (v254 + v80) - v236;
    // %259 = v255 + v81
    // %260 = v259 - v237
    float v260 = (v255 + v81) - v237;
    // %261 = v256 + v82
    // %262 = v261 - v238
    float v262 = (v256 + v82) - v238;

    // Absolute distance from bounds center
    // %263 = abs(v258)
    // %264 = abs(v260)
    // %265 = abs(v262)
    float v263 = abs(v258);
    float v264 = abs(v260);
    float v265 = abs(v262);

    // Bounds extents + 1
    // %266 = v241 + 1.0
    // %267 = v244 + 1.0
    // %268 = v247 + 1.0
    float v266 = v241 + 1.0f;
    float v267 = v244 + 1.0f;
    float v268 = v247 + 1.0f;

    // Check if outside bounds
    // %269 = v263 > v266
    // %270 = v264 > v267
    // %271 = v265 > v268
    bool b269 = v263 > v266;
    bool b270 = v264 > v267;
    bool b271 = v265 > v268;

    // %272 = b269 || b270
    // %273 = %272 || b271
    bool outsideBounds = b269 || b270 || b271;

    if (outsideBounds) {
      // label %274: dithered out-of-bounds visualization
      // %275 = v81 + v80
      float v275 = v81 + v80;
      // %276 = cb0_60_x + cb0_60_y
      float v276 = cb0_60_x + cb0_60_y;
      // %277 = v275 + v82
      float v277 = v275 + v82;
      // %278 = v276 + cb0_60_z
      float v278 = v276 + cb0_60_z;
      // %279 = v277 * 0x3F52E83A2 (1.1553e-03 approx)
      float v279 = v277 * asfloat(0x3F52E83A);
      // %280 = v278 * 0x40A2E83A2 (2413.9... approx -- actually large)
      float v280 = v278 * asfloat(0x40A2E83A);
      // %281 = frac(v280)
      float v281 = frac(v280);
      // %282 = v281 + v279
      float v282 = v281 + v279;
      // %283 = frac(v282)
      float v283 = frac(v282);
      // %284 = v283 > 0.5
      bool b284 = v283 > 0.5f;
      // %285 = (float)b284
      float v285 = (float)b284;
      // %286 = 1.0 - v285
      float v286 = 1.0f - v285;

      // Output: checkerboard pattern
      v310 = 1.0f;     // alpha = 1.0
      v311 = v286;     // R (inverted checker)
      v312 = 1.0f;     // G = 1.0
      v313 = v285;     // B = checker
    } else {
      // label %287: inside bounds, check custom radius
      // %288 = v250 > 0.0
      if (v250 > 0.0f) {
        // label %289: custom bounds radius fade
        // %290 = v77 - TEXCOORD9_x
        // %291 = v78 - TEXCOORD9_y
        // %292 = v79 - TEXCOORD9_z
        float v290 = v77 - TEXCOORD9_x;
        float v291 = v78 - TEXCOORD9_y;
        float v292 = v79 - TEXCOORD9_z;

        // %293 = abs(v290)
        // %294 = abs(v291)
        // %295 = abs(v292)
        float v293 = abs(v290);
        float v294 = abs(v291);
        float v295 = abs(v292);

        // %296 = max(v294, v295)
        float v296 = max(v294, v295);
        // %297 = max(v293, v296)
        float v297 = max(v293, v296);

        // %298 = v297 - v250
        float v298 = v297 - v250;
        // %299 = abs(v298)
        float v299 = abs(v298);
        // %300 = v299 * 20.0
        float v300 = v299 * 20.0f;
        // %301 = saturate(v300)
        float v301 = saturate(v300);
        // %302 = 1.0 - v301
        float v302 = 1.0f - v301;

        // sign(v302): compare > 0 and < 0, compute sign
        // %303 = v302 > 0.0
        // %304 = v302 < 0.0
        bool b303 = v302 > 0.0f;
        bool b304 = v302 < 0.0f;
        // %305 = (int)b303
        // %306 = (int)b304
        int i305 = (int)b303;
        int i306 = (int)b304;
        // %307 = i305 - i306
        int i307 = i305 - i306;
        // %308 = (float)i307
        float v308 = (float)i307;

        v310 = v308;  // alpha = sign-derived value
        v311 = v302;  // R
        v312 = 0.0f;  // G = 0
        v313 = v302;  // B
      } else {
        // label %287 fallthrough (v250 <= 0): use normal opacity and emissive
        v310 = v119;
        v311 = v220;
        v312 = v221;
        v313 = v222;
      }
    }
  } else {
    // No out-of-bounds check: use normal values
    v310 = v119;
    v311 = v220;
    v312 = v221;
    v313 = v222;
  }

  // Final composite: emissive * alpha + scene color
  // %314 = v311 * v219
  // %315 = v312 * v219
  // %316 = v313 * v219
  float v314 = v311 * v219;
  float v315 = v312 * v219;
  float v316 = v313 * v219;

  // %317 = v314 + v216
  // %318 = v315 + v217
  // %319 = v316 + v218
  float v317 = v314 + v216;
  float v318 = v315 + v217;
  float v319 = v316 + v218;

  // Apply PreExposure
  // %320 = cbufferLoadLegacy(cb0, 132) (already loaded)
  // %321 = cb0_132.z (PreExposure)
  float v321 = View_c132.z;

  // %322 = v321 * v317
  // %323 = v321 * v318
  // %324 = v319 * v321
  float v322 = v321 * v317;
  float v323 = v321 * v318;
  float v324 = v319 * v321;

  // Clamp to 32256.0 (half float max)
  // %325 = min(v322, 32256.0)
  // %326 = min(v323, 32256.0)
  // %327 = min(v324, 32256.0)
  float4 SV_Target;
  SV_Target.x = min(v322, 32256.0f);
  SV_Target.y = min(v323, 32256.0f);
  SV_Target.z = min(v324, 32256.0f);
  SV_Target.w = v310;

  // RenoDX HDR fix: PQ decode → BT.2020 → Neutwo compress → PQ encode
  if (PROCESSING_PATH == 0.f) {
    SV_Target.xyz = renodx::color::pq::DecodeSafe(SV_Target.xyz);
    SV_Target.xyz = renodx::color::bt2020::from::BT709(SV_Target.xyz);
    SV_Target.xyz = renodx::tonemap::neutwo::MaxChannel(SV_Target.xyz);
    SV_Target.xyz = renodx::color::pq::EncodeSafe(SV_Target.xyz, RENODX_GRAPHICS_WHITE_NITS * 3.f);
  }

  return SV_Target;
}
