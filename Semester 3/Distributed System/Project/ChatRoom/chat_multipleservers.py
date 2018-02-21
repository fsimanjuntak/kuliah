# chat_server.py

import sys, socket, select
import Server
import json

HOST = 'localhost'
SOCKET_LIST_SERVER = []
SOCKET_LIST = []
RECV_BUFFER = 4096
PORT = 9009
ASK_ACKNOWLEDGEMENT = "01" #Ask Acknowledgement
REPLY_ACKNOWLEDGEMENT = "02" #Reply Acknowledgement
socket_connection_to_defaultserver = None

def chat_server():
    if(len(sys.argv) < 3) :
        print ('Usage : python chat_multiservers.py hostname port')
        sys.exit()

    arg_host = sys.argv[1]
    arg_port = int(sys.argv[2])

    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server_socket.bind((arg_host, arg_port))
    server_socket.listen(10)
    print ("Server is running on port " + str(arg_port))

    #if the address is similar with the socket default
    if (arg_port != PORT):
        socket_connection_to_defaultserver = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        socket_connection_to_defaultserver.settimeout(2)
        # connect to remote host
        try :
            socket_connection_to_defaultserver.connect((HOST, PORT))
            print('Connected to default server')
            # socket_connection_to_defaultserver.send("server_port_%s" % (arg_port))
        except Exception as ex:
            print ('Unable to connect to default server', ex)
            sys.exit()
    else:
        #append master to the socket list
        SOCKET_LIST_SERVER.append(Server.Server(arg_host,"", True, True, arg_port, server_socket))

    while 1:
        sockfd, addr = server_socket.accept()
        print("Server %s is trying to connect"%(addr[0]))
        if (arg_port == PORT):
            isclientorserverexist = False;
            isserver = False
            #check if this connected client/server already in the list
            for _server in SOCKET_LIST_SERVER:
                if _server.sockfd == sockfd:
                    isclientorserverexist = True
                    isserver = _server.isserver

            if isclientorserverexist == False:
                #ask their identity
                print("ask acknowledgement")
                sockfd.send("message_type:%s" % {ASK_ACKNOWLEDGEMENT})
            else:
                #receive acknowledgement from Client or Server
                data = sockfd.recv(RECV_BUFFER)
                arr_msg = json.load(json.dump({data}))

                if(arr_msg['message_type'] == REPLY_ACKNOWLEDGEMENT):
                    if (arr_msg["isclient"] == "0"):
                        isserver = True
                    else:
                        isserver = False
                    SOCKET_LIST_SERVER.append(Server.Server(addr[0],addr[1], False, isserver, arr_msg['socket_port'], sockfd))


                for _server in SOCKET_LIST_SERVER:
                    print("%s , %s , %s , %s" %(_server.adrress, _server.port, _server.socket_port, _server.ismaster))

        # else:
        #     print("not main server")
        #      #receiving data from the socket.
        #     data = socket_connection_to_defaultserver.recv(RECV_BUFFER)
        #
        #     print(data)
        #     if data:
        #         arr_msg = json.load(json.dump({data}))
        #         if (arr_msg['message_type'] == ASK_ACKNOWLEDGEMENT):
        #             print("reply acknowledgement")
        #             #Send the acknowledgment to server
        #             server_identity = "message_type:%s,host:%s,socket_port:%s,isclient:0"%(REPLY_ACKNOWLEDGEMENT,arg_host, arg_port)
        #             socket_connection_to_defaultserver.send(server_identity)
        #

                # print ("Server (%s, %s) is up and running" % addr)

                #append slave to the socket list
                # SOCKET_LIST_SERVER.append(Server.Server(addr[0],addr[1], False, "", sockfd))

             #    #receiving data from the socket.
             #    data = sockfd.recv(RECV_BUFFER)
             #    if data:
             #        arrmsg = data.split("_")
             #        if (arrmsg[0] == "server"):
             #            #COMMUNICATION WITH SERVER SIDE
             #            if (arrmsg[1] == "port"):
             #                for _server in SOCKET_LIST_SERVER:
             #                    if _server.sockfd == sockfd:
             #                        _server.setSocketPort(arrmsg[2])
             #            for _server in SOCKET_LIST_SERVER:
             #                print("%s , %s , %s , %s" %(_server.adrress, _server.port, _server.socket_port, _server.ismaster))
             #    else:
             #       print("Socket is broken")
             #
             # except Exception as ex:
             #    print('Exception receiving message', ex)
             #    continue


            while 1:
                data = socket_connection_to_defaultserver.recv(RECV_BUFFER)

    server_socket.close()

# broadcast chat messages to all connected clients
def broadcast (server_socket, sock, message):
    for socket in SOCKET_LIST:
        # send the message only to peer
        if socket != server_socket and socket != sock :
            try :
                socket.send(message)
            except :
                # broken socket connection
                socket.close()
                # broken socket, remove it
                if socket in SOCKET_LIST:
                    SOCKET_LIST.remove(socket)

if __name__ == "__main__":
    sys.exit(chat_server())

