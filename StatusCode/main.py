import datetime
now=datetime.datetime.now()

data=now.strftime("%Y.%m.%d.%H.%M.%S")
data=data+": "+input(data+": ")
with open("../status.txt","w+") as f:
	f.write(data)
