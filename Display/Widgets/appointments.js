// Beispieltermine (kann durch echte Termine ersetzt werden)
function loadAppointments() {
    // Beispieltermine (kann durch echte Termine ersetzt werden)
    const appointments = [
        { date: '2024-06-05', time: '10:00', description: 'Meeting with client' },
        { date: '2024-06-06', time: '14:30', description: 'Team brainstorming session' },
        { date: '2024-06-07', time: '16:00', description: 'Phone call with supplier' }
    ];

    const today = new Date(); // Heutiges Datum
    const appointmentsList = document.getElementById('appointmentsList');
    appointmentsList.innerHTML = '';

    // Filtere Termine, die heute oder später stattfinden
    const upcomingAppointments = appointments.filter(appointment => new Date(appointment.date) >= today);

    // Sortiere die Termine nach Datum
    upcomingAppointments.sort((a, b) => new Date(a.date) - new Date(b.date));

    // Füge die Termine zur Liste hinzu
    upcomingAppointments.forEach(appointment => {
        const listItem = document.createElement('li');
        listItem.classList.add('appointment-item');
        listItem.textContent = `${appointment.date} - ${appointment.time} - ${appointment.description}`;
        appointmentsList.appendChild(listItem);
    });
}

// Eventlistener, um die Termine beim Laden der Seite zu laden
document.addEventListener('DOMContentLoaded', function() {
    loadAppointments();
});