class User:
    def __init__(self, ID, Position, Confirmblock=None, Rate=None, Startblockheight=None, time=None, waittime=None):
        self.ID = ID
        self.Position = Position
        self.Confirmblock = Confirmblock
        self.Rate = Rate
        self.Startblockheight = Startblockheight
        self.Starttranstime=0
        self.time = time
        self.waittime = waittime
        #请求的数据包大小，单位Mbit
        self.datasize=0
        self.uploadtime=0
        self.UE_request_round=0
        self.transmissiontime=0
        self.iswaittime_recorded=False
        