# -*- coding: utf-8 -*-

import glob
import os
from hashlib import md5


def test_params(categories):
    list_of_dirs = []
    test_dirs = []
    for cat in categories:
        list_of_dirs.append("F:\\songbird_samples\\Training\\" + cat)
        test_dirs.append("F:\\songbird_samples\\Testing\\" + cat)

    return list_of_dirs, test_dirs


if __name__ == '__main__':
    birds = ['bluejay_all', 'cardinal_all', 'cardinal_call', 'cardinal_song', 'chickadee_all', 'chickadee_call',
             'chickadee_song', 'crow_all', 'goldfinch_all', 'goldfinch_call', 'goldfinch_song', 'robin_all',
             'robin_call', 'robin_song', 'sparrow_all', 'sparrow_call',
             'sparrow_song', 'titmouse_all', 'titmouse_call', 'titmouse_song']
    list_of_dirs, test_dirs = test_params(birds)
    dirs = list_of_dirs + test_dirs
    for dir in dirs:
        for file in glob.glob(unicode(dir) + u"\\*.wav"):
            os.rename(file, str(md5(file).hexdigest())+'.wav')