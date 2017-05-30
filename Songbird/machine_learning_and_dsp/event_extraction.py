import glob
import os

from pyAudioAnalysis import audioBasicIO
from pyAudioAnalysis import audioSegmentation as aS
from scipy.io import wavfile


def event_extraction(classname, path=os.getcwd()):
    os.chdir(path)
    for inputFile in glob.glob("*.wav"):
        if not os.path.isfile(inputFile):
            raise Exception("Input audio file not found!")

        [Fs, x] = audioBasicIO.readAudioFile(inputFile)
        segmentLimits = aS.silenceRemoval(x, Fs, 0.05, 0.05, 1.0, 0.3, False)
        for i, s in enumerate(segmentLimits):
            if not os.path.exists(classname):
                os.makedirs(classname)
            strOut = os.path.join(path, classname, "{0:s}_{1:.3f}-{2:.3f}.wav".format(inputFile[0:-4], s[0], s[1]))
            wavfile.write(strOut, Fs, x[int(Fs * s[0]):int(Fs * s[1])])
    output_path = path + classname
    return output_path


if __name__ == '__main__':
    list_of_dirs = ["C:\\Users\\zacha\\PycharmProjects\\untitled\\amr_test",
                    "C:\\Users\\zacha\\PycharmProjects\\untitled\\blo_test",
                    "C:\\Users\\zacha\\PycharmProjects\\untitled\\hwr_test",
                    "C:\\Users\\zacha\\PycharmProjects\\untitled\\wth_test"]

    for dir in list_of_dirs:
        os.chdir(dir)
        current_folder_path, current_folder_name = os.path.split(os.getcwd())
        event_extraction(current_folder_name, dir)
