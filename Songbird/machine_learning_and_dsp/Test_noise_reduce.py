from noise_removal import noiseCleaner

if __name__ == '__main__':
    rootdir = "D:\\ML Recordings\\Cornell_trimmed"
    new_cleaner = noiseCleaner(verbose=True, num_threads=0)
    new_cleaner.noise_removal_dir(rootdir)
