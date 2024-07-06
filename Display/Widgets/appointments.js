function loadAppointments() {
    const appointments = [
        { date: '2024-08-08', time: '10:00', description: 'Meeting with client' },
        { date: '2024-09-10', time: '14:30', description: 'Team brainstorming session' },
        { date: '2024-07-07', time: '16:00', description: 'Phone call with supplier' }
    ];

    const today = new Date();
    const appointmentsList = document.getElementById('appointmentsList');
    appointmentsList.innerHTML = '';

    // Filter appointments happening today or in the future
    const upcomingAppointments = appointments.filter(appointment => new Date(appointment.date) >= today);

    // Sort appointments by date
    upcomingAppointments.sort((a, b) => new Date(a.date) - new Date(b.date));

    // Add appointments to the list
    upcomingAppointments.forEach(appointment => {
        const listItem = document.createElement('li');
        listItem.classList.add('appointment-item');
        listItem.textContent = `${appointment.date} - ${appointment.time} - ${appointment.description}`;
        appointmentsList.appendChild(listItem);
    });
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', loadAppointments);
} else {
    loadAppointments();
}
