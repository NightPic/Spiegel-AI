import json
import time

def output_detected_profile(profiles, label):
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
            "selectedRemoteContent": [{"index": i, "id": i, "enabled": True} for i in range(9)]
        }
        profiles.append(new_profile)

    # Save JSON to file
    with open("profiles.json", "w") as json_file:
        json.dump(profiles, json_file, indent=4)

def load_profiles():
    try:
        with open("profiles.json", "r") as json_file:
            return json.load(json_file)
    except FileNotFoundError:
        return []
