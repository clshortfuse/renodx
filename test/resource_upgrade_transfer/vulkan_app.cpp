#define VK_USE_PLATFORM_WIN32_KHR
#include <vulkan/vulkan.h>

#include <array>
#include <bit>
#include <cmath>
#include <cstring>
#include <sstream>
#include <string>
#include <vector>

#include "common.hpp"

namespace transfer = renodx::test::resource_upgrade_transfer;

namespace {

uint32_t FindMemoryType(
    const VkPhysicalDeviceMemoryProperties& properties,
    uint32_t type_bits,
    VkMemoryPropertyFlags required) {
  for (uint32_t index = 0u; index < properties.memoryTypeCount; ++index) {
    if ((type_bits & (1u << index)) != 0u
        && (properties.memoryTypes[index].propertyFlags & required) == required) {
      return index;
    }
  }
  return UINT32_MAX;
}

bool CreateBuffer(
    VkDevice device,
    const VkPhysicalDeviceMemoryProperties& memory_properties,
    VkDeviceSize size,
    VkBufferUsageFlags usage,
    VkBuffer* buffer,
    VkDeviceMemory* memory) {
  const VkBufferCreateInfo buffer_info = {
      .sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO,
      .size = size,
      .usage = usage,
      .sharingMode = VK_SHARING_MODE_EXCLUSIVE,
  };
  if (vkCreateBuffer(device, &buffer_info, nullptr, buffer) != VK_SUCCESS) return false;

  VkMemoryRequirements requirements = {};
  vkGetBufferMemoryRequirements(device, *buffer, &requirements);
  const uint32_t memory_type = FindMemoryType(
      memory_properties,
      requirements.memoryTypeBits,
      VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT | VK_MEMORY_PROPERTY_HOST_COHERENT_BIT);
  if (memory_type == UINT32_MAX) return false;

  const VkMemoryAllocateInfo allocation_info = {
      .sType = VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO,
      .allocationSize = requirements.size,
      .memoryTypeIndex = memory_type,
  };
  return vkAllocateMemory(device, &allocation_info, nullptr, memory) == VK_SUCCESS
         && vkBindBufferMemory(device, *buffer, *memory, 0u) == VK_SUCCESS;
}

float Float16ToFloat(uint16_t value) {
  const uint32_t sign = static_cast<uint32_t>(value & 0x8000u) << 16u;
  uint32_t exponent = (value >> 10u) & 0x1Fu;
  uint32_t mantissa = value & 0x3FFu;
  uint32_t bits = 0u;
  if (exponent == 0u) {
    if (mantissa == 0u) {
      bits = sign;
    } else {
      int32_t normalized_exponent = -14;
      while ((mantissa & 0x400u) == 0u) {
        mantissa <<= 1u;
        --normalized_exponent;
      }
      bits = sign
             | (static_cast<uint32_t>(normalized_exponent + 127) << 23u)
             | ((mantissa & 0x3FFu) << 13u);
    }
  } else if (exponent == 0x1Fu) {
    bits = sign | 0x7F800000u | (mantissa << 13u);
  } else {
    bits = sign | ((exponent + 112u) << 23u) | (mantissa << 13u);
  }
  return std::bit_cast<float>(bits);
}

}  // namespace

int main() {
  const auto format = transfer::GetFormat();
  const VkFormat vk_format = format == transfer::Format::RGBA8
                                 ? VK_FORMAT_R8G8B8A8_UNORM
                                 : VK_FORMAT_A2B10G10R10_UNORM_PACK32;

  const char* layers[] = {"VK_LAYER_renodx_test_reshade"};
  const VkApplicationInfo application_info = {
      .sType = VK_STRUCTURE_TYPE_APPLICATION_INFO,
      .pApplicationName = "RenoDX Vulkan Resource Upgrade Transfer Test",
      .applicationVersion = VK_MAKE_API_VERSION(0, 1, 0, 0),
      .pEngineName = "RenoDX Test",
      .engineVersion = VK_MAKE_API_VERSION(0, 1, 0, 0),
      .apiVersion = VK_API_VERSION_1_3,
  };
  const VkInstanceCreateInfo instance_info = {
      .sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
      .pApplicationInfo = &application_info,
      .enabledLayerCount = 1u,
      .ppEnabledLayerNames = layers,
  };
  VkInstance instance = VK_NULL_HANDLE;
  const VkResult instance_result = vkCreateInstance(&instance_info, nullptr, &instance);
  if (instance_result != VK_SUCCESS) {
    return transfer::Finish(false, "vkCreateInstance failed: " + std::to_string(instance_result));
  }

  uint32_t physical_device_count = 0u;
  if (vkEnumeratePhysicalDevices(instance, &physical_device_count, nullptr) != VK_SUCCESS
      || physical_device_count == 0u) {
    vkDestroyInstance(instance, nullptr);
    return transfer::Finish(false, "no Vulkan physical device");
  }
  std::vector<VkPhysicalDevice> physical_devices(physical_device_count);
  vkEnumeratePhysicalDevices(instance, &physical_device_count, physical_devices.data());
  const VkPhysicalDevice physical_device = physical_devices.front();

  uint32_t queue_family_count = 0u;
  vkGetPhysicalDeviceQueueFamilyProperties(physical_device, &queue_family_count, nullptr);
  std::vector<VkQueueFamilyProperties> queue_families(queue_family_count);
  vkGetPhysicalDeviceQueueFamilyProperties(physical_device, &queue_family_count, queue_families.data());
  uint32_t queue_family = UINT32_MAX;
  for (uint32_t index = 0u; index < queue_family_count; ++index) {
    if ((queue_families[index].queueFlags & VK_QUEUE_GRAPHICS_BIT) != 0u) {
      queue_family = index;
      break;
    }
  }
  if (queue_family == UINT32_MAX) {
    vkDestroyInstance(instance, nullptr);
    return transfer::Finish(false, "no Vulkan graphics queue");
  }

  constexpr float queue_priority = 1.f;
  const VkDeviceQueueCreateInfo queue_info = {
      .sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO,
      .queueFamilyIndex = queue_family,
      .queueCount = 1u,
      .pQueuePriorities = &queue_priority,
  };
  const VkDeviceCreateInfo device_info = {
      .sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO,
      .queueCreateInfoCount = 1u,
      .pQueueCreateInfos = &queue_info,
  };
  VkDevice device = VK_NULL_HANDLE;
  if (vkCreateDevice(physical_device, &device_info, nullptr, &device) != VK_SUCCESS) {
    vkDestroyInstance(instance, nullptr);
    return transfer::Finish(false, "vkCreateDevice failed");
  }

  VkPhysicalDeviceMemoryProperties memory_properties = {};
  vkGetPhysicalDeviceMemoryProperties(physical_device, &memory_properties);
  VkBuffer upload = VK_NULL_HANDLE;
  VkBuffer readback = VK_NULL_HANDLE;
  VkDeviceMemory upload_memory = VK_NULL_HANDLE;
  VkDeviceMemory readback_memory = VK_NULL_HANDLE;
  if (!CreateBuffer(
          device,
          memory_properties,
          4096u,
          VK_BUFFER_USAGE_TRANSFER_SRC_BIT | VK_BUFFER_USAGE_TRANSFER_DST_BIT,
          &upload,
          &upload_memory)
      || !CreateBuffer(
          device,
          memory_properties,
          4096u,
          VK_BUFFER_USAGE_TRANSFER_SRC_BIT | VK_BUFFER_USAGE_TRANSFER_DST_BIT,
          &readback,
          &readback_memory)) {
    return transfer::Finish(false, "Vulkan buffer creation failed");
  }

  void* mapped = nullptr;
  if (vkMapMemory(device, upload_memory, 0u, VK_WHOLE_SIZE, 0u, &mapped) != VK_SUCCESS) {
    return transfer::Finish(false, "upload mapping failed");
  }
  std::memset(mapped, transfer::SENTINEL, 4096u);
  auto* upload_bytes = static_cast<uint8_t*>(mapped);
  for (uint32_t y = 0u; y < transfer::HEIGHT; ++y) {
    for (uint32_t x = 0u; x < transfer::WIDTH; ++x) {
      const uint32_t packed = transfer::Packed(x, y, format);
      std::memcpy(
          upload_bytes + transfer::UPLOAD_OFFSET + (y * transfer::WIDTH + x) * sizeof(packed),
          &packed,
          sizeof(packed));
    }
  }
  vkUnmapMemory(device, upload_memory);

  if (vkMapMemory(device, readback_memory, 0u, VK_WHOLE_SIZE, 0u, &mapped) != VK_SUCCESS) {
    return transfer::Finish(false, "readback initialization mapping failed");
  }
  std::memset(mapped, transfer::SENTINEL, 4096u);
  vkUnmapMemory(device, readback_memory);

  const VkImageCreateInfo image_info = {
      .sType = VK_STRUCTURE_TYPE_IMAGE_CREATE_INFO,
      .imageType = VK_IMAGE_TYPE_2D,
      .format = vk_format,
      .extent = {transfer::WIDTH, transfer::HEIGHT, 1u},
      .mipLevels = 1u,
      .arrayLayers = 1u,
      .samples = VK_SAMPLE_COUNT_1_BIT,
      .tiling = VK_IMAGE_TILING_OPTIMAL,
      .usage = static_cast<VkImageUsageFlags>(
          GetEnvironmentVariableW(L"RENODX_TRANSFER_LIMITED_USAGE", nullptr, 0u) != 0u
              ? VK_IMAGE_USAGE_TRANSFER_DST_BIT
              : VK_IMAGE_USAGE_TRANSFER_SRC_BIT | VK_IMAGE_USAGE_TRANSFER_DST_BIT),
      .sharingMode = VK_SHARING_MODE_EXCLUSIVE,
      .initialLayout = VK_IMAGE_LAYOUT_UNDEFINED,
  };
  VkImage image = VK_NULL_HANDLE;
  if (vkCreateImage(device, &image_info, nullptr, &image) != VK_SUCCESS) {
    return transfer::Finish(false, "vkCreateImage failed");
  }
  VkMemoryRequirements image_requirements = {};
  vkGetImageMemoryRequirements(device, image, &image_requirements);
  const uint32_t image_memory_type = FindMemoryType(
      memory_properties,
      image_requirements.memoryTypeBits,
      VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT);
  if (image_memory_type == UINT32_MAX) {
    return transfer::Finish(false, "no device-local Vulkan image memory");
  }
  const VkMemoryAllocateInfo image_allocation_info = {
      .sType = VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO,
      .allocationSize = image_requirements.size,
      .memoryTypeIndex = image_memory_type,
  };
  VkDeviceMemory image_memory = VK_NULL_HANDLE;
  if (vkAllocateMemory(device, &image_allocation_info, nullptr, &image_memory) != VK_SUCCESS
      || vkBindImageMemory(device, image, image_memory, 0u) != VK_SUCCESS) {
    return transfer::Finish(false, "Vulkan image memory allocation failed");
  }

  const VkCommandPoolCreateInfo pool_info = {
      .sType = VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO,
      .queueFamilyIndex = queue_family,
  };
  VkCommandPool command_pool = VK_NULL_HANDLE;
  if (vkCreateCommandPool(device, &pool_info, nullptr, &command_pool) != VK_SUCCESS) {
    return transfer::Finish(false, "vkCreateCommandPool failed");
  }
  const VkCommandBufferAllocateInfo command_buffer_info = {
      .sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO,
      .commandPool = command_pool,
      .level = VK_COMMAND_BUFFER_LEVEL_PRIMARY,
      .commandBufferCount = 1u,
  };
  VkCommandBuffer command_buffer = VK_NULL_HANDLE;
  if (vkAllocateCommandBuffers(device, &command_buffer_info, &command_buffer) != VK_SUCCESS) {
    return transfer::Finish(false, "vkAllocateCommandBuffers failed");
  }
  const VkCommandBufferBeginInfo begin_info = {
      .sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO,
      .flags = VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT,
  };
  vkBeginCommandBuffer(command_buffer, &begin_info);

  VkImageMemoryBarrier barrier = {
      .sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER,
      .dstAccessMask = VK_ACCESS_TRANSFER_WRITE_BIT,
      .oldLayout = VK_IMAGE_LAYOUT_UNDEFINED,
      .newLayout = VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL,
      .srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED,
      .dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED,
      .image = image,
      .subresourceRange = {
          .aspectMask = VK_IMAGE_ASPECT_COLOR_BIT,
          .baseMipLevel = 0u,
          .levelCount = 1u,
          .baseArrayLayer = 0u,
          .layerCount = 1u,
      },
  };
  vkCmdPipelineBarrier(
      command_buffer,
      VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT,
      VK_PIPELINE_STAGE_TRANSFER_BIT,
      0u,
      0u,
      nullptr,
      0u,
      nullptr,
      1u,
      &barrier);

  const VkBufferImageCopy upload_copy = {
      .bufferOffset = transfer::UPLOAD_OFFSET,
      .bufferRowLength = transfer::WIDTH,
      .bufferImageHeight = transfer::HEIGHT,
      .imageSubresource = {
          .aspectMask = VK_IMAGE_ASPECT_COLOR_BIT,
          .mipLevel = 0u,
          .baseArrayLayer = 0u,
          .layerCount = 1u,
      },
      .imageExtent = {transfer::WIDTH, transfer::HEIGHT, 1u},
  };
  vkCmdCopyBufferToImage(
      command_buffer,
      upload,
      image,
      VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL,
      1u,
      &upload_copy);

  barrier.srcAccessMask = VK_ACCESS_TRANSFER_WRITE_BIT;
  barrier.dstAccessMask = VK_ACCESS_TRANSFER_READ_BIT;
  barrier.oldLayout = VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL;
  barrier.newLayout = VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL;
  vkCmdPipelineBarrier(
      command_buffer,
      VK_PIPELINE_STAGE_TRANSFER_BIT,
      VK_PIPELINE_STAGE_TRANSFER_BIT,
      0u,
      0u,
      nullptr,
      0u,
      nullptr,
      1u,
      &barrier);

  VkBufferImageCopy readback_copy = upload_copy;
  readback_copy.bufferOffset = transfer::READBACK_OFFSET;
  vkCmdCopyImageToBuffer(
      command_buffer,
      image,
      VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL,
      readback,
      1u,
      &readback_copy);
  if (vkEndCommandBuffer(command_buffer) != VK_SUCCESS) {
    return transfer::Finish(false, "vkEndCommandBuffer failed");
  }

  VkQueue queue = VK_NULL_HANDLE;
  vkGetDeviceQueue(device, queue_family, 0u, &queue);
  const VkSubmitInfo submit_info = {
      .sType = VK_STRUCTURE_TYPE_SUBMIT_INFO,
      .commandBufferCount = 1u,
      .pCommandBuffers = &command_buffer,
  };
  if (vkQueueSubmit(queue, 1u, &submit_info, VK_NULL_HANDLE) != VK_SUCCESS
      || vkQueueWaitIdle(queue) != VK_SUCCESS) {
    return transfer::Finish(false, "Vulkan queue execution failed");
  }

  if (vkMapMemory(device, readback_memory, 0u, VK_WHOLE_SIZE, 0u, &mapped) != VK_SUCCESS) {
    return transfer::Finish(false, "readback mapping failed");
  }
  const auto* readback_bytes = static_cast<const uint8_t*>(mapped);
  const bool inspect_upgraded = GetEnvironmentVariableW(L"RENODX_TRANSFER_INSPECT_UPGRADED", nullptr, 0u) != 0u;
  bool matches = true;
  std::string mismatch_detail;
  for (uint32_t y = 0u; y < transfer::HEIGHT && matches; ++y) {
    for (uint32_t x = 0u; x < transfer::WIDTH && matches; ++x) {
      if (inspect_upgraded) {
        const auto expected = transfer::Expected(x, y, format);
        for (uint32_t component = 0u; component < 4u; ++component) {
          uint16_t actual_bits = 0u;
          std::memcpy(
              &actual_bits,
              readback_bytes + transfer::READBACK_OFFSET
                  + (y * transfer::WIDTH + x) * 4u * sizeof(actual_bits)
                  + component * sizeof(actual_bits),
              sizeof(actual_bits));
          const float actual = Float16ToFloat(actual_bits);
          if (!std::isfinite(actual) || std::abs(actual - expected[component]) > 0.002f) {
            std::ostringstream detail;
            detail << "upgraded texel mismatch at (" << x << ", " << y << ") component "
                   << component << ": actual=" << actual << " (bits=0x" << std::hex
                   << actual_bits << std::dec << "), expected=" << expected[component];
            mismatch_detail = detail.str();
            matches = false;
            break;
          }
        }
      } else {
        uint32_t actual = 0u;
        std::memcpy(
            &actual,
            readback_bytes + transfer::READBACK_OFFSET + (y * transfer::WIDTH + x) * sizeof(actual),
            sizeof(actual));
        const uint32_t expected = transfer::Packed(x, y, format);
        if (actual != expected) {
          std::ostringstream detail;
          detail << "packed texel mismatch at (" << x << ", " << y << "): actual=0x"
                 << std::hex << actual << ", expected=0x" << expected;
          mismatch_detail = detail.str();
          matches = false;
        }
      }
    }
  }
  vkUnmapMemory(device, readback_memory);

  vkDeviceWaitIdle(device);
  vkDestroyCommandPool(device, command_pool, nullptr);
  vkDestroyImage(device, image, nullptr);
  vkFreeMemory(device, image_memory, nullptr);
  vkDestroyBuffer(device, readback, nullptr);
  vkFreeMemory(device, readback_memory, nullptr);
  vkDestroyBuffer(device, upload, nullptr);
  vkFreeMemory(device, upload_memory, nullptr);
  vkDestroyDevice(device, nullptr);
  vkDestroyInstance(instance, nullptr);
  return transfer::Finish(
      matches,
      matches ? (inspect_upgraded ? "upgraded texture contained the expected normalized half-float texels"
                                  : "Vulkan upload/readback preserved application-visible packed data")
              : mismatch_detail);
}