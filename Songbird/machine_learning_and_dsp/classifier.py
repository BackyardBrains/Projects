import getopt
import os
import sys

from process_and_categorize import classiFier

if __name__ == '__main__':

    directory = os.getcwd()
    classifierType = 'gradientboosting'
    birds = []
    verbose = False
    model_file = os.path.join(directory, 'model')
    export = False
    run = False

    try:
        opts, args = getopt.getopt(sys.argv[1:], "d:m:c:b:ver",
                                   ["dir=", "model=", "classifier=", "verbose", "export", "run"])
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
        elif opt in ("-e", "--export"):
            export = True
        elif opt in ("-r", "--run"):
            run = True
        else:
            assert False, "unhandled option"

    if not os.path.isfile(model_file):
        raise Exception("Model file:" + model_file + " not found!")

    if classifierType not in ('knn', 'svm', 'gradientboosting', 'randomforest', 'extratrees'):
        raise Exception(classifierType + " is not a valid model type!")

    classifier0 = classiFier(directory, model_file, classifierType, verbose=verbose)
    if run:
        classifier0.classify()
    if export:
        classifier0.export()
    if not run and not export:
        sys.stderr.write("No operator flags set: exiting!")
        exit(1)
