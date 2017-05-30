from noise_removal import noise_removal_dir
rootdir = "/home/zach/Documents/bird_samples"

noise_removal_dir(rootdir, smoothingWindow=0.4, weight=0.4, sensitivity=0.4)
