function fetchGasStations() {
    const apiKey = "210cf594-7d21-d062-5e5c-415cb748e03e";
    const city = "Regensburg";
    const apiUrl = `https://creativecommons.tankerkoenig.de/json/list.php?apikey=${apiKey}&lat=49.0134&lng=12.1016&rad=5&sort=price&type=e5`;

    async function getGasStations() {
        try {
            const response = await fetch(apiUrl);
            const data = await response.json();

            if (data.status === "ok" && data.stations.length > 0) {
                const cheapestStation = data.stations.reduce((prev, curr) => {
                    return (prev.price < curr.price) ? prev : curr;
                });

                displayStationInfo(cheapestStation);
            } else {
                document.getElementById("station-info").innerText = "Keine Daten verfügbar.";
            }
        } catch (error) {
            console.error("Fehler beim Abrufen der Daten:", error);
            document.getElementById("station-info").innerText = "Fehler beim Abrufen der Daten.";
        }
    }

    function displayStationInfo(station) {
        const infoElement = document.getElementById("station-info");
        infoElement.innerHTML = `
            <p>Tankstelle: ${station.name}</p>
            <p>Adresse: ${station.street} ${station.houseNumber}, ${station.postCode} ${station.place}</p>
            <p>Preis: €${station.price.toFixed(2)} / Liter</p>
        `;
    }

    getGasStations();
}

if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", fetchGasStations);
} else {
    fetchGasStations();
}
