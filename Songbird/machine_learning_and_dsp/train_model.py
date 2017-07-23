from pyAudioAnalysis import audioTrainTest

from test_model import tester


def train_model(list_of_dirs, mtStep=0.4, mtWin=0.4, stStep=0.04, stWin=0.04, classifierType='gradientboosting',
                modelName='Test',
                useBeatmap=False):
    # Trains a new classification model see audioTrainTest.py in pyaudioanalysis library for details
    audioTrainTest.featureAndTrain(list_of_dirs, mtWin, mtStep, stWin, stStep, classifierType,
                                   '_'.join([classifierType, modelName]), useBeatmap)


def train_and_test(list_of_dirs, test_dirs, mtStep=0.4, mtWin=0.4, stStep=0.04, stWin=0.04,
                   classifierType='gradientboosting',
                   modelName='gradientboostingTest', useBeatmap=False):
    # automatically trains a new model and then tests it using a seperate dataset, see test_model.py
    train_model(list_of_dirs, mtWin, mtStep, stWin, stStep, classifierType, modelName, useBeatmap)
    t1 = tester(test_dirs, modelName='_'.join([classifierType, modelName]), classifierType=classifierType)
    t1.test_model()
    # send_notification('test and train complete') #sms notification; see twillio_test.py