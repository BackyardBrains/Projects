# -*- coding: utf-8 -*-
# from noise_removal import noise_removal_dir
import os
import time

from train_model import train_and_test


def test_params(categories):
    list_of_dirs = []
    test_dirs = []
    for cat in categories:
        list_of_dirs.append(
            u"C:\\Users\\zacha\\Desktop\\testign\\" + unicode(
                cat) + u"\\" + unicode(cat) + u"_clean")
        test_dirs.append(u"C:\\Users\\zacha\\Desktop\\testign\\" + unicode(
            cat) + u"\\" + unicode(cat) + u"_clean")

    return list_of_dirs, test_dirs


if __name__ == '__main__':
    # birds = ['bluejay_all', 'cardinal_all', 'cardinal_call', 'cardinal_song', 'chickadee_all', 'chickadee_call',
    # 'chickadee_song', 'crow_all', 'goldfinch_all', 'goldfinch_call', 'goldfinch_song', 'robin_all',
    # 'robin_call', 'robin_song', 'sparrow_all', 'sparrow_call',
    # 'sparrow_song', 'titmouse_all', 'titmouse_call', 'titmouse_song']

    birds = ['bluejay_all', 'cardinal_song', 'chickadee_song', 'crow_all', 'goldfinch_song', 'robin_song',
             'sparrow_song', 'titmouse_song']
    list_of_dirs = [os.path.join("/run/media/zach/untitled/ML Recordings/xeno-canto/training", bird, bird+'_clean') for bird in birds]
    test_dirs = [os.path.join("/run/media/zach/untitled/ML Recordings/xeno-canto/testing", bird, bird + '_clean') for
                 bird in birds]
    test_dirs.append("/run/media/zach/untitled/ML Recordings/xeno-canto/testing/no_cat")

    # noise_removal_dir("C:\\Users\\zacha\\Desktop\\testign")
    start_time = time.clock()
    train_and_test(list_of_dirs, test_dirs, modelName="model")
    # plus_zero_one()
    print "Total CPU time is: ", time.clock() - start_time
