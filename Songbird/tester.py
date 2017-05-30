import os
import time
import pathos.multiprocessing as mp
from pathos.multiprocessing import Pool
from pyAudioAnalysis import audioTrainTest as aT
import glob

class tester:
    def __init__(self, dirs, model_file, classifierType='gradientboosting', threshold=0.7,
                 verbose=False, num_threads=mp.cpu_count()):
        self.dirs = dirs
        self.model_file = model_file
        self.classifierType = classifierType
        self.threshold = threshold
        self.verbose = verbose
        self.num_threads = num_threads

    def test(self):
        dirs = self.dirs
        model_file = self.model_file
        classifierType = self.classifierType
        threshold = self.threshold
        verbose = self.verbose

