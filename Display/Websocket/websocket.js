let socket = new WebSocket("ws://raspberrypi.local:8000");

socket.onmessage = function (event) {
    let message = JSON.parse(event.data);
    let action = message.action;
    let index = message.index;

    if (action === 'enable' || action === 'disable') {
        let widget = document.querySelectorAll('.box')[index];
        let content = widget.querySelector('.widget');

        if (action === 'disable') {
            content.style.visibility = 'hidden';
        } else {
            content.style.visibility = 'visible';
        }
    } else if (action === 'swap') {
        let oldIndex = message.old_index;
        let newIndex = message.new_index;
        swapWidgets(oldIndex, newIndex);
    }
};

function swapWidgets(oldIndex, newIndex) {
    let boxes = document.querySelectorAll('.box');
    let parent = boxes[0].parentElement;

    let oldWidget = boxes[oldIndex];
    let newWidget = boxes[newIndex];

    let clonedOldWidget = oldWidget.cloneNode(true);
    let clonedNewWidget = newWidget.cloneNode(true);

    parent.replaceChild(clonedNewWidget, oldWidget);
    parent.replaceChild(clonedOldWidget, newWidget);
}
