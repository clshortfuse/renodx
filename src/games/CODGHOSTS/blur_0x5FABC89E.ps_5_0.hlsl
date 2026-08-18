    // ---- Created with 3Dmigoto v1.3.16 on Thu Aug 06 20:45:13 2026
    //
    // HDR-safe vanilla blur replacement with RenoDX blur-strength control.
    //
    // Blur Strength:
    //   0%   = unblurred source
    //   50%  = blend halfway between source and the original game blur
    //   100% = exact original game blur result
    //
    // The original blur kernel, tap offsets, supplied weights, zoom/DOF behavior,
    // HDR attenuation, and full-strength alpha behavior are left unchanged.
    // No kernel normalization, HDR peak restoration, saturate-to-SDR, or 1.0 clamp.

    #include "./shared.h"

    Texture2D<float4> t0 : register(t0);
    SamplerState s0_s : register(s0);

    cbuffer cb2 : register(b2)
    {
        float4 cb2[10];
    };

    // FP16 maximum finite value. Invalid/runaway values are discarded rather than
    // converted into a 65504 white pixel.
    static const float RENODX_FP16_MAX = 65504.0f;

    float SanitizeHDRChannel(float value)
    {
        if (value != value)
        {
            return 0.0f;
        }

        value = max(value, 0.0f);

        if (value >= RENODX_FP16_MAX)
        {
            return 0.0f;
        }

        return value;
    }

    float4 SanitizeHDRSample(float4 value)
    {
        value.rgb = float3(
            SanitizeHDRChannel(value.r),
            SanitizeHDRChannel(value.g),
            SanitizeHDRChannel(value.b)
        );

        return value;
    }

    float4 SampleHDR(float2 uv)
    {
        return SanitizeHDRSample(
            t0.Sample(s0_s, uv)
        );
    }

    float4 SanitizeBlurOutput(float4 value)
    {
        value.rgb = float3(
            SanitizeHDRChannel(value.r),
            SanitizeHDRChannel(value.g),
            SanitizeHDRChannel(value.b)
        );

        return value;
    }

    void main(
        float4 v0 : SV_POSITION0,
        float2 v1 : TEXCOORD0,
        out float4 o0 : SV_TARGET0)
    {
        float blurStrength = saturate(RENODX_BLUR_STRENGTH);

        // At 0%, bypass the entire blur kernel. Besides producing a truly sharp
        // result, this avoids all of the extra blur texture samples.
        [branch]
        if (blurStrength <= 0.000001f)
        {
            o0 = SampleHDR(v1);
            return;
        }

        float4 r0;
        float4 r1;
        float4 r2;
        float4 r3;
        float4 r4;

        // Tap group 0
        r0.xyzw = -cb2[0].zwxy + v1.xyxy;
        r1.xyzw = SampleHDR(r0.xy);
        r0.xyzw = SampleHDR(r0.zw);

        r2.xyzw = cb2[0].xyzw + v1.xyxy;
        r3.xyzw = SampleHDR(r2.zw);
        r2.xyzw = SampleHDR(r2.xy);

        r0.xyzw = r2.xyzw + r0.xyzw;
        r1.xyzw = r3.xyzw + r1.xyzw;

        r1.xyzw = cb2[8].yyyy * r1.xyzw;
        r0.xyzw = cb2[8].xxxx * r0.xyzw + r1.xyzw;

        // Tap group 1
        r1.xyzw = -cb2[1].zwxy + v1.xyxy;
        r2.xyzw = SampleHDR(r1.zw);
        r1.xyzw = SampleHDR(r1.xy);

        r3.xyzw = cb2[1].xyzw + v1.xyxy;
        r4.xyzw = SampleHDR(r3.xy);
        r3.xyzw = SampleHDR(r3.zw);

        r1.xyzw = r3.xyzw + r1.xyzw;
        r2.xyzw = r4.xyzw + r2.xyzw;

        r0.xyzw = cb2[8].zzzz * r2.xyzw + r0.xyzw;
        r0.xyzw = cb2[8].wwww * r1.xyzw + r0.xyzw;

        // Tap group 2
        r1.xyzw = -cb2[2].zwxy + v1.xyxy;
        r2.xyzw = SampleHDR(r1.zw);
        r1.xyzw = SampleHDR(r1.xy);

        r3.xyzw = cb2[2].xyzw + v1.xyxy;
        r4.xyzw = SampleHDR(r3.xy);
        r3.xyzw = SampleHDR(r3.zw);

        r1.xyzw = r3.xyzw + r1.xyzw;
        r2.xyzw = r4.xyzw + r2.xyzw;

        r0.xyzw = cb2[9].xxxx * r2.xyzw + r0.xyzw;
        r0.xyzw = cb2[9].yyyy * r1.xyzw + r0.xyzw;

        // Tap group 3
        r1.xyzw = -cb2[3].zwxy + v1.xyxy;
        r2.xyzw = SampleHDR(r1.zw);
        r1.xyzw = SampleHDR(r1.xy);

        r3.xyzw = cb2[3].xyzw + v1.xyxy;
        r4.xyzw = SampleHDR(r3.xy);
        r3.xyzw = SampleHDR(r3.zw);

        r1.xyzw = r3.xyzw + r1.xyzw;
        r2.xyzw = r4.xyzw + r2.xyzw;

        r0.xyzw = cb2[9].zzzz * r2.xyzw + r0.xyzw;

        // Exact original blur output. No normalization or peak restoration.
        float4 blurredColor =
            cb2[9].wwww * r1.xyzw
            + r0.xyzw;

        blurredColor = SanitizeBlurOutput(blurredColor);

        // Default 100% path keeps the old shader result exactly and avoids the
        // extra center sample used only for partial-strength blending.
        [branch]
        if (blurStrength >= 0.999999f)
        {
            o0 = blurredColor;
            return;
        }

        float4 sourceColor = SampleHDR(v1);

        // Blend the whole sample, including alpha. This makes 0% a true blur bypass
        // while 100% preserves the original weighted alpha behavior exactly.
        o0 = lerp(
            sourceColor,
            blurredColor,
            blurStrength
        );
    }
