def enum(**named_values):
    return type('Enum', (), named_values)

MessageType = enum(ACKNOWLEDGEMENT='acknowledgement', NORMAL='normal', INFO='info')
SenderType = enum(CLIENT='client', SERVER='server')
