#include <array>

#include <windows.h>

#include <d3d12.h>
#include <dxgi1_6.h>
#include <wrl/client.h>

using Microsoft::WRL::ComPtr;

int main() {
  ComPtr<IDXGIFactory6> factory;
  if (FAILED(CreateDXGIFactory1(IID_PPV_ARGS(&factory)))) return 1;

  ComPtr<ID3D12Device> device;
  if (FAILED(D3D12CreateDevice(nullptr, D3D_FEATURE_LEVEL_11_0, IID_PPV_ARGS(&device)))) return 2;

  D3D12_DESCRIPTOR_HEAP_DESC resource_heap_desc = {};
  resource_heap_desc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV;
  resource_heap_desc.NumDescriptors = 4096u;
  resource_heap_desc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE;
  ComPtr<ID3D12DescriptorHeap> resource_heap;
  if (FAILED(device->CreateDescriptorHeap(&resource_heap_desc, IID_PPV_ARGS(&resource_heap)))) return 3;

  D3D12_DESCRIPTOR_HEAP_DESC sampler_heap_desc = {};
  sampler_heap_desc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_SAMPLER;
  sampler_heap_desc.NumDescriptors = 256u;
  sampler_heap_desc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE;
  ComPtr<ID3D12DescriptorHeap> sampler_heap;
  if (FAILED(device->CreateDescriptorHeap(&sampler_heap_desc, IID_PPV_ARGS(&sampler_heap)))) return 4;

  D3D12_COMMAND_QUEUE_DESC queue_desc = {};
  ComPtr<ID3D12CommandQueue> queue;
  if (FAILED(device->CreateCommandQueue(&queue_desc, IID_PPV_ARGS(&queue)))) return 5;

  const HINSTANCE instance = GetModuleHandleW(nullptr);
  const wchar_t* class_name = L"RenoDXDescriptorCacheRace";
  WNDCLASSW window_class = {};
  window_class.lpfnWndProc = DefWindowProcW;
  window_class.hInstance = instance;
  window_class.lpszClassName = class_name;
  RegisterClassW(&window_class);
  HWND window = CreateWindowExW(
      0,
      class_name,
      L"RenoDX Descriptor Cache Race",
      WS_OVERLAPPEDWINDOW,
      CW_USEDEFAULT,
      CW_USEDEFAULT,
      64,
      64,
      nullptr,
      nullptr,
      instance,
      nullptr);
  if (window == nullptr) return 6;

  DXGI_SWAP_CHAIN_DESC1 swapchain_desc = {};
  swapchain_desc.Width = 64u;
  swapchain_desc.Height = 64u;
  swapchain_desc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
  swapchain_desc.SampleDesc.Count = 1u;
  swapchain_desc.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
  swapchain_desc.BufferCount = 2u;
  swapchain_desc.SwapEffect = DXGI_SWAP_EFFECT_FLIP_DISCARD;
  ComPtr<IDXGISwapChain1> swapchain;
  if (FAILED(factory->CreateSwapChainForHwnd(
          queue.Get(),
          window,
          &swapchain_desc,
          nullptr,
          nullptr,
          &swapchain))) {
    DestroyWindow(window);
    return 7;
  }

  D3D12_DESCRIPTOR_RANGE descriptor_range = {};
  descriptor_range.RangeType = D3D12_DESCRIPTOR_RANGE_TYPE_SRV;
  descriptor_range.NumDescriptors = 1u;
  descriptor_range.BaseShaderRegister = 41u;
  descriptor_range.RegisterSpace = 564u;
  descriptor_range.OffsetInDescriptorsFromTableStart = D3D12_DESCRIPTOR_RANGE_OFFSET_APPEND;

  D3D12_ROOT_PARAMETER root_param = {};
  root_param.ParameterType = D3D12_ROOT_PARAMETER_TYPE_DESCRIPTOR_TABLE;
  root_param.DescriptorTable.NumDescriptorRanges = 1u;
  root_param.DescriptorTable.pDescriptorRanges = &descriptor_range;
  root_param.ShaderVisibility = D3D12_SHADER_VISIBILITY_PIXEL;

  const D3D12_ROOT_SIGNATURE_DESC root_signature_desc = {
      .NumParameters = 1u,
      .pParameters = &root_param,
      .Flags = D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT,
  };
  ComPtr<ID3DBlob> signature;
  ComPtr<ID3DBlob> error;
  if (FAILED(D3D12SerializeRootSignature(
          &root_signature_desc,
          D3D_ROOT_SIGNATURE_VERSION_1,
          &signature,
          &error))) {
    return 8;
  }

  std::array<ComPtr<ID3D12RootSignature>, 64u> root_signatures;
  for (auto& root_signature : root_signatures) {
    if (FAILED(device->CreateRootSignature(
            0u,
            signature->GetBufferPointer(),
            signature->GetBufferSize(),
            IID_PPV_ARGS(&root_signature)))) {
      return 9;
    }
  }

  if (FAILED(swapchain->Present(0u, 0u))) return 10;

  for (auto& root_signature : root_signatures) root_signature.Reset();
  swapchain.Reset();
  DestroyWindow(window);
  UnregisterClassW(class_name, instance);
  return 0;
}