let socket = new WebSocket("wss://raspberrypi.local:8000");

socket.onmessage = function (event) {
    let message = JSON.parse(event.data);
    let action = message.action;
    let index = message.index;

    if (action === 'enable' || action === 'disable') {
        let widget = document.querySelectorAll('.box')[index];
        widget.style.display = action === 'disable' ? 'none' : 'block';
    } else if (action === 'swap') {
        let oldIndex = message.old_index;
        let newIndex = message.new_index;
        swapWidgets(oldIndex, newIndex);
    }
};

function swapWidgets(oldIndex, newIndex) {
    let boxes = document.querySelectorAll('.box');
    let parent = boxes[0].parentElement;
    parent.insertBefore(boxes[oldIndex], boxes[newIndex]);
}