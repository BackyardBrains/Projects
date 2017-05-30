from noise_removal import noise_removal_dir

rootdir = "C:\\Users\\zacha\\Desktop\\testign"

noise_removal_dir(rootdir, smoothingWindow=0.4, weight=0.4, sensitivity=0.4)
