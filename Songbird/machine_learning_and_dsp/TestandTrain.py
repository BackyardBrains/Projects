# -*- coding: utf-8 -*-
# from noise_removal import noise_removal_dir
import time
import os
from test_model import tester
from train_model import train_model


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


def plus_zero_one(smoothingWindow=5, weight=1, sensitivity=1):
    print "Running on: ", smoothingWindow, weight, sensitivity

    birds = ['bluejay_all', 'cardinal_song', 'chickadee_song', 'crow_all', 'goldfinch_song', 'robin_song',
             'sparrow_song', 'titmouse_song']
    list_of_dirs, test_dirs = test_params(birds)
    model = 'gradientboosting'  # , 'knn', 'gradientboosting', 'randomforest', 'extratrees']
    modelName = 'model32'

    try:
        noise_removal_dir("C:\\Users\\zacha\\Desktop\\testign", smoothingWindow=float(smoothingWindow) / 10.0,
                          weight=float(weight) / 10.0,
                          sensitivity=float(sensitivity) / 10.0)
        test_model(test_dirs, modelName=modelName, classifierType=model, store_to_mySQL=True)
    except:
        print "Failed on: ", smoothingWindow, weight, sensitivity
    else:
        print "Success on: ", smoothingWindow, weight, sensitivity

    if smoothingWindow == 50 and weight == 9 and sensitivity == 9:
        return

    if smoothingWindow == 50:
        smoothingWindow = 5
        if weight == 9:
            weight = 1
            sensitivity += 1
        else:
            weight += 1

    else:
        smoothingWindow += 5
    plus_zero_one(smoothingWindow=smoothingWindow, weight=weight, sensitivity=sensitivity)


if __name__ == '__main__':
    # birds = ['bluejay_all', 'cardinal_all', 'cardinal_call', 'cardinal_song', 'chickadee_all', 'chickadee_call',
    # 'chickadee_song', 'crow_all', 'goldfinch_all', 'goldfinch_call', 'goldfinch_song', 'robin_all',
    # 'robin_call', 'robin_song', 'sparrow_all', 'sparrow_call',
    # 'sparrow_song', 'titmouse_all', 'titmouse_call', 'titmouse_song']

    birds = ['bluejay_all', 'cardinal_song', 'chickadee_song', 'crow_all', 'goldfinch_song', 'robin_song',
             'sparrow_song', 'titmouse_song']
    list_of_dirs = [os.path.join("/run/media/zach/untitled/ML Recordings/xeno-canto/training", bird, bird+'_clean') for bird in birds]
    train_model(list_of_dirs=list_of_dirs)

    # noise_removal_dir("C:\\Users\\zacha\\Desktop\\testign")
    start_time = time.clock()
    # train_and_test(list_of_dirs, test_dirs, modelName=modelName, classifierType=model, store_to_mySQL=True)
    # plus_zero_one()
    print "Total CPU time is: ", time.clock() - start_time
