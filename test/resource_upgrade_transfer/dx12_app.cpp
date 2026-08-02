#include <d3d12.h>
#include <dxgi1_6.h>
#include <wrl/client.h>

#include <cstring>
#include <vector>

#include "common.hpp"

using Microsoft::WRL::ComPtr;
namespace transfer = renodx::test::resource_upgrade_transfer;

namespace {

bool HasDebugErrors(ID3D12InfoQueue* queue, std::string& detail) {
  if (queue == nullptr) return false;
  const UINT64 count = queue->GetNumStoredMessagesAllowedByRetrievalFilter();
  for (UINT64 i = 0; i < count; ++i) {
    SIZE_T size = 0;
    queue->GetMessage(i, nullptr, &size);
    std::vector<uint8_t> storage(size);
    auto* message = reinterpret_cast<D3D12_MESSAGE*>(storage.data());
    if (FAILED(queue->GetMessage(i, message, &size))) continue;
    if (message->Severity != D3D12_MESSAGE_SEVERITY_ERROR
        && message->Severity != D3D12_MESSAGE_SEVERITY_CORRUPTION) {
      continue;
    }
    detail = message->pDescription == nullptr ? "D3D12 debug-layer error" : message->pDescription;
    return true;
  }
  return false;
}

}  // namespace

