import json
import socket

# Open a server socket and bind it to port 5555
s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind(("",5555))
while True:
    try:
        s.listen()
        # When it accepts a connection, print the message
        conn,addr=s.accept()
        print("Connected to",addr)
        # If it has not received heartbeat for three seconds, a timeout error will be thrown
        conn.settimeout(3)
        conn.setblocking(True)
        # Open the database text file and store its content to variable xx
        x=open("database.txt","r")
        xx=x.read().rstrip()
        x.close()
        
        # Repeatly wait for received data
        while True:
            #print("..")
            received=conn.recv(1024).decode("utf-8")
            # If the received data are heartbeats,
            # open and read the text file again and store the text file's content into variable x3
            if received=="Heartbeat":
                #print("Heartbeat received")
                x=open("database.txt","r")
                x3=x.read().rstrip()
                x.close()
                # If the file's content has changed,
                # separate out the newly appended part of the file's content
                if x3!=xx:
                    xlist=x3.split(xx)
                    xxx=xlist[1].lstrip().split("\t")
                    print(xxx)
                    # store the data in a dictionary and convert it to a JSON string
                    # send the JSON string to the connected TCP client
                    payload={"device id":xxx[0],
                            "device type":xxx[1],
                            "user id":xxx[2],
                            "timestamp":xxx[3],
                            "message":xxx[4]}
                    dumped=json.dumps(payload)+"\r\n"
                    conn.sendall(dumped.encode("utf-8"))
                    # assign the content of x3 to xx and repeat the above task
                    xx=x3
            if received=="":
                print("Interrupted")
                break
        break
    # If a timeout error is thrown, close the connection socket
    except KeyboardInterrupt:
        conn.close()
        print("Interrupted")
        break
    except:
        conn.close()
        print("Disconnected")
        break