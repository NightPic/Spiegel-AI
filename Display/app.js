// Funktion zum Laden der profiles.json Datei mit XMLHttpRequest
function loadProfiles(callback) {
    const xhr = new XMLHttpRequest();
    xhr.open('GET', 'profiles.json', true);
    xhr.responseType = 'json';

    xhr.onload = function() {
        if (xhr.status >= 200 && xhr.status < 300) {
            console.log('profiles.json loaded:', xhr.response); // Debugging: Ausgabe der geladenen Datei
            callback(null, xhr.response);
        } else {
            callback(new Error('Failed to load profiles.json: ' + xhr.statusText));
        }
    };

    xhr.onerror = function() {
        callback(new Error('Network error'));
        console.log("Failure");
    };

    xhr.send();
}

// Funktion zum Finden des ausgewählten Profils
function findSelectedProfile(profiles) {
    console.log('Profiles:', profiles); // Debugging: Ausgabe aller Profile
    return profiles.find(profile => profile.isSelected);
}

// Funktion zum Anpassen der Widgets basierend auf dem ausgewählten Profil
function adjustWidgets(selectedProfile) {
    const widgetContainer = document.getElementById('widgetContainer');
    const boxes = Array.from(widgetContainer.getElementsByClassName('box'));

    // Zuerst alle Widgets aus dem Container entfernen
    boxes.forEach(box => widgetContainer.removeChild(box));

    // Maximal 9 Widgets (ID 0-8)
    const maxWidgets = 9;

    // Erstellen einer Karte für schnelle Suche
    const widgetMap = new Map();
    selectedProfile.selectedRemoteContent.forEach(widget => {
        widgetMap.set(widget.id, widget);
    });

    // Widgets basierend auf den ausgewählten IDs und deren Index neu hinzufügen
    for (let i = 0; i < maxWidgets; i++) {
        if (widgetMap.has(i)) {
            const widget = widgetMap.get(i);
            if (widget.enabled) {
                const box = boxes.find(b => b.getAttribute('box-id') === `box-${widget.id}`);
                box.style.order = widget.index; // CSS order-Eigenschaft verwenden, um die Reihenfolge zu ändern
                widgetContainer.appendChild(box);
            }
        } else {
            // Leere Box für fehlende IDs hinzufügen
            const emptyBox = document.createElement('div');
            emptyBox.className = 'box';
            emptyBox.style.order = i;
            widgetContainer.appendChild(emptyBox);
        }
    }
}

// Hauptfunktion zum Initialisieren und Ausführen des Scripts
function init() {
    loadProfiles((error, profiles) => {
        if (error) {
            console.error(error);
            return;
        }
        const selectedProfile = findSelectedProfile(profiles);

        if (selectedProfile) {
            console.log('Selected Profile Name:', selectedProfile.name); // Konsolenausgabe des Profilnamens
            adjustWidgets(selectedProfile);
        } else {
            console.error('Kein ausgewähltes Profil gefunden.');
        }
    });
}

// Initialisieren beim Laden des Dokuments
document.addEventListener('DOMContentLoaded', init);

// Aktualisieren der Widgets alle 30 Sekunden
setInterval(init, 5000);
