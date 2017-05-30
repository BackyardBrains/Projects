import numpy
import glob
import os
import pickle
from sklearn.cluster import KMeans
import scipy.io.wavfile as wav
from python_speech_features import mfcc
from pyAudioAnalysis.audioTrainTest import listOfFeatures2Matrix
from scipy.stats import mode

dirs = [    "C:\\Users\\zacha\\PycharmProjects\\untitled\\american_robin_songonly",
                    "C:\\Users\\zacha\\PycharmProjects\\untitled\\house_wren_songonly",
                    "C:\\Users\\zacha\\PycharmProjects\\untitled\\wood_thrush_songonly"]
#dirs= ["C:\\Users\\zacha\\PycharmProjects\\untitled\\samples"]
data = []
for i in xrange(0, len(dirs)):  # Iterate through each test directory
    dir = dirs[i]
    os.chdir(dir)
    for file in glob.glob("*.wav"):
        (rate, sig) = wav.read(file)
        mfcc_feat = mfcc(sig, rate)
        data.append(mfcc_feat)



data = numpy.array(data)
[X, Y] = listOfFeatures2Matrix(data)
kmeans = KMeans(n_clusters=len(dirs)).fit(X,Y)

result_matrix = [[0,0,0],[0,0,0],[0,0,0]]
for i in xrange(0, len(dirs)):  # Iterate through each test directory
    dir = dirs[i]
    os.chdir(dir)
    num_tested=0
    num_correct=0
    for file in glob.glob("*.wav"):
        (rate, sig) = wav.read(file)
        mfcc_feat = mfcc(sig, rate)
        predictions = kmeans.predict(mfcc_feat)
        result = mode(predictions).mode[0]
        result_matrix[i][result] += 1

print result_matrix


