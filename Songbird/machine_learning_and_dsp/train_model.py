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
    list_of_dirs = ["C:\\Users\\zacha\\PycharmProjects\\untitled\\american_robin",
                    "C:\\Users\\zacha\\PycharmProjects\\untitled\\baltimore_oriole",
                    "C:\\Users\\zacha\\PycharmProjects\\untitled\\house_wren",
                    "C:\\Users\\zacha\\PycharmProjects\\untitled\\wood_thrush"]
    test_dirs = ["C:\\Users\\zacha\\PycharmProjects\\untitled\\american_robin_test\\",
                 "C:\\Users\\zacha\\PycharmProjects\\untitled\\baltimore_oriole_test\\",
                 "C:\\Users\\zacha\\PycharmProjects\\untitled\\house_wren_test\\",
                 "C:\\Users\\zacha\\PycharmProjects\\untitled\\wood_thrush_test\\"]
    model_dir = os.getcwd() + '\\'
    train_and_test(list_of_dirs, test_dirs, model_dir, mtWin=1.0, mtStep=1.0, stWin=0.05,
                   stStep=0.05, useBeatmap=True)
