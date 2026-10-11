#include "../common.hlsli"

float3 EncodeUIForHDR(float _116, float _117, float _118, float4 HDROutput_016, float HDROutput_036, float HDROutput_064, float HDROutput_076, float HDROutput_084) {
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    float3 color = float3(_116, _117, _118);
    if (RENODX_SDR_EOTF_EMULATION_UI == 0.f) {
      color = renodx::color::srgb::EncodeSafe(color);
    } else {
      color = renodx::color::gamma::DecodeSafe(color);
    }
    color = renodx::color::bt2020::from::BT709(color);
    color = renodx::color::pq::EncodeSafe(color, RENODX_GRAPHICS_WHITE_NITS);
    return color;
  } else {
    float _153;
    float _154;
    float _155;
    float _156;
    float _164;
    float _165;
    float _169;
    float _170;
    float _171;
    float _187;
    float _194;
    float _201;
    float _210;
    float _214;
    float _223;
    float _227;
    float _236;
    float _245;
    float _246;
    float _247;
    float _248;
    float _274;
    float _275;
    float _276;

    _153 = saturate(select((_116 <= 0.040449999272823334f), (_116 * 0.07739938050508499f), exp2(log2(abs((_116 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _154 = saturate(select((_117 <= 0.040449999272823334f), (_117 * 0.07739938050508499f), exp2(log2(abs((_117 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _155 = saturate(select((_118 <= 0.040449999272823334f), (_118 * 0.07739938050508499f), exp2(log2(abs((_118 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f)));
    _156 = dot(float3(_153, _154, _155), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _164 = select((_156 > 0.5f), (((_156 * HDROutput_016.y) / (HDROutput_016.y - _156)) + HDROutput_016.x), (_156 / (1.000100016593933f - _156)));
    _165 = _156 + 9.999999747378752e-05f;
    _169 = _164 * (_153 / _165);
    _170 = (_154 / _165) * _164;
    _171 = (_155 / _165) * _164;
    _187 = saturate(max(max(_169, _170), _171) + -1.0f);

    _194 = HDROutput_064 * 9.999999747378752e-05f;
    _201 = exp2(log2(abs(_194 * (((1.0f - _187) * mad(0.04331360012292862f, _171, mad(0.3292819857597351f, _170, (_169 * 0.627403974533081f)))) + (_187 * mad(0.047561999410390854f, _171, mad(0.19859300553798676f, _170, (_169 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _210 = exp2(log2(abs(((_201 * 18.8515625f) + 0.8359375f) / ((_201 * 18.6875f) + 1.0f))) * 78.84375f);
    _214 = exp2(log2(abs(_194 * mad(0.012477199546992779f, _171, mad(0.9417769908905029f, _170, (_169 * 0.045745600014925f))))) * 0.1593017578125f);
    _223 = exp2(log2(abs(((_214 * 18.8515625f) + 0.8359375f) / ((_214 * 18.6875f) + 1.0f))) * 78.84375f);
    _227 = exp2(log2(abs(_194 * mad(0.9836069941520691f, _171, mad(0.017604099586606026f, _170, (_169 * -0.0012105499627068639f))))) * 0.1593017578125f);
    _236 = exp2(log2(abs(((_227 * 18.8515625f) + 0.8359375f) / ((_227 * 18.6875f) + 1.0f))) * 78.84375f);
    _245 = saturate(_210 / HDROutput_084);
    _246 = saturate(_223 / HDROutput_084);
    _247 = saturate(_236 / HDROutput_084);
    _248 = HDROutput_084 - HDROutput_036;
    _274 = select((_210 > HDROutput_076), _210, select((_210 < HDROutput_084), max((((_245 * _245) * _248) + HDROutput_036), _210), _210));
    _275 = select((_223 > HDROutput_076), _223, select((_223 < HDROutput_084), max((((_246 * _246) * _248) + HDROutput_036), _223), _223));
    _276 = select((_236 > HDROutput_076), _236, select((_236 < HDROutput_084), max((((_247 * _247) * _248) + HDROutput_036), _236), _236));
    return float3(_274, _275, _276);
  }
}
