function updateState(profiles) {
    let selectedProfile = findSelectedProfile(profiles);
    let state = getState(selectedProfile);

    let widgetContainer = document.getElementById('widgetContainer');
    widgetContainer.innerHTML = '';

    const oldScripts = document.querySelectorAll('.dynamic-script');
    oldScripts.forEach(script => script.remove());

    // Reorder and append boxes based on state array
    state.forEach((item, index) => {
        let box = document.createElement('div');
        box.className = 'box';

        let widget = document.createElement('div');
        widget.className = 'widget';

        switch (item.id) {
            case -1:
                widget.innerHTML = `<h1> </h1>`;
                break;
            case 0:
                widget.innerHTML = `
                    <div id="calendarWidget">
                        <div id="currentMonthCalendar"></div>
                        <div id="nextMonthCalendar"></div>
                    </div>`;
                break;
            case 1:
                widget.innerHTML = `<div id="clock"></div>`;
                break;
            case 2:
                widget.innerHTML = `
                    <h1>Wettervorhersage App</h1>
                    <div id="weather">
                        <div id="forecast"></div>
                    </div>`;
                break;
            case 3:
                widget.innerHTML = `
                    <h2>Notizen</h2>
                    <textarea id="notesTextarea" rows="10" readonly="true">Semesterferien beginnen am: 27. Juli 2024</textarea>`;
                break;
            case 4:
                widget.innerHTML = `
                    <h2>Nächste Termine</h2>
                    <ul id="appointmentsList"></ul>`;
                break;
            case 5:
                widget.innerHTML = `
                    <h2>Verkehrslage in Regensburg</h2>
                    <p id="stau-status">Lade...</p>`;
                break;
            case 6:
                widget.innerHTML = `
                    <h2>Neueste Nachrichten</h2>
                    <ul id="news-feed"></ul>`;
                break;
            case 7:
                widget.innerHTML = `
                    <h2>Günstigste Tankstelle in Regensburg</h2>
                    <div id="station-info">
                    </div>`;
                break;
            case 8:
                widget.innerHTML = `
                    <h2>${selectedProfile.name}</h2>
                    <div>
                    </div>`;
                break;
            case 9:
                widget.innerHTML = `
                    <h2>TestWidget</h2>
                    <div>
                    </div>`;
                break;
            default:
                console.error(`No widget defined for id: ${item.id}`);
                return;
        }

        if (!item.enabled) {
            widget.style.display = 'none';
        } else {
            widget.style.display = 'block';
        }
        
        let scriptSrc = getScriptSrcById(item.id);
        if (scriptSrc) {
            let script = document.createElement('script');
            script.src = getScriptSrcById(item.id);
            script.className = 'dynamic-script';
            widget.appendChild(script);
        }
            
        box.appendChild(widget);
        widgetContainer.appendChild(box);
    });
}

function getScriptSrcById(id) {
    switch (id) {
        case 0:
            return 'Widgets/calender.js';
        case 1:
            return 'Widgets/clock.js';
        case 2:
            return 'Widgets/forecast.js';
        case 3:
            return 'Widgets/notes.js';
        case 4:
            return 'Widgets/appointments.js';
        case 5:
            return 'Widgets/TrafficInformation.js';
        case 6:
            return 'Widgets/NewsFeed.js';
        case 7:
            return 'Widgets/GasStation.js';
        default:
            return null;
    }
}