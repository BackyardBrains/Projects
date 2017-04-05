#! python


import getopt
import glob
import os
import sys

import MySQLdb
from pyAudioAnalysis import audioTrainTest as aT

from config import *


def classify(directory=os.getcwd(), model_file=os.path.join(os.getcwd(), 'model'), classifierType='gradientboosting'):
    for file in glob.glob("*.wav"):
        Result, P, classNames = aT.fileClassification(file, model_file, classifierType)
        with MySQLdb.connect(host=host, user=user, passwd=passwd,
                             db=database) as cur:  # config is in config.py: see above
            cur.execute("insert ")  # .........

if __name__ == '__main__':

    directory = os.getcwd()
    classifierType = 'gradientboosting'
    verbose = False

    try:
        opts, args = getopt.getopt(sys.argv[1:], "d:m:c:v", ["dir=", "model=", "classifier=", "verbose"])
    except getopt.GetoptError as err:
        # print help information and exit:
        print str(err)  # will print something like "option -a not recognized"
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-d", "--dir"):
            directory = arg
        elif opt in ("-m", "--model"):
            model_file = arg
        elif opt in ("-c", "--classifier"):
            classifierType = arg
        elif opt in ("-v", "--verbose"):
            verbose = True
        else:
            assert False, "unhandled option"

    model_file = os.path.join(directory, 'model')
    if not os.path.isfile(model_file):
        raise Exception("Model file:" + model_file + " not found!")

    if classifierType not in ('knn', 'svm', 'gradientboosting', 'randomforest', 'extratrees'):
        raise Exception(classifierType + " is not a valid model type!")
