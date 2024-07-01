function createCalendarWidget() {
    const calendarWidget = document.getElementById('calendarWidget');
    const currentMonthCalendar = document.getElementById('currentMonthCalendar');
    const nextMonthCalendar = document.getElementById('nextMonthCalendar');

    function generateCalendar(month, year, container) {
        const firstDayOfMonth = new Date(year, month, 1).getDay();
        const adjustedFirstDayOfMonth = firstDayOfMonth === 0 ? 6 : firstDayOfMonth - 1;
        const daysInMonth = new Date(year, month + 1, 0).getDate();

        let calendarHtml = '<table class="calendar-table">';

        calendarHtml += '<thead><tr><th colspan="7">';
        const months = ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'];
        calendarHtml += months[month] + ' ' + year;
        calendarHtml += '</th></tr><tr>';
        const daysOfWeek = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
        daysOfWeek.forEach(day => {
            calendarHtml += `<th>${day}</th>`;
        });
        calendarHtml += '</tr></thead>';

        calendarHtml += '<tbody><tr>';
        for (let i = 0; i < adjustedFirstDayOfMonth; i++) {
            calendarHtml += '<td></td>';
        }
        for (let day = 1; day <= daysInMonth; day++) {
            const today = new Date();
            const isCurrentDay = day === today.getDate() && month === today.getMonth() && year === today.getFullYear();
            calendarHtml += `<td ${isCurrentDay ? 'class="current-day"' : ''}>${day}</td>`;
            if ((day + adjustedFirstDayOfMonth) % 7 === 0) {
                calendarHtml += '</tr><tr>';
            }
        }
        calendarHtml += '</tr></tbody></table>';

        container.innerHTML = calendarHtml;
    }

    const currentDate = new Date();
    generateCalendar(currentDate.getMonth(), currentDate.getFullYear(), currentMonthCalendar);

    const nextMonth = (currentDate.getMonth() + 1) % 12;
    const nextYear = nextMonth === 0 ? currentDate.getFullYear() + 1 : currentDate.getFullYear();
    generateCalendar(nextMonth, nextYear, nextMonthCalendar);
}

createCalendarWidget();
