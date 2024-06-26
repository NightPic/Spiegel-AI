function updateState(profiles) {
    let selectedProfile = findSelectedProfile(profiles);
    let state = getState(selectedProfile);

    // Get the widgetContainer element
    let widgetContainer = document.getElementById('widgetContainer');

    // Copy the current children of widgetContainer
    let currentChildren = Array.from(widgetContainer.children);

    // Clear existing children from widgetContainer
    widgetContainer.innerHTML = '';


    // Reorder and append boxes based on state array
    state.forEach((item, index) => {
        // Find the original box element by its box-id
        let originalBox = currentChildren.find(child => child.getAttribute('box-id') === `box-${item.id}`);
        if (originalBox) {
            // Adjust visibility based on the 'enabled' property
            let widget = originalBox.querySelector('.widget');
            if (!widget) {
                console.error('Widget not found in original box:', originalBox);
                return;
            }

            if (!item.enabled) {
                widget.style.display = 'none'; // Hide widget if not enabled
            } else {
                widget.style.display = 'block'; // Show widget if enabled
            }

            // Append the original box to widgetContainer
            widgetContainer.appendChild(originalBox);
        } else {
            console.error(`Original box not found for index ${index}`);
        }
    });
}
