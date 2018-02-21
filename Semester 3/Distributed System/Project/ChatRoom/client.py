'''
    udp socket client
    Silver Moon
'''

import socket   #for sockets
import sys  #for exit
from notebook.notebookapp import raw_input

# create dgram udp socket

try:
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
except socket.error:
    print ('Failed to create socket')
    sys.exit()

host = 'localhost';
port = 8888;

while(1) :
    msg = raw_input('Enter message to send : ')

    try :
        #Set the whole string
        s.sendto(msg.encode(encoding='utf-8'), (host, port))

        # receive data from client (data, addr)
        d = s.recvfrom(1024)
        reply = d[0]
        addr = d[1]

        print ('Server reply : ' + reply)

    except socket.error as msg:
        print ('Error Code : ' + str(msg[0]) + ' Message ' + msg[1])
        sys.exit()
