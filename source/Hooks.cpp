#include "Hooks.h"

#include "utils/Logger.h"

#include "IUI/API.h"

#include "Compass.h"

namespace HCN
{
	bool ProcessQuestHook(const RE::HUDMarkerManager* a_hudMarkerManager, RE::HUDMarker::ScaleformData* a_markerData,
						  RE::NiPoint3* a_pos, const RE::RefHandle& a_refHandle, std::int32_t a_markerId, RE::TESQuest*& a_quest)
	{
		if (HUDMarkerManager::UpdateHUDMarker(a_hudMarkerManager, a_markerData, a_pos, a_refHandle, a_markerId))
		{
			if (auto compass = extended::Compass::GetSingleton())
			{
				RE::TESObjectREFRPtr markerRef = RE::TESObjectREFR::LookupByHandle(a_refHandle);

				compass->ProcessQuestMarker(a_quest, markerRef.get(), a_markerId);
			}

			return true;
		}

		return false;
	}

	bool ProcessLocationHook(const RE::HUDMarkerManager* a_hudMarkerManager, RE::HUDMarker::ScaleformData* a_markerData,
							 RE::NiPoint3* a_pos, const RE::RefHandle& a_refHandle, std::int32_t a_markerId)
	{
		if (HUDMarkerManager::UpdateHUDMarker(a_hudMarkerManager, a_markerData, a_pos, a_refHandle, a_markerId)) 
		{
			if (auto compass = extended::Compass::GetSingleton())
			{
				RE::TESObjectREFRPtr markerRef = RE::TESObjectREFR::LookupByHandle(a_refHandle);
				for (RE::RefHandle locationRef : a_hudMarkerManager->locationRefs) 
				{
					RE::TESObjectREFRPtr locationRefOut = RE::TESObjectREFR::LookupByHandle(locationRef);
					if (locationRefOut == markerRef)
					{
						logger::info("Marker found");
					}
				}

				if (markerRef) 
				{
					compass->ProcessLocationMarker(markerRef->extraList.GetByType<RE::ExtraMapMarker>(), markerRef.get(), a_markerId);
				}
			}

			return true;
		}

		return false;
	}

	bool ProcessEnemyHook(const RE::HUDMarkerManager* a_hudMarkerManager, RE::HUDMarker::ScaleformData* a_markerData,
						  RE::NiPoint3* a_pos, const RE::RefHandle& a_refHandle, std::int32_t a_markerId)
	{
		if (HUDMarkerManager::UpdateHUDMarker(a_hudMarkerManager, a_markerData, a_pos, a_refHandle, a_markerId)) 
		{
			if (auto compass = extended::Compass::GetSingleton())
			{
				RE::TESObjectREFRPtr markerRef = RE::TESObjectREFR::LookupByHandle(a_refHandle);

				if (markerRef)
				{
					compass->ProcessEnemyMarker(markerRef->As<RE::Character>(), a_markerId);
				}
			}

			return true;
		}

		return false;
	}

	bool ProcessPlayerSetHook(const RE::HUDMarkerManager* a_hudMarkerManager, RE::HUDMarker::ScaleformData* a_markerData,
							  RE::NiPoint3* a_pos, const RE::RefHandle& a_refHandle, std::int32_t a_markerId)
	{
		if (HUDMarkerManager::UpdateHUDMarker(a_hudMarkerManager, a_markerData, a_pos, a_refHandle, a_markerId)) 
		{
			RE::TESObjectREFRPtr markerRef = RE::TESObjectREFR::LookupByHandle(a_refHandle);

			logger::trace("Player-set marker hooked, {}/?", (int)markerRef->GetFormType());
			logger::flush();

			return true;
		}

		return false;
	}

	bool SetCompassMarkersHook(RE::GFxValue::ObjectInterface* a_objectInterface, void* a_data,
							   RE::GFxValue* a_result, const char* a_name, const RE::GFxValue* a_args,
							   std::uint32_t a_numArgs, bool a_isDObj)
	{
		if (auto compass = extended::Compass::GetSingleton()) 
		{
			compass->SetMarkersExtraInfo();
		}

		return a_objectInterface->Invoke(a_data, a_result, a_name, a_args, a_numArgs, a_isDObj);
	}
}
