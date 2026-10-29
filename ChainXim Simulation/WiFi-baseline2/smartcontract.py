"""Application allocator matching the finalized room geometry."""
import copy,math
from LD import LD
from User import User

class smartcontract:
    def __init__(self):
       self.LDs=[LD('WIFI',[5,5,0])]
       self.Users=[User(f'User{i+1}',[0,0,0])for i in range(50)]

    def findpair(self, Users_list):
        if not Users_list:raise ValueError('Empty user list')
        if len({u.ID for u in Users_list})!=len(Users_list):raise ValueError('Duplicate user ID')
        if not self.LDs:raise ValueError('No LDs available')
        lists={light.ID:[]for light in self.LDs}
        for user in Users_list:
            index=min(range(len(self.LDs)),key=lambda i:(self.calculate_distance(user.Position,self.LDs[i].Position),i))
            lists[self.LDs[index].ID].append(copy.deepcopy(user))
        return lists

    def addLD(self, ID, Position):self.LDs.append(LD(ID,Position))
    def addUser(self, ID, Position):self.Users.append(User(ID,Position))

    @staticmethod
    def calculate_distance(user_coordinates,ld_coordinates):
        if len(user_coordinates)!=3 or len(ld_coordinates)!=3:raise ValueError('Coordinates must have 3 dimensions')
        return math.dist(user_coordinates,ld_coordinates)
