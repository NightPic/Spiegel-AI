import json
import time

def save_profiles(profiles, send_profiles, force_send=False):
    with open("../../../Display/profiles.json", "w") as json_file:
        json.dump(profiles, json_file, indent=4)
    # Send updated profiles to WebSocket server if required
    if force_send:
        send_profiles(profiles)

def output_detected_profile(profiles, label, send_profiles):
    for profile in profiles:
        profile["isSelected"] = False

    existing_profile = next((profile for profile in profiles if profile["name"] == label), None)
    if existing_profile:
        existing_profile["isSelected"] = True
    else:
        new_profile = {
            "id": str(int(time.time() * 1000)),
            "name": label,
            "isSelected": True,
            "selectedWidgetIDs": list(range(8)),
            "state": [{"index": i, "id": i, "enabled": True} for i in range(9)]
        }
        profiles.append(new_profile)

    save_profiles(profiles, send_profiles, force_send=True)

def load_profiles():
    try:
        with open("../../../Display/profiles.json", "r") as json_file:
            return json.load(json_file)
    except FileNotFoundError:
        return []
