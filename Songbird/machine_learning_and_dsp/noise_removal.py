import os
import shutil

import pyAudioAnalysis.audioBasicIO as audioBasicIO
import pyAudioAnalysis.audioSegmentation as aS
import scipy.io.wavfile as wavfile
import sox
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


def noise_removal(inputFile, smoothingWindow=0.4, weight=0.4, sensitivity=0.4, debug=True):
    if not os.path.isfile(inputFile):
        raise Exception("Input audio file not found!")

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

    tfs = sox.Transformer()
    full_inputFile_path = os.path.join(dir, inputFile)
    noise_profile_path = '.'.join([full_inputFile_path, 'prof'])
    tfs.noiseprof(full_inputFile_path, noise_profile_path)
    tfs.build(noise_out, '-n')
    tfs.clear_effects()
    tfs.noisered(noise_profile_path, amount=sensitivity)
    clean_out = os.path.join(dir, clean_dir, inputFile)
    tfs.build(activity_out, clean_out)

    if not debug:
        shutil.rmtree(os.path.join(dir, "noise"))
        shutil.rmtree(os.path.join(dir, "activity"))
        os.remove(noise_profile_path)

    return clean_out


def noise_removal_dir(rootdir, smoothingWindow=0.4, weight=0.4, sensitivity=0.4, debug=True):
    for root, dirs, files in os.walk(rootdir):
        for sub in dirs:
            if sub == 'activity' or sub == 'noise' or '_clean' in sub:
                shutil.rmtree(os.path.join(root, sub))
        for file in files:
            if file.endswith('.wav'):
                noise_removal(os.path.join(root, file), smoothingWindow=smoothingWindow, weight=weight,
                              sensitivity=sensitivity, debug=debug)