int main() {
  const auto format = transfer::GetFormat();
  const DXGI_FORMAT dxgi_format = format == transfer::Format::RGBA8
                                      ? DXGI_FORMAT_R8G8B8A8_UNORM
                                      : DXGI_FORMAT_R10G10B10A2_UNORM;

  ComPtr<ID3D12Debug> debug;
  if (SUCCEEDED(D3D12GetDebugInterface(IID_PPV_ARGS(&debug)))) {
    debug->EnableDebugLayer();
  }

  ComPtr<IDXGIFactory4> factory;
  if (FAILED(CreateDXGIFactory2(0, IID_PPV_ARGS(&factory)))) {
    return transfer::Finish(false, "CreateDXGIFactory2 failed");
  }

  ComPtr<ID3D12Device> device;
  if (FAILED(D3D12CreateDevice(nullptr, D3D_FEATURE_LEVEL_11_0, IID_PPV_ARGS(&device)))) {
    return transfer::Finish(false, "D3D12CreateDevice failed");
  }
  ComPtr<ID3D12InfoQueue> info_queue;
  device.As(&info_queue);
  if (info_queue) info_queue->ClearStoredMessages();

  D3D12_COMMAND_QUEUE_DESC queue_desc = {};
  queue_desc.Type = D3D12_COMMAND_LIST_TYPE_DIRECT;
  ComPtr<ID3D12CommandQueue> queue;
  if (FAILED(device->CreateCommandQueue(&queue_desc, IID_PPV_ARGS(&queue)))) {
    return transfer::Finish(false, "CreateCommandQueue failed");
  }

  const D3D12_HEAP_PROPERTIES default_heap = {.Type = D3D12_HEAP_TYPE_DEFAULT};
  const D3D12_HEAP_PROPERTIES upload_heap = {.Type = D3D12_HEAP_TYPE_UPLOAD};
  const D3D12_HEAP_PROPERTIES readback_heap = {.Type = D3D12_HEAP_TYPE_READBACK};
  const D3D12_RESOURCE_DESC buffer_desc = {
      .Dimension = D3D12_RESOURCE_DIMENSION_BUFFER,
      .Width = 4096,
      .Height = 1,
      .DepthOrArraySize = 1,
      .MipLevels = 1,
      .Format = DXGI_FORMAT_UNKNOWN,
      .SampleDesc = {.Count = 1},
      .Layout = D3D12_TEXTURE_LAYOUT_ROW_MAJOR,
  };
  const D3D12_RESOURCE_DESC texture_desc = {
      .Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE2D,
      .Width = transfer::WIDTH,
      .Height = transfer::HEIGHT,
      .DepthOrArraySize = 1,
      .MipLevels = 1,
      .Format = dxgi_format,
      .SampleDesc = {.Count = 1},
      .Layout = D3D12_TEXTURE_LAYOUT_UNKNOWN,
  };

  ComPtr<ID3D12Resource> upload;
  ComPtr<ID3D12Resource> readback;
  ComPtr<ID3D12Resource> texture;
  if (FAILED(device->CreateCommittedResource(
          &upload_heap,
          D3D12_HEAP_FLAG_NONE,
          &buffer_desc,
          D3D12_RESOURCE_STATE_GENERIC_READ,
          nullptr,
          IID_PPV_ARGS(&upload)))
      || FAILED(device->CreateCommittedResource(
          &readback_heap,
          D3D12_HEAP_FLAG_NONE,
          &buffer_desc,
          D3D12_RESOURCE_STATE_COPY_DEST,
          nullptr,
          IID_PPV_ARGS(&readback)))
      || FAILED(device->CreateCommittedResource(
          &default_heap,
          D3D12_HEAP_FLAG_NONE,
          &texture_desc,
          D3D12_RESOURCE_STATE_COPY_DEST,
          nullptr,
          IID_PPV_ARGS(&texture)))) {
    return transfer::Finish(false, "CreateCommittedResource failed");
  }

  uint8_t* upload_data = nullptr;
  if (FAILED(upload->Map(0, nullptr, reinterpret_cast<void**>(&upload_data)))) {
    return transfer::Finish(false, "upload Map failed");
  }
  std::memset(upload_data, transfer::SENTINEL, 4096);
  for (uint32_t y = 0; y < transfer::HEIGHT; ++y) {
    for (uint32_t x = 0; x < transfer::WIDTH; ++x) {
      const uint32_t packed = transfer::Packed(x, y, format);
      std::memcpy(upload_data + transfer::UPLOAD_OFFSET + y * 256u + x * sizeof(packed), &packed, sizeof(packed));
    }
  }
  upload->Unmap(0, nullptr);

  uint8_t* initial_readback_data = nullptr;
  const D3D12_RANGE no_read = {};
  if (FAILED(readback->Map(0, &no_read, reinterpret_cast<void**>(&initial_readback_data)))) {
    return transfer::Finish(false, "readback initialization Map failed");
  }
  std::memset(initial_readback_data, transfer::SENTINEL, 4096);
  const D3D12_RANGE all_written = {.Begin = 0, .End = 4096};
  readback->Unmap(0, &all_written);

  ComPtr<ID3D12CommandAllocator> allocator;
  ComPtr<ID3D12GraphicsCommandList> command_list;
  if (FAILED(device->CreateCommandAllocator(D3D12_COMMAND_LIST_TYPE_DIRECT, IID_PPV_ARGS(&allocator)))
      || FAILED(device->CreateCommandList(
          0,
          D3D12_COMMAND_LIST_TYPE_DIRECT,
          allocator.Get(),
          nullptr,
          IID_PPV_ARGS(&command_list)))) {
    return transfer::Finish(false, "command-list creation failed");
  }

  D3D12_TEXTURE_COPY_LOCATION upload_location = {};
  upload_location.pResource = upload.Get();
  upload_location.Type = D3D12_TEXTURE_COPY_TYPE_PLACED_FOOTPRINT;
  upload_location.PlacedFootprint = {
      .Offset = transfer::UPLOAD_OFFSET,
      .Footprint = {
          .Format = dxgi_format,
          .Width = transfer::WIDTH,
          .Height = transfer::HEIGHT,
          .Depth = 1,
          .RowPitch = 256,
      },
  };
  D3D12_TEXTURE_COPY_LOCATION texture_location = {};
  texture_location.pResource = texture.Get();
  texture_location.Type = D3D12_TEXTURE_COPY_TYPE_SUBRESOURCE_INDEX;
  command_list->CopyTextureRegion(&texture_location, 0, 0, 0, &upload_location, nullptr);

  D3D12_RESOURCE_BARRIER barrier = {};
  barrier.Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
  barrier.Transition.pResource = texture.Get();
  barrier.Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
  barrier.Transition.StateBefore = D3D12_RESOURCE_STATE_COPY_DEST;
  barrier.Transition.StateAfter = D3D12_RESOURCE_STATE_COPY_SOURCE;
  command_list->ResourceBarrier(1, &barrier);

  D3D12_TEXTURE_COPY_LOCATION readback_location = upload_location;
  readback_location.pResource = readback.Get();
  readback_location.PlacedFootprint.Offset = transfer::READBACK_OFFSET;
  command_list->CopyTextureRegion(&readback_location, 0, 0, 0, &texture_location, nullptr);

  const HRESULT close_result = command_list->Close();
  if (FAILED(close_result)) {
    std::string detail;
    if (!HasDebugErrors(info_queue.Get(), detail)) {
      detail = "Close command list failed with HRESULT " + std::to_string(static_cast<uint32_t>(close_result));
    }
    return transfer::Finish(false, detail);
  }
  ID3D12CommandList* lists[] = {command_list.Get()};
  queue->ExecuteCommandLists(1, lists);

  ComPtr<ID3D12Fence> fence;
  if (FAILED(device->CreateFence(0, D3D12_FENCE_FLAG_NONE, IID_PPV_ARGS(&fence)))) {
    return transfer::Finish(false, "CreateFence failed");
  }
  HANDLE event_handle = CreateEventW(nullptr, FALSE, FALSE, nullptr);
  if (event_handle == nullptr
      || FAILED(queue->Signal(fence.Get(), 1))
      || (fence->GetCompletedValue() < 1
          && (FAILED(fence->SetEventOnCompletion(1, event_handle))
              || WaitForSingleObject(event_handle, 10000) != WAIT_OBJECT_0))) {
    if (event_handle != nullptr) CloseHandle(event_handle);
    return transfer::Finish(false, "GPU synchronization failed");
  }
  CloseHandle(event_handle);

  std::string detail;
  if (HasDebugErrors(info_queue.Get(), detail)) {
    return transfer::Finish(false, detail);
  }

  uint8_t* readback_data = nullptr;
  const D3D12_RANGE read_range = {
      .Begin = transfer::READBACK_OFFSET,
      .End = transfer::READBACK_OFFSET + 4u * 256u,
  };
  if (FAILED(readback->Map(0, &read_range, reinterpret_cast<void**>(&readback_data)))) {
    return transfer::Finish(false, "readback Map failed");
  }

  bool matches = true;
  for (uint32_t y = 0; y < transfer::HEIGHT && matches; ++y) {
    for (uint32_t x = 0; x < transfer::WIDTH; ++x) {
      uint32_t actual = 0;
      std::memcpy(&actual, readback_data + transfer::READBACK_OFFSET + y * 256u + x * sizeof(actual), sizeof(actual));
      if (actual != transfer::Packed(x, y, format)) {
        matches = false;
        break;
      }
    }
  }
  readback->Unmap(0, nullptr);
  return transfer::Finish(matches, matches ? "native D3D12 upload/readback preserved application-visible data"
                                           : "application readback did not contain the uploaded packed pixels");
}