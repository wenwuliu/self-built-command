import itchat
import sys
import time
import datetime

t = time.time()

total = int(sys.argv[1])*60
second = int(t)


@itchat.msg_register(itchat.content.TEXT)
def text_reply(msg):
    t1 = time.time()
    second1 = int(t1)
    left = int(second1 - second)
    if(left <= total):
        return "自动回复～ 正在" + str(sys.argv[2]) + "中，大概剩余" + str(int((total - left)/60)) + "分钟回来"
    else:
        return "预计" + str(sys.argv[2]) + str(total/60) + "分钟，现在还没完成2333，请稍等片刻，我马上回来"

itchat.auto_login()
itchat.run()
