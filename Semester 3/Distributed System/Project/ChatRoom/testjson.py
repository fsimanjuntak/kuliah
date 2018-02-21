import json, socket
from MessageUtil import MessageUtil
from Enum import MessageType, SenderType


objmsg = MessageUtil.constructMessage("127.0.0.1", "server", "normal","hi how are you")
msg1, msg2, msg3, msg4 = MessageUtil.extractMessage(objmsg)
print(msg1, msg2, msg3, msg4)

print(MessageType.ACKNOWLEDGEMENT)

# print (sock.getsockname()[1])
#
# def constructMessage(identifier_id, sender_type, message_type, message):
#    json_format = {'id':identifier_id, 'sender_type':sender_type,'message_type':message_type, 'message':message}
#    return json.dumps(json_format)
#
# def extractMessage(obj):
#     json_object = json.loads(obj)
#     return json_object['id'], json_object['sender_type'], json_object['message_type'], json_object['message']
#
# m = {'id': 2, 'name': 'hussain'}
# n = json.dumps(m)
# o = json.loads(n)
# print (o['id'], o['name'])
# objmsg = constructMessage("127.0.0.1", "server", "normal","hi how are you")
# msg1, msg2, msg3, msg4 = extractMessage(objmsg)
# print(msg1, msg2, msg3, msg4)
