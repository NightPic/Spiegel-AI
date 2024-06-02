// Funktion zum Laden von Notizen aus dem lokalen Speicher
function loadNotes() {
    const savedNotes = localStorage.getItem('notes');
    if (savedNotes) {
        document.getElementById('notesTextarea').value = savedNotes;
    }
}

// Funktion zum Speichern von Notizen im lokalen Speicher
function saveNotes() {
    const notesTextarea = document.getElementById('notesTextarea');
    localStorage.setItem('notes', notesTextarea.value);
}

// Eventlistener, um die Notizen beim Laden der Seite zu laden
document.addEventListener('DOMContentLoaded', function() {
    loadNotes();
});

// Eventlistener, um die Notizen zu speichern, wenn der Benutzer den Text ändert
document.getElementById('notesTextarea').addEventListener('input', function() {
    saveNotes();
});