import datetime
import sys
now=datetime.datetime.now()

data=now.strftime("%Y.%m.%d %H.%M.%S")
data=data+": "+sys.argv[1]+"\n"
with open("status.txt","a+") as f:
	f.write(data)
with open("status.txt","r") as f:
	for line in f:
		if line==data:
			print(line.strip()+" <--")
		else:
			print(line.strip())
