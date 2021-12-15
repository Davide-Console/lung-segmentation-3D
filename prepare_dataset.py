import os
import zipfile


def main(n, x):
    dirpath = 'dataset/T_50/CT'

    for dirs, dirnames, filenames in os.walk(dirpath):

        filenames.sort()
        for filename in filenames:

            path = os.path.join(dirs, filename)
            newpath = os.path.join(dirs, str(n) + '.dcm')

            if filename.endswith(str(x) + '.dcm'):
                os.rename(path, newpath)
                x += 1
                n += 1


if __name__ == '__main__':
    if os.path.exists('Resources.zip') and not os.path.exists('dataset'):
        print("Extracting zip folder")
        zip_ref = zipfile.ZipFile('Resources.zip', 'r')
        os.mkdir('dataset')
        zip_ref.extractall('dataset/')
        zip_ref.close()
        # os.rename('Resources', 'dataset')
    main(1, 1930)
    main(53, 1846)
