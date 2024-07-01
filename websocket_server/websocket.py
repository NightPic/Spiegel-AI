import asyncio
import websockets
import json

# Store connected clients
connected_clients = set()

async def handler(websocket, path):
    # Add client to connected_clients set
    connected_clients.add(websocket)
    print(f"Connection opened for {websocket.remote_address}")

    try:
        async for message in websocket:
            print(f"Received message: {message}")
            if message == 'fetch':
                await broadcast(message)
                continue
            
            data = json.loads(message)
            action = data.get('action')
            if action == 'update_profiles':
                profiles = data.get('profiles')
                await broadcast(json.dumps({'action': 'update_profiles', 'profiles': profiles}))
    except websockets.exceptions.ConnectionClosed as e:
        print(f"Connection closed with error: {e}")
    except websockets.exceptions.ConnectionClosedOK:
        print("Connection closed normally")
    finally:
        # Remove client from connected_clients set when connection closes
        connected_clients.remove(websocket)
        print(f"Connection closed for {websocket.remote_address}")

async def broadcast(message):
    if connected_clients:
        await asyncio.wait([asyncio.create_task(client.send(message)) for client in connected_clients])

start_server = websockets.serve(handler, '0.0.0.0', 8000)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
