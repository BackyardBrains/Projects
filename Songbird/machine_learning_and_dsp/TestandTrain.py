# -*- coding: utf-8 -*-
from train_model import *
from twillio_test import *


def test_params(categories):
    list_of_dirs = []
    test_dirs = []
    for cat in categories:
        list_of_dirs.append(u"F:\\songbird_samples\\Training\\" + unicode(cat) + '\\clean')
        test_dirs.append(u"F:\\songbird_samples\\Testing\\" + unicode(cat) + '\\clean')

    return list_of_dirs, test_dirs


if __name__ == '__main__':
    # birds = ['bluejay_all', 'cardinal_all', 'cardinal_call', 'cardinal_song', 'chickadee_all', 'chickadee_call',
    # 'chickadee_song', 'crow_all', 'goldfinch_all', 'goldfinch_call', 'goldfinch_song', 'robin_all',
    # 'robin_call', 'robin_song', 'sparrow_all', 'sparrow_call',
    # 'sparrow_song', 'titmouse_all', 'titmouse_call', 'titmouse_song']
    birds = ['bluejay_all', 'cardinal_song', 'chickadee_song', 'crow_all', 'goldfinch_song', 'robin_song',
             'sparrow_song', 'titmouse_song']
    list_of_dirs, test_dirs = test_params(birds)
    model = 'gradientboosting'  # , 'knn', 'gradientboosting', 'randomforest', 'extratrees']
    modelName = '_'.join([model, 'allBirdsSongsOnly', 'cleanAudio'])
    print '\n', '\n', "Begin Train and Test for: ", modelName, '\n'
    train_and_test(list_of_dirs, test_dirs, modelName=modelName, classifierType=model, store_to_mySQL=True)
    print '\n', '\n', "End Train and Test for: ", modelName, '\n'
