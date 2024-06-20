import asyncio
import websockets
import json

# Store connected clients
connected_clients = set()

async def handler(websocket, path):
    # Add client to connected_clients set
    connected_clients.add(websocket)
    try:
        async for message in websocket:
            try:
                print(f"Received message: {message}")
                data = json.loads(message)
                action = data.get('action')
                index = data.get('index')

                if action in ['enable', 'disable']:
                    await broadcast(json.dumps({'action': action, 'index': index}))
                elif action == 'swap':
                    old_index = data.get('old_index')
                    new_index = data.get('new_index')
                    await broadcast(json.dumps({'action': action, 'old_index': old_index, 'new_index': new_index}))
            except json.JSONDecodeError as e:
                print(f"JSON decode error with message {message}: {e}")
    finally:
        # Remove client from connected_clients set when connection closes
        connected_clients.remove(websocket)

async def broadcast(message):
    if connected_clients:
        await asyncio.wait([asyncio.create_task(client.send(message)) for client in connected_clients])

start_server = websockets.serve(handler, '0.0.0.0', 8000)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()

