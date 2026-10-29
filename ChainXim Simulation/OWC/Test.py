from smartcontract import smartcontract
from LD import LD
from User import User

import random
import copy

systemsmartcontract=smartcontract()
User10=User('User10',[4,4,1])
User11=User('User11',[6,6,1])
User12=User('User12',[4,6,1])
User1=User('User1',[1,9,1])
RequestUsers=[User10,User11,User12,User1]
servicelists=systemsmartcontract.findpair(RequestUsers)
#print(servicelists)
# for key,value in servicelists.items():
#     print(f"{key}")
#     if value:
#         for item in value:
#             print(f"{item.ID}: {item.Position}")
#     else:
#         print("- (empty)")
#     print()

isUpchain = True
for key, value in servicelists.items():
    # print(f"{key}")
    if value:
        isUpchain = True
        break
        # for item in value:
        #     print(f"{item.ID}: {item.Position}")
    else:
        # print("- (empty)")
        isUpchain = False
    print()

print(f"isUpchain: {isUpchain}")


#用户组
User1=User('User1',[0.5, 9.5, 1])
User2=User('User2',[3, 3, 1])
User3=User('User3',[3.6, 8.3, 1])
User4=User('User4',[8, 4, 1])
User5=User('User5',[5.4, 1.2, 1])
User6=User('User6',[1, 1, 1])
User7=User('User7',[9, 1, 1])
User8=User('User8',[1.5, 6.5, 1])
User9=User('User9',[9, 9.5, 1])
User10=User('User10',[4, 4, 1])
User11=User('User11',[6, 6, 1])
User12=User('User12',[4, 6, 1])
User13=User('User13',[6, 4, 1])
User14=User('User14',[3.3, 9.8, 1])
User15=User('User15',[7, 3, 1])
User16=User('User16',[6.2, 7.5, 1])
User17=User('User17',[2, 4, 1])
User18=User('User18',[9, 7, 1])
User19=User('User19',[3, 0.2, 1])
User20=User('User20',[7, 5, 1])
all_UEs=[User1,User2,User3,User4,User5,User6,User7,User8,User9,User10,User11,User12,User13,User14,User15,User16,User17,User18,User19,User20]

#LD组
LD1=LD('LD1',[2,2,3])
LD2=LD('LD2',[5,2,3])
LD3=LD('LD3',[8,2,3])
LD4=LD('LD4',[2,5,3])
LD5=LD('LD5',[5,5,3])
LD6=LD('LD6',[8,5,3])
LD7=LD('LD7',[2,8,3])
LD8=LD('LD8',[5,8,3])
LD9=LD('LD9',[8,8,3])
all_LD=[LD1,LD2,LD3,LD4,LD5,LD6,LD7,LD8,LD9]

#随机选择的用户数量
n = 20

# 获取原始UE列表的长度
num_UEs = len(all_UEs)

# 生成一个随机的索引列表
random_indices = random.sample(range(num_UEs), n)

# 遍历随机索引列表，选择对应的UE并添加到活跃用户列表中
active_users = []
for i in range(n):
    index = random_indices[i]
    selected_UE = all_UEs[index]
    active_users.append(selected_UE)


for user in active_users:
    print(f'User ID: {user.ID}, Position: {user.Position}')

print()
#被拉去上传请求的用户组
UEs = []

#上传请求的概率
probability=0.5


servicelists_upload = {
    'LD1': [User1],
    'LD2': [User2],
    'LD3': [User3],
    'LD4': [User4],
    'LD5': [User5,User10,User11],
    'LD6': [User6],
    'LD7': [User7],
    'LD8': [User8],
    'LD9': [User9]
}
UEs_reject=[]
#检查服务列表中尚未完成服务的用户个数
for each_LD in all_LD:
    service_length=1
    for key,value in servicelists_upload.items():
        if key==each_LD.ID:
            if value:
                delete_indices_reject=[]
                for item in value:
                    if service_length-0>=3:
                        #如容量达到上限，则拒绝用户请求
                        #清空参数后，记录下被拒绝的用户
                        rejecteduser=copy.deepcopy(item)
                        rejecteduser.Confirmblock=0
                        rejecteduser.Rate=0
                        rejecteduser.Startblockheight=0
                        rejecteduser.time=0
                        rejecteduser.waittime=0
                        rejecteduser.datasize=0
                        rejecteduser.uploadtime=0
                        rejecteduser.Starttranstime=0
                        rejecteduser.UE_request_round=0
                        #用户位置随机改变！！！
                        rejecteduser.Position=[random.random() * 10, random.random() * 10, 1]
                        UEs_reject.append(copy.deepcopy(rejecteduser))
                        #记录将被移除的用户
                        delete_indices_reject.append(item)
                    else:
                        #如果容量未达上限，则保留用户，并且将服务列表长度增加
                        service_length=service_length+1
                #将用户从服务列表移除
                for i in delete_indices_reject:
                    value.remove(i)

print(servicelists_upload)
print('被拒绝的用户为：')
for u in UEs_reject:
    print(f'User ID: {u.ID}, Position: {u.Position}')






# # 判断是否以一定概率执行
# if random.random() < probability and len(active_users) > 0:
#     # 选择用户的个数是随机的
#     num_users = random.randint(1, len(active_users))
#     # 随机选择用户
#     random_indices_selected = random.sample(range(len(active_users)), num_users)
#     UEs = [active_users[i] for i in random_indices_selected]
                        
#     # 输出选择的用户ID和位置
#     print('本次上传请求的用户为：')
#     for user in UEs:
#         print(f'User ID: {user.ID}, Position: {user.Position}')

#     print()

#     # 从users中移除选择的用户
#     for i in sorted(random_indices_selected, reverse=True):
#         del active_users[i]
    
#     print('剩余用户为：')
#     for u in active_users:
#         print(f'User ID: {u.ID}, Position: {u.Position}')
