from pyAudioAnalysis import audioTrainTest

from test_model import tester


def train_model(list_of_dirs, mtWin=1.0, mtStep=1.0, stWin=audioTrainTest.shortTermWindow,
                stStep=audioTrainTest.shortTermStep, classifierType='gradientboosting', modelName='Test',
                useBeatmap=False):
    # Trains a new classification model see audioTrainTest.py in pyaudioanalysis library for details
    audioTrainTest.featureAndTrain(list_of_dirs, mtWin, mtStep, stWin, stStep, classifierType,
                                   '_'.join([classifierType, modelName]), useBeatmap)


def train_and_test(list_of_dirs, test_dirs, mtWin=1.0, mtStep=1.0,
                   stWin=audioTrainTest.shortTermWindow,
                   stStep=audioTrainTest.shortTermStep, classifierType='gradientboosting',
                   modelName='gradientboostingTest', useBeatmap=False):
    # automatically trains a new model and then tests it using a seperate dataset, see test_model.py
    train_model(list_of_dirs, mtWin, mtStep, stWin, stStep, classifierType, modelName, useBeatmap)
    t1 = tester(test_dirs, modelName=modelName, classifierType=classifierType)
    # send_notification('test and train complete') #sms notification; see twillio_test.py