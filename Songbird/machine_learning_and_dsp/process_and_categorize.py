#! python


import os
import shutil
import time
from zlib import crc32

import MySQLdb
import pathos.multiprocessing as mp
from pathos.multiprocessing import Pool
from pyAudioAnalysis import audioTrainTest as aT

from config import *
from noise_removal import noiseCleaner


class classiFier:
    def __init__(self, directory=os.getcwd(), model_file=os.path.join(os.getcwd(), 'model'),
                 classifierType='gradientboosting',
                 verbose=False, num_threads=mp.cpu_count()):
        self.directory = directory
        self.model_file = model_file
        self.classifierType = classifierType
        self.verbose = verbose
        self.num_threads = num_threads

    def classify(self):
        directory = self.directory
        num_threads = self.num_threads

        wav_files = []
        for file in os.listdir(directory):
            if file.endswith('.wav'):
                file = os.path.join(directory, file)
                wav_files.append(file)

        pros = Pool(num_threads)
        pros.map(self.classFile, wav_files)
        shutil.rmtree(os.path.join(directory, "noise"))
        shutil.rmtree(os.path.join(directory, "activity"))

    def classFile(self, file):
        model_file = self.model_file
        classifierType = self.classifierType
        verbose = self.verbose

        added = os.path.getmtime(file)
        added = time.gmtime(added)
        added = time.strftime('\'' + '-'.join(['%Y', '%m', '%d']) + ' ' + ':'.join(['%H', '%M', '%S']) + '\'',
                              added)

        cleaner = noiseCleaner(verbose=verbose)
        clean_wav = cleaner.noise_removal(file)
        Result, P, classNames = aT.fileClassification(clean_wav, model_file, classifierType)
        if verbose:
            print file
            print Result
            print classNames
            print P, '\n'

        result_dict = {}
        for i in xrange(0, len(classNames)):
            result_dict[classNames[i]] = P[i]

        result_dict = sorted(result_dict.items(), key=lambda x: x[1], reverse=True)

        sample_id = crc32(file)
        device_id = -1  # tbi
        latitude = -1  # tbi
        longitute = -1  # tbi
        humidity = -1  # tbi
        temp = -1  # tbi
        light = -1  # tbi
        type1 = '\'' + result_dict[0][0] + '\''
        type2 = '\'' + result_dict[1][0] + '\''
        type3 = '\'' + result_dict[2][0] + '\''
        per1 = result_dict[0][1]
        per2 = result_dict[1][1]
        per3 = result_dict[2][1]

        values = [sample_id, device_id, added, latitude, longitute, humidity, temp, light, type1, per1, type2,
                  per2,
                  type3, per3]
        values = [str(x) for x in values]

        with MySQLdb.connect(host=host, user=user, passwd=passwd,
                             db=database) as cur:  # config is in config.py: see above
            query_text = "INSERT INTO sampleInfo (sampleid, deviceid, added, latitude, longitude, humidity, temp, light, type1, per1, type2, per2, type3, per3) values(" + ','.join(
                values) + ");"
            cur.execute(query_text)

    def export(self):
        try:
            export_file = str(time.time())
            if os.system(
                            "mysqldump -u %s -p %s --password=%s --skip-add-drop-table --no-create-info --skip-add-locks > export/%s.sql" % (
                            user, database, passwd, export_file)):
                raise Exception("mysqldump export failed!")
        except:
            raise
        else:
            with MySQLdb.connect(host=host, user=user, passwd=passwd,
                                 db=database) as cur:
                cur.execute("DROP DATABASE %s;" % database)
                cur.execute("CREATE DATABASE %s;" % database)

            tbl_create = os.path.join(os.getcwd(), 'tbl_create.sql')
            if os.system("mysql -u %s -p %s --password=%s < %s" % (user, database, passwd, tbl_create)):
                raise Exception("tbl_create.sql error!")
