# -*- coding: utf-8 -*-

import os
import sys


def sanatize_filenames(directory=unicode(os.getcwd()), verbose=False):
    if verbose:
        print "Now sanitizing filenames in root directory: ", directory, '\n'
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.mp3') or file.endswith('MP3'):
                filename, fileextension = os.path.splitext(file)
                new_filename = ''.join(e for e in filename if e.isalnum()) + '.mp3'
                file = os.path.join(root, file)
                new_filename = os.path.join(root, new_filename)
                while (os.path.exists(new_filename)):
                    new_filename += '1.mp3'
                if file != new_filename:
                    os.rename(file, new_filename)
                if verbose:
                    print new_filename

    if verbose:
        print ''


if __name__ == '__main__':
    directory = unicode(os.getcwd())
    if len(sys.argv) > 1:
        directory = sys.argv[1]

    sanatize_filenames(directory)
