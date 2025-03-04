cbuffer SceneInfo : register(b0) {
  float SceneInfo_023x : packoffset(c023.x);
  float SceneInfo_023y : packoffset(c023.y);
};

cbuffer HDRMapping : register(b1) {
  float HDRMapping_000z : packoffset(c000.z);
  float HDRMapping_009x : packoffset(c009.x);
  float HDRMapping_009y : packoffset(c009.y);
  float HDRMapping_009z : packoffset(c009.z);
  float HDRMapping_009w : packoffset(c009.w);
  float HDRMapping_010x : packoffset(c010.x);
  float HDRMapping_010z : packoffset(c010.z);
  float HDRMapping_010w : packoffset(c010.w);
  float HDRMapping_014x : packoffset(c014.x);
};

cbuffer OCIOTransformXYZMatrix : register(b2) {
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
};

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  // fn:start 0
  // %1 = call %dx.types.Handle @dx.op.createHandleFromBinding(i32 217, %dx.types.ResBind { i32 2, i32 2, i32 0, i8 2 }, i32 2, i1 false)  ; CreateHandleFromBinding(bind,index,nonUniformIndex)
  // cbuffer _1 = OCIOTransformXYZMatrix;
  // %2 = call %dx.types.Handle @dx.op.createHandleFromBinding(i32 217, %dx.types.ResBind { i32 1, i32 1, i32 0, i8 2 }, i32 1, i1 false)  ; CreateHandleFromBinding(bind,index,nonUniformIndex)
  // cbuffer _2 = HDRMapping;
  // %3 = call %dx.types.Handle @dx.op.createHandleFromBinding(i32 217, %dx.types.ResBind { i32 0, i32 0, i32 0, i8 2 }, i32 0, i1 false)  ; CreateHandleFromBinding(bind,index,nonUniformIndex)
  // cbuffer _3 = SceneInfo;
  // %4 = call %dx.types.Handle @dx.op.annotateHandle(i32 216, %dx.types.Handle %1, %dx.types.ResourceProperties { i32 13, i32 128 })  ; AnnotateHandle(res,props)  resource: CBuffer
  // auto _4 = _1;
  // %5 = call %dx.types.Handle @dx.op.annotateHandle(i32 216, %dx.types.Handle %2, %dx.types.ResourceProperties { i32 13, i32 240 })  ; AnnotateHandle(res,props)  resource: CBuffer
  // auto _5 = _2;
  // %6 = call %dx.types.Handle @dx.op.annotateHandle(i32 216, %dx.types.Handle %3, %dx.types.ResourceProperties { i32 13, i32 624 })  ; AnnotateHandle(res,props)  resource: CBuffer
  // auto _6 = _3;
  // %7 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  // float _7 = SV_Position.x;
  // %8 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 1, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  // float _8 = SV_Position.y;
  // %10 = extractvalue %dx.types.CBufRet.f32 %9, 2
  // float _10 = HDRMapping_000z;
  // %11 = fmul fast float %10, 0x3F847AE140000000
  float _11 = (HDRMapping_000z) * 0.009999999776482582f;
  // %13 = extractvalue %dx.types.CBufRet.f32 %12, 3
  // float _13 = HDRMapping_009w;
  // %14 = fmul fast float %11, %13
  float _14 = _11 * (HDRMapping_009w);
  // %17 = extractvalue %dx.types.CBufRet.f32 %16, 3
  // float _17 = HDRMapping_010w;
  // %18 = fmul fast float %17, 0x3F747AE140000000
  float _18 = (HDRMapping_010w) * 0.004999999888241291f;
  // %19 = extractvalue %dx.types.CBufRet.f32 %15, 0
  // float _19 = SceneInfo_023x;
  // %20 = extractvalue %dx.types.CBufRet.f32 %15, 1
  // float _20 = SceneInfo_023y;
  // %21 = fmul fast float %19, 0x3F9EB851E0000000
  float _21 = (SceneInfo_023x) * 0.029999999329447746f;
  // %22 = fmul fast float %20, 0x3FE99999A0000000
  float _22 = (SceneInfo_023y) * 0.800000011920929f;
  // %23 = fcmp fast oge float %7, %21
  // bool _23 = ((SV_Position.x) >= _21);
  // %24 = fmul fast float %19, 0x3FEA8F5C20000000
  // float _24 = (SceneInfo_023x) * 0.8299999833106995f;
  // %25 = fcmp fast ole float %7, %24
  // bool _25 = ((SV_Position.x) <= ((SceneInfo_023x) * 0.8299999833106995f));
  // %26 = and i1 %23, %25
  // bool _26 = ((bool)(((SV_Position.x) >= _21))) && ((bool)(((SV_Position.x) <= ((SceneInfo_023x) * 0.8299999833106995f))));
  // %27 = fcmp fast oge float %8, %22
  // bool _27 = ((SV_Position.y) >= _22);
  // %28 = and i1 %27, %26
  // bool _28 = ((bool)(((SV_Position.y) >= _22))) && ((bool)(((bool)(((SV_Position.x) >= _21))) && ((bool)(((SV_Position.x) <= ((SceneInfo_023x) * 0.8299999833106995f))))));
  // %29 = fcmp fast ole float %8, %20
  // bool _29 = ((SV_Position.y) <= (SceneInfo_023y));
  // %30 = and i1 %29, %28
  // bool _30 = ((bool)(((SV_Position.y) <= (SceneInfo_023y)))) && ((bool)(((bool)(((SV_Position.y) >= _22))) && ((bool)(((bool)(((SV_Position.x) >= _21))) && ((bool)(((SV_Position.x) <= ((SceneInfo_023x) * 0.8299999833106995f))))))));
  float _65;
  float _233;
  float _241;
  float _285;
  float _290;
  float _434 = 0.0f;
  float _435 = 0.0f;
  float _436 = 0.0f;
  float _437 = 0.0f;
  if ((((bool)(((SV_Position.y) <= (SceneInfo_023y)))) && ((bool)(((bool)(((SV_Position.y) >= _22))) && ((bool)(((bool)(((SV_Position.x) >= _21))) && ((bool)(((SV_Position.x) <= ((SceneInfo_023x) * 0.8299999833106995f)))))))))) {
    // fn:start 31
    // fn:pending 433
    // %32 = fmul fast float %20, 0x3FC99999A0000000
    // float _32 = (SceneInfo_023y) * 0.20000000298023224f;
    // %33 = fmul fast float %20, 0x3F4E573AC0000000
    // float _33 = (SceneInfo_023y) * 0.0009259259095415473f;
    // %34 = fmul fast float %19, 0x3F41111120000000
    // float _34 = (SceneInfo_023x) * 0.0005208333604969084f;
    // %35 = fadd fast float %7, -5.000000e-01
    // float _35 = (SV_Position.x) + -0.5f;
    // %36 = fsub fast float %35, %21
    // float _36 = ((SV_Position.x) + -0.5f) - _21;
    // %37 = fsub fast float 5.000000e-01, %8
    // float _37 = 0.5f - (SV_Position.y);
    // %38 = fadd fast float %37, %22
    // float _38 = (0.5f - (SV_Position.y)) + _22;
    // %39 = fadd fast float %38, %32
    // float _39 = ((0.5f - (SV_Position.y)) + _22) + ((SceneInfo_023y) * 0.20000000298023224f);
    // %40 = fmul fast float %36, %18
    // float _40 = (((SV_Position.x) + -0.5f) - _21) * _18;
    // %41 = fmul fast float %39, %18
    // float _41 = (((0.5f - (SV_Position.y)) + _22) + ((SceneInfo_023y) * 0.20000000298023224f)) * _18;
    // %42 = fdiv fast float %40, %34
    float _42 = ((((SV_Position.x) + -0.5f) - _21) * _18) / ((SceneInfo_023x) * 0.0005208333604969084f);
    // %43 = fdiv fast float %41, %33
    float _43 = ((((0.5f - (SV_Position.y)) + _22) + ((SceneInfo_023y) * 0.20000000298023224f)) * _18) / ((SceneInfo_023y) * 0.0009259259095415473f);
    // %44 = fmul fast float %42, 2.000000e+00
    float _44 = _42 * 2.0f;
    // %45 = fsub fast float -0.000000e+00, %44
    // float _45 = -0.0f - _44;
    // %46 = fcmp fast oge float %44, %45
    // bool _46 = (_44 >= (-0.0f - _44));
    // %47 = call float @dx.op.unary.f32(i32 6, float %44)  ; FAbs(value)
    // float _47 = abs(_44);
    // %48 = call float @dx.op.unary.f32(i32 22, float %47)  ; Frc(value)
    float _48 = frac((abs(_44)));
    // %49 = fsub fast float -0.000000e+00, %48
    // float _49 = -0.0f - _48;
    // %50 = select i1 %46, float %48, float %49
    // float _50 = (((bool)((_44 >= (-0.0f - _44)))) ? _48 : (-0.0f - _48));
    // %51 = fmul fast float %50, 5.000000e-01
    // float _51 = ((((bool)((_44 >= (-0.0f - _44)))) ? _48 : (-0.0f - _48))) * 0.5f;
    // %52 = fcmp fast ugt float %51, 0x3F947AE140000000
    bool _52 = !((((((bool)((_44 >= (-0.0f - _44)))) ? _48 : (-0.0f - _48))) * 0.5f) <= 0.019999999552965164f);
    _65 = 0.05999999865889549f;
    do {
      if (_52) {
        // fn:start 53
        // fn:pending 433, 64
        // %54 = fmul fast float %43, 2.000000e+00
        float _54 = _43 * 2.0f;
        // %55 = fsub fast float -0.000000e+00, %54
        // float _55 = -0.0f - _54;
        // %56 = fcmp fast oge float %54, %55
        // bool _56 = (_54 >= (-0.0f - _54));
        // %57 = call float @dx.op.unary.f32(i32 6, float %54)  ; FAbs(value)
        // float _57 = abs(_54);
        // %58 = call float @dx.op.unary.f32(i32 22, float %57)  ; Frc(value)
        float _58 = frac((abs(_54)));
        // %59 = fsub fast float -0.000000e+00, %58
        // float _59 = -0.0f - _58;
        // %60 = select i1 %56, float %58, float %59
        // float _60 = (((bool)((_54 >= (-0.0f - _54)))) ? _58 : (-0.0f - _58));
        // %61 = fmul fast float %60, 5.000000e-01
        // float _61 = ((((bool)((_54 >= (-0.0f - _54)))) ? _58 : (-0.0f - _58))) * 0.5f;
        // %62 = fcmp fast ole float %61, 0x3F947AE140000000
        // bool _62 = ((((((bool)((_54 >= (-0.0f - _54)))) ? _58 : (-0.0f - _58))) * 0.5f) <= 0.019999999552965164f);
        // %63 = select i1 %62, float 0x3FAEB851E0000000, float 0x3FA47AE140000000
        // float _63 = (((bool)(((((((bool)((_54 >= (-0.0f - _54)))) ? _58 : (-0.0f - _58))) * 0.5f) <= 0.019999999552965164f))) ? 0.05999999865889549f : 0.03999999910593033f);
        _65 = ((((bool)(((((((bool)((_54 >= (-0.0f - _54)))) ? _58 : (-0.0f - _58))) * 0.5f) <= 0.019999999552965164f))) ? 0.05999999865889549f : 0.03999999910593033f));
        // fn:converge 53 => 64
      }
      // fn:start 64
      // fn:pending 433
      // %67 = extractvalue %dx.types.CBufRet.f32 %66, 0
      // float _67 = OCIOTransformXYZMatrix_004x;
      // %68 = extractvalue %dx.types.CBufRet.f32 %66, 1
      // float _68 = OCIOTransformXYZMatrix_004y;
      // %69 = extractvalue %dx.types.CBufRet.f32 %66, 2
      // float _69 = OCIOTransformXYZMatrix_004z;
      // %71 = extractvalue %dx.types.CBufRet.f32 %70, 0
      // float _71 = OCIOTransformXYZMatrix_000x;
      // %72 = extractvalue %dx.types.CBufRet.f32 %70, 1
      // float _72 = OCIOTransformXYZMatrix_000y;
      // %73 = extractvalue %dx.types.CBufRet.f32 %70, 2
      // float _73 = OCIOTransformXYZMatrix_000z;
      // %75 = extractvalue %dx.types.CBufRet.f32 %74, 0
      // float _75 = OCIOTransformXYZMatrix_001x;
      // %76 = extractvalue %dx.types.CBufRet.f32 %74, 1
      // float _76 = OCIOTransformXYZMatrix_001y;
      // %77 = extractvalue %dx.types.CBufRet.f32 %74, 2
      // float _77 = OCIOTransformXYZMatrix_001z;
      // %79 = extractvalue %dx.types.CBufRet.f32 %78, 0
      // float _79 = OCIOTransformXYZMatrix_002x;
      // %80 = extractvalue %dx.types.CBufRet.f32 %78, 1
      // float _80 = OCIOTransformXYZMatrix_002y;
      // %81 = extractvalue %dx.types.CBufRet.f32 %78, 2
      // float _81 = OCIOTransformXYZMatrix_002z;
      // %82 = fmul fast float %71, 0x3FD6FD2200000000
      // float _82 = (OCIOTransformXYZMatrix_000x) * 0.35920000076293945f;
      // %83 = call float @dx.op.tertiary.f32(i32 46, float 0x3FE652BD40000000, float %75, float %82)  ; FMad(a,b,c)
      // float _83 = mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f));
      // %84 = call float @dx.op.tertiary.f32(i32 46, float 0xBFA25460A0000000, float %79, float %83)  ; FMad(a,b,c)
      // float _84 = mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))));
      // %85 = fmul fast float %72, 0x3FD6FD2200000000
      // float _85 = (OCIOTransformXYZMatrix_000y) * 0.35920000076293945f;
      // %86 = call float @dx.op.tertiary.f32(i32 46, float 0x3FE652BD40000000, float %76, float %85)  ; FMad(a,b,c)
      // float _86 = mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f));
      // %87 = call float @dx.op.tertiary.f32(i32 46, float 0xBFA25460A0000000, float %80, float %86)  ; FMad(a,b,c)
      // float _87 = mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))));
      // %88 = fmul fast float %73, 0x3FD6FD2200000000
      // float _88 = (OCIOTransformXYZMatrix_000z) * 0.35920000076293945f;
      // %89 = call float @dx.op.tertiary.f32(i32 46, float 0x3FE652BD40000000, float %77, float %88)  ; FMad(a,b,c)
      // float _89 = mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f));
      // %90 = call float @dx.op.tertiary.f32(i32 46, float 0xBFA25460A0000000, float %81, float %89)  ; FMad(a,b,c)
      // float _90 = mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))));
      // %91 = fmul fast float %71, 0xBFC89A0280000000
      // float _91 = (OCIOTransformXYZMatrix_000x) * -0.19220000505447388f;
      // %92 = call float @dx.op.tertiary.f32(i32 46, float 0x3FF19B3D00000000, float %75, float %91)  ; FMad(a,b,c)
      // float _92 = mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f));
      // %93 = call float @dx.op.tertiary.f32(i32 46, float 0x3FB353F7C0000000, float %79, float %92)  ; FMad(a,b,c)
      // float _93 = mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))));
      // %94 = fmul fast float %72, 0xBFC89A0280000000
      // float _94 = (OCIOTransformXYZMatrix_000y) * -0.19220000505447388f;
      // %95 = call float @dx.op.tertiary.f32(i32 46, float 0x3FF19B3D00000000, float %76, float %94)  ; FMad(a,b,c)
      // float _95 = mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f));
      // %96 = call float @dx.op.tertiary.f32(i32 46, float 0x3FB353F7C0000000, float %80, float %95)  ; FMad(a,b,c)
      // float _96 = mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))));
      // %97 = fmul fast float %73, 0xBFC89A0280000000
      // float _97 = (OCIOTransformXYZMatrix_000z) * -0.19220000505447388f;
      // %98 = call float @dx.op.tertiary.f32(i32 46, float 0x3FF19B3D00000000, float %77, float %97)  ; FMad(a,b,c)
      // float _98 = mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f));
      // %99 = call float @dx.op.tertiary.f32(i32 46, float 0x3FB353F7C0000000, float %81, float %98)  ; FMad(a,b,c)
      // float _99 = mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))));
      // %100 = fmul fast float %71, 0x3F7CAC0840000000
      // float _100 = (OCIOTransformXYZMatrix_000x) * 0.007000000216066837f;
      // %101 = call float @dx.op.tertiary.f32(i32 46, float 0x3FB32CA580000000, float %75, float %100)  ; FMad(a,b,c)
      // float _101 = mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f));
      // %102 = call float @dx.op.tertiary.f32(i32 46, float 0x3FEAFD2200000000, float %79, float %101)  ; FMad(a,b,c)
      // float _102 = mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))));
      // %103 = fmul fast float %72, 0x3F7CAC0840000000
      // float _103 = (OCIOTransformXYZMatrix_000y) * 0.007000000216066837f;
      // %104 = call float @dx.op.tertiary.f32(i32 46, float 0x3FB32CA580000000, float %76, float %103)  ; FMad(a,b,c)
      // float _104 = mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f));
      // %105 = call float @dx.op.tertiary.f32(i32 46, float 0x3FEAFD2200000000, float %80, float %104)  ; FMad(a,b,c)
      // float _105 = mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))));
      // %106 = fmul fast float %73, 0x3F7CAC0840000000
      // float _106 = (OCIOTransformXYZMatrix_000z) * 0.007000000216066837f;
      // %107 = call float @dx.op.tertiary.f32(i32 46, float 0x3FB32CA580000000, float %77, float %106)  ; FMad(a,b,c)
      // float _107 = mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f));
      // %108 = call float @dx.op.tertiary.f32(i32 46, float 0x3FEAFD2200000000, float %81, float %107)  ; FMad(a,b,c)
      // float _108 = mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))));
      // %109 = fmul fast float %84, 4.096000e+03
      // float _109 = (mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f;
      // %110 = fmul fast float %87, 4.096000e+03
      // float _110 = (mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f;
      // %111 = fmul fast float %90, 4.096000e+03
      // float _111 = (mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))))) * 4096.0f;
      // %112 = call float @dx.op.unary.f32(i32 26, float %109)  ; Round_ne(value)
      // float _112 = round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f));
      // %113 = call float @dx.op.unary.f32(i32 26, float %110)  ; Round_ne(value)
      // float _113 = round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f));
      // %114 = call float @dx.op.unary.f32(i32 26, float %111)  ; Round_ne(value)
      // float _114 = round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))))) * 4096.0f));
      // %115 = fmul fast float %113, 0x3F30000000000000
      // float _115 = (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f;
      // %116 = fmul fast float %114, 0x3F30000000000000
      // float _116 = (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f;
      // %117 = fmul fast float %93, 4.096000e+03
      // float _117 = (mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f;
      // %118 = fmul fast float %96, 4.096000e+03
      // float _118 = (mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f;
      // %119 = fmul fast float %99, 4.096000e+03
      // float _119 = (mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))))) * 4096.0f;
      // %120 = call float @dx.op.unary.f32(i32 26, float %117)  ; Round_ne(value)
      // float _120 = round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f));
      // %121 = call float @dx.op.unary.f32(i32 26, float %118)  ; Round_ne(value)
      // float _121 = round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f));
      // %122 = call float @dx.op.unary.f32(i32 26, float %119)  ; Round_ne(value)
      // float _122 = round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))))) * 4096.0f));
      // %123 = fmul fast float %121, 0x3F30000000000000
      // float _123 = (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f;
      // %124 = fmul fast float %122, 0x3F30000000000000
      // float _124 = (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f;
      // %125 = fmul fast float %102, 4.096000e+03
      // float _125 = (mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f;
      // %126 = fmul fast float %105, 4.096000e+03
      // float _126 = (mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f;
      // %127 = fmul fast float %108, 4.096000e+03
      // float _127 = (mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))))) * 4096.0f;
      // %128 = call float @dx.op.unary.f32(i32 26, float %125)  ; Round_ne(value)
      // float _128 = round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f));
      // %129 = call float @dx.op.unary.f32(i32 26, float %126)  ; Round_ne(value)
      // float _129 = round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f));
      // %130 = call float @dx.op.unary.f32(i32 26, float %127)  ; Round_ne(value)
      // float _130 = round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))))) * 4096.0f));
      // %131 = fmul fast float %129, 0x3F30000000000000
      // float _131 = (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f;
      // %132 = fmul fast float %130, 0x3F30000000000000
      // float _132 = (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f;
      // %133 = fmul fast float %42, 0x3F30000000000000
      float _133 = _42 * 0.000244140625f;
      // %134 = fmul fast float %133, %112
      // float _134 = _133 * (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f)));
      // %135 = call float @dx.op.tertiary.f32(i32 46, float %115, float %42, float %134)  ; FMad(a,b,c)
      // float _135 = mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _42, (_133 * (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f)))));
      // %136 = call float @dx.op.tertiary.f32(i32 46, float %116, float %42, float %135)  ; FMad(a,b,c)
      // float _136 = mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _42, (mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _42, (_133 * (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f)))))));
      // %137 = fmul fast float %133, %120
      // float _137 = _133 * (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f)));
      // %138 = call float @dx.op.tertiary.f32(i32 46, float %123, float %42, float %137)  ; FMad(a,b,c)
      // float _138 = mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _42, (_133 * (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f)))));
      // %139 = call float @dx.op.tertiary.f32(i32 46, float %124, float %42, float %138)  ; FMad(a,b,c)
      // float _139 = mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _42, (mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _42, (_133 * (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f)))))));
      // %140 = fmul fast float %133, %128
      // float _140 = _133 * (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f)));
      // %141 = call float @dx.op.tertiary.f32(i32 46, float %131, float %42, float %140)  ; FMad(a,b,c)
      // float _141 = mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _42, (_133 * (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f)))));
      // %142 = call float @dx.op.tertiary.f32(i32 46, float %132, float %42, float %141)  ; FMad(a,b,c)
      // float _142 = mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _42, (mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _42, (_133 * (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f)))))));
      // %143 = fmul fast float %136, 0x3F847AE140000000
      // float _143 = (mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _42, (mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _42, (_133 * (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f)))))))) * 0.009999999776482582f;
      // %144 = call float @dx.op.unary.f32(i32 23, float %143)  ; Log(value)
      // float _144 = log2(((mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _42, (mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _42, (_133 * (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f)))))))) * 0.009999999776482582f));
      // %145 = fmul fast float %144, 0x3FC4640000000000
      // float _145 = (log2(((mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _42, (mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _42, (_133 * (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f)))))))) * 0.009999999776482582f))) * 0.1593017578125f;
      // %146 = call float @dx.op.unary.f32(i32 21, float %145)  ; Exp(value)
      float _146 = exp2(((log2(((mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _42, (mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _42, (_133 * (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f)))))))) * 0.009999999776482582f))) * 0.1593017578125f));
      // %147 = fmul fast float %146, 0x4032DA0000000000
      // float _147 = _146 * 18.8515625f;
      // %148 = fadd fast float %147, 8.359375e-01
      // float _148 = (_146 * 18.8515625f) + 0.8359375f;
      // %149 = fmul fast float %146, 1.868750e+01
      // float _149 = _146 * 18.6875f;
      // %150 = fadd fast float %149, 1.000000e+00
      // float _150 = (_146 * 18.6875f) + 1.0f;
      // %151 = fdiv fast float %148, %150
      // float _151 = ((_146 * 18.8515625f) + 0.8359375f) / ((_146 * 18.6875f) + 1.0f);
      // %152 = call float @dx.op.unary.f32(i32 23, float %151)  ; Log(value)
      // float _152 = log2((((_146 * 18.8515625f) + 0.8359375f) / ((_146 * 18.6875f) + 1.0f)));
      // %153 = fmul fast float %152, 7.884375e+01
      // float _153 = (log2((((_146 * 18.8515625f) + 0.8359375f) / ((_146 * 18.6875f) + 1.0f)))) * 78.84375f;
      // %154 = call float @dx.op.unary.f32(i32 21, float %153)  ; Exp(value)
      // float _154 = exp2(((log2((((_146 * 18.8515625f) + 0.8359375f) / ((_146 * 18.6875f) + 1.0f)))) * 78.84375f));
      // %155 = call float @dx.op.unary.f32(i32 7, float %154)  ; Saturate(value)
      float _155 = saturate((exp2(((log2((((_146 * 18.8515625f) + 0.8359375f) / ((_146 * 18.6875f) + 1.0f)))) * 78.84375f))));
      // %156 = fmul fast float %139, 0x3F847AE140000000
      // float _156 = (mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _42, (mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _42, (_133 * (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f)))))))) * 0.009999999776482582f;
      // %157 = call float @dx.op.unary.f32(i32 23, float %156)  ; Log(value)
      // float _157 = log2(((mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _42, (mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _42, (_133 * (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f)))))))) * 0.009999999776482582f));
      // %158 = fmul fast float %157, 0x3FC4640000000000
      // float _158 = (log2(((mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _42, (mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _42, (_133 * (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f)))))))) * 0.009999999776482582f))) * 0.1593017578125f;
      // %159 = call float @dx.op.unary.f32(i32 21, float %158)  ; Exp(value)
      float _159 = exp2(((log2(((mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _42, (mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _42, (_133 * (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f)))))))) * 0.009999999776482582f))) * 0.1593017578125f));
      // %160 = fmul fast float %159, 0x4032DA0000000000
      // float _160 = _159 * 18.8515625f;
      // %161 = fadd fast float %160, 8.359375e-01
      // float _161 = (_159 * 18.8515625f) + 0.8359375f;
      // %162 = fmul fast float %159, 1.868750e+01
      // float _162 = _159 * 18.6875f;
      // %163 = fadd fast float %162, 1.000000e+00
      // float _163 = (_159 * 18.6875f) + 1.0f;
      // %164 = fdiv fast float %161, %163
      // float _164 = ((_159 * 18.8515625f) + 0.8359375f) / ((_159 * 18.6875f) + 1.0f);
      // %165 = call float @dx.op.unary.f32(i32 23, float %164)  ; Log(value)
      // float _165 = log2((((_159 * 18.8515625f) + 0.8359375f) / ((_159 * 18.6875f) + 1.0f)));
      // %166 = fmul fast float %165, 7.884375e+01
      // float _166 = (log2((((_159 * 18.8515625f) + 0.8359375f) / ((_159 * 18.6875f) + 1.0f)))) * 78.84375f;
      // %167 = call float @dx.op.unary.f32(i32 21, float %166)  ; Exp(value)
      // float _167 = exp2(((log2((((_159 * 18.8515625f) + 0.8359375f) / ((_159 * 18.6875f) + 1.0f)))) * 78.84375f));
      // %168 = call float @dx.op.unary.f32(i32 7, float %167)  ; Saturate(value)
      float _168 = saturate((exp2(((log2((((_159 * 18.8515625f) + 0.8359375f) / ((_159 * 18.6875f) + 1.0f)))) * 78.84375f))));
      // %169 = fmul fast float %142, 0x3F847AE140000000
      // float _169 = (mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _42, (mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _42, (_133 * (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f)))))))) * 0.009999999776482582f;
      // %170 = call float @dx.op.unary.f32(i32 23, float %169)  ; Log(value)
      // float _170 = log2(((mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _42, (mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _42, (_133 * (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f)))))))) * 0.009999999776482582f));
      // %171 = fmul fast float %170, 0x3FC4640000000000
      // float _171 = (log2(((mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _42, (mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _42, (_133 * (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f)))))))) * 0.009999999776482582f))) * 0.1593017578125f;
      // %172 = call float @dx.op.unary.f32(i32 21, float %171)  ; Exp(value)
      float _172 = exp2(((log2(((mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _42, (mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _42, (_133 * (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f)))))))) * 0.009999999776482582f))) * 0.1593017578125f));
      // %173 = fmul fast float %172, 0x4032DA0000000000
      // float _173 = _172 * 18.8515625f;
      // %174 = fadd fast float %173, 8.359375e-01
      // float _174 = (_172 * 18.8515625f) + 0.8359375f;
      // %175 = fmul fast float %172, 1.868750e+01
      // float _175 = _172 * 18.6875f;
      // %176 = fadd fast float %175, 1.000000e+00
      // float _176 = (_172 * 18.6875f) + 1.0f;
      // %177 = fdiv fast float %174, %176
      // float _177 = ((_172 * 18.8515625f) + 0.8359375f) / ((_172 * 18.6875f) + 1.0f);
      // %178 = call float @dx.op.unary.f32(i32 23, float %177)  ; Log(value)
      // float _178 = log2((((_172 * 18.8515625f) + 0.8359375f) / ((_172 * 18.6875f) + 1.0f)));
      // %179 = fmul fast float %178, 7.884375e+01
      // float _179 = (log2((((_172 * 18.8515625f) + 0.8359375f) / ((_172 * 18.6875f) + 1.0f)))) * 78.84375f;
      // %180 = call float @dx.op.unary.f32(i32 21, float %179)  ; Exp(value)
      // float _180 = exp2(((log2((((_172 * 18.8515625f) + 0.8359375f) / ((_172 * 18.6875f) + 1.0f)))) * 78.84375f));
      // %181 = call float @dx.op.unary.f32(i32 7, float %180)  ; Saturate(value)
      float _181 = saturate((exp2(((log2((((_172 * 18.8515625f) + 0.8359375f) / ((_172 * 18.6875f) + 1.0f)))) * 78.84375f))));
      // %182 = fadd fast float %168, %155
      // float _182 = _168 + _155;
      // %183 = fmul fast float %182, 5.000000e-01
      float _183 = (_168 + _155) * 0.5f;
      // %184 = call float @dx.op.dot3.f32(i32 55, float %155, float %168, float %181, float 6.610000e+03, float -1.361300e+04, float 7.003000e+03)  ; Dot3(ax,ay,az,bx,by,bz)
      // float _184 = dot(float3(_155, _168, _181), float3(6610.0f, -13613.0f, 7003.0f));
      // %185 = fmul fast float %184, 0x3F30000000000000
      // float _185 = (dot(float3(_155, _168, _181), float3(6610.0f, -13613.0f, 7003.0f))) * 0.000244140625f;
      // %186 = call float @dx.op.dot3.f32(i32 55, float %155, float %168, float %181, float 1.793300e+04, float -1.739000e+04, float -5.430000e+02)  ; Dot3(ax,ay,az,bx,by,bz)
      // float _186 = dot(float3(_155, _168, _181), float3(17933.0f, -17390.0f, -543.0f));
      // %187 = fmul fast float %186, 0x3F30000000000000
      // float _187 = (dot(float3(_155, _168, _181), float3(17933.0f, -17390.0f, -543.0f))) * 0.000244140625f;
      // %188 = extractvalue %dx.types.CBufRet.f32 %12, 0
      // float _188 = HDRMapping_009x;
      // %189 = fmul fast float %188, 0x3F847AE140000000
      float _189 = (HDRMapping_009x) * 0.009999999776482582f;
      // %190 = extractvalue %dx.types.CBufRet.f32 %12, 2
      // float _190 = HDRMapping_009z;
      // %191 = fmul fast float %190, 0x3F847AE140000000
      float _191 = (HDRMapping_009z) * 0.009999999776482582f;
      // %192 = extractvalue %dx.types.CBufRet.f32 %12, 1
      // float _192 = HDRMapping_009y;
      // %193 = call float @dx.op.unary.f32(i32 7, float %183)  ; Saturate(value)
      // float _193 = saturate(_183);
      // %194 = call float @dx.op.unary.f32(i32 23, float %193)  ; Log(value)
      // float _194 = log2((saturate(_183)));
      // %195 = fmul fast float %194, 0x3F89F9B580000000
      // float _195 = (log2((saturate(_183)))) * 0.012683313339948654f;
      // %196 = call float @dx.op.unary.f32(i32 21, float %195)  ; Exp(value)
      float _196 = exp2(((log2((saturate(_183)))) * 0.012683313339948654f));
      // %197 = fadd fast float %196, -8.359375e-01
      // float _197 = _196 + -0.8359375f;
      // %198 = call float @dx.op.binary.f32(i32 35, float 0.000000e+00, float %197)  ; FMax(a,b)
      // float _198 = max(0.0f, (_196 + -0.8359375f));
      // %199 = fmul fast float %196, 1.868750e+01
      // float _199 = _196 * 18.6875f;
      // %200 = fsub fast float 0x4032DA0000000000, %199
      // float _200 = 18.8515625f - (_196 * 18.6875f);
      // %201 = fdiv fast float %198, %200
      // float _201 = (max(0.0f, (_196 + -0.8359375f))) / (18.8515625f - (_196 * 18.6875f));
      // %202 = call float @dx.op.unary.f32(i32 23, float %201)  ; Log(value)
      // float _202 = log2(((max(0.0f, (_196 + -0.8359375f))) / (18.8515625f - (_196 * 18.6875f))));
      // %203 = fmul fast float %202, 0x40191C0D60000000
      // float _203 = (log2(((max(0.0f, (_196 + -0.8359375f))) / (18.8515625f - (_196 * 18.6875f))))) * 6.277394771575928f;
      // %204 = call float @dx.op.unary.f32(i32 21, float %203)  ; Exp(value)
      // float _204 = exp2(((log2(((max(0.0f, (_196 + -0.8359375f))) / (18.8515625f - (_196 * 18.6875f))))) * 6.277394771575928f));
      // %205 = fmul fast float %204, 1.000000e+02
      float _205 = (exp2(((log2(((max(0.0f, (_196 + -0.8359375f))) / (18.8515625f - (_196 * 18.6875f))))) * 6.277394771575928f))) * 100.0f;
      // %206 = fcmp fast oeq float %189, 0.000000e+00
      // bool _206 = (_189 == 0.0f);
      _241 = _205;
      do {
        if (!((_189 == 0.0f))) {
          // fn:start 207
          // fn:pending 433, 240
          // %208 = call float @dx.op.binary.f32(i32 35, float %191, float 0.000000e+00)  ; FMax(a,b)
          float _208 = max(_191, 0.0f);
          // %209 = fsub fast float %189, %208
          // float _209 = _189 - _208;
          // %210 = fsub fast float %205, %208
          // float _210 = _205 - _208;
          // %211 = fdiv fast float %210, %209
          // float _211 = (_205 - _208) / (_189 - _208);
          // %212 = call float @dx.op.unary.f32(i32 7, float %211)  ; Saturate(value)
          float _212 = saturate(((_205 - _208) / (_189 - _208)));
          // %213 = fmul fast float %212, 2.000000e+00
          // float _213 = _212 * 2.0f;
          // %214 = fsub fast float 3.000000e+00, %213
          // float _214 = 3.0f - (_212 * 2.0f);
          // %215 = fmul fast float %212, %212
          // float _215 = _212 * _212;
          // %216 = fmul fast float %215, %214
          // float _216 = (_212 * _212) * (3.0f - (_212 * 2.0f));
          // %217 = fsub fast float 1.000000e+00, %216
          // float _217 = 1.0f - ((_212 * _212) * (3.0f - (_212 * 2.0f)));
          // %218 = fcmp fast ugt float %205, %191
          // bool _218 = !(_205 <= _191);
          _233 = 0.0f;
          do {
            if ((!(_205 <= _191))) {
              // fn:start 219
              // fn:pending 433, 240, 232
              // %220 = fcmp fast ult float %191, 0.000000e+00
              // bool _220 = !(_191 >= 0.0f);
              if (!(!(_191 >= 0.0f))) {
                // fn:start 221
                // fn:pending 433, 240, 232
                // %222 = fadd fast float %191, -1.000000e+00
                // float _222 = _191 + -1.0f;
                // %223 = fdiv fast float -1.000000e+00, %222
                float _223 = -1.0f / (_191 + -1.0f);
                // %224 = fsub fast float 1.000000e+00, %223
                // float _224 = 1.0f - _223;
                // %225 = fmul fast float %223, %205
                // float _225 = _223 * _205;
                // %226 = fadd fast float %224, %225
                // float _226 = (1.0f - _223) + (_223 * _205);
                _233 = ((1.0f - _223) + (_223 * _205));
                // fn:converge 221 => 232
              } else {
                // fn:start 227
                // fn:pending 433, 240, 232
                // %228 = fsub fast float -1.000000e+00, %191
                // float _228 = -1.0f - _191;
                // %229 = fsub fast float -0.000000e+00, %191
                // float _229 = -0.0f - _191;
                // %230 = fmul fast float %205, %228
                // float _230 = _205 * (-1.0f - _191);
                // %231 = fsub fast float %229, %230
                // float _231 = (-0.0f - _191) - (_205 * (-1.0f - _191));
                _233 = ((-0.0f - _191) - (_205 * (-1.0f - _191)));
                // fn:converge 227 => 232
              }
            }
            // fn:start 232
            // fn:pending 433, 240
            // %234 = call float @dx.op.unary.f32(i32 23, float %233)  ; Log(value)
            // float _234 = log2(_233);
            // %235 = fmul fast float %234, %192
            // float _235 = (log2(_233)) * (HDRMapping_009y);
            // %236 = call float @dx.op.unary.f32(i32 21, float %235)  ; Exp(value)
            // float _236 = exp2(((log2(_233)) * (HDRMapping_009y)));
            // %237 = fsub fast float %236, %205
            // float _237 = (exp2(((log2(_233)) * (HDRMapping_009y)))) - _205;
            // %238 = fmul fast float %237, %217
            // float _238 = ((exp2(((log2(_233)) * (HDRMapping_009y)))) - _205) * (1.0f - ((_212 * _212) * (3.0f - (_212 * 2.0f))));
            // %239 = fadd fast float %238, %205
            // float _239 = (((exp2(((log2(_233)) * (HDRMapping_009y)))) - _205) * (1.0f - ((_212 * _212) * (3.0f - (_212 * 2.0f))))) + _205;
            _241 = ((((exp2(((log2(_233)) * (HDRMapping_009y)))) - _205) * (1.0f - ((_212 * _212) * (3.0f - (_212 * 2.0f))))) + _205);
            // fn:converge 232 => 240
          } while (false);
        }
        // fn:start 240
        // fn:pending 433
        // %242 = fcmp fast oeq float %14, %11
        // bool _242 = (_14 == _11);
        // %243 = fcmp fast ogt float %241, %11
        // bool _243 = (_241 > _11);
        // %244 = and i1 %242, %243
        // bool _244 = ((bool)((_14 == _11))) && ((bool)((_241 > _11)));
        _290 = _11;
        do {
          if (!(((bool)((_14 == _11))) && ((bool)((_241 > _11))))) {
            // fn:start 245
            // fn:pending 433, 289
            // %246 = extractvalue %dx.types.CBufRet.f32 %16, 0
            // float _246 = HDRMapping_010x;
            // %247 = fsub fast float 1.000000e+00, %13
            // float _247 = 1.0f - (HDRMapping_009w);
            // %248 = fmul fast float %247, %11
            float _248 = (1.0f - (HDRMapping_009w)) * _11;
            // %249 = fsub fast float %11, %248
            float _249 = _11 - _248;
            // %250 = call float @dx.op.unary.f32(i32 21, float %246)  ; Exp(value)
            float _250 = exp2((HDRMapping_010x));
            // %251 = fdiv fast float 1.000000e+00, %250
            // float _251 = 1.0f / _250;
            // %252 = fmul fast float %251, %241
            // float _252 = (1.0f / _250) * _241;
            // %253 = fdiv fast float %249, %250
            float _253 = _249 / _250;
            // %254 = fsub fast float %11, %253
            float _254 = _11 - _253;
            // %255 = fsub fast float %252, %11
            float _255 = ((1.0f / _250) * _241) - _11;
            // %256 = fcmp olt float %255, -0.000000e+00
            // bool _256 = (_255 < -0.0f);
            _285 = -0.0f;
            do {
              if (((_255 < -0.0f))) {
                // fn:start 257
                // fn:pending 433, 289, 284
                // %259 = extractvalue %dx.types.CBufRet.f32 %258, 0
                // float _259 = HDRMapping_014x;
                // %260 = fadd fast float %259, -5.000000e-01
                // float _260 = (HDRMapping_014x) + -0.5f;
                // %261 = call float @dx.op.binary.f32(i32 36, float %246, float 1.000000e+00)  ; FMin(a,b)
                // float _261 = min((HDRMapping_010x), 1.0f);
                // %262 = fmul fast float %260, %261
                // float _262 = ((HDRMapping_014x) + -0.5f) * (min((HDRMapping_010x), 1.0f));
                // %263 = fadd fast float %262, 5.000000e-01
                // float _263 = (((HDRMapping_014x) + -0.5f) * (min((HDRMapping_010x), 1.0f))) + 0.5f;
                // %264 = fmul fast float %263, 2.000000e+00
                // float _264 = ((((HDRMapping_014x) + -0.5f) * (min((HDRMapping_010x), 1.0f))) + 0.5f) * 2.0f;
                // %265 = fcmp fast oeq float %253, 0.000000e+00
                // bool _265 = (_253 == 0.0f);
                // %266 = fdiv fast float %249, %253
                // float _266 = _249 / _253;
                // %267 = select i1 %265, float 1.000000e+00, float %266
                // float _267 = (((bool)((_253 == 0.0f))) ? 1.0f : (_249 / _253));
                // %268 = fmul fast float %264, %267
                // float _268 = (((((HDRMapping_014x) + -0.5f) * (min((HDRMapping_010x), 1.0f))) + 0.5f) * 2.0f) * ((((bool)((_253 == 0.0f))) ? 1.0f : (_249 / _253)));
                // %269 = fsub fast float -0.000000e+00, %255
                // float _269 = -0.0f - _255;
                // %270 = fmul fast float %268, %254
                // float _270 = ((((((HDRMapping_014x) + -0.5f) * (min((HDRMapping_010x), 1.0f))) + 0.5f) * 2.0f) * ((((bool)((_253 == 0.0f))) ? 1.0f : (_249 / _253)))) * _254;
                // %271 = fdiv fast float %270, %248
                float _271 = (((((((HDRMapping_014x) + -0.5f) * (min((HDRMapping_010x), 1.0f))) + 0.5f) * 2.0f) * ((((bool)((_253 == 0.0f))) ? 1.0f : (_249 / _253)))) * _254) / _248;
                // %272 = call float @dx.op.unary.f32(i32 23, float %248)  ; Log(value)
                // float _272 = log2(_248);
                // %273 = call float @dx.op.unary.f32(i32 23, float %254)  ; Log(value)
                // float _273 = log2(_254);
                // %274 = fmul fast float %271, 0xBFE62E4300000000
                // float _274 = _271 * -0.6931471824645996f;
                // %275 = fmul fast float %274, %273
                // float _275 = (_271 * -0.6931471824645996f) * (log2(_254));
                // %276 = call float @dx.op.unary.f32(i32 23, float %269)  ; Log(value)
                // float _276 = log2((-0.0f - _255));
                // %277 = fmul fast float %276, %271
                // float _277 = (log2((-0.0f - _255))) * _271;
                // %278 = fadd fast float %277, %272
                // float _278 = ((log2((-0.0f - _255))) * _271) + (log2(_248));
                // %279 = fmul fast float %278, 0x3FE62E4300000000
                // float _279 = (((log2((-0.0f - _255))) * _271) + (log2(_248))) * 0.6931471824645996f;
                // %280 = fadd fast float %279, %275
                // float _280 = ((((log2((-0.0f - _255))) * _271) + (log2(_248))) * 0.6931471824645996f) + ((_271 * -0.6931471824645996f) * (log2(_254)));
                // %281 = fmul fast float %280, 0x3FF7154760000000
                // float _281 = (((((log2((-0.0f - _255))) * _271) + (log2(_248))) * 0.6931471824645996f) + ((_271 * -0.6931471824645996f) * (log2(_254)))) * 1.4426950216293335f;
                // %282 = call float @dx.op.unary.f32(i32 21, float %281)  ; Exp(value)
                // float _282 = exp2(((((((log2((-0.0f - _255))) * _271) + (log2(_248))) * 0.6931471824645996f) + ((_271 * -0.6931471824645996f) * (log2(_254)))) * 1.4426950216293335f));
                // %283 = fsub float -0.000000e+00, %282
                // float _283 = -0.0f - (exp2(((((((log2((-0.0f - _255))) * _271) + (log2(_248))) * 0.6931471824645996f) + ((_271 * -0.6931471824645996f) * (log2(_254)))) * 1.4426950216293335f)));
                _285 = (-0.0f - (exp2(((((((log2((-0.0f - _255))) * _271) + (log2(_248))) * 0.6931471824645996f) + ((_271 * -0.6931471824645996f) * (log2(_254)))) * 1.4426950216293335f))));
                // fn:converge 257 => 284
              }
              // fn:start 284
              // fn:pending 433, 289
              // %286 = fadd fast float %285, %11
              // float _286 = _285 + _11;
              // %287 = fcmp fast ole float %241, %14
              // bool _287 = (_241 <= _14);
              // %288 = select i1 %287, float %241, float %286
              // float _288 = (((bool)((_241 <= _14))) ? _241 : (_285 + _11));
              _290 = ((((bool)((_241 <= _14))) ? _241 : (_285 + _11)));
              // fn:converge 284 => 289
            } while (false);
          }
          // fn:start 289
          // fn:pending 433
          // %291 = fmul fast float %290, 0x3F847AE140000000
          // float _291 = _290 * 0.009999999776482582f;
          // %292 = call float @dx.op.unary.f32(i32 23, float %291)  ; Log(value)
          // float _292 = log2((_290 * 0.009999999776482582f));
          // %293 = fmul fast float %292, 0x3FC4640000000000
          // float _293 = (log2((_290 * 0.009999999776482582f))) * 0.1593017578125f;
          // %294 = call float @dx.op.unary.f32(i32 21, float %293)  ; Exp(value)
          float _294 = exp2(((log2((_290 * 0.009999999776482582f))) * 0.1593017578125f));
          // %295 = fmul fast float %294, 0x4032DA0000000000
          // float _295 = _294 * 18.8515625f;
          // %296 = fadd fast float %295, 8.359375e-01
          // float _296 = (_294 * 18.8515625f) + 0.8359375f;
          // %297 = fmul fast float %294, 1.868750e+01
          // float _297 = _294 * 18.6875f;
          // %298 = fadd fast float %297, 1.000000e+00
          // float _298 = (_294 * 18.6875f) + 1.0f;
          // %299 = fdiv fast float %296, %298
          // float _299 = ((_294 * 18.8515625f) + 0.8359375f) / ((_294 * 18.6875f) + 1.0f);
          // %300 = call float @dx.op.unary.f32(i32 23, float %299)  ; Log(value)
          // float _300 = log2((((_294 * 18.8515625f) + 0.8359375f) / ((_294 * 18.6875f) + 1.0f)));
          // %301 = fmul fast float %300, 7.884375e+01
          // float _301 = (log2((((_294 * 18.8515625f) + 0.8359375f) / ((_294 * 18.6875f) + 1.0f)))) * 78.84375f;
          // %302 = call float @dx.op.unary.f32(i32 21, float %301)  ; Exp(value)
          // float _302 = exp2(((log2((((_294 * 18.8515625f) + 0.8359375f) / ((_294 * 18.6875f) + 1.0f)))) * 78.84375f));
          // %303 = call float @dx.op.unary.f32(i32 7, float %302)  ; Saturate(value)
          float _303 = saturate((exp2(((log2((((_294 * 18.8515625f) + 0.8359375f) / ((_294 * 18.6875f) + 1.0f)))) * 78.84375f))));
          // %304 = extractvalue %dx.types.CBufRet.f32 %16, 2
          // float _304 = HDRMapping_010z;
          // %305 = fmul fast float %185, %304
          // float _305 = ((dot(float3(_155, _168, _181), float3(6610.0f, -13613.0f, 7003.0f))) * 0.000244140625f) * (HDRMapping_010z);
          // %306 = fmul fast float %187, %304
          // float _306 = ((dot(float3(_155, _168, _181), float3(17933.0f, -17390.0f, -543.0f))) * 0.000244140625f) * (HDRMapping_010z);
          // %307 = fdiv fast float %303, %183
          // float _307 = _303 / _183;
          // %308 = fdiv fast float %183, %303
          // float _308 = _183 / _303;
          // %309 = call float @dx.op.binary.f32(i32 36, float %308, float %307)  ; FMin(a,b)
          float _309 = min((_183 / _303), (_303 / _183));
          // %310 = fmul fast float %305, %309
          float _310 = (((dot(float3(_155, _168, _181), float3(6610.0f, -13613.0f, 7003.0f))) * 0.000244140625f) * (HDRMapping_010z)) * _309;
          // %311 = fmul fast float %306, %309
          float _311 = (((dot(float3(_155, _168, _181), float3(17933.0f, -17390.0f, -543.0f))) * 0.000244140625f) * (HDRMapping_010z)) * _309;
          // %312 = call float @dx.op.tertiary.f32(i32 46, float 0x3F826E9780000000, float %310, float %303)  ; FMad(a,b,c)
          // float _312 = mad(0.008999999612569809f, _310, _303);
          // %313 = call float @dx.op.tertiary.f32(i32 46, float 0x3FBC6A7F00000000, float %311, float %312)  ; FMad(a,b,c)
          // float _313 = mad(0.11100000143051147f, _311, (mad(0.008999999612569809f, _310, _303)));
          // %314 = call float @dx.op.tertiary.f32(i32 46, float 0xBF826E9780000000, float %310, float %303)  ; FMad(a,b,c)
          // float _314 = mad(-0.008999999612569809f, _310, _303);
          // %315 = call float @dx.op.tertiary.f32(i32 46, float 0xBFBC6A7F00000000, float %311, float %314)  ; FMad(a,b,c)
          // float _315 = mad(-0.11100000143051147f, _311, (mad(-0.008999999612569809f, _310, _303)));
          // %316 = call float @dx.op.tertiary.f32(i32 46, float 0x3FE1EB8520000000, float %310, float %303)  ; FMad(a,b,c)
          // float _316 = mad(0.5600000023841858f, _310, _303);
          // %317 = call float @dx.op.tertiary.f32(i32 46, float 0xBFD48B43A0000000, float %311, float %316)  ; FMad(a,b,c)
          // float _317 = mad(-0.32100000977516174f, _311, (mad(0.5600000023841858f, _310, _303)));
          // %318 = call float @dx.op.unary.f32(i32 7, float %313)  ; Saturate(value)
          // float _318 = saturate((mad(0.11100000143051147f, _311, (mad(0.008999999612569809f, _310, _303)))));
          // %319 = call float @dx.op.unary.f32(i32 23, float %318)  ; Log(value)
          // float _319 = log2((saturate((mad(0.11100000143051147f, _311, (mad(0.008999999612569809f, _310, _303)))))));
          // %320 = fmul fast float %319, 0x3F89F9B580000000
          // float _320 = (log2((saturate((mad(0.11100000143051147f, _311, (mad(0.008999999612569809f, _310, _303)))))))) * 0.012683313339948654f;
          // %321 = call float @dx.op.unary.f32(i32 21, float %320)  ; Exp(value)
          float _321 = exp2(((log2((saturate((mad(0.11100000143051147f, _311, (mad(0.008999999612569809f, _310, _303)))))))) * 0.012683313339948654f));
          // %322 = fadd fast float %321, -8.359375e-01
          // float _322 = _321 + -0.8359375f;
          // %323 = call float @dx.op.binary.f32(i32 35, float 0.000000e+00, float %322)  ; FMax(a,b)
          // float _323 = max(0.0f, (_321 + -0.8359375f));
          // %324 = fmul fast float %321, 1.868750e+01
          // float _324 = _321 * 18.6875f;
          // %325 = fsub fast float 0x4032DA0000000000, %324
          // float _325 = 18.8515625f - (_321 * 18.6875f);
          // %326 = fdiv fast float %323, %325
          // float _326 = (max(0.0f, (_321 + -0.8359375f))) / (18.8515625f - (_321 * 18.6875f));
          // %327 = call float @dx.op.unary.f32(i32 23, float %326)  ; Log(value)
          // float _327 = log2(((max(0.0f, (_321 + -0.8359375f))) / (18.8515625f - (_321 * 18.6875f))));
          // %328 = fmul fast float %327, 0x40191C0D60000000
          // float _328 = (log2(((max(0.0f, (_321 + -0.8359375f))) / (18.8515625f - (_321 * 18.6875f))))) * 6.277394771575928f;
          // %329 = call float @dx.op.unary.f32(i32 21, float %328)  ; Exp(value)
          float _329 = exp2(((log2(((max(0.0f, (_321 + -0.8359375f))) / (18.8515625f - (_321 * 18.6875f))))) * 6.277394771575928f));
          // %330 = call float @dx.op.unary.f32(i32 7, float %315)  ; Saturate(value)
          // float _330 = saturate((mad(-0.11100000143051147f, _311, (mad(-0.008999999612569809f, _310, _303)))));
          // %331 = call float @dx.op.unary.f32(i32 23, float %330)  ; Log(value)
          // float _331 = log2((saturate((mad(-0.11100000143051147f, _311, (mad(-0.008999999612569809f, _310, _303)))))));
          // %332 = fmul fast float %331, 0x3F89F9B580000000
          // float _332 = (log2((saturate((mad(-0.11100000143051147f, _311, (mad(-0.008999999612569809f, _310, _303)))))))) * 0.012683313339948654f;
          // %333 = call float @dx.op.unary.f32(i32 21, float %332)  ; Exp(value)
          float _333 = exp2(((log2((saturate((mad(-0.11100000143051147f, _311, (mad(-0.008999999612569809f, _310, _303)))))))) * 0.012683313339948654f));
          // %334 = fadd fast float %333, -8.359375e-01
          // float _334 = _333 + -0.8359375f;
          // %335 = call float @dx.op.binary.f32(i32 35, float 0.000000e+00, float %334)  ; FMax(a,b)
          // float _335 = max(0.0f, (_333 + -0.8359375f));
          // %336 = fmul fast float %333, 1.868750e+01
          // float _336 = _333 * 18.6875f;
          // %337 = fsub fast float 0x4032DA0000000000, %336
          // float _337 = 18.8515625f - (_333 * 18.6875f);
          // %338 = fdiv fast float %335, %337
          // float _338 = (max(0.0f, (_333 + -0.8359375f))) / (18.8515625f - (_333 * 18.6875f));
          // %339 = call float @dx.op.unary.f32(i32 23, float %338)  ; Log(value)
          // float _339 = log2(((max(0.0f, (_333 + -0.8359375f))) / (18.8515625f - (_333 * 18.6875f))));
          // %340 = fmul fast float %339, 0x40191C0D60000000
          // float _340 = (log2(((max(0.0f, (_333 + -0.8359375f))) / (18.8515625f - (_333 * 18.6875f))))) * 6.277394771575928f;
          // %341 = call float @dx.op.unary.f32(i32 21, float %340)  ; Exp(value)
          // float _341 = exp2(((log2(((max(0.0f, (_333 + -0.8359375f))) / (18.8515625f - (_333 * 18.6875f))))) * 6.277394771575928f));
          // %342 = fmul fast float %341, 1.000000e+02
          float _342 = (exp2(((log2(((max(0.0f, (_333 + -0.8359375f))) / (18.8515625f - (_333 * 18.6875f))))) * 6.277394771575928f))) * 100.0f;
          // %343 = call float @dx.op.unary.f32(i32 7, float %317)  ; Saturate(value)
          // float _343 = saturate((mad(-0.32100000977516174f, _311, (mad(0.5600000023841858f, _310, _303)))));
          // %344 = call float @dx.op.unary.f32(i32 23, float %343)  ; Log(value)
          // float _344 = log2((saturate((mad(-0.32100000977516174f, _311, (mad(0.5600000023841858f, _310, _303)))))));
          // %345 = fmul fast float %344, 0x3F89F9B580000000
          // float _345 = (log2((saturate((mad(-0.32100000977516174f, _311, (mad(0.5600000023841858f, _310, _303)))))))) * 0.012683313339948654f;
          // %346 = call float @dx.op.unary.f32(i32 21, float %345)  ; Exp(value)
          float _346 = exp2(((log2((saturate((mad(-0.32100000977516174f, _311, (mad(0.5600000023841858f, _310, _303)))))))) * 0.012683313339948654f));
          // %347 = fadd fast float %346, -8.359375e-01
          // float _347 = _346 + -0.8359375f;
          // %348 = call float @dx.op.binary.f32(i32 35, float 0.000000e+00, float %347)  ; FMax(a,b)
          // float _348 = max(0.0f, (_346 + -0.8359375f));
          // %349 = fmul fast float %346, 1.868750e+01
          // float _349 = _346 * 18.6875f;
          // %350 = fsub fast float 0x4032DA0000000000, %349
          // float _350 = 18.8515625f - (_346 * 18.6875f);
          // %351 = fdiv fast float %348, %350
          // float _351 = (max(0.0f, (_346 + -0.8359375f))) / (18.8515625f - (_346 * 18.6875f));
          // %352 = call float @dx.op.unary.f32(i32 23, float %351)  ; Log(value)
          // float _352 = log2(((max(0.0f, (_346 + -0.8359375f))) / (18.8515625f - (_346 * 18.6875f))));
          // %353 = fmul fast float %352, 0x40191C0D60000000
          // float _353 = (log2(((max(0.0f, (_346 + -0.8359375f))) / (18.8515625f - (_346 * 18.6875f))))) * 6.277394771575928f;
          // %354 = call float @dx.op.unary.f32(i32 21, float %353)  ; Exp(value)
          // float _354 = exp2(((log2(((max(0.0f, (_346 + -0.8359375f))) / (18.8515625f - (_346 * 18.6875f))))) * 6.277394771575928f));
          // %355 = fmul fast float %354, 1.000000e+02
          float _355 = (exp2(((log2(((max(0.0f, (_346 + -0.8359375f))) / (18.8515625f - (_346 * 18.6875f))))) * 6.277394771575928f))) * 100.0f;
          // %356 = fmul fast float %329, 0x4069E33340000000
          // float _356 = _329 * 207.10000610351562f;
          // %357 = call float @dx.op.tertiary.f32(i32 46, float 0xBFF53B6460000000, float %342, float %356)  ; FMad(a,b,c)
          // float _357 = mad(-1.3270000219345093f, _342, (_329 * 207.10000610351562f));
          // %358 = call float @dx.op.tertiary.f32(i32 46, float 0x3FCA7EF9E0000000, float %355, float %357)  ; FMad(a,b,c)
          // float _358 = mad(0.2070000022649765f, _355, (mad(-1.3270000219345093f, _342, (_329 * 207.10000610351562f))));
          // %359 = fmul fast float %329, 3.650000e+01
          // float _359 = _329 * 36.5f;
          // %360 = call float @dx.op.tertiary.f32(i32 46, float 0x3FE5CAC080000000, float %342, float %359)  ; FMad(a,b,c)
          // float _360 = mad(0.6809999942779541f, _342, (_329 * 36.5f));
          // %361 = call float @dx.op.tertiary.f32(i32 46, float 0xBFA70A3D80000000, float %355, float %360)  ; FMad(a,b,c)
          // float _361 = mad(-0.04500000178813934f, _355, (mad(0.6809999942779541f, _342, (_329 * 36.5f))));
          // %362 = fmul fast float %329, 0xC0139999A0000000
          // float _362 = _329 * -4.900000095367432f;
          // %363 = call float @dx.op.tertiary.f32(i32 46, float 0xBFA99999A0000000, float %342, float %362)  ; FMad(a,b,c)
          // float _363 = mad(-0.05000000074505806f, _342, (_329 * -4.900000095367432f));
          // %364 = call float @dx.op.tertiary.f32(i32 46, float 0x3FF3020C40000000, float %355, float %363)  ; FMad(a,b,c)
          // float _364 = mad(1.187999963760376f, _355, (mad(-0.05000000074505806f, _342, (_329 * -4.900000095367432f))));
          // %365 = fmul fast float %358, %67
          // float _365 = (mad(0.2070000022649765f, _355, (mad(-1.3270000219345093f, _342, (_329 * 207.10000610351562f))))) * (OCIOTransformXYZMatrix_004x);
          // %366 = call float @dx.op.tertiary.f32(i32 46, float %68, float %361, float %365)  ; FMad(a,b,c)
          // float _366 = mad((OCIOTransformXYZMatrix_004y), (mad(-0.04500000178813934f, _355, (mad(0.6809999942779541f, _342, (_329 * 36.5f))))), ((mad(0.2070000022649765f, _355, (mad(-1.3270000219345093f, _342, (_329 * 207.10000610351562f))))) * (OCIOTransformXYZMatrix_004x)));
          // %367 = call float @dx.op.tertiary.f32(i32 46, float %69, float %364, float %366)  ; FMad(a,b,c)
          // float _367 = mad((OCIOTransformXYZMatrix_004z), (mad(1.187999963760376f, _355, (mad(-0.05000000074505806f, _342, (_329 * -4.900000095367432f))))), (mad((OCIOTransformXYZMatrix_004y), (mad(-0.04500000178813934f, _355, (mad(0.6809999942779541f, _342, (_329 * 36.5f))))), ((mad(0.2070000022649765f, _355, (mad(-1.3270000219345093f, _342, (_329 * 207.10000610351562f))))) * (OCIOTransformXYZMatrix_004x)))));
          // %368 = fsub fast float %367, %43
          // float _368 = (mad((OCIOTransformXYZMatrix_004z), (mad(1.187999963760376f, _355, (mad(-0.05000000074505806f, _342, (_329 * -4.900000095367432f))))), (mad((OCIOTransformXYZMatrix_004y), (mad(-0.04500000178813934f, _355, (mad(0.6809999942779541f, _342, (_329 * 36.5f))))), ((mad(0.2070000022649765f, _355, (mad(-1.3270000219345093f, _342, (_329 * 207.10000610351562f))))) * (OCIOTransformXYZMatrix_004x)))))) - _43;
          // %369 = call float @dx.op.unary.f32(i32 6, float %368)  ; FAbs(value)
          // float _369 = abs(((mad((OCIOTransformXYZMatrix_004z), (mad(1.187999963760376f, _355, (mad(-0.05000000074505806f, _342, (_329 * -4.900000095367432f))))), (mad((OCIOTransformXYZMatrix_004y), (mad(-0.04500000178813934f, _355, (mad(0.6809999942779541f, _342, (_329 * 36.5f))))), ((mad(0.2070000022649765f, _355, (mad(-1.3270000219345093f, _342, (_329 * 207.10000610351562f))))) * (OCIOTransformXYZMatrix_004x)))))) - _43));
          // %370 = fmul fast float %17, 0x3F847AE140000000
          // float _370 = (HDRMapping_010w) * 0.009999999776482582f;
          // %371 = fcmp fast olt float %369, %370
          // bool _371 = ((abs(((mad((OCIOTransformXYZMatrix_004z), (mad(1.187999963760376f, _355, (mad(-0.05000000074505806f, _342, (_329 * -4.900000095367432f))))), (mad((OCIOTransformXYZMatrix_004y), (mad(-0.04500000178813934f, _355, (mad(0.6809999942779541f, _342, (_329 * 36.5f))))), ((mad(0.2070000022649765f, _355, (mad(-1.3270000219345093f, _342, (_329 * 207.10000610351562f))))) * (OCIOTransformXYZMatrix_004x)))))) - _43))) < ((HDRMapping_010w) * 0.009999999776482582f));
          if ((((abs(((mad((OCIOTransformXYZMatrix_004z), (mad(1.187999963760376f, _355, (mad(-0.05000000074505806f, _342, (_329 * -4.900000095367432f))))), (mad((OCIOTransformXYZMatrix_004y), (mad(-0.04500000178813934f, _355, (mad(0.6809999942779541f, _342, (_329 * 36.5f))))), ((mad(0.2070000022649765f, _355, (mad(-1.3270000219345093f, _342, (_329 * 207.10000610351562f))))) * (OCIOTransformXYZMatrix_004x)))))) - _43))) < ((HDRMapping_010w) * 0.009999999776482582f)))) {
            // fn:start 372
            // fn:pending 433
            // %373 = fcmp fast ugt float %42, %189
            // bool _373 = !(_42 <= _189);
            _434 = 0.07999999821186066f;
            _435 = 0.15000000596046448f;
            _436 = 1.0f;
            _437 = 0.75f;
            if ((!(_42 <= _189))) {
              // fn:start 374
              // fn:pending 433
              // %375 = fcmp fast olt float %42, %14
              // bool _375 = (_42 < _14);
              _434 = 0.0f;
              _435 = 1.0f;
              _436 = 0.0f;
              _437 = 0.75f;
              if (!((_42 < _14))) {
                // fn:start 376
                // fn:pending 433
                _434 = 1.0f;
                _435 = 0.0f;
                _436 = 0.0f;
                _437 = 0.75f;
                // fn:converge 376 => 433
              }
            }
          } else {
            // fn:start 377
            // fn:pending 433
            // %378 = fsub fast float -0.000000e+00, %42
            // float _378 = -0.0f - _42;
            // %379 = fcmp fast oge float %42, %378
            // bool _379 = (_42 >= (-0.0f - _42));
            // %380 = call float @dx.op.unary.f32(i32 6, float %42)  ; FAbs(value)
            // float _380 = abs(_42);
            // %381 = call float @dx.op.unary.f32(i32 22, float %380)  ; Frc(value)
            float _381 = frac((abs(_42)));
            // %382 = fsub fast float -0.000000e+00, %381
            // float _382 = -0.0f - _381;
            // %383 = select i1 %379, float %381, float %382
            float _383 = (((bool)((_42 >= (-0.0f - _42)))) ? _381 : (-0.0f - _381));
            // %384 = fcmp fast ugt float %383, 0x3F947AE140000000
            // bool _384 = !(_383 <= 0.019999999552965164f);
            _434 = 0.25f;
            _435 = 0.25f;
            _436 = 0.25f;
            _437 = 0.75f;
            if ((!(_383 <= 0.019999999552965164f))) {
              // fn:start 385
              // fn:pending 433
              // %386 = fsub fast float -0.000000e+00, %43
              // float _386 = -0.0f - _43;
              // %387 = fcmp fast oge float %43, %386
              // bool _387 = (_43 >= (-0.0f - _43));
              // %388 = call float @dx.op.unary.f32(i32 6, float %43)  ; FAbs(value)
              // float _388 = abs(_43);
              // %389 = call float @dx.op.unary.f32(i32 22, float %388)  ; Frc(value)
              float _389 = frac((abs(_43)));
              // %390 = fsub fast float -0.000000e+00, %389
              // float _390 = -0.0f - _389;
              // %391 = select i1 %387, float %389, float %390
              float _391 = (((bool)((_43 >= (-0.0f - _43)))) ? _389 : (-0.0f - _389));
              // %392 = fcmp fast ugt float %391, 0x3F947AE140000000
              // bool _392 = !(_391 <= 0.019999999552965164f);
              _434 = 0.25f;
              _435 = 0.25f;
              _436 = 0.25f;
              _437 = 0.75f;
              if ((!(_391 <= 0.019999999552965164f))) {
                // fn:start 393
                // fn:pending 433
                // %394 = fcmp fast ole float %383, %65
                // bool _394 = (_383 <= _65);
                // %395 = fcmp fast ole float %42, 1.000000e+00
                // bool _395 = (_42 <= 1.0f);
                // %396 = and i1 %395, %394
                // bool _396 = ((bool)((_42 <= 1.0f))) && ((bool)((_383 <= _65)));
                do {
                  if ((((bool)((_42 <= 1.0f))) && ((bool)((_383 <= _65))))) {
                    // fn:start 397
                    // fn:pending 433, 407
                    // %398 = fmul fast float %43, 1.000000e+01
                    float _398 = _43 * 10.0f;
                    // %399 = fsub fast float -0.000000e+00, %398
                    // float _399 = -0.0f - _398;
                    // %400 = fcmp fast oge float %398, %399
                    // bool _400 = (_398 >= (-0.0f - _398));
                    // %401 = call float @dx.op.unary.f32(i32 6, float %398)  ; FAbs(value)
                    // float _401 = abs(_398);
                    // %402 = call float @dx.op.unary.f32(i32 22, float %401)  ; Frc(value)
                    float _402 = frac((abs(_398)));
                    // %403 = fsub fast float -0.000000e+00, %402
                    // float _403 = -0.0f - _402;
                    // %404 = select i1 %400, float %402, float %403
                    // float _404 = (((bool)((_398 >= (-0.0f - _398)))) ? _402 : (-0.0f - _402));
                    // %405 = fmul fast float %404, 0x3FB99999A0000000
                    // float _405 = ((((bool)((_398 >= (-0.0f - _398)))) ? _402 : (-0.0f - _402))) * 0.10000000149011612f;
                    // %406 = fcmp fast ugt float %405, 0x3F947AE140000000
                    // bool _406 = !((((((bool)((_398 >= (-0.0f - _398)))) ? _402 : (-0.0f - _402))) * 0.10000000149011612f) <= 0.019999999552965164f);
                    _434 = 0.3499999940395355f;
                    _435 = 0.3499999940395355f;
                    _436 = 0.3499999940395355f;
                    _437 = 0.75f;
                    if (!(!((((((bool)((_398 >= (-0.0f - _398)))) ? _402 : (-0.0f - _402))) * 0.10000000149011612f) <= 0.019999999552965164f))) {
                      break;
                    }
                  }
                  // fn:start 407
                  // fn:pending 433
                  // %408 = fcmp fast ole float %391, %65
                  // bool _408 = (_391 <= _65);
                  // %409 = fcmp fast ole float %43, 1.000000e+00
                  // bool _409 = (_43 <= 1.0f);
                  // %410 = and i1 %409, %408
                  // bool _410 = ((bool)((_43 <= 1.0f))) && ((bool)((_391 <= _65)));
                  do {
                    if ((((bool)((_43 <= 1.0f))) && ((bool)((_391 <= _65))))) {
                      // fn:start 411
                      // fn:pending 433, 421
                      // %412 = fmul fast float %42, 1.000000e+01
                      float _412 = _42 * 10.0f;
                      // %413 = fsub fast float -0.000000e+00, %412
                      // float _413 = -0.0f - _412;
                      // %414 = fcmp fast oge float %412, %413
                      // bool _414 = (_412 >= (-0.0f - _412));
                      // %415 = call float @dx.op.unary.f32(i32 6, float %412)  ; FAbs(value)
                      // float _415 = abs(_412);
                      // %416 = call float @dx.op.unary.f32(i32 22, float %415)  ; Frc(value)
                      float _416 = frac((abs(_412)));
                      // %417 = fsub fast float -0.000000e+00, %416
                      // float _417 = -0.0f - _416;
                      // %418 = select i1 %414, float %416, float %417
                      // float _418 = (((bool)((_412 >= (-0.0f - _412)))) ? _416 : (-0.0f - _416));
                      // %419 = fmul fast float %418, 0x3FB99999A0000000
                      // float _419 = ((((bool)((_412 >= (-0.0f - _412)))) ? _416 : (-0.0f - _416))) * 0.10000000149011612f;
                      // %420 = fcmp fast ugt float %419, 0x3F947AE140000000
                      // bool _420 = !((((((bool)((_412 >= (-0.0f - _412)))) ? _416 : (-0.0f - _416))) * 0.10000000149011612f) <= 0.019999999552965164f);
                      _434 = 0.3499999940395355f;
                      _435 = 0.3499999940395355f;
                      _436 = 0.3499999940395355f;
                      _437 = 0.75f;
                      if (!(!((((((bool)((_412 >= (-0.0f - _412)))) ? _416 : (-0.0f - _416))) * 0.10000000149011612f) <= 0.019999999552965164f))) {
                        break;
                      }
                    }
                    // fn:start 421
                    // fn:pending 433
                    _434 = 0.11999999731779099f;
                    _435 = 0.11999999731779099f;
                    _436 = 0.11999999731779099f;
                    _437 = 0.75f;
                    if (_52) {
                      // fn:start 422
                      // fn:pending 433
                      // %423 = fmul fast float %43, 2.000000e+00
                      float _423 = _43 * 2.0f;
                      // %424 = fsub fast float -0.000000e+00, %423
                      // float _424 = -0.0f - _423;
                      // %425 = fcmp fast oge float %423, %424
                      // bool _425 = (_423 >= (-0.0f - _423));
                      // %426 = call float @dx.op.unary.f32(i32 6, float %423)  ; FAbs(value)
                      // float _426 = abs(_423);
                      // %427 = call float @dx.op.unary.f32(i32 22, float %426)  ; Frc(value)
                      float _427 = frac((abs(_423)));
                      // %428 = fsub fast float -0.000000e+00, %427
                      // float _428 = -0.0f - _427;
                      // %429 = select i1 %425, float %427, float %428
                      // float _429 = (((bool)((_423 >= (-0.0f - _423)))) ? _427 : (-0.0f - _427));
                      // %430 = fmul fast float %429, 5.000000e-01
                      // float _430 = ((((bool)((_423 >= (-0.0f - _423)))) ? _427 : (-0.0f - _427))) * 0.5f;
                      // %431 = fcmp fast ugt float %430, 0x3F947AE140000000
                      // bool _431 = !((((((bool)((_423 >= (-0.0f - _423)))) ? _427 : (-0.0f - _427))) * 0.5f) <= 0.019999999552965164f);
                      _434 = 0.11999999731779099f;
                      _435 = 0.11999999731779099f;
                      _436 = 0.11999999731779099f;
                      _437 = 0.75f;
                      if ((!((((((bool)((_423 >= (-0.0f - _423)))) ? _427 : (-0.0f - _427))) * 0.5f) <= 0.019999999552965164f))) {
                        // fn:start 432
                        // fn:pending 433
                        _434 = 0.05000000074505806f;
                        _435 = 0.05000000074505806f;
                        _436 = 0.05000000074505806f;
                        _437 = 0.75f;
                        // fn:converge 432 => 433
                      }
                    }
                  } while (false);
                } while (false);
              }
            }
          }
        } while (false);
      } while (false);
    } while (false);
  }
  // fn:start 433
  SV_Target.x = _434;
  SV_Target.y = _435;
  SV_Target.z = _436;
  SV_Target.w = _437;
  return SV_Target;
}
