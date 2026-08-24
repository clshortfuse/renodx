import argparse
import hashlib
import re
from pathlib import Path


SHADER_HASH = "0xC03380A0"
SHADER_FILENAME = "../detroitbecomehuman-effects/effects/motion_blur_0xC03380A0.comp.slang"
VANILLA_DIGEST = "24996e860d86905206a2dbce825894126dc93d27c16c03802e1b8cbd8117520d"


def require(text, pattern, description):
    if re.search(pattern, text, flags=re.MULTILINE | re.DOTALL) is None:
        raise AssertionError(description)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--source-dir", required=True, type=Path)
    args = parser.parse_args()
    source_dir = args.source_dir.resolve()

    shader = (source_dir / SHADER_FILENAME).read_text(encoding="utf-8")
    addon = (source_dir / "addon.cpp").read_text(encoding="utf-8")
    shared = (source_dir / "shared.h").read_text(encoding="utf-8")
    supported_build = (source_dir / "supported_build.hpp").read_text(
        encoding="utf-8"
    )

    require(shader, r'#include\s+"\.\./\.\./detroitbecomehuman/shared\.h"', "injected runtime payload is missing")
    require(
        shader,
        r"local_size_x\s*=\s*8[\s\S]*?local_size_y\s*=\s*8[\s\S]*?local_size_z\s*=\s*1",
        "native 8x8 motion-blur workgroup changed",
    )
    for binding in range(7):
        require(
            shader,
            rf"binding\s*=\s*{binding}\)[^\n]*sampler2D",
            f"native sampled binding {binding} is missing",
        )
    require(
        shader,
        r"binding\s*=\s*16,\s*rgba16f\)[^\n]*writeonly\s+image2D",
        "native rgba16f output binding changed",
    )
    require(
        shader,
        r"binding\s*=\s*52,\s*std140\)[\s\S]*?POST_PROCESSING_MOTION_BLUR_CONSTANT_BUFFER",
        "native 112-byte b52 constant buffer is missing",
    )

    vanilla_start = shader.index(
        "NativeMotionBlurResult ResolveMotionBlurVanilla"
    )
    vanilla_end = shader.index(
        "bool UseExperimentalMotionFeather", vanilla_start
    )
    vanilla_digest = hashlib.sha256(
        shader[vanilla_start:vanilla_end].encode("utf-8")
    ).hexdigest()
    if vanilla_digest != VANILLA_DIGEST:
        raise AssertionError(
            "ResolveMotionBlurVanilla source/order changed from the accepted exact port"
        )
    require(
        shader[vanilla_start:vanilla_end],
        r"for\s*\(int\s+i\s*=\s*0;\s*i\s*<\s*8;[\s\S]*?"
        r"\(centerDepth\s*-\s*sampleDepth\)[\s\S]*?999\.99993896484375"
        r"[\s\S]*?\(sampleDepth\s*-\s*centerDepth\)[\s\S]*?999\.99993896484375",
        "native eight-sample depth rejection must remain unchanged",
    )

    require(
        shader,
        r"UseExperimentalMotionFeather\(out\s+bool\s+highQuality\)"
        r"[\s\S]*?highQuality\s*=\s*true"
        r"[\s\S]*?return\s+CUSTOM_EXPERIMENTAL_MOTION_BLUR",
        "motion feather must be independently gated by the experimental flag",
    )
    require(
        shader,
        r"ResolveStableMotionMask\(ivec2\s+halfPixel\)"
        r"[\s\S]*?for\s*\(int\s+y\s*=\s*-1;\s*y\s*<=\s*1"
        r"[\s\S]*?for\s*\(int\s+x\s*=\s*-1;\s*x\s*<=\s*1"
        r"[\s\S]*?coverageSum\s*\*\s*0\.0625",
        "motion mask must retain its normalized 1-2-1 spatial filter",
    )
    require(
        shader,
        r"centerMaskCoverage\s*=\s*ResolveStableMotionMask\(halfPixel\)"
        r"[\s\S]*?centerIsForeground\s*=\s*centerMaskCoverage\s*>=\s*0\.5",
        "enhanced path must classify both sides from the spatially filtered mask",
    )
    require(
        shader,
        r"tileVelocityVector\s*=\s*texelFetch\("
        r"[\s\S]*?velMaxTileMap"
        r"[\s\S]*?localVelocity\s*=\s*clamp\("
        r"[\s\S]*?kMinimumLocalVelocityRatio"
        r"[\s\S]*?cameraVelocityScale"
        r"[\s\S]*?maximumReach"
        r"[\s\S]*?MotionEdgeGatherResult\s+directionalGather"
        r"[\s\S]*?transitionControl\s*=\s*motionStrength"
        r"[\s\S]*?kMaximumMotionMaskBlend"
        r"[\s\S]*?directionalGather\.depthOppositeSupport",
        "feather must convolve both sides with filtered mask and depth evidence",
    )
    if "validatedBackgroundTapCount" in shader:
        raise AssertionError(
            "motion feather must use continuous support instead of a hard tap-count gate"
        )
    require(
        shader,
        r"kBalancedDirectionalSamples\s*=\s*7"
        r"[\s\S]*?kHighDirectionalSamples\s*=\s*9"
        r"[\s\S]*?kBalancedCoverageFeatherSteps\s*=\s*3"
        r"[\s\S]*?kHighCoverageFeatherSteps\s*=\s*4"
        r"[\s\S]*?kBalancedCameraVelocityScale\s*=\s*0\.24"
        r"[\s\S]*?kHighCameraVelocityScale\s*=\s*0\.32"
        r"[\s\S]*?kBalancedMaximumReach\s*=\s*8\.0"
        r"[\s\S]*?kHighMaximumReach\s*=\s*12\.0"
        r"[\s\S]*?kMaximumMotionMaskBlend\s*=\s*0\.65"
        r"[\s\S]*?kMaximumCoverageFade\s*=\s*0\.75"
        r"[\s\S]*?kMinimumParallelEdgeFade\s*=\s*0\.15",
        "fast-motion mask feather must retain its bounded 8/12-pixel reach",
    )
    require(
        shader,
        r"MotionEdgeGatherResult\s+ResolveMotionEdgeGather\("
        r"[\s\S]*?oppositeSideCoverage\s*=\s*centerIsForeground"
        r"[\s\S]*?depthDiscontinuity"
        r"[\s\S]*?depthOppositeWeightSum"
        r"[\s\S]*?MotionEdgeGatherResult\s+directionalGather"
        r"[\s\S]*?kMaximumMotionMaskBlend"
        r"[\s\S]*?smoothstep\(\s*0\.01,\s*0\.45,"
        r"\s*directionalGather\.depthOppositeSupport",
        "fast motion must use a gradual depth-supported directional blend",
    )
    require(
        shader,
        r"ResolveInwardSilhouetteFade\("
        r"[\s\S]*?kCoverageSearchDirections"
        r"[\s\S]*?depthEdgeEvidence"
        r"[\s\S]*?ResolveStableMotionMask\(sampleHalfPixel\)"
        r"[\s\S]*?exteriorEvidence"
        r"[\s\S]*?nearestExteriorDistance"
        r"[\s\S]*?motionAlignment"
        r"[\s\S]*?kMinimumParallelEdgeFade"
        r"[\s\S]*?exteriorColorPixel"
        r"[\s\S]*?ResolveBlurMap\(exteriorColorPixel\)"
        r"[\s\S]*?InwardSilhouetteFadeResult\s+inwardSilhouetteFade"
        r"[\s\S]*?inwardSilhouetteFade\.exteriorColor"
        r"[\s\S]*?kMaximumCoverageFade",
        "silhouette must use an inward coverage fade without cross-edge color blur",
    )
    for forbidden in (
        "normalGather",
        "closestDepthEdgeDistance",
        "kMaximumNormalEdgeBlend",
        "depthEdgeWeightSum",
    ):
        if forbidden in shader:
            raise AssertionError(
                "motion feather must not reintroduce a screen-space edge-normal halo"
            )
    for forbidden in ("mix(\n        0.35", "mix(\n        0.5"):
        if forbidden in shader:
            raise AssertionError(
                "motion feather must not retain a non-zero fallback without edge evidence"
            )
    if "TEMP" in shader:
        raise AssertionError("motion-blur shader still contains a temporary diagnostic")
    if "CUSTOM_DOF_VANILLA_TRANSITION" in shader:
        raise AssertionError(
            "experimental motion blur must not depend on a DOF transition control"
        )

    require(
        shared,
        r"CUSTOM_EXPERIMENTAL_MOTION_BLUR"
        r"[\s\S]*?CUSTOM_RUNTIME_FLAGS\s*&\s*0x4u",
        "shared injection payload is missing the experimental motion-blur flag",
    )
    require(
        addon,
        r"RUNTIME_FLAG_EXPERIMENTAL_MOTION_BLUR\s*=\s*1u\s*<<\s*2u"
        r"[\s\S]*?ExperimentalMotionBlur"
        r"[\s\S]*?default_value\s*=\s*0\.f"
        r"[\s\S]*?section\s*=\s*\"Experimental\"",
        "experimental motion blur must be an independent default-off UI setting",
    )

    require(
        supported_build,
        r"kMotionBlurShaderCrc\s*=\s*0xC03380A0u"
        r"[\s\S]*?kObservedMotionBlurModuleSize\s*=\s*9'112u",
        "captured motion-blur shader identity is not build-scoped",
    )
    require(
        addon,
        r"kMotionBlurShaderCrc[\s\S]*?\.code\s*=\s*__0xC03380A0",
        "motion-blur replacement is not embedded in the static registry",
    )

    print("PASS: Detroit experimental motion-blur silhouette gather contract")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (AssertionError, OSError, ValueError) as error:
        print(f"FAIL: {error}")
        raise SystemExit(1)
