import json
import threading
import websocket
from profile_utils import load_profiles

def on_message(ws, message):
    message_data = json.loads(message)
    sender = message_data.get("sender")
    if sender == "remote":
        profiles = message_data.get("profiles")
        with open("profiles.json", "w") as json_file:
            json.dump(profiles, json_file, indent=4)
    elif sender == "fetch":
        profiles = load_profiles()
        ws.send(json.dumps({"sender": "spiegel", "profiles": profiles}))

def on_error(ws, error):
    print(error)

def on_close(ws):
    print("### closed ###")

def on_open(ws):
    print("### connected ###")
    profiles = load_profiles()
    ws.send(json.dumps({"sender": "spiegel", "profiles": profiles}))

def start_websocket():
    ws = websocket.WebSocketApp("ws://your.websocket.server",
                                on_message=on_message,
                                on_error=on_error,
                                on_close=on_close)
    ws.on_open = on_open
    ws.run_forever()

def send_profiles(profiles):
    ws = websocket.create_connection("ws://your.websocket.server")
    ws.send(json.dumps({"sender": "spiegel", "profiles": profiles}))
    ws.close()

# Start WebSocket thread
def initiate_websocket_connection():
    websocket_thread = threading.Thread(target=start_websocket)
    websocket_thread.start()
