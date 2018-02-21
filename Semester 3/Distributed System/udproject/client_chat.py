import socket
import sys, socket, select
from MessageUtil import MessageUtil


def chat_client():
    # Declares Variables
    TYPE_SERVER = "SERVER"
    MESSAGE_INFO = "INFO"

    # Create a UDP socket
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    my_address = s.getsockname()[0]
    my_identity_type = "CLIENT"
    server_address = ('localhost', 10000)

    multicast_group = ('224.3.29.71', 10000)



    # Send acknowledgement message to server that I am up
    s.sendto(MessageUtil.constructMessage(my_address,my_identity_type,"ACKNOWLEDGEMENT","ACKNOWLEDGEMENT"), server_address)
    # sys.stdout.write('[Me] '); sys.stdout.flush()


    while 1:
            socket_list = [sys.stdin, s]
            # Get the list sockets which are readable
            read_sockets, write_sockets, error_sockets = select.select(socket_list , [], [])

            for sock in read_sockets:
                if sock == s:
                    # incoming message from remote server, s
                    data = sock.recv(4096)
                    if not data :
                        print ('\nDisconnected from chat server')
                        sys.exit()
                    else :
                        #extract and print message
                        sender_id, sender_type, message_type, message_content = MessageUtil.extractMessage(data)
                        if (sender_type == TYPE_SERVER):
                            if (message_type == MESSAGE_INFO):
                                sys.stdout.write("%s \n"%(message_content))
                        else:
                            sys.stdout.write("[%s] %s"%(sender_id, message_content))
                    sys.stdout.write('[Me] '); sys.stdout.flush()

                else :
                    # user entered a message
                    msg = sys.stdin.readline()
                    s.sendto(MessageUtil.constructMessage(my_address, my_identity_type, "NORMAL", msg), server_address)
                    # sys.stdout.write('[Me] ');
                    sys.stdout.flush()

if __name__ == "__main__":
    sys.exit(chat_client())

# try:
#
#     # Send data
#     print >>sys.stderr, 'sending "%s"' % message
#     sent = sock.sendto(message, server_address)
#
#     # Receive response
#     print >>sys.stderr, 'waiting to receive'
#     data, server = sock.recvfrom(4096)
#     print >>sys.stderr, 'received "%s"' % data
#
# finally:
#     print >>sys.stderr, 'closing socket'
#     sock.close()
