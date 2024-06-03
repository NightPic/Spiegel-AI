document.addEventListener("DOMContentLoaded", function() {
    const stauStatusElement = document.getElementById("stau-status");

    // Funktion zum Abrufen des Verkehrsstatus von OpenStreetMap Overpass API
    function getTrafficStatus() {
        // Überarbeitete Overpass-Abfrage
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
                    throw new Error('Netzwerkantwort war nicht ok.');
                }
                return response.json();
            })
            .then(data => {
                const stauExistiert = data.elements && data.elements.length > 0;
                const trafficStatus = stauExistiert ? "Es gibt einen Stau" : "Es gibt keinen Stau";
                stauStatusElement.textContent = trafficStatus;
            })
            .catch(error => {
                console.error('Fehler beim Abrufen der Verkehrsdaten:', error);
                stauStatusElement.textContent = "Fehler beim Abrufen der Verkehrsdaten";
            });
    }

    // Aktualisiere den Verkehrsstatus beim Laden der Seite
    getTrafficStatus();

    // Aktualisiere den Verkehrsstatus alle 5 Minuten (300000 Millisekunden)
    setInterval(getTrafficStatus, 300000);
});
