#For linux
#Self replicating script

import platform
import sys

userdata={"system":platform.system(),
"machine":platform.machine(),
"platform":platform.platform(),
"usernames":platform.uname(),
"pyver":str(sys.version.split("/n"))}
