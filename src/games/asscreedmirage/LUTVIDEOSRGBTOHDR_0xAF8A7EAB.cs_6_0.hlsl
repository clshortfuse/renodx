static const float _22[5] = { -4.0f, -4.0f, -3.1573765277862548828125f, -0.485249996185302734375f, 1.84773242473602294921875f };
static const float _29[5] = { -0.718548238277435302734375f, 2.0810306072235107421875f, 3.66812419891357421875f, 4.0f, 4.0f };
static const float _41[9] = { -1.69896996021270751953125f, -1.69896996021270751953125f, -1.477900028228759765625f, -1.2290999889373779296875f, -0.864799976348876953125f, -0.448000013828277587890625f, 0.0051799998618662357330322265625f, 0.451108038425445556640625f, 0.91137444972991943359375f };
static const float _53[9] = { 0.51543867588043212890625f, 0.8470437526702880859375f, 1.13580000400543212890625f, 1.38020002841949462890625f, 1.51970005035400390625f, 1.5985000133514404296875f, 1.64670002460479736328125f, 1.67460918426513671875f, 1.687873363494873046875f };

cbuffer _13_15 : register(b0, space6) {
  float4 _15_m0[10] : packoffset(c0);
};

RWTexture3D<float4> _8 : register(u0, space6);

static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

