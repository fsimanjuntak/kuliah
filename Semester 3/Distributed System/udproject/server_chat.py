import socket
import sys
from MessageUtil import MessageUtil


#declare variables
TYPE_CLIENT = "CLIENT"
TYPE_SERVER = "SERVER"

# message types
MESSAGE_ACKNOWLEDGEMENT = "ACKNOWLEDGEMENT"
MESSAGE_NORMAL = "NORMAL"
MESSAGE_INFO = "INFO"

# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

# Bind the socket to the port
server_host = "localhost"
server_port = 10000
server_address = (server_host, server_port)
print >>sys.stderr, 'Server is starting up on %s port %s' % server_address
sock.bind(server_address)

while True:
    print >>sys.stderr, '\nwaiting to receive message'
    data, address = sock.recvfrom(4096)
    # print >>sys.stderr, 'received %s bytes from %s' % (len(data), address)

    if data:
        sender_id, sender_type, message_type, message_content = MessageUtil.extractMessage(data)
        if (sender_type == TYPE_CLIENT):
            message = message_content
            if (message_type == MESSAGE_ACKNOWLEDGEMENT):
                message = 'client %s:%s joined the room' %(address[0],address[1])
                print(message)

                obj_message = MessageUtil.constructMessage(server_host, TYPE_SERVER, MESSAGE_INFO, message)
                sock.sendto(obj_message, address)
            else :
                #send message to all clients except the sender
                sock.sendto(MessageUtil.constructMessage(address[0], TYPE_CLIENT, MESSAGE_NORMAL, message), address)
                print("sent message to client %s"%(message))
