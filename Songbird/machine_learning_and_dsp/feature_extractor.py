from pyAudioAnalysis.audioFeatureExtraction import mtFeatureExtractionToFileDir

list_of_dirs = ["/home/zach/Documents/bird_samples/titmouse_song_clean"]


for dir in list_of_dirs:
    mtFeatureExtractionToFileDir(dir, 1.0, 1.0, 0.05, 0.05, storeStFeatures=True, storeToCSV=True, PLOT=True)
