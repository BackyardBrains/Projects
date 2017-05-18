import os
import shutil
import sys

import pathos.multiprocessing as mp
import pyAudioAnalysis.audioBasicIO as audioBasicIO
import pyAudioAnalysis.audioSegmentation as aS
import scipy.io.wavfile as wavfile
import sox
from pathos.multiprocessing import Pool
from pydub import AudioSegment


def create_subdirectory(dir, subdir):
    if not os.path.exists(os.path.join(dir, subdir)):
        os.makedirs(os.path.join(dir, subdir))


# https://stackoverflow.com/questions/2890703/how-to-join-two-wav-files-using-python
def recombine_wavfiles(infiles, outfile):
    sound = [AudioSegment.from_wav(infile) for infile in infiles]
    sound = sum(sound)

    sound.export(outfile, format="wav")

    for file in infiles:
        os.remove(file)


class noiseCleaner:
    def __init__(self, smoothingWindow=0.4, weight=0.4, sensitivity=0.4, debug=True,
                 verbose=False, num_threads=mp.cpu_count()):
        self.smoothingWindow = smoothingWindow
        self.weight = weight
        self.sensitivity = sensitivity
        self.debug = debug
        self.verbose = verbose
        self.num_threads = num_threads

    def noise_removal(self, inputFile):
        smoothingWindow = self.smoothingWindow
        weight = self.weight
        sensitivity = self.sensitivity
        debug = self.debug
        verbose = self.verbose

        if verbose:
            print inputFile

        if not os.path.isfile(inputFile):
            raise Exception(inputFile + " not found!")

        [Fs, x] = audioBasicIO.readAudioFile(inputFile)  # read audio signal

        dir, inputFile = os.path.split(inputFile)

        create_subdirectory(dir, 'noise')
        create_subdirectory(dir, 'activity')

        root, current_sub_dir = os.path.split(dir)
        clean_dir = '_'.join([current_sub_dir, 'clean'])
        create_subdirectory(dir, clean_dir)

        segmentLimits = aS.silenceRemoval(x, Fs, 0.05, 0.05, smoothingWindow, weight, False)  # get onsets
        prev_end = 0
        activity_files = []
        noise_files = []
        for i, s in enumerate(segmentLimits):
            strOut = os.path.join(dir, "noise", "{0:s}_{1:.3f}-{2:.3f}.wav".format(inputFile[0:-4], prev_end, s[0]))
            wavfile.write(strOut, Fs, x[int(Fs * prev_end):int(Fs * s[0])])
            noise_files.append(strOut)

            strOut = os.path.join(dir, "activity", "{0:s}_{1:.3f}-{2:.3f}.wav".format(inputFile[0:-4], s[0], s[1]))
            wavfile.write(strOut, Fs, x[int(Fs * s[0]):int(Fs * s[1])])
            activity_files.append(strOut)

            prev_end = s[1]

        strOut = os.path.join(dir, "noise", "{0:s}_{1:.3f}-{2:.3f}.wav".format(inputFile[0:-4], prev_end, len(x) / Fs))
        wavfile.write(strOut, Fs, x[int(Fs * prev_end):len(x) / Fs])
        noise_files.append(strOut)

        activity_out = os.path.join(dir, "activity", inputFile)
        noise_out = os.path.join(dir, "noise", inputFile)

        recombine_wavfiles(noise_files, noise_out)
        recombine_wavfiles(activity_files, activity_out)

        try:
            tfs = sox.Transformer()
            noise_profile_path = '.'.join([noise_out, 'prof'])
            tfs.noiseprof(noise_out, noise_profile_path)
            tfs.build(noise_out, '-n')
            tfs.clear_effects()
            tfs.noisered(noise_profile_path, amount=sensitivity)
            clean_out = os.path.join(dir, clean_dir, inputFile)
            tfs.build(activity_out, clean_out)

        except:
            sys.stderr.write("Sox error in noise reduction of file: %s" % os.path.join(dir, inputFile))
            sys.exit(1)

        if not debug:
            shutil.rmtree(os.path.join(dir, "noise"))
            shutil.rmtree(os.path.join(dir, "activity"))

        return clean_out

    def noise_removal_dir(self, rootdir):

        num_threads = self.num_threads

        if not os.path.exists(rootdir):
            raise Exception(rootdir + " not found!")

        for root, dirs, files in os.walk(rootdir):
            parent, folder_name = os.path.split(root)
            if folder_name == 'activity' or folder_name == 'noise' or '_clean' in folder_name:
                shutil.rmtree(root)
        num_samples_processed = 0
        wav_files = []
        for root, dirs, files in os.walk(rootdir):
            for file in files:
                if file.endswith('.wav'):
                    wav_files.append(os.path.join(root, file))
                    num_samples_processed += 1

        print "Now beginning preprocessing for: ", num_samples_processed, " samples."

        pros = Pool(num_threads)
        pros.map(self.noise_removal, wav_files)

        print "Preprocessing complete!\n"
