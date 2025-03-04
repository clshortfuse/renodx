Texture2D<float4> SrcTexture : register(t0);

Texture2D<float4> OCIO_lut1d_0 : register(t1);

Texture3D<float4> OCIO_lut3d_1 : register(t2);

cbuffer HDRMapping : register(b0) {
  float HDRMapping_000x : packoffset(c000.x);
  float HDRMapping_000z : packoffset(c000.z);
  float HDRMapping_009x : packoffset(c009.x);
  float HDRMapping_009y : packoffset(c009.y);
  float HDRMapping_009z : packoffset(c009.z);
  float HDRMapping_009w : packoffset(c009.w);
  float HDRMapping_010x : packoffset(c010.x);
  float HDRMapping_010z : packoffset(c010.z);
  float HDRMapping_014x : packoffset(c014.x);
};

cbuffer OCIOTransformXYZMatrix : register(b1) {
  float OCIOTransformXYZMatrix_000x : packoffset(c000.x);
  float OCIOTransformXYZMatrix_000y : packoffset(c000.y);
  float OCIOTransformXYZMatrix_000z : packoffset(c000.z);
  float OCIOTransformXYZMatrix_001x : packoffset(c001.x);
  float OCIOTransformXYZMatrix_001y : packoffset(c001.y);
  float OCIOTransformXYZMatrix_001z : packoffset(c001.z);
  float OCIOTransformXYZMatrix_002x : packoffset(c002.x);
  float OCIOTransformXYZMatrix_002y : packoffset(c002.y);
  float OCIOTransformXYZMatrix_002z : packoffset(c002.z);
  float OCIOTransformXYZMatrix_004x : packoffset(c004.x);
  float OCIOTransformXYZMatrix_004y : packoffset(c004.y);
  float OCIOTransformXYZMatrix_004z : packoffset(c004.z);
  float OCIOTransformXYZMatrix_005x : packoffset(c005.x);
  float OCIOTransformXYZMatrix_005y : packoffset(c005.y);
  float OCIOTransformXYZMatrix_005z : packoffset(c005.z);
  float OCIOTransformXYZMatrix_006x : packoffset(c006.x);
  float OCIOTransformXYZMatrix_006y : packoffset(c006.y);
  float OCIOTransformXYZMatrix_006z : packoffset(c006.z);
};

SamplerState PointBorder : register(s2, space32);

