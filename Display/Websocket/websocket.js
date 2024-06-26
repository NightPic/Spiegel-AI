let socket = new WebSocket("ws://raspberrypi.local:8000");

socket.onmessage = function (event) {
    let message = JSON.parse(event.data);
    if (message.action === 'update_profiles') {
        let profiles = message.profiles;
        updateState(profiles);
    }
};