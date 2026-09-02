#include <d3d12.h>
#include <dxgi1_6.h>
#include <windows.h>
#include <wrl/client.h>

#include <array>

using Microsoft::WRL::ComPtr;

namespace {

LRESULT CALLBACK WindowProc(HWND window, UINT message, WPARAM wparam, LPARAM lparam) {
  if (message == WM_DESTROY) {
    PostQuitMessage(0);
    return 0;
  }
  return DefWindowProcW(window, message, wparam, lparam);
}

HWND CreateTestWindow(HINSTANCE instance) {
  constexpr wchar_t class_name[] = L"RenoDXRenderPassBehaviorTest";
  const WNDCLASSW window_class = {
      .lpfnWndProc = WindowProc,
      .hInstance = instance,
      .lpszClassName = class_name,
  };
  if (RegisterClassW(&window_class) == 0 && GetLastError() != ERROR_CLASS_ALREADY_EXISTS) {
    return nullptr;
  }
  return CreateWindowExW(
      0,
      class_name,
      L"RenoDX RenderPass Behavior Test",
      WS_OVERLAPPEDWINDOW,
      CW_USEDEFAULT,
      CW_USEDEFAULT,
      64,
      64,
      nullptr,
      nullptr,
      instance,
      nullptr);
}

}  // namespace

int main() {
  HINSTANCE instance = GetModuleHandleW(nullptr);
  HWND window = CreateTestWindow(instance);
  if (window == nullptr) return 10;

  ComPtr<IDXGIFactory4> factory;
  ComPtr<ID3D12Device> device;
  if (FAILED(CreateDXGIFactory2(0, IID_PPV_ARGS(&factory)))
      || FAILED(D3D12CreateDevice(nullptr, D3D_FEATURE_LEVEL_11_0, IID_PPV_ARGS(&device)))) {
    DestroyWindow(window);
    return 11;
  }

  const D3D12_COMMAND_QUEUE_DESC queue_desc = {
      .Type = D3D12_COMMAND_LIST_TYPE_DIRECT,
  };
  ComPtr<ID3D12CommandQueue> queue;
  if (FAILED(device->CreateCommandQueue(&queue_desc, IID_PPV_ARGS(&queue)))) {
    DestroyWindow(window);
    return 12;
  }

  const DXGI_SWAP_CHAIN_DESC1 swapchain_desc = {
      .Width = 32,
      .Height = 32,
      .Format = DXGI_FORMAT_R8G8B8A8_UNORM,
      .SampleDesc = {.Count = 1},
      .BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT,
      .BufferCount = 2,
      .SwapEffect = DXGI_SWAP_EFFECT_FLIP_DISCARD,
  };
  ComPtr<IDXGISwapChain1> swapchain1;
  if (FAILED(factory->CreateSwapChainForHwnd(
          queue.Get(),
          window,
          &swapchain_desc,
          nullptr,
          nullptr,
          &swapchain1))) {
    DestroyWindow(window);
    return 13;
  }
  ComPtr<IDXGISwapChain3> swapchain;
  if (FAILED(swapchain1.As(&swapchain))) {
    DestroyWindow(window);
    return 14;
  }

  const D3D12_DESCRIPTOR_HEAP_DESC heap_desc = {
      .Type = D3D12_DESCRIPTOR_HEAP_TYPE_RTV,
      .NumDescriptors = 2,
  };
  ComPtr<ID3D12DescriptorHeap> rtv_heap;
  if (FAILED(device->CreateDescriptorHeap(&heap_desc, IID_PPV_ARGS(&rtv_heap)))) {
    DestroyWindow(window);
    return 15;
  }

  const UINT descriptor_size = device->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_RTV);
  std::array<ComPtr<ID3D12Resource>, 2> back_buffers;
  D3D12_CPU_DESCRIPTOR_HANDLE rtv = rtv_heap->GetCPUDescriptorHandleForHeapStart();
  for (UINT index = 0; index < back_buffers.size(); ++index) {
    if (FAILED(swapchain->GetBuffer(index, IID_PPV_ARGS(&back_buffers[index])))) {
      DestroyWindow(window);
      return 16;
    }
    device->CreateRenderTargetView(back_buffers[index].Get(), nullptr, rtv);
    rtv.ptr += descriptor_size;
  }

  ComPtr<ID3D12CommandAllocator> allocator;
  ComPtr<ID3D12GraphicsCommandList> command_list;
  if (FAILED(device->CreateCommandAllocator(D3D12_COMMAND_LIST_TYPE_DIRECT, IID_PPV_ARGS(&allocator)))
      || FAILED(device->CreateCommandList(
          0,
          D3D12_COMMAND_LIST_TYPE_DIRECT,
          allocator.Get(),
          nullptr,
          IID_PPV_ARGS(&command_list)))) {
    DestroyWindow(window);
    return 17;
  }

  const UINT buffer_index = swapchain->GetCurrentBackBufferIndex();
  D3D12_RESOURCE_BARRIER barrier = {
      .Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION,
      .Transition = {
          .pResource = back_buffers[buffer_index].Get(),
          .Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES,
          .StateBefore = D3D12_RESOURCE_STATE_PRESENT,
          .StateAfter = D3D12_RESOURCE_STATE_RENDER_TARGET,
      },
  };
  command_list->ResourceBarrier(1, &barrier);

  D3D12_CPU_DESCRIPTOR_HANDLE current_rtv = rtv_heap->GetCPUDescriptorHandleForHeapStart();
  current_rtv.ptr += static_cast<SIZE_T>(buffer_index) * descriptor_size;
  constexpr float clear_color[4] = {0.f, 0.f, 0.f, 1.f};
  command_list->ClearRenderTargetView(current_rtv, clear_color, 0, nullptr);

  std::swap(barrier.Transition.StateBefore, barrier.Transition.StateAfter);
  command_list->ResourceBarrier(1, &barrier);
  if (FAILED(command_list->Close())) {
    DestroyWindow(window);
    return 18;
  }
  ID3D12CommandList* lists[] = {command_list.Get()};
  queue->ExecuteCommandLists(1, lists);

  const HRESULT present_result = swapchain->Present(0, 0);
  if (FAILED(present_result)) {
    DestroyWindow(window);
    return 19;
  }

  ComPtr<ID3D12Fence> fence;
  if (FAILED(device->CreateFence(0, D3D12_FENCE_FLAG_NONE, IID_PPV_ARGS(&fence)))
      || FAILED(queue->Signal(fence.Get(), 1))) {
    DestroyWindow(window);
    return 20;
  }
  HANDLE fence_event = CreateEventW(nullptr, FALSE, FALSE, nullptr);
  if (fence_event == nullptr) {
    DestroyWindow(window);
    return 21;
  }
  if (fence->GetCompletedValue() < 1) {
    if (FAILED(fence->SetEventOnCompletion(1, fence_event))
        || WaitForSingleObject(fence_event, 30000) != WAIT_OBJECT_0) {
      CloseHandle(fence_event);
      DestroyWindow(window);
      return 22;
    }
  }
  CloseHandle(fence_event);
  DestroyWindow(window);
  return 0;
}