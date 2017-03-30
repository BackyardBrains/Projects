from pyAudioAnalysis import audioTrainTest as aT
from noise_removal import noise_removal
import glob
import os


def clean_and_test(test_wav, model_file, classifierType='gradientboosting'):
    clean_wav = noise_removal(test_wav, debug=False)
    Result, P, classNames = aT.fileClassification(clean_wav, model_file, classifierType)
    return Result, P, classNames

if __name__ == '__main__':
    for file in glob.glob(u"*.wav"):
        Result, P, classNames = clean_and_test(file, os.path.join(os.getcwd(), 'model'))
        print file
        print Result
        print classNames
        print P
        print '\n'