void comp_main() {
  float _72 = float(gl_GlobalInvocationID.x);
  float _73 = float(gl_GlobalInvocationID.y);
  float _74 = float(gl_GlobalInvocationID.z);
  float _75 = _72 * 0.0322580635547637939453125f;
  float _77 = _73 * 0.0322580635547637939453125f;
  float _78 = _74 * 0.0322580635547637939453125f;
  float _1131;
  float _1133;
  float _1135;
  if (asuint(_15_m0[8u]).x == 0u) {
    float _328;
    float _722;
    float _378;
#if 0
    if (_75 < 0.039285711944103240966796875f) {
      _328 = _72 * 0.00249613262712955474853515625f;
    } else {
      _328 = exp2(log2((_72 * 0.03057636506855487823486328125f) + 0.052132703363895416259765625f) * 2.400000095367431640625f);
    }
    if (_77 < 0.039285711944103240966796875f) {
      _378 = _73 * 0.00249613262712955474853515625f;
    } else {
      _378 = exp2(log2((_73 * 0.03057636506855487823486328125f) + 0.052132703363895416259765625f) * 2.400000095367431640625f);
    }
    if (_78 < 0.039285711944103240966796875f) {
      _722 = _74 * 0.00249613262712955474853515625f;
    } else {
      _722 = exp2(log2((_74 * 0.03057636506855487823486328125f) + 0.052132703363895416259765625f) * 2.400000095367431640625f);
    }
#else
    _328 = pow(_72, 2.2);
    _378 = pow(_73, 2.2);
    _722 = pow(_74, 2.2);
#endif
    float _727 = mad(_722, 0.1804807484149932861328125f, mad(_378, 0.3575843870639801025390625f, _328 * 0.41239082813262939453125f));
    float _733 = mad(_722, 0.07219229638576507568359375f, mad(_378, 0.715168774127960205078125f, _328 * 0.212639033794403076171875f));
    float _739 = mad(_722, 0.95053195953369140625f, mad(_378, 0.119194753468036651611328125f, _328 * 0.01933082006871700286865234375f));
    float _743 = mad(_739, -0.0149709321558475494384765625f, mad(_733, 0.00610530562698841094970703125f, _727 * 1.01303493976593017578125f));
    float _746 = mad(_739, -0.0050320238806307315826416015625f, mad(_733, 0.9981634616851806640625f, _727 * 0.0076982178725302219390869140625f));
    float _749 = mad(_739, 0.924506366252899169921875f, mad(_733, 0.00468514859676361083984375f, _727 * (-0.0028413091786205768585205078125f)));
    float _752 = mad(_749, -0.2364246845245361328125f, mad(_746, -0.324803292751312255859375f, _743 * 1.641023159027099609375f));
    float _755 = mad(_749, 0.01675636507570743560791015625f, mad(_746, 1.61533200740814208984375f, _743 * (-0.66366302967071533203125f)));
    float _758 = mad(_749, 0.98839473724365234375f, mad(_746, -0.008284439332783222198486328125f, _743 * 0.011721909977495670318603515625f));
    float _763 = mad(_758, -0.0040411460213363170623779296875f, mad(_755, -0.0507373176515102386474609375f, _752 * 1.05477845668792724609375f));
    float _765 = _752 * (-0.02049033343791961669921875f);
    float _769 = mad(_758, -0.0040411460213363170623779296875f, mad(_755, 1.02453136444091796875f, _765));
    float _772 = mad(_758, 1.071227550506591796875f, mad(_755, -0.050737321376800537109375f, _765));
    float _778 = mad(_772, 0.156187713146209716796875f, mad(_769, 0.13400419056415557861328125f, _763 * 0.66245424747467041015625f));
    float _784 = mad(_772, 0.0536895208060741424560546875f, mad(_769, 0.674081623554229736328125f, _763 * 0.2722287476062774658203125f));
    float _793 = (_784 + _778) + mad(_772, 1.01033914089202880859375f, mad(_769, 0.0040607289411127567291259765625f, _763 * (-0.005574661307036876678466796875f)));
    float _795 = (_793 == 0.0f) ? 1.0000000133514319600180897396058e-10f : _793;
    float _797 = _778 / _795;
    float _798 = _784 / _795;
    float _805 = exp2(log2(min(max(_784, 0.0f), 65520.0f)) * 1.01926410198211669921875f);
    float _807 = max(_798, 1.0000000133514319600180897396058e-10f);
    float _808 = (_805 * _797) / _807;
    float _812 = (_805 * ((1.0f - _797) - _798)) / _807;
    float _830 = log2((mad(_812, -0.2364246845245361328125f, mad(_805, -0.324803292751312255859375f, _808 * 1.641023159027099609375f)) * 47.979999542236328125f) + 0.0199999995529651641845703125f) * 0.3010300099849700927734375f;
    float _919;
    if (_830 > (-1.6989700794219970703125f)) {
      float frontier_phi_52_51_ladder;
      if ((_830 > (-1.6989700794219970703125f)) && (_830 <= 0.681241333484649658203125f)) {
        float _1158;
        float _1160;
        float _1162;
        float _1164;
        if ((_830 > (-1.69896996021270751953125f)) && (_830 <= (-1.5884349346160888671875f))) {
          _1158 = 0.0f;
          _1160 = -1.69896996021270751953125f;
          _1162 = -1.69896996021270751953125f;
          _1164 = -1.477900028228759765625f;
        } else {
          float frontier_phi_78_79_ladder;
          float frontier_phi_78_79_ladder_1;
          float frontier_phi_78_79_ladder_2;
          float frontier_phi_78_79_ladder_3;
          if ((_830 > (-1.5884349346160888671875f)) && (_830 <= (-1.35350000858306884765625f))) {
            frontier_phi_78_79_ladder = -1.2290999889373779296875f;
            frontier_phi_78_79_ladder_1 = -1.477900028228759765625f;
            frontier_phi_78_79_ladder_2 = -1.69896996021270751953125f;
            frontier_phi_78_79_ladder_3 = 1.0f;
          } else {
            float frontier_phi_78_79_ladder_93_ladder;
            float frontier_phi_78_79_ladder_93_ladder_1;
            float frontier_phi_78_79_ladder_93_ladder_2;
            float frontier_phi_78_79_ladder_93_ladder_3;
            if ((_830 > (-1.35350000858306884765625f)) && (_830 <= (-1.04694998264312744140625f))) {
              frontier_phi_78_79_ladder_93_ladder = -0.864799976348876953125f;
              frontier_phi_78_79_ladder_93_ladder_1 = -1.2290999889373779296875f;
              frontier_phi_78_79_ladder_93_ladder_2 = -1.477900028228759765625f;
              frontier_phi_78_79_ladder_93_ladder_3 = 2.0f;
            } else {
              float frontier_phi_78_79_ladder_93_ladder_109_ladder;
              float frontier_phi_78_79_ladder_93_ladder_109_ladder_1;
              float frontier_phi_78_79_ladder_93_ladder_109_ladder_2;
              float frontier_phi_78_79_ladder_93_ladder_109_ladder_3;
              if ((_830 > (-1.04694998264312744140625f)) && (_830 <= (-0.6563999652862548828125f))) {
                frontier_phi_78_79_ladder_93_ladder_109_ladder = -0.448000013828277587890625f;
                frontier_phi_78_79_ladder_93_ladder_109_ladder_1 = -0.864799976348876953125f;
                frontier_phi_78_79_ladder_93_ladder_109_ladder_2 = -1.2290999889373779296875f;
                frontier_phi_78_79_ladder_93_ladder_109_ladder_3 = 3.0f;
              } else {
                float frontier_phi_78_79_ladder_93_ladder_109_ladder_127_ladder;
                float frontier_phi_78_79_ladder_93_ladder_109_ladder_127_ladder_1;
                float frontier_phi_78_79_ladder_93_ladder_109_ladder_127_ladder_2;
                float frontier_phi_78_79_ladder_93_ladder_109_ladder_127_ladder_3;
                if ((_830 > (-0.6563999652862548828125f)) && (_830 <= (-0.2214100062847137451171875f))) {
                  frontier_phi_78_79_ladder_93_ladder_109_ladder_127_ladder = 0.0051799998618662357330322265625f;
                  frontier_phi_78_79_ladder_93_ladder_109_ladder_127_ladder_1 = -0.448000013828277587890625f;
                  frontier_phi_78_79_ladder_93_ladder_109_ladder_127_ladder_2 = -0.864799976348876953125f;
                  frontier_phi_78_79_ladder_93_ladder_109_ladder_127_ladder_3 = 4.0f;
                } else {
                  bool _1688 = (_830 > (-0.2214100062847137451171875f)) && (_830 <= 0.2281440198421478271484375f);
                  frontier_phi_78_79_ladder_93_ladder_109_ladder_127_ladder = _1688 ? 0.451108038425445556640625f : 0.91137444972991943359375f;
                  frontier_phi_78_79_ladder_93_ladder_109_ladder_127_ladder_1 = _1688 ? 0.0051799998618662357330322265625f : 0.451108038425445556640625f;
                  frontier_phi_78_79_ladder_93_ladder_109_ladder_127_ladder_2 = _1688 ? (-0.448000013828277587890625f) : 0.0051799998618662357330322265625f;
                  frontier_phi_78_79_ladder_93_ladder_109_ladder_127_ladder_3 = _1688 ? 5.0f : 6.0f;
                }
                frontier_phi_78_79_ladder_93_ladder_109_ladder = frontier_phi_78_79_ladder_93_ladder_109_ladder_127_ladder;
                frontier_phi_78_79_ladder_93_ladder_109_ladder_1 = frontier_phi_78_79_ladder_93_ladder_109_ladder_127_ladder_1;
                frontier_phi_78_79_ladder_93_ladder_109_ladder_2 = frontier_phi_78_79_ladder_93_ladder_109_ladder_127_ladder_2;
                frontier_phi_78_79_ladder_93_ladder_109_ladder_3 = frontier_phi_78_79_ladder_93_ladder_109_ladder_127_ladder_3;
              }
              frontier_phi_78_79_ladder_93_ladder = frontier_phi_78_79_ladder_93_ladder_109_ladder;
              frontier_phi_78_79_ladder_93_ladder_1 = frontier_phi_78_79_ladder_93_ladder_109_ladder_1;
              frontier_phi_78_79_ladder_93_ladder_2 = frontier_phi_78_79_ladder_93_ladder_109_ladder_2;
              frontier_phi_78_79_ladder_93_ladder_3 = frontier_phi_78_79_ladder_93_ladder_109_ladder_3;
            }
            frontier_phi_78_79_ladder = frontier_phi_78_79_ladder_93_ladder;
            frontier_phi_78_79_ladder_1 = frontier_phi_78_79_ladder_93_ladder_1;
            frontier_phi_78_79_ladder_2 = frontier_phi_78_79_ladder_93_ladder_2;
            frontier_phi_78_79_ladder_3 = frontier_phi_78_79_ladder_93_ladder_3;
          }
          _1158 = frontier_phi_78_79_ladder_3;
          _1160 = frontier_phi_78_79_ladder_2;
          _1162 = frontier_phi_78_79_ladder_1;
          _1164 = frontier_phi_78_79_ladder;
        }
        float _1166 = _1160 * 0.5f;
        float _1169 = _1162 - _1160;
        float _1171 = mad(_1162, 0.5f, _1166) - _830;
        frontier_phi_52_51_ladder = ((((_1171 * 2.0f) / (((-0.0f) - _1169) - sqrt((_1169 * _1169) - ((mad(_1164, 0.5f, mad(_1162, -1.0f, _1166)) * 4.0f) * _1171)))) + _1158) * 0.4602663815021514892578125f) + (-2.54062366485595703125f);
      } else {
        float frontier_phi_52_51_ladder_65_ladder;
        if ((_830 > 0.681241333484649658203125f) && (_830 < 1.6812412738800048828125f)) {
          float _1268;
          float _1270;
          float _1272;
          float _1274;
          if ((_830 > 0.681241214275360107421875f) && (_830 <= 0.991421878337860107421875f)) {
            _1268 = 0.0f;
            _1270 = 0.51543867588043212890625f;
            _1272 = 0.8470437526702880859375f;
            _1274 = 1.13580000400543212890625f;
          } else {
            float frontier_phi_94_95_ladder;
            float frontier_phi_94_95_ladder_1;
            float frontier_phi_94_95_ladder_2;
            float frontier_phi_94_95_ladder_3;
            if ((_830 > 0.991421878337860107421875f) && (_830 <= 1.25800001621246337890625f)) {
              frontier_phi_94_95_ladder = 0.8470437526702880859375f;
              frontier_phi_94_95_ladder_1 = 1.0f;
              frontier_phi_94_95_ladder_2 = 1.13580000400543212890625f;
              frontier_phi_94_95_ladder_3 = 1.38020002841949462890625f;
            } else {
              float frontier_phi_94_95_ladder_110_ladder;
              float frontier_phi_94_95_ladder_110_ladder_1;
              float frontier_phi_94_95_ladder_110_ladder_2;
              float frontier_phi_94_95_ladder_110_ladder_3;
              if ((_830 > 1.25800001621246337890625f) && (_830 <= 1.4499499797821044921875f)) {
                frontier_phi_94_95_ladder_110_ladder = 1.13580000400543212890625f;
                frontier_phi_94_95_ladder_110_ladder_1 = 2.0f;
                frontier_phi_94_95_ladder_110_ladder_2 = 1.38020002841949462890625f;
                frontier_phi_94_95_ladder_110_ladder_3 = 1.51970005035400390625f;
              } else {
                float frontier_phi_94_95_ladder_110_ladder_128_ladder;
                float frontier_phi_94_95_ladder_110_ladder_128_ladder_1;
                float frontier_phi_94_95_ladder_110_ladder_128_ladder_2;
                float frontier_phi_94_95_ladder_110_ladder_128_ladder_3;
                if ((_830 > 1.4499499797821044921875f) && (_830 <= 1.55910003185272216796875f)) {
                  frontier_phi_94_95_ladder_110_ladder_128_ladder = 1.38020002841949462890625f;
                  frontier_phi_94_95_ladder_110_ladder_128_ladder_1 = 3.0f;
                  frontier_phi_94_95_ladder_110_ladder_128_ladder_2 = 1.51970005035400390625f;
                  frontier_phi_94_95_ladder_110_ladder_128_ladder_3 = 1.5985000133514404296875f;
                } else {
                  float frontier_phi_94_95_ladder_110_ladder_128_ladder_147_ladder;
                  float frontier_phi_94_95_ladder_110_ladder_128_ladder_147_ladder_1;
                  float frontier_phi_94_95_ladder_110_ladder_128_ladder_147_ladder_2;
                  float frontier_phi_94_95_ladder_110_ladder_128_ladder_147_ladder_3;
                  if ((_830 > 1.55910003185272216796875f) && (_830 <= 1.622600078582763671875f)) {
                    frontier_phi_94_95_ladder_110_ladder_128_ladder_147_ladder = 1.51970005035400390625f;
                    frontier_phi_94_95_ladder_110_ladder_128_ladder_147_ladder_1 = 4.0f;
                    frontier_phi_94_95_ladder_110_ladder_128_ladder_147_ladder_2 = 1.5985000133514404296875f;
                    frontier_phi_94_95_ladder_110_ladder_128_ladder_147_ladder_3 = 1.64670002460479736328125f;
                  } else {
                    bool _1778 = (_830 > 1.622600078582763671875f) && (_830 <= 1.660654544830322265625f);
                    frontier_phi_94_95_ladder_110_ladder_128_ladder_147_ladder = _1778 ? 1.5985000133514404296875f : 1.64670002460479736328125f;
                    frontier_phi_94_95_ladder_110_ladder_128_ladder_147_ladder_1 = _1778 ? 5.0f : 6.0f;
                    frontier_phi_94_95_ladder_110_ladder_128_ladder_147_ladder_2 = _1778 ? 1.64670002460479736328125f : 1.67460918426513671875f;
                    frontier_phi_94_95_ladder_110_ladder_128_ladder_147_ladder_3 = _1778 ? 1.67460918426513671875f : 1.687873363494873046875f;
                  }
                  frontier_phi_94_95_ladder_110_ladder_128_ladder = frontier_phi_94_95_ladder_110_ladder_128_ladder_147_ladder;
                  frontier_phi_94_95_ladder_110_ladder_128_ladder_1 = frontier_phi_94_95_ladder_110_ladder_128_ladder_147_ladder_1;
                  frontier_phi_94_95_ladder_110_ladder_128_ladder_2 = frontier_phi_94_95_ladder_110_ladder_128_ladder_147_ladder_2;
                  frontier_phi_94_95_ladder_110_ladder_128_ladder_3 = frontier_phi_94_95_ladder_110_ladder_128_ladder_147_ladder_3;
                }
                frontier_phi_94_95_ladder_110_ladder = frontier_phi_94_95_ladder_110_ladder_128_ladder;
                frontier_phi_94_95_ladder_110_ladder_1 = frontier_phi_94_95_ladder_110_ladder_128_ladder_1;
                frontier_phi_94_95_ladder_110_ladder_2 = frontier_phi_94_95_ladder_110_ladder_128_ladder_2;
                frontier_phi_94_95_ladder_110_ladder_3 = frontier_phi_94_95_ladder_110_ladder_128_ladder_3;
              }
              frontier_phi_94_95_ladder = frontier_phi_94_95_ladder_110_ladder;
              frontier_phi_94_95_ladder_1 = frontier_phi_94_95_ladder_110_ladder_1;
              frontier_phi_94_95_ladder_2 = frontier_phi_94_95_ladder_110_ladder_2;
              frontier_phi_94_95_ladder_3 = frontier_phi_94_95_ladder_110_ladder_3;
            }
            _1268 = frontier_phi_94_95_ladder_1;
            _1270 = frontier_phi_94_95_ladder;
            _1272 = frontier_phi_94_95_ladder_2;
            _1274 = frontier_phi_94_95_ladder_3;
          }
          float _1276 = _1270 * 0.5f;
          float _1279 = _1272 - _1270;
          float _1281 = mad(_1272, 0.5f, _1276) - _830;
          frontier_phi_52_51_ladder_65_ladder = ((((_1281 * 2.0f) / (((-0.0f) - _1279) - sqrt((_1279 * _1279) - ((mad(_1274, 0.5f, mad(_1272, -1.0f, _1276)) * 4.0f) * _1281)))) + _1268) * 0.33160507678985595703125f) + 0.68124115467071533203125f;
        } else {
          frontier_phi_52_51_ladder_65_ladder = 3.00247669219970703125f;
        }
        frontier_phi_52_51_ladder = frontier_phi_52_51_ladder_65_ladder;
      }
      _919 = frontier_phi_52_51_ladder;
    } else {
      _919 = -2.54062366485595703125f;
    }
    float _925 = exp2(_919 * 3.3219280242919921875f);
    float _927 = log2((mad(_812, 0.01675636507570743560791015625f, mad(_805, 1.61533200740814208984375f, _808 * (-0.66366302967071533203125f))) * 47.979999542236328125f) + 0.0199999995529651641845703125f) * 0.3010300099849700927734375f;
    float _1056;
    if (_927 > (-1.6989700794219970703125f)) {
      float frontier_phi_67_66_ladder;
      if ((_927 > (-1.6989700794219970703125f)) && (_927 <= 0.681241333484649658203125f)) {
        float _1298;
        float _1300;
        float _1302;
        float _1304;
        if ((_927 > (-1.69896996021270751953125f)) && (_927 <= (-1.5884349346160888671875f))) {
          _1298 = 0.0f;
          _1300 = -1.69896996021270751953125f;
          _1302 = -1.69896996021270751953125f;
          _1304 = -1.477900028228759765625f;
        } else {
          float frontier_phi_96_97_ladder;
          float frontier_phi_96_97_ladder_1;
          float frontier_phi_96_97_ladder_2;
          float frontier_phi_96_97_ladder_3;
          if ((_927 > (-1.5884349346160888671875f)) && (_927 <= (-1.35350000858306884765625f))) {
            frontier_phi_96_97_ladder = -1.2290999889373779296875f;
            frontier_phi_96_97_ladder_1 = -1.477900028228759765625f;
            frontier_phi_96_97_ladder_2 = -1.69896996021270751953125f;
            frontier_phi_96_97_ladder_3 = 1.0f;
          } else {
            float frontier_phi_96_97_ladder_111_ladder;
            float frontier_phi_96_97_ladder_111_ladder_1;
            float frontier_phi_96_97_ladder_111_ladder_2;
            float frontier_phi_96_97_ladder_111_ladder_3;
            if ((_927 > (-1.35350000858306884765625f)) && (_927 <= (-1.04694998264312744140625f))) {
              frontier_phi_96_97_ladder_111_ladder = -0.864799976348876953125f;
              frontier_phi_96_97_ladder_111_ladder_1 = -1.2290999889373779296875f;
              frontier_phi_96_97_ladder_111_ladder_2 = -1.477900028228759765625f;
              frontier_phi_96_97_ladder_111_ladder_3 = 2.0f;
            } else {
              float frontier_phi_96_97_ladder_111_ladder_129_ladder;
              float frontier_phi_96_97_ladder_111_ladder_129_ladder_1;
              float frontier_phi_96_97_ladder_111_ladder_129_ladder_2;
              float frontier_phi_96_97_ladder_111_ladder_129_ladder_3;
              if ((_927 > (-1.04694998264312744140625f)) && (_927 <= (-0.6563999652862548828125f))) {
                frontier_phi_96_97_ladder_111_ladder_129_ladder = -0.448000013828277587890625f;
                frontier_phi_96_97_ladder_111_ladder_129_ladder_1 = -0.864799976348876953125f;
                frontier_phi_96_97_ladder_111_ladder_129_ladder_2 = -1.2290999889373779296875f;
                frontier_phi_96_97_ladder_111_ladder_129_ladder_3 = 3.0f;
              } else {
                float frontier_phi_96_97_ladder_111_ladder_129_ladder_148_ladder;
                float frontier_phi_96_97_ladder_111_ladder_129_ladder_148_ladder_1;
                float frontier_phi_96_97_ladder_111_ladder_129_ladder_148_ladder_2;
                float frontier_phi_96_97_ladder_111_ladder_129_ladder_148_ladder_3;
                if ((_927 > (-0.6563999652862548828125f)) && (_927 <= (-0.2214100062847137451171875f))) {
                  frontier_phi_96_97_ladder_111_ladder_129_ladder_148_ladder = 0.0051799998618662357330322265625f;
                  frontier_phi_96_97_ladder_111_ladder_129_ladder_148_ladder_1 = -0.448000013828277587890625f;
                  frontier_phi_96_97_ladder_111_ladder_129_ladder_148_ladder_2 = -0.864799976348876953125f;
                  frontier_phi_96_97_ladder_111_ladder_129_ladder_148_ladder_3 = 4.0f;
                } else {
                  bool _1781 = (_927 > (-0.2214100062847137451171875f)) && (_927 <= 0.2281440198421478271484375f);
                  frontier_phi_96_97_ladder_111_ladder_129_ladder_148_ladder = _1781 ? 0.451108038425445556640625f : 0.91137444972991943359375f;
                  frontier_phi_96_97_ladder_111_ladder_129_ladder_148_ladder_1 = _1781 ? 0.0051799998618662357330322265625f : 0.451108038425445556640625f;
                  frontier_phi_96_97_ladder_111_ladder_129_ladder_148_ladder_2 = _1781 ? (-0.448000013828277587890625f) : 0.0051799998618662357330322265625f;
                  frontier_phi_96_97_ladder_111_ladder_129_ladder_148_ladder_3 = _1781 ? 5.0f : 6.0f;
                }
                frontier_phi_96_97_ladder_111_ladder_129_ladder = frontier_phi_96_97_ladder_111_ladder_129_ladder_148_ladder;
                frontier_phi_96_97_ladder_111_ladder_129_ladder_1 = frontier_phi_96_97_ladder_111_ladder_129_ladder_148_ladder_1;
                frontier_phi_96_97_ladder_111_ladder_129_ladder_2 = frontier_phi_96_97_ladder_111_ladder_129_ladder_148_ladder_2;
                frontier_phi_96_97_ladder_111_ladder_129_ladder_3 = frontier_phi_96_97_ladder_111_ladder_129_ladder_148_ladder_3;
              }
              frontier_phi_96_97_ladder_111_ladder = frontier_phi_96_97_ladder_111_ladder_129_ladder;
              frontier_phi_96_97_ladder_111_ladder_1 = frontier_phi_96_97_ladder_111_ladder_129_ladder_1;
              frontier_phi_96_97_ladder_111_ladder_2 = frontier_phi_96_97_ladder_111_ladder_129_ladder_2;
              frontier_phi_96_97_ladder_111_ladder_3 = frontier_phi_96_97_ladder_111_ladder_129_ladder_3;
            }
            frontier_phi_96_97_ladder = frontier_phi_96_97_ladder_111_ladder;
            frontier_phi_96_97_ladder_1 = frontier_phi_96_97_ladder_111_ladder_1;
            frontier_phi_96_97_ladder_2 = frontier_phi_96_97_ladder_111_ladder_2;
            frontier_phi_96_97_ladder_3 = frontier_phi_96_97_ladder_111_ladder_3;
          }
          _1298 = frontier_phi_96_97_ladder_3;
          _1300 = frontier_phi_96_97_ladder_2;
          _1302 = frontier_phi_96_97_ladder_1;
          _1304 = frontier_phi_96_97_ladder;
        }
        float _1306 = _1300 * 0.5f;
        float _1309 = _1302 - _1300;
        float _1311 = mad(_1302, 0.5f, _1306) - _927;
        frontier_phi_67_66_ladder = ((((_1311 * 2.0f) / (((-0.0f) - _1309) - sqrt((_1309 * _1309) - ((mad(_1304, 0.5f, mad(_1302, -1.0f, _1306)) * 4.0f) * _1311)))) + _1298) * 0.4602663815021514892578125f) + (-2.54062366485595703125f);
      } else {
        float frontier_phi_67_66_ladder_82_ladder;
        if ((_927 > 0.681241333484649658203125f) && (_927 < 1.6812412738800048828125f)) {
          float _1374;
          float _1376;
          float _1378;
          float _1380;
          if ((_927 > 0.681241214275360107421875f) && (_927 <= 0.991421878337860107421875f)) {
            _1374 = 0.0f;
            _1376 = 0.51543867588043212890625f;
            _1378 = 0.8470437526702880859375f;
            _1380 = 1.13580000400543212890625f;
          } else {
            float frontier_phi_112_113_ladder;
            float frontier_phi_112_113_ladder_1;
            float frontier_phi_112_113_ladder_2;
            float frontier_phi_112_113_ladder_3;
            if ((_927 > 0.991421878337860107421875f) && (_927 <= 1.25800001621246337890625f)) {
              frontier_phi_112_113_ladder = 1.38020002841949462890625f;
              frontier_phi_112_113_ladder_1 = 1.13580000400543212890625f;
              frontier_phi_112_113_ladder_2 = 0.8470437526702880859375f;
              frontier_phi_112_113_ladder_3 = 1.0f;
            } else {
              float frontier_phi_112_113_ladder_130_ladder;
              float frontier_phi_112_113_ladder_130_ladder_1;
              float frontier_phi_112_113_ladder_130_ladder_2;
              float frontier_phi_112_113_ladder_130_ladder_3;
              if ((_927 > 1.25800001621246337890625f) && (_927 <= 1.4499499797821044921875f)) {
                frontier_phi_112_113_ladder_130_ladder = 1.51970005035400390625f;
                frontier_phi_112_113_ladder_130_ladder_1 = 1.38020002841949462890625f;
                frontier_phi_112_113_ladder_130_ladder_2 = 1.13580000400543212890625f;
                frontier_phi_112_113_ladder_130_ladder_3 = 2.0f;
              } else {
                float frontier_phi_112_113_ladder_130_ladder_149_ladder;
                float frontier_phi_112_113_ladder_130_ladder_149_ladder_1;
                float frontier_phi_112_113_ladder_130_ladder_149_ladder_2;
                float frontier_phi_112_113_ladder_130_ladder_149_ladder_3;
                if ((_927 > 1.4499499797821044921875f) && (_927 <= 1.55910003185272216796875f)) {
                  frontier_phi_112_113_ladder_130_ladder_149_ladder = 1.5985000133514404296875f;
                  frontier_phi_112_113_ladder_130_ladder_149_ladder_1 = 1.51970005035400390625f;
                  frontier_phi_112_113_ladder_130_ladder_149_ladder_2 = 1.38020002841949462890625f;
                  frontier_phi_112_113_ladder_130_ladder_149_ladder_3 = 3.0f;
                } else {
                  float frontier_phi_112_113_ladder_130_ladder_149_ladder_164_ladder;
                  float frontier_phi_112_113_ladder_130_ladder_149_ladder_164_ladder_1;
                  float frontier_phi_112_113_ladder_130_ladder_149_ladder_164_ladder_2;
                  float frontier_phi_112_113_ladder_130_ladder_149_ladder_164_ladder_3;
                  if ((_927 > 1.55910003185272216796875f) && (_927 <= 1.622600078582763671875f)) {
                    frontier_phi_112_113_ladder_130_ladder_149_ladder_164_ladder = 1.64670002460479736328125f;
                    frontier_phi_112_113_ladder_130_ladder_149_ladder_164_ladder_1 = 1.5985000133514404296875f;
                    frontier_phi_112_113_ladder_130_ladder_149_ladder_164_ladder_2 = 1.51970005035400390625f;
                    frontier_phi_112_113_ladder_130_ladder_149_ladder_164_ladder_3 = 4.0f;
                  } else {
                    bool _1834 = (_927 > 1.622600078582763671875f) && (_927 <= 1.660654544830322265625f);
                    frontier_phi_112_113_ladder_130_ladder_149_ladder_164_ladder = _1834 ? 1.67460918426513671875f : 1.687873363494873046875f;
                    frontier_phi_112_113_ladder_130_ladder_149_ladder_164_ladder_1 = _1834 ? 1.64670002460479736328125f : 1.67460918426513671875f;
                    frontier_phi_112_113_ladder_130_ladder_149_ladder_164_ladder_2 = _1834 ? 1.5985000133514404296875f : 1.64670002460479736328125f;
                    frontier_phi_112_113_ladder_130_ladder_149_ladder_164_ladder_3 = _1834 ? 5.0f : 6.0f;
                  }
                  frontier_phi_112_113_ladder_130_ladder_149_ladder = frontier_phi_112_113_ladder_130_ladder_149_ladder_164_ladder;
                  frontier_phi_112_113_ladder_130_ladder_149_ladder_1 = frontier_phi_112_113_ladder_130_ladder_149_ladder_164_ladder_1;
                  frontier_phi_112_113_ladder_130_ladder_149_ladder_2 = frontier_phi_112_113_ladder_130_ladder_149_ladder_164_ladder_2;
                  frontier_phi_112_113_ladder_130_ladder_149_ladder_3 = frontier_phi_112_113_ladder_130_ladder_149_ladder_164_ladder_3;
                }
                frontier_phi_112_113_ladder_130_ladder = frontier_phi_112_113_ladder_130_ladder_149_ladder;
                frontier_phi_112_113_ladder_130_ladder_1 = frontier_phi_112_113_ladder_130_ladder_149_ladder_1;
                frontier_phi_112_113_ladder_130_ladder_2 = frontier_phi_112_113_ladder_130_ladder_149_ladder_2;
                frontier_phi_112_113_ladder_130_ladder_3 = frontier_phi_112_113_ladder_130_ladder_149_ladder_3;
              }
              frontier_phi_112_113_ladder = frontier_phi_112_113_ladder_130_ladder;
              frontier_phi_112_113_ladder_1 = frontier_phi_112_113_ladder_130_ladder_1;
              frontier_phi_112_113_ladder_2 = frontier_phi_112_113_ladder_130_ladder_2;
              frontier_phi_112_113_ladder_3 = frontier_phi_112_113_ladder_130_ladder_3;
            }
            _1374 = frontier_phi_112_113_ladder_3;
            _1376 = frontier_phi_112_113_ladder_2;
            _1378 = frontier_phi_112_113_ladder_1;
            _1380 = frontier_phi_112_113_ladder;
          }
          float _1382 = _1376 * 0.5f;
          float _1385 = _1378 - _1376;
          float _1387 = mad(_1378, 0.5f, _1382) - _927;
          frontier_phi_67_66_ladder_82_ladder = ((((_1387 * 2.0f) / (((-0.0f) - _1385) - sqrt((_1385 * _1385) - ((mad(_1380, 0.5f, mad(_1378, -1.0f, _1382)) * 4.0f) * _1387)))) + _1374) * 0.33160507678985595703125f) + 0.68124115467071533203125f;
        } else {
          frontier_phi_67_66_ladder_82_ladder = 3.00247669219970703125f;
        }
        frontier_phi_67_66_ladder = frontier_phi_67_66_ladder_82_ladder;
      }
      _1056 = frontier_phi_67_66_ladder;
    } else {
      _1056 = -2.54062366485595703125f;
    }
    float _1060 = exp2(_1056 * 3.3219280242919921875f);
    float _1062 = log2((mad(_812, 0.98839473724365234375f, mad(_805, -0.008284439332783222198486328125f, _808 * 0.011721909977495670318603515625f)) * 47.979999542236328125f) + 0.0199999995529651641845703125f) * 0.3010300099849700927734375f;
    float _1202;
    if (_1062 > (-1.6989700794219970703125f)) {
      float frontier_phi_84_83_ladder;
      if ((_1062 > (-1.6989700794219970703125f)) && (_1062 <= 0.681241333484649658203125f)) {
        float _1402;
        float _1404;
        float _1406;
        float _1408;
        if ((_1062 > (-1.69896996021270751953125f)) && (_1062 <= (-1.5884349346160888671875f))) {
          _1402 = 0.0f;
          _1404 = -1.69896996021270751953125f;
          _1406 = -1.69896996021270751953125f;
          _1408 = -1.477900028228759765625f;
        } else {
          float frontier_phi_114_115_ladder;
          float frontier_phi_114_115_ladder_1;
          float frontier_phi_114_115_ladder_2;
          float frontier_phi_114_115_ladder_3;
          if ((_1062 > (-1.5884349346160888671875f)) && (_1062 <= (-1.35350000858306884765625f))) {
            frontier_phi_114_115_ladder = -1.2290999889373779296875f;
            frontier_phi_114_115_ladder_1 = -1.477900028228759765625f;
            frontier_phi_114_115_ladder_2 = -1.69896996021270751953125f;
            frontier_phi_114_115_ladder_3 = 1.0f;
          } else {
            float frontier_phi_114_115_ladder_131_ladder;
            float frontier_phi_114_115_ladder_131_ladder_1;
            float frontier_phi_114_115_ladder_131_ladder_2;
            float frontier_phi_114_115_ladder_131_ladder_3;
            if ((_1062 > (-1.35350000858306884765625f)) && (_1062 <= (-1.04694998264312744140625f))) {
              frontier_phi_114_115_ladder_131_ladder = -0.864799976348876953125f;
              frontier_phi_114_115_ladder_131_ladder_1 = -1.2290999889373779296875f;
              frontier_phi_114_115_ladder_131_ladder_2 = -1.477900028228759765625f;
              frontier_phi_114_115_ladder_131_ladder_3 = 2.0f;
            } else {
              float frontier_phi_114_115_ladder_131_ladder_150_ladder;
              float frontier_phi_114_115_ladder_131_ladder_150_ladder_1;
              float frontier_phi_114_115_ladder_131_ladder_150_ladder_2;
              float frontier_phi_114_115_ladder_131_ladder_150_ladder_3;
              if ((_1062 > (-1.04694998264312744140625f)) && (_1062 <= (-0.6563999652862548828125f))) {
                frontier_phi_114_115_ladder_131_ladder_150_ladder = -0.448000013828277587890625f;
                frontier_phi_114_115_ladder_131_ladder_150_ladder_1 = -0.864799976348876953125f;
                frontier_phi_114_115_ladder_131_ladder_150_ladder_2 = -1.2290999889373779296875f;
                frontier_phi_114_115_ladder_131_ladder_150_ladder_3 = 3.0f;
              } else {
                float frontier_phi_114_115_ladder_131_ladder_150_ladder_165_ladder;
                float frontier_phi_114_115_ladder_131_ladder_150_ladder_165_ladder_1;
                float frontier_phi_114_115_ladder_131_ladder_150_ladder_165_ladder_2;
                float frontier_phi_114_115_ladder_131_ladder_150_ladder_165_ladder_3;
                if ((_1062 > (-0.6563999652862548828125f)) && (_1062 <= (-0.2214100062847137451171875f))) {
                  frontier_phi_114_115_ladder_131_ladder_150_ladder_165_ladder = 0.0051799998618662357330322265625f;
                  frontier_phi_114_115_ladder_131_ladder_150_ladder_165_ladder_1 = -0.448000013828277587890625f;
                  frontier_phi_114_115_ladder_131_ladder_150_ladder_165_ladder_2 = -0.864799976348876953125f;
                  frontier_phi_114_115_ladder_131_ladder_150_ladder_165_ladder_3 = 4.0f;
                } else {
                  bool _1837 = (_1062 > (-0.2214100062847137451171875f)) && (_1062 <= 0.2281440198421478271484375f);
                  frontier_phi_114_115_ladder_131_ladder_150_ladder_165_ladder = _1837 ? 0.451108038425445556640625f : 0.91137444972991943359375f;
                  frontier_phi_114_115_ladder_131_ladder_150_ladder_165_ladder_1 = _1837 ? 0.0051799998618662357330322265625f : 0.451108038425445556640625f;
                  frontier_phi_114_115_ladder_131_ladder_150_ladder_165_ladder_2 = _1837 ? (-0.448000013828277587890625f) : 0.0051799998618662357330322265625f;
                  frontier_phi_114_115_ladder_131_ladder_150_ladder_165_ladder_3 = _1837 ? 5.0f : 6.0f;
                }
                frontier_phi_114_115_ladder_131_ladder_150_ladder = frontier_phi_114_115_ladder_131_ladder_150_ladder_165_ladder;
                frontier_phi_114_115_ladder_131_ladder_150_ladder_1 = frontier_phi_114_115_ladder_131_ladder_150_ladder_165_ladder_1;
                frontier_phi_114_115_ladder_131_ladder_150_ladder_2 = frontier_phi_114_115_ladder_131_ladder_150_ladder_165_ladder_2;
                frontier_phi_114_115_ladder_131_ladder_150_ladder_3 = frontier_phi_114_115_ladder_131_ladder_150_ladder_165_ladder_3;
              }
              frontier_phi_114_115_ladder_131_ladder = frontier_phi_114_115_ladder_131_ladder_150_ladder;
              frontier_phi_114_115_ladder_131_ladder_1 = frontier_phi_114_115_ladder_131_ladder_150_ladder_1;
              frontier_phi_114_115_ladder_131_ladder_2 = frontier_phi_114_115_ladder_131_ladder_150_ladder_2;
              frontier_phi_114_115_ladder_131_ladder_3 = frontier_phi_114_115_ladder_131_ladder_150_ladder_3;
            }
            frontier_phi_114_115_ladder = frontier_phi_114_115_ladder_131_ladder;
            frontier_phi_114_115_ladder_1 = frontier_phi_114_115_ladder_131_ladder_1;
            frontier_phi_114_115_ladder_2 = frontier_phi_114_115_ladder_131_ladder_2;
            frontier_phi_114_115_ladder_3 = frontier_phi_114_115_ladder_131_ladder_3;
          }
          _1402 = frontier_phi_114_115_ladder_3;
          _1404 = frontier_phi_114_115_ladder_2;
          _1406 = frontier_phi_114_115_ladder_1;
          _1408 = frontier_phi_114_115_ladder;
        }
        float _1410 = _1404 * 0.5f;
        float _1413 = _1406 - _1404;
        float _1415 = mad(_1406, 0.5f, _1410) - _1062;
        frontier_phi_84_83_ladder = ((((_1415 * 2.0f) / (((-0.0f) - _1413) - sqrt((_1413 * _1413) - ((mad(_1408, 0.5f, mad(_1406, -1.0f, _1410)) * 4.0f) * _1415)))) + _1402) * 0.4602663815021514892578125f) + (-2.54062366485595703125f);
      } else {
        float frontier_phi_84_83_ladder_100_ladder;
        if ((_1062 > 0.681241333484649658203125f) && (_1062 < 1.6812412738800048828125f)) {
          float _1548;
          float _1550;
          float _1552;
          float _1554;
          if ((_1062 > 0.681241214275360107421875f) && (_1062 <= 0.991421878337860107421875f)) {
            _1548 = 0.0f;
            _1550 = 0.51543867588043212890625f;
            _1552 = 0.8470437526702880859375f;
            _1554 = 1.13580000400543212890625f;
          } else {
            float frontier_phi_132_133_ladder;
            float frontier_phi_132_133_ladder_1;
            float frontier_phi_132_133_ladder_2;
            float frontier_phi_132_133_ladder_3;
            if ((_1062 > 0.991421878337860107421875f) && (_1062 <= 1.25800001621246337890625f)) {
              frontier_phi_132_133_ladder = 1.38020002841949462890625f;
              frontier_phi_132_133_ladder_1 = 1.13580000400543212890625f;
              frontier_phi_132_133_ladder_2 = 0.8470437526702880859375f;
              frontier_phi_132_133_ladder_3 = 1.0f;
            } else {
              float frontier_phi_132_133_ladder_151_ladder;
              float frontier_phi_132_133_ladder_151_ladder_1;
              float frontier_phi_132_133_ladder_151_ladder_2;
              float frontier_phi_132_133_ladder_151_ladder_3;
              if ((_1062 > 1.25800001621246337890625f) && (_1062 <= 1.4499499797821044921875f)) {
                frontier_phi_132_133_ladder_151_ladder = 1.51970005035400390625f;
                frontier_phi_132_133_ladder_151_ladder_1 = 1.38020002841949462890625f;
                frontier_phi_132_133_ladder_151_ladder_2 = 1.13580000400543212890625f;
                frontier_phi_132_133_ladder_151_ladder_3 = 2.0f;
              } else {
                float frontier_phi_132_133_ladder_151_ladder_166_ladder;
                float frontier_phi_132_133_ladder_151_ladder_166_ladder_1;
                float frontier_phi_132_133_ladder_151_ladder_166_ladder_2;
                float frontier_phi_132_133_ladder_151_ladder_166_ladder_3;
                if ((_1062 > 1.4499499797821044921875f) && (_1062 <= 1.55910003185272216796875f)) {
                  frontier_phi_132_133_ladder_151_ladder_166_ladder = 1.5985000133514404296875f;
                  frontier_phi_132_133_ladder_151_ladder_166_ladder_1 = 1.51970005035400390625f;
                  frontier_phi_132_133_ladder_151_ladder_166_ladder_2 = 1.38020002841949462890625f;
                  frontier_phi_132_133_ladder_151_ladder_166_ladder_3 = 3.0f;
                } else {
                  float frontier_phi_132_133_ladder_151_ladder_166_ladder_175_ladder;
                  float frontier_phi_132_133_ladder_151_ladder_166_ladder_175_ladder_1;
                  float frontier_phi_132_133_ladder_151_ladder_166_ladder_175_ladder_2;
                  float frontier_phi_132_133_ladder_151_ladder_166_ladder_175_ladder_3;
                  if ((_1062 > 1.55910003185272216796875f) && (_1062 <= 1.622600078582763671875f)) {
                    frontier_phi_132_133_ladder_151_ladder_166_ladder_175_ladder = 1.64670002460479736328125f;
                    frontier_phi_132_133_ladder_151_ladder_166_ladder_175_ladder_1 = 1.5985000133514404296875f;
                    frontier_phi_132_133_ladder_151_ladder_166_ladder_175_ladder_2 = 1.51970005035400390625f;
                    frontier_phi_132_133_ladder_151_ladder_166_ladder_175_ladder_3 = 4.0f;
                  } else {
                    bool _1922 = (_1062 > 1.622600078582763671875f) && (_1062 <= 1.660654544830322265625f);
                    frontier_phi_132_133_ladder_151_ladder_166_ladder_175_ladder = _1922 ? 1.67460918426513671875f : 1.687873363494873046875f;
                    frontier_phi_132_133_ladder_151_ladder_166_ladder_175_ladder_1 = _1922 ? 1.64670002460479736328125f : 1.67460918426513671875f;
                    frontier_phi_132_133_ladder_151_ladder_166_ladder_175_ladder_2 = _1922 ? 1.5985000133514404296875f : 1.64670002460479736328125f;
                    frontier_phi_132_133_ladder_151_ladder_166_ladder_175_ladder_3 = _1922 ? 5.0f : 6.0f;
                  }
                  frontier_phi_132_133_ladder_151_ladder_166_ladder = frontier_phi_132_133_ladder_151_ladder_166_ladder_175_ladder;
                  frontier_phi_132_133_ladder_151_ladder_166_ladder_1 = frontier_phi_132_133_ladder_151_ladder_166_ladder_175_ladder_1;
                  frontier_phi_132_133_ladder_151_ladder_166_ladder_2 = frontier_phi_132_133_ladder_151_ladder_166_ladder_175_ladder_2;
                  frontier_phi_132_133_ladder_151_ladder_166_ladder_3 = frontier_phi_132_133_ladder_151_ladder_166_ladder_175_ladder_3;
                }
                frontier_phi_132_133_ladder_151_ladder = frontier_phi_132_133_ladder_151_ladder_166_ladder;
                frontier_phi_132_133_ladder_151_ladder_1 = frontier_phi_132_133_ladder_151_ladder_166_ladder_1;
                frontier_phi_132_133_ladder_151_ladder_2 = frontier_phi_132_133_ladder_151_ladder_166_ladder_2;
                frontier_phi_132_133_ladder_151_ladder_3 = frontier_phi_132_133_ladder_151_ladder_166_ladder_3;
              }
              frontier_phi_132_133_ladder = frontier_phi_132_133_ladder_151_ladder;
              frontier_phi_132_133_ladder_1 = frontier_phi_132_133_ladder_151_ladder_1;
              frontier_phi_132_133_ladder_2 = frontier_phi_132_133_ladder_151_ladder_2;
              frontier_phi_132_133_ladder_3 = frontier_phi_132_133_ladder_151_ladder_3;
            }
            _1548 = frontier_phi_132_133_ladder_3;
            _1550 = frontier_phi_132_133_ladder_2;
            _1552 = frontier_phi_132_133_ladder_1;
            _1554 = frontier_phi_132_133_ladder;
          }
          float _1556 = _1550 * 0.5f;
          float _1559 = _1552 - _1550;
          float _1561 = mad(_1552, 0.5f, _1556) - _1062;
          frontier_phi_84_83_ladder_100_ladder = ((((_1561 * 2.0f) / (((-0.0f) - _1559) - sqrt((_1559 * _1559) - ((mad(_1554, 0.5f, mad(_1552, -1.0f, _1556)) * 4.0f) * _1561)))) + _1548) * 0.33160507678985595703125f) + 0.68124115467071533203125f;
        } else {
          frontier_phi_84_83_ladder_100_ladder = 3.00247669219970703125f;
        }
        frontier_phi_84_83_ladder = frontier_phi_84_83_ladder_100_ladder;
      }
      _1202 = frontier_phi_84_83_ladder;
    } else {
      _1202 = -2.54062366485595703125f;
    }
    float _1206 = exp2(_1202 * 3.3219280242919921875f);
    _1131 = mad(_1206, 0.16386906802654266357421875f, mad(_1060, 0.14067865908145904541015625f, _925 * 0.695452213287353515625f));
    _1133 = mad(_1206, 0.095534317195415496826171875f, mad(_1060, 0.85967099666595458984375f, _925 * 0.044794581830501556396484375f));
    _1135 = mad(_1206, 1.00150072574615478515625f, mad(_1060, 0.00402521155774593353271484375f, _925 * (-0.0055258679203689098358154296875f)));
  } else {
    float _98 = exp2(log2(abs(_75)) * 0.0126833133399486541748046875f);
    float _99 = _98 + (-0.8359375f);
    float _113 = exp2(log2(abs(((_99 < 0.0f) ? 0.0f : _99) / (18.8515625f - (_98 * 18.6875f)))) * 6.277394771575927734375f);
    float _117 = exp2(log2(abs(_77)) * 0.0126833133399486541748046875f);
    float _118 = _117 + (-0.8359375f);
    float _128 = exp2(log2(abs(((_118 < 0.0f) ? 0.0f : _118) / (18.8515625f - (_117 * 18.6875f)))) * 6.277394771575927734375f) * 10000.0f;
    float _133 = exp2(log2(abs(_78)) * 0.0126833133399486541748046875f);
    float _134 = _133 + (-0.8359375f);
    float _144 = exp2(log2(abs(((_134 < 0.0f) ? 0.0f : _134) / (18.8515625f - (_133 * 18.6875f)))) * 6.277394771575927734375f) * 10000.0f;
    float _149 = mad(_144, 0.16888095438480377197265625f, mad(_128, 0.14461688697338104248046875f, _113 * 6369.58203125f));
    float _155 = mad(_144, 0.059301711618900299072265625f, mad(_128, 0.677998006343841552734375f, _113 * 2627.002685546875f));
    float _159 = mad(_144, 1.06098496913909912109375f, mad(_128, 0.02807268314063549041748046875f, 0.0f));
    float _165 = mad(_159, -0.0149709321558475494384765625f, mad(_155, 0.00610530562698841094970703125f, _149 * 1.01303493976593017578125f));
    float _171 = mad(_159, -0.0050320238806307315826416015625f, mad(_155, 0.9981634616851806640625f, _149 * 0.0076982178725302219390869140625f));
    float _177 = mad(_159, 0.924506366252899169921875f, mad(_155, 0.00468514859676361083984375f, _149 * (-0.0028413091786205768585205078125f)));
    float _215;
    float _218;
    float _221;
    float _224;
    float _227;
    float _230;
    float _233;
    float _236;
    float _239;
    float _242;
    float _245;
    float _248;
    float _251;
    float _254;
    float _257;
    float _260;
    float _263;
    float _266;
    float _270;
    float _272;
    float _276;
    float _280;
    if (_15_m0[8u].w < 4000.0f) {
      float frontier_phi_6_5_ladder;
      float frontier_phi_6_5_ladder_1;
      float frontier_phi_6_5_ladder_2;
      float frontier_phi_6_5_ladder_3;
      float frontier_phi_6_5_ladder_4;
      float frontier_phi_6_5_ladder_5;
      float frontier_phi_6_5_ladder_6;
      float frontier_phi_6_5_ladder_7;
      float frontier_phi_6_5_ladder_8;
      float frontier_phi_6_5_ladder_9;
      float frontier_phi_6_5_ladder_10;
      float frontier_phi_6_5_ladder_11;
      float frontier_phi_6_5_ladder_12;
      float frontier_phi_6_5_ladder_13;
      float frontier_phi_6_5_ladder_14;
      float frontier_phi_6_5_ladder_15;
      float frontier_phi_6_5_ladder_16;
      float frontier_phi_6_5_ladder_17;
      float frontier_phi_6_5_ladder_18;
      float frontier_phi_6_5_ladder_19;
      float frontier_phi_6_5_ladder_20;
      float frontier_phi_6_5_ladder_21;
      if (_15_m0[8u].w < 48.0f) {
        frontier_phi_6_5_ladder = -1.477900028228759765625f;
        frontier_phi_6_5_ladder_1 = 0.91137444972991943359375f;
        frontier_phi_6_5_ladder_2 = 0.451108038425445556640625f;
        frontier_phi_6_5_ladder_3 = 0.0051799998618662357330322265625f;
        frontier_phi_6_5_ladder_4 = -0.448000013828277587890625f;
        frontier_phi_6_5_ladder_5 = -0.864799976348876953125f;
        frontier_phi_6_5_ladder_6 = -1.2290999889373779296875f;
        frontier_phi_6_5_ladder_7 = -1.69896996021270751953125f;
        frontier_phi_6_5_ladder_8 = 1.687873363494873046875f;
        frontier_phi_6_5_ladder_9 = 1.67460918426513671875f;
        frontier_phi_6_5_ladder_10 = 1.64670002460479736328125f;
        frontier_phi_6_5_ladder_11 = 1.51970005035400390625f;
        frontier_phi_6_5_ladder_12 = 1.38020002841949462890625f;
        frontier_phi_6_5_ladder_13 = 1.13580000400543212890625f;
        frontier_phi_6_5_ladder_14 = 0.8470437526702880859375f;
        frontier_phi_6_5_ladder_15 = 1.5985000133514404296875f;
        frontier_phi_6_5_ladder_16 = 0.51543867588043212890625f;
        frontier_phi_6_5_ladder_17 = 4.80000019073486328125f;
        frontier_phi_6_5_ladder_18 = 48.0f;
        frontier_phi_6_5_ladder_19 = 1005.71893310546875f;
        frontier_phi_6_5_ladder_20 = 0.0199999995529651641845703125f;
        frontier_phi_6_5_ladder_21 = 0.00287989364005625247955322265625f;
      } else {
        float _334 = log2(_15_m0[8u].w);
        float _380;
        float _384;
        float _388;
        float _392;
        float _396;
        float _400;
        float _404;
        float _408;
        float _412;
        float _416;
        float _419;
        float _422;
        float _425;
        float _428;
        float _431;
        float _434;
        float _437;
        float _440;
        float _442;
        float _444;
        float _446;
        float _448;
        float _450;
        float _452;
        float _454;
        float _456;
        float _458;
        float _461;
        float _464;
        float _466;
        float _467;
        float _468;
        float _469;
        float _470;
        float _473;
        if ((_15_m0[8u].w >= 2000.0f) && (_15_m0[8u].w < 4000.0f)) {
          _380 = 12.19021511077880859375f;
          _384 = 11.74135303497314453125f;
          _388 = 10.5388164520263671875f;
          _392 = 9.3608608245849609375f;
          _396 = 8.0217914581298828125f;
          _400 = 6.67973232269287109375f;
          _404 = 5.34597873687744140625f;
          _408 = 3.995220661163330078125f;
          _412 = 2.6486351490020751953125f;
          _416 = 4.289228916168212890625f;
          _419 = 2.354627132415771484375f;
          _422 = 0.39657175540924072265625f;
          _425 = -1.55067598819732666015625f;
          _428 = -3.513935565948486328125f;
          _431 = -5.050991535186767578125f;
          _434 = -6.415307521820068359375f;
          _437 = -7.643855571746826171875f;
          _440 = 11.05348491668701171875f;
          _442 = 10.87808322906494140625f;
          _444 = 10.13686370849609375f;
          _446 = 9.19642543792724609375f;
          _448 = 7.9005413055419921875f;
          _450 = 6.63488674163818359375f;
          _452 = 5.296149730682373046875f;
          _454 = 3.97968578338623046875f;
          _456 = 2.6641705036163330078125f;
          _458 = 12.0f;
          _461 = -12.0f;
          _464 = 11.0f;
          _466 = 10.0f;
          _467 = 2000.0f;
          _468 = 0.004999999888241291046142578125f;
          _469 = 4000.0f;
          _470 = clamp((_15_m0[8u].w + (-2000.0f)) * 0.0005000000237487256526947021484375f, 0.0f, 1.0f);
          _473 = clamp(_334 + (-10.9657840728759765625f), 0.0f, 1.0f);
        } else {
          float frontier_phi_19_14_ladder;
          float frontier_phi_19_14_ladder_1;
          float frontier_phi_19_14_ladder_2;
          float frontier_phi_19_14_ladder_3;
          float frontier_phi_19_14_ladder_4;
          float frontier_phi_19_14_ladder_5;
          float frontier_phi_19_14_ladder_6;
          float frontier_phi_19_14_ladder_7;
          float frontier_phi_19_14_ladder_8;
          float frontier_phi_19_14_ladder_9;
          float frontier_phi_19_14_ladder_10;
          float frontier_phi_19_14_ladder_11;
          float frontier_phi_19_14_ladder_12;
          float frontier_phi_19_14_ladder_13;
          float frontier_phi_19_14_ladder_14;
          float frontier_phi_19_14_ladder_15;
          float frontier_phi_19_14_ladder_16;
          float frontier_phi_19_14_ladder_17;
          float frontier_phi_19_14_ladder_18;
          float frontier_phi_19_14_ladder_19;
          float frontier_phi_19_14_ladder_20;
          float frontier_phi_19_14_ladder_21;
          float frontier_phi_19_14_ladder_22;
          float frontier_phi_19_14_ladder_23;
          float frontier_phi_19_14_ladder_24;
          float frontier_phi_19_14_ladder_25;
          float frontier_phi_19_14_ladder_26;
          float frontier_phi_19_14_ladder_27;
          float frontier_phi_19_14_ladder_28;
          float frontier_phi_19_14_ladder_29;
          float frontier_phi_19_14_ladder_30;
          float frontier_phi_19_14_ladder_31;
          float frontier_phi_19_14_ladder_32;
          float frontier_phi_19_14_ladder_33;
          float frontier_phi_19_14_ladder_34;
          if ((_15_m0[8u].w >= 1000.0f) && (_15_m0[8u].w < 2000.0f)) {
            frontier_phi_19_14_ladder = 2.6641705036163330078125f;
            frontier_phi_19_14_ladder_1 = -7.643855571746826171875f;
            frontier_phi_19_14_ladder_2 = -6.415307521820068359375f;
            frontier_phi_19_14_ladder_3 = -5.050991535186767578125f;
            frontier_phi_19_14_ladder_4 = -3.513935565948486328125f;
            frontier_phi_19_14_ladder_5 = -1.55067598819732666015625f;
            frontier_phi_19_14_ladder_6 = 0.39657175540924072265625f;
            frontier_phi_19_14_ladder_7 = 2.354627132415771484375f;
            frontier_phi_19_14_ladder_8 = 4.289228916168212890625f;
            frontier_phi_19_14_ladder_9 = clamp(_334 + (-9.9657840728759765625f), 0.0f, 1.0f);
            frontier_phi_19_14_ladder_10 = 3.97968578338623046875f;
            frontier_phi_19_14_ladder_11 = 5.296149730682373046875f;
            frontier_phi_19_14_ladder_12 = 6.63488674163818359375f;
            frontier_phi_19_14_ladder_13 = 7.9005413055419921875f;
            frontier_phi_19_14_ladder_14 = 9.19642543792724609375f;
            frontier_phi_19_14_ladder_15 = 10.13686370849609375f;
            frontier_phi_19_14_ladder_16 = 10.87808322906494140625f;
            frontier_phi_19_14_ladder_17 = 11.05348491668701171875f;
            frontier_phi_19_14_ladder_18 = 9.923465728759765625f;
            frontier_phi_19_14_ladder_19 = clamp((_15_m0[8u].w + (-1000.0f)) * 0.001000000047497451305389404296875f, 0.0f, 1.0f);
            frontier_phi_19_14_ladder_20 = 2000.0f;
            frontier_phi_19_14_ladder_21 = 0.004999999888241291046142578125f;
            frontier_phi_19_14_ladder_22 = 1000.0f;
            frontier_phi_19_14_ladder_23 = 10.0f;
            frontier_phi_19_14_ladder_24 = 10.0f;
            frontier_phi_19_14_ladder_25 = -12.0f;
            frontier_phi_19_14_ladder_26 = 11.0f;
            frontier_phi_19_14_ladder_27 = 3.956704616546630859375f;
            frontier_phi_19_14_ladder_28 = 5.2097797393798828125f;
            frontier_phi_19_14_ladder_29 = 6.472112178802490234375f;
            frontier_phi_19_14_ladder_30 = 7.668006420135498046875f;
            frontier_phi_19_14_ladder_31 = 8.76457500457763671875f;
            frontier_phi_19_14_ladder_32 = 9.49905300140380859375f;
            frontier_phi_19_14_ladder_33 = 10.0081024169921875f;
            frontier_phi_19_14_ladder_34 = 2.687151432037353515625f;
          } else {
            frontier_phi_19_14_ladder = 2.687151432037353515625f;
            frontier_phi_19_14_ladder_1 = -5.643856048583984375f;
            frontier_phi_19_14_ladder_2 = -4.909477710723876953125f;
            frontier_phi_19_14_ladder_3 = -4.082981586456298828125f;
            frontier_phi_19_14_ladder_4 = -2.872803211212158203125f;
            frontier_phi_19_14_ladder_5 = -1.4882237911224365234375f;
            frontier_phi_19_14_ladder_6 = 0.01720758713781833648681640625f;
            frontier_phi_19_14_ladder_7 = 1.49854838848114013671875f;
            frontier_phi_19_14_ladder_8 = 3.0275204181671142578125f;
            frontier_phi_19_14_ladder_9 = clamp((_334 + (-5.584962368011474609375f)) * 0.22826768457889556884765625f, 0.0f, 1.0f);
            frontier_phi_19_14_ladder_10 = 3.956704616546630859375f;
            frontier_phi_19_14_ladder_11 = 5.2097797393798828125f;
            frontier_phi_19_14_ladder_12 = 6.472112178802490234375f;
            frontier_phi_19_14_ladder_13 = 7.668006420135498046875f;
            frontier_phi_19_14_ladder_14 = 8.76457500457763671875f;
            frontier_phi_19_14_ladder_15 = 9.49905300140380859375f;
            frontier_phi_19_14_ladder_16 = 9.923465728759765625f;
            frontier_phi_19_14_ladder_17 = 10.0081024169921875f;
            frontier_phi_19_14_ladder_18 = 5.562931060791015625f;
            frontier_phi_19_14_ladder_19 = clamp((_15_m0[8u].w + (-48.0f)) * 0.001050420221872627735137939453125f, 0.0f, 1.0f);
            frontier_phi_19_14_ladder_20 = 1000.0f;
            frontier_phi_19_14_ladder_21 = 0.0199999995529651641845703125f;
            frontier_phi_19_14_ladder_22 = 48.0f;
            frontier_phi_19_14_ladder_23 = 4.80000019073486328125f;
            frontier_phi_19_14_ladder_24 = 6.5f;
            frontier_phi_19_14_ladder_25 = -6.5f;
            frontier_phi_19_14_ladder_26 = 10.0f;
            frontier_phi_19_14_ladder_27 = 2.813818454742431640625f;
            frontier_phi_19_14_ladder_28 = 3.7730457782745361328125f;
            frontier_phi_19_14_ladder_29 = 4.584925174713134765625f;
            frontier_phi_19_14_ladder_30 = 5.0483341217041015625f;
            frontier_phi_19_14_ladder_31 = 5.310101985931396484375f;
            frontier_phi_19_14_ladder_32 = 5.470219135284423828125f;
            frontier_phi_19_14_ladder_33 = 5.60699367523193359375f;
            frontier_phi_19_14_ladder_34 = 1.712250232696533203125f;
          }
          _380 = frontier_phi_19_14_ladder_17;
          _384 = frontier_phi_19_14_ladder_16;
          _388 = frontier_phi_19_14_ladder_15;
          _392 = frontier_phi_19_14_ladder_14;
          _396 = frontier_phi_19_14_ladder_13;
          _400 = frontier_phi_19_14_ladder_12;
          _404 = frontier_phi_19_14_ladder_11;
          _408 = frontier_phi_19_14_ladder_10;
          _412 = frontier_phi_19_14_ladder;
          _416 = frontier_phi_19_14_ladder_8;
          _419 = frontier_phi_19_14_ladder_7;
          _422 = frontier_phi_19_14_ladder_6;
          _425 = frontier_phi_19_14_ladder_5;
          _428 = frontier_phi_19_14_ladder_4;
          _431 = frontier_phi_19_14_ladder_3;
          _434 = frontier_phi_19_14_ladder_2;
          _437 = frontier_phi_19_14_ladder_1;
          _440 = frontier_phi_19_14_ladder_33;
          _442 = frontier_phi_19_14_ladder_18;
          _444 = frontier_phi_19_14_ladder_32;
          _446 = frontier_phi_19_14_ladder_31;
          _448 = frontier_phi_19_14_ladder_30;
          _450 = frontier_phi_19_14_ladder_29;
          _452 = frontier_phi_19_14_ladder_28;
          _454 = frontier_phi_19_14_ladder_27;
          _456 = frontier_phi_19_14_ladder_34;
          _458 = frontier_phi_19_14_ladder_26;
          _461 = frontier_phi_19_14_ladder_25;
          _464 = frontier_phi_19_14_ladder_24;
          _466 = frontier_phi_19_14_ladder_23;
          _467 = frontier_phi_19_14_ladder_22;
          _468 = frontier_phi_19_14_ladder_21;
          _469 = frontier_phi_19_14_ladder_20;
          _470 = frontier_phi_19_14_ladder_19;
          _473 = frontier_phi_19_14_ladder_9;
        }
        float _476 = exp2(_437);
        float _483 = exp2(_456);
        float _489 = exp2(_454);
        float _494 = exp2(_434);
        float _501 = exp2(_452);
        float _506 = exp2(_431);
        float _513 = exp2(_450);
        float _518 = exp2(_428);
        float _525 = exp2(_448);
        float _530 = exp2(_425);
        float _537 = exp2(_446);
        float _542 = exp2(_422);
        float _549 = exp2(_444);
        float _554 = exp2(_419);
        float _561 = exp2(_442);
        float _566 = exp2(_416);
        float _573 = exp2(_440);
        float _586 = log2(max(exp2((_473 * ((-12.0f) - _461)) + _461) * 0.180000007152557373046875f, 5.9604644775390625e-08f));
        float _587 = _586 * 0.3010300099849700927734375f;
        float _656;
        if (_587 > (-5.2601776123046875f)) {
          float frontier_phi_31_30_ladder;
          if ((_587 > (-5.2601776123046875f)) && (_587 < (-0.74472749233245849609375f))) {
            float _835 = (_586 * 0.199999988079071044921875f) + 3.49478626251220703125f;
            uint _837 = uint(int(_835));
            float _839 = _835 - float(int(_837));
            uint _843 = _837 + 1u;
            float _850 = _22[_837] * 0.5f;
            frontier_phi_31_30_ladder = dot(float3(_839 * _839, _839, 1.0f), float3(mad(_22[_837 + 2u], 0.5f, mad(_22[_843], -1.0f, _850)), _22[_843] - _22[_837], mad(_22[_843], 0.5f, _850)));
          } else {
            float frontier_phi_31_30_ladder_40_ladder;
            if ((_587 >= (-0.74472749233245849609375f)) && (_587 < 4.673812389373779296875f)) {
              float _931 = (_586 * 0.1666666567325592041015625f) + 0.4123218357563018798828125f;
              uint _933 = uint(int(_931));
              float _935 = _931 - float(int(_933));
              uint _938 = _933 + 1u;
              float _945 = _29[_933] * 0.5f;
              frontier_phi_31_30_ladder_40_ladder = dot(float3(_935 * _935, _935, 1.0f), float3(mad(_29[_933 + 2u], 0.5f, mad(_29[_938], -1.0f, _945)), _29[_938] - _29[_933], mad(_29[_938], 0.5f, _945)));
            } else {
              frontier_phi_31_30_ladder_40_ladder = 4.0f;
            }
            frontier_phi_31_30_ladder = frontier_phi_31_30_ladder_40_ladder;
          }
          _656 = frontier_phi_31_30_ladder;
        } else {
          _656 = -4.0f;
        }
        float _670 = log2(max(exp2((_473 * (_458 - _464)) + _464) * 0.180000007152557373046875f, 5.9604644775390625e-08f));
        float _671 = _670 * 0.3010300099849700927734375f;
        float _865;
        if (_671 > (-5.2601776123046875f)) {
          float frontier_phi_42_41_ladder;
          if ((_671 > (-5.2601776123046875f)) && (_671 < (-0.74472749233245849609375f))) {
            float _953 = (_670 * 0.199999988079071044921875f) + 3.49478626251220703125f;
            uint _954 = uint(int(_953));
            float _956 = _953 - float(int(_954));
            uint _959 = _954 + 1u;
            float _966 = _22[_954] * 0.5f;
            frontier_phi_42_41_ladder = dot(float3(_956 * _956, _956, 1.0f), float3(mad(_22[_954 + 2u], 0.5f, mad(_22[_959], -1.0f, _966)), _22[_959] - _22[_954], mad(_22[_959], 0.5f, _966)));
          } else {
            float frontier_phi_42_41_ladder_55_ladder;
            if ((_671 >= (-0.74472749233245849609375f)) && (_671 < 4.673812389373779296875f)) {
              float _1065 = (_670 * 0.1666666567325592041015625f) + 0.4123218357563018798828125f;
              uint _1066 = uint(int(_1065));
              float _1068 = _1065 - float(int(_1066));
              uint _1071 = _1066 + 1u;
              float _1078 = _29[_1066] * 0.5f;
              frontier_phi_42_41_ladder_55_ladder = dot(float3(_1068 * _1068, _1068, 1.0f), float3(mad(_29[_1066 + 2u], 0.5f, mad(_29[_1071], -1.0f, _1078)), _29[_1071] - _29[_1066], mad(_29[_1071], 0.5f, _1078)));
            } else {
              frontier_phi_42_41_ladder_55_ladder = 4.0f;
            }
            frontier_phi_42_41_ladder = frontier_phi_42_41_ladder_55_ladder;
          }
          _865 = frontier_phi_42_41_ladder;
        } else {
          _865 = -4.0f;
        }
        frontier_phi_6_5_ladder = log2(((0.011716556735336780548095703125f - _494) * _470) + _494) * 0.3010300099849700927734375f;
        frontier_phi_6_5_ladder_1 = log2(((19.551792144775390625f - _566) * _470) + _566) * 0.3010300099849700927734375f;
        frontier_phi_6_5_ladder_2 = log2(((5.114620208740234375f - _554) * _470) + _554) * 0.3010300099849700927734375f;
        frontier_phi_6_5_ladder_3 = log2(((1.31637609004974365234375f - _542) * _470) + _542) * 0.3010300099849700927734375f;
        frontier_phi_6_5_ladder_4 = log2(((0.341350078582763671875f - _530) * _470) + _530) * 0.3010300099849700927734375f;
        frontier_phi_6_5_ladder_5 = log2(((0.087538681924343109130859375f - _518) * _470) + _518) * 0.3010300099849700927734375f;
        frontier_phi_6_5_ladder_6 = log2(((0.030164770781993865966796875f - _506) * _470) + _506) * 0.3010300099849700927734375f;
        frontier_phi_6_5_ladder_7 = log2(((0.0050000022165477275848388671875f - _476) * _470) + _476) * 0.3010300099849700927734375f;
        frontier_phi_6_5_ladder_8 = log2(((exp2(_380) - _573) * _470) + _573) * 0.3010300099849700927734375f;
        frontier_phi_6_5_ladder_9 = log2(((exp2(_384) - _561) * _470) + _561) * 0.3010300099849700927734375f;
        frontier_phi_6_5_ladder_10 = log2(((exp2(_388) - _549) * _470) + _549) * 0.3010300099849700927734375f;
        frontier_phi_6_5_ladder_11 = log2(((exp2(_396) - _525) * _470) + _525) * 0.3010300099849700927734375f;
        frontier_phi_6_5_ladder_12 = log2(((exp2(_400) - _513) * _470) + _513) * 0.3010300099849700927734375f;
        frontier_phi_6_5_ladder_13 = log2(((exp2(_404) - _501) * _470) + _501) * 0.3010300099849700927734375f;
        frontier_phi_6_5_ladder_14 = log2(((exp2(_408) - _489) * _470) + _489) * 0.3010300099849700927734375f;
        frontier_phi_6_5_ladder_15 = log2(((exp2(_392) - _537) * _470) + _537) * 0.3010300099849700927734375f;
        frontier_phi_6_5_ladder_16 = log2(((exp2(_412) - _483) * _470) + _483) * 0.3010300099849700927734375f;
        frontier_phi_6_5_ladder_17 = (_470 * (10.0f - _466)) + _466;
        frontier_phi_6_5_ladder_18 = (_470 * (_469 - _467)) + _467;
        frontier_phi_6_5_ladder_19 = exp2(_865 * 3.3219280242919921875f);
        frontier_phi_6_5_ladder_20 = (_470 * (0.004999999888241291046142578125f - _468)) + _468;
        frontier_phi_6_5_ladder_21 = exp2(_656 * 3.3219280242919921875f);
      }
      _215 = frontier_phi_6_5_ladder_1;
      _218 = frontier_phi_6_5_ladder_2;
      _221 = frontier_phi_6_5_ladder_3;
      _224 = frontier_phi_6_5_ladder_4;
      _227 = frontier_phi_6_5_ladder_5;
      _230 = frontier_phi_6_5_ladder_6;
      _233 = frontier_phi_6_5_ladder;
      _236 = frontier_phi_6_5_ladder_7;
      _239 = frontier_phi_6_5_ladder_8;
      _242 = frontier_phi_6_5_ladder_9;
      _245 = frontier_phi_6_5_ladder_10;
      _248 = frontier_phi_6_5_ladder_15;
      _251 = frontier_phi_6_5_ladder_11;
      _254 = frontier_phi_6_5_ladder_12;
      _257 = frontier_phi_6_5_ladder_13;
      _260 = frontier_phi_6_5_ladder_14;
      _263 = frontier_phi_6_5_ladder_16;
      _266 = frontier_phi_6_5_ladder_17;
      _270 = frontier_phi_6_5_ladder_18;
      _272 = frontier_phi_6_5_ladder_19;
      _276 = frontier_phi_6_5_ladder_20;
      _280 = frontier_phi_6_5_ladder_21;
    } else {
      _215 = 1.2911865711212158203125f;
      _218 = 0.7088134288787841796875f;
      _221 = 0.11937999725341796875f;
      _224 = -0.4668000042438507080078125f;
      _227 = -1.0578000545501708984375f;
      _230 = -1.5204999446868896484375f;
      _233 = -1.9312000274658203125f;
      _236 = -2.3010299205780029296875f;
      _239 = 3.669620513916015625f;
      _242 = 3.534499645233154296875f;
      _245 = 3.1724998950958251953125f;
      _248 = 2.8178999423980712890625f;
      _251 = 2.4147999286651611328125f;
      _254 = 2.010799884796142578125f;
      _257 = 1.60930001735687255859375f;
      _260 = 1.2026813030242919921875f;
      _263 = 0.797318637371063232421875f;
      _266 = 10.0f;
      _270 = 4000.0f;
      _272 = 6824.36376953125f;
      _276 = 0.004999999888241291046142578125f;
      _280 = 0.00014179872232489287853240966796875f;
    }
    float _284 = log2(_280);
    float _287 = (2.2630341053009033203125f - _284) * 0.0430042855441570281982421875f;
    float _289 = log2(_272);
    float _292 = (_289 + (-2.2630341053009033203125f)) * 0.0430042855441570281982421875f;
    float _294 = (_236 + _236) * 0.5f;
    float _297 = (_236 + _233) * 0.5f;
    float _299 = (_233 + _230) * 0.5f;
    float _301 = (_230 + _227) * 0.5f;
    float _303 = (_227 + _224) * 0.5f;
    float _305 = (_224 + _221) * 0.5f;
    float _307 = (_221 + _218) * 0.5f;
    float _309 = (_263 + _260) * 0.5f;
    float _311 = (_260 + _257) * 0.5f;
    float _313 = (_257 + _254) * 0.5f;
    float _315 = (_254 + _251) * 0.5f;
    float _317 = (_251 + _248) * 0.5f;
    float _319 = (_248 + _245) * 0.5f;
    float _321 = (_245 + _242) * 0.5f;
    float _323 = log2(mad(_177, -0.2364246845245361328125f, mad(_171, -0.324803292751312255859375f, _165 * 1.641023159027099609375f)) + 3.5073844628641381859779357910156e-05f) * 0.3010300099849700927734375f;
    float _326 = log2(_276) * 0.3010300099849700927734375f;
    float _368;
    if (_323 > _326) {
      float _337 = log2(_266) * 0.3010300099849700927734375f;
      float frontier_phi_17_9_ladder;
      if ((_323 > _326) && (_323 <= _337)) {
        float _604;
        float _608;
        float _610;
        float _612;
        if ((_323 > _294) && (_323 <= _297)) {
          _604 = 0.0f;
          _608 = _236;
          _610 = _236;
          _612 = _233;
        } else {
          float frontier_phi_22_23_ladder;
          float frontier_phi_22_23_ladder_1;
          float frontier_phi_22_23_ladder_2;
          float frontier_phi_22_23_ladder_3;
          if ((_323 > _297) && (_323 <= _299)) {
            frontier_phi_22_23_ladder = _230;
            frontier_phi_22_23_ladder_1 = _233;
            frontier_phi_22_23_ladder_2 = _236;
            frontier_phi_22_23_ladder_3 = 1.0f;
          } else {
            float frontier_phi_22_23_ladder_32_ladder;
            float frontier_phi_22_23_ladder_32_ladder_1;
            float frontier_phi_22_23_ladder_32_ladder_2;
            float frontier_phi_22_23_ladder_32_ladder_3;
            if ((_323 > _299) && (_323 <= _301)) {
              frontier_phi_22_23_ladder_32_ladder = _227;
              frontier_phi_22_23_ladder_32_ladder_1 = _230;
              frontier_phi_22_23_ladder_32_ladder_2 = _233;
              frontier_phi_22_23_ladder_32_ladder_3 = 2.0f;
            } else {
              float frontier_phi_22_23_ladder_32_ladder_43_ladder;
              float frontier_phi_22_23_ladder_32_ladder_43_ladder_1;
              float frontier_phi_22_23_ladder_32_ladder_43_ladder_2;
              float frontier_phi_22_23_ladder_32_ladder_43_ladder_3;
              if ((_323 > _301) && (_323 <= _303)) {
                frontier_phi_22_23_ladder_32_ladder_43_ladder = _224;
                frontier_phi_22_23_ladder_32_ladder_43_ladder_1 = _227;
                frontier_phi_22_23_ladder_32_ladder_43_ladder_2 = _230;
                frontier_phi_22_23_ladder_32_ladder_43_ladder_3 = 3.0f;
              } else {
                float frontier_phi_22_23_ladder_32_ladder_43_ladder_56_ladder;
                float frontier_phi_22_23_ladder_32_ladder_43_ladder_56_ladder_1;
                float frontier_phi_22_23_ladder_32_ladder_43_ladder_56_ladder_2;
                float frontier_phi_22_23_ladder_32_ladder_43_ladder_56_ladder_3;
                if ((_323 > _303) && (_323 <= _305)) {
                  frontier_phi_22_23_ladder_32_ladder_43_ladder_56_ladder = _221;
                  frontier_phi_22_23_ladder_32_ladder_43_ladder_56_ladder_1 = _224;
                  frontier_phi_22_23_ladder_32_ladder_43_ladder_56_ladder_2 = _227;
                  frontier_phi_22_23_ladder_32_ladder_43_ladder_56_ladder_3 = 4.0f;
                } else {
                  bool _1087 = (_323 > _305) && (_323 <= _307);
                  frontier_phi_22_23_ladder_32_ladder_43_ladder_56_ladder = _1087 ? _218 : _215;
                  frontier_phi_22_23_ladder_32_ladder_43_ladder_56_ladder_1 = _1087 ? _221 : _218;
                  frontier_phi_22_23_ladder_32_ladder_43_ladder_56_ladder_2 = _1087 ? _224 : _221;
                  frontier_phi_22_23_ladder_32_ladder_43_ladder_56_ladder_3 = _1087 ? 5.0f : 6.0f;
                }
                frontier_phi_22_23_ladder_32_ladder_43_ladder = frontier_phi_22_23_ladder_32_ladder_43_ladder_56_ladder;
                frontier_phi_22_23_ladder_32_ladder_43_ladder_1 = frontier_phi_22_23_ladder_32_ladder_43_ladder_56_ladder_1;
                frontier_phi_22_23_ladder_32_ladder_43_ladder_2 = frontier_phi_22_23_ladder_32_ladder_43_ladder_56_ladder_2;
                frontier_phi_22_23_ladder_32_ladder_43_ladder_3 = frontier_phi_22_23_ladder_32_ladder_43_ladder_56_ladder_3;
              }
              frontier_phi_22_23_ladder_32_ladder = frontier_phi_22_23_ladder_32_ladder_43_ladder;
              frontier_phi_22_23_ladder_32_ladder_1 = frontier_phi_22_23_ladder_32_ladder_43_ladder_1;
              frontier_phi_22_23_ladder_32_ladder_2 = frontier_phi_22_23_ladder_32_ladder_43_ladder_2;
              frontier_phi_22_23_ladder_32_ladder_3 = frontier_phi_22_23_ladder_32_ladder_43_ladder_3;
            }
            frontier_phi_22_23_ladder = frontier_phi_22_23_ladder_32_ladder;
            frontier_phi_22_23_ladder_1 = frontier_phi_22_23_ladder_32_ladder_1;
            frontier_phi_22_23_ladder_2 = frontier_phi_22_23_ladder_32_ladder_2;
            frontier_phi_22_23_ladder_3 = frontier_phi_22_23_ladder_32_ladder_3;
          }
          _604 = frontier_phi_22_23_ladder_3;
          _608 = frontier_phi_22_23_ladder_2;
          _610 = frontier_phi_22_23_ladder_1;
          _612 = frontier_phi_22_23_ladder;
        }
        float _614 = _608 * 0.5f;
        float _618 = _610 - _608;
        float _620 = mad(_610, 0.5f, _614) - _323;
        frontier_phi_17_9_ladder = (_284 * 0.3010300099849700927734375f) + (_287 * (((_620 * 2.0f) / (((-0.0f) - _618) - sqrt((_618 * _618) - ((mad(_612, 0.5f, mad(_610, -1.0f, _614)) * 4.0f) * _620)))) + _604));
      } else {
        float frontier_phi_17_9_ladder_16_ladder;
        if ((_323 > _337) && (_323 < (log2(_270) * 0.3010300099849700927734375f))) {
          float _676;
          float _678;
          float _680;
          float _682;
          if ((_323 > _309) && (_323 <= _311)) {
            _676 = 0.0f;
            _678 = _263;
            _680 = _260;
            _682 = _257;
          } else {
            float frontier_phi_33_34_ladder;
            float frontier_phi_33_34_ladder_1;
            float frontier_phi_33_34_ladder_2;
            float frontier_phi_33_34_ladder_3;
            if ((_323 > _311) && (_323 <= _313)) {
              frontier_phi_33_34_ladder = _260;
              frontier_phi_33_34_ladder_1 = 1.0f;
              frontier_phi_33_34_ladder_2 = _257;
              frontier_phi_33_34_ladder_3 = _254;
            } else {
              float frontier_phi_33_34_ladder_44_ladder;
              float frontier_phi_33_34_ladder_44_ladder_1;
              float frontier_phi_33_34_ladder_44_ladder_2;
              float frontier_phi_33_34_ladder_44_ladder_3;
              if ((_323 > _313) && (_323 <= _315)) {
                frontier_phi_33_34_ladder_44_ladder = _257;
                frontier_phi_33_34_ladder_44_ladder_1 = 2.0f;
                frontier_phi_33_34_ladder_44_ladder_2 = _254;
                frontier_phi_33_34_ladder_44_ladder_3 = _251;
              } else {
                float frontier_phi_33_34_ladder_44_ladder_57_ladder;
                float frontier_phi_33_34_ladder_44_ladder_57_ladder_1;
                float frontier_phi_33_34_ladder_44_ladder_57_ladder_2;
                float frontier_phi_33_34_ladder_44_ladder_57_ladder_3;
                if ((_323 > _315) && (_323 <= _317)) {
                  frontier_phi_33_34_ladder_44_ladder_57_ladder = _254;
                  frontier_phi_33_34_ladder_44_ladder_57_ladder_1 = 3.0f;
                  frontier_phi_33_34_ladder_44_ladder_57_ladder_2 = _251;
                  frontier_phi_33_34_ladder_44_ladder_57_ladder_3 = _248;
                } else {
                  float frontier_phi_33_34_ladder_44_ladder_57_ladder_70_ladder;
                  float frontier_phi_33_34_ladder_44_ladder_57_ladder_70_ladder_1;
                  float frontier_phi_33_34_ladder_44_ladder_57_ladder_70_ladder_2;
                  float frontier_phi_33_34_ladder_44_ladder_57_ladder_70_ladder_3;
                  if ((_323 > _317) && (_323 <= _319)) {
                    frontier_phi_33_34_ladder_44_ladder_57_ladder_70_ladder = _251;
                    frontier_phi_33_34_ladder_44_ladder_57_ladder_70_ladder_1 = 4.0f;
                    frontier_phi_33_34_ladder_44_ladder_57_ladder_70_ladder_2 = _248;
                    frontier_phi_33_34_ladder_44_ladder_57_ladder_70_ladder_3 = _245;
                  } else {
                    bool _1215 = (_323 > _319) && (_323 <= _321);
                    frontier_phi_33_34_ladder_44_ladder_57_ladder_70_ladder = _1215 ? _248 : _245;
                    frontier_phi_33_34_ladder_44_ladder_57_ladder_70_ladder_1 = _1215 ? 5.0f : 6.0f;
                    frontier_phi_33_34_ladder_44_ladder_57_ladder_70_ladder_2 = _1215 ? _245 : _242;
                    frontier_phi_33_34_ladder_44_ladder_57_ladder_70_ladder_3 = _1215 ? _242 : _239;
                  }
                  frontier_phi_33_34_ladder_44_ladder_57_ladder = frontier_phi_33_34_ladder_44_ladder_57_ladder_70_ladder;
                  frontier_phi_33_34_ladder_44_ladder_57_ladder_1 = frontier_phi_33_34_ladder_44_ladder_57_ladder_70_ladder_1;
                  frontier_phi_33_34_ladder_44_ladder_57_ladder_2 = frontier_phi_33_34_ladder_44_ladder_57_ladder_70_ladder_2;
                  frontier_phi_33_34_ladder_44_ladder_57_ladder_3 = frontier_phi_33_34_ladder_44_ladder_57_ladder_70_ladder_3;
                }
                frontier_phi_33_34_ladder_44_ladder = frontier_phi_33_34_ladder_44_ladder_57_ladder;
                frontier_phi_33_34_ladder_44_ladder_1 = frontier_phi_33_34_ladder_44_ladder_57_ladder_1;
                frontier_phi_33_34_ladder_44_ladder_2 = frontier_phi_33_34_ladder_44_ladder_57_ladder_2;
                frontier_phi_33_34_ladder_44_ladder_3 = frontier_phi_33_34_ladder_44_ladder_57_ladder_3;
              }
              frontier_phi_33_34_ladder = frontier_phi_33_34_ladder_44_ladder;
              frontier_phi_33_34_ladder_1 = frontier_phi_33_34_ladder_44_ladder_1;
              frontier_phi_33_34_ladder_2 = frontier_phi_33_34_ladder_44_ladder_2;
              frontier_phi_33_34_ladder_3 = frontier_phi_33_34_ladder_44_ladder_3;
            }
            _676 = frontier_phi_33_34_ladder_1;
            _678 = frontier_phi_33_34_ladder;
            _680 = frontier_phi_33_34_ladder_2;
            _682 = frontier_phi_33_34_ladder_3;
          }
          float _684 = _678 * 0.5f;
          float _687 = _680 - _678;
          float _689 = mad(_680, 0.5f, _684) - _323;
          frontier_phi_17_9_ladder_16_ladder = (_292 * (((_689 * 2.0f) / (((-0.0f) - _687) - sqrt((_687 * _687) - ((mad(_682, 0.5f, mad(_680, -1.0f, _684)) * 4.0f) * _689)))) + _676)) + 0.68124115467071533203125f;
        } else {
          frontier_phi_17_9_ladder_16_ladder = _289 * 0.3010300099849700927734375f;
        }
        frontier_phi_17_9_ladder = frontier_phi_17_9_ladder_16_ladder;
      }
      _368 = frontier_phi_17_9_ladder;
    } else {
      _368 = _284 * 0.3010300099849700927734375f;
    }
    float _374 = exp2(_368 * 3.3219280242919921875f);
    float _376 = log2(mad(_177, 0.01675636507570743560791015625f, mad(_171, 1.61533200740814208984375f, _165 * (-0.66366302967071533203125f))) + 3.5073844628641381859779357910156e-05f) * 0.3010300099849700927734375f;
    float _713;
    if (_376 > _326) {
      float _642 = log2(_266) * 0.3010300099849700927734375f;
      float frontier_phi_37_26_ladder;
      if ((_376 > _326) && (_376 <= _642)) {
        float _877;
        float _879;
        float _881;
        float _883;
        if ((_376 > _294) && (_376 <= _297)) {
          _877 = 0.0f;
          _879 = _236;
          _881 = _236;
          _883 = _233;
        } else {
          float frontier_phi_45_46_ladder;
          float frontier_phi_45_46_ladder_1;
          float frontier_phi_45_46_ladder_2;
          float frontier_phi_45_46_ladder_3;
          if ((_376 > _297) && (_376 <= _299)) {
            frontier_phi_45_46_ladder = _230;
            frontier_phi_45_46_ladder_1 = _233;
            frontier_phi_45_46_ladder_2 = _236;
            frontier_phi_45_46_ladder_3 = 1.0f;
          } else {
            float frontier_phi_45_46_ladder_58_ladder;
            float frontier_phi_45_46_ladder_58_ladder_1;
            float frontier_phi_45_46_ladder_58_ladder_2;
            float frontier_phi_45_46_ladder_58_ladder_3;
            if ((_376 > _299) && (_376 <= _301)) {
              frontier_phi_45_46_ladder_58_ladder = _227;
              frontier_phi_45_46_ladder_58_ladder_1 = _230;
              frontier_phi_45_46_ladder_58_ladder_2 = _233;
              frontier_phi_45_46_ladder_58_ladder_3 = 2.0f;
            } else {
              float frontier_phi_45_46_ladder_58_ladder_71_ladder;
              float frontier_phi_45_46_ladder_58_ladder_71_ladder_1;
              float frontier_phi_45_46_ladder_58_ladder_71_ladder_2;
              float frontier_phi_45_46_ladder_58_ladder_71_ladder_3;
              if ((_376 > _301) && (_376 <= _303)) {
                frontier_phi_45_46_ladder_58_ladder_71_ladder = _224;
                frontier_phi_45_46_ladder_58_ladder_71_ladder_1 = _227;
                frontier_phi_45_46_ladder_58_ladder_71_ladder_2 = _230;
                frontier_phi_45_46_ladder_58_ladder_71_ladder_3 = 3.0f;
              } else {
                float frontier_phi_45_46_ladder_58_ladder_71_ladder_86_ladder;
                float frontier_phi_45_46_ladder_58_ladder_71_ladder_86_ladder_1;
                float frontier_phi_45_46_ladder_58_ladder_71_ladder_86_ladder_2;
                float frontier_phi_45_46_ladder_58_ladder_71_ladder_86_ladder_3;
                if ((_376 > _303) && (_376 <= _305)) {
                  frontier_phi_45_46_ladder_58_ladder_71_ladder_86_ladder = _221;
                  frontier_phi_45_46_ladder_58_ladder_71_ladder_86_ladder_1 = _224;
                  frontier_phi_45_46_ladder_58_ladder_71_ladder_86_ladder_2 = _227;
                  frontier_phi_45_46_ladder_58_ladder_71_ladder_86_ladder_3 = 4.0f;
                } else {
                  bool _1337 = (_376 > _305) && (_376 <= _307);
                  frontier_phi_45_46_ladder_58_ladder_71_ladder_86_ladder = _1337 ? _218 : _215;
                  frontier_phi_45_46_ladder_58_ladder_71_ladder_86_ladder_1 = _1337 ? _221 : _218;
                  frontier_phi_45_46_ladder_58_ladder_71_ladder_86_ladder_2 = _1337 ? _224 : _221;
                  frontier_phi_45_46_ladder_58_ladder_71_ladder_86_ladder_3 = _1337 ? 5.0f : 6.0f;
                }
                frontier_phi_45_46_ladder_58_ladder_71_ladder = frontier_phi_45_46_ladder_58_ladder_71_ladder_86_ladder;
                frontier_phi_45_46_ladder_58_ladder_71_ladder_1 = frontier_phi_45_46_ladder_58_ladder_71_ladder_86_ladder_1;
                frontier_phi_45_46_ladder_58_ladder_71_ladder_2 = frontier_phi_45_46_ladder_58_ladder_71_ladder_86_ladder_2;
                frontier_phi_45_46_ladder_58_ladder_71_ladder_3 = frontier_phi_45_46_ladder_58_ladder_71_ladder_86_ladder_3;
              }
              frontier_phi_45_46_ladder_58_ladder = frontier_phi_45_46_ladder_58_ladder_71_ladder;
              frontier_phi_45_46_ladder_58_ladder_1 = frontier_phi_45_46_ladder_58_ladder_71_ladder_1;
              frontier_phi_45_46_ladder_58_ladder_2 = frontier_phi_45_46_ladder_58_ladder_71_ladder_2;
              frontier_phi_45_46_ladder_58_ladder_3 = frontier_phi_45_46_ladder_58_ladder_71_ladder_3;
            }
            frontier_phi_45_46_ladder = frontier_phi_45_46_ladder_58_ladder;
            frontier_phi_45_46_ladder_1 = frontier_phi_45_46_ladder_58_ladder_1;
            frontier_phi_45_46_ladder_2 = frontier_phi_45_46_ladder_58_ladder_2;
            frontier_phi_45_46_ladder_3 = frontier_phi_45_46_ladder_58_ladder_3;
          }
          _877 = frontier_phi_45_46_ladder_3;
          _879 = frontier_phi_45_46_ladder_2;
          _881 = frontier_phi_45_46_ladder_1;
          _883 = frontier_phi_45_46_ladder;
        }
        float _885 = _879 * 0.5f;
        float _888 = _881 - _879;
        float _890 = mad(_881, 0.5f, _885) - _376;
        frontier_phi_37_26_ladder = (_284 * 0.3010300099849700927734375f) + (_287 * (((_890 * 2.0f) / (((-0.0f) - _888) - sqrt((_888 * _888) - ((mad(_883, 0.5f, mad(_881, -1.0f, _885)) * 4.0f) * _890)))) + _877));
      } else {
        float frontier_phi_37_26_ladder_36_ladder;
        if ((_376 > _642) && (_376 < (log2(_270) * 0.3010300099849700927734375f))) {
          float _985;
          float _987;
          float _989;
          float _991;
          if ((_376 > _309) && (_376 <= _311)) {
            _985 = 0.0f;
            _987 = _263;
            _989 = _260;
            _991 = _257;
          } else {
            float frontier_phi_59_60_ladder;
            float frontier_phi_59_60_ladder_1;
            float frontier_phi_59_60_ladder_2;
            float frontier_phi_59_60_ladder_3;
            if ((_376 > _311) && (_376 <= _313)) {
              frontier_phi_59_60_ladder = _254;
              frontier_phi_59_60_ladder_1 = _257;
              frontier_phi_59_60_ladder_2 = _260;
              frontier_phi_59_60_ladder_3 = 1.0f;
            } else {
              float frontier_phi_59_60_ladder_72_ladder;
              float frontier_phi_59_60_ladder_72_ladder_1;
              float frontier_phi_59_60_ladder_72_ladder_2;
              float frontier_phi_59_60_ladder_72_ladder_3;
              if ((_376 > _313) && (_376 <= _315)) {
                frontier_phi_59_60_ladder_72_ladder = _251;
                frontier_phi_59_60_ladder_72_ladder_1 = _254;
                frontier_phi_59_60_ladder_72_ladder_2 = _257;
                frontier_phi_59_60_ladder_72_ladder_3 = 2.0f;
              } else {
                float frontier_phi_59_60_ladder_72_ladder_87_ladder;
                float frontier_phi_59_60_ladder_72_ladder_87_ladder_1;
                float frontier_phi_59_60_ladder_72_ladder_87_ladder_2;
                float frontier_phi_59_60_ladder_72_ladder_87_ladder_3;
                if ((_376 > _315) && (_376 <= _317)) {
                  frontier_phi_59_60_ladder_72_ladder_87_ladder = _248;
                  frontier_phi_59_60_ladder_72_ladder_87_ladder_1 = _251;
                  frontier_phi_59_60_ladder_72_ladder_87_ladder_2 = _254;
                  frontier_phi_59_60_ladder_72_ladder_87_ladder_3 = 3.0f;
                } else {
                  float frontier_phi_59_60_ladder_72_ladder_87_ladder_102_ladder;
                  float frontier_phi_59_60_ladder_72_ladder_87_ladder_102_ladder_1;
                  float frontier_phi_59_60_ladder_72_ladder_87_ladder_102_ladder_2;
                  float frontier_phi_59_60_ladder_72_ladder_87_ladder_102_ladder_3;
                  if ((_376 > _317) && (_376 <= _319)) {
                    frontier_phi_59_60_ladder_72_ladder_87_ladder_102_ladder = _245;
                    frontier_phi_59_60_ladder_72_ladder_87_ladder_102_ladder_1 = _248;
                    frontier_phi_59_60_ladder_72_ladder_87_ladder_102_ladder_2 = _251;
                    frontier_phi_59_60_ladder_72_ladder_87_ladder_102_ladder_3 = 4.0f;
                  } else {
                    bool _1435 = (_376 > _319) && (_376 <= _321);
                    frontier_phi_59_60_ladder_72_ladder_87_ladder_102_ladder = _1435 ? _242 : _239;
                    frontier_phi_59_60_ladder_72_ladder_87_ladder_102_ladder_1 = _1435 ? _245 : _242;
                    frontier_phi_59_60_ladder_72_ladder_87_ladder_102_ladder_2 = _1435 ? _248 : _245;
                    frontier_phi_59_60_ladder_72_ladder_87_ladder_102_ladder_3 = _1435 ? 5.0f : 6.0f;
                  }
                  frontier_phi_59_60_ladder_72_ladder_87_ladder = frontier_phi_59_60_ladder_72_ladder_87_ladder_102_ladder;
                  frontier_phi_59_60_ladder_72_ladder_87_ladder_1 = frontier_phi_59_60_ladder_72_ladder_87_ladder_102_ladder_1;
                  frontier_phi_59_60_ladder_72_ladder_87_ladder_2 = frontier_phi_59_60_ladder_72_ladder_87_ladder_102_ladder_2;
                  frontier_phi_59_60_ladder_72_ladder_87_ladder_3 = frontier_phi_59_60_ladder_72_ladder_87_ladder_102_ladder_3;
                }
                frontier_phi_59_60_ladder_72_ladder = frontier_phi_59_60_ladder_72_ladder_87_ladder;
                frontier_phi_59_60_ladder_72_ladder_1 = frontier_phi_59_60_ladder_72_ladder_87_ladder_1;
                frontier_phi_59_60_ladder_72_ladder_2 = frontier_phi_59_60_ladder_72_ladder_87_ladder_2;
                frontier_phi_59_60_ladder_72_ladder_3 = frontier_phi_59_60_ladder_72_ladder_87_ladder_3;
              }
              frontier_phi_59_60_ladder = frontier_phi_59_60_ladder_72_ladder;
              frontier_phi_59_60_ladder_1 = frontier_phi_59_60_ladder_72_ladder_1;
              frontier_phi_59_60_ladder_2 = frontier_phi_59_60_ladder_72_ladder_2;
              frontier_phi_59_60_ladder_3 = frontier_phi_59_60_ladder_72_ladder_3;
            }
            _985 = frontier_phi_59_60_ladder_3;
            _987 = frontier_phi_59_60_ladder_2;
            _989 = frontier_phi_59_60_ladder_1;
            _991 = frontier_phi_59_60_ladder;
          }
          float _993 = _987 * 0.5f;
          float _996 = _989 - _987;
          float _998 = mad(_989, 0.5f, _993) - _376;
          frontier_phi_37_26_ladder_36_ladder = (_292 * (((_998 * 2.0f) / (((-0.0f) - _996) - sqrt((_996 * _996) - ((mad(_991, 0.5f, mad(_989, -1.0f, _993)) * 4.0f) * _998)))) + _985)) + 0.68124115467071533203125f;
        } else {
          frontier_phi_37_26_ladder_36_ladder = _289 * 0.3010300099849700927734375f;
        }
        frontier_phi_37_26_ladder = frontier_phi_37_26_ladder_36_ladder;
      }
      _713 = frontier_phi_37_26_ladder;
    } else {
      _713 = _284 * 0.3010300099849700927734375f;
    }
    float _718 = exp2(_713 * 3.3219280242919921875f);
    float _720 = log2(mad(_177, 0.98839473724365234375f, mad(_171, -0.008284439332783222198486328125f, _165 * 0.011721909977495670318603515625f)) + 3.5073844628641381859779357910156e-05f) * 0.3010300099849700927734375f;
    float _1021;
    if (_720 > _326) {
      float _911 = log2(_266) * 0.3010300099849700927734375f;
      float frontier_phi_63_49_ladder;
      if ((_720 > _326) && (_720 <= _911)) {
        float _1099;
        float _1101;
        float _1103;
        float _1105;
        if ((_720 > _294) && (_720 <= _297)) {
          _1099 = 0.0f;
          _1101 = _236;
          _1103 = _236;
          _1105 = _233;
        } else {
          float frontier_phi_73_74_ladder;
          float frontier_phi_73_74_ladder_1;
          float frontier_phi_73_74_ladder_2;
          float frontier_phi_73_74_ladder_3;
          if ((_720 > _297) && (_720 <= _299)) {
            frontier_phi_73_74_ladder = _230;
            frontier_phi_73_74_ladder_1 = _233;
            frontier_phi_73_74_ladder_2 = _236;
            frontier_phi_73_74_ladder_3 = 1.0f;
          } else {
            float frontier_phi_73_74_ladder_88_ladder;
            float frontier_phi_73_74_ladder_88_ladder_1;
            float frontier_phi_73_74_ladder_88_ladder_2;
            float frontier_phi_73_74_ladder_88_ladder_3;
            if ((_720 > _299) && (_720 <= _301)) {
              frontier_phi_73_74_ladder_88_ladder = _227;
              frontier_phi_73_74_ladder_88_ladder_1 = _230;
              frontier_phi_73_74_ladder_88_ladder_2 = _233;
              frontier_phi_73_74_ladder_88_ladder_3 = 2.0f;
            } else {
              float frontier_phi_73_74_ladder_88_ladder_103_ladder;
              float frontier_phi_73_74_ladder_88_ladder_103_ladder_1;
              float frontier_phi_73_74_ladder_88_ladder_103_ladder_2;
              float frontier_phi_73_74_ladder_88_ladder_103_ladder_3;
              if ((_720 > _301) && (_720 <= _303)) {
                frontier_phi_73_74_ladder_88_ladder_103_ladder = _224;
                frontier_phi_73_74_ladder_88_ladder_103_ladder_1 = _227;
                frontier_phi_73_74_ladder_88_ladder_103_ladder_2 = _230;
                frontier_phi_73_74_ladder_88_ladder_103_ladder_3 = 3.0f;
              } else {
                float frontier_phi_73_74_ladder_88_ladder_103_ladder_118_ladder;
                float frontier_phi_73_74_ladder_88_ladder_103_ladder_118_ladder_1;
                float frontier_phi_73_74_ladder_88_ladder_103_ladder_118_ladder_2;
                float frontier_phi_73_74_ladder_88_ladder_103_ladder_118_ladder_3;
                if ((_720 > _303) && (_720 <= _305)) {
                  frontier_phi_73_74_ladder_88_ladder_103_ladder_118_ladder = _221;
                  frontier_phi_73_74_ladder_88_ladder_103_ladder_118_ladder_1 = _224;
                  frontier_phi_73_74_ladder_88_ladder_103_ladder_118_ladder_2 = _227;
                  frontier_phi_73_74_ladder_88_ladder_103_ladder_118_ladder_3 = 4.0f;
                } else {
                  bool _1578 = (_720 > _305) && (_720 <= _307);
                  frontier_phi_73_74_ladder_88_ladder_103_ladder_118_ladder = _1578 ? _218 : _215;
                  frontier_phi_73_74_ladder_88_ladder_103_ladder_118_ladder_1 = _1578 ? _221 : _218;
                  frontier_phi_73_74_ladder_88_ladder_103_ladder_118_ladder_2 = _1578 ? _224 : _221;
                  frontier_phi_73_74_ladder_88_ladder_103_ladder_118_ladder_3 = _1578 ? 5.0f : 6.0f;
                }
                frontier_phi_73_74_ladder_88_ladder_103_ladder = frontier_phi_73_74_ladder_88_ladder_103_ladder_118_ladder;
                frontier_phi_73_74_ladder_88_ladder_103_ladder_1 = frontier_phi_73_74_ladder_88_ladder_103_ladder_118_ladder_1;
                frontier_phi_73_74_ladder_88_ladder_103_ladder_2 = frontier_phi_73_74_ladder_88_ladder_103_ladder_118_ladder_2;
                frontier_phi_73_74_ladder_88_ladder_103_ladder_3 = frontier_phi_73_74_ladder_88_ladder_103_ladder_118_ladder_3;
              }
              frontier_phi_73_74_ladder_88_ladder = frontier_phi_73_74_ladder_88_ladder_103_ladder;
              frontier_phi_73_74_ladder_88_ladder_1 = frontier_phi_73_74_ladder_88_ladder_103_ladder_1;
              frontier_phi_73_74_ladder_88_ladder_2 = frontier_phi_73_74_ladder_88_ladder_103_ladder_2;
              frontier_phi_73_74_ladder_88_ladder_3 = frontier_phi_73_74_ladder_88_ladder_103_ladder_3;
            }
            frontier_phi_73_74_ladder = frontier_phi_73_74_ladder_88_ladder;
            frontier_phi_73_74_ladder_1 = frontier_phi_73_74_ladder_88_ladder_1;
            frontier_phi_73_74_ladder_2 = frontier_phi_73_74_ladder_88_ladder_2;
            frontier_phi_73_74_ladder_3 = frontier_phi_73_74_ladder_88_ladder_3;
          }
          _1099 = frontier_phi_73_74_ladder_3;
          _1101 = frontier_phi_73_74_ladder_2;
          _1103 = frontier_phi_73_74_ladder_1;
          _1105 = frontier_phi_73_74_ladder;
        }
        float _1107 = _1101 * 0.5f;
        float _1110 = _1103 - _1101;
        float _1112 = mad(_1103, 0.5f, _1107) - _720;
        frontier_phi_63_49_ladder = (_284 * 0.3010300099849700927734375f) + (_287 * (((_1112 * 2.0f) / (((-0.0f) - _1110) - sqrt((_1110 * _1110) - ((mad(_1105, 0.5f, mad(_1103, -1.0f, _1107)) * 4.0f) * _1112)))) + _1099));
      } else {
        float frontier_phi_63_49_ladder_62_ladder;
        if ((_720 > _911) && (_720 < (log2(_270) * 0.3010300099849700927734375f))) {
          float _1225;
          float _1227;
          float _1229;
          float _1231;
          if ((_720 > _309) && (_720 <= _311)) {
            _1225 = 0.0f;
            _1227 = _263;
            _1229 = _260;
            _1231 = _257;
          } else {
            float frontier_phi_89_90_ladder;
            float frontier_phi_89_90_ladder_1;
            float frontier_phi_89_90_ladder_2;
            float frontier_phi_89_90_ladder_3;
            if ((_720 > _311) && (_720 <= _313)) {
              frontier_phi_89_90_ladder = _254;
              frontier_phi_89_90_ladder_1 = _257;
              frontier_phi_89_90_ladder_2 = _260;
              frontier_phi_89_90_ladder_3 = 1.0f;
            } else {
              float frontier_phi_89_90_ladder_104_ladder;
              float frontier_phi_89_90_ladder_104_ladder_1;
              float frontier_phi_89_90_ladder_104_ladder_2;
              float frontier_phi_89_90_ladder_104_ladder_3;
              if ((_720 > _313) && (_720 <= _315)) {
                frontier_phi_89_90_ladder_104_ladder = _251;
                frontier_phi_89_90_ladder_104_ladder_1 = _254;
                frontier_phi_89_90_ladder_104_ladder_2 = _257;
                frontier_phi_89_90_ladder_104_ladder_3 = 2.0f;
              } else {
                float frontier_phi_89_90_ladder_104_ladder_119_ladder;
                float frontier_phi_89_90_ladder_104_ladder_119_ladder_1;
                float frontier_phi_89_90_ladder_104_ladder_119_ladder_2;
                float frontier_phi_89_90_ladder_104_ladder_119_ladder_3;
                if ((_720 > _315) && (_720 <= _317)) {
                  frontier_phi_89_90_ladder_104_ladder_119_ladder = _248;
                  frontier_phi_89_90_ladder_104_ladder_119_ladder_1 = _251;
                  frontier_phi_89_90_ladder_104_ladder_119_ladder_2 = _254;
                  frontier_phi_89_90_ladder_104_ladder_119_ladder_3 = 3.0f;
                } else {
                  float frontier_phi_89_90_ladder_104_ladder_119_ladder_135_ladder;
                  float frontier_phi_89_90_ladder_104_ladder_119_ladder_135_ladder_1;
                  float frontier_phi_89_90_ladder_104_ladder_119_ladder_135_ladder_2;
                  float frontier_phi_89_90_ladder_104_ladder_119_ladder_135_ladder_3;
                  if ((_720 > _317) && (_720 <= _319)) {
                    frontier_phi_89_90_ladder_104_ladder_119_ladder_135_ladder = _245;
                    frontier_phi_89_90_ladder_104_ladder_119_ladder_135_ladder_1 = _248;
                    frontier_phi_89_90_ladder_104_ladder_119_ladder_135_ladder_2 = _251;
                    frontier_phi_89_90_ladder_104_ladder_119_ladder_135_ladder_3 = 4.0f;
                  } else {
                    bool _1707 = (_720 > _319) && (_720 <= _321);
                    frontier_phi_89_90_ladder_104_ladder_119_ladder_135_ladder = _1707 ? _242 : _239;
                    frontier_phi_89_90_ladder_104_ladder_119_ladder_135_ladder_1 = _1707 ? _245 : _242;
                    frontier_phi_89_90_ladder_104_ladder_119_ladder_135_ladder_2 = _1707 ? _248 : _245;
                    frontier_phi_89_90_ladder_104_ladder_119_ladder_135_ladder_3 = _1707 ? 5.0f : 6.0f;
                  }
                  frontier_phi_89_90_ladder_104_ladder_119_ladder = frontier_phi_89_90_ladder_104_ladder_119_ladder_135_ladder;
                  frontier_phi_89_90_ladder_104_ladder_119_ladder_1 = frontier_phi_89_90_ladder_104_ladder_119_ladder_135_ladder_1;
                  frontier_phi_89_90_ladder_104_ladder_119_ladder_2 = frontier_phi_89_90_ladder_104_ladder_119_ladder_135_ladder_2;
                  frontier_phi_89_90_ladder_104_ladder_119_ladder_3 = frontier_phi_89_90_ladder_104_ladder_119_ladder_135_ladder_3;
                }
                frontier_phi_89_90_ladder_104_ladder = frontier_phi_89_90_ladder_104_ladder_119_ladder;
                frontier_phi_89_90_ladder_104_ladder_1 = frontier_phi_89_90_ladder_104_ladder_119_ladder_1;
                frontier_phi_89_90_ladder_104_ladder_2 = frontier_phi_89_90_ladder_104_ladder_119_ladder_2;
                frontier_phi_89_90_ladder_104_ladder_3 = frontier_phi_89_90_ladder_104_ladder_119_ladder_3;
              }
              frontier_phi_89_90_ladder = frontier_phi_89_90_ladder_104_ladder;
              frontier_phi_89_90_ladder_1 = frontier_phi_89_90_ladder_104_ladder_1;
              frontier_phi_89_90_ladder_2 = frontier_phi_89_90_ladder_104_ladder_2;
              frontier_phi_89_90_ladder_3 = frontier_phi_89_90_ladder_104_ladder_3;
            }
            _1225 = frontier_phi_89_90_ladder_3;
            _1227 = frontier_phi_89_90_ladder_2;
            _1229 = frontier_phi_89_90_ladder_1;
            _1231 = frontier_phi_89_90_ladder;
          }
          float _1233 = _1227 * 0.5f;
          float _1236 = _1229 - _1227;
          float _1238 = mad(_1229, 0.5f, _1233) - _720;
          frontier_phi_63_49_ladder_62_ladder = (_292 * (((_1238 * 2.0f) / (((-0.0f) - _1236) - sqrt((_1236 * _1236) - ((mad(_1231, 0.5f, mad(_1229, -1.0f, _1233)) * 4.0f) * _1238)))) + _1225)) + 0.68124115467071533203125f;
        } else {
          frontier_phi_63_49_ladder_62_ladder = _289 * 0.3010300099849700927734375f;
        }
        frontier_phi_63_49_ladder = frontier_phi_63_49_ladder_62_ladder;
      }
      _1021 = frontier_phi_63_49_ladder;
    } else {
      _1021 = _284 * 0.3010300099849700927734375f;
    }
    float _1026 = exp2(_1021 * 3.3219280242919921875f);
    _1131 = mad(_1026, 0.16386906802654266357421875f, mad(_718, 0.14067865908145904541015625f, _374 * 0.695452213287353515625f));
    _1133 = mad(_1026, 0.095534317195415496826171875f, mad(_718, 0.85967099666595458984375f, _374 * 0.044794581830501556396484375f));
    _1135 = mad(_1026, 1.00150072574615478515625f, mad(_718, 0.00402521155774593353271484375f, _374 * (-0.0055258679203689098358154296875f)));
  }
  float _1156 = log2(mad(_1135, -0.21492855250835418701171875f, mad(_1133, -0.2365107238292694091796875f, _1131 * 1.451439380645751953125f))) * 0.3010300099849700927734375f;
  float _1256;
  if (_1156 > (-4.0f)) {
    float frontier_phi_92_91_ladder;
    if ((_1156 > (-4.0f)) && (_1156 <= 0.681241333484649658203125f)) {
      float _1446;
      float _1448;
      float _1450;
      float _1452;
      if (_1156 > (-3.578688144683837890625f)) {
        float frontier_phi_121_120_ladder;
        float frontier_phi_121_120_ladder_1;
        float frontier_phi_121_120_ladder_2;
        float frontier_phi_121_120_ladder_3;
        if ((_1156 > (-3.578688144683837890625f)) && (_1156 <= (-1.82131326198577880859375f))) {
          frontier_phi_121_120_ladder = -3.1573765277862548828125f;
          frontier_phi_121_120_ladder_1 = 1.0f;
          frontier_phi_121_120_ladder_2 = -4.0f;
          frontier_phi_121_120_ladder_3 = -0.485249996185302734375f;
        } else {
          bool _1584 = (_1156 > (-1.82131326198577880859375f)) && (_1156 <= 0.681241214275360107421875f);
          frontier_phi_121_120_ladder = _1584 ? (-0.485249996185302734375f) : 0.0f;
          frontier_phi_121_120_ladder_1 = _1584 ? 2.0f : 0.0f;
          frontier_phi_121_120_ladder_2 = _1584 ? (-3.1573765277862548828125f) : 0.0f;
          frontier_phi_121_120_ladder_3 = _1584 ? 1.84773242473602294921875f : 0.0f;
        }
        _1446 = frontier_phi_121_120_ladder_1;
        _1448 = frontier_phi_121_120_ladder_2;
        _1450 = frontier_phi_121_120_ladder;
        _1452 = frontier_phi_121_120_ladder_3;
      } else {
        _1446 = 0.0f;
        _1448 = -4.0f;
        _1450 = -4.0f;
        _1452 = -3.1573765277862548828125f;
      }
      float _1454 = _1448 * 0.5f;
      float _1457 = _1450 - _1448;
      float _1459 = mad(_1450, 0.5f, _1454) - _1156;
      frontier_phi_92_91_ladder = ((((_1459 * 2.0f) / (((-0.0f) - _1457) - sqrt((_1457 * _1457) - ((mad(_1452, 0.5f, mad(_1450, -1.0f, _1454)) * 4.0f) * _1459)))) + _1446) * 1.50514996051788330078125f) + (-5.2601776123046875f);
    } else {
      float frontier_phi_92_91_ladder_106_ladder;
      if ((_1156 > 0.681241333484649658203125f) && (_1156 < 4.0f)) {
        float _1585;
        float _1587;
        float _1589;
        float _1591;
        if ((_1156 > 0.68124115467071533203125f) && (_1156 <= 2.87457752227783203125f)) {
          _1585 = 0.0f;
          _1587 = -0.718548238277435302734375f;
          _1589 = 2.0810306072235107421875f;
          _1591 = 3.66812419891357421875f;
        } else {
          float frontier_phi_137_138_ladder;
          float frontier_phi_137_138_ladder_1;
          float frontier_phi_137_138_ladder_2;
          float frontier_phi_137_138_ladder_3;
          if ((_1156 > 2.87457752227783203125f) && (_1156 <= 3.834062099456787109375f)) {
            frontier_phi_137_138_ladder = 4.0f;
            frontier_phi_137_138_ladder_1 = 3.66812419891357421875f;
            frontier_phi_137_138_ladder_2 = 2.0810306072235107421875f;
            frontier_phi_137_138_ladder_3 = 1.0f;
          } else {
            bool _1710 = (_1156 > 3.834062099456787109375f) && (_1156 <= 4.0f);
            float _1590 = _1710 ? 4.0f : 0.0f;
            frontier_phi_137_138_ladder = _1590;
            frontier_phi_137_138_ladder_1 = _1590;
            frontier_phi_137_138_ladder_2 = _1710 ? 3.66812419891357421875f : 0.0f;
            frontier_phi_137_138_ladder_3 = _1710 ? 2.0f : 0.0f;
          }
          _1585 = frontier_phi_137_138_ladder_3;
          _1587 = frontier_phi_137_138_ladder_2;
          _1589 = frontier_phi_137_138_ladder_1;
          _1591 = frontier_phi_137_138_ladder;
        }
        float _1592 = _1587 * 0.5f;
        float _1595 = _1589 - _1587;
        float _1597 = mad(_1589, 0.5f, _1592) - _1156;
        frontier_phi_92_91_ladder_106_ladder = ((((_1597 * 2.0f) / (((-0.0f) - _1595) - sqrt((_1595 * _1595) - ((mad(_1591, 0.5f, mad(_1589, -1.0f, _1592)) * 4.0f) * _1597)))) + _1585) * 1.80618000030517578125f) + (-0.74472749233245849609375f);
      } else {
        frontier_phi_92_91_ladder_106_ladder = 4.673812389373779296875f;
      }
      frontier_phi_92_91_ladder = frontier_phi_92_91_ladder_106_ladder;
    }
    _1256 = frontier_phi_92_91_ladder;
  } else {
    _1256 = -5.2601776123046875f;
  }
  float _1260 = exp2(_1256 * 3.3219280242919921875f);
  float _1262 = log2(mad(_1135, -0.099675945937633514404296875f, mad(_1133, 1.176229953765869140625f, _1131 * (-0.076553761959075927734375f)))) * 0.3010300099849700927734375f;
  float _1355;
  if (_1262 > (-4.0f)) {
    float frontier_phi_108_107_ladder;
    if ((_1262 > (-4.0f)) && (_1262 <= 0.681241333484649658203125f)) {
      float _1617;
      float _1619;
      float _1621;
      float _1623;
      if (_1262 > (-3.578688144683837890625f)) {
        float frontier_phi_140_139_ladder;
        float frontier_phi_140_139_ladder_1;
        float frontier_phi_140_139_ladder_2;
        float frontier_phi_140_139_ladder_3;
        if ((_1262 > (-3.578688144683837890625f)) && (_1262 <= (-1.82131326198577880859375f))) {
          frontier_phi_140_139_ladder = -4.0f;
          frontier_phi_140_139_ladder_1 = 1.0f;
          frontier_phi_140_139_ladder_2 = -3.1573765277862548828125f;
          frontier_phi_140_139_ladder_3 = -0.485249996185302734375f;
        } else {
          bool _1713 = (_1262 > (-1.82131326198577880859375f)) && (_1262 <= 0.681241214275360107421875f);
          frontier_phi_140_139_ladder = _1713 ? (-3.1573765277862548828125f) : 0.0f;
          frontier_phi_140_139_ladder_1 = _1713 ? 2.0f : 0.0f;
          frontier_phi_140_139_ladder_2 = _1713 ? (-0.485249996185302734375f) : 0.0f;
          frontier_phi_140_139_ladder_3 = _1713 ? 1.84773242473602294921875f : 0.0f;
        }
        _1617 = frontier_phi_140_139_ladder_1;
        _1619 = frontier_phi_140_139_ladder;
        _1621 = frontier_phi_140_139_ladder_2;
        _1623 = frontier_phi_140_139_ladder_3;
      } else {
        _1617 = 0.0f;
        _1619 = -4.0f;
        _1621 = -4.0f;
        _1623 = -3.1573765277862548828125f;
      }
      float _1625 = _1619 * 0.5f;
      float _1628 = _1621 - _1619;
      float _1630 = mad(_1621, 0.5f, _1625) - _1262;
      frontier_phi_108_107_ladder = ((((_1630 * 2.0f) / (((-0.0f) - _1628) - sqrt((_1628 * _1628) - ((mad(_1623, 0.5f, mad(_1621, -1.0f, _1625)) * 4.0f) * _1630)))) + _1617) * 1.50514996051788330078125f) + (-5.2601776123046875f);
    } else {
      float frontier_phi_108_107_ladder_124_ladder;
      if ((_1262 > 0.681241333484649658203125f) && (_1262 < 4.0f)) {
        float _1714;
        float _1716;
        float _1718;
        float _1720;
        if ((_1262 > 0.68124115467071533203125f) && (_1262 <= 2.87457752227783203125f)) {
          _1714 = 0.0f;
          _1716 = -0.718548238277435302734375f;
          _1718 = 2.0810306072235107421875f;
          _1720 = 3.66812419891357421875f;
        } else {
          float frontier_phi_155_156_ladder;
          float frontier_phi_155_156_ladder_1;
          float frontier_phi_155_156_ladder_2;
          float frontier_phi_155_156_ladder_3;
          if ((_1262 > 2.87457752227783203125f) && (_1262 <= 3.834062099456787109375f)) {
            frontier_phi_155_156_ladder = 4.0f;
            frontier_phi_155_156_ladder_1 = 3.66812419891357421875f;
            frontier_phi_155_156_ladder_2 = 2.0810306072235107421875f;
            frontier_phi_155_156_ladder_3 = 1.0f;
          } else {
            bool _1793 = (_1262 > 3.834062099456787109375f) && (_1262 <= 4.0f);
            float _1719 = _1793 ? 4.0f : 0.0f;
            frontier_phi_155_156_ladder = _1719;
            frontier_phi_155_156_ladder_1 = _1719;
            frontier_phi_155_156_ladder_2 = _1793 ? 3.66812419891357421875f : 0.0f;
            frontier_phi_155_156_ladder_3 = _1793 ? 2.0f : 0.0f;
          }
          _1714 = frontier_phi_155_156_ladder_3;
          _1716 = frontier_phi_155_156_ladder_2;
          _1718 = frontier_phi_155_156_ladder_1;
          _1720 = frontier_phi_155_156_ladder;
        }
        float _1721 = _1716 * 0.5f;
        float _1724 = _1718 - _1716;
        float _1726 = mad(_1718, 0.5f, _1721) - _1262;
        frontier_phi_108_107_ladder_124_ladder = ((((_1726 * 2.0f) / (((-0.0f) - _1724) - sqrt((_1724 * _1724) - ((mad(_1720, 0.5f, mad(_1718, -1.0f, _1721)) * 4.0f) * _1726)))) + _1714) * 1.80618000030517578125f) + (-0.74472749233245849609375f);
      } else {
        frontier_phi_108_107_ladder_124_ladder = 4.673812389373779296875f;
      }
      frontier_phi_108_107_ladder = frontier_phi_108_107_ladder_124_ladder;
    }
    _1355 = frontier_phi_108_107_ladder;
  } else {
    _1355 = -5.2601776123046875f;
  }
  float _1359 = exp2(_1355 * 3.3219280242919921875f);
  float _1361 = log2(mad(_1135, 0.9977161884307861328125f, mad(_1133, -0.006032447330653667449951171875f, _1131 * 0.00831612758338451385498046875f))) * 0.3010300099849700927734375f;
  float _1483;
  if (_1361 > (-4.0f)) {
    float frontier_phi_126_125_ladder;
    if ((_1361 > (-4.0f)) && (_1361 <= 0.681241333484649658203125f)) {
      float _1744;
      float _1746;
      float _1748;
      float _1750;
      if (_1361 > (-3.578688144683837890625f)) {
        float frontier_phi_158_157_ladder;
        float frontier_phi_158_157_ladder_1;
        float frontier_phi_158_157_ladder_2;
        float frontier_phi_158_157_ladder_3;
        if ((_1361 > (-3.578688144683837890625f)) && (_1361 <= (-1.82131326198577880859375f))) {
          frontier_phi_158_157_ladder = -0.485249996185302734375f;
          frontier_phi_158_157_ladder_1 = 1.0f;
          frontier_phi_158_157_ladder_2 = -4.0f;
          frontier_phi_158_157_ladder_3 = -3.1573765277862548828125f;
        } else {
          bool _1796 = (_1361 > (-1.82131326198577880859375f)) && (_1361 <= 0.681241214275360107421875f);
          frontier_phi_158_157_ladder = _1796 ? 1.84773242473602294921875f : 0.0f;
          frontier_phi_158_157_ladder_1 = _1796 ? 2.0f : 0.0f;
          frontier_phi_158_157_ladder_2 = _1796 ? (-3.1573765277862548828125f) : 0.0f;
          frontier_phi_158_157_ladder_3 = _1796 ? (-0.485249996185302734375f) : 0.0f;
        }
        _1744 = frontier_phi_158_157_ladder_1;
        _1746 = frontier_phi_158_157_ladder_2;
        _1748 = frontier_phi_158_157_ladder_3;
        _1750 = frontier_phi_158_157_ladder;
      } else {
        _1744 = 0.0f;
        _1746 = -4.0f;
        _1748 = -4.0f;
        _1750 = -3.1573765277862548828125f;
      }
      float _1752 = _1746 * 0.5f;
      float _1755 = _1748 - _1746;
      float _1757 = mad(_1748, 0.5f, _1752) - _1361;
      frontier_phi_126_125_ladder = ((((_1757 * 2.0f) / (((-0.0f) - _1755) - sqrt((_1755 * _1755) - ((mad(_1750, 0.5f, mad(_1748, -1.0f, _1752)) * 4.0f) * _1757)))) + _1744) * 1.50514996051788330078125f) + (-5.2601776123046875f);
    } else {
      float frontier_phi_126_125_ladder_143_ladder;
      if ((_1361 > 0.681241333484649658203125f) && (_1361 < 4.0f)) {
        float _1797;
        float _1799;
        float _1801;
        float _1803;
        if ((_1361 > 0.68124115467071533203125f) && (_1361 <= 2.87457752227783203125f)) {
          _1797 = 0.0f;
          _1799 = -0.718548238277435302734375f;
          _1801 = 2.0810306072235107421875f;
          _1803 = 3.66812419891357421875f;
        } else {
          float frontier_phi_169_170_ladder;
          float frontier_phi_169_170_ladder_1;
          float frontier_phi_169_170_ladder_2;
          float frontier_phi_169_170_ladder_3;
          if ((_1361 > 2.87457752227783203125f) && (_1361 <= 3.834062099456787109375f)) {
            frontier_phi_169_170_ladder = 4.0f;
            frontier_phi_169_170_ladder_1 = 3.66812419891357421875f;
            frontier_phi_169_170_ladder_2 = 2.0810306072235107421875f;
            frontier_phi_169_170_ladder_3 = 1.0f;
          } else {
            bool _1843 = (_1361 > 3.834062099456787109375f) && (_1361 <= 4.0f);
            float _1802 = _1843 ? 4.0f : 0.0f;
            frontier_phi_169_170_ladder = _1802;
            frontier_phi_169_170_ladder_1 = _1802;
            frontier_phi_169_170_ladder_2 = _1843 ? 3.66812419891357421875f : 0.0f;
            frontier_phi_169_170_ladder_3 = _1843 ? 2.0f : 0.0f;
          }
          _1797 = frontier_phi_169_170_ladder_3;
          _1799 = frontier_phi_169_170_ladder_2;
          _1801 = frontier_phi_169_170_ladder_1;
          _1803 = frontier_phi_169_170_ladder;
        }
        float _1804 = _1799 * 0.5f;
        float _1807 = _1801 - _1799;
        float _1809 = mad(_1801, 0.5f, _1804) - _1361;
        frontier_phi_126_125_ladder_143_ladder = ((((_1809 * 2.0f) / (((-0.0f) - _1807) - sqrt((_1807 * _1807) - ((mad(_1803, 0.5f, mad(_1801, -1.0f, _1804)) * 4.0f) * _1809)))) + _1797) * 1.80618000030517578125f) + (-0.74472749233245849609375f);
      } else {
        frontier_phi_126_125_ladder_143_ladder = 4.673812389373779296875f;
      }
      frontier_phi_126_125_ladder = frontier_phi_126_125_ladder_143_ladder;
    }
    _1483 = frontier_phi_126_125_ladder;
  } else {
    _1483 = -5.2601776123046875f;
  }
  float _1487 = exp2(_1483 * 3.3219280242919921875f);
  float _1508 = max(0.0f, min(mad(_1487, -0.00223706453107297420501708984375f, mad(_1359, -0.0280867479741573333740234375f, _1260 * 1.03032386302947998046875f)), 65504.0f));
  float _1510 = max(0.0f, min(mad(_1487, -0.00223706476390361785888671875f, mad(_1359, 1.01357996463775634765625f, _1260 * (-0.011342871002852916717529296875f))), 65504.0f));
  float _1512 = max(0.0f, min(mad(_1487, 1.03942966461181640625f, mad(_1359, -0.0280867516994476318359375f, _1260 * (-0.0113428719341754913330078125f))), 65504.0f));
  float _1523 = max(0.0f, min(mad(_1512, 0.16386906802654266357421875f, mad(_1510, 0.14067865908145904541015625f, _1508 * 0.695452213287353515625f)), 65504.0f));
  float _1525 = max(0.0f, min(mad(_1512, 0.095534317195415496826171875f, mad(_1510, 0.85967099666595458984375f, _1508 * 0.044794581830501556396484375f)), 65504.0f));
  float _1527 = max(0.0f, min(mad(_1512, 1.00150072574615478515625f, mad(_1510, 0.00402521155774593353271484375f, _1508 * (-0.0055258679203689098358154296875f))), 65504.0f));
  float _1649;
  if ((_1523 == _1525) && (_1525 == _1527)) {
    _1649 = asfloat(0xffc10000u /* nan */);
  } else {
    float _1660 = ((_1523 * 2.0f) - _1525) - _1527;
    float _1662 = (_1525 - _1527) * 1.73205077648162841796875f;
    float _1665 = atan(_1662 / _1660);
    bool _1670 = _1660 < 0.0f;
    bool _1671 = _1660 == 0.0f;
    bool _1672 = _1662 >= 0.0f;
    bool _1673 = _1662 < 0.0f;
    _1649 = (_1671 && _1672) ? 90.0f : ((_1671 && _1673) ? (-90.0f) : (((_1670 && _1673) ? (_1665 + (-3.1415927410125732421875f)) : ((_1670 && _1672) ? (_1665 + 3.1415927410125732421875f) : _1665)) * 57.2957763671875f));
  }
  float _1655 = (_1649 < 0.0f) ? (_1649 + 360.0f) : _1649;
  float _1824;
  if (_1655 < (-180.0f)) {
    _1824 = _1655 + 360.0f;
  } else {
    float frontier_phi_171_161_ladder;
    if (_1655 > 180.0f) {
      frontier_phi_171_161_ladder = _1655 + (-360.0f);
    } else {
      frontier_phi_171_161_ladder = _1655;
    }
    _1824 = frontier_phi_171_161_ladder;
  }
  float _1854;
  if ((_1824 > (-67.5f)) && (_1824 < 67.5f)) {
    float _1845 = (_1824 + 67.5f) * 0.0296296291053295135498046875f;
    uint _1847 = uint(int(_1845));
    float _1849 = _1845 - float(int(_1847));
    float _1850 = _1849 * _1849;
    float _1851 = _1850 * _1849;
    float frontier_phi_178_177_ladder;
    if (_1847 == 3u) {
      frontier_phi_178_177_ladder = ((0.16666667163372039794921875f - (_1849 * 0.5f)) + (_1850 * 0.5f)) - (_1851 * 0.16666667163372039794921875f);
    } else {
      float frontier_phi_178_177_ladder_181_ladder;
      if (_1847 == 2u) {
        frontier_phi_178_177_ladder_181_ladder = (0.666666686534881591796875f - _1850) + (_1851 * 0.5f);
      } else {
        float frontier_phi_178_177_ladder_181_ladder_185_ladder;
        if (_1847 == 1u) {
          frontier_phi_178_177_ladder_181_ladder_185_ladder = ((_1851 * (-0.5f)) + 0.16666667163372039794921875f) + ((_1850 + _1849) * 0.5f);
        } else {
          frontier_phi_178_177_ladder_181_ladder_185_ladder = (_1847 == 0u) ? (_1851 * 0.16666667163372039794921875f) : 0.0f;
        }
        frontier_phi_178_177_ladder_181_ladder = frontier_phi_178_177_ladder_181_ladder_185_ladder;
      }
      frontier_phi_178_177_ladder = frontier_phi_178_177_ladder_181_ladder;
    }
    _1854 = frontier_phi_178_177_ladder;
  } else {
    _1854 = 0.0f;
  }
  float _1860 = (_1824 < 0.0f) ? _1525 : _1527;
  float _1866 = _1523 - (((_1860 + 0.02999999932944774627685546875f) * 0.2700000107288360595703125f) * _1854);
  float _1883 = (((-0.0f) - sqrt((_1866 * _1866) - (((_1860 * 0.008100000210106372833251953125f) * _1854) * ((_1854 * 1.08000004291534423828125f) + (-4.0f))))) - _1866) / ((_1854 * 0.540000021457672119140625f) + (-2.0f));
  float _1885 = max(_1883, max(_1525, _1527));
  float _1908 = ((_1527 + _1525) + _1883) + (sqrt(max((((_1525 - _1883) * _1525) + ((_1527 - _1525) * _1527)) + ((_1883 - _1527) * _1883), 0.0f)) * 1.75f);
  float _1909 = _1908 * 0.3333333432674407958984375f;
  float _1911 = ((max(_1885, 1.0000000133514319600180897396058e-10f) - max(min(_1883, min(_1525, _1527)), 1.0000000133514319600180897396058e-10f)) / max(_1885, 0.00999999977648258209228515625f)) + (-0.4000000059604644775390625f);
  float _1913 = _1911 * 5.0f;
  float _1918 = max(1.0f - abs(_1911 * 2.5f), 0.0f);
  float _1930;
  if (_1913 < 0.0f) {
    _1930 = -1.0f;
  } else {
    float frontier_phi_182_183_ladder;
    if (_1913 > 0.0f) {
      frontier_phi_182_183_ladder = 1.0f;
    } else {
      frontier_phi_182_183_ladder = 0.0f;
    }
    _1930 = frontier_phi_182_183_ladder;
  }
  float _1934 = (_1930 * (1.0f - (_1918 * _1918))) + 1.0f;
  float _1935 = _1934 * 0.02500000037252902984619140625f;
  float _1967;
  if (_1909 > ((_1934 * 0.00133333331905305385589599609375f) + 0.053333334624767303466796875f)) {
    float frontier_phi_192_186_ladder;
    if (_1909 < 0.1599999964237213134765625f) {
      frontier_phi_192_186_ladder = (((0.23999999463558197021484375f / _1908) + (-0.5f)) * _1935) / ((_1934 * 0.012500000186264514923095703125f) + (-1.0f));
    } else {
      frontier_phi_192_186_ladder = 0.0f;
    }
    _1967 = frontier_phi_192_186_ladder;
  } else {
    _1967 = ((-0.0f) - _1935) / (_1935 + 1.0f);
  }
  float _1968 = _1967 + 1.0f;
  float _1969 = _1968 * _1883;
  float _1970 = _1968 * _1525;
  float _1971 = _1968 * _1527;
  float _1991 = _15_m0[4u].x * (mad(_1971, -0.21492855250835418701171875f, mad(_1970, -0.2365107238292694091796875f, _1969 * 1.451439380645751953125f)) / _15_m0[9u].x);
  float _1992 = _15_m0[4u].x * (mad(_1971, -0.099675945937633514404296875f, mad(_1970, 1.176229953765869140625f, _1969 * (-0.076553761959075927734375f))) / _15_m0[9u].x);
  float _1993 = _15_m0[4u].x * (mad(_1971, 0.9977161884307861328125f, mad(_1970, -0.006032447330653667449951171875f, _1969 * 0.00831612758338451385498046875f)) / _15_m0[9u].x);
  float _1999 = mad(_1993, 0.16386906802654266357421875f, mad(_1992, 0.14067865908145904541015625f, _1991 * 0.695452213287353515625f));
  float _2002 = mad(_1993, 0.095534317195415496826171875f, mad(_1992, 0.85967099666595458984375f, _1991 * 0.044794581830501556396484375f));
  float _2005 = mad(_1993, 1.00150072574615478515625f, mad(_1992, 0.00402521155774593353271484375f, _1991 * (-0.0055258679203689098358154296875f)));
  float _2007 = max(_1999, max(_2002, _2005));
  float _2014 = (max(_2007, 1.0000000133514319600180897396058e-10f) - max(min(_1999, min(_2002, _2005)), 1.0000000133514319600180897396058e-10f)) / max(_2007, 0.00999999977648258209228515625f);
  float _2028 = ((_2002 + _1999) + _2005) + (sqrt(max((((_2005 - _2002) * _2005) + ((_2002 - _1999) * _2002)) + ((_1999 - _2005) * _1999), 0.0f)) * 1.75f);
  float _2029 = _2028 * 0.3333333432674407958984375f;
  float _2030 = _2014 + (-0.4000000059604644775390625f);
  float _2031 = _2030 * 5.0f;
  float _2035 = max(1.0f - abs(_2030 * 2.5f), 0.0f);
  float _2037;
  if (_2031 < 0.0f) {
    _2037 = -1.0f;
  } else {
    float frontier_phi_193_194_ladder;
    if (_2031 > 0.0f) {
      frontier_phi_193_194_ladder = 1.0f;
    } else {
      frontier_phi_193_194_ladder = 0.0f;
    }
    _2037 = frontier_phi_193_194_ladder;
  }
  float _2042 = ((_2037 * (1.0f - (_2035 * _2035))) + 1.0f) * 0.02500000037252902984619140625f;
  float _2046;
  if (_2029 > 0.053333334624767303466796875f) {
    float frontier_phi_196_195_ladder;
    if (_2029 < 0.1599999964237213134765625f) {
      frontier_phi_196_195_ladder = ((0.23999999463558197021484375f / _2028) + (-0.5f)) * _2042;
    } else {
      frontier_phi_196_195_ladder = 0.0f;
    }
    _2046 = frontier_phi_196_195_ladder;
  } else {
    _2046 = _2042;
  }
  float _2048 = _2046 + 1.0f;
  float _2049 = _2048 * _1999;
  float _2050 = _2048 * _2002;
  float _2051 = _2048 * _2005;
  float _2057;
  if ((_2049 == _2050) && (_2050 == _2051)) {
    _2057 = asfloat(0xffc10000u /* nan */);
  } else {
    float _2065 = ((_2049 * 2.0f) - _2050) - _2051;
    float _2068 = ((_2002 - _2005) * 1.73205077648162841796875f) * _2048;
    float _2070 = atan(_2068 / _2065);
    bool _2073 = _2065 < 0.0f;
    bool _2074 = _2065 == 0.0f;
    bool _2075 = _2068 >= 0.0f;
    bool _2076 = _2068 < 0.0f;
    _2057 = (_2075 && _2074) ? 90.0f : ((_2076 && _2074) ? (-90.0f) : (((_2076 && _2073) ? (_2070 + (-3.1415927410125732421875f)) : ((_2075 && _2073) ? (_2070 + 3.1415927410125732421875f) : _2070)) * 57.2957763671875f));
  }
  float _2061 = (_2057 < 0.0f) ? (_2057 + 360.0f) : _2057;
  float _2087;
  if (_2061 < (-180.0f)) {
    _2087 = _2061 + 360.0f;
  } else {
    float frontier_phi_203_202_ladder;
    if (_2061 > 180.0f) {
      frontier_phi_203_202_ladder = _2061 + (-360.0f);
    } else {
      frontier_phi_203_202_ladder = _2061;
    }
    _2087 = frontier_phi_203_202_ladder;
  }
  float _2100;
  if ((_2087 > (-67.5f)) && (_2087 < 67.5f)) {
    float _2093 = (_2087 + 67.5f) * 0.0296296291053295135498046875f;
    uint _2094 = uint(int(_2093));
    float _2096 = _2093 - float(int(_2094));
    float _2097 = _2096 * _2096;
    float _2098 = _2097 * _2096;
    float frontier_phi_206_205_ladder;
    if (_2094 == 3u) {
      frontier_phi_206_205_ladder = ((0.16666667163372039794921875f - (_2096 * 0.5f)) + (_2097 * 0.5f)) - (_2098 * 0.16666667163372039794921875f);
    } else {
      float frontier_phi_206_205_ladder_208_ladder;
      if (_2094 == 2u) {
        frontier_phi_206_205_ladder_208_ladder = (0.666666686534881591796875f - _2097) + (_2098 * 0.5f);
      } else {
        float frontier_phi_206_205_ladder_208_ladder_212_ladder;
        if (_2094 == 1u) {
          frontier_phi_206_205_ladder_208_ladder_212_ladder = ((_2098 * (-0.5f)) + 0.16666667163372039794921875f) + ((_2097 + _2096) * 0.5f);
        } else {
          frontier_phi_206_205_ladder_208_ladder_212_ladder = (_2094 == 0u) ? (_2098 * 0.16666667163372039794921875f) : 0.0f;
        }
        frontier_phi_206_205_ladder_208_ladder = frontier_phi_206_205_ladder_208_ladder_212_ladder;
      }
      frontier_phi_206_205_ladder = frontier_phi_206_205_ladder_208_ladder;
    }
    _2100 = frontier_phi_206_205_ladder;
  } else {
    _2100 = 0.0f;
  }
  float _2111 = max(0.0f, min((((_2014 * 0.2700000107288360595703125f) * (0.02999999932944774627685546875f - _2049)) * _2100) + _2049, 65520.0f));
  float _2113 = max(0.0f, min(_2050, 65520.0f));
  float _2115 = max(0.0f, min(_2051, 65520.0f));
  float _2126 = max(0.0f, min(mad(_2115, -0.21492855250835418701171875f, mad(_2113, -0.2365107238292694091796875f, _2111 * 1.451439380645751953125f)), 65504.0f));
  float _2128 = max(0.0f, min(mad(_2115, -0.099675945937633514404296875f, mad(_2113, 1.176229953765869140625f, _2111 * (-0.076553761959075927734375f))), 65504.0f));
  float _2130 = max(0.0f, min(mad(_2115, 0.9977161884307861328125f, mad(_2113, -0.006032447330653667449951171875f, _2111 * 0.00831612758338451385498046875f)), 65504.0f));
  float _2137 = _2126 * 0.01088915579020977020263671875f;
  float _2146 = log2(max(mad(_2130, 0.0021475818939507007598876953125f, mad(_2128, 0.02696327865123748779296875f, _2126 * 0.970889151096343994140625f)), 5.9604644775390625e-08f));
  float _2147 = _2146 * 0.3010300099849700927734375f;
  float _2158;
  if (_2147 > (-5.2601776123046875f)) {
    float frontier_phi_210_209_ladder;
    if ((_2147 > (-5.2601776123046875f)) && (_2147 < (-0.74472749233245849609375f))) {
      float _2171 = (_2146 * 0.199999988079071044921875f) + 3.49478626251220703125f;
      uint _2172 = uint(int(_2171));
      float _2174 = _2171 - float(int(_2172));
      uint _2177 = _2172 + 1u;
      float _2184 = _22[_2172] * 0.5f;
      frontier_phi_210_209_ladder = dot(float3(_2174 * _2174, _2174, 1.0f), float3(mad(_22[_2172 + 2u], 0.5f, mad(_22[_2177], -1.0f, _2184)), _22[_2177] - _22[_2172], mad(_22[_2177], 0.5f, _2184)));
    } else {
      float frontier_phi_210_209_ladder_214_ladder;
      if ((_2147 >= (-0.74472749233245849609375f)) && (_2147 < 4.673812389373779296875f)) {
        float _2213 = (_2146 * 0.1666666567325592041015625f) + 0.4123218357563018798828125f;
        uint _2214 = uint(int(_2213));
        float _2216 = _2213 - float(int(_2214));
        uint _2219 = _2214 + 1u;
        float _2226 = _29[_2214] * 0.5f;
        frontier_phi_210_209_ladder_214_ladder = dot(float3(_2216 * _2216, _2216, 1.0f), float3(mad(_29[_2214 + 2u], 0.5f, mad(_29[_2219], -1.0f, _2226)), _29[_2219] - _29[_2214], mad(_29[_2219], 0.5f, _2226)));
      } else {
        frontier_phi_210_209_ladder_214_ladder = 4.0f;
      }
      frontier_phi_210_209_ladder = frontier_phi_210_209_ladder_214_ladder;
    }
    _2158 = frontier_phi_210_209_ladder;
  } else {
    _2158 = -4.0f;
  }
  float _2162 = exp2(_2158 * 3.3219280242919921875f);
  float _2164 = log2(max(mad(_2130, 0.0021475818939507007598876953125f, mad(_2128, 0.9869632720947265625f, _2137)), 5.9604644775390625e-08f));
  float _2165 = _2164 * 0.3010300099849700927734375f;
  float _2197;
  if (_2165 > (-5.2601776123046875f)) {
    float frontier_phi_216_215_ladder;
    if ((_2165 > (-5.2601776123046875f)) && (_2165 < (-0.74472749233245849609375f))) {
      float _2234 = (_2164 * 0.199999988079071044921875f) + 3.49478626251220703125f;
      uint _2235 = uint(int(_2234));
      float _2237 = _2234 - float(int(_2235));
      uint _2240 = _2235 + 1u;
      float _2247 = _22[_2235] * 0.5f;
      frontier_phi_216_215_ladder = dot(float3(_2237 * _2237, _2237, 1.0f), float3(mad(_22[_2235 + 2u], 0.5f, mad(_22[_2240], -1.0f, _2247)), _22[_2240] - _22[_2235], mad(_22[_2240], 0.5f, _2247)));
    } else {
      float frontier_phi_216_215_ladder_221_ladder;
      if ((_2165 >= (-0.74472749233245849609375f)) && (_2165 < 4.673812389373779296875f)) {
        float _2289 = (_2164 * 0.1666666567325592041015625f) + 0.4123218357563018798828125f;
        uint _2290 = uint(int(_2289));
        float _2292 = _2289 - float(int(_2290));
        uint _2295 = _2290 + 1u;
        float _2302 = _29[_2290] * 0.5f;
        frontier_phi_216_215_ladder_221_ladder = dot(float3(_2292 * _2292, _2292, 1.0f), float3(mad(_29[_2290 + 2u], 0.5f, mad(_29[_2295], -1.0f, _2302)), _29[_2295] - _29[_2290], mad(_29[_2295], 0.5f, _2302)));
      } else {
        frontier_phi_216_215_ladder_221_ladder = 4.0f;
      }
      frontier_phi_216_215_ladder = frontier_phi_216_215_ladder_221_ladder;
    }
    _2197 = frontier_phi_216_215_ladder;
  } else {
    _2197 = -4.0f;
  }
  float _2201 = exp2(_2197 * 3.3219280242919921875f);
  float _2203 = log2(max(mad(_2130, 0.962147533893585205078125f, mad(_2128, 0.02696327865123748779296875f, _2137)), 5.9604644775390625e-08f));
  float _2204 = _2203 * 0.3010300099849700927734375f;
  float _2260;
  if (_2204 > (-5.2601776123046875f)) {
    float frontier_phi_223_222_ladder;
    if ((_2204 > (-5.2601776123046875f)) && (_2204 < (-0.74472749233245849609375f))) {
      float _2310 = (_2203 * 0.199999988079071044921875f) + 3.49478626251220703125f;
      uint _2311 = uint(int(_2310));
      float _2313 = _2310 - float(int(_2311));
      uint _2316 = _2311 + 1u;
      float _2323 = _22[_2311] * 0.5f;
      frontier_phi_223_222_ladder = dot(float3(_2313 * _2313, _2313, 1.0f), float3(mad(_22[_2311 + 2u], 0.5f, mad(_22[_2316], -1.0f, _2323)), _22[_2316] - _22[_2311], mad(_22[_2316], 0.5f, _2323)));
    } else {
      float frontier_phi_223_222_ladder_226_ladder;
      if ((_2204 >= (-0.74472749233245849609375f)) && (_2204 < 4.673812389373779296875f)) {
        float _2360 = (_2203 * 0.1666666567325592041015625f) + 0.4123218357563018798828125f;
        uint _2361 = uint(int(_2360));
        float _2363 = _2360 - float(int(_2361));
        uint _2366 = _2361 + 1u;
        float _2373 = _29[_2361] * 0.5f;
        frontier_phi_223_222_ladder_226_ladder = dot(float3(_2363 * _2363, _2363, 1.0f), float3(mad(_29[_2361 + 2u], 0.5f, mad(_29[_2366], -1.0f, _2373)), _29[_2366] - _29[_2361], mad(_29[_2366], 0.5f, _2373)));
      } else {
        frontier_phi_223_222_ladder_226_ladder = 4.0f;
      }
      frontier_phi_223_222_ladder = frontier_phi_223_222_ladder_226_ladder;
    }
    _2260 = frontier_phi_223_222_ladder;
  } else {
    _2260 = -4.0f;
  }
  float _2264 = exp2(_2260 * 3.3219280242919921875f);
  float _2267 = mad(_2264, 0.16386906802654266357421875f, mad(_2201, 0.14067865908145904541015625f, _2162 * 0.695452213287353515625f));
  float _2270 = mad(_2264, 0.095534317195415496826171875f, mad(_2201, 0.85967099666595458984375f, _2162 * 0.044794581830501556396484375f));
  float _2273 = mad(_2264, 1.00150072574615478515625f, mad(_2201, 0.00402521155774593353271484375f, _2162 * (-0.0055258679203689098358154296875f)));
  float _2281 = mad(_2273, -0.21492855250835418701171875f, mad(_2270, -0.2365107238292694091796875f, _2267 * 1.451439380645751953125f));
  float _2284 = mad(_2273, -0.099675945937633514404296875f, mad(_2270, 1.176229953765869140625f, _2267 * (-0.076553761959075927734375f)));
  float _2287 = mad(_2273, 0.9977161884307861328125f, mad(_2270, -0.006032447330653667449951171875f, _2267 * 0.00831612758338451385498046875f));
  float _3295;
  float _3296;
  float _3297;
  if (asuint(_15_m0[3u]).x == 0u) {
    float _2334 = log2(max(_2281, 5.9604644775390625e-08f));
    float _2335 = _2334 * 0.3010300099849700927734375f;
    float _2383;
    if (_2335 > (-2.54062366485595703125f)) {
      float frontier_phi_231_230_ladder;
      if ((_2335 > (-2.54062366485595703125f)) && (_2335 < 0.68124115467071533203125f)) {
        float _2396 = (_2334 + 8.43976879119873046875f) * 0.654034316539764404296875f;
        uint _2398 = uint(int(_2396));
        float _2400 = _2396 - float(int(_2398));
        uint _2403 = _2398 + 1u;
        float _2410 = _41[_2398] * 0.5f;
        frontier_phi_231_230_ladder = dot(float3(_2400 * _2400, _2400, 1.0f), float3(mad(_41[_2398 + 2u], 0.5f, mad(_41[_2403], -1.0f, _2410)), _41[_2403] - _41[_2398], mad(_41[_2403], 0.5f, _2410)));
      } else {
        float frontier_phi_231_230_ladder_235_ladder;
        if ((_2335 >= 0.68124115467071533203125f) && (_2335 < 3.00247669219970703125f)) {
          float _2456 = (_2334 + (-2.2630341053009033203125f)) * 0.90779674053192138671875f;
          uint _2458 = uint(int(_2456));
          float _2460 = _2456 - float(int(_2458));
          uint _2463 = _2458 + 1u;
          float _2470 = _53[_2458] * 0.5f;
          frontier_phi_231_230_ladder_235_ladder = dot(float3(_2460 * _2460, _2460, 1.0f), float3(mad(_53[_2458 + 2u], 0.5f, mad(_53[_2463], -1.0f, _2470)), _53[_2463] - _53[_2458], mad(_53[_2463], 0.5f, _2470)));
        } else {
          frontier_phi_231_230_ladder_235_ladder = (_2334 * 0.0120411999523639678955078125f) + 1.5611422061920166015625f;
        }
        frontier_phi_231_230_ladder = frontier_phi_231_230_ladder_235_ladder;
      }
      _2383 = frontier_phi_231_230_ladder;
    } else {
      _2383 = -1.6989700794219970703125f;
    }
    float _2390 = log2(max(_2284, 5.9604644775390625e-08f));
    float _2391 = _2390 * 0.3010300099849700927734375f;
    float _2423;
    if (_2391 > (-2.54062366485595703125f)) {
      float frontier_phi_237_236_ladder;
      if ((_2391 > (-2.54062366485595703125f)) && (_2391 < 0.68124115467071533203125f)) {
        float _2481 = (_2390 + 8.43976879119873046875f) * 0.654034316539764404296875f;
        uint _2482 = uint(int(_2481));
        float _2484 = _2481 - float(int(_2482));
        uint _2487 = _2482 + 1u;
        float _2494 = _41[_2482] * 0.5f;
        frontier_phi_237_236_ladder = dot(float3(_2484 * _2484, _2484, 1.0f), float3(mad(_41[_2482 + 2u], 0.5f, mad(_41[_2487], -1.0f, _2494)), _41[_2487] - _41[_2482], mad(_41[_2487], 0.5f, _2494)));
      } else {
        float frontier_phi_237_236_ladder_244_ladder;
        if ((_2391 >= 0.68124115467071533203125f) && (_2391 < 3.00247669219970703125f)) {
          float _2641 = (_2390 + (-2.2630341053009033203125f)) * 0.90779674053192138671875f;
          uint _2642 = uint(int(_2641));
          float _2644 = _2641 - float(int(_2642));
          uint _2647 = _2642 + 1u;
          float _2654 = _53[_2642] * 0.5f;
          frontier_phi_237_236_ladder_244_ladder = dot(float3(_2644 * _2644, _2644, 1.0f), float3(mad(_53[_2642 + 2u], 0.5f, mad(_53[_2647], -1.0f, _2654)), _53[_2647] - _53[_2642], mad(_53[_2647], 0.5f, _2654)));
        } else {
          frontier_phi_237_236_ladder_244_ladder = (_2390 * 0.0120411999523639678955078125f) + 1.5611422061920166015625f;
        }
        frontier_phi_237_236_ladder = frontier_phi_237_236_ladder_244_ladder;
      }
      _2423 = frontier_phi_237_236_ladder;
    } else {
      _2423 = -1.6989700794219970703125f;
    }
    float _2430 = log2(max(_2287, 5.9604644775390625e-08f));
    float _2431 = _2430 * 0.3010300099849700927734375f;
    float _2507;
    if (_2431 > (-2.54062366485595703125f)) {
      float frontier_phi_246_245_ladder;
      if ((_2431 > (-2.54062366485595703125f)) && (_2431 < 0.68124115467071533203125f)) {
        float _2663 = (_2430 + 8.43976879119873046875f) * 0.654034316539764404296875f;
        uint _2664 = uint(int(_2663));
        float _2666 = _2663 - float(int(_2664));
        uint _2669 = _2664 + 1u;
        float _2676 = _41[_2664] * 0.5f;
        frontier_phi_246_245_ladder = dot(float3(_2666 * _2666, _2666, 1.0f), float3(mad(_41[_2664 + 2u], 0.5f, mad(_41[_2669], -1.0f, _2676)), _41[_2669] - _41[_2664], mad(_41[_2669], 0.5f, _2676)));
      } else {
        float frontier_phi_246_245_ladder_254_ladder;
        if ((_2431 >= 0.68124115467071533203125f) && (_2431 < 3.00247669219970703125f)) {
          float _2906 = (_2430 + (-2.2630341053009033203125f)) * 0.90779674053192138671875f;
          uint _2907 = uint(int(_2906));
          float _2909 = _2906 - float(int(_2907));
          uint _2912 = _2907 + 1u;
          float _2919 = _53[_2907] * 0.5f;
          frontier_phi_246_245_ladder_254_ladder = dot(float3(_2909 * _2909, _2909, 1.0f), float3(mad(_53[_2907 + 2u], 0.5f, mad(_53[_2912], -1.0f, _2919)), _53[_2912] - _53[_2907], mad(_53[_2912], 0.5f, _2919)));
        } else {
          frontier_phi_246_245_ladder_254_ladder = (_2430 * 0.0120411999523639678955078125f) + 1.5611422061920166015625f;
        }
        frontier_phi_246_245_ladder = frontier_phi_246_245_ladder_254_ladder;
      }
      _2507 = frontier_phi_246_245_ladder;
    } else {
      _2507 = -1.6989700794219970703125f;
    }
    float _2513 = exp2(_2383 * 3.3219280242919921875f) + (-0.0199999995529651641845703125f);
    float _2516 = (exp2(_2423 * 3.3219280242919921875f) + (-0.0199999995529651641845703125f)) * 0.02084201760590076446533203125f;
    float _2519 = (exp2(_2507 * 3.3219280242919921875f) + (-0.0199999995529651641845703125f)) * 0.02084201760590076446533203125f;
    float _2523 = mad(_2519, 0.156187713146209716796875f, mad(_2516, 0.13400419056415557861328125f, _2513 * 0.0138068832457065582275390625f));
    float _2527 = mad(_2519, 0.0536895208060741424560546875f, mad(_2516, 0.674081623554229736328125f, _2513 * 0.0056737964041531085968017578125f));
    float _2533 = (_2527 + _2523) + mad(_2519, 1.01033914089202880859375f, mad(_2516, 0.0040607289411127567291259765625f, _2513 * (-0.00011618719145189970731735229492188f)));
    float _2535 = (_2533 == 0.0f) ? 1.0000000133514319600180897396058e-10f : _2533;
    float _2536 = _2523 / _2535;
    float _2537 = _2527 / _2535;
    float _2543 = exp2(log2(min(max(_2527, 0.0f), 65520.0f)) * 0.981100022792816162109375f);
    float _2545 = max(_2537, 1.0000000133514319600180897396058e-10f);
    float _2546 = (_2543 * _2536) / _2545;
    float _2550 = (_2543 * ((1.0f - _2536) - _2537)) / _2545;
    float _2553 = mad(_2550, -0.2364246845245361328125f, mad(_2543, -0.324803292751312255859375f, _2546 * 1.641023159027099609375f));
    float _2556 = mad(_2550, 0.01675636507570743560791015625f, mad(_2543, 1.61533200740814208984375f, _2546 * (-0.66366302967071533203125f)));
    float _2559 = mad(_2550, 0.98839473724365234375f, mad(_2543, -0.008284439332783222198486328125f, _2546 * 0.011721909977495670318603515625f));
    float _2564 = mad(_2559, 0.0037582661025226116180419921875f, mad(_2556, 0.0471857078373432159423828125f, _2553 * 0.94905602931976318359375f));
    float _2566 = _2553 * 0.0190560109913349151611328125f;
    float _2570 = mad(_2559, 0.0037582661025226116180419921875f, mad(_2556, 0.977185726165771484375f, _2566));
    float _2572 = mad(_2559, 0.933758258819580078125f, mad(_2556, 0.0471857078373432159423828125f, _2566));
    float _2576 = mad(_2572, 0.156187713146209716796875f, mad(_2570, 0.13400419056415557861328125f, _2564 * 0.66245424747467041015625f));
    float _2579 = mad(_2572, 0.0536895208060741424560546875f, mad(_2570, 0.674081623554229736328125f, _2564 * 0.2722287476062774658203125f));
    float _2582 = mad(_2572, 1.01033914089202880859375f, mad(_2570, 0.0040607289411127567291259765625f, _2564 * (-0.005574661307036876678466796875f)));
    float _2587 = mad(_2582, 0.0159532725811004638671875f, mad(_2579, -0.006113274954259395599365234375f, _2576 * 0.98722398281097412109375f));
    float _2593 = mad(_2582, 0.005330018699169158935546875f, mad(_2579, 1.00186145305633544921875f, _2576 * (-0.0075983591377735137939453125f)));
    float _2599 = mad(_2582, 1.08168041706085205078125f, mad(_2579, -0.005095951259136199951171875f, _2576 * 0.003072567284107208251953125f));
    float _2620 = max(0.0f, min(mad(_2599, -0.4986107349395751953125f, mad(_2593, -1.53738307952880859375f, _2587 * 3.24096965789794921875f)), 1.0f));
    float _2622 = max(0.0f, min(mad(_2599, 0.04155506193637847900390625f, mad(_2593, 1.87596714496612548828125f, _2587 * (-0.969243526458740234375f))), 1.0f));
    float _2624 = max(0.0f, min(mad(_2599, 1.0569717884063720703125f, mad(_2593, -0.2039768993854522705078125f, _2587 * 0.0556300543248653411865234375f)), 1.0f));
    float _2927;
    if (_2620 < 0.003039932809770107269287109375f) {
      _2927 = _2620 * 12.92321014404296875f;
    } else {
      _2927 = (exp2(log2(_2620) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _3062;
    if (_2622 < 0.003039932809770107269287109375f) {
      _3062 = _2622 * 12.92321014404296875f;
    } else {
      _3062 = (exp2(log2(_2622) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float frontier_phi_295_281_ladder;
    float frontier_phi_295_281_ladder_1;
    float frontier_phi_295_281_ladder_2;
    if (_2624 < 0.003039932809770107269287109375f) {
      frontier_phi_295_281_ladder = _3062;
      frontier_phi_295_281_ladder_1 = _2624 * 12.92321014404296875f;
      frontier_phi_295_281_ladder_2 = _2927;
    } else {
      frontier_phi_295_281_ladder = _3062;
      frontier_phi_295_281_ladder_1 = (exp2(log2(_2624) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
      frontier_phi_295_281_ladder_2 = _2927;
    }
    _3295 = frontier_phi_295_281_ladder_2;
    _3296 = frontier_phi_295_281_ladder;
    _3297 = frontier_phi_295_281_ladder_1;
  } else {
    float _70[9];
    _70[0u] = 0.0f;
    _70[1u] = 0.0f;
    _70[2u] = 0.0f;
    _70[3u] = 0.0f;
    _70[4u] = 0.0f;
    _70[5u] = 0.0f;
    _70[6u] = 0.0f;
    _70[7u] = 0.0f;
    _70[8u] = 0.0f;
    float _71[9];
    _71[0u] = 0.0f;
    _71[1u] = 0.0f;
    _71[2u] = 0.0f;
    _71[3u] = 0.0f;
    _71[4u] = 0.0f;
    _71[5u] = 0.0f;
    _71[6u] = 0.0f;
    _71[7u] = 0.0f;
    _71[8u] = 0.0f;
    float _2437;
    float _2441;
    float _2443;
    float _2445;
    float _2447;
    if (_15_m0[3u].w < 4000.0f) {
      float frontier_phi_240_232_ladder;
      float frontier_phi_240_232_ladder_1;
      float frontier_phi_240_232_ladder_2;
      float frontier_phi_240_232_ladder_3;
      float frontier_phi_240_232_ladder_4;
      if (_15_m0[3u].w < 48.0f) {
        _70[0u] = -1.69896996021270751953125f;
        _70[1u] = -1.69896996021270751953125f;
        _70[2u] = -1.477900028228759765625f;
        _70[3u] = -1.2290999889373779296875f;
        _70[4u] = -0.864799976348876953125f;
        _70[5u] = -0.448000013828277587890625f;
        _70[6u] = 0.0051799998618662357330322265625f;
        _70[7u] = 0.451108038425445556640625f;
        _70[8u] = 0.91137444972991943359375f;
        _71[0u] = 0.51543867588043212890625f;
        _71[1u] = 0.8470437526702880859375f;
        _71[2u] = 1.13580000400543212890625f;
        _71[3u] = 1.38020002841949462890625f;
        _71[4u] = 1.51970005035400390625f;
        _71[5u] = 1.5985000133514404296875f;
        _71[6u] = 1.64670002460479736328125f;
        _71[7u] = 1.67460918426513671875f;
        _71[8u] = 1.687873363494873046875f;
        frontier_phi_240_232_ladder = 48.0f;
        frontier_phi_240_232_ladder_1 = 0.039999999105930328369140625f;
        frontier_phi_240_232_ladder_2 = 0.0199999995529651641845703125f;
        frontier_phi_240_232_ladder_3 = 0.00287989364005625247955322265625f;
        frontier_phi_240_232_ladder_4 = 1005.71893310546875f;
      } else {
        float _2436 = log2(_15_m0[3u].w);
        float _2696;
        float _2697;
        float _2698;
        float _2699;
        float _2700;
        float _2701;
        float _2702;
        float _2703;
        float _2704;
        float _2705;
        float _2706;
        float _2707;
        float _2708;
        float _2709;
        float _2710;
        float _2711;
        float _2712;
        float _2713;
        float _2714;
        float _2715;
        float _2716;
        float _2717;
        float _2718;
        float _2719;
        float _2720;
        float _2721;
        float _2722;
        float _2723;
        float _2724;
        float _2725;
        float _2728;
        float _2729;
        float _2730;
        float _2731;
        float _2732;
        float _2735;
        if ((_15_m0[3u].w >= 2000.0f) && (_15_m0[3u].w < 4000.0f)) {
          _2696 = 12.19021511077880859375f;
          _2697 = 11.74135303497314453125f;
          _2698 = 10.5388164520263671875f;
          _2699 = 9.3608608245849609375f;
          _2700 = 8.0217914581298828125f;
          _2701 = 6.67973232269287109375f;
          _2702 = 5.34597873687744140625f;
          _2703 = 3.995220661163330078125f;
          _2704 = 2.6486351490020751953125f;
          _2705 = 4.289228916168212890625f;
          _2706 = 2.354627132415771484375f;
          _2707 = 0.39657175540924072265625f;
          _2708 = -1.55067598819732666015625f;
          _2709 = -3.513935565948486328125f;
          _2710 = -5.050991535186767578125f;
          _2711 = -6.415307521820068359375f;
          _2712 = -7.643855571746826171875f;
          _2713 = 11.05348491668701171875f;
          _2714 = 10.87808322906494140625f;
          _2715 = 10.13686370849609375f;
          _2716 = 9.19642543792724609375f;
          _2717 = 7.9005413055419921875f;
          _2718 = 6.63488674163818359375f;
          _2719 = 5.296149730682373046875f;
          _2720 = 3.97968578338623046875f;
          _2721 = 2.6641705036163330078125f;
          _2722 = -12.0f;
          _2723 = 11.0f;
          _2724 = 12.0f;
          _2725 = 0.300000011920928955078125f;
          _2728 = 0.119999997317790985107421875f;
          _2729 = 4000.0f;
          _2730 = 0.004999999888241291046142578125f;
          _2731 = 2000.0f;
          _2732 = clamp((_15_m0[3u].w + (-2000.0f)) * 0.0005000000237487256526947021484375f, 0.0f, 1.0f);
          _2735 = clamp(_2436 + (-10.9657840728759765625f), 0.0f, 1.0f);
        } else {
          float frontier_phi_257_248_ladder;
          float frontier_phi_257_248_ladder_1;
          float frontier_phi_257_248_ladder_2;
          float frontier_phi_257_248_ladder_3;
          float frontier_phi_257_248_ladder_4;
          float frontier_phi_257_248_ladder_5;
          float frontier_phi_257_248_ladder_6;
          float frontier_phi_257_248_ladder_7;
          float frontier_phi_257_248_ladder_8;
          float frontier_phi_257_248_ladder_9;
          float frontier_phi_257_248_ladder_10;
          float frontier_phi_257_248_ladder_11;
          float frontier_phi_257_248_ladder_12;
          float frontier_phi_257_248_ladder_13;
          float frontier_phi_257_248_ladder_14;
          float frontier_phi_257_248_ladder_15;
          float frontier_phi_257_248_ladder_16;
          float frontier_phi_257_248_ladder_17;
          float frontier_phi_257_248_ladder_18;
          float frontier_phi_257_248_ladder_19;
          float frontier_phi_257_248_ladder_20;
          float frontier_phi_257_248_ladder_21;
          float frontier_phi_257_248_ladder_22;
          float frontier_phi_257_248_ladder_23;
          float frontier_phi_257_248_ladder_24;
          float frontier_phi_257_248_ladder_25;
          float frontier_phi_257_248_ladder_26;
          float frontier_phi_257_248_ladder_27;
          float frontier_phi_257_248_ladder_28;
          float frontier_phi_257_248_ladder_29;
          float frontier_phi_257_248_ladder_30;
          float frontier_phi_257_248_ladder_31;
          float frontier_phi_257_248_ladder_32;
          float frontier_phi_257_248_ladder_33;
          float frontier_phi_257_248_ladder_34;
          float frontier_phi_257_248_ladder_35;
          if ((_15_m0[3u].w >= 1000.0f) && (_15_m0[3u].w < 2000.0f)) {
            frontier_phi_257_248_ladder = -1.55067598819732666015625f;
            frontier_phi_257_248_ladder_1 = 0.39657175540924072265625f;
            frontier_phi_257_248_ladder_2 = 4.289228916168212890625f;
            frontier_phi_257_248_ladder_3 = 2.354627132415771484375f;
            frontier_phi_257_248_ladder_4 = 10.87808322906494140625f;
            frontier_phi_257_248_ladder_5 = -3.513935565948486328125f;
            frontier_phi_257_248_ladder_6 = -5.050991535186767578125f;
            frontier_phi_257_248_ladder_7 = -6.415307521820068359375f;
            frontier_phi_257_248_ladder_8 = -7.643855571746826171875f;
            frontier_phi_257_248_ladder_9 = 10.0081024169921875f;
            frontier_phi_257_248_ladder_10 = 2.6641705036163330078125f;
            frontier_phi_257_248_ladder_11 = 3.97968578338623046875f;
            frontier_phi_257_248_ladder_12 = 5.296149730682373046875f;
            frontier_phi_257_248_ladder_13 = 6.63488674163818359375f;
            frontier_phi_257_248_ladder_14 = 7.9005413055419921875f;
            frontier_phi_257_248_ladder_15 = 9.19642543792724609375f;
            frontier_phi_257_248_ladder_16 = 10.13686370849609375f;
            frontier_phi_257_248_ladder_17 = 11.05348491668701171875f;
            frontier_phi_257_248_ladder_18 = clamp(_2436 + (-9.9657840728759765625f), 0.0f, 1.0f);
            frontier_phi_257_248_ladder_19 = 9.49905300140380859375f;
            frontier_phi_257_248_ladder_20 = 9.923465728759765625f;
            frontier_phi_257_248_ladder_21 = clamp((_15_m0[3u].w + (-1000.0f)) * 0.001000000047497451305389404296875f, 0.0f, 1.0f);
            frontier_phi_257_248_ladder_22 = 1000.0f;
            frontier_phi_257_248_ladder_23 = 0.004999999888241291046142578125f;
            frontier_phi_257_248_ladder_24 = 2000.0f;
            frontier_phi_257_248_ladder_25 = 0.0599999986588954925537109375f;
            frontier_phi_257_248_ladder_26 = 0.119999997317790985107421875f;
            frontier_phi_257_248_ladder_27 = 11.0f;
            frontier_phi_257_248_ladder_28 = -12.0f;
            frontier_phi_257_248_ladder_29 = 2.687151432037353515625f;
            frontier_phi_257_248_ladder_30 = 3.956704616546630859375f;
            frontier_phi_257_248_ladder_31 = 5.2097797393798828125f;
            frontier_phi_257_248_ladder_32 = 6.472112178802490234375f;
            frontier_phi_257_248_ladder_33 = 7.668006420135498046875f;
            frontier_phi_257_248_ladder_34 = 8.76457500457763671875f;
            frontier_phi_257_248_ladder_35 = 10.0f;
          } else {
            frontier_phi_257_248_ladder = -1.4882237911224365234375f;
            frontier_phi_257_248_ladder_1 = 0.01720758713781833648681640625f;
            frontier_phi_257_248_ladder_2 = 3.0275204181671142578125f;
            frontier_phi_257_248_ladder_3 = 1.49854838848114013671875f;
            frontier_phi_257_248_ladder_4 = 9.923465728759765625f;
            frontier_phi_257_248_ladder_5 = -2.872803211212158203125f;
            frontier_phi_257_248_ladder_6 = -4.082981586456298828125f;
            frontier_phi_257_248_ladder_7 = -4.909477710723876953125f;
            frontier_phi_257_248_ladder_8 = -5.643856048583984375f;
            frontier_phi_257_248_ladder_9 = 5.60699367523193359375f;
            frontier_phi_257_248_ladder_10 = 2.687151432037353515625f;
            frontier_phi_257_248_ladder_11 = 3.956704616546630859375f;
            frontier_phi_257_248_ladder_12 = 5.2097797393798828125f;
            frontier_phi_257_248_ladder_13 = 6.472112178802490234375f;
            frontier_phi_257_248_ladder_14 = 7.668006420135498046875f;
            frontier_phi_257_248_ladder_15 = 8.76457500457763671875f;
            frontier_phi_257_248_ladder_16 = 9.49905300140380859375f;
            frontier_phi_257_248_ladder_17 = 10.0081024169921875f;
            frontier_phi_257_248_ladder_18 = clamp((_2436 + (-5.584962368011474609375f)) * 0.22826768457889556884765625f, 0.0f, 1.0f);
            frontier_phi_257_248_ladder_19 = 5.470219135284423828125f;
            frontier_phi_257_248_ladder_20 = 5.562931060791015625f;
            frontier_phi_257_248_ladder_21 = clamp((_15_m0[3u].w + (-48.0f)) * 0.001050420221872627735137939453125f, 0.0f, 1.0f);
            frontier_phi_257_248_ladder_22 = 48.0f;
            frontier_phi_257_248_ladder_23 = 0.0199999995529651641845703125f;
            frontier_phi_257_248_ladder_24 = 1000.0f;
            frontier_phi_257_248_ladder_25 = 0.039999999105930328369140625f;
            frontier_phi_257_248_ladder_26 = 0.0599999986588954925537109375f;
            frontier_phi_257_248_ladder_27 = 10.0f;
            frontier_phi_257_248_ladder_28 = -6.5f;
            frontier_phi_257_248_ladder_29 = 1.712250232696533203125f;
            frontier_phi_257_248_ladder_30 = 2.813818454742431640625f;
            frontier_phi_257_248_ladder_31 = 3.7730457782745361328125f;
            frontier_phi_257_248_ladder_32 = 4.584925174713134765625f;
            frontier_phi_257_248_ladder_33 = 5.0483341217041015625f;
            frontier_phi_257_248_ladder_34 = 5.310101985931396484375f;
            frontier_phi_257_248_ladder_35 = 6.5f;
          }
          _2696 = frontier_phi_257_248_ladder_17;
          _2697 = frontier_phi_257_248_ladder_4;
          _2698 = frontier_phi_257_248_ladder_16;
          _2699 = frontier_phi_257_248_ladder_15;
          _2700 = frontier_phi_257_248_ladder_14;
          _2701 = frontier_phi_257_248_ladder_13;
          _2702 = frontier_phi_257_248_ladder_12;
          _2703 = frontier_phi_257_248_ladder_11;
          _2704 = frontier_phi_257_248_ladder_10;
          _2705 = frontier_phi_257_248_ladder_2;
          _2706 = frontier_phi_257_248_ladder_3;
          _2707 = frontier_phi_257_248_ladder_1;
          _2708 = frontier_phi_257_248_ladder;
          _2709 = frontier_phi_257_248_ladder_5;
          _2710 = frontier_phi_257_248_ladder_6;
          _2711 = frontier_phi_257_248_ladder_7;
          _2712 = frontier_phi_257_248_ladder_8;
          _2713 = frontier_phi_257_248_ladder_9;
          _2714 = frontier_phi_257_248_ladder_20;
          _2715 = frontier_phi_257_248_ladder_19;
          _2716 = frontier_phi_257_248_ladder_34;
          _2717 = frontier_phi_257_248_ladder_33;
          _2718 = frontier_phi_257_248_ladder_32;
          _2719 = frontier_phi_257_248_ladder_31;
          _2720 = frontier_phi_257_248_ladder_30;
          _2721 = frontier_phi_257_248_ladder_29;
          _2722 = frontier_phi_257_248_ladder_28;
          _2723 = frontier_phi_257_248_ladder_35;
          _2724 = frontier_phi_257_248_ladder_27;
          _2725 = frontier_phi_257_248_ladder_26;
          _2728 = frontier_phi_257_248_ladder_25;
          _2729 = frontier_phi_257_248_ladder_24;
          _2730 = frontier_phi_257_248_ladder_23;
          _2731 = frontier_phi_257_248_ladder_22;
          _2732 = frontier_phi_257_248_ladder_21;
          _2735 = frontier_phi_257_248_ladder_18;
        }
        float _2738 = exp2(_2712);
        float _2743 = log2(((0.0050000022165477275848388671875f - _2738) * _2732) + _2738) * 0.3010300099849700927734375f;
        _70[0u] = _2743;
        float _2745 = exp2(_2721);
        _71[0u] = log2(((exp2(_2704) - _2745) * _2732) + _2745) * 0.3010300099849700927734375f;
        _70[1u] = _2743;
        float _2752 = exp2(_2720);
        _71[1u] = log2(((exp2(_2703) - _2752) * _2732) + _2752) * 0.3010300099849700927734375f;
        float _2758 = exp2(_2711);
        _70[2u] = log2(((0.011716556735336780548095703125f - _2758) * _2732) + _2758) * 0.3010300099849700927734375f;
        float _2765 = exp2(_2719);
        _71[2u] = log2(((exp2(_2702) - _2765) * _2732) + _2765) * 0.3010300099849700927734375f;
        float _2771 = exp2(_2710);
        _70[3u] = log2(((0.030164770781993865966796875f - _2771) * _2732) + _2771) * 0.3010300099849700927734375f;
        float _2778 = exp2(_2718);
        _71[3u] = log2(((exp2(_2701) - _2778) * _2732) + _2778) * 0.3010300099849700927734375f;
        float _2784 = exp2(_2709);
        _70[4u] = log2(((0.087538681924343109130859375f - _2784) * _2732) + _2784) * 0.3010300099849700927734375f;
        float _2791 = exp2(_2717);
        _71[4u] = log2(((exp2(_2700) - _2791) * _2732) + _2791) * 0.3010300099849700927734375f;
        float _2797 = exp2(_2708);
        _70[5u] = log2(((0.341350078582763671875f - _2797) * _2732) + _2797) * 0.3010300099849700927734375f;
        float _2804 = exp2(_2716);
        _71[5u] = log2(((exp2(_2699) - _2804) * _2732) + _2804) * 0.3010300099849700927734375f;
        float _2810 = exp2(_2707);
        _70[6u] = log2(((1.31637609004974365234375f - _2810) * _2732) + _2810) * 0.3010300099849700927734375f;
        float _2817 = exp2(_2715);
        _71[6u] = log2(((exp2(_2698) - _2817) * _2732) + _2817) * 0.3010300099849700927734375f;
        float _2823 = exp2(_2706);
        _70[7u] = log2(((5.114620208740234375f - _2823) * _2732) + _2823) * 0.3010300099849700927734375f;
        float _2830 = exp2(_2714);
        _71[7u] = log2(((exp2(_2697) - _2830) * _2732) + _2830) * 0.3010300099849700927734375f;
        float _2836 = exp2(_2705);
        _70[8u] = log2(((19.551792144775390625f - _2836) * _2732) + _2836) * 0.3010300099849700927734375f;
        float _2843 = exp2(_2713);
        _71[8u] = log2(((exp2(_2696) - _2843) * _2732) + _2843) * 0.3010300099849700927734375f;
        float _2855 = log2(max(exp2((_2735 * ((-12.0f) - _2722)) + _2722) * 0.180000007152557373046875f, 5.9604644775390625e-08f));
        float _2856 = _2855 * 0.3010300099849700927734375f;
        float _2932;
        if (_2856 > (-5.2601776123046875f)) {
          float frontier_phi_267_266_ladder;
          if ((_2856 > (-5.2601776123046875f)) && (_2856 < (-0.74472749233245849609375f))) {
            float _2989 = (_2855 * 0.199999988079071044921875f) + 3.49478626251220703125f;
            uint _2990 = uint(int(_2989));
            float _2992 = _2989 - float(int(_2990));
            uint _2995 = _2990 + 1u;
            float _3002 = _22[_2990] * 0.5f;
            frontier_phi_267_266_ladder = dot(float3(_2992 * _2992, _2992, 1.0f), float3(mad(_22[_2990 + 2u], 0.5f, mad(_22[_2995], -1.0f, _3002)), _22[_2995] - _22[_2990], mad(_22[_2995], 0.5f, _3002)));
          } else {
            float frontier_phi_267_266_ladder_275_ladder;
            if ((_2856 >= (-0.74472749233245849609375f)) && (_2856 < 4.673812389373779296875f)) {
              float _3065 = (_2855 * 0.1666666567325592041015625f) + 0.4123218357563018798828125f;
              uint _3066 = uint(int(_3065));
              float _3068 = _3065 - float(int(_3066));
              uint _3071 = _3066 + 1u;
              float _3078 = _29[_3066] * 0.5f;
              frontier_phi_267_266_ladder_275_ladder = dot(float3(_3068 * _3068, _3068, 1.0f), float3(mad(_29[_3066 + 2u], 0.5f, mad(_29[_3071], -1.0f, _3078)), _29[_3071] - _29[_3066], mad(_29[_3071], 0.5f, _3078)));
            } else {
              frontier_phi_267_266_ladder_275_ladder = 4.0f;
            }
            frontier_phi_267_266_ladder = frontier_phi_267_266_ladder_275_ladder;
          }
          _2932 = frontier_phi_267_266_ladder;
        } else {
          _2932 = -4.0f;
        }
        float _2944 = log2(max(exp2((_2735 * (_2724 - _2723)) + _2723) * 0.180000007152557373046875f, 5.9604644775390625e-08f));
        float _2945 = _2944 * 0.3010300099849700927734375f;
        float _3015;
        if (_2945 > (-5.2601776123046875f)) {
          float frontier_phi_277_276_ladder;
          if ((_2945 > (-5.2601776123046875f)) && (_2945 < (-0.74472749233245849609375f))) {
            float _3086 = (_2944 * 0.199999988079071044921875f) + 3.49478626251220703125f;
            uint _3087 = uint(int(_3086));
            float _3089 = _3086 - float(int(_3087));
            uint _3092 = _3087 + 1u;
            float _3099 = _22[_3087] * 0.5f;
            frontier_phi_277_276_ladder = dot(float3(_3089 * _3089, _3089, 1.0f), float3(mad(_22[_3087 + 2u], 0.5f, mad(_22[_3092], -1.0f, _3099)), _22[_3092] - _22[_3087], mad(_22[_3092], 0.5f, _3099)));
          } else {
            float frontier_phi_277_276_ladder_284_ladder;
            if ((_2945 >= (-0.74472749233245849609375f)) && (_2945 < 4.673812389373779296875f)) {
              float _3151 = (_2944 * 0.1666666567325592041015625f) + 0.4123218357563018798828125f;
              uint _3152 = uint(int(_3151));
              float _3154 = _3151 - float(int(_3152));
              uint _3157 = _3152 + 1u;
              float _3164 = _29[_3152] * 0.5f;
              frontier_phi_277_276_ladder_284_ladder = dot(float3(_3154 * _3154, _3154, 1.0f), float3(mad(_29[_3152 + 2u], 0.5f, mad(_29[_3157], -1.0f, _3164)), _29[_3157] - _29[_3152], mad(_29[_3157], 0.5f, _3164)));
            } else {
              frontier_phi_277_276_ladder_284_ladder = 4.0f;
            }
            frontier_phi_277_276_ladder = frontier_phi_277_276_ladder_284_ladder;
          }
          _3015 = frontier_phi_277_276_ladder;
        } else {
          _3015 = -4.0f;
        }
        frontier_phi_240_232_ladder = (_2732 * (_2729 - _2731)) + _2731;
        frontier_phi_240_232_ladder_1 = (_2732 * (_2725 - _2728)) + _2728;
        frontier_phi_240_232_ladder_2 = (_2732 * (0.004999999888241291046142578125f - _2730)) + _2730;
        frontier_phi_240_232_ladder_3 = exp2(_2932 * 3.3219280242919921875f);
        frontier_phi_240_232_ladder_4 = exp2(_3015 * 3.3219280242919921875f);
      }
      _2437 = frontier_phi_240_232_ladder_1;
      _2441 = frontier_phi_240_232_ladder_2;
      _2443 = frontier_phi_240_232_ladder_3;
      _2445 = frontier_phi_240_232_ladder;
      _2447 = frontier_phi_240_232_ladder_4;
    } else {
      _70[0u] = -2.3010299205780029296875f;
      _70[1u] = -2.3010299205780029296875f;
      _70[2u] = -1.9312000274658203125f;
      _70[3u] = -1.5204999446868896484375f;
      _70[4u] = -1.0578000545501708984375f;
      _70[5u] = -0.4668000042438507080078125f;
      _70[6u] = 0.11937999725341796875f;
      _70[7u] = 0.7088134288787841796875f;
      _70[8u] = 1.2911865711212158203125f;
      _71[0u] = 0.797318637371063232421875f;
      _71[1u] = 1.2026813030242919921875f;
      _71[2u] = 1.60930001735687255859375f;
      _71[3u] = 2.010799884796142578125f;
      _71[4u] = 2.4147999286651611328125f;
      _71[5u] = 2.8178999423980712890625f;
      _71[6u] = 3.1724998950958251953125f;
      _71[7u] = 3.534499645233154296875f;
      _71[8u] = 3.669620513916015625f;
      _2437 = 0.300000011920928955078125f;
      _2441 = 0.004999999888241291046142578125f;
      _2443 = 0.00014179872232489287853240966796875f;
      _2445 = 4000.0f;
      _2447 = 6824.36376953125f;
    }
    float _2450 = log2(max(_2281, 5.9604644775390625e-08f));
    float _2451 = _2450 * 0.3010300099849700927734375f;
    float _2452 = log2(_2443);
    float _2453 = _2452 * 0.3010300099849700927734375f;
    float _2896;
    if (_2451 > _2453) {
      float frontier_phi_262_249_ladder;
      if ((_2451 < 0.68124115467071533203125f) && (_2451 > _2453)) {
        float _2870 = ((_2450 - _2452) * 2.1072101593017578125f) / ((2.2630341053009033203125f - _2452) * 0.3010300099849700927734375f);
        uint _2871 = uint(int(_2870));
        float _2873 = _2870 - float(int(_2871));
        uint _2876 = _2871 + 1u;
        float _2883 = _70[_2871] * 0.5f;
        frontier_phi_262_249_ladder = dot(float3(_2873 * _2873, _2873, 1.0f), float3(mad(_70[_2871 + 2u], 0.5f, mad(_70[_2876], -1.0f, _2883)), _70[_2876] - _70[_2871], mad(_70[_2876], 0.5f, _2883)));
      } else {
        float _2892 = log2(_2447);
        float frontier_phi_262_249_ladder_261_ladder;
        if ((_2451 >= 0.68124115467071533203125f) && (_2451 < (_2892 * 0.3010300099849700927734375f))) {
          float _2951 = ((_2450 + (-2.2630341053009033203125f)) * 2.1072101593017578125f) / ((_2892 + (-2.2630341053009033203125f)) * 0.3010300099849700927734375f);
          uint _2952 = uint(int(_2951));
          float _2954 = _2951 - float(int(_2952));
          uint _2957 = _2952 + 1u;
          float _2964 = _71[_2952] * 0.5f;
          frontier_phi_262_249_ladder_261_ladder = dot(float3(_2954 * _2954, _2954, 1.0f), float3(mad(_71[_2952 + 2u], 0.5f, mad(_71[_2957], -1.0f, _2964)), _71[_2957] - _71[_2952], mad(_71[_2957], 0.5f, _2964)));
        } else {
          frontier_phi_262_249_ladder_261_ladder = ((log2(_2445) * 0.3010300099849700927734375f) + (_2451 * _2437)) - ((_2437 * 0.3010300099849700927734375f) * _2892);
        }
        frontier_phi_262_249_ladder = frontier_phi_262_249_ladder_261_ladder;
      }
      _2896 = frontier_phi_262_249_ladder;
    } else {
      _2896 = log2(_2441) * 0.3010300099849700927734375f;
    }
    float _2902 = log2(max(_2284, 5.9604644775390625e-08f));
    float _2903 = _2902 * 0.3010300099849700927734375f;
    float _3053;
    if (_2903 > _2453) {
      float frontier_phi_280_270_ladder;
      if ((_2903 < 0.68124115467071533203125f) && (_2903 > _2453)) {
        float _3027 = ((_2902 - _2452) * 2.1072101593017578125f) / ((2.2630341053009033203125f - _2452) * 0.3010300099849700927734375f);
        uint _3028 = uint(int(_3027));
        float _3030 = _3027 - float(int(_3028));
        uint _3033 = _3028 + 1u;
        float _3040 = _70[_3028] * 0.5f;
        frontier_phi_280_270_ladder = dot(float3(_3030 * _3030, _3030, 1.0f), float3(mad(_70[_3028 + 2u], 0.5f, mad(_70[_3033], -1.0f, _3040)), _70[_3033] - _70[_3028], mad(_70[_3033], 0.5f, _3040)));
      } else {
        float _3049 = log2(_2447);
        float frontier_phi_280_270_ladder_279_ladder;
        if ((_2903 >= 0.68124115467071533203125f) && (_2903 < (_3049 * 0.3010300099849700927734375f))) {
          float _3113 = ((_2902 + (-2.2630341053009033203125f)) * 2.1072101593017578125f) / ((_3049 + (-2.2630341053009033203125f)) * 0.3010300099849700927734375f);
          uint _3114 = uint(int(_3113));
          float _3116 = _3113 - float(int(_3114));
          uint _3119 = _3114 + 1u;
          float _3126 = _71[_3114] * 0.5f;
          frontier_phi_280_270_ladder_279_ladder = dot(float3(_3116 * _3116, _3116, 1.0f), float3(mad(_71[_3114 + 2u], 0.5f, mad(_71[_3119], -1.0f, _3126)), _71[_3119] - _71[_3114], mad(_71[_3119], 0.5f, _3126)));
        } else {
          frontier_phi_280_270_ladder_279_ladder = ((log2(_2445) * 0.3010300099849700927734375f) + (_2903 * _2437)) - ((_2437 * 0.3010300099849700927734375f) * _3049);
        }
        frontier_phi_280_270_ladder = frontier_phi_280_270_ladder_279_ladder;
      }
      _3053 = frontier_phi_280_270_ladder;
    } else {
      _3053 = log2(_2441) * 0.3010300099849700927734375f;
    }
    float _3059 = log2(max(_2287, 5.9604644775390625e-08f));
    float _3060 = _3059 * 0.3010300099849700927734375f;
    float _3201;
    if (_3060 > _2453) {
      float frontier_phi_294_287_ladder;
      if ((_3060 < 0.68124115467071533203125f) && (_3060 > _2453)) {
        float _3175 = ((_3059 - _2452) * 2.1072101593017578125f) / ((2.2630341053009033203125f - _2452) * 0.3010300099849700927734375f);
        uint _3176 = uint(int(_3175));
        float _3178 = _3175 - float(int(_3176));
        uint _3181 = _3176 + 1u;
        float _3188 = _70[_3176] * 0.5f;
        frontier_phi_294_287_ladder = dot(float3(_3178 * _3178, _3178, 1.0f), float3(mad(_70[_3176 + 2u], 0.5f, mad(_70[_3181], -1.0f, _3188)), _70[_3181] - _70[_3176], mad(_70[_3181], 0.5f, _3188)));
      } else {
        float _3197 = log2(_2447);
        float frontier_phi_294_287_ladder_293_ladder;
        if ((_3060 >= 0.68124115467071533203125f) && (_3060 < (_3197 * 0.3010300099849700927734375f))) {
          float _3304 = ((_3059 + (-2.2630341053009033203125f)) * 2.1072101593017578125f) / ((_3197 + (-2.2630341053009033203125f)) * 0.3010300099849700927734375f);
          uint _3305 = uint(int(_3304));
          float _3307 = _3304 - float(int(_3305));
          uint _3310 = _3305 + 1u;
          float _3317 = _71[_3305] * 0.5f;
          frontier_phi_294_287_ladder_293_ladder = dot(float3(_3307 * _3307, _3307, 1.0f), float3(mad(_71[_3305 + 2u], 0.5f, mad(_71[_3310], -1.0f, _3317)), _71[_3310] - _71[_3305], mad(_71[_3310], 0.5f, _3317)));
        } else {
          frontier_phi_294_287_ladder_293_ladder = ((log2(_2445) * 0.3010300099849700927734375f) + (_3060 * _2437)) - ((_2437 * 0.3010300099849700927734375f) * _3197);
        }
        frontier_phi_294_287_ladder = frontier_phi_294_287_ladder_293_ladder;
      }
      _3201 = frontier_phi_294_287_ladder;
    } else {
      _3201 = log2(_2441) * 0.3010300099849700927734375f;
    }
    float _3206 = exp2(_2896 * 3.3219280242919921875f) + (-3.5073844628641381859779357910156e-05f);
    float _3208 = exp2(_3053 * 3.3219280242919921875f) + (-3.5073844628641381859779357910156e-05f);
    float _3209 = exp2(_3201 * 3.3219280242919921875f) + (-3.5073844628641381859779357910156e-05f);
    float _3212 = mad(_3209, 0.156187713146209716796875f, mad(_3208, 0.13400419056415557861328125f, _3206 * 0.66245424747467041015625f));
    float _3215 = mad(_3209, 0.0536895208060741424560546875f, mad(_3208, 0.674081623554229736328125f, _3206 * 0.2722287476062774658203125f));
    float _3218 = mad(_3209, 1.01033914089202880859375f, mad(_3208, 0.0040607289411127567291259765625f, _3206 * (-0.005574661307036876678466796875f)));
    float _3221 = mad(_3218, 0.0159532725811004638671875f, mad(_3215, -0.006113274954259395599365234375f, _3212 * 0.98722398281097412109375f));
    float _3224 = mad(_3218, 0.005330018699169158935546875f, mad(_3215, 1.00186145305633544921875f, _3212 * (-0.0075983591377735137939453125f)));
    float _3227 = mad(_3218, 1.08168041706085205078125f, mad(_3215, -0.005095951259136199951171875f, _3212 * 0.003072567284107208251953125f));
    float _3258 = exp2(log2(abs(max(0.0f, min(mad(_3227, -0.2533662319183349609375f, mad(_3224, -0.355670750141143798828125f, _3221 * 1.71665084362030029296875f)), 65520.0f)) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
    float _3273 = exp2(log2(abs(max(0.0f, min(mad(_3227, 0.0157685391604900360107421875f, mad(_3224, 1.61648142337799072265625f, _3221 * (-0.666684448719024658203125f))), 65520.0f)) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
    float _3286 = exp2(log2(abs(max(0.0f, min(mad(_3227, 0.942103207111358642578125f, mad(_3224, -0.04277060925960540771484375f, _3221 * 0.01763985492289066314697265625f)), 65520.0f)) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
    _3295 = exp2(log2(((_3258 * 18.8515625f) + 0.8359375f) / ((_3258 * 18.6875f) + 1.0f)) * 78.84375f);
    _3296 = exp2(log2(((_3273 * 18.8515625f) + 0.8359375f) / ((_3273 * 18.6875f) + 1.0f)) * 78.84375f);
    _3297 = exp2(log2(((_3286 * 18.8515625f) + 0.8359375f) / ((_3286 * 18.6875f) + 1.0f)) * 78.84375f);
  }
  _8[uint3(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y, gl_GlobalInvocationID.z)] = float4(_3295, _3296, _3297, 1.0f);
}

[numthreads(16, 16, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  comp_main();
}
