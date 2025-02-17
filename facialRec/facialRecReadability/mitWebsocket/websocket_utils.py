import json
import threading
from websocket import create_connection, WebSocketApp
from profile_utils import load_profiles


def on_message(ws, message):
    if message == "fetch":
        profiles = load_profiles()
        ws.send(json.dumps({"sender": "mirror", "profiles": profiles}))
        return
    message_data = json.loads(message)
    sender = message_data.get("sender")
    if sender == "remote":
        profiles = message_data.get("profiles")
        with open("../../../Display/profiles.json", "w") as json_file:
            json.dump(profiles, json_file, indent=4)

def on_error(ws, error):
    print(error)

def on_close(ws, close_status_code, close_msg):
    print("### closed ###")

def on_open(ws):
    print("### connected ###")

def start_websocket():
    global ws_app
    ws_app = WebSocketApp("ws://172.16.11.249:8000",
                          on_message=on_message,
                          on_error=on_error,
                          on_close=on_close)
    ws_app.on_open = on_open
    ws_app.run_forever()

def send_profiles(profiles):
    global ws_app
    if ws_app and ws_app.sock.connected:
        ws_app.send(json.dumps({"sender": "mirror", "profiles": profiles}))

def initiate_websocket_connection():
    websocket_thread = threading.Thread(target=start_websocket)
    websocket_thread.start()
