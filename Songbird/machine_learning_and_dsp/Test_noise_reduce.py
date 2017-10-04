import os
if __name__ == '__main__':
    rootdir = "F:\\bird_model_2\\WC_BIRDS_testing"
    # new_cleaner = noiseCleaner(verbose=True)
    # new_cleaner.noise_removal_dir(rootdir)
    for root, dirs, files in os.walk(rootdir):
        print dirs