SamplerState BilinearClamp : register(s5, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  // fn:start 0
  // %1 = call %dx.types.Handle @dx.op.createHandleFromBinding(i32 217, %dx.types.ResBind { i32 2, i32 2, i32 0, i8 0 }, i32 2, i1 false)  ; CreateHandleFromBinding(bind,index,nonUniformIndex)
  // texture _1 = OCIO_lut3d_1;
  // %2 = call %dx.types.Handle @dx.op.createHandleFromBinding(i32 217, %dx.types.ResBind { i32 1, i32 1, i32 0, i8 0 }, i32 1, i1 false)  ; CreateHandleFromBinding(bind,index,nonUniformIndex)
  // texture _2 = OCIO_lut1d_0;
  // %3 = call %dx.types.Handle @dx.op.createHandleFromBinding(i32 217, %dx.types.ResBind zeroinitializer, i32 0, i1 false)  ; CreateHandleFromBinding(bind,index,nonUniformIndex)
  // texture _3 = SrcTexture;
  // %4 = call %dx.types.Handle @dx.op.createHandleFromBinding(i32 217, %dx.types.ResBind { i32 9, i32 9, i32 32, i8 3 }, i32 9, i1 false)  ; CreateHandleFromBinding(bind,index,nonUniformIndex)
  // SamplerState _4 = TrilinearClamp;
  // %5 = call %dx.types.Handle @dx.op.createHandleFromBinding(i32 217, %dx.types.ResBind { i32 5, i32 5, i32 32, i8 3 }, i32 5, i1 false)  ; CreateHandleFromBinding(bind,index,nonUniformIndex)
  // SamplerState _5 = BilinearClamp;
  // %6 = call %dx.types.Handle @dx.op.createHandleFromBinding(i32 217, %dx.types.ResBind { i32 2, i32 2, i32 32, i8 3 }, i32 2, i1 false)  ; CreateHandleFromBinding(bind,index,nonUniformIndex)
  // SamplerState _6 = PointBorder;
  // %7 = call %dx.types.Handle @dx.op.createHandleFromBinding(i32 217, %dx.types.ResBind { i32 1, i32 1, i32 0, i8 2 }, i32 1, i1 false)  ; CreateHandleFromBinding(bind,index,nonUniformIndex)
  // cbuffer _7 = OCIOTransformXYZMatrix;
  // %8 = call %dx.types.Handle @dx.op.createHandleFromBinding(i32 217, %dx.types.ResBind { i32 0, i32 0, i32 0, i8 2 }, i32 0, i1 false)  ; CreateHandleFromBinding(bind,index,nonUniformIndex)
  // cbuffer _8 = HDRMapping;
  // %9 = call %dx.types.Handle @dx.op.annotateHandle(i32 216, %dx.types.Handle %7, %dx.types.ResourceProperties { i32 13, i32 128 })  ; AnnotateHandle(res,props)  resource: CBuffer
  // auto _9 = _7;
  // %10 = call %dx.types.Handle @dx.op.annotateHandle(i32 216, %dx.types.Handle %8, %dx.types.ResourceProperties { i32 13, i32 240 })  ; AnnotateHandle(res,props)  resource: CBuffer
  // auto _10 = _8;
  // %11 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  // float _11 = TEXCOORD.x;
  // %12 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 1, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  // float _12 = TEXCOORD.y;
  // %14 = extractvalue %dx.types.CBufRet.f32 %13, 2
  // float _14 = HDRMapping_000z;
  // %15 = fmul fast float %14, 0x3F847AE140000000
  float _15 = (HDRMapping_000z) * 0.009999999776482582f;
  // %17 = extractvalue %dx.types.CBufRet.f32 %16, 3
  // float _17 = HDRMapping_009w;
  // %18 = fmul fast float %15, %17
  float _18 = _15 * (HDRMapping_009w);
  // %19 = call %dx.types.Handle @dx.op.annotateHandle(i32 216, %dx.types.Handle %3, %dx.types.ResourceProperties { i32 2, i32 1033 })  ; AnnotateHandle(res,props)  resource: Texture2D<4xF32>
  // auto _19 = _3;
  // %20 = call %dx.types.Handle @dx.op.annotateHandle(i32 216, %dx.types.Handle %6, %dx.types.ResourceProperties { i32 14, i32 0 })  ; AnnotateHandle(res,props)  resource: SamplerState
  // auto _20 = _6;
  // %21 = call %dx.types.ResRet.f32 @dx.op.sampleLevel.f32(i32 62, %dx.types.Handle %19, %dx.types.Handle %20, float %11, float %12, float undef, float undef, i32 0, i32 0, i32 undef, float 0.000000e+00)  ; SampleLevel(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,LOD)
  float4 _21 = SrcTexture.SampleLevel(PointBorder, float2((TEXCOORD.x), (TEXCOORD.y)), 0.0f);
  // %22 = extractvalue %dx.types.ResRet.f32 %21, 0
  // float _22 = _21.x;
  // %23 = extractvalue %dx.types.ResRet.f32 %21, 1
  // float _23 = _21.y;
  // %24 = extractvalue %dx.types.ResRet.f32 %21, 2
  // float _24 = _21.z;
  // %25 = extractvalue %dx.types.CBufRet.f32 %13, 0
  // float _25 = HDRMapping_000x;
  // %26 = fmul fast float %25, 0x3F847AE140000000
  float _26 = (HDRMapping_000x) * 0.009999999776482582f;
  // %27 = fmul fast float %26, %22
  // float _27 = _26 * (_21.x);
  // %28 = fmul fast float %26, %23
  float _28 = _26 * (_21.y);
  // %29 = fmul fast float %26, %24
  float _29 = _26 * (_21.z);
  // %31 = extractvalue %dx.types.CBufRet.f32 %30, 0
  // float _31 = OCIOTransformXYZMatrix_004x;
  // %32 = extractvalue %dx.types.CBufRet.f32 %30, 1
  // float _32 = OCIOTransformXYZMatrix_004y;
  // %33 = extractvalue %dx.types.CBufRet.f32 %30, 2
  // float _33 = OCIOTransformXYZMatrix_004z;
  // %35 = extractvalue %dx.types.CBufRet.f32 %34, 0
  // float _35 = OCIOTransformXYZMatrix_005x;
  // %36 = extractvalue %dx.types.CBufRet.f32 %34, 1
  // float _36 = OCIOTransformXYZMatrix_005y;
  // %37 = extractvalue %dx.types.CBufRet.f32 %34, 2
  // float _37 = OCIOTransformXYZMatrix_005z;
  // %39 = extractvalue %dx.types.CBufRet.f32 %38, 0
  // float _39 = OCIOTransformXYZMatrix_006x;
  // %40 = extractvalue %dx.types.CBufRet.f32 %38, 1
  // float _40 = OCIOTransformXYZMatrix_006y;
  // %41 = extractvalue %dx.types.CBufRet.f32 %38, 2
  // float _41 = OCIOTransformXYZMatrix_006z;
  // %43 = extractvalue %dx.types.CBufRet.f32 %42, 0
  // float _43 = OCIOTransformXYZMatrix_000x;
  // %44 = extractvalue %dx.types.CBufRet.f32 %42, 1
  // float _44 = OCIOTransformXYZMatrix_000y;
  // %45 = extractvalue %dx.types.CBufRet.f32 %42, 2
  // float _45 = OCIOTransformXYZMatrix_000z;
  // %47 = extractvalue %dx.types.CBufRet.f32 %46, 0
  // float _47 = OCIOTransformXYZMatrix_001x;
  // %48 = extractvalue %dx.types.CBufRet.f32 %46, 1
  // float _48 = OCIOTransformXYZMatrix_001y;
  // %49 = extractvalue %dx.types.CBufRet.f32 %46, 2
  // float _49 = OCIOTransformXYZMatrix_001z;
  // %51 = extractvalue %dx.types.CBufRet.f32 %50, 0
  // float _51 = OCIOTransformXYZMatrix_002x;
  // %52 = extractvalue %dx.types.CBufRet.f32 %50, 1
  // float _52 = OCIOTransformXYZMatrix_002y;
  // %53 = extractvalue %dx.types.CBufRet.f32 %50, 2
  // float _53 = OCIOTransformXYZMatrix_002z;
  // %54 = fmul fast float %43, 0x3FD6FD2200000000
  // float _54 = (OCIOTransformXYZMatrix_000x) * 0.35920000076293945f;
  // %55 = call float @dx.op.tertiary.f32(i32 46, float 0x3FE652BD40000000, float %47, float %54)  ; FMad(a,b,c)
  // float _55 = mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f));
  // %56 = call float @dx.op.tertiary.f32(i32 46, float 0xBFA25460A0000000, float %51, float %55)  ; FMad(a,b,c)
  // float _56 = mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))));
  // %57 = fmul fast float %44, 0x3FD6FD2200000000
  // float _57 = (OCIOTransformXYZMatrix_000y) * 0.35920000076293945f;
  // %58 = call float @dx.op.tertiary.f32(i32 46, float 0x3FE652BD40000000, float %48, float %57)  ; FMad(a,b,c)
  // float _58 = mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f));
  // %59 = call float @dx.op.tertiary.f32(i32 46, float 0xBFA25460A0000000, float %52, float %58)  ; FMad(a,b,c)
  // float _59 = mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))));
  // %60 = fmul fast float %45, 0x3FD6FD2200000000
  // float _60 = (OCIOTransformXYZMatrix_000z) * 0.35920000076293945f;
  // %61 = call float @dx.op.tertiary.f32(i32 46, float 0x3FE652BD40000000, float %49, float %60)  ; FMad(a,b,c)
  // float _61 = mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f));
  // %62 = call float @dx.op.tertiary.f32(i32 46, float 0xBFA25460A0000000, float %53, float %61)  ; FMad(a,b,c)
  // float _62 = mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))));
  // %63 = fmul fast float %43, 0xBFC89A0280000000
  // float _63 = (OCIOTransformXYZMatrix_000x) * -0.19220000505447388f;
  // %64 = call float @dx.op.tertiary.f32(i32 46, float 0x3FF19B3D00000000, float %47, float %63)  ; FMad(a,b,c)
  // float _64 = mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f));
  // %65 = call float @dx.op.tertiary.f32(i32 46, float 0x3FB353F7C0000000, float %51, float %64)  ; FMad(a,b,c)
  // float _65 = mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))));
  // %66 = fmul fast float %44, 0xBFC89A0280000000
  // float _66 = (OCIOTransformXYZMatrix_000y) * -0.19220000505447388f;
  // %67 = call float @dx.op.tertiary.f32(i32 46, float 0x3FF19B3D00000000, float %48, float %66)  ; FMad(a,b,c)
  // float _67 = mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f));
  // %68 = call float @dx.op.tertiary.f32(i32 46, float 0x3FB353F7C0000000, float %52, float %67)  ; FMad(a,b,c)
  // float _68 = mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))));
  // %69 = fmul fast float %45, 0xBFC89A0280000000
  // float _69 = (OCIOTransformXYZMatrix_000z) * -0.19220000505447388f;
  // %70 = call float @dx.op.tertiary.f32(i32 46, float 0x3FF19B3D00000000, float %49, float %69)  ; FMad(a,b,c)
  // float _70 = mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f));
  // %71 = call float @dx.op.tertiary.f32(i32 46, float 0x3FB353F7C0000000, float %53, float %70)  ; FMad(a,b,c)
  // float _71 = mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))));
  // %72 = fmul fast float %43, 0x3F7CAC0840000000
  // float _72 = (OCIOTransformXYZMatrix_000x) * 0.007000000216066837f;
  // %73 = call float @dx.op.tertiary.f32(i32 46, float 0x3FB32CA580000000, float %47, float %72)  ; FMad(a,b,c)
  // float _73 = mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f));
  // %74 = call float @dx.op.tertiary.f32(i32 46, float 0x3FEAFD2200000000, float %51, float %73)  ; FMad(a,b,c)
  // float _74 = mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))));
  // %75 = fmul fast float %44, 0x3F7CAC0840000000
  // float _75 = (OCIOTransformXYZMatrix_000y) * 0.007000000216066837f;
  // %76 = call float @dx.op.tertiary.f32(i32 46, float 0x3FB32CA580000000, float %48, float %75)  ; FMad(a,b,c)
  // float _76 = mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f));
  // %77 = call float @dx.op.tertiary.f32(i32 46, float 0x3FEAFD2200000000, float %52, float %76)  ; FMad(a,b,c)
  // float _77 = mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))));
  // %78 = fmul fast float %45, 0x3F7CAC0840000000
  // float _78 = (OCIOTransformXYZMatrix_000z) * 0.007000000216066837f;
  // %79 = call float @dx.op.tertiary.f32(i32 46, float 0x3FB32CA580000000, float %49, float %78)  ; FMad(a,b,c)
  // float _79 = mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f));
  // %80 = call float @dx.op.tertiary.f32(i32 46, float 0x3FEAFD2200000000, float %53, float %79)  ; FMad(a,b,c)
  // float _80 = mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))));
  // %81 = fmul fast float %56, 4.096000e+03
  // float _81 = (mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f;
  // %82 = fmul fast float %59, 4.096000e+03
  // float _82 = (mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f;
  // %83 = fmul fast float %62, 4.096000e+03
  // float _83 = (mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))))) * 4096.0f;
  // %84 = call float @dx.op.unary.f32(i32 26, float %81)  ; Round_ne(value)
  // float _84 = round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f));
  // %85 = call float @dx.op.unary.f32(i32 26, float %82)  ; Round_ne(value)
  // float _85 = round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f));
  // %86 = call float @dx.op.unary.f32(i32 26, float %83)  ; Round_ne(value)
  // float _86 = round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))))) * 4096.0f));
  // %87 = fmul fast float %85, 0x3F30000000000000
  // float _87 = (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f;
  // %88 = fmul fast float %86, 0x3F30000000000000
  // float _88 = (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f;
  // %89 = fmul fast float %65, 4.096000e+03
  // float _89 = (mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f;
  // %90 = fmul fast float %68, 4.096000e+03
  // float _90 = (mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f;
  // %91 = fmul fast float %71, 4.096000e+03
  // float _91 = (mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))))) * 4096.0f;
  // %92 = call float @dx.op.unary.f32(i32 26, float %89)  ; Round_ne(value)
  // float _92 = round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f));
  // %93 = call float @dx.op.unary.f32(i32 26, float %90)  ; Round_ne(value)
  // float _93 = round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f));
  // %94 = call float @dx.op.unary.f32(i32 26, float %91)  ; Round_ne(value)
  // float _94 = round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))))) * 4096.0f));
  // %95 = fmul fast float %93, 0x3F30000000000000
  // float _95 = (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f;
  // %96 = fmul fast float %94, 0x3F30000000000000
  // float _96 = (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f;
  // %97 = fmul fast float %74, 4.096000e+03
  // float _97 = (mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f;
  // %98 = fmul fast float %77, 4.096000e+03
  // float _98 = (mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f;
  // %99 = fmul fast float %80, 4.096000e+03
  // float _99 = (mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))))) * 4096.0f;
  // %100 = call float @dx.op.unary.f32(i32 26, float %97)  ; Round_ne(value)
  // float _100 = round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f));
  // %101 = call float @dx.op.unary.f32(i32 26, float %98)  ; Round_ne(value)
  // float _101 = round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f));
  // %102 = call float @dx.op.unary.f32(i32 26, float %99)  ; Round_ne(value)
  // float _102 = round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))))) * 4096.0f));
  // %103 = fmul fast float %101, 0x3F30000000000000
  // float _103 = (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f;
  // %104 = fmul fast float %102, 0x3F30000000000000
  // float _104 = (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f;
  // %105 = fmul fast float %27, 0x3F30000000000000
  float _105 = (_26 * (_21.x)) * 0.000244140625f;
  // %106 = fmul fast float %105, %84
  // float _106 = _105 * (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f)));
  // %107 = call float @dx.op.tertiary.f32(i32 46, float %87, float %28, float %106)  ; FMad(a,b,c)
  // float _107 = mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _28, (_105 * (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f)))));
  // %108 = call float @dx.op.tertiary.f32(i32 46, float %88, float %29, float %107)  ; FMad(a,b,c)
  // float _108 = mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _29, (mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _28, (_105 * (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f)))))));
  // %109 = fmul fast float %105, %92
  // float _109 = _105 * (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f)));
  // %110 = call float @dx.op.tertiary.f32(i32 46, float %95, float %28, float %109)  ; FMad(a,b,c)
  // float _110 = mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _28, (_105 * (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f)))));
  // %111 = call float @dx.op.tertiary.f32(i32 46, float %96, float %29, float %110)  ; FMad(a,b,c)
  // float _111 = mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _29, (mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _28, (_105 * (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f)))))));
  // %112 = fmul fast float %105, %100
  // float _112 = _105 * (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f)));
  // %113 = call float @dx.op.tertiary.f32(i32 46, float %103, float %28, float %112)  ; FMad(a,b,c)
  // float _113 = mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _28, (_105 * (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f)))));
  // %114 = call float @dx.op.tertiary.f32(i32 46, float %104, float %29, float %113)  ; FMad(a,b,c)
  // float _114 = mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _29, (mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _28, (_105 * (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f)))))));
  // %115 = fmul fast float %108, 0x3F847AE140000000
  // float _115 = (mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _29, (mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _28, (_105 * (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f)))))))) * 0.009999999776482582f;
  // %116 = call float @dx.op.unary.f32(i32 23, float %115)  ; Log(value)
  // float _116 = log2(((mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _29, (mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _28, (_105 * (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f)))))))) * 0.009999999776482582f));
  // %117 = fmul fast float %116, 0x3FC4640000000000
  // float _117 = (log2(((mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _29, (mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _28, (_105 * (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f)))))))) * 0.009999999776482582f))) * 0.1593017578125f;
  // %118 = call float @dx.op.unary.f32(i32 21, float %117)  ; Exp(value)
  float _118 = exp2(((log2(((mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _29, (mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _28, (_105 * (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f)))))))) * 0.009999999776482582f))) * 0.1593017578125f));
  // %119 = fmul fast float %118, 0x4032DA0000000000
  // float _119 = _118 * 18.8515625f;
  // %120 = fadd fast float %119, 8.359375e-01
  // float _120 = (_118 * 18.8515625f) + 0.8359375f;
  // %121 = fmul fast float %118, 1.868750e+01
  // float _121 = _118 * 18.6875f;
  // %122 = fadd fast float %121, 1.000000e+00
  // float _122 = (_118 * 18.6875f) + 1.0f;
  // %123 = fdiv fast float %120, %122
  // float _123 = ((_118 * 18.8515625f) + 0.8359375f) / ((_118 * 18.6875f) + 1.0f);
  // %124 = call float @dx.op.unary.f32(i32 23, float %123)  ; Log(value)
  // float _124 = log2((((_118 * 18.8515625f) + 0.8359375f) / ((_118 * 18.6875f) + 1.0f)));
  // %125 = fmul fast float %124, 7.884375e+01
  // float _125 = (log2((((_118 * 18.8515625f) + 0.8359375f) / ((_118 * 18.6875f) + 1.0f)))) * 78.84375f;
  // %126 = call float @dx.op.unary.f32(i32 21, float %125)  ; Exp(value)
  // float _126 = exp2(((log2((((_118 * 18.8515625f) + 0.8359375f) / ((_118 * 18.6875f) + 1.0f)))) * 78.84375f));
  // %127 = call float @dx.op.unary.f32(i32 7, float %126)  ; Saturate(value)
  float _127 = saturate((exp2(((log2((((_118 * 18.8515625f) + 0.8359375f) / ((_118 * 18.6875f) + 1.0f)))) * 78.84375f))));
  // %128 = fmul fast float %111, 0x3F847AE140000000
  // float _128 = (mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _29, (mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _28, (_105 * (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f)))))))) * 0.009999999776482582f;
  // %129 = call float @dx.op.unary.f32(i32 23, float %128)  ; Log(value)
  // float _129 = log2(((mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _29, (mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _28, (_105 * (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f)))))))) * 0.009999999776482582f));
  // %130 = fmul fast float %129, 0x3FC4640000000000
  // float _130 = (log2(((mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _29, (mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _28, (_105 * (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f)))))))) * 0.009999999776482582f))) * 0.1593017578125f;
  // %131 = call float @dx.op.unary.f32(i32 21, float %130)  ; Exp(value)
  float _131 = exp2(((log2(((mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _29, (mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _28, (_105 * (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f)))))))) * 0.009999999776482582f))) * 0.1593017578125f));
  // %132 = fmul fast float %131, 0x4032DA0000000000
  // float _132 = _131 * 18.8515625f;
  // %133 = fadd fast float %132, 8.359375e-01
  // float _133 = (_131 * 18.8515625f) + 0.8359375f;
  // %134 = fmul fast float %131, 1.868750e+01
  // float _134 = _131 * 18.6875f;
  // %135 = fadd fast float %134, 1.000000e+00
  // float _135 = (_131 * 18.6875f) + 1.0f;
  // %136 = fdiv fast float %133, %135
  // float _136 = ((_131 * 18.8515625f) + 0.8359375f) / ((_131 * 18.6875f) + 1.0f);
  // %137 = call float @dx.op.unary.f32(i32 23, float %136)  ; Log(value)
  // float _137 = log2((((_131 * 18.8515625f) + 0.8359375f) / ((_131 * 18.6875f) + 1.0f)));
  // %138 = fmul fast float %137, 7.884375e+01
  // float _138 = (log2((((_131 * 18.8515625f) + 0.8359375f) / ((_131 * 18.6875f) + 1.0f)))) * 78.84375f;
  // %139 = call float @dx.op.unary.f32(i32 21, float %138)  ; Exp(value)
  // float _139 = exp2(((log2((((_131 * 18.8515625f) + 0.8359375f) / ((_131 * 18.6875f) + 1.0f)))) * 78.84375f));
  // %140 = call float @dx.op.unary.f32(i32 7, float %139)  ; Saturate(value)
  float _140 = saturate((exp2(((log2((((_131 * 18.8515625f) + 0.8359375f) / ((_131 * 18.6875f) + 1.0f)))) * 78.84375f))));
  // %141 = fmul fast float %114, 0x3F847AE140000000
  // float _141 = (mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _29, (mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _28, (_105 * (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f)))))))) * 0.009999999776482582f;
  // %142 = call float @dx.op.unary.f32(i32 23, float %141)  ; Log(value)
  // float _142 = log2(((mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _29, (mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _28, (_105 * (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f)))))))) * 0.009999999776482582f));
  // %143 = fmul fast float %142, 0x3FC4640000000000
  // float _143 = (log2(((mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _29, (mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _28, (_105 * (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f)))))))) * 0.009999999776482582f))) * 0.1593017578125f;
  // %144 = call float @dx.op.unary.f32(i32 21, float %143)  ; Exp(value)
  float _144 = exp2(((log2(((mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _29, (mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _28, (_105 * (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f)))))))) * 0.009999999776482582f))) * 0.1593017578125f));
  // %145 = fmul fast float %144, 0x4032DA0000000000
  // float _145 = _144 * 18.8515625f;
  // %146 = fadd fast float %145, 8.359375e-01
  // float _146 = (_144 * 18.8515625f) + 0.8359375f;
  // %147 = fmul fast float %144, 1.868750e+01
  // float _147 = _144 * 18.6875f;
  // %148 = fadd fast float %147, 1.000000e+00
  // float _148 = (_144 * 18.6875f) + 1.0f;
  // %149 = fdiv fast float %146, %148
  // float _149 = ((_144 * 18.8515625f) + 0.8359375f) / ((_144 * 18.6875f) + 1.0f);
  // %150 = call float @dx.op.unary.f32(i32 23, float %149)  ; Log(value)
  // float _150 = log2((((_144 * 18.8515625f) + 0.8359375f) / ((_144 * 18.6875f) + 1.0f)));
  // %151 = fmul fast float %150, 7.884375e+01
  // float _151 = (log2((((_144 * 18.8515625f) + 0.8359375f) / ((_144 * 18.6875f) + 1.0f)))) * 78.84375f;
  // %152 = call float @dx.op.unary.f32(i32 21, float %151)  ; Exp(value)
  // float _152 = exp2(((log2((((_144 * 18.8515625f) + 0.8359375f) / ((_144 * 18.6875f) + 1.0f)))) * 78.84375f));
  // %153 = call float @dx.op.unary.f32(i32 7, float %152)  ; Saturate(value)
  float _153 = saturate((exp2(((log2((((_144 * 18.8515625f) + 0.8359375f) / ((_144 * 18.6875f) + 1.0f)))) * 78.84375f))));
  // %154 = fadd fast float %140, %127
  // float _154 = _140 + _127;
  // %155 = fmul fast float %154, 5.000000e-01
  float _155 = (_140 + _127) * 0.5f;
  // %156 = call float @dx.op.dot3.f32(i32 55, float %127, float %140, float %153, float 6.610000e+03, float -1.361300e+04, float 7.003000e+03)  ; Dot3(ax,ay,az,bx,by,bz)
  // float _156 = dot(float3(_127, _140, _153), float3(6610.0f, -13613.0f, 7003.0f));
  // %157 = fmul fast float %156, 0x3F30000000000000
  // float _157 = (dot(float3(_127, _140, _153), float3(6610.0f, -13613.0f, 7003.0f))) * 0.000244140625f;
  // %158 = call float @dx.op.dot3.f32(i32 55, float %127, float %140, float %153, float 1.793300e+04, float -1.739000e+04, float -5.430000e+02)  ; Dot3(ax,ay,az,bx,by,bz)
  // float _158 = dot(float3(_127, _140, _153), float3(17933.0f, -17390.0f, -543.0f));
  // %159 = fmul fast float %158, 0x3F30000000000000
  // float _159 = (dot(float3(_127, _140, _153), float3(17933.0f, -17390.0f, -543.0f))) * 0.000244140625f;
  // %160 = extractvalue %dx.types.CBufRet.f32 %16, 0
  // float _160 = HDRMapping_009x;
  // %161 = fmul fast float %160, 0x3F847AE140000000
  float _161 = (HDRMapping_009x) * 0.009999999776482582f;
  // %162 = extractvalue %dx.types.CBufRet.f32 %16, 2
  // float _162 = HDRMapping_009z;
  // %163 = fmul fast float %162, 0x3F847AE140000000
  float _163 = (HDRMapping_009z) * 0.009999999776482582f;
  // %164 = extractvalue %dx.types.CBufRet.f32 %16, 1
  // float _164 = HDRMapping_009y;
  // %165 = call float @dx.op.unary.f32(i32 7, float %155)  ; Saturate(value)
  // float _165 = saturate(_155);
  // %166 = call float @dx.op.unary.f32(i32 23, float %165)  ; Log(value)
  // float _166 = log2((saturate(_155)));
  // %167 = fmul fast float %166, 0x3F89F9B580000000
  // float _167 = (log2((saturate(_155)))) * 0.012683313339948654f;
  // %168 = call float @dx.op.unary.f32(i32 21, float %167)  ; Exp(value)
  float _168 = exp2(((log2((saturate(_155)))) * 0.012683313339948654f));
  // %169 = fadd fast float %168, -8.359375e-01
  // float _169 = _168 + -0.8359375f;
  // %170 = call float @dx.op.binary.f32(i32 35, float 0.000000e+00, float %169)  ; FMax(a,b)
  // float _170 = max(0.0f, (_168 + -0.8359375f));
  // %171 = fmul fast float %168, 1.868750e+01
  // float _171 = _168 * 18.6875f;
  // %172 = fsub fast float 0x4032DA0000000000, %171
  // float _172 = 18.8515625f - (_168 * 18.6875f);
  // %173 = fdiv fast float %170, %172
  // float _173 = (max(0.0f, (_168 + -0.8359375f))) / (18.8515625f - (_168 * 18.6875f));
  // %174 = call float @dx.op.unary.f32(i32 23, float %173)  ; Log(value)
  // float _174 = log2(((max(0.0f, (_168 + -0.8359375f))) / (18.8515625f - (_168 * 18.6875f))));
  // %175 = fmul fast float %174, 0x40191C0D60000000
  // float _175 = (log2(((max(0.0f, (_168 + -0.8359375f))) / (18.8515625f - (_168 * 18.6875f))))) * 6.277394771575928f;
  // %176 = call float @dx.op.unary.f32(i32 21, float %175)  ; Exp(value)
  // float _176 = exp2(((log2(((max(0.0f, (_168 + -0.8359375f))) / (18.8515625f - (_168 * 18.6875f))))) * 6.277394771575928f));
  // %177 = fmul fast float %176, 1.000000e+02
  float _177 = (exp2(((log2(((max(0.0f, (_168 + -0.8359375f))) / (18.8515625f - (_168 * 18.6875f))))) * 6.277394771575928f))) * 100.0f;
  // %178 = fcmp fast oeq float %161, 0.000000e+00
  // bool _178 = (_161 == 0.0f);
  float _205;
  float _213 = _177;
  float _258;
  float _263;
  float _370;
  float _399;
  float _426;
  float _598;
  float _599;
  float _600;
  float _601;
  float _602;
  if (!((_161 == 0.0f))) {
    // fn:start 179
    // fn:pending 212
    // %180 = call float @dx.op.binary.f32(i32 35, float %163, float 0.000000e+00)  ; FMax(a,b)
    float _180 = max(_163, 0.0f);
    // %181 = fsub fast float %161, %180
    // float _181 = _161 - _180;
    // %182 = fsub fast float %177, %180
    // float _182 = _177 - _180;
    // %183 = fdiv fast float %182, %181
    // float _183 = (_177 - _180) / (_161 - _180);
    // %184 = call float @dx.op.unary.f32(i32 7, float %183)  ; Saturate(value)
    float _184 = saturate(((_177 - _180) / (_161 - _180)));
    // %185 = fmul fast float %184, 2.000000e+00
    // float _185 = _184 * 2.0f;
    // %186 = fsub fast float 3.000000e+00, %185
    // float _186 = 3.0f - (_184 * 2.0f);
    // %187 = fmul fast float %184, %184
    // float _187 = _184 * _184;
    // %188 = fmul fast float %187, %186
    // float _188 = (_184 * _184) * (3.0f - (_184 * 2.0f));
    // %189 = fsub fast float 1.000000e+00, %188
    // float _189 = 1.0f - ((_184 * _184) * (3.0f - (_184 * 2.0f)));
    // %190 = fcmp fast ugt float %177, %163
    // bool _190 = !(_177 <= _163);
    _205 = 0.0f;
    do {
      if ((!(_177 <= _163))) {
        // fn:start 191
        // fn:pending 212, 204
        // %192 = fcmp fast ult float %163, 0.000000e+00
        // bool _192 = !(_163 >= 0.0f);
        if (!(!(_163 >= 0.0f))) {
          // fn:start 193
          // fn:pending 212, 204
          // %194 = fadd fast float %163, -1.000000e+00
          // float _194 = _163 + -1.0f;
          // %195 = fdiv fast float -1.000000e+00, %194
          float _195 = -1.0f / (_163 + -1.0f);
          // %196 = fsub fast float 1.000000e+00, %195
          // float _196 = 1.0f - _195;
          // %197 = fmul fast float %195, %177
          // float _197 = _195 * _177;
          // %198 = fadd fast float %196, %197
          // float _198 = (1.0f - _195) + (_195 * _177);
          _205 = ((1.0f - _195) + (_195 * _177));
          // fn:converge 193 => 204
        } else {
          // fn:start 199
          // fn:pending 212, 204
          // %200 = fsub fast float -1.000000e+00, %163
          // float _200 = -1.0f - _163;
          // %201 = fsub fast float -0.000000e+00, %163
          // float _201 = -0.0f - _163;
          // %202 = fmul fast float %177, %200
          // float _202 = _177 * (-1.0f - _163);
          // %203 = fsub fast float %201, %202
          // float _203 = (-0.0f - _163) - (_177 * (-1.0f - _163));
          _205 = ((-0.0f - _163) - (_177 * (-1.0f - _163)));
          // fn:converge 199 => 204
        }
      }
      // fn:start 204
      // fn:pending 212
      // %206 = call float @dx.op.unary.f32(i32 23, float %205)  ; Log(value)
      // float _206 = log2(_205);
      // %207 = fmul fast float %206, %164
      // float _207 = (log2(_205)) * (HDRMapping_009y);
      // %208 = call float @dx.op.unary.f32(i32 21, float %207)  ; Exp(value)
      // float _208 = exp2(((log2(_205)) * (HDRMapping_009y)));
      // %209 = fsub fast float %208, %177
      // float _209 = (exp2(((log2(_205)) * (HDRMapping_009y)))) - _177;
      // %210 = fmul fast float %209, %189
      // float _210 = ((exp2(((log2(_205)) * (HDRMapping_009y)))) - _177) * (1.0f - ((_184 * _184) * (3.0f - (_184 * 2.0f))));
      // %211 = fadd fast float %210, %177
      // float _211 = (((exp2(((log2(_205)) * (HDRMapping_009y)))) - _177) * (1.0f - ((_184 * _184) * (3.0f - (_184 * 2.0f))))) + _177;
      _213 = ((((exp2(((log2(_205)) * (HDRMapping_009y)))) - _177) * (1.0f - ((_184 * _184) * (3.0f - (_184 * 2.0f))))) + _177);
      // fn:converge 204 => 212
    } while (false);
  }
  // fn:start 212
  // %214 = fcmp fast oeq float %18, %15
  // bool _214 = (_18 == _15);
  // %215 = fcmp fast ogt float %213, %15
  // bool _215 = (_213 > _15);
  // %216 = and i1 %214, %215
  // bool _216 = ((bool)((_18 == _15))) && ((bool)((_213 > _15)));
  _263 = _15;
  if (!(((bool)((_18 == _15))) && ((bool)((_213 > _15))))) {
    // fn:start 217
    // fn:pending 262
    // %219 = extractvalue %dx.types.CBufRet.f32 %218, 0
    // float _219 = HDRMapping_010x;
    // %220 = fsub fast float 1.000000e+00, %17
    // float _220 = 1.0f - (HDRMapping_009w);
    // %221 = fmul fast float %220, %15
    float _221 = (1.0f - (HDRMapping_009w)) * _15;
    // %222 = fsub fast float %15, %221
    float _222 = _15 - _221;
    // %223 = call float @dx.op.unary.f32(i32 21, float %219)  ; Exp(value)
    float _223 = exp2((HDRMapping_010x));
    // %224 = fdiv fast float 1.000000e+00, %223
    // float _224 = 1.0f / _223;
    // %225 = fmul fast float %224, %213
    // float _225 = (1.0f / _223) * _213;
    // %226 = fdiv fast float %222, %223
    float _226 = _222 / _223;
    // %227 = fsub fast float %15, %226
    float _227 = _15 - _226;
    // %228 = fsub fast float %225, %15
    float _228 = ((1.0f / _223) * _213) - _15;
    // %229 = fcmp olt float %228, -0.000000e+00
    // bool _229 = (_228 < -0.0f);
    _258 = -0.0f;
    do {
      if (((_228 < -0.0f))) {
        // fn:start 230
        // fn:pending 262, 257
        // %232 = extractvalue %dx.types.CBufRet.f32 %231, 0
        // float _232 = HDRMapping_014x;
        // %233 = fadd fast float %232, -5.000000e-01
        // float _233 = (HDRMapping_014x) + -0.5f;
        // %234 = call float @dx.op.binary.f32(i32 36, float %219, float 1.000000e+00)  ; FMin(a,b)
        // float _234 = min((HDRMapping_010x), 1.0f);
        // %235 = fmul fast float %233, %234
        // float _235 = ((HDRMapping_014x) + -0.5f) * (min((HDRMapping_010x), 1.0f));
        // %236 = fadd fast float %235, 5.000000e-01
        // float _236 = (((HDRMapping_014x) + -0.5f) * (min((HDRMapping_010x), 1.0f))) + 0.5f;
        // %237 = fmul fast float %236, 2.000000e+00
        // float _237 = ((((HDRMapping_014x) + -0.5f) * (min((HDRMapping_010x), 1.0f))) + 0.5f) * 2.0f;
        // %238 = fcmp fast oeq float %226, 0.000000e+00
        // bool _238 = (_226 == 0.0f);
        // %239 = fdiv fast float %222, %226
        // float _239 = _222 / _226;
        // %240 = select i1 %238, float 1.000000e+00, float %239
        // float _240 = (((bool)((_226 == 0.0f))) ? 1.0f : (_222 / _226));
        // %241 = fmul fast float %237, %240
        // float _241 = (((((HDRMapping_014x) + -0.5f) * (min((HDRMapping_010x), 1.0f))) + 0.5f) * 2.0f) * ((((bool)((_226 == 0.0f))) ? 1.0f : (_222 / _226)));
        // %242 = fsub fast float -0.000000e+00, %228
        // float _242 = -0.0f - _228;
        // %243 = fmul fast float %241, %227
        // float _243 = ((((((HDRMapping_014x) + -0.5f) * (min((HDRMapping_010x), 1.0f))) + 0.5f) * 2.0f) * ((((bool)((_226 == 0.0f))) ? 1.0f : (_222 / _226)))) * _227;
        // %244 = fdiv fast float %243, %221
        float _244 = (((((((HDRMapping_014x) + -0.5f) * (min((HDRMapping_010x), 1.0f))) + 0.5f) * 2.0f) * ((((bool)((_226 == 0.0f))) ? 1.0f : (_222 / _226)))) * _227) / _221;
        // %245 = call float @dx.op.unary.f32(i32 23, float %221)  ; Log(value)
        // float _245 = log2(_221);
        // %246 = call float @dx.op.unary.f32(i32 23, float %227)  ; Log(value)
        // float _246 = log2(_227);
        // %247 = fmul fast float %244, 0xBFE62E4300000000
        // float _247 = _244 * -0.6931471824645996f;
        // %248 = fmul fast float %247, %246
        // float _248 = (_244 * -0.6931471824645996f) * (log2(_227));
        // %249 = call float @dx.op.unary.f32(i32 23, float %242)  ; Log(value)
        // float _249 = log2((-0.0f - _228));
        // %250 = fmul fast float %249, %244
        // float _250 = (log2((-0.0f - _228))) * _244;
        // %251 = fadd fast float %250, %245
        // float _251 = ((log2((-0.0f - _228))) * _244) + (log2(_221));
        // %252 = fmul fast float %251, 0x3FE62E4300000000
        // float _252 = (((log2((-0.0f - _228))) * _244) + (log2(_221))) * 0.6931471824645996f;
        // %253 = fadd fast float %252, %248
        // float _253 = ((((log2((-0.0f - _228))) * _244) + (log2(_221))) * 0.6931471824645996f) + ((_244 * -0.6931471824645996f) * (log2(_227)));
        // %254 = fmul fast float %253, 0x3FF7154760000000
        // float _254 = (((((log2((-0.0f - _228))) * _244) + (log2(_221))) * 0.6931471824645996f) + ((_244 * -0.6931471824645996f) * (log2(_227)))) * 1.4426950216293335f;
        // %255 = call float @dx.op.unary.f32(i32 21, float %254)  ; Exp(value)
        // float _255 = exp2(((((((log2((-0.0f - _228))) * _244) + (log2(_221))) * 0.6931471824645996f) + ((_244 * -0.6931471824645996f) * (log2(_227)))) * 1.4426950216293335f));
        // %256 = fsub float -0.000000e+00, %255
        // float _256 = -0.0f - (exp2(((((((log2((-0.0f - _228))) * _244) + (log2(_221))) * 0.6931471824645996f) + ((_244 * -0.6931471824645996f) * (log2(_227)))) * 1.4426950216293335f)));
        _258 = (-0.0f - (exp2(((((((log2((-0.0f - _228))) * _244) + (log2(_221))) * 0.6931471824645996f) + ((_244 * -0.6931471824645996f) * (log2(_227)))) * 1.4426950216293335f))));
        // fn:converge 230 => 257
      }
      // fn:start 257
      // fn:pending 262
      // %259 = fadd fast float %258, %15
      // float _259 = _258 + _15;
      // %260 = fcmp fast ole float %213, %18
      // bool _260 = (_213 <= _18);
      // %261 = select i1 %260, float %213, float %259
      // float _261 = (((bool)((_213 <= _18))) ? _213 : (_258 + _15));
      _263 = ((((bool)((_213 <= _18))) ? _213 : (_258 + _15)));
      // fn:converge 257 => 262
    } while (false);
  }
  // fn:start 262
  // %264 = fmul fast float %263, 0x3F847AE140000000
  // float _264 = _263 * 0.009999999776482582f;
  // %265 = call float @dx.op.unary.f32(i32 23, float %264)  ; Log(value)
  // float _265 = log2((_263 * 0.009999999776482582f));
  // %266 = fmul fast float %265, 0x3FC4640000000000
  // float _266 = (log2((_263 * 0.009999999776482582f))) * 0.1593017578125f;
  // %267 = call float @dx.op.unary.f32(i32 21, float %266)  ; Exp(value)
  float _267 = exp2(((log2((_263 * 0.009999999776482582f))) * 0.1593017578125f));
  // %268 = fmul fast float %267, 0x4032DA0000000000
  // float _268 = _267 * 18.8515625f;
  // %269 = fadd fast float %268, 8.359375e-01
  // float _269 = (_267 * 18.8515625f) + 0.8359375f;
  // %270 = fmul fast float %267, 1.868750e+01
  // float _270 = _267 * 18.6875f;
  // %271 = fadd fast float %270, 1.000000e+00
  // float _271 = (_267 * 18.6875f) + 1.0f;
  // %272 = fdiv fast float %269, %271
  // float _272 = ((_267 * 18.8515625f) + 0.8359375f) / ((_267 * 18.6875f) + 1.0f);
  // %273 = call float @dx.op.unary.f32(i32 23, float %272)  ; Log(value)
  // float _273 = log2((((_267 * 18.8515625f) + 0.8359375f) / ((_267 * 18.6875f) + 1.0f)));
  // %274 = fmul fast float %273, 7.884375e+01
  // float _274 = (log2((((_267 * 18.8515625f) + 0.8359375f) / ((_267 * 18.6875f) + 1.0f)))) * 78.84375f;
  // %275 = call float @dx.op.unary.f32(i32 21, float %274)  ; Exp(value)
  // float _275 = exp2(((log2((((_267 * 18.8515625f) + 0.8359375f) / ((_267 * 18.6875f) + 1.0f)))) * 78.84375f));
  // %276 = call float @dx.op.unary.f32(i32 7, float %275)  ; Saturate(value)
  float _276 = saturate((exp2(((log2((((_267 * 18.8515625f) + 0.8359375f) / ((_267 * 18.6875f) + 1.0f)))) * 78.84375f))));
  // %278 = extractvalue %dx.types.CBufRet.f32 %277, 2
  // float _278 = HDRMapping_010z;
  // %279 = fmul fast float %157, %278
  // float _279 = ((dot(float3(_127, _140, _153), float3(6610.0f, -13613.0f, 7003.0f))) * 0.000244140625f) * (HDRMapping_010z);
  // %280 = fmul fast float %159, %278
  // float _280 = ((dot(float3(_127, _140, _153), float3(17933.0f, -17390.0f, -543.0f))) * 0.000244140625f) * (HDRMapping_010z);
  // %281 = fdiv fast float %276, %155
  // float _281 = _276 / _155;
  // %282 = fdiv fast float %155, %276
  // float _282 = _155 / _276;
  // %283 = call float @dx.op.binary.f32(i32 36, float %282, float %281)  ; FMin(a,b)
  float _283 = min((_155 / _276), (_276 / _155));
  // %284 = fmul fast float %279, %283
  float _284 = (((dot(float3(_127, _140, _153), float3(6610.0f, -13613.0f, 7003.0f))) * 0.000244140625f) * (HDRMapping_010z)) * _283;
  // %285 = fmul fast float %280, %283
  float _285 = (((dot(float3(_127, _140, _153), float3(17933.0f, -17390.0f, -543.0f))) * 0.000244140625f) * (HDRMapping_010z)) * _283;
  // %286 = call float @dx.op.tertiary.f32(i32 46, float 0x3F826E9780000000, float %284, float %276)  ; FMad(a,b,c)
  // float _286 = mad(0.008999999612569809f, _284, _276);
  // %287 = call float @dx.op.tertiary.f32(i32 46, float 0x3FBC6A7F00000000, float %285, float %286)  ; FMad(a,b,c)
  // float _287 = mad(0.11100000143051147f, _285, (mad(0.008999999612569809f, _284, _276)));
  // %288 = call float @dx.op.tertiary.f32(i32 46, float 0xBF826E9780000000, float %284, float %276)  ; FMad(a,b,c)
  // float _288 = mad(-0.008999999612569809f, _284, _276);
  // %289 = call float @dx.op.tertiary.f32(i32 46, float 0xBFBC6A7F00000000, float %285, float %288)  ; FMad(a,b,c)
  // float _289 = mad(-0.11100000143051147f, _285, (mad(-0.008999999612569809f, _284, _276)));
  // %290 = call float @dx.op.tertiary.f32(i32 46, float 0x3FE1EB8520000000, float %284, float %276)  ; FMad(a,b,c)
  // float _290 = mad(0.5600000023841858f, _284, _276);
  // %291 = call float @dx.op.tertiary.f32(i32 46, float 0xBFD48B43A0000000, float %285, float %290)  ; FMad(a,b,c)
  // float _291 = mad(-0.32100000977516174f, _285, (mad(0.5600000023841858f, _284, _276)));
  // %292 = call float @dx.op.unary.f32(i32 7, float %287)  ; Saturate(value)
  // float _292 = saturate((mad(0.11100000143051147f, _285, (mad(0.008999999612569809f, _284, _276)))));
  // %293 = call float @dx.op.unary.f32(i32 23, float %292)  ; Log(value)
  // float _293 = log2((saturate((mad(0.11100000143051147f, _285, (mad(0.008999999612569809f, _284, _276)))))));
  // %294 = fmul fast float %293, 0x3F89F9B580000000
  // float _294 = (log2((saturate((mad(0.11100000143051147f, _285, (mad(0.008999999612569809f, _284, _276)))))))) * 0.012683313339948654f;
  // %295 = call float @dx.op.unary.f32(i32 21, float %294)  ; Exp(value)
  float _295 = exp2(((log2((saturate((mad(0.11100000143051147f, _285, (mad(0.008999999612569809f, _284, _276)))))))) * 0.012683313339948654f));
  // %296 = fadd fast float %295, -8.359375e-01
  // float _296 = _295 + -0.8359375f;
  // %297 = call float @dx.op.binary.f32(i32 35, float 0.000000e+00, float %296)  ; FMax(a,b)
  // float _297 = max(0.0f, (_295 + -0.8359375f));
  // %298 = fmul fast float %295, 1.868750e+01
  // float _298 = _295 * 18.6875f;
  // %299 = fsub fast float 0x4032DA0000000000, %298
  // float _299 = 18.8515625f - (_295 * 18.6875f);
  // %300 = fdiv fast float %297, %299
  // float _300 = (max(0.0f, (_295 + -0.8359375f))) / (18.8515625f - (_295 * 18.6875f));
  // %301 = call float @dx.op.unary.f32(i32 23, float %300)  ; Log(value)
  // float _301 = log2(((max(0.0f, (_295 + -0.8359375f))) / (18.8515625f - (_295 * 18.6875f))));
  // %302 = fmul fast float %301, 0x40191C0D60000000
  // float _302 = (log2(((max(0.0f, (_295 + -0.8359375f))) / (18.8515625f - (_295 * 18.6875f))))) * 6.277394771575928f;
  // %303 = call float @dx.op.unary.f32(i32 21, float %302)  ; Exp(value)
  float _303 = exp2(((log2(((max(0.0f, (_295 + -0.8359375f))) / (18.8515625f - (_295 * 18.6875f))))) * 6.277394771575928f));
  // %304 = call float @dx.op.unary.f32(i32 7, float %289)  ; Saturate(value)
  // float _304 = saturate((mad(-0.11100000143051147f, _285, (mad(-0.008999999612569809f, _284, _276)))));
  // %305 = call float @dx.op.unary.f32(i32 23, float %304)  ; Log(value)
  // float _305 = log2((saturate((mad(-0.11100000143051147f, _285, (mad(-0.008999999612569809f, _284, _276)))))));
  // %306 = fmul fast float %305, 0x3F89F9B580000000
  // float _306 = (log2((saturate((mad(-0.11100000143051147f, _285, (mad(-0.008999999612569809f, _284, _276)))))))) * 0.012683313339948654f;
  // %307 = call float @dx.op.unary.f32(i32 21, float %306)  ; Exp(value)
  float _307 = exp2(((log2((saturate((mad(-0.11100000143051147f, _285, (mad(-0.008999999612569809f, _284, _276)))))))) * 0.012683313339948654f));
  // %308 = fadd fast float %307, -8.359375e-01
  // float _308 = _307 + -0.8359375f;
  // %309 = call float @dx.op.binary.f32(i32 35, float 0.000000e+00, float %308)  ; FMax(a,b)
  // float _309 = max(0.0f, (_307 + -0.8359375f));
  // %310 = fmul fast float %307, 1.868750e+01
  // float _310 = _307 * 18.6875f;
  // %311 = fsub fast float 0x4032DA0000000000, %310
  // float _311 = 18.8515625f - (_307 * 18.6875f);
  // %312 = fdiv fast float %309, %311
  // float _312 = (max(0.0f, (_307 + -0.8359375f))) / (18.8515625f - (_307 * 18.6875f));
  // %313 = call float @dx.op.unary.f32(i32 23, float %312)  ; Log(value)
  // float _313 = log2(((max(0.0f, (_307 + -0.8359375f))) / (18.8515625f - (_307 * 18.6875f))));
  // %314 = fmul fast float %313, 0x40191C0D60000000
  // float _314 = (log2(((max(0.0f, (_307 + -0.8359375f))) / (18.8515625f - (_307 * 18.6875f))))) * 6.277394771575928f;
  // %315 = call float @dx.op.unary.f32(i32 21, float %314)  ; Exp(value)
  // float _315 = exp2(((log2(((max(0.0f, (_307 + -0.8359375f))) / (18.8515625f - (_307 * 18.6875f))))) * 6.277394771575928f));
  // %316 = fmul fast float %315, 1.000000e+02
  float _316 = (exp2(((log2(((max(0.0f, (_307 + -0.8359375f))) / (18.8515625f - (_307 * 18.6875f))))) * 6.277394771575928f))) * 100.0f;
  // %317 = call float @dx.op.unary.f32(i32 7, float %291)  ; Saturate(value)
  // float _317 = saturate((mad(-0.32100000977516174f, _285, (mad(0.5600000023841858f, _284, _276)))));
  // %318 = call float @dx.op.unary.f32(i32 23, float %317)  ; Log(value)
  // float _318 = log2((saturate((mad(-0.32100000977516174f, _285, (mad(0.5600000023841858f, _284, _276)))))));
  // %319 = fmul fast float %318, 0x3F89F9B580000000
  // float _319 = (log2((saturate((mad(-0.32100000977516174f, _285, (mad(0.5600000023841858f, _284, _276)))))))) * 0.012683313339948654f;
  // %320 = call float @dx.op.unary.f32(i32 21, float %319)  ; Exp(value)
  float _320 = exp2(((log2((saturate((mad(-0.32100000977516174f, _285, (mad(0.5600000023841858f, _284, _276)))))))) * 0.012683313339948654f));
  // %321 = fadd fast float %320, -8.359375e-01
  // float _321 = _320 + -0.8359375f;
  // %322 = call float @dx.op.binary.f32(i32 35, float 0.000000e+00, float %321)  ; FMax(a,b)
  // float _322 = max(0.0f, (_320 + -0.8359375f));
  // %323 = fmul fast float %320, 1.868750e+01
  // float _323 = _320 * 18.6875f;
  // %324 = fsub fast float 0x4032DA0000000000, %323
  // float _324 = 18.8515625f - (_320 * 18.6875f);
  // %325 = fdiv fast float %322, %324
  // float _325 = (max(0.0f, (_320 + -0.8359375f))) / (18.8515625f - (_320 * 18.6875f));
  // %326 = call float @dx.op.unary.f32(i32 23, float %325)  ; Log(value)
  // float _326 = log2(((max(0.0f, (_320 + -0.8359375f))) / (18.8515625f - (_320 * 18.6875f))));
  // %327 = fmul fast float %326, 0x40191C0D60000000
  // float _327 = (log2(((max(0.0f, (_320 + -0.8359375f))) / (18.8515625f - (_320 * 18.6875f))))) * 6.277394771575928f;
  // %328 = call float @dx.op.unary.f32(i32 21, float %327)  ; Exp(value)
  // float _328 = exp2(((log2(((max(0.0f, (_320 + -0.8359375f))) / (18.8515625f - (_320 * 18.6875f))))) * 6.277394771575928f));
  // %329 = fmul fast float %328, 1.000000e+02
  float _329 = (exp2(((log2(((max(0.0f, (_320 + -0.8359375f))) / (18.8515625f - (_320 * 18.6875f))))) * 6.277394771575928f))) * 100.0f;
  // %330 = fmul fast float %303, 0x4069E33340000000
  // float _330 = _303 * 207.10000610351562f;
  // %331 = call float @dx.op.tertiary.f32(i32 46, float 0xBFF53B6460000000, float %316, float %330)  ; FMad(a,b,c)
  // float _331 = mad(-1.3270000219345093f, _316, (_303 * 207.10000610351562f));
  // %332 = call float @dx.op.tertiary.f32(i32 46, float 0x3FCA7EF9E0000000, float %329, float %331)  ; FMad(a,b,c)
  float _332 = mad(0.2070000022649765f, _329, (mad(-1.3270000219345093f, _316, (_303 * 207.10000610351562f))));
  // %333 = fmul fast float %303, 3.650000e+01
  // float _333 = _303 * 36.5f;
  // %334 = call float @dx.op.tertiary.f32(i32 46, float 0x3FE5CAC080000000, float %316, float %333)  ; FMad(a,b,c)
  // float _334 = mad(0.6809999942779541f, _316, (_303 * 36.5f));
  // %335 = call float @dx.op.tertiary.f32(i32 46, float 0xBFA70A3D80000000, float %329, float %334)  ; FMad(a,b,c)
  float _335 = mad(-0.04500000178813934f, _329, (mad(0.6809999942779541f, _316, (_303 * 36.5f))));
  // %336 = fmul fast float %303, 0xC0139999A0000000
  // float _336 = _303 * -4.900000095367432f;
  // %337 = call float @dx.op.tertiary.f32(i32 46, float 0xBFA99999A0000000, float %316, float %336)  ; FMad(a,b,c)
  // float _337 = mad(-0.05000000074505806f, _316, (_303 * -4.900000095367432f));
  // %338 = call float @dx.op.tertiary.f32(i32 46, float 0x3FF3020C40000000, float %329, float %337)  ; FMad(a,b,c)
  float _338 = mad(1.187999963760376f, _329, (mad(-0.05000000074505806f, _316, (_303 * -4.900000095367432f))));
  // %339 = fmul fast float %332, %31
  // float _339 = _332 * (OCIOTransformXYZMatrix_004x);
  // %340 = call float @dx.op.tertiary.f32(i32 46, float %32, float %335, float %339)  ; FMad(a,b,c)
  // float _340 = mad((OCIOTransformXYZMatrix_004y), _335, (_332 * (OCIOTransformXYZMatrix_004x)));
  // %341 = call float @dx.op.tertiary.f32(i32 46, float %33, float %338, float %340)  ; FMad(a,b,c)
  float _341 = mad((OCIOTransformXYZMatrix_004z), _338, (mad((OCIOTransformXYZMatrix_004y), _335, (_332 * (OCIOTransformXYZMatrix_004x)))));
  // %342 = fmul fast float %332, %35
  // float _342 = _332 * (OCIOTransformXYZMatrix_005x);
  // %343 = call float @dx.op.tertiary.f32(i32 46, float %36, float %335, float %342)  ; FMad(a,b,c)
  // float _343 = mad((OCIOTransformXYZMatrix_005y), _335, (_332 * (OCIOTransformXYZMatrix_005x)));
  // %344 = call float @dx.op.tertiary.f32(i32 46, float %37, float %338, float %343)  ; FMad(a,b,c)
  float _344 = mad((OCIOTransformXYZMatrix_005z), _338, (mad((OCIOTransformXYZMatrix_005y), _335, (_332 * (OCIOTransformXYZMatrix_005x)))));
  // %345 = fmul fast float %332, %39
  // float _345 = _332 * (OCIOTransformXYZMatrix_006x);
  // %346 = call float @dx.op.tertiary.f32(i32 46, float %40, float %335, float %345)  ; FMad(a,b,c)
  // float _346 = mad((OCIOTransformXYZMatrix_006y), _335, (_332 * (OCIOTransformXYZMatrix_006x)));
  // %347 = call float @dx.op.tertiary.f32(i32 46, float %41, float %338, float %346)  ; FMad(a,b,c)
  float _347 = mad((OCIOTransformXYZMatrix_006z), _338, (mad((OCIOTransformXYZMatrix_006y), _335, (_332 * (OCIOTransformXYZMatrix_006x)))));
  // %348 = fmul fast float %341, 0x3FE6412480000000
  // float _348 = _341 * 0.6954519748687744f;
  // %349 = call float @dx.op.tertiary.f32(i32 46, float %344, float 0x3FC201C500000000, float %348)  ; FMad(a,b,c)
  // float _349 = mad(_344, 0.1406790018081665f, (_341 * 0.6954519748687744f));
  // %350 = call float @dx.op.tertiary.f32(i32 46, float %347, float 0x3FC4F9A8C0000000, float %349)  ; FMad(a,b,c)
  float _350 = mad(_347, 0.1638689935207367f, (mad(_344, 0.1406790018081665f, (_341 * 0.6954519748687744f))));
  // %351 = fmul fast float %341, 0x3FA6EF5160000000
  // float _351 = _341 * 0.04479460045695305f;
  // %352 = call float @dx.op.tertiary.f32(i32 46, float %344, float 0x3FEB826CC0000000, float %351)  ; FMad(a,b,c)
  // float _352 = mad(_344, 0.8596709966659546f, (_341 * 0.04479460045695305f));
  // %353 = call float @dx.op.tertiary.f32(i32 46, float %347, float 0x3FB874EFA0000000, float %352)  ; FMad(a,b,c)
  float _353 = mad(_347, 0.0955343022942543f, (mad(_344, 0.8596709966659546f, (_341 * 0.04479460045695305f))));
  // %354 = fmul fast float %341, 0xBF76A24E20000000
  // float _354 = _341 * -0.00552588002756238f;
  // %355 = call float @dx.op.tertiary.f32(i32 46, float %344, float 0x3F707CBD20000000, float %354)  ; FMad(a,b,c)
  // float _355 = mad(_344, 0.004025210160762072f, (_341 * -0.00552588002756238f));
  // %356 = call float @dx.op.tertiary.f32(i32 46, float %347, float 0x3FF00624E0000000, float %355)  ; FMad(a,b,c)
  float _356 = mad(_347, 1.0015000104904175f, (mad(_344, 0.004025210160762072f, (_341 * -0.00552588002756238f))));
  // %357 = call float @dx.op.unary.f32(i32 6, float %350)  ; FAbs(value)
  float _357 = abs(_350);
  // %358 = fcmp fast ogt float %357, 0x3F10000000000000
  // bool _358 = (_357 > 6.103515625e-05f);
  if (((_357 > 6.103515625e-05f))) {
    // fn:start 359
    // fn:pending 369
    // %360 = call float @dx.op.binary.f32(i32 36, float %357, float 6.550400e+04)  ; FMin(a,b)
    float _360 = min(_357, 65504.0f);
    // %361 = call float @dx.op.unary.f32(i32 23, float %360)  ; Log(value)
    // float _361 = log2(_360);
    // %362 = call float @dx.op.unary.f32(i32 27, float %361)  ; Round_ni(value)
    float _362 = floor((log2(_360)));
    // %363 = call float @dx.op.unary.f32(i32 21, float %362)  ; Exp(value)
    float _363 = exp2(_362);
    // %364 = fsub fast float %360, %363
    // float _364 = _360 - _363;
    // %365 = fdiv fast float %364, %363
    // float _365 = (_360 - _363) / _363;
    // %366 = call float @dx.op.dot3.f32(i32 55, float %362, float %365, float 1.500000e+01, float 1.024000e+03, float 1.024000e+03, float 1.024000e+03)  ; Dot3(ax,ay,az,bx,by,bz)
    // float _366 = dot(float3(_362, ((_360 - _363) / _363), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
    _370 = (dot(float3(_362, ((_360 - _363) / _363), 15.0f), float3(1024.0f, 1024.0f, 1024.0f)));
    // fn:converge 359 => 369
  } else {
    // fn:start 367
    // fn:pending 369
    // %368 = fmul fast float %357, 0x4170000000000000
    // float _368 = _357 * 16777216.0f;
    _370 = (_357 * 16777216.0f);
    // fn:converge 367 => 369
  }
  // fn:start 369
  // %371 = fcmp fast ogt float %350, 0.000000e+00
  // bool _371 = (_350 > 0.0f);
  // %372 = select i1 %371, float 0.000000e+00, float 3.276800e+04
  // float _372 = (((bool)((_350 > 0.0f))) ? 0.0f : 32768.0f);
  // %373 = fadd fast float %370, %372
  float _373 = _370 + ((((bool)((_350 > 0.0f))) ? 0.0f : 32768.0f));
  // %374 = fmul fast float %373, 0x3F30010020000000
  // float _374 = _373 * 0.00024420025874860585f;
  // %375 = call float @dx.op.unary.f32(i32 27, float %374)  ; Round_ni(value)
  float _375 = floor((_373 * 0.00024420025874860585f));
  // %376 = fmul fast float %375, 4.095000e+03
  // float _376 = _375 * 4095.0f;
  // %377 = fadd fast float %373, 5.000000e-01
  // float _377 = _373 + 0.5f;
  // %378 = fsub fast float %377, %376
  // float _378 = (_373 + 0.5f) - (_375 * 4095.0f);
  // %379 = fmul fast float %378, 0x3F30000000000000
  // float _379 = ((_373 + 0.5f) - (_375 * 4095.0f)) * 0.000244140625f;
  // %380 = fadd fast float %375, 5.000000e-01
  // float _380 = _375 + 0.5f;
  // %381 = fmul fast float %380, 0x3FAE1E1E20000000
  // float _381 = (_375 + 0.5f) * 0.05882352963089943f;
  // %382 = call %dx.types.Handle @dx.op.annotateHandle(i32 216, %dx.types.Handle %2, %dx.types.ResourceProperties { i32 2, i32 1033 })  ; AnnotateHandle(res,props)  resource: Texture2D<4xF32>
  // auto _382 = _2;
  // %383 = call %dx.types.Handle @dx.op.annotateHandle(i32 216, %dx.types.Handle %5, %dx.types.ResourceProperties { i32 14, i32 0 })  ; AnnotateHandle(res,props)  resource: SamplerState
  // auto _383 = _5;
  // %384 = call %dx.types.ResRet.f32 @dx.op.sampleLevel.f32(i32 62, %dx.types.Handle %382, %dx.types.Handle %383, float %379, float %381, float undef, float undef, i32 0, i32 0, i32 undef, float 0.000000e+00)  ; SampleLevel(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,LOD)
  // float4 _384 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_373 + 0.5f) - (_375 * 4095.0f)) * 0.000244140625f), ((_375 + 0.5f) * 0.05882352963089943f)), 0.0f);
  // %385 = extractvalue %dx.types.ResRet.f32 %384, 0
  // float _385 = ((float4)(OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_373 + 0.5f) - (_375 * 4095.0f)) * 0.000244140625f), ((_375 + 0.5f) * 0.05882352963089943f)), 0.0f))).x;
  // %386 = call float @dx.op.unary.f32(i32 6, float %353)  ; FAbs(value)
  float _386 = abs(_353);
  // %387 = fcmp fast ogt float %386, 0x3F10000000000000
  // bool _387 = (_386 > 6.103515625e-05f);
  if (((_386 > 6.103515625e-05f))) {
    // fn:start 388
    // fn:pending 398
    // %389 = call float @dx.op.binary.f32(i32 36, float %386, float 6.550400e+04)  ; FMin(a,b)
    float _389 = min(_386, 65504.0f);
    // %390 = call float @dx.op.unary.f32(i32 23, float %389)  ; Log(value)
    // float _390 = log2(_389);
    // %391 = call float @dx.op.unary.f32(i32 27, float %390)  ; Round_ni(value)
    float _391 = floor((log2(_389)));
    // %392 = call float @dx.op.unary.f32(i32 21, float %391)  ; Exp(value)
    float _392 = exp2(_391);
    // %393 = fsub fast float %389, %392
    // float _393 = _389 - _392;
    // %394 = fdiv fast float %393, %392
    // float _394 = (_389 - _392) / _392;
    // %395 = call float @dx.op.dot3.f32(i32 55, float %391, float %394, float 1.500000e+01, float 1.024000e+03, float 1.024000e+03, float 1.024000e+03)  ; Dot3(ax,ay,az,bx,by,bz)
    // float _395 = dot(float3(_391, ((_389 - _392) / _392), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
    _399 = (dot(float3(_391, ((_389 - _392) / _392), 15.0f), float3(1024.0f, 1024.0f, 1024.0f)));
    // fn:converge 388 => 398
  } else {
    // fn:start 396
    // fn:pending 398
    // %397 = fmul fast float %386, 0x4170000000000000
    // float _397 = _386 * 16777216.0f;
    _399 = (_386 * 16777216.0f);
    // fn:converge 396 => 398
  }
  // fn:start 398
  // %400 = fcmp fast ogt float %353, 0.000000e+00
  // bool _400 = (_353 > 0.0f);
  // %401 = select i1 %400, float 0.000000e+00, float 3.276800e+04
  // float _401 = (((bool)((_353 > 0.0f))) ? 0.0f : 32768.0f);
  // %402 = fadd fast float %399, %401
  float _402 = _399 + ((((bool)((_353 > 0.0f))) ? 0.0f : 32768.0f));
  // %403 = fmul fast float %402, 0x3F30010020000000
  // float _403 = _402 * 0.00024420025874860585f;
  // %404 = call float @dx.op.unary.f32(i32 27, float %403)  ; Round_ni(value)
  float _404 = floor((_402 * 0.00024420025874860585f));
  // %405 = fmul fast float %404, 4.095000e+03
  // float _405 = _404 * 4095.0f;
  // %406 = fadd fast float %402, 5.000000e-01
  // float _406 = _402 + 0.5f;
  // %407 = fsub fast float %406, %405
  // float _407 = (_402 + 0.5f) - (_404 * 4095.0f);
  // %408 = fmul fast float %407, 0x3F30000000000000
  // float _408 = ((_402 + 0.5f) - (_404 * 4095.0f)) * 0.000244140625f;
  // %409 = fadd fast float %404, 5.000000e-01
  // float _409 = _404 + 0.5f;
  // %410 = fmul fast float %409, 0x3FAE1E1E20000000
  // float _410 = (_404 + 0.5f) * 0.05882352963089943f;
  // %411 = call %dx.types.ResRet.f32 @dx.op.sampleLevel.f32(i32 62, %dx.types.Handle %382, %dx.types.Handle %383, float %408, float %410, float undef, float undef, i32 0, i32 0, i32 undef, float 0.000000e+00)  ; SampleLevel(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,LOD)
  // float4 _411 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_402 + 0.5f) - (_404 * 4095.0f)) * 0.000244140625f), ((_404 + 0.5f) * 0.05882352963089943f)), 0.0f);
  // %412 = extractvalue %dx.types.ResRet.f32 %411, 0
  // float _412 = ((float4)(OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_402 + 0.5f) - (_404 * 4095.0f)) * 0.000244140625f), ((_404 + 0.5f) * 0.05882352963089943f)), 0.0f))).x;
  // %413 = call float @dx.op.unary.f32(i32 6, float %356)  ; FAbs(value)
  float _413 = abs(_356);
  // %414 = fcmp fast ogt float %413, 0x3F10000000000000
  // bool _414 = (_413 > 6.103515625e-05f);
  if (((_413 > 6.103515625e-05f))) {
    // fn:start 415
    // fn:pending 425
    // %416 = call float @dx.op.binary.f32(i32 36, float %413, float 6.550400e+04)  ; FMin(a,b)
    float _416 = min(_413, 65504.0f);
    // %417 = call float @dx.op.unary.f32(i32 23, float %416)  ; Log(value)
    // float _417 = log2(_416);
    // %418 = call float @dx.op.unary.f32(i32 27, float %417)  ; Round_ni(value)
    float _418 = floor((log2(_416)));
    // %419 = call float @dx.op.unary.f32(i32 21, float %418)  ; Exp(value)
    float _419 = exp2(_418);
    // %420 = fsub fast float %416, %419
    // float _420 = _416 - _419;
    // %421 = fdiv fast float %420, %419
    // float _421 = (_416 - _419) / _419;
    // %422 = call float @dx.op.dot3.f32(i32 55, float %418, float %421, float 1.500000e+01, float 1.024000e+03, float 1.024000e+03, float 1.024000e+03)  ; Dot3(ax,ay,az,bx,by,bz)
    // float _422 = dot(float3(_418, ((_416 - _419) / _419), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
    _426 = (dot(float3(_418, ((_416 - _419) / _419), 15.0f), float3(1024.0f, 1024.0f, 1024.0f)));
    // fn:converge 415 => 425
  } else {
    // fn:start 423
    // fn:pending 425
    // %424 = fmul fast float %413, 0x4170000000000000
    // float _424 = _413 * 16777216.0f;
    _426 = (_413 * 16777216.0f);
    // fn:converge 423 => 425
  }
  // fn:start 425
  // %427 = fcmp fast ogt float %356, 0.000000e+00
  // bool _427 = (_356 > 0.0f);
  // %428 = select i1 %427, float 0.000000e+00, float 3.276800e+04
  // float _428 = (((bool)((_356 > 0.0f))) ? 0.0f : 32768.0f);
  // %429 = fadd fast float %426, %428
  float _429 = _426 + ((((bool)((_356 > 0.0f))) ? 0.0f : 32768.0f));
  // %430 = fmul fast float %429, 0x3F30010020000000
  // float _430 = _429 * 0.00024420025874860585f;
  // %431 = call float @dx.op.unary.f32(i32 27, float %430)  ; Round_ni(value)
  float _431 = floor((_429 * 0.00024420025874860585f));
  // %432 = fmul fast float %431, 4.095000e+03
  // float _432 = _431 * 4095.0f;
  // %433 = fadd fast float %429, 5.000000e-01
  // float _433 = _429 + 0.5f;
  // %434 = fsub fast float %433, %432
  // float _434 = (_429 + 0.5f) - (_431 * 4095.0f);
  // %435 = fmul fast float %434, 0x3F30000000000000
  // float _435 = ((_429 + 0.5f) - (_431 * 4095.0f)) * 0.000244140625f;
  // %436 = fadd fast float %431, 5.000000e-01
  // float _436 = _431 + 0.5f;
  // %437 = fmul fast float %436, 0x3FAE1E1E20000000
  // float _437 = (_431 + 0.5f) * 0.05882352963089943f;
  // %438 = call %dx.types.ResRet.f32 @dx.op.sampleLevel.f32(i32 62, %dx.types.Handle %382, %dx.types.Handle %383, float %435, float %437, float undef, float undef, i32 0, i32 0, i32 undef, float 0.000000e+00)  ; SampleLevel(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,LOD)
  // float4 _438 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_429 + 0.5f) - (_431 * 4095.0f)) * 0.000244140625f), ((_431 + 0.5f) * 0.05882352963089943f)), 0.0f);
  // %439 = extractvalue %dx.types.ResRet.f32 %438, 0
  // float _439 = ((float4)(OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_429 + 0.5f) - (_431 * 4095.0f)) * 0.000244140625f), ((_431 + 0.5f) * 0.05882352963089943f)), 0.0f))).x;
  // %440 = fmul fast float %385, 6.400000e+01
  float _440 = (((float4)(OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_373 + 0.5f) - (_375 * 4095.0f)) * 0.000244140625f), ((_375 + 0.5f) * 0.05882352963089943f)), 0.0f))).x) * 64.0f;
  // %441 = fmul fast float %412, 6.400000e+01
  float _441 = (((float4)(OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_402 + 0.5f) - (_404 * 4095.0f)) * 0.000244140625f), ((_404 + 0.5f) * 0.05882352963089943f)), 0.0f))).x) * 64.0f;
  // %442 = fmul fast float %439, 6.400000e+01
  float _442 = (((float4)(OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_429 + 0.5f) - (_431 * 4095.0f)) * 0.000244140625f), ((_431 + 0.5f) * 0.05882352963089943f)), 0.0f))).x) * 64.0f;
  // %443 = call float @dx.op.unary.f32(i32 27, float %440)  ; Round_ni(value)
  float _443 = floor(_440);
  // %444 = call float @dx.op.unary.f32(i32 27, float %441)  ; Round_ni(value)
  float _444 = floor(_441);
  // %445 = call float @dx.op.unary.f32(i32 27, float %442)  ; Round_ni(value)
  float _445 = floor(_442);
  // %446 = fsub fast float %440, %443
  float _446 = _440 - _443;
  // %447 = fsub fast float %441, %444
  float _447 = _441 - _444;
  // %448 = fsub fast float %442, %445
  float _448 = _442 - _445;
  // %449 = fadd fast float %445, 5.000000e-01
  // float _449 = _445 + 0.5f;
  // %450 = fadd fast float %444, 5.000000e-01
  // float _450 = _444 + 0.5f;
  // %451 = fadd fast float %443, 5.000000e-01
  // float _451 = _443 + 0.5f;
  // %452 = fmul fast float %449, 0x3F8F81F820000000
  float _452 = (_445 + 0.5f) * 0.015384615398943424f;
  // %453 = fmul fast float %450, 0x3F8F81F820000000
  float _453 = (_444 + 0.5f) * 0.015384615398943424f;
  // %454 = fmul fast float %451, 0x3F8F81F820000000
  float _454 = (_443 + 0.5f) * 0.015384615398943424f;
  // %455 = call %dx.types.Handle @dx.op.annotateHandle(i32 216, %dx.types.Handle %1, %dx.types.ResourceProperties { i32 4, i32 1033 })  ; AnnotateHandle(res,props)  resource: Texture3D<4xF32>
  // auto _455 = _1;
  // %456 = call %dx.types.Handle @dx.op.annotateHandle(i32 216, %dx.types.Handle %4, %dx.types.ResourceProperties { i32 14, i32 0 })  ; AnnotateHandle(res,props)  resource: SamplerState
  // auto _456 = _4;
  // %457 = call %dx.types.ResRet.f32 @dx.op.sampleLevel.f32(i32 62, %dx.types.Handle %455, %dx.types.Handle %456, float %452, float %453, float %454, float undef, i32 0, i32 0, i32 0, float 0.000000e+00)  ; SampleLevel(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,LOD)
  float4 _457 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_452, _453, _454), 0.0f);
  // %458 = extractvalue %dx.types.ResRet.f32 %457, 0
  // float _458 = _457.x;
  // %459 = extractvalue %dx.types.ResRet.f32 %457, 1
  // float _459 = _457.y;
  // %460 = extractvalue %dx.types.ResRet.f32 %457, 2
  // float _460 = _457.z;
  // %461 = fadd fast float %452, 0x3F8F81F820000000
  float _461 = _452 + 0.015384615398943424f;
  // %462 = fadd fast float %453, 0x3F8F81F820000000
  float _462 = _453 + 0.015384615398943424f;
  // %463 = fadd fast float %454, 0x3F8F81F820000000
  float _463 = _454 + 0.015384615398943424f;
  // %464 = call %dx.types.ResRet.f32 @dx.op.sampleLevel.f32(i32 62, %dx.types.Handle %455, %dx.types.Handle %456, float %461, float %462, float %463, float undef, i32 0, i32 0, i32 0, float 0.000000e+00)  ; SampleLevel(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,LOD)
  float4 _464 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_461, _462, _463), 0.0f);
  // %465 = extractvalue %dx.types.ResRet.f32 %464, 0
  // float _465 = _464.x;
  // %466 = extractvalue %dx.types.ResRet.f32 %464, 1
  // float _466 = _464.y;
  // %467 = extractvalue %dx.types.ResRet.f32 %464, 2
  // float _467 = _464.z;
  // %468 = fcmp fast ult float %446, %447
  // bool _468 = !(_446 >= _447);
  if (!(!(_446 >= _447))) {
    // fn:start 469
    // fn:pending 597
    // %470 = fcmp fast ult float %447, %448
    // bool _470 = !(_447 >= _448);
    if (!(!(_447 >= _448))) {
      // fn:start 471
      // fn:pending 597
      // %472 = call %dx.types.ResRet.f32 @dx.op.sampleLevel.f32(i32 62, %dx.types.Handle %455, %dx.types.Handle %456, float %452, float %453, float %463, float undef, i32 0, i32 0, i32 0, float 0.000000e+00)  ; SampleLevel(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,LOD)
      float4 _472 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_452, _453, _463), 0.0f);
      // %473 = extractvalue %dx.types.ResRet.f32 %472, 0
      // float _473 = _472.x;
      // %474 = extractvalue %dx.types.ResRet.f32 %472, 1
      // float _474 = _472.y;
      // %475 = extractvalue %dx.types.ResRet.f32 %472, 2
      // float _475 = _472.z;
      // %476 = call %dx.types.ResRet.f32 @dx.op.sampleLevel.f32(i32 62, %dx.types.Handle %455, %dx.types.Handle %456, float %452, float %462, float %463, float undef, i32 0, i32 0, i32 0, float 0.000000e+00)  ; SampleLevel(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,LOD)
      float4 _476 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_452, _462, _463), 0.0f);
      // %477 = extractvalue %dx.types.ResRet.f32 %476, 0
      // float _477 = _476.x;
      // %478 = extractvalue %dx.types.ResRet.f32 %476, 1
      // float _478 = _476.y;
      // %479 = extractvalue %dx.types.ResRet.f32 %476, 2
      // float _479 = _476.z;
      // %480 = fsub fast float %446, %447
      float _480 = _446 - _447;
      // %481 = fsub fast float %447, %448
      float _481 = _447 - _448;
      // %482 = fmul fast float %473, %480
      // float _482 = (_472.x) * _480;
      // %483 = fmul fast float %474, %480
      // float _483 = (_472.y) * _480;
      // %484 = fmul fast float %475, %480
      // float _484 = (_472.z) * _480;
      // %485 = fmul fast float %477, %481
      // float _485 = (_476.x) * _481;
      // %486 = fmul fast float %478, %481
      // float _486 = (_476.y) * _481;
      // %487 = fmul fast float %479, %481
      // float _487 = (_476.z) * _481;
      // %488 = fadd fast float %485, %482
      // float _488 = ((_476.x) * _481) + ((_472.x) * _480);
      // %489 = fadd fast float %486, %483
      // float _489 = ((_476.y) * _481) + ((_472.y) * _480);
      // %490 = fadd fast float %487, %484
      // float _490 = ((_476.z) * _481) + ((_472.z) * _480);
      _598 = (((_476.x) * _481) + ((_472.x) * _480));
      _599 = (((_476.y) * _481) + ((_472.y) * _480));
      _600 = (((_476.z) * _481) + ((_472.z) * _480));
      _601 = _446;
      _602 = _448;
      // fn:converge 471 => 597
    } else {
      // fn:start 491
      // fn:pending 597
      // %492 = fcmp fast ult float %446, %448
      // bool _492 = !(_446 >= _448);
      if (!(!(_446 >= _448))) {
        // fn:start 493
        // fn:pending 597
        // %494 = call %dx.types.ResRet.f32 @dx.op.sampleLevel.f32(i32 62, %dx.types.Handle %455, %dx.types.Handle %456, float %452, float %453, float %463, float undef, i32 0, i32 0, i32 0, float 0.000000e+00)  ; SampleLevel(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,LOD)
        float4 _494 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_452, _453, _463), 0.0f);
        // %495 = extractvalue %dx.types.ResRet.f32 %494, 0
        // float _495 = _494.x;
        // %496 = extractvalue %dx.types.ResRet.f32 %494, 1
        // float _496 = _494.y;
        // %497 = extractvalue %dx.types.ResRet.f32 %494, 2
        // float _497 = _494.z;
        // %498 = call %dx.types.ResRet.f32 @dx.op.sampleLevel.f32(i32 62, %dx.types.Handle %455, %dx.types.Handle %456, float %461, float %453, float %463, float undef, i32 0, i32 0, i32 0, float 0.000000e+00)  ; SampleLevel(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,LOD)
        float4 _498 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_461, _453, _463), 0.0f);
        // %499 = extractvalue %dx.types.ResRet.f32 %498, 0
        // float _499 = _498.x;
        // %500 = extractvalue %dx.types.ResRet.f32 %498, 1
        // float _500 = _498.y;
        // %501 = extractvalue %dx.types.ResRet.f32 %498, 2
        // float _501 = _498.z;
        // %502 = fsub fast float %446, %448
        float _502 = _446 - _448;
        // %503 = fsub fast float %448, %447
        float _503 = _448 - _447;
        // %504 = fmul fast float %495, %502
        // float _504 = (_494.x) * _502;
        // %505 = fmul fast float %496, %502
        // float _505 = (_494.y) * _502;
        // %506 = fmul fast float %497, %502
        // float _506 = (_494.z) * _502;
        // %507 = fmul fast float %499, %503
        // float _507 = (_498.x) * _503;
        // %508 = fmul fast float %500, %503
        // float _508 = (_498.y) * _503;
        // %509 = fmul fast float %501, %503
        // float _509 = (_498.z) * _503;
        // %510 = fadd fast float %507, %504
        // float _510 = ((_498.x) * _503) + ((_494.x) * _502);
        // %511 = fadd fast float %508, %505
        // float _511 = ((_498.y) * _503) + ((_494.y) * _502);
        // %512 = fadd fast float %509, %506
        // float _512 = ((_498.z) * _503) + ((_494.z) * _502);
        _598 = (((_498.x) * _503) + ((_494.x) * _502));
        _599 = (((_498.y) * _503) + ((_494.y) * _502));
        _600 = (((_498.z) * _503) + ((_494.z) * _502));
        _601 = _446;
        _602 = _447;
        // fn:converge 493 => 597
      } else {
        // fn:start 513
        // fn:pending 597
        // %514 = call %dx.types.ResRet.f32 @dx.op.sampleLevel.f32(i32 62, %dx.types.Handle %455, %dx.types.Handle %456, float %461, float %453, float %454, float undef, i32 0, i32 0, i32 0, float 0.000000e+00)  ; SampleLevel(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,LOD)
        float4 _514 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_461, _453, _454), 0.0f);
        // %515 = extractvalue %dx.types.ResRet.f32 %514, 0
        // float _515 = _514.x;
        // %516 = extractvalue %dx.types.ResRet.f32 %514, 1
        // float _516 = _514.y;
        // %517 = extractvalue %dx.types.ResRet.f32 %514, 2
        // float _517 = _514.z;
        // %518 = call %dx.types.ResRet.f32 @dx.op.sampleLevel.f32(i32 62, %dx.types.Handle %455, %dx.types.Handle %456, float %461, float %453, float %463, float undef, i32 0, i32 0, i32 0, float 0.000000e+00)  ; SampleLevel(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,LOD)
        float4 _518 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_461, _453, _463), 0.0f);
        // %519 = extractvalue %dx.types.ResRet.f32 %518, 0
        // float _519 = _518.x;
        // %520 = extractvalue %dx.types.ResRet.f32 %518, 1
        // float _520 = _518.y;
        // %521 = extractvalue %dx.types.ResRet.f32 %518, 2
        // float _521 = _518.z;
        // %522 = fsub fast float %448, %446
        float _522 = _448 - _446;
        // %523 = fsub fast float %446, %447
        float _523 = _446 - _447;
        // %524 = fmul fast float %515, %522
        // float _524 = (_514.x) * _522;
        // %525 = fmul fast float %516, %522
        // float _525 = (_514.y) * _522;
        // %526 = fmul fast float %517, %522
        // float _526 = (_514.z) * _522;
        // %527 = fmul fast float %519, %523
        // float _527 = (_518.x) * _523;
        // %528 = fmul fast float %520, %523
        // float _528 = (_518.y) * _523;
        // %529 = fmul fast float %521, %523
        // float _529 = (_518.z) * _523;
        // %530 = fadd fast float %527, %524
        // float _530 = ((_518.x) * _523) + ((_514.x) * _522);
        // %531 = fadd fast float %528, %525
        // float _531 = ((_518.y) * _523) + ((_514.y) * _522);
        // %532 = fadd fast float %529, %526
        // float _532 = ((_518.z) * _523) + ((_514.z) * _522);
        _598 = (((_518.x) * _523) + ((_514.x) * _522));
        _599 = (((_518.y) * _523) + ((_514.y) * _522));
        _600 = (((_518.z) * _523) + ((_514.z) * _522));
        _601 = _448;
        _602 = _447;
        // fn:converge 513 => 597
      }
    }
  } else {
    // fn:start 533
    // fn:pending 597
    // %534 = fcmp fast ugt float %447, %448
    // bool _534 = !(_447 <= _448);
    if (!(!(_447 <= _448))) {
      // fn:start 535
      // fn:pending 597
      // %536 = call %dx.types.ResRet.f32 @dx.op.sampleLevel.f32(i32 62, %dx.types.Handle %455, %dx.types.Handle %456, float %461, float %453, float %454, float undef, i32 0, i32 0, i32 0, float 0.000000e+00)  ; SampleLevel(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,LOD)
      float4 _536 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_461, _453, _454), 0.0f);
      // %537 = extractvalue %dx.types.ResRet.f32 %536, 0
      // float _537 = _536.x;
      // %538 = extractvalue %dx.types.ResRet.f32 %536, 1
      // float _538 = _536.y;
      // %539 = extractvalue %dx.types.ResRet.f32 %536, 2
      // float _539 = _536.z;
      // %540 = call %dx.types.ResRet.f32 @dx.op.sampleLevel.f32(i32 62, %dx.types.Handle %455, %dx.types.Handle %456, float %461, float %462, float %454, float undef, i32 0, i32 0, i32 0, float 0.000000e+00)  ; SampleLevel(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,LOD)
      float4 _540 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_461, _462, _454), 0.0f);
      // %541 = extractvalue %dx.types.ResRet.f32 %540, 0
      // float _541 = _540.x;
      // %542 = extractvalue %dx.types.ResRet.f32 %540, 1
      // float _542 = _540.y;
      // %543 = extractvalue %dx.types.ResRet.f32 %540, 2
      // float _543 = _540.z;
      // %544 = fsub fast float %448, %447
      float _544 = _448 - _447;
      // %545 = fsub fast float %447, %446
      float _545 = _447 - _446;
      // %546 = fmul fast float %537, %544
      // float _546 = (_536.x) * _544;
      // %547 = fmul fast float %538, %544
      // float _547 = (_536.y) * _544;
      // %548 = fmul fast float %539, %544
      // float _548 = (_536.z) * _544;
      // %549 = fmul fast float %541, %545
      // float _549 = (_540.x) * _545;
      // %550 = fmul fast float %542, %545
      // float _550 = (_540.y) * _545;
      // %551 = fmul fast float %543, %545
      // float _551 = (_540.z) * _545;
      // %552 = fadd fast float %549, %546
      // float _552 = ((_540.x) * _545) + ((_536.x) * _544);
      // %553 = fadd fast float %550, %547
      // float _553 = ((_540.y) * _545) + ((_536.y) * _544);
      // %554 = fadd fast float %551, %548
      // float _554 = ((_540.z) * _545) + ((_536.z) * _544);
      _598 = (((_540.x) * _545) + ((_536.x) * _544));
      _599 = (((_540.y) * _545) + ((_536.y) * _544));
      _600 = (((_540.z) * _545) + ((_536.z) * _544));
      _601 = _448;
      _602 = _446;
      // fn:converge 535 => 597
    } else {
      // fn:start 555
      // fn:pending 597
      // %556 = fcmp fast ult float %446, %448
      // bool _556 = !(_446 >= _448);
      if (!(!(_446 >= _448))) {
        // fn:start 557
        // fn:pending 597
        // %558 = call %dx.types.ResRet.f32 @dx.op.sampleLevel.f32(i32 62, %dx.types.Handle %455, %dx.types.Handle %456, float %452, float %462, float %454, float undef, i32 0, i32 0, i32 0, float 0.000000e+00)  ; SampleLevel(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,LOD)
        float4 _558 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_452, _462, _454), 0.0f);
        // %559 = extractvalue %dx.types.ResRet.f32 %558, 0
        // float _559 = _558.x;
        // %560 = extractvalue %dx.types.ResRet.f32 %558, 1
        // float _560 = _558.y;
        // %561 = extractvalue %dx.types.ResRet.f32 %558, 2
        // float _561 = _558.z;
        // %562 = call %dx.types.ResRet.f32 @dx.op.sampleLevel.f32(i32 62, %dx.types.Handle %455, %dx.types.Handle %456, float %452, float %462, float %463, float undef, i32 0, i32 0, i32 0, float 0.000000e+00)  ; SampleLevel(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,LOD)
        float4 _562 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_452, _462, _463), 0.0f);
        // %563 = extractvalue %dx.types.ResRet.f32 %562, 0
        // float _563 = _562.x;
        // %564 = extractvalue %dx.types.ResRet.f32 %562, 1
        // float _564 = _562.y;
        // %565 = extractvalue %dx.types.ResRet.f32 %562, 2
        // float _565 = _562.z;
        // %566 = fsub fast float %447, %446
        float _566 = _447 - _446;
        // %567 = fsub fast float %446, %448
        float _567 = _446 - _448;
        // %568 = fmul fast float %559, %566
        // float _568 = (_558.x) * _566;
        // %569 = fmul fast float %560, %566
        // float _569 = (_558.y) * _566;
        // %570 = fmul fast float %561, %566
        // float _570 = (_558.z) * _566;
        // %571 = fmul fast float %563, %567
        // float _571 = (_562.x) * _567;
        // %572 = fmul fast float %564, %567
        // float _572 = (_562.y) * _567;
        // %573 = fmul fast float %565, %567
        // float _573 = (_562.z) * _567;
        // %574 = fadd fast float %571, %568
        // float _574 = ((_562.x) * _567) + ((_558.x) * _566);
        // %575 = fadd fast float %572, %569
        // float _575 = ((_562.y) * _567) + ((_558.y) * _566);
        // %576 = fadd fast float %573, %570
        // float _576 = ((_562.z) * _567) + ((_558.z) * _566);
        _598 = (((_562.x) * _567) + ((_558.x) * _566));
        _599 = (((_562.y) * _567) + ((_558.y) * _566));
        _600 = (((_562.z) * _567) + ((_558.z) * _566));
        _601 = _447;
        _602 = _448;
        // fn:converge 557 => 597
      } else {
        // fn:start 577
        // fn:pending 597
        // %578 = call %dx.types.ResRet.f32 @dx.op.sampleLevel.f32(i32 62, %dx.types.Handle %455, %dx.types.Handle %456, float %452, float %462, float %454, float undef, i32 0, i32 0, i32 0, float 0.000000e+00)  ; SampleLevel(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,LOD)
        float4 _578 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_452, _462, _454), 0.0f);
        // %579 = extractvalue %dx.types.ResRet.f32 %578, 0
        // float _579 = _578.x;
        // %580 = extractvalue %dx.types.ResRet.f32 %578, 1
        // float _580 = _578.y;
        // %581 = extractvalue %dx.types.ResRet.f32 %578, 2
        // float _581 = _578.z;
        // %582 = call %dx.types.ResRet.f32 @dx.op.sampleLevel.f32(i32 62, %dx.types.Handle %455, %dx.types.Handle %456, float %461, float %462, float %454, float undef, i32 0, i32 0, i32 0, float 0.000000e+00)  ; SampleLevel(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,LOD)
        float4 _582 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_461, _462, _454), 0.0f);
        // %583 = extractvalue %dx.types.ResRet.f32 %582, 0
        // float _583 = _582.x;
        // %584 = extractvalue %dx.types.ResRet.f32 %582, 1
        // float _584 = _582.y;
        // %585 = extractvalue %dx.types.ResRet.f32 %582, 2
        // float _585 = _582.z;
        // %586 = fsub fast float %447, %448
        float _586 = _447 - _448;
        // %587 = fsub fast float %448, %446
        float _587 = _448 - _446;
        // %588 = fmul fast float %579, %586
        // float _588 = (_578.x) * _586;
        // %589 = fmul fast float %580, %586
        // float _589 = (_578.y) * _586;
        // %590 = fmul fast float %581, %586
        // float _590 = (_578.z) * _586;
        // %591 = fmul fast float %583, %587
        // float _591 = (_582.x) * _587;
        // %592 = fmul fast float %584, %587
        // float _592 = (_582.y) * _587;
        // %593 = fmul fast float %585, %587
        // float _593 = (_582.z) * _587;
        // %594 = fadd fast float %591, %588
        // float _594 = ((_582.x) * _587) + ((_578.x) * _586);
        // %595 = fadd fast float %592, %589
        // float _595 = ((_582.y) * _587) + ((_578.y) * _586);
        // %596 = fadd fast float %593, %590
        // float _596 = ((_582.z) * _587) + ((_578.z) * _586);
        _598 = (((_582.x) * _587) + ((_578.x) * _586));
        _599 = (((_582.y) * _587) + ((_578.y) * _586));
        _600 = (((_582.z) * _587) + ((_578.z) * _586));
        _601 = _447;
        _602 = _446;
        // fn:converge 577 => 597
      }
    }
  }
  // fn:start 597
  // %603 = fsub float 1.000000e+00, %601
  float _603 = 1.0f - _601;
  // %604 = fmul fast float %603, %458
  // float _604 = _603 * (_457.x);
  // %605 = fmul fast float %603, %459
  // float _605 = _603 * (_457.y);
  // %606 = fmul fast float %603, %460
  // float _606 = _603 * (_457.z);
  // %607 = fadd fast float %604, %598
  // float _607 = (_603 * (_457.x)) + _598;
  // %608 = fadd fast float %605, %599
  // float _608 = (_603 * (_457.y)) + _599;
  // %609 = fadd fast float %606, %600
  // float _609 = (_603 * (_457.z)) + _600;
  // %610 = fmul fast float %602, %465
  // float _610 = _602 * (_464.x);
  // %611 = fmul fast float %602, %466
  // float _611 = _602 * (_464.y);
  // %612 = fmul fast float %602, %467
  // float _612 = _602 * (_464.z);
  // %613 = fadd fast float %607, %610
  // float _613 = ((_603 * (_457.x)) + _598) + (_602 * (_464.x));
  // %614 = fadd fast float %608, %611
  // float _614 = ((_603 * (_457.y)) + _599) + (_602 * (_464.y));
  // %615 = fadd fast float %609, %612
  // float _615 = ((_603 * (_457.z)) + _600) + (_602 * (_464.z));
  SV_Target.x = (((_603 * (_457.x)) + _598) + (_602 * (_464.x)));
  SV_Target.y = (((_603 * (_457.y)) + _599) + (_602 * (_464.y)));
  SV_Target.z = (((_603 * (_457.z)) + _600) + (_602 * (_464.z)));
  SV_Target.w = 1.0f;
  return SV_Target;
}
