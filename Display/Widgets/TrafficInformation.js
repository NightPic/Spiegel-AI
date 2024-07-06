function fetchTrafficInformation() {
    const stauStatusElement = document.getElementById("stau-status");

    function getTrafficStatus() {
        const overpassQuery = `
            [out:json];
            area[name="Regensburg"][admin_level=8]->.searchArea;
            (
                node["highway"]["traffic:jam"](area.searchArea);
                way["highway"]["traffic:jam"](area.searchArea);
                relation["highway"]["traffic:jam"](area.searchArea);
            );
            out body;
        `;
        const overpassUrl = `https://overpass-api.de/api/interpreter?data=${encodeURIComponent(overpassQuery)}`;

        fetch(overpassUrl)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok.');
                }
                return response.json();
            })
            .then(data => {
                const stauExists = data.elements && data.elements.length > 0;
                const trafficStatus = stauExists ? "Es gibt einen Stau" : "Es gibt keinen Stau";
                stauStatusElement.textContent = trafficStatus;
            })
            .catch(error => {
                console.error('Error fetching traffic data:', error);
                stauStatusElement.textContent = "Error fetching traffic data";
            });
    }

    // Initial fetch
    getTrafficStatus();

    // Update traffic status every 5 minutes
    setInterval(getTrafficStatus, 300000);
}

if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", fetchTrafficInformation);
} else {
    fetchTrafficInformation();
}
