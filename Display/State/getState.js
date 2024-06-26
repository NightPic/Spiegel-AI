function getState(selectedProfile) {
    // If no profile is selected, return default state
    if (!selectedProfile) {
        return [
            {
                "index": 0,
                "id": 0,
                "enabled": true
            },
            {
                "index": 1,
                "id": 1,
                "enabled": true
            },
            {
                "index": 2,
                "id": 2,
                "enabled": true
            },
            {
                "index": 3,
                "id": 3,
                "enabled": true
            },
            {
                "index": 4,
                "id": 4,
                "enabled": true
            },
            {
                "index": 5,
                "id": 5,
                "enabled": true
            },
            {
                "index": 6,
                "id": 6,
                "enabled": true
            },
            {
                "index": 7,
                "id": 7,
                "enabled": true
            },
            {
                "index": 8,
                "id": 8,
                "enabled": true
            }
        ];
    }

    return selectedProfile.state;
}