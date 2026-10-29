class LD:
    def __init__(self, ID, Position):
        self.ID = ID
        self.Position = Position
        self.servicelistsLD=[]
        #LD的状态，用于传输时
        self.isbusy=False
        #服务顺序标识
        self.service_index=0
        #LD已经服务一个用户的时长
        self.transmissiontime=0

