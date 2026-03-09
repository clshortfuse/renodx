/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cstdlib>
#include <vector>

#include <d3d11.h>
#include <d3d12.h>

#include <nvsdk_ngx.h>

#include "../directx.hpp"
#include "../log.hpp"

namespace renodx::utils::dlss::nvngx {

static decltype(&NVSDK_NGX_D3D11_Init) real_NVSDK_NGX_D3D11_Init = nullptr;
NVSDK_NGX_API NVSDK_NGX_Result NVSDK_CONV hooked_NVSDK_NGX_D3D11_Init(unsigned long long InApplicationId, const wchar_t* InApplicationDataPath, ID3D11Device* InDevice, const NVSDK_NGX_FeatureCommonInfo* InFeatureInfo = nullptr, NVSDK_NGX_Version InSDKVersion = NVSDK_NGX_Version_API) {
  utils::log::d("utils::dlss::nvngx::hooked_NVSDK_NGX_D3D11_Init()");
  utils::directx::NativeFromReShadeProxy(&InDevice);
  return real_NVSDK_NGX_D3D11_Init(InApplicationId, InApplicationDataPath, InDevice, InFeatureInfo, InSDKVersion);
}

static decltype(&NVSDK_NGX_D3D12_Init) real_NVSDK_NGX_D3D12_Init = nullptr;
NVSDK_NGX_Result NVSDK_CONV hooked_NVSDK_NGX_D3D12_Init(unsigned long long InApplicationId, const wchar_t* InApplicationDataPath, ID3D12Device* InDevice, const NVSDK_NGX_FeatureCommonInfo* InFeatureInfo = nullptr, NVSDK_NGX_Version InSDKVersion = NVSDK_NGX_Version_API) {
  utils::log::d("utils::dlss::nvngx::hooked_NVSDK_NGX_D3D12_Init()");
  utils::directx::NativeFromReShadeProxy(&InDevice);
  return real_NVSDK_NGX_D3D12_Init(InApplicationId, InApplicationDataPath, InDevice, InFeatureInfo, InSDKVersion);
}

static decltype(&NVSDK_NGX_D3D11_Init_with_ProjectID) real_NVSDK_NGX_D3D11_Init_with_ProjectID = nullptr;
NVSDK_NGX_Result NVSDK_CONV hooked_NVSDK_NGX_D3D11_Init_with_ProjectID(const char* InProjectId, NVSDK_NGX_EngineType InEngineType, const char* InEngineVersion, const wchar_t* InApplicationDataPath, ID3D11Device* InDevice, const NVSDK_NGX_FeatureCommonInfo* InFeatureInfo = nullptr, NVSDK_NGX_Version InSDKVersion = NVSDK_NGX_Version_API) {
  utils::log::d("utils::dlss::nvngx::hooked_NVSDK_NGX_D3D11_Init_with_ProjectID()");
  utils::directx::NativeFromReShadeProxy(&InDevice);
  return real_NVSDK_NGX_D3D11_Init_with_ProjectID(InProjectId, InEngineType, InEngineVersion, InApplicationDataPath, InDevice, InFeatureInfo, InSDKVersion);
}

static decltype(&NVSDK_NGX_D3D12_Init_with_ProjectID) real_NVSDK_NGX_D3D12_Init_with_ProjectID = nullptr;
NVSDK_NGX_Result NVSDK_CONV hooked_NVSDK_NGX_D3D12_Init_with_ProjectID(const char* InProjectId, NVSDK_NGX_EngineType InEngineType, const char* InEngineVersion, const wchar_t* InApplicationDataPath, ID3D12Device* InDevice, const NVSDK_NGX_FeatureCommonInfo* InFeatureInfo = nullptr, NVSDK_NGX_Version InSDKVersion = NVSDK_NGX_Version_API) {
  utils::log::d("utils::dlss::nvngx::hooked_NVSDK_NGX_D3D12_Init_with_ProjectID()");
  utils::directx::NativeFromReShadeProxy(&InDevice);
  return real_NVSDK_NGX_D3D12_Init_with_ProjectID(InProjectId, InEngineType, InEngineVersion, InApplicationDataPath, InDevice, InFeatureInfo, InSDKVersion);
}

static decltype(&NVSDK_NGX_D3D11_Shutdown1) real_NVSDK_NGX_D3D11_Shutdown1 = nullptr;
NVSDK_NGX_API NVSDK_NGX_Result NVSDK_CONV hooked_NVSDK_NGX_D3D11_Shutdown1(ID3D11Device* InDevice) {
  utils::log::d("utils::dlss::nvngx::hooked_NVSDK_NGX_D3D11_Shutdown1()");
  utils::directx::NativeFromReShadeProxy(&InDevice);
  return real_NVSDK_NGX_D3D11_Shutdown1(InDevice);
}

static decltype(&NVSDK_NGX_D3D12_Shutdown1) real_NVSDK_NGX_D3D12_Shutdown1 = nullptr;
NVSDK_NGX_API NVSDK_NGX_Result NVSDK_CONV hooked_NVSDK_NGX_D3D12_Shutdown1(ID3D12Device* InDevice) {
  utils::log::d("utils::dlss::nvngx::hooked_NVSDK_NGX_D3D12_Shutdown1()");
  utils::directx::NativeFromReShadeProxy(&InDevice);
  return real_NVSDK_NGX_D3D12_Shutdown1(InDevice);
}

static decltype(&NVSDK_NGX_D3D11_CreateFeature) real_NVSDK_NGX_D3D11_CreateFeature = nullptr;
NVSDK_NGX_API NVSDK_NGX_Result NVSDK_CONV hooked_NVSDK_NGX_D3D11_CreateFeature(ID3D11DeviceContext* InDevCtx, NVSDK_NGX_Feature InFeatureID, NVSDK_NGX_Parameter* InParameters, NVSDK_NGX_Handle** OutHandle) {
  utils::log::d("utils::dlss::nvngx::hooked_NVSDK_NGX_D3D11_CreateFeature()");
  utils::directx::NativeFromReShadeProxy(&InDevCtx);
  return real_NVSDK_NGX_D3D11_CreateFeature(InDevCtx, InFeatureID, InParameters, OutHandle);
}

static decltype(&NVSDK_NGX_D3D12_CreateFeature) real_NVSDK_NGX_D3D12_CreateFeature = nullptr;
NVSDK_NGX_API NVSDK_NGX_Result NVSDK_CONV hooked_NVSDK_NGX_D3D12_CreateFeature(ID3D12GraphicsCommandList* InCmdList, NVSDK_NGX_Feature InFeatureID, NVSDK_NGX_Parameter* InParameters, NVSDK_NGX_Handle** OutHandle) {
  utils::log::d("utils::dlss::nvngx::hooked_NVSDK_NGX_D3D12_CreateFeature()");
  utils::directx::NativeFromReShadeProxy(&InCmdList);
  return real_NVSDK_NGX_D3D12_CreateFeature(InCmdList, InFeatureID, InParameters, OutHandle);
}

static decltype(&NVSDK_NGX_D3D11_EvaluateFeature) real_NVSDK_NGX_D3D11_EvaluateFeature = nullptr;
NVSDK_NGX_API NVSDK_NGX_Result NVSDK_CONV hooked_NVSDK_NGX_D3D11_EvaluateFeature(ID3D11DeviceContext* InDevCtx, const NVSDK_NGX_Handle* InFeatureHandle, const NVSDK_NGX_Parameter* InParameters, PFN_NVSDK_NGX_ProgressCallback InCallback = NULL) {
#ifdef DEBUG_LEVEL_1
  utils::log::d("utils::dlss::nvngx::hooked_NVSDK_NGX_D3D11_EvaluateFeature()");
#endif
  utils::directx::NativeFromReShadeProxy(&InDevCtx);
  return real_NVSDK_NGX_D3D11_EvaluateFeature(InDevCtx, InFeatureHandle, InParameters, InCallback);
}

static decltype(&NVSDK_NGX_D3D12_EvaluateFeature) real_NVSDK_NGX_D3D12_EvaluateFeature = nullptr;
NVSDK_NGX_API NVSDK_NGX_Result NVSDK_CONV hooked_NVSDK_NGX_D3D12_EvaluateFeature(ID3D12GraphicsCommandList* InCmdList, const NVSDK_NGX_Handle* InFeatureHandle, const NVSDK_NGX_Parameter* InParameters, PFN_NVSDK_NGX_ProgressCallback InCallback = NULL) {
  utils::directx::NativeFromReShadeProxy(&InCmdList);
  return real_NVSDK_NGX_D3D12_EvaluateFeature(InCmdList, InFeatureHandle, InParameters, InCallback);
}

static decltype(&NVSDK_NGX_D3D11_EvaluateFeature_C) real_NVSDK_NGX_D3D11_EvaluateFeature_C = nullptr;
NVSDK_NGX_API NVSDK_NGX_Result NVSDK_CONV hooked_NVSDK_NGX_D3D11_EvaluateFeature_C(ID3D11DeviceContext* InDevCtx, const NVSDK_NGX_Handle* InFeatureHandle, const NVSDK_NGX_Parameter* InParameters, PFN_NVSDK_NGX_ProgressCallback_C InCallback) {
  utils::directx::NativeFromReShadeProxy(&InDevCtx);
  return real_NVSDK_NGX_D3D11_EvaluateFeature_C(InDevCtx, InFeatureHandle, InParameters, InCallback);
}

static decltype(&NVSDK_NGX_D3D12_EvaluateFeature_C) real_NVSDK_NGX_D3D12_EvaluateFeature_C = nullptr;
NVSDK_NGX_API NVSDK_NGX_Result NVSDK_CONV hooked_NVSDK_NGX_D3D12_EvaluateFeature_C(ID3D12GraphicsCommandList* InCmdList, const NVSDK_NGX_Handle* InFeatureHandle, const NVSDK_NGX_Parameter* InParameters, PFN_NVSDK_NGX_ProgressCallback_C InCallback) {
  utils::directx::NativeFromReShadeProxy(&InCmdList);
  return real_NVSDK_NGX_D3D12_EvaluateFeature_C(InCmdList, InFeatureHandle, InParameters, InCallback);
}

static const std::vector<std::tuple<const char*, void**, void*>> DLSS_HOOKS = {
    {"NVSDK_NGX_D3D11_Init", (void**)&real_NVSDK_NGX_D3D11_Init, &hooked_NVSDK_NGX_D3D11_Init},
    {"NVSDK_NGX_D3D12_Init", (void**)&real_NVSDK_NGX_D3D12_Init, &hooked_NVSDK_NGX_D3D12_Init},
    {"NVSDK_NGX_D3D11_Init_with_ProjectID", (void**)&real_NVSDK_NGX_D3D11_Init_with_ProjectID, &hooked_NVSDK_NGX_D3D11_Init_with_ProjectID},
    {"NVSDK_NGX_D3D12_Init_with_ProjectID", (void**)&real_NVSDK_NGX_D3D12_Init_with_ProjectID, &hooked_NVSDK_NGX_D3D12_Init_with_ProjectID},
    {"NVSDK_NGX_D3D11_Shutdown1", (void**)&real_NVSDK_NGX_D3D11_Shutdown1, &hooked_NVSDK_NGX_D3D11_Shutdown1},
    {"NVSDK_NGX_D3D12_Shutdown1", (void**)&real_NVSDK_NGX_D3D12_Shutdown1, &hooked_NVSDK_NGX_D3D12_Shutdown1},
    {"NVSDK_NGX_D3D11_CreateFeature", (void**)&real_NVSDK_NGX_D3D11_CreateFeature, &hooked_NVSDK_NGX_D3D11_CreateFeature},
    {"NVSDK_NGX_D3D12_CreateFeature", (void**)&real_NVSDK_NGX_D3D12_CreateFeature, &hooked_NVSDK_NGX_D3D12_CreateFeature},
    {"NVSDK_NGX_D3D11_EvaluateFeature", (void**)&real_NVSDK_NGX_D3D11_EvaluateFeature, &hooked_NVSDK_NGX_D3D11_EvaluateFeature},
    {"NVSDK_NGX_D3D12_EvaluateFeature", (void**)&real_NVSDK_NGX_D3D12_EvaluateFeature, &hooked_NVSDK_NGX_D3D12_EvaluateFeature},
    {"NVSDK_NGX_D3D11_EvaluateFeature_C", (void**)&real_NVSDK_NGX_D3D11_EvaluateFeature_C, &hooked_NVSDK_NGX_D3D11_EvaluateFeature_C},
    {"NVSDK_NGX_D3D12_EvaluateFeature_C", (void**)&real_NVSDK_NGX_D3D12_EvaluateFeature_C, &hooked_NVSDK_NGX_D3D12_EvaluateFeature_C},
};

}  // namespace renodx::utils::dlss::nvngx