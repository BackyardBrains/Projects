from test_model import *
from twillio_test import *


def test_params(categories):
    list_of_dirs = []
    test_dirs = []
    for cat in categories:
        list_of_dirs.append("F:\\songbird_samples\\Training\\" + cat)
        test_dirs.append("F:\\songbird_samples\\Testing\\" + cat)

    return list_of_dirs, test_dirs


if __name__ == '__main__':
    list_of_dirs, test_dirs = test_params(
        ['bluejay_all', 'cardinal_song', 'chickadee_song', 'crow_all', 'goldfinch_song', 'robin_song', 'sparrow_song',
         'titmouse_song'])
    models = ['svm']  # , 'knn', 'gradientboosting', 'randomforest', 'extratrees']
    modelName = "all8songsonlytest0"
    for model in models:
        test_model(test_dirs, modelName=modelName, classifierType=model, store_to_mySQL=True)

