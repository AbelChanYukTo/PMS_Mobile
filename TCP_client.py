import json
import socket
import sys
import threading
import time
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi

# The connection string containing the account's username and password, and the cluster's name
uri = "mongodb+srv://abelchanseefat1230:123456789To1@abelchanyukto.b26hf.mongodb.net/?retryWrites=true&w=majority&appName=AbelChanYukTo"
# Connect to the MongoDB database
connection=MongoClient(uri,server_api=ServerApi('1'))

# Open a client socket
s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# Set it as blocking
s.setblocking(True)
# Connect to the TCP server and print the message if successfully connected
s.connect(("localhost",5555))
print("Connected to localhost:5555")

# Define a function for sending heartbeat signal to the server every second
def timer():
    while True:
        s.sendall(b"Heartbeat")
        time.sleep(1)
# Open a thread executing the above function
thetimer=threading.Thread(target=timer)
# Set it as a daemon thread so that it will stop when the main program stops
thetimer.daemon=True
thetimer.start()
try:
    # Repeatly wait for receiving data from the server
    while True:
        received=s.recv(1024).decode("utf-8")
        # If the received data are not empty, use json to convert them to a dictionary
        if received!="":
            print(received)
            loaded=json.loads(received)

            # If the data are from bed fall detectors,
            # update the condition of the corresponding patient in the database
            if loaded["device type"]=="0000008012" or loaded["device type"]=="0000006677":
                pms=connection["pms"]
                coll=pms["patient"]
                query={"id":loaded["device id"]}
                updateop={"$set":{"condition":loaded["message"]}}
                coll.update_one(query,updateop)
            
            # If the data are from blood pressure and heartbeat rate sensors,
            if loaded["device type"]=="0000008816":
                hlist=loaded["message"].split("blood_pressure:")
                hhlist=hlist[1].split("heartbeat_rate:")
                blood_pressure=hhlist[0]
                heartbeat_rate=hhlist[1]
                # Update the blood pressure and heartbeat rate of the corresponding patient
                pms=connection["pms"]
                coll=pms["patient"]
                query={"id":loaded["device id"]}
                updateop={"$set":{"heartbeat_rate":heartbeat_rate,"blood_pressure":blood_pressure}}
                coll.update_one(query,updateop)
        # If the received data are empty,
        # it means that the server is closed,
        # so close the socket and the connection to the database
        else:
            s.close()
            connection.close()
            print("Connection stops")
            break
except:
    s.close()
    connection.close()
    print("Connection stops")