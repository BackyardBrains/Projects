import glob
import os
import time
from hashlib import md5
from operator import truediv

import MySQLdb
import numpy as np
from pyAudioAnalysis import audioTrainTest as aT

from config import *  # Set mysql parameter is a file called config.py: host=, user=, passwd=, database=


def unshared_copy(inList):
    #https://stackoverflow.com/questions/1601269/how-to-make-a-completely-unshared-copy-of-a-complicated-list-deep-copy-is-not
    if isinstance(inList, list):
        return list( map(unshared_copy, inList) )
    return inList


def test_model(test_dirs, model_dir=os.getcwd(), modelName='Test', classifierType='svm', level=0.7,
               store_to_mySQL=False):
    # Used to test an existing model against new samples;
    # Test directories should contain the same categories and be in the same order as the original training data, but should contain seperate samples
    # model_dir is the path to the model file generated by the training function
    # modelName is the name of the model file generated by the trainging function
    # classifierType is the ML method used and should be the same as the training method used. Should be one of: svm, knn, gradientboosting, randomforest, extratrees
    # certainty_threshold: Any results with confidence below this should be treated as indeterminate
    # Level is confidence threshold above which test results should be considered
    # When store_to_mySQL is set to True results will be pushed to mySQL table specified in config.py

    # The following sets up a new table in the given db to store information about each classification; The table will be given the same name as the model file; the table will be dropped initially if a table with the same name already exists.

    start_time = time.clock()

    modelName = '_'.join([classifierType, modelName])

    table_setup = '(filename VARCHAR(1024), class VARCHAR(1024), identifiedCorrectly VARCHAR(1024), confidence DOUBLE, PRIMARY KEY (filename));'

    if store_to_mySQL:
        with MySQLdb.connect(host=host, user=user, passwd=passwd,
                             db=database) as cur:  # config is in config.py: see above

            try:
                cur.execute("DROP TABLE " + modelName)
            except:
                pass

            cur.execute("CREATE TABLE " + modelName + table_setup)

    temp = []
    for j in test_dirs:
        temp.append(0)
    confusion_matrix = []
    for k in test_dirs:
        confusion_matrix.append(unshared_copy(temp))

    confidence_above_90 = unshared_copy(temp)
    correct_above_90 = unshared_copy(temp)
    total_num_samples = unshared_copy(temp)
    confidence_corrected_con_matrix = unshared_copy(confusion_matrix)
    for i in xrange(0, len(test_dirs)):  # Iterate through each test directory
        dir = test_dirs[i]
        os.chdir(dir)
        for file in glob.glob("*.wav"):  # Iterate through each wave file in the directory
            Result, P, classNames = aT.fileClassification(file, os.path.join(model_dir, modelName),
                                                          classifierType)  # Test the file

            if classNames == -1:
                raise Exception("Model file " + os.path.join(model_dir, modelName) + " not found!")

            if store_to_mySQL:
                current_file_results = {
                    'filename': str(md5(file).hexdigest()),
                    'class': str(classNames[i]),
                    'identifiedCorrectly': str(Result == float(i)).upper(),
                    'confidence': str(max(P))
                }
                with MySQLdb.connect(host=host, user=user, passwd=passwd, db=database) as cur:
                    insert_statement = "INSERT INTO " + modelName + " (filename, class, identifiedCorrectly, confidence) VALUES (\'" + \
                                       current_file_results['filename'] + "\', \'" + current_file_results[
                                           'class'] + '\', ' + current_file_results['identifiedCorrectly'] + ', ' + \
                                       current_file_results['confidence'] + ");"
                    cur.execute(insert_statement)

            total_num_samples[i] += 1
            confusion_matrix[i][int(Result)] += 1
            if max(P) > level:
                confidence_corrected_con_matrix[i][int(Result)] += 1
                confidence_above_90[i] += 1
                if Result == float(i):
                    correct_above_90[i] += 1

    acc_above_90 = map(truediv, correct_above_90, confidence_above_90)
    percent_desicive_samples = map(truediv, confidence_above_90, total_num_samples)

    print classNames
    print "acc above ", level, ": ", acc_above_90
    print "percent samples above ", level, ": ", percent_desicive_samples, '\n'
    print "confusion matrix:"
    aT.printConfusionMatrix(np.array(confusion_matrix), classNames)
    print "\n", "confidence adjusted confustion matrix:"
    aT.printConfusionMatrix(np.array(confidence_corrected_con_matrix), classNames)

    print '\n', "Processed ", sum(total_num_samples), " samples in ", time.clock() - start_time, " seconds."
