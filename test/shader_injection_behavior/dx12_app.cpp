#include <d3d12.h>
#include <dxgi1_6.h>
#include <wrl/client.h>

using Microsoft::WRL::ComPtr;

int main() {
  ComPtr<IDXGIFactory6> factory;
  if (FAILED(CreateDXGIFactory1(IID_PPV_ARGS(&factory)))) return 1;

  ComPtr<ID3D12Device> device;
  if (FAILED(D3D12CreateDevice(nullptr, D3D_FEATURE_LEVEL_11_0, IID_PPV_ARGS(&device)))) return 2;

  D3D12_DESCRIPTOR_RANGE descriptor_range = {};
  descriptor_range.RangeType = D3D12_DESCRIPTOR_RANGE_TYPE_SRV;
  descriptor_range.NumDescriptors = 1u;
  descriptor_range.BaseShaderRegister = 0u;
  descriptor_range.RegisterSpace = 0u;
  descriptor_range.OffsetInDescriptorsFromTableStart = D3D12_DESCRIPTOR_RANGE_OFFSET_APPEND;

  D3D12_ROOT_PARAMETER root_params[3] = {};
  root_params[0].ParameterType = D3D12_ROOT_PARAMETER_TYPE_DESCRIPTOR_TABLE;
  root_params[0].DescriptorTable.NumDescriptorRanges = 1u;
  root_params[0].DescriptorTable.pDescriptorRanges = &descriptor_range;
  root_params[0].ShaderVisibility = D3D12_SHADER_VISIBILITY_PIXEL;

  root_params[1].ParameterType = D3D12_ROOT_PARAMETER_TYPE_32BIT_CONSTANTS;
  root_params[1].Constants.ShaderRegister = 1u;
  root_params[1].Constants.RegisterSpace = 7u;
  root_params[1].Constants.Num32BitValues = 56u;
  root_params[1].ShaderVisibility = D3D12_SHADER_VISIBILITY_ALL;

  root_params[2].ParameterType = D3D12_ROOT_PARAMETER_TYPE_CBV;
  root_params[2].Descriptor.ShaderRegister = 0u;
  root_params[2].Descriptor.RegisterSpace = 0u;
  root_params[2].ShaderVisibility = D3D12_SHADER_VISIBILITY_ALL;

  D3D12_STATIC_SAMPLER_DESC static_sampler = {};
  static_sampler.Filter = D3D12_FILTER_MIN_MAG_MIP_POINT;
  static_sampler.AddressU = D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
  static_sampler.AddressV = D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
  static_sampler.AddressW = D3D12_TEXTURE_ADDRESS_MODE_CLAMP;
  static_sampler.MaxLOD = D3D12_FLOAT32_MAX;
  static_sampler.ShaderRegister = 0u;
  static_sampler.RegisterSpace = 0u;
  static_sampler.ShaderVisibility = D3D12_SHADER_VISIBILITY_PIXEL;

  const D3D12_ROOT_SIGNATURE_DESC root_signature_desc = {
      .NumParameters = 3u,
      .pParameters = root_params,
      .NumStaticSamplers = 1u,
      .pStaticSamplers = &static_sampler,
      .Flags = D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT,
  };

  ComPtr<ID3D12RootSignature> root_signature;
  const auto create_root_signature = [&](ComPtr<ID3D12RootSignature>& output) {
    ComPtr<ID3DBlob> signature;
    ComPtr<ID3DBlob> error;
    if (FAILED(D3D12SerializeRootSignature(
            &root_signature_desc,
            D3D_ROOT_SIGNATURE_VERSION_1,
            &signature,
            &error))) {
      return false;
    }
    return SUCCEEDED(device->CreateRootSignature(
        0u,
        signature->GetBufferPointer(),
        signature->GetBufferSize(),
        IID_PPV_ARGS(&output)));
  };

  if (!create_root_signature(root_signature)) {
    return 3;
  }

  root_params[1].Constants.ShaderRegister = 2u;
  root_params[1].Constants.Num32BitValues = 60u;
  ComPtr<ID3D12RootSignature> overflow_root_signature;
  if (!create_root_signature(overflow_root_signature)) {
    return 4;
  }

  overflow_root_signature.Reset();
  root_signature.Reset();
  return 0;
}