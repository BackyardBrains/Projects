import os

from pyAudioAnalysis import audioTrainTest

from test_model import test_model


def train_model(list_of_dirs, mtWin=1.0, mtStep=1.0, stWin=audioTrainTest.shortTermWindow,
                stStep=audioTrainTest.shortTermStep, classifierType='svm', modelName='svmTest', useBeatmap=False):
    # Trains a new classification model see audioTrainTest.py in pyaudioanalysis library for details
    audioTrainTest.featureAndTrain(list_of_dirs, mtWin, mtStep, stWin, stStep, classifierType, modelName, useBeatmap)


def train_and_test(list_of_dirs, test_dirs, model_dir, mtWin=1.0, mtStep=1.0, stWin=audioTrainTest.shortTermWindow,
                   stStep=audioTrainTest.shortTermStep, classifierType='svm', modelName='svmTest', useBeatmap=False):
    # automatically trains a new model and then tests it using a seperate dataset, see test_model.py
    train_model(list_of_dirs, mtWin, mtStep, stWin, stStep, classifierType, modelName, useBeatmap)
    test_model(test_dirs, model_dir, modelName, classifierType)
    # send_notification('test and train complete') #sms notification; see twillio_test.py


if __name__ == '__main__':
    list_of_dirs = ["F:\\songbird_samples\\Training\\cardinal_song", "F:\\songbird_samples\\Training\\sparrow_song", "F:\\songbird_samples\\Training\\titmouse_song"]
    test_dirs = ["F:\\songbird_samples\\Testing\\cardinal_song", "F:\\songbird_samples\\Testing\\sparrow_song",  "F:\\songbird_samples\\Testing\\titmouse_song"]
    model_dir = os.getcwd() + '\\'
    models = ['svm']  # , 'knn', 'gradientboosting', 'randomforest', 'extratrees']
    for model in models:
        train_and_test(list_of_dirs, test_dirs, model_dir, mtWin=1.0, mtStep=1.0, stWin=0.05,
                       stStep=0.05, useBeatmap=False, modelName=model + '_cardinal_sparrow_titmouse_0', classifierType=model)
