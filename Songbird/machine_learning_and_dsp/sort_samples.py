#! python

import os
import shutil


def string_sub(string_a, string_b):
    if len(string_a) < len(string_b):
        comp_length = len(string_a)
        return string_b[comp_length:]

    else:
        comp_length = len(string_b)
        return string_a[comp_length:]


def directory_check(file):
    folder, filename = os.path.split(file)
    if not os.path.exists(folder):
        os.mkdir(folder)


rootdir = os.getcwd()

trimed_folder = rootdir + '_testing'
if not os.path.exists(trimed_folder):
    os.mkdir(trimed_folder)

for root, dirs, files in os.walk(rootdir):
    filenum = 0
    for file in files:
        if (file.endswith('.wav') or file.endswith('.WAV')) and not filenum % 5:
            file_path = os.path.join(root, file)
            new_file_path = string_sub(file_path, rootdir)
            new_file_path = trimed_folder + new_file_path
            directory_check(new_file_path)

            shutil.move(file_path, new_file_path)
        filenum += 1
