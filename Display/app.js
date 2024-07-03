let previousProfiles = null;

// Function to fetch profiles.json and compare with previous state
function checkForProfileChanges() {
    fetch('profiles.json')
        .then(response => response.json())
        .then(profiles => {
            // Compare with previousProfiles
            if (!isEqual(profiles, previousProfiles)) {
                // Update detected, call updateState
                updateState(profiles);
                // Update previousProfiles
                previousProfiles = profiles;
            }
        })
        .catch(error => {
            console.error('Error fetching profiles.json:', error);
        });
}

// Function to compare two objects deeply
function isEqual(obj1, obj2) {
    return JSON.stringify(obj1) === JSON.stringify(obj2);
}

// Initial call to check for changes
checkForProfileChanges();

// Poll for changes every 200 ms (adjust timing as needed)
setInterval(checkForProfileChanges, 200);
