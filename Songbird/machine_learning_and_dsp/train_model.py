import os

from pyAudioAnalysis import audioTrainTest

from test_model import test_model


def train_model(list_of_dirs, mtWin=1.0, mtStep=1.0, stWin=audioTrainTest.shortTermWindow,
                stStep=audioTrainTest.shortTermStep, classifierType='svm', modelName='Test', useBeatmap=False):
    # Trains a new classification model see audioTrainTest.py in pyaudioanalysis library for details
    audioTrainTest.featureAndTrain(list_of_dirs, mtWin, mtStep, stWin, stStep, classifierType,
                                   '_'.join([classifierType, modelName]), useBeatmap)


def train_and_test(list_of_dirs, test_dirs, model_dir=os.getcwd(), mtWin=1.0, mtStep=1.0,
                   stWin=audioTrainTest.shortTermWindow,
                   stStep=audioTrainTest.shortTermStep, classifierType='svm', modelName='svmTest', useBeatmap=False,
                   store_to_mySQL=False):
    # automatically trains a new model and then tests it using a seperate dataset, see test_model.py
    train_model(list_of_dirs, mtWin, mtStep, stWin, stStep, classifierType, modelName, useBeatmap)
    test_model(test_dirs, model_dir, modelName, classifierType, store_to_mySQL=store_to_mySQL)
    # send_notification('test and train complete') #sms notification; see twillio_test.py