
// Clock
setTimeout(updateClock, 1000);

// Appointments
setTimeout(loadAppointments, 60000);

//Calendar

function getNextMidnight() {
    const now = new Date();
    const midnight = new Date(now);
    midnight.setHours(24, 0, 0, 0); // Setze auf Mitternacht
    return midnight - now; // Zeit bis Mitternacht in Millisekunden
}
// Zeit bis zur nächsten Mitternacht berechnen
const timeToMidnight = getNextMidnight();

// Einmaligen Timeout bis Mitternacht setzen
setTimeout(function() {
    createCalendarWidget(); // Einmalige Ausführung um Mitternacht

    // Dann setInterval, um die Funktion täglich auszuführen
    setInterval(createCalendarWidget, 24 * 60 * 60 * 1000); // Alle 24 Stunden
}, timeToMidnight);

// Forecast
setTimeout(getForecast, 36000000);

//GasStation
setTimeout(fetchGasStations, 10000);

//NewsFeed
setTimeout(RefreshNews, 10000);

//TrafficInformation
setInterval(getTrafficStatus, 300000);


