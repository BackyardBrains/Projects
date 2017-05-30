import numpy
import glob
import os
import pickle
from sklearn.cluster import KMeans
import scipy.io.wavfile as wav
from python_speech_features import mfcc
from pyAudioAnalysis.audioTrainTest import listOfFeatures2Matrix

dirs = [    "C:\\Users\\zacha\\PycharmProjects\\untitled\\american_robin_songonly",
                    "C:\\Users\\zacha\\PycharmProjects\\untitled\\house_wren_songonly",
                    "C:\\Users\\zacha\\PycharmProjects\\untitled\\wood_thrush_songonly"]
#dirs= ["C:\\Users\\zacha\\PycharmProjects\\untitled\\samples"]
data = []
ids = []
for i in xrange(0, len(dirs)):  # Iterate through each test directory
    dir = dirs[i]
    os.chdir(dir)
    for file in glob.glob("*.npy"):
        features = numpy.load(file)
        ids.append(i)
        temp = []
        for f in features:
            temp.append(f[0])
        data.append(temp)



data = numpy.array(data)
[X, Y] = listOfFeatures2Matrix(data)
kmeans = KMeans(n_clusters=len(dirs)).fit(X,Y)
zero = [0,0,0]
one = [0,0,0]
two = [0,0,0]
#pickle.dump(kmeans, 'birds.km')
assert len(ids) == len(kmeans.labels_)
assert len(ids) == 180
for i in xrange(0,len(ids)):
    if ids[i] == 0:
        zero[kmeans.labels_[i]] += 1
    elif ids[i] == 1:
        one[kmeans.labels_[i]] += 1
    elif ids[i] == 2:
        two[kmeans.labels_[i]] += 1
    else:
        assert 0
print zero, one, two