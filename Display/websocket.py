import asyncio
import ssl
import websockets

ssl_context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
ssl_context.load_cert_chain(certfile='server-cert.pem', keyfile='server-key.pem')

async def handler(websocket, path):
    async for name in websocket:
        print(f"Received message: {name}")
        await websocket.send(f"Hello {name}!")

start_server = websockets.serve(handler, '0.0.0.0', 8000, ssl=ssl_context)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
