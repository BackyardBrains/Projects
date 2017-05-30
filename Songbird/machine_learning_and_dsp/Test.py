def test_params(categories):
    list_of_dirs = []
    test_dirs = []
    for cat in categories:
        list_of_dirs.append(u"F:\\songbird_samples\\Training\\" + unicode(cat) + '\\clean')
        test_dirs.append(u"F:\\songbird_samples\\Testing\\" + unicode(cat) + '\\clean')

    return list_of_dirs, test_dirs


if __name__ == '__main__':
    list_of_dirs, test_dirs = test_params(
        ['bluejay_all', 'cardinal_all', 'chickadee_all', 'crow_all', 'goldfinch_all', 'robin_all',
         'sparrow_all', 'titmouse_all'])
    model = 'gradientboosting'  # , 'knn', 'gradientboosting', 'randomforest', 'extratrees']
    modelName = '_'.join([model, 'allBirdsSongsOnly', 'cleanAudio'])
    test_model(test_dirs, modelName=modelName, classifierType=model, store_to_mySQL=False)
