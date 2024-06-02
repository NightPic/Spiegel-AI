async function getForecast() {
    const apiKey = 'e6cb12360dff69175882e44ac7ed2e99';  // Ersetze dies durch deinen API-Schlüssel
    const city = 'Regensburg'; // document.getElementById('city').value;
    const url = `https://api.openweathermap.org/data/2.5/forecast?q=${city}&appid=${apiKey}&units=metric&lang=de`;

    try {
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error('Stadt nicht gefunden');
        }

        const data = await response.json();
        displayForecast(data);
    } catch (error) {
        alert(error.message);
    }
}

function displayForecast(data) {
    const forecastDiv = document.getElementById('forecast');
    forecastDiv.innerHTML = '';

    // Daten nach Tagen gruppieren
    const days = {};
    data.list.forEach(item => {
        const date = new Date(item.dt_txt);
        const day = date.toLocaleDateString('de-DE', { weekday: 'long', day: 'numeric', month: 'long' });

        if (!days[day]) {
            days[day] = [];
        }
        days[day].push(item);
    });

    let columnDiv = null;
    let dayCount = 0;

    // Wettervorhersage für jeden Tag anzeigen
    for (const day in days) {
        if (dayCount % 2 === 0) {
            columnDiv = document.createElement('div');
            columnDiv.className = 'forecast-container';
            forecastDiv.appendChild(columnDiv);
        }

        const dayDiv = document.createElement('div');
        dayDiv.className = 'day';
        dayDiv.innerHTML = `<h3>${day}</h3>`;

        days[day].forEach(item => {
            const time = new Date(item.dt_txt).toLocaleTimeString('de-DE', { hour: '2-digit', minute: '2-digit' });
            const description = item.weather[0].description;
            const temp = item.main.temp;
            dayDiv.innerHTML += `<p>${time}: ${description}, ${temp}°C</p>`;
        });

        columnDiv.appendChild(dayDiv);
        dayCount++;
    }
}

getForecast();