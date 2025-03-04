RWTexture3D<float> OutLUT : register(u0);

cbuffer HDRMapping : register(b0) {
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

[numthreads(8, 8, 8)]
void main(
 uint3 SV_DispatchThreadID : SV_DispatchThreadID,
 uint3 SV_GroupID : SV_GroupID,
 uint3 SV_GroupThreadID : SV_GroupThreadID,
 uint SV_GroupIndex : SV_GroupIndex
) {
  // fn:start 0
  // %1 = call %dx.types.Handle @dx.op.createHandleFromBinding(i32 217, %dx.types.ResBind { i32 0, i32 0, i32 0, i8 1 }, i32 0, i1 false)  ; CreateHandleFromBinding(bind,index,nonUniformIndex)
  // rwtexture _1 = OutLUT;
  // %2 = call %dx.types.Handle @dx.op.createHandleFromBinding(i32 217, %dx.types.ResBind { i32 1, i32 1, i32 0, i8 2 }, i32 1, i1 false)  ; CreateHandleFromBinding(bind,index,nonUniformIndex)
  // cbuffer _2 = OCIOTransformXYZMatrix;
  // %3 = call %dx.types.Handle @dx.op.createHandleFromBinding(i32 217, %dx.types.ResBind { i32 0, i32 0, i32 0, i8 2 }, i32 0, i1 false)  ; CreateHandleFromBinding(bind,index,nonUniformIndex)
  // cbuffer _3 = HDRMapping;
  // %4 = call %dx.types.Handle @dx.op.annotateHandle(i32 216, %dx.types.Handle %2, %dx.types.ResourceProperties { i32 13, i32 128 })  ; AnnotateHandle(res,props)  resource: CBuffer
  // auto _4 = _2;
  // %5 = call %dx.types.Handle @dx.op.annotateHandle(i32 216, %dx.types.Handle %3, %dx.types.ResourceProperties { i32 13, i32 240 })  ; AnnotateHandle(res,props)  resource: CBuffer
  // auto _5 = _3;
  // %6 = call i32 @dx.op.threadId.i32(i32 93, i32 0)  ; ThreadId(component)
  // uint _6 = SV_DispatchThreadID.x;
  // %7 = call i32 @dx.op.threadId.i32(i32 93, i32 1)  ; ThreadId(component)
  // uint _7 = SV_DispatchThreadID.y;
  // %8 = call i32 @dx.op.threadId.i32(i32 93, i32 2)  ; ThreadId(component)
  // uint _8 = SV_DispatchThreadID.z;
  // %10 = extractvalue %dx.types.CBufRet.f32 %9, 2
  // float _10 = HDRMapping_000z;
  // %11 = fmul fast float %10, 0x3F847AE140000000
  float _11 = (HDRMapping_000z) * 0.009999999776482582f;
  // %13 = extractvalue %dx.types.CBufRet.f32 %12, 3
  // float _13 = HDRMapping_009w;
  // %14 = fmul fast float %11, %13
  float _14 = _11 * (HDRMapping_009w);
  // %15 = uitofp i32 %6 to float
  float _15 = float((uint)(SV_DispatchThreadID.x));
  // %16 = uitofp i32 %7 to float
  float _16 = float((uint)(SV_DispatchThreadID.y));
  // %17 = uitofp i32 %8 to float
  float _17 = float((uint)(SV_DispatchThreadID.z));
  // %18 = fmul fast float %15, 0x3F90410420000000
  float _18 = _15 * 0.01587301678955555f;
  // %19 = fmul fast float %16, 0x3F90410420000000
  float _19 = _16 * 0.01587301678955555f;
  // %20 = fmul fast float %17, 0x3F90410420000000
  float _20 = _17 * 0.01587301678955555f;
  // %21 = fcmp fast ugt float %18, 0xBFD349A560000000
  // bool _21 = !(_18 <= -0.3013699948787689f);
  float _34;
  float _48;
  float _62;
  float _238;
  float _246;
  float _291;
  float _296;
  if (!(!(_18 <= -0.3013699948787689f))) {
    // fn:start 22
    // fn:pending 33
    // %23 = fmul fast float %15, 0x3FD1CC5020000000
    // float _23 = _15 * 0.2780952751636505f;
    // %24 = fadd fast float %23, 0xC02170A3E0000000
    // float _24 = (_15 * 0.2780952751636505f) + -8.720000267028809f;
    // %25 = call float @dx.op.unary.f32(i32 21, float %24)  ; Exp(value)
    // float _25 = exp2(((_15 * 0.2780952751636505f) + -8.720000267028809f));
    // %26 = fadd fast float %25, 0xBF00000000000000
    // float _26 = (exp2(((_15 * 0.2780952751636505f) + -8.720000267028809f))) + -3.0517578125e-05f;
    _34 = ((exp2(((_15 * 0.2780952751636505f) + -8.720000267028809f))) + -3.0517578125e-05f);
    // fn:converge 22 => 33
  } else {
    // fn:start 27
    // fn:pending 33
    // %28 = fcmp fast olt float %18, 0x3FF77CEDA0000000
    // bool _28 = (_18 < 1.468000054359436f);
    _34 = 65504.0f;
    if (((_18 < 1.468000054359436f))) {
      // fn:start 29
      // fn:pending 33
      // %30 = fmul fast float %15, 0x3FD1CC5020000000
      // float _30 = _15 * 0.2780952751636505f;
      // %31 = fadd fast float %30, 0xC02370A3E0000000
      // float _31 = (_15 * 0.2780952751636505f) + -9.720000267028809f;
      // %32 = call float @dx.op.unary.f32(i32 21, float %31)  ; Exp(value)
      // float _32 = exp2(((_15 * 0.2780952751636505f) + -9.720000267028809f));
      _34 = (exp2(((_15 * 0.2780952751636505f) + -9.720000267028809f)));
      // fn:converge 29 => 33
    }
  }
  // fn:start 33
  // %35 = fcmp fast ugt float %19, 0xBFD349A560000000
  // bool _35 = !(_19 <= -0.3013699948787689f);
  if (!(!(_19 <= -0.3013699948787689f))) {
    // fn:start 36
    // fn:pending 47
    // %37 = fmul fast float %16, 0x3FD1CC5020000000
    // float _37 = _16 * 0.2780952751636505f;
    // %38 = fadd fast float %37, 0xC02170A3E0000000
    // float _38 = (_16 * 0.2780952751636505f) + -8.720000267028809f;
    // %39 = call float @dx.op.unary.f32(i32 21, float %38)  ; Exp(value)
    // float _39 = exp2(((_16 * 0.2780952751636505f) + -8.720000267028809f));
    // %40 = fadd fast float %39, 0xBF00000000000000
    // float _40 = (exp2(((_16 * 0.2780952751636505f) + -8.720000267028809f))) + -3.0517578125e-05f;
    _48 = ((exp2(((_16 * 0.2780952751636505f) + -8.720000267028809f))) + -3.0517578125e-05f);
    // fn:converge 36 => 47
  } else {
    // fn:start 41
    // fn:pending 47
    // %42 = fcmp fast olt float %19, 0x3FF77CEDA0000000
    // bool _42 = (_19 < 1.468000054359436f);
    _48 = 65504.0f;
    if (((_19 < 1.468000054359436f))) {
      // fn:start 43
      // fn:pending 47
      // %44 = fmul fast float %16, 0x3FD1CC5020000000
      // float _44 = _16 * 0.2780952751636505f;
      // %45 = fadd fast float %44, 0xC02370A3E0000000
      // float _45 = (_16 * 0.2780952751636505f) + -9.720000267028809f;
      // %46 = call float @dx.op.unary.f32(i32 21, float %45)  ; Exp(value)
      // float _46 = exp2(((_16 * 0.2780952751636505f) + -9.720000267028809f));
      _48 = (exp2(((_16 * 0.2780952751636505f) + -9.720000267028809f)));
      // fn:converge 43 => 47
    }
  }
  // fn:start 47
  // %49 = fcmp fast ugt float %20, 0xBFD349A560000000
  // bool _49 = !(_20 <= -0.3013699948787689f);
  if (!(!(_20 <= -0.3013699948787689f))) {
    // fn:start 50
    // fn:pending 61
    // %51 = fmul fast float %17, 0x3FD1CC5020000000
    // float _51 = _17 * 0.2780952751636505f;
    // %52 = fadd fast float %51, 0xC02170A3E0000000
    // float _52 = (_17 * 0.2780952751636505f) + -8.720000267028809f;
    // %53 = call float @dx.op.unary.f32(i32 21, float %52)  ; Exp(value)
    // float _53 = exp2(((_17 * 0.2780952751636505f) + -8.720000267028809f));
    // %54 = fadd fast float %53, 0xBF00000000000000
    // float _54 = (exp2(((_17 * 0.2780952751636505f) + -8.720000267028809f))) + -3.0517578125e-05f;
    _62 = ((exp2(((_17 * 0.2780952751636505f) + -8.720000267028809f))) + -3.0517578125e-05f);
    // fn:converge 50 => 61
  } else {
    // fn:start 55
    // fn:pending 61
    // %56 = fcmp fast olt float %20, 0x3FF77CEDA0000000
    // bool _56 = (_20 < 1.468000054359436f);
    _62 = 65504.0f;
    if (((_20 < 1.468000054359436f))) {
      // fn:start 57
      // fn:pending 61
      // %58 = fmul fast float %17, 0x3FD1CC5020000000
      // float _58 = _17 * 0.2780952751636505f;
      // %59 = fadd fast float %58, 0xC02370A3E0000000
      // float _59 = (_17 * 0.2780952751636505f) + -9.720000267028809f;
      // %60 = call float @dx.op.unary.f32(i32 21, float %59)  ; Exp(value)
      // float _60 = exp2(((_17 * 0.2780952751636505f) + -9.720000267028809f));
      _62 = (exp2(((_17 * 0.2780952751636505f) + -9.720000267028809f)));
      // fn:converge 57 => 61
    }
  }
  // fn:start 61
  // %64 = extractvalue %dx.types.CBufRet.f32 %63, 0
  // float _64 = OCIOTransformXYZMatrix_004x;
  // %65 = extractvalue %dx.types.CBufRet.f32 %63, 1
  // float _65 = OCIOTransformXYZMatrix_004y;
  // %66 = extractvalue %dx.types.CBufRet.f32 %63, 2
  // float _66 = OCIOTransformXYZMatrix_004z;
  // %68 = extractvalue %dx.types.CBufRet.f32 %67, 0
  // float _68 = OCIOTransformXYZMatrix_005x;
  // %69 = extractvalue %dx.types.CBufRet.f32 %67, 1
  // float _69 = OCIOTransformXYZMatrix_005y;
  // %70 = extractvalue %dx.types.CBufRet.f32 %67, 2
  // float _70 = OCIOTransformXYZMatrix_005z;
  // %72 = extractvalue %dx.types.CBufRet.f32 %71, 0
  // float _72 = OCIOTransformXYZMatrix_006x;
  // %73 = extractvalue %dx.types.CBufRet.f32 %71, 1
  // float _73 = OCIOTransformXYZMatrix_006y;
  // %74 = extractvalue %dx.types.CBufRet.f32 %71, 2
  // float _74 = OCIOTransformXYZMatrix_006z;
  // %76 = extractvalue %dx.types.CBufRet.f32 %75, 0
  // float _76 = OCIOTransformXYZMatrix_000x;
  // %77 = extractvalue %dx.types.CBufRet.f32 %75, 1
  // float _77 = OCIOTransformXYZMatrix_000y;
  // %78 = extractvalue %dx.types.CBufRet.f32 %75, 2
  // float _78 = OCIOTransformXYZMatrix_000z;
  // %80 = extractvalue %dx.types.CBufRet.f32 %79, 0
  // float _80 = OCIOTransformXYZMatrix_001x;
  // %81 = extractvalue %dx.types.CBufRet.f32 %79, 1
  // float _81 = OCIOTransformXYZMatrix_001y;
  // %82 = extractvalue %dx.types.CBufRet.f32 %79, 2
  // float _82 = OCIOTransformXYZMatrix_001z;
  // %84 = extractvalue %dx.types.CBufRet.f32 %83, 0
  // float _84 = OCIOTransformXYZMatrix_002x;
  // %85 = extractvalue %dx.types.CBufRet.f32 %83, 1
  // float _85 = OCIOTransformXYZMatrix_002y;
  // %86 = extractvalue %dx.types.CBufRet.f32 %83, 2
  // float _86 = OCIOTransformXYZMatrix_002z;
  // %87 = fmul fast float %76, 0x3FD6FD2200000000
  // float _87 = (OCIOTransformXYZMatrix_000x) * 0.35920000076293945f;
  // %88 = call float @dx.op.tertiary.f32(i32 46, float 0x3FE652BD40000000, float %80, float %87)  ; FMad(a,b,c)
  // float _88 = mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f));
  // %89 = call float @dx.op.tertiary.f32(i32 46, float 0xBFA25460A0000000, float %84, float %88)  ; FMad(a,b,c)
  // float _89 = mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))));
  // %90 = fmul fast float %77, 0x3FD6FD2200000000
  // float _90 = (OCIOTransformXYZMatrix_000y) * 0.35920000076293945f;
  // %91 = call float @dx.op.tertiary.f32(i32 46, float 0x3FE652BD40000000, float %81, float %90)  ; FMad(a,b,c)
  // float _91 = mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f));
  // %92 = call float @dx.op.tertiary.f32(i32 46, float 0xBFA25460A0000000, float %85, float %91)  ; FMad(a,b,c)
  // float _92 = mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))));
  // %93 = fmul fast float %78, 0x3FD6FD2200000000
  // float _93 = (OCIOTransformXYZMatrix_000z) * 0.35920000076293945f;
  // %94 = call float @dx.op.tertiary.f32(i32 46, float 0x3FE652BD40000000, float %82, float %93)  ; FMad(a,b,c)
  // float _94 = mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f));
  // %95 = call float @dx.op.tertiary.f32(i32 46, float 0xBFA25460A0000000, float %86, float %94)  ; FMad(a,b,c)
  // float _95 = mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))));
  // %96 = fmul fast float %76, 0xBFC89A0280000000
  // float _96 = (OCIOTransformXYZMatrix_000x) * -0.19220000505447388f;
  // %97 = call float @dx.op.tertiary.f32(i32 46, float 0x3FF19B3D00000000, float %80, float %96)  ; FMad(a,b,c)
  // float _97 = mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f));
  // %98 = call float @dx.op.tertiary.f32(i32 46, float 0x3FB353F7C0000000, float %84, float %97)  ; FMad(a,b,c)
  // float _98 = mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))));
  // %99 = fmul fast float %77, 0xBFC89A0280000000
  // float _99 = (OCIOTransformXYZMatrix_000y) * -0.19220000505447388f;
  // %100 = call float @dx.op.tertiary.f32(i32 46, float 0x3FF19B3D00000000, float %81, float %99)  ; FMad(a,b,c)
  // float _100 = mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f));
  // %101 = call float @dx.op.tertiary.f32(i32 46, float 0x3FB353F7C0000000, float %85, float %100)  ; FMad(a,b,c)
  // float _101 = mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))));
  // %102 = fmul fast float %78, 0xBFC89A0280000000
  // float _102 = (OCIOTransformXYZMatrix_000z) * -0.19220000505447388f;
  // %103 = call float @dx.op.tertiary.f32(i32 46, float 0x3FF19B3D00000000, float %82, float %102)  ; FMad(a,b,c)
  // float _103 = mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f));
  // %104 = call float @dx.op.tertiary.f32(i32 46, float 0x3FB353F7C0000000, float %86, float %103)  ; FMad(a,b,c)
  // float _104 = mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))));
  // %105 = fmul fast float %76, 0x3F7CAC0840000000
  // float _105 = (OCIOTransformXYZMatrix_000x) * 0.007000000216066837f;
  // %106 = call float @dx.op.tertiary.f32(i32 46, float 0x3FB32CA580000000, float %80, float %105)  ; FMad(a,b,c)
  // float _106 = mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f));
  // %107 = call float @dx.op.tertiary.f32(i32 46, float 0x3FEAFD2200000000, float %84, float %106)  ; FMad(a,b,c)
  // float _107 = mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))));
  // %108 = fmul fast float %77, 0x3F7CAC0840000000
  // float _108 = (OCIOTransformXYZMatrix_000y) * 0.007000000216066837f;
  // %109 = call float @dx.op.tertiary.f32(i32 46, float 0x3FB32CA580000000, float %81, float %108)  ; FMad(a,b,c)
  // float _109 = mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f));
  // %110 = call float @dx.op.tertiary.f32(i32 46, float 0x3FEAFD2200000000, float %85, float %109)  ; FMad(a,b,c)
  // float _110 = mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))));
  // %111 = fmul fast float %78, 0x3F7CAC0840000000
  // float _111 = (OCIOTransformXYZMatrix_000z) * 0.007000000216066837f;
  // %112 = call float @dx.op.tertiary.f32(i32 46, float 0x3FB32CA580000000, float %82, float %111)  ; FMad(a,b,c)
  // float _112 = mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f));
  // %113 = call float @dx.op.tertiary.f32(i32 46, float 0x3FEAFD2200000000, float %86, float %112)  ; FMad(a,b,c)
  // float _113 = mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))));
  // %114 = fmul fast float %89, 4.096000e+03
  // float _114 = (mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f;
  // %115 = fmul fast float %92, 4.096000e+03
  // float _115 = (mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f;
  // %116 = fmul fast float %95, 4.096000e+03
  // float _116 = (mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))))) * 4096.0f;
  // %117 = call float @dx.op.unary.f32(i32 26, float %114)  ; Round_ne(value)
  // float _117 = round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f));
  // %118 = call float @dx.op.unary.f32(i32 26, float %115)  ; Round_ne(value)
  // float _118 = round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f));
  // %119 = call float @dx.op.unary.f32(i32 26, float %116)  ; Round_ne(value)
  // float _119 = round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))))) * 4096.0f));
  // %120 = fmul fast float %118, 0x3F30000000000000
  // float _120 = (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f;
  // %121 = fmul fast float %119, 0x3F30000000000000
  // float _121 = (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f;
  // %122 = fmul fast float %98, 4.096000e+03
  // float _122 = (mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f;
  // %123 = fmul fast float %101, 4.096000e+03
  // float _123 = (mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f;
  // %124 = fmul fast float %104, 4.096000e+03
  // float _124 = (mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))))) * 4096.0f;
  // %125 = call float @dx.op.unary.f32(i32 26, float %122)  ; Round_ne(value)
  // float _125 = round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f));
  // %126 = call float @dx.op.unary.f32(i32 26, float %123)  ; Round_ne(value)
  // float _126 = round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f));
  // %127 = call float @dx.op.unary.f32(i32 26, float %124)  ; Round_ne(value)
  // float _127 = round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))))) * 4096.0f));
  // %128 = fmul fast float %126, 0x3F30000000000000
  // float _128 = (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f;
  // %129 = fmul fast float %127, 0x3F30000000000000
  // float _129 = (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f;
  // %130 = fmul fast float %107, 4.096000e+03
  // float _130 = (mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f;
  // %131 = fmul fast float %110, 4.096000e+03
  // float _131 = (mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f;
  // %132 = fmul fast float %113, 4.096000e+03
  // float _132 = (mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))))) * 4096.0f;
  // %133 = call float @dx.op.unary.f32(i32 26, float %130)  ; Round_ne(value)
  // float _133 = round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f));
  // %134 = call float @dx.op.unary.f32(i32 26, float %131)  ; Round_ne(value)
  // float _134 = round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f));
  // %135 = call float @dx.op.unary.f32(i32 26, float %132)  ; Round_ne(value)
  // float _135 = round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))))) * 4096.0f));
  // %136 = fmul fast float %134, 0x3F30000000000000
  // float _136 = (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f;
  // %137 = fmul fast float %135, 0x3F30000000000000
  // float _137 = (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f;
  // %138 = fmul fast float %34, 0x3F30000000000000
  float _138 = _34 * 0.000244140625f;
  // %139 = fmul fast float %138, %117
  // float _139 = _138 * (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f)));
  // %140 = call float @dx.op.tertiary.f32(i32 46, float %120, float %48, float %139)  ; FMad(a,b,c)
  // float _140 = mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _48, (_138 * (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f)))));
  // %141 = call float @dx.op.tertiary.f32(i32 46, float %121, float %62, float %140)  ; FMad(a,b,c)
  // float _141 = mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _62, (mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _48, (_138 * (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f)))))));
  // %142 = fmul fast float %138, %125
  // float _142 = _138 * (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f)));
  // %143 = call float @dx.op.tertiary.f32(i32 46, float %128, float %48, float %142)  ; FMad(a,b,c)
  // float _143 = mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _48, (_138 * (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f)))));
  // %144 = call float @dx.op.tertiary.f32(i32 46, float %129, float %62, float %143)  ; FMad(a,b,c)
  // float _144 = mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _62, (mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _48, (_138 * (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f)))))));
  // %145 = fmul fast float %138, %133
  // float _145 = _138 * (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f)));
  // %146 = call float @dx.op.tertiary.f32(i32 46, float %136, float %48, float %145)  ; FMad(a,b,c)
  // float _146 = mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _48, (_138 * (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f)))));
  // %147 = call float @dx.op.tertiary.f32(i32 46, float %137, float %62, float %146)  ; FMad(a,b,c)
  // float _147 = mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _62, (mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _48, (_138 * (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f)))))));
  // %148 = fmul fast float %141, 0x3F847AE140000000
  // float _148 = (mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _62, (mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _48, (_138 * (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f)))))))) * 0.009999999776482582f;
  // %149 = call float @dx.op.unary.f32(i32 23, float %148)  ; Log(value)
  // float _149 = log2(((mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _62, (mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _48, (_138 * (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f)))))))) * 0.009999999776482582f));
  // %150 = fmul fast float %149, 0x3FC4640000000000
  // float _150 = (log2(((mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _62, (mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _48, (_138 * (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f)))))))) * 0.009999999776482582f))) * 0.1593017578125f;
  // %151 = call float @dx.op.unary.f32(i32 21, float %150)  ; Exp(value)
  float _151 = exp2(((log2(((mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002z), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _62, (mad(((round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002y), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.35920000076293945f))))) * 4096.0f))) * 0.000244140625f), _48, (_138 * (round(((mad(-0.03579999879002571f, (OCIOTransformXYZMatrix_002x), (mad(0.6976000070571899f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.35920000076293945f))))) * 4096.0f)))))))) * 0.009999999776482582f))) * 0.1593017578125f));
  // %152 = fmul fast float %151, 0x4032DA0000000000
  // float _152 = _151 * 18.8515625f;
  // %153 = fadd fast float %152, 8.359375e-01
  // float _153 = (_151 * 18.8515625f) + 0.8359375f;
  // %154 = fmul fast float %151, 1.868750e+01
  // float _154 = _151 * 18.6875f;
  // %155 = fadd fast float %154, 1.000000e+00
  // float _155 = (_151 * 18.6875f) + 1.0f;
  // %156 = fdiv fast float %153, %155
  // float _156 = ((_151 * 18.8515625f) + 0.8359375f) / ((_151 * 18.6875f) + 1.0f);
  // %157 = call float @dx.op.unary.f32(i32 23, float %156)  ; Log(value)
  // float _157 = log2((((_151 * 18.8515625f) + 0.8359375f) / ((_151 * 18.6875f) + 1.0f)));
  // %158 = fmul fast float %157, 7.884375e+01
  // float _158 = (log2((((_151 * 18.8515625f) + 0.8359375f) / ((_151 * 18.6875f) + 1.0f)))) * 78.84375f;
  // %159 = call float @dx.op.unary.f32(i32 21, float %158)  ; Exp(value)
  // float _159 = exp2(((log2((((_151 * 18.8515625f) + 0.8359375f) / ((_151 * 18.6875f) + 1.0f)))) * 78.84375f));
  // %160 = call float @dx.op.unary.f32(i32 7, float %159)  ; Saturate(value)
  float _160 = saturate((exp2(((log2((((_151 * 18.8515625f) + 0.8359375f) / ((_151 * 18.6875f) + 1.0f)))) * 78.84375f))));
  // %161 = fmul fast float %144, 0x3F847AE140000000
  // float _161 = (mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _62, (mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _48, (_138 * (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f)))))))) * 0.009999999776482582f;
  // %162 = call float @dx.op.unary.f32(i32 23, float %161)  ; Log(value)
  // float _162 = log2(((mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _62, (mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _48, (_138 * (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f)))))))) * 0.009999999776482582f));
  // %163 = fmul fast float %162, 0x3FC4640000000000
  // float _163 = (log2(((mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _62, (mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _48, (_138 * (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f)))))))) * 0.009999999776482582f))) * 0.1593017578125f;
  // %164 = call float @dx.op.unary.f32(i32 21, float %163)  ; Exp(value)
  float _164 = exp2(((log2(((mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002z), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _62, (mad(((round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002y), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * -0.19220000505447388f))))) * 4096.0f))) * 0.000244140625f), _48, (_138 * (round(((mad(0.0754999965429306f, (OCIOTransformXYZMatrix_002x), (mad(1.1003999710083008f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * -0.19220000505447388f))))) * 4096.0f)))))))) * 0.009999999776482582f))) * 0.1593017578125f));
  // %165 = fmul fast float %164, 0x4032DA0000000000
  // float _165 = _164 * 18.8515625f;
  // %166 = fadd fast float %165, 8.359375e-01
  // float _166 = (_164 * 18.8515625f) + 0.8359375f;
  // %167 = fmul fast float %164, 1.868750e+01
  // float _167 = _164 * 18.6875f;
  // %168 = fadd fast float %167, 1.000000e+00
  // float _168 = (_164 * 18.6875f) + 1.0f;
  // %169 = fdiv fast float %166, %168
  // float _169 = ((_164 * 18.8515625f) + 0.8359375f) / ((_164 * 18.6875f) + 1.0f);
  // %170 = call float @dx.op.unary.f32(i32 23, float %169)  ; Log(value)
  // float _170 = log2((((_164 * 18.8515625f) + 0.8359375f) / ((_164 * 18.6875f) + 1.0f)));
  // %171 = fmul fast float %170, 7.884375e+01
  // float _171 = (log2((((_164 * 18.8515625f) + 0.8359375f) / ((_164 * 18.6875f) + 1.0f)))) * 78.84375f;
  // %172 = call float @dx.op.unary.f32(i32 21, float %171)  ; Exp(value)
  // float _172 = exp2(((log2((((_164 * 18.8515625f) + 0.8359375f) / ((_164 * 18.6875f) + 1.0f)))) * 78.84375f));
  // %173 = call float @dx.op.unary.f32(i32 7, float %172)  ; Saturate(value)
  float _173 = saturate((exp2(((log2((((_164 * 18.8515625f) + 0.8359375f) / ((_164 * 18.6875f) + 1.0f)))) * 78.84375f))));
  // %174 = fmul fast float %147, 0x3F847AE140000000
  // float _174 = (mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _62, (mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _48, (_138 * (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f)))))))) * 0.009999999776482582f;
  // %175 = call float @dx.op.unary.f32(i32 23, float %174)  ; Log(value)
  // float _175 = log2(((mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _62, (mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _48, (_138 * (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f)))))))) * 0.009999999776482582f));
  // %176 = fmul fast float %175, 0x3FC4640000000000
  // float _176 = (log2(((mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _62, (mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _48, (_138 * (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f)))))))) * 0.009999999776482582f))) * 0.1593017578125f;
  // %177 = call float @dx.op.unary.f32(i32 21, float %176)  ; Exp(value)
  float _177 = exp2(((log2(((mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002z), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001z), ((OCIOTransformXYZMatrix_000z) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _62, (mad(((round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002y), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001y), ((OCIOTransformXYZMatrix_000y) * 0.007000000216066837f))))) * 4096.0f))) * 0.000244140625f), _48, (_138 * (round(((mad(0.8434000015258789f, (OCIOTransformXYZMatrix_002x), (mad(0.07490000128746033f, (OCIOTransformXYZMatrix_001x), ((OCIOTransformXYZMatrix_000x) * 0.007000000216066837f))))) * 4096.0f)))))))) * 0.009999999776482582f))) * 0.1593017578125f));
  // %178 = fmul fast float %177, 0x4032DA0000000000
  // float _178 = _177 * 18.8515625f;
  // %179 = fadd fast float %178, 8.359375e-01
  // float _179 = (_177 * 18.8515625f) + 0.8359375f;
  // %180 = fmul fast float %177, 1.868750e+01
  // float _180 = _177 * 18.6875f;
  // %181 = fadd fast float %180, 1.000000e+00
  // float _181 = (_177 * 18.6875f) + 1.0f;
  // %182 = fdiv fast float %179, %181
  // float _182 = ((_177 * 18.8515625f) + 0.8359375f) / ((_177 * 18.6875f) + 1.0f);
  // %183 = call float @dx.op.unary.f32(i32 23, float %182)  ; Log(value)
  // float _183 = log2((((_177 * 18.8515625f) + 0.8359375f) / ((_177 * 18.6875f) + 1.0f)));
  // %184 = fmul fast float %183, 7.884375e+01
  // float _184 = (log2((((_177 * 18.8515625f) + 0.8359375f) / ((_177 * 18.6875f) + 1.0f)))) * 78.84375f;
  // %185 = call float @dx.op.unary.f32(i32 21, float %184)  ; Exp(value)
  // float _185 = exp2(((log2((((_177 * 18.8515625f) + 0.8359375f) / ((_177 * 18.6875f) + 1.0f)))) * 78.84375f));
  // %186 = call float @dx.op.unary.f32(i32 7, float %185)  ; Saturate(value)
  float _186 = saturate((exp2(((log2((((_177 * 18.8515625f) + 0.8359375f) / ((_177 * 18.6875f) + 1.0f)))) * 78.84375f))));
  // %187 = fadd fast float %173, %160
  // float _187 = _173 + _160;
  // %188 = fmul fast float %187, 5.000000e-01
  float _188 = (_173 + _160) * 0.5f;
  // %189 = call float @dx.op.dot3.f32(i32 55, float %160, float %173, float %186, float 6.610000e+03, float -1.361300e+04, float 7.003000e+03)  ; Dot3(ax,ay,az,bx,by,bz)
  // float _189 = dot(float3(_160, _173, _186), float3(6610.0f, -13613.0f, 7003.0f));
  // %190 = fmul fast float %189, 0x3F30000000000000
  // float _190 = (dot(float3(_160, _173, _186), float3(6610.0f, -13613.0f, 7003.0f))) * 0.000244140625f;
  // %191 = call float @dx.op.dot3.f32(i32 55, float %160, float %173, float %186, float 1.793300e+04, float -1.739000e+04, float -5.430000e+02)  ; Dot3(ax,ay,az,bx,by,bz)
  // float _191 = dot(float3(_160, _173, _186), float3(17933.0f, -17390.0f, -543.0f));
  // %192 = fmul fast float %191, 0x3F30000000000000
  // float _192 = (dot(float3(_160, _173, _186), float3(17933.0f, -17390.0f, -543.0f))) * 0.000244140625f;
  // %193 = extractvalue %dx.types.CBufRet.f32 %12, 0
  // float _193 = HDRMapping_009x;
  // %194 = fmul fast float %193, 0x3F847AE140000000
  float _194 = (HDRMapping_009x) * 0.009999999776482582f;
  // %195 = extractvalue %dx.types.CBufRet.f32 %12, 2
  // float _195 = HDRMapping_009z;
  // %196 = fmul fast float %195, 0x3F847AE140000000
  float _196 = (HDRMapping_009z) * 0.009999999776482582f;
  // %197 = extractvalue %dx.types.CBufRet.f32 %12, 1
  // float _197 = HDRMapping_009y;
  // %198 = call float @dx.op.unary.f32(i32 7, float %188)  ; Saturate(value)
  // float _198 = saturate(_188);
  // %199 = call float @dx.op.unary.f32(i32 23, float %198)  ; Log(value)
  // float _199 = log2((saturate(_188)));
  // %200 = fmul fast float %199, 0x3F89F9B580000000
  // float _200 = (log2((saturate(_188)))) * 0.012683313339948654f;
  // %201 = call float @dx.op.unary.f32(i32 21, float %200)  ; Exp(value)
  float _201 = exp2(((log2((saturate(_188)))) * 0.012683313339948654f));
  // %202 = fadd fast float %201, -8.359375e-01
  // float _202 = _201 + -0.8359375f;
  // %203 = call float @dx.op.binary.f32(i32 35, float 0.000000e+00, float %202)  ; FMax(a,b)
  // float _203 = max(0.0f, (_201 + -0.8359375f));
  // %204 = fmul fast float %201, 1.868750e+01
  // float _204 = _201 * 18.6875f;
  // %205 = fsub fast float 0x4032DA0000000000, %204
  // float _205 = 18.8515625f - (_201 * 18.6875f);
  // %206 = fdiv fast float %203, %205
  // float _206 = (max(0.0f, (_201 + -0.8359375f))) / (18.8515625f - (_201 * 18.6875f));
  // %207 = call float @dx.op.unary.f32(i32 23, float %206)  ; Log(value)
  // float _207 = log2(((max(0.0f, (_201 + -0.8359375f))) / (18.8515625f - (_201 * 18.6875f))));
  // %208 = fmul fast float %207, 0x40191C0D60000000
  // float _208 = (log2(((max(0.0f, (_201 + -0.8359375f))) / (18.8515625f - (_201 * 18.6875f))))) * 6.277394771575928f;
  // %209 = call float @dx.op.unary.f32(i32 21, float %208)  ; Exp(value)
  // float _209 = exp2(((log2(((max(0.0f, (_201 + -0.8359375f))) / (18.8515625f - (_201 * 18.6875f))))) * 6.277394771575928f));
  // %210 = fmul fast float %209, 1.000000e+02
  float _210 = (exp2(((log2(((max(0.0f, (_201 + -0.8359375f))) / (18.8515625f - (_201 * 18.6875f))))) * 6.277394771575928f))) * 100.0f;
  // %211 = fcmp fast oeq float %194, 0.000000e+00
  // bool _211 = (_194 == 0.0f);
  _246 = _210;
  if (!((_194 == 0.0f))) {
    // fn:start 212
    // fn:pending 245
    // %213 = call float @dx.op.binary.f32(i32 35, float %196, float 0.000000e+00)  ; FMax(a,b)
    float _213 = max(_196, 0.0f);
    // %214 = fsub fast float %194, %213
    // float _214 = _194 - _213;
    // %215 = fsub fast float %210, %213
    // float _215 = _210 - _213;
    // %216 = fdiv fast float %215, %214
    // float _216 = (_210 - _213) / (_194 - _213);
    // %217 = call float @dx.op.unary.f32(i32 7, float %216)  ; Saturate(value)
    float _217 = saturate(((_210 - _213) / (_194 - _213)));
    // %218 = fmul fast float %217, 2.000000e+00
    // float _218 = _217 * 2.0f;
    // %219 = fsub fast float 3.000000e+00, %218
    // float _219 = 3.0f - (_217 * 2.0f);
    // %220 = fmul fast float %217, %217
    // float _220 = _217 * _217;
    // %221 = fmul fast float %220, %219
    // float _221 = (_217 * _217) * (3.0f - (_217 * 2.0f));
    // %222 = fsub fast float 1.000000e+00, %221
    // float _222 = 1.0f - ((_217 * _217) * (3.0f - (_217 * 2.0f)));
    // %223 = fcmp fast ugt float %210, %196
    // bool _223 = !(_210 <= _196);
    _238 = 0.0f;
    do {
      if ((!(_210 <= _196))) {
        // fn:start 224
        // fn:pending 245, 237
        // %225 = fcmp fast ult float %196, 0.000000e+00
        // bool _225 = !(_196 >= 0.0f);
        if (!(!(_196 >= 0.0f))) {
          // fn:start 226
          // fn:pending 245, 237
          // %227 = fadd fast float %196, -1.000000e+00
          // float _227 = _196 + -1.0f;
          // %228 = fdiv fast float -1.000000e+00, %227
          float _228 = -1.0f / (_196 + -1.0f);
          // %229 = fsub fast float 1.000000e+00, %228
          // float _229 = 1.0f - _228;
          // %230 = fmul fast float %228, %210
          // float _230 = _228 * _210;
          // %231 = fadd fast float %229, %230
          // float _231 = (1.0f - _228) + (_228 * _210);
          _238 = ((1.0f - _228) + (_228 * _210));
          // fn:converge 226 => 237
        } else {
          // fn:start 232
          // fn:pending 245, 237
          // %233 = fsub fast float -1.000000e+00, %196
          // float _233 = -1.0f - _196;
          // %234 = fsub fast float -0.000000e+00, %196
          // float _234 = -0.0f - _196;
          // %235 = fmul fast float %210, %233
          // float _235 = _210 * (-1.0f - _196);
          // %236 = fsub fast float %234, %235
          // float _236 = (-0.0f - _196) - (_210 * (-1.0f - _196));
          _238 = ((-0.0f - _196) - (_210 * (-1.0f - _196)));
          // fn:converge 232 => 237
        }
      }
      // fn:start 237
      // fn:pending 245
      // %239 = call float @dx.op.unary.f32(i32 23, float %238)  ; Log(value)
      // float _239 = log2(_238);
      // %240 = fmul fast float %239, %197
      // float _240 = (log2(_238)) * (HDRMapping_009y);
      // %241 = call float @dx.op.unary.f32(i32 21, float %240)  ; Exp(value)
      // float _241 = exp2(((log2(_238)) * (HDRMapping_009y)));
      // %242 = fsub fast float %241, %210
      // float _242 = (exp2(((log2(_238)) * (HDRMapping_009y)))) - _210;
      // %243 = fmul fast float %242, %222
      // float _243 = ((exp2(((log2(_238)) * (HDRMapping_009y)))) - _210) * (1.0f - ((_217 * _217) * (3.0f - (_217 * 2.0f))));
      // %244 = fadd fast float %243, %210
      // float _244 = (((exp2(((log2(_238)) * (HDRMapping_009y)))) - _210) * (1.0f - ((_217 * _217) * (3.0f - (_217 * 2.0f))))) + _210;
      _246 = ((((exp2(((log2(_238)) * (HDRMapping_009y)))) - _210) * (1.0f - ((_217 * _217) * (3.0f - (_217 * 2.0f))))) + _210);
      // fn:converge 237 => 245
    } while (false);
  }
  // fn:start 245
  // %247 = fcmp fast oeq float %14, %11
  // bool _247 = (_14 == _11);
  // %248 = fcmp fast ogt float %246, %11
  // bool _248 = (_246 > _11);
  // %249 = and i1 %247, %248
  // bool _249 = ((bool)((_14 == _11))) && ((bool)((_246 > _11)));
  _296 = _11;
  if (!(((bool)((_14 == _11))) && ((bool)((_246 > _11))))) {
    // fn:start 250
    // fn:pending 295
    // %252 = extractvalue %dx.types.CBufRet.f32 %251, 0
    // float _252 = HDRMapping_010x;
    // %253 = fsub fast float 1.000000e+00, %13
    // float _253 = 1.0f - (HDRMapping_009w);
    // %254 = fmul fast float %253, %11
    float _254 = (1.0f - (HDRMapping_009w)) * _11;
    // %255 = fsub fast float %11, %254
    float _255 = _11 - _254;
    // %256 = call float @dx.op.unary.f32(i32 21, float %252)  ; Exp(value)
    float _256 = exp2((HDRMapping_010x));
    // %257 = fdiv fast float 1.000000e+00, %256
    // float _257 = 1.0f / _256;
    // %258 = fmul fast float %257, %246
    // float _258 = (1.0f / _256) * _246;
    // %259 = fdiv fast float %255, %256
    float _259 = _255 / _256;
    // %260 = fsub fast float %11, %259
    float _260 = _11 - _259;
    // %261 = fsub fast float %258, %11
    float _261 = ((1.0f / _256) * _246) - _11;
    // %262 = fcmp olt float %261, -0.000000e+00
    // bool _262 = (_261 < -0.0f);
    _291 = -0.0f;
    do {
      if (((_261 < -0.0f))) {
        // fn:start 263
        // fn:pending 295, 290
        // %265 = extractvalue %dx.types.CBufRet.f32 %264, 0
        // float _265 = HDRMapping_014x;
        // %266 = fadd fast float %265, -5.000000e-01
        // float _266 = (HDRMapping_014x) + -0.5f;
        // %267 = call float @dx.op.binary.f32(i32 36, float %252, float 1.000000e+00)  ; FMin(a,b)
        // float _267 = min((HDRMapping_010x), 1.0f);
        // %268 = fmul fast float %266, %267
        // float _268 = ((HDRMapping_014x) + -0.5f) * (min((HDRMapping_010x), 1.0f));
        // %269 = fadd fast float %268, 5.000000e-01
        // float _269 = (((HDRMapping_014x) + -0.5f) * (min((HDRMapping_010x), 1.0f))) + 0.5f;
        // %270 = fmul fast float %269, 2.000000e+00
        // float _270 = ((((HDRMapping_014x) + -0.5f) * (min((HDRMapping_010x), 1.0f))) + 0.5f) * 2.0f;
        // %271 = fcmp fast oeq float %259, 0.000000e+00
        // bool _271 = (_259 == 0.0f);
        // %272 = fdiv fast float %255, %259
        // float _272 = _255 / _259;
        // %273 = select i1 %271, float 1.000000e+00, float %272
        // float _273 = (((bool)((_259 == 0.0f))) ? 1.0f : (_255 / _259));
        // %274 = fmul fast float %270, %273
        // float _274 = (((((HDRMapping_014x) + -0.5f) * (min((HDRMapping_010x), 1.0f))) + 0.5f) * 2.0f) * ((((bool)((_259 == 0.0f))) ? 1.0f : (_255 / _259)));
        // %275 = fsub fast float -0.000000e+00, %261
        // float _275 = -0.0f - _261;
        // %276 = fmul fast float %274, %260
        // float _276 = ((((((HDRMapping_014x) + -0.5f) * (min((HDRMapping_010x), 1.0f))) + 0.5f) * 2.0f) * ((((bool)((_259 == 0.0f))) ? 1.0f : (_255 / _259)))) * _260;
        // %277 = fdiv fast float %276, %254
        float _277 = (((((((HDRMapping_014x) + -0.5f) * (min((HDRMapping_010x), 1.0f))) + 0.5f) * 2.0f) * ((((bool)((_259 == 0.0f))) ? 1.0f : (_255 / _259)))) * _260) / _254;
        // %278 = call float @dx.op.unary.f32(i32 23, float %254)  ; Log(value)
        // float _278 = log2(_254);
        // %279 = call float @dx.op.unary.f32(i32 23, float %260)  ; Log(value)
        // float _279 = log2(_260);
        // %280 = fmul fast float %277, 0xBFE62E4300000000
        // float _280 = _277 * -0.6931471824645996f;
        // %281 = fmul fast float %280, %279
        // float _281 = (_277 * -0.6931471824645996f) * (log2(_260));
        // %282 = call float @dx.op.unary.f32(i32 23, float %275)  ; Log(value)
        // float _282 = log2((-0.0f - _261));
        // %283 = fmul fast float %282, %277
        // float _283 = (log2((-0.0f - _261))) * _277;
        // %284 = fadd fast float %283, %278
        // float _284 = ((log2((-0.0f - _261))) * _277) + (log2(_254));
        // %285 = fmul fast float %284, 0x3FE62E4300000000
        // float _285 = (((log2((-0.0f - _261))) * _277) + (log2(_254))) * 0.6931471824645996f;
        // %286 = fadd fast float %285, %281
        // float _286 = ((((log2((-0.0f - _261))) * _277) + (log2(_254))) * 0.6931471824645996f) + ((_277 * -0.6931471824645996f) * (log2(_260)));
        // %287 = fmul fast float %286, 0x3FF7154760000000
        // float _287 = (((((log2((-0.0f - _261))) * _277) + (log2(_254))) * 0.6931471824645996f) + ((_277 * -0.6931471824645996f) * (log2(_260)))) * 1.4426950216293335f;
        // %288 = call float @dx.op.unary.f32(i32 21, float %287)  ; Exp(value)
        // float _288 = exp2(((((((log2((-0.0f - _261))) * _277) + (log2(_254))) * 0.6931471824645996f) + ((_277 * -0.6931471824645996f) * (log2(_260)))) * 1.4426950216293335f));
        // %289 = fsub float -0.000000e+00, %288
        // float _289 = -0.0f - (exp2(((((((log2((-0.0f - _261))) * _277) + (log2(_254))) * 0.6931471824645996f) + ((_277 * -0.6931471824645996f) * (log2(_260)))) * 1.4426950216293335f)));
        _291 = (-0.0f - (exp2(((((((log2((-0.0f - _261))) * _277) + (log2(_254))) * 0.6931471824645996f) + ((_277 * -0.6931471824645996f) * (log2(_260)))) * 1.4426950216293335f))));
        // fn:converge 263 => 290
      }
      // fn:start 290
      // fn:pending 295
      // %292 = fadd fast float %291, %11
      // float _292 = _291 + _11;
      // %293 = fcmp fast ole float %246, %14
      // bool _293 = (_246 <= _14);
      // %294 = select i1 %293, float %246, float %292
      // float _294 = (((bool)((_246 <= _14))) ? _246 : (_291 + _11));
      _296 = ((((bool)((_246 <= _14))) ? _246 : (_291 + _11)));
      // fn:converge 290 => 295
    } while (false);
  }
  // fn:start 295
  // %297 = fmul fast float %296, 0x3F847AE140000000
  // float _297 = _296 * 0.009999999776482582f;
  // %298 = call float @dx.op.unary.f32(i32 23, float %297)  ; Log(value)
  // float _298 = log2((_296 * 0.009999999776482582f));
  // %299 = fmul fast float %298, 0x3FC4640000000000
  // float _299 = (log2((_296 * 0.009999999776482582f))) * 0.1593017578125f;
  // %300 = call float @dx.op.unary.f32(i32 21, float %299)  ; Exp(value)
  float _300 = exp2(((log2((_296 * 0.009999999776482582f))) * 0.1593017578125f));
  // %301 = fmul fast float %300, 0x4032DA0000000000
  // float _301 = _300 * 18.8515625f;
  // %302 = fadd fast float %301, 8.359375e-01
  // float _302 = (_300 * 18.8515625f) + 0.8359375f;
  // %303 = fmul fast float %300, 1.868750e+01
  // float _303 = _300 * 18.6875f;
  // %304 = fadd fast float %303, 1.000000e+00
  // float _304 = (_300 * 18.6875f) + 1.0f;
  // %305 = fdiv fast float %302, %304
  // float _305 = ((_300 * 18.8515625f) + 0.8359375f) / ((_300 * 18.6875f) + 1.0f);
  // %306 = call float @dx.op.unary.f32(i32 23, float %305)  ; Log(value)
  // float _306 = log2((((_300 * 18.8515625f) + 0.8359375f) / ((_300 * 18.6875f) + 1.0f)));
  // %307 = fmul fast float %306, 7.884375e+01
  // float _307 = (log2((((_300 * 18.8515625f) + 0.8359375f) / ((_300 * 18.6875f) + 1.0f)))) * 78.84375f;
  // %308 = call float @dx.op.unary.f32(i32 21, float %307)  ; Exp(value)
  // float _308 = exp2(((log2((((_300 * 18.8515625f) + 0.8359375f) / ((_300 * 18.6875f) + 1.0f)))) * 78.84375f));
  // %309 = call float @dx.op.unary.f32(i32 7, float %308)  ; Saturate(value)
  float _309 = saturate((exp2(((log2((((_300 * 18.8515625f) + 0.8359375f) / ((_300 * 18.6875f) + 1.0f)))) * 78.84375f))));
  // %311 = extractvalue %dx.types.CBufRet.f32 %310, 2
  // float _311 = HDRMapping_010z;
  // %312 = fmul fast float %190, %311
  // float _312 = ((dot(float3(_160, _173, _186), float3(6610.0f, -13613.0f, 7003.0f))) * 0.000244140625f) * (HDRMapping_010z);
  // %313 = fmul fast float %192, %311
  // float _313 = ((dot(float3(_160, _173, _186), float3(17933.0f, -17390.0f, -543.0f))) * 0.000244140625f) * (HDRMapping_010z);
  // %314 = fdiv fast float %309, %188
  // float _314 = _309 / _188;
  // %315 = fdiv fast float %188, %309
  // float _315 = _188 / _309;
  // %316 = call float @dx.op.binary.f32(i32 36, float %315, float %314)  ; FMin(a,b)
  float _316 = min((_188 / _309), (_309 / _188));
  // %317 = fmul fast float %312, %316
  float _317 = (((dot(float3(_160, _173, _186), float3(6610.0f, -13613.0f, 7003.0f))) * 0.000244140625f) * (HDRMapping_010z)) * _316;
  // %318 = fmul fast float %313, %316
  float _318 = (((dot(float3(_160, _173, _186), float3(17933.0f, -17390.0f, -543.0f))) * 0.000244140625f) * (HDRMapping_010z)) * _316;
  // %319 = call float @dx.op.tertiary.f32(i32 46, float 0x3F826E9780000000, float %317, float %309)  ; FMad(a,b,c)
  // float _319 = mad(0.008999999612569809f, _317, _309);
  // %320 = call float @dx.op.tertiary.f32(i32 46, float 0x3FBC6A7F00000000, float %318, float %319)  ; FMad(a,b,c)
  // float _320 = mad(0.11100000143051147f, _318, (mad(0.008999999612569809f, _317, _309)));
  // %321 = call float @dx.op.tertiary.f32(i32 46, float 0xBF826E9780000000, float %317, float %309)  ; FMad(a,b,c)
  // float _321 = mad(-0.008999999612569809f, _317, _309);
  // %322 = call float @dx.op.tertiary.f32(i32 46, float 0xBFBC6A7F00000000, float %318, float %321)  ; FMad(a,b,c)
  // float _322 = mad(-0.11100000143051147f, _318, (mad(-0.008999999612569809f, _317, _309)));
  // %323 = call float @dx.op.tertiary.f32(i32 46, float 0x3FE1EB8520000000, float %317, float %309)  ; FMad(a,b,c)
  // float _323 = mad(0.5600000023841858f, _317, _309);
  // %324 = call float @dx.op.tertiary.f32(i32 46, float 0xBFD48B43A0000000, float %318, float %323)  ; FMad(a,b,c)
  // float _324 = mad(-0.32100000977516174f, _318, (mad(0.5600000023841858f, _317, _309)));
  // %325 = call float @dx.op.unary.f32(i32 7, float %320)  ; Saturate(value)
  // float _325 = saturate((mad(0.11100000143051147f, _318, (mad(0.008999999612569809f, _317, _309)))));
  // %326 = call float @dx.op.unary.f32(i32 23, float %325)  ; Log(value)
  // float _326 = log2((saturate((mad(0.11100000143051147f, _318, (mad(0.008999999612569809f, _317, _309)))))));
  // %327 = fmul fast float %326, 0x3F89F9B580000000
  // float _327 = (log2((saturate((mad(0.11100000143051147f, _318, (mad(0.008999999612569809f, _317, _309)))))))) * 0.012683313339948654f;
  // %328 = call float @dx.op.unary.f32(i32 21, float %327)  ; Exp(value)
  float _328 = exp2(((log2((saturate((mad(0.11100000143051147f, _318, (mad(0.008999999612569809f, _317, _309)))))))) * 0.012683313339948654f));
  // %329 = fadd fast float %328, -8.359375e-01
  // float _329 = _328 + -0.8359375f;
  // %330 = call float @dx.op.binary.f32(i32 35, float 0.000000e+00, float %329)  ; FMax(a,b)
  // float _330 = max(0.0f, (_328 + -0.8359375f));
  // %331 = fmul fast float %328, 1.868750e+01
  // float _331 = _328 * 18.6875f;
  // %332 = fsub fast float 0x4032DA0000000000, %331
  // float _332 = 18.8515625f - (_328 * 18.6875f);
  // %333 = fdiv fast float %330, %332
  // float _333 = (max(0.0f, (_328 + -0.8359375f))) / (18.8515625f - (_328 * 18.6875f));
  // %334 = call float @dx.op.unary.f32(i32 23, float %333)  ; Log(value)
  // float _334 = log2(((max(0.0f, (_328 + -0.8359375f))) / (18.8515625f - (_328 * 18.6875f))));
  // %335 = fmul fast float %334, 0x40191C0D60000000
  // float _335 = (log2(((max(0.0f, (_328 + -0.8359375f))) / (18.8515625f - (_328 * 18.6875f))))) * 6.277394771575928f;
  // %336 = call float @dx.op.unary.f32(i32 21, float %335)  ; Exp(value)
  float _336 = exp2(((log2(((max(0.0f, (_328 + -0.8359375f))) / (18.8515625f - (_328 * 18.6875f))))) * 6.277394771575928f));
  // %337 = call float @dx.op.unary.f32(i32 7, float %322)  ; Saturate(value)
  // float _337 = saturate((mad(-0.11100000143051147f, _318, (mad(-0.008999999612569809f, _317, _309)))));
  // %338 = call float @dx.op.unary.f32(i32 23, float %337)  ; Log(value)
  // float _338 = log2((saturate((mad(-0.11100000143051147f, _318, (mad(-0.008999999612569809f, _317, _309)))))));
  // %339 = fmul fast float %338, 0x3F89F9B580000000
  // float _339 = (log2((saturate((mad(-0.11100000143051147f, _318, (mad(-0.008999999612569809f, _317, _309)))))))) * 0.012683313339948654f;
  // %340 = call float @dx.op.unary.f32(i32 21, float %339)  ; Exp(value)
  float _340 = exp2(((log2((saturate((mad(-0.11100000143051147f, _318, (mad(-0.008999999612569809f, _317, _309)))))))) * 0.012683313339948654f));
  // %341 = fadd fast float %340, -8.359375e-01
  // float _341 = _340 + -0.8359375f;
  // %342 = call float @dx.op.binary.f32(i32 35, float 0.000000e+00, float %341)  ; FMax(a,b)
  // float _342 = max(0.0f, (_340 + -0.8359375f));
  // %343 = fmul fast float %340, 1.868750e+01
  // float _343 = _340 * 18.6875f;
  // %344 = fsub fast float 0x4032DA0000000000, %343
  // float _344 = 18.8515625f - (_340 * 18.6875f);
  // %345 = fdiv fast float %342, %344
  // float _345 = (max(0.0f, (_340 + -0.8359375f))) / (18.8515625f - (_340 * 18.6875f));
  // %346 = call float @dx.op.unary.f32(i32 23, float %345)  ; Log(value)
  // float _346 = log2(((max(0.0f, (_340 + -0.8359375f))) / (18.8515625f - (_340 * 18.6875f))));
  // %347 = fmul fast float %346, 0x40191C0D60000000
  // float _347 = (log2(((max(0.0f, (_340 + -0.8359375f))) / (18.8515625f - (_340 * 18.6875f))))) * 6.277394771575928f;
  // %348 = call float @dx.op.unary.f32(i32 21, float %347)  ; Exp(value)
  // float _348 = exp2(((log2(((max(0.0f, (_340 + -0.8359375f))) / (18.8515625f - (_340 * 18.6875f))))) * 6.277394771575928f));
  // %349 = fmul fast float %348, 1.000000e+02
  float _349 = (exp2(((log2(((max(0.0f, (_340 + -0.8359375f))) / (18.8515625f - (_340 * 18.6875f))))) * 6.277394771575928f))) * 100.0f;
  // %350 = call float @dx.op.unary.f32(i32 7, float %324)  ; Saturate(value)
  // float _350 = saturate((mad(-0.32100000977516174f, _318, (mad(0.5600000023841858f, _317, _309)))));
  // %351 = call float @dx.op.unary.f32(i32 23, float %350)  ; Log(value)
  // float _351 = log2((saturate((mad(-0.32100000977516174f, _318, (mad(0.5600000023841858f, _317, _309)))))));
  // %352 = fmul fast float %351, 0x3F89F9B580000000
  // float _352 = (log2((saturate((mad(-0.32100000977516174f, _318, (mad(0.5600000023841858f, _317, _309)))))))) * 0.012683313339948654f;
  // %353 = call float @dx.op.unary.f32(i32 21, float %352)  ; Exp(value)
  float _353 = exp2(((log2((saturate((mad(-0.32100000977516174f, _318, (mad(0.5600000023841858f, _317, _309)))))))) * 0.012683313339948654f));
  // %354 = fadd fast float %353, -8.359375e-01
  // float _354 = _353 + -0.8359375f;
  // %355 = call float @dx.op.binary.f32(i32 35, float 0.000000e+00, float %354)  ; FMax(a,b)
  // float _355 = max(0.0f, (_353 + -0.8359375f));
  // %356 = fmul fast float %353, 1.868750e+01
  // float _356 = _353 * 18.6875f;
  // %357 = fsub fast float 0x4032DA0000000000, %356
  // float _357 = 18.8515625f - (_353 * 18.6875f);
  // %358 = fdiv fast float %355, %357
  // float _358 = (max(0.0f, (_353 + -0.8359375f))) / (18.8515625f - (_353 * 18.6875f));
  // %359 = call float @dx.op.unary.f32(i32 23, float %358)  ; Log(value)
  // float _359 = log2(((max(0.0f, (_353 + -0.8359375f))) / (18.8515625f - (_353 * 18.6875f))));
  // %360 = fmul fast float %359, 0x40191C0D60000000
  // float _360 = (log2(((max(0.0f, (_353 + -0.8359375f))) / (18.8515625f - (_353 * 18.6875f))))) * 6.277394771575928f;
  // %361 = call float @dx.op.unary.f32(i32 21, float %360)  ; Exp(value)
  // float _361 = exp2(((log2(((max(0.0f, (_353 + -0.8359375f))) / (18.8515625f - (_353 * 18.6875f))))) * 6.277394771575928f));
  // %362 = fmul fast float %361, 1.000000e+02
  float _362 = (exp2(((log2(((max(0.0f, (_353 + -0.8359375f))) / (18.8515625f - (_353 * 18.6875f))))) * 6.277394771575928f))) * 100.0f;
  // %363 = fmul fast float %336, 0x4069E33340000000
  // float _363 = _336 * 207.10000610351562f;
  // %364 = call float @dx.op.tertiary.f32(i32 46, float 0xBFF53B6460000000, float %349, float %363)  ; FMad(a,b,c)
  // float _364 = mad(-1.3270000219345093f, _349, (_336 * 207.10000610351562f));
  // %365 = call float @dx.op.tertiary.f32(i32 46, float 0x3FCA7EF9E0000000, float %362, float %364)  ; FMad(a,b,c)
  float _365 = mad(0.2070000022649765f, _362, (mad(-1.3270000219345093f, _349, (_336 * 207.10000610351562f))));
  // %366 = fmul fast float %336, 3.650000e+01
  // float _366 = _336 * 36.5f;
  // %367 = call float @dx.op.tertiary.f32(i32 46, float 0x3FE5CAC080000000, float %349, float %366)  ; FMad(a,b,c)
  // float _367 = mad(0.6809999942779541f, _349, (_336 * 36.5f));
  // %368 = call float @dx.op.tertiary.f32(i32 46, float 0xBFA70A3D80000000, float %362, float %367)  ; FMad(a,b,c)
  float _368 = mad(-0.04500000178813934f, _362, (mad(0.6809999942779541f, _349, (_336 * 36.5f))));
  // %369 = fmul fast float %336, 0xC0139999A0000000
  // float _369 = _336 * -4.900000095367432f;
  // %370 = call float @dx.op.tertiary.f32(i32 46, float 0xBFA99999A0000000, float %349, float %369)  ; FMad(a,b,c)
  // float _370 = mad(-0.05000000074505806f, _349, (_336 * -4.900000095367432f));
  // %371 = call float @dx.op.tertiary.f32(i32 46, float 0x3FF3020C40000000, float %362, float %370)  ; FMad(a,b,c)
  float _371 = mad(1.187999963760376f, _362, (mad(-0.05000000074505806f, _349, (_336 * -4.900000095367432f))));
  // %372 = fmul fast float %365, %64
  // float _372 = _365 * (OCIOTransformXYZMatrix_004x);
  // %373 = call float @dx.op.tertiary.f32(i32 46, float %65, float %368, float %372)  ; FMad(a,b,c)
  // float _373 = mad((OCIOTransformXYZMatrix_004y), _368, (_365 * (OCIOTransformXYZMatrix_004x)));
  // %374 = call float @dx.op.tertiary.f32(i32 46, float %66, float %371, float %373)  ; FMad(a,b,c)
  float _374 = mad((OCIOTransformXYZMatrix_004z), _371, (mad((OCIOTransformXYZMatrix_004y), _368, (_365 * (OCIOTransformXYZMatrix_004x)))));
  // %375 = fmul fast float %365, %68
  // float _375 = _365 * (OCIOTransformXYZMatrix_005x);
  // %376 = call float @dx.op.tertiary.f32(i32 46, float %69, float %368, float %375)  ; FMad(a,b,c)
  // float _376 = mad((OCIOTransformXYZMatrix_005y), _368, (_365 * (OCIOTransformXYZMatrix_005x)));
  // %377 = call float @dx.op.tertiary.f32(i32 46, float %70, float %371, float %376)  ; FMad(a,b,c)
  float _377 = mad((OCIOTransformXYZMatrix_005z), _371, (mad((OCIOTransformXYZMatrix_005y), _368, (_365 * (OCIOTransformXYZMatrix_005x)))));
  // %378 = fmul fast float %365, %72
  // float _378 = _365 * (OCIOTransformXYZMatrix_006x);
  // %379 = call float @dx.op.tertiary.f32(i32 46, float %73, float %368, float %378)  ; FMad(a,b,c)
  // float _379 = mad((OCIOTransformXYZMatrix_006y), _368, (_365 * (OCIOTransformXYZMatrix_006x)));
  // %380 = call float @dx.op.tertiary.f32(i32 46, float %74, float %371, float %379)  ; FMad(a,b,c)
  float _380 = mad((OCIOTransformXYZMatrix_006z), _371, (mad((OCIOTransformXYZMatrix_006y), _368, (_365 * (OCIOTransformXYZMatrix_006x)))));
  // %381 = fmul fast float %374, 0x3FE39EA4E0000000
  // float _381 = _374 * 0.6131157279014587f;
  // %382 = call float @dx.op.tertiary.f32(i32 46, float %377, float 0x3FD5BA8880000000, float %381)  ; FMad(a,b,c)
  // float _382 = mad(_377, 0.33951008319854736f, (_374 * 0.6131157279014587f));
  // %383 = call float @dx.op.tertiary.f32(i32 46, float %380, float 0x3FA8418280000000, float %382)  ; FMad(a,b,c)
  // float _383 = mad(_380, 0.047374799847602844f, (mad(_377, 0.33951008319854736f, (_374 * 0.6131157279014587f))));
  // %384 = fmul fast float %374, 0x3FB1F870E0000000
  // float _384 = _374 * 0.07019715756177902f;
  // %385 = call float @dx.op.tertiary.f32(i32 46, float %377, float 0x3FED52C7C0000000, float %384)  ; FMad(a,b,c)
  // float _385 = mad(_377, 0.9163550138473511f, (_374 * 0.07019715756177902f));
  // %386 = call float @dx.op.tertiary.f32(i32 46, float %380, float 0x3F8B8B37A0000000, float %385)  ; FMad(a,b,c)
  // float _386 = mad(_380, 0.013449129648506641f, (mad(_377, 0.9163550138473511f, (_374 * 0.07019715756177902f))));
  // %387 = fmul fast float %374, 0x3F951D2AC0000000
  // float _387 = _374 * 0.020619075745344162f;
  // %388 = call float @dx.op.tertiary.f32(i32 46, float %377, float 0x3FBC0D6F40000000, float %387)  ; FMad(a,b,c)
  // float _388 = mad(_377, 0.10957999527454376f, (_374 * 0.020619075745344162f));
  // %389 = call float @dx.op.tertiary.f32(i32 46, float %380, float 0x3FEBD56860000000, float %388)  ; FMad(a,b,c)
  // float _389 = mad(_380, 0.8698007464408875f, (mad(_377, 0.10957999527454376f, (_374 * 0.020619075745344162f))));
  // %390 = call %dx.types.Handle @dx.op.annotateHandle(i32 216, %dx.types.Handle %1, %dx.types.ResourceProperties { i32 4100, i32 1033 })  ; AnnotateHandle(res,props)  resource: RWTexture3D<4xF32>
  // auto _390 = _1;
  OutLUT[int3(((uint)(SV_DispatchThreadID.x)), ((uint)(SV_DispatchThreadID.y)), ((uint)(SV_DispatchThreadID.z)))] = float4((mad(_380, 0.047374799847602844f, (mad(_377, 0.33951008319854736f, (_374 * 0.6131157279014587f))))), (mad(_380, 0.013449129648506641f, (mad(_377, 0.9163550138473511f, (_374 * 0.07019715756177902f))))), (mad(_380, 0.8698007464408875f, (mad(_377, 0.10957999527454376f, (_374 * 0.020619075745344162f))))), 1.0f);
}
