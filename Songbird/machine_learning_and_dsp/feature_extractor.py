from pyAudioAnalysis.audioFeatureExtraction import mtFeatureExtractionToFileDir

list_of_dirs = [    "C:\\Users\\zacha\\PycharmProjects\\untitled\\american_robin_songonly",
                    "C:\\Users\\zacha\\PycharmProjects\\untitled\\house_wren_songonly",
                    "C:\\Users\\zacha\\PycharmProjects\\untitled\\wood_thrush_songonly"]


for dir in list_of_dirs:
    mtFeatureExtractionToFileDir(dir, 1.0, 1.0, 0.05, 0.05, storeStFeatures=False, storeToCSV=False, PLOT=False)