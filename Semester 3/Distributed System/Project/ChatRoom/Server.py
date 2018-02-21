class Server(object):
   def __init__(self, address, port, ismaster, isserver, socket_port, sockfd):
      self.adrress = address
      self.port = port
      self.socket_port = socket_port
      self.sockfd = sockfd
      self.ismaster = ismaster
      self.isserver = isserver
      self.clients = []

   def setMaster(self):
      self.ismaster = True

   def addClient(self, client):
      self.clients.append(client)

   def removeClient(self, client):
      self.clients.remove(client)

   def setSocketPort(self, socket_port):
      self.socket_port = socket_port
