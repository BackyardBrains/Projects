from noise_removal import noiseCleaner

rootdir = "/home/zach/Documents/cleaner_test"
new_cleaner = noiseCleaner(smoothingWindow=0.1, weight=0.3, sensitivity=0.3, num_threads=1)
new_cleaner.noise_removal_dir(rootdir)
