import os
import sys


def sanatize_filenames(directory=os.getcwd(), verbose=False):
    os.chdir(directory)
    if verbose:
        print "Now sanitizing filenames in root directory: ", directory, '\n'
    for root, dirs, files in os.walk(os.getcwd()):
        for file in files:
            if file.endswith('.wav'):
                filename, fileextension = os.path.splitext(file)
                new_filename = ''.join(e for e in filename if e.isalnum()) + '.wav'
                file = os.path.join(root, file)
                new_filename = os.path.join(root, new_filename)
                os.rename(file, new_filename)
                if verbose:
                    print new_filename

    if verbose:
        print ''


if __name__ == '__main__':
    directory = os.getcwd()
    if len(sys.argv) > 1:
        directory = sys.argv[1]

    sanatize_filenames(directory)
