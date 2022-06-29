import os
import sys
import re
import argparse
import json

import fileinput
from tempfile import NamedTemporaryFile



FN="/home/sfdev/glibc/glibc-build/benchtests/bench-sprintf.out"

 
json_file=open(FN)

with NamedTemporaryFile('w+t',delete=False) as f:
    print(f.name)
    f.write("{\n")
    line=json_file.readlines()
    f.writelines(line)
    f.write("\n}")
    f.seek(0)
    aa=json.load(f)
    print(aa)



