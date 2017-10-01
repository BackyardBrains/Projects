from noise_removal import noiseCleaner

if __name__ == '__main__':
    rootdir = "/home/zach/Dropbox/7-21-17"
    new_cleaner = noiseCleaner(verbose=True, debug=True)
    new_cleaner.noise_removal_dir(rootdir)
