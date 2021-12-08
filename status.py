import datetime
import sys
data=datetime.datetime.now().strftime("%Y.%m.%d %H.%M.%S: ")+sys.argv[1]
with open("status.txt","a+") as f:
  f.write(data+"\n")
with open("status.txt","r") as f:
  for line in f:
    if line==data:
      print("-> "+line.strip())
    else:
      print("   "+line.strip())
