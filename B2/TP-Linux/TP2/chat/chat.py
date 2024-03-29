import asyncio
import datetime
import json
import logging
import os
import uuid
from random import randint

import colorlog
import redis.asyncio as redis
import websockets


class Server:
    def __init__(self, port, db_host, db_port, max_clients, host='0.0.0.0'):
        self.__host = host
        self.__port = port
        self.__db_host = db_host
        self.__db_port = db_port
        self.__max_clients = max_clients
        self.__websockets = {}
        self.__websockets: dict[str, websockets.WebSocketServerProtocol]
        self.__logger = colorlog.getLogger()
        self.__logger.setLevel(logging.INFO)
        stream_handler = colorlog.StreamHandler()
        stream_handler.setLevel(logging.INFO)

        formatter = colorlog.ColoredFormatter(
            "%(log_color)s%(asctime)s %(levelname)s %(message)s",
            datefmt='%Y-%m-%d %H:%M:%S',
            log_colors={
                'DEBUG': 'cyan',
                'INFO': 'white',
                'WARNING': 'yellow',
                'ERROR': 'red',
                'CRITICAL': 'red,bg_white',
            }
        )
        stream_handler.setFormatter(formatter)
        self.__logger.addHandler(stream_handler)
        asyncio.run(self.run())

    @staticmethod
    def generate_uuid():
        return uuid.uuid4()

    @staticmethod
    async def receive(reader) -> str | bytes:
        try:
            return await reader.recv()
        except websockets.exceptions.ConnectionClosedOK:
            return b''
        except websockets.exceptions.ConnectionClosedError:
            return b''

    async def __get_user(self, id_: str) -> dict | None:
        client = redis.Redis(host=self.__db_host, port=self.__db_port)
        res = json.loads(await client.get(id_))
        await client.aclose()
        return res

    async def __set_user(self, id_: str, data: dict) -> None:
        client = redis.Redis(host=self.__db_host, port=self.__db_port)
        await client.set(id_, json.dumps(data))
        await client.aclose()

    async def get_all_users(self):
        client = redis.Redis(host=self.__db_host, port=self.__db_port)
        keys = await client.keys()
        await client.aclose()
        return keys

    async def __handle_client_msg(self, websocket: websockets.WebSocketServerProtocol):
        self.__logger.info(f"New client : {websocket.remote_address}")
        if len(self.__websockets) >= self.__max_clients:
            await websocket.send("Server full")
            await websocket.close()
            return
        if websocket.remote_address not in [(await self.__get_user(i))["addr"] for i in await self.get_all_users()]:
            data = await self.receive(websocket)
            if data == b'':
                await websocket.send("You must choose un nametag")
                await websocket.close()
                return
            elif data.startswith("Hello|"):
                id_ = str(self.generate_uuid())
                self.__websockets[id_] = websocket
                cls = {"here": True, "color": randint(0, 255), 'pseudo': data[6:],
                       "addr": websocket.remote_address}
                await self.__set_user(id_, cls)
                await self.__send(id_, websocket)
                await self.__send_all("", id_, True)
            elif data.split('ID|')[1].encode() in await self.get_all_users():
                id_ = data.split('ID|')[1]
                cls = await self.__get_user(id_)
                cls["here"] = True
                self.__websockets[id_] = websocket
                cls["addr"] = websocket.remote_address
                cls[
                    "timestamp"] = f"[{datetime.datetime.today().hour}:{datetime.datetime.today().minute}]"
                await self.__set_user(id_, cls)
                await self.__send(id_, websocket, accept=True)
                await self.__send_all("", id_, reconnect=True)
            else:
                await websocket.send("You must choose un nametag")
                await websocket.close()
                return
        else:
            id_ = await self.receive(websocket)
            if await self.__get_user(id_) is not None:
                cls = await self.__get_user(id_)
                self.__websockets[id_] = websocket
                cls["here"] = True
                cls["addr"] = websocket.remote_address
                await self.__set_user(id_, cls)
                await self.__send(await self.__get_user(id_), websocket, accept=True)
            else:
                await websocket.send("Connection rejected")
                await websocket.close()
                return
        while True:
            client = await self.__get_user(id_)
            data = await self.receive(websocket)
            if data == b'':
                client["here"] = False
                await self.__set_user(id_, client)
                await websocket.close()
                self.__logger.info(f"Client {client['pseudo']} disconnected")
                await self.__send_all("", id_, disconnect=True)
                break
            message = data
            client[
                "timestamp"] = f"[{datetime.datetime.today().hour}:{datetime.datetime.today().minute}]"
            self.__logger.info(
                f"Message received from {client['addr'][0]}:{client['addr'][1]} : {message!r}")
            await self.__send_all(message, id_)

    @staticmethod
    async def __send(id_, websocket, accept=False):
        if accept:
            await websocket.send("200")
        else:
            await websocket.send(f"ID|{id_}")
        await websocket.drain()

    async def __send_all(self, message, local_client_id, annonce=False, disconnect=False, reconnect=False):
        local_client = await self.__get_user(local_client_id)
        for i in await self.get_all_users():
            client = await self.__get_user(i)
            if client["here"] and i in self.__websockets:
                if not annonce:
                    if client != local_client:
                        if disconnect:
                            self.__logger.info(
                                f"[{datetime.datetime.today().hour}:{datetime.datetime.today().minute}]\033Annonce : \
                                {local_client['pseudo']} a quitté la chatroom")
                            await self.__websockets[i].send(
                                f"[{datetime.datetime.today().hour}:{datetime.datetime.today().minute}]\033Annonce : \
                                {local_client['pseudo']} a quitté la chatroom")
                            await self.__websockets[i].drain()
                        elif reconnect:
                            self.__logger.info(
                                f"[{datetime.datetime.today().hour}:{datetime.datetime.today().minute}]\033Annonce : \
                                {local_client['pseudo']} est de retour !")
                            await self.__websockets[i].send(
                                f"[{datetime.datetime.today().hour}:{datetime.datetime.today().minute}]\033Annonce : \
                                {local_client['pseudo']} est de retour !")
                            await self.__websockets[i].drain()
                        else:
                            await self.__websockets[i].send(
                                f"{local_client['timestamp']}\033{local_client['color']}\033{local_client['pseudo']}\033\
                                 a dit : {message}")
                            await self.__websockets[i].drain()
                    else:
                        if not disconnect and not reconnect:
                            await self.__websockets[i].send(
                                f"{local_client['timestamp']}\033Vous avez dit : {message}")
                            await self.__websockets[i].drain()
                        elif reconnect:
                            await self.__websockets[i].send(
                                f"{local_client['timestamp']}\033Welcome back  !")
                            await self.__websockets[i].drain()
                else:
                    self.__logger.info(
                        f"[{datetime.datetime.today().hour}:{datetime.datetime.today().minute}]\033Annonce : \
                        {local_client['pseudo']} a rejoint la chatroom")

                    await self.__websockets[i].send(
                        f"[{datetime.datetime.today().hour}:{datetime.datetime.today().minute}]\033Annonce : \
                        {local_client['pseudo']} a rejoint la chatroom")
                    await self.__websockets[i].drain()

    async def run(self):
        async with websockets.serve(self.__handle_client_msg, self.__host, self.__port):
            await asyncio.Future()


if __name__ == "__main__":
    Server(port=int(os.environ.get("CHAT_PORT")), max_clients=int(os.environ.get("MAX_USERS")),
           db_host=os.environ.get("DB_HOST"), db_port=int(os.environ.get("DB_PORT")))
