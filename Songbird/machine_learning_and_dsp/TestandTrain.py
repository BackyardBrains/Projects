# -*- coding: utf-8 -*-
# from noise_removal import noise_removal_dir
import os
import time

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


def cornellTrain(classifierType, modelName):
    birds = ['Baeolophus_bicolor', 'Cardinalis_cardinalis', 'Corvus_brachyrhynchos', 'Cyanocitta_cristata',
             'Passer_domesticus', 'Poecile_atricapillus', 'Spinus_tristis', 'Turdus_migratorius']
    list_of_dirs = [os.path.join("/run/media/zach/untitled/ML_Recordings/Cornell_trimmed", bird, bird + '_clean') for
                    bird in birds]
    test_dirs = [os.path.join("/run/media/zach/untitled/ML_Recordings/Cornell_trimmed_testing", bird, bird + '_clean')
                 for
                 bird in birds]

    # noise_removal_dir("C:\\Users\\zacha\\Desktop\\testign")
    start_time = time.clock()
    # train_and_test(list_of_dirs, test_dirs, modelName="cornellModel")
    train_model(list_of_dirs, classifierType=classifierType, modelName=modelName)
    # plus_zero_one()
    print "Total CPU time is: ", time.clock() - start_time


if __name__ == '__main__':
    # birds = ['bluejay_all', 'cardinal_all', 'cardinal_call', 'cardinal_song', 'chickadee_all', 'chickadee_call',
    # 'chickadee_song', 'crow_all', 'goldfinch_all', 'goldfinch_call', 'goldfinch_song', 'robin_all',
    # 'robin_call', 'robin_song', 'sparrow_all', 'sparrow_call',
    # 'sparrow_song', 'titmouse_all', 'titmouse_call', 'titmouse_song']
    cornellTrain()
