let socket = new WebSocket("ws://raspberrypi.local:8000");

socket.onmessage = function (event) {
    let message = JSON.parse(event.data);
    if (message.sender === 'remote') {
        let profiles = message.profiles;
        updateState(profiles);
    }
};