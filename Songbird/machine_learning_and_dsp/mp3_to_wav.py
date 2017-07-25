#! python
# -*- coding: utf-8 -*-

import os
import sys

rootdir = os.getcwd()
num_lost = 0

for root, dirs, files in os.walk(rootdir):
    for file in files:
        if file.endswith('.mp3'):
            file = os.path.join(root, file)
            new_file = file + '.wav'
            if os.system("C:\\Users\\zacha\\Downloads\\ffmpeg-3.2.4-win64-shared\\bin\\ffmpeg.exe -i %s %s -y" % (
            file, new_file)):
                num_lost += 1
            elif os.path.exists(new_file):
                os.remove(file)
            else:
                sys.stderr("ffmpeg exited 0, but %s didn't get converted\n" % file)
                exit(1)
print num_lost
