import os

def main(n, x):
    dirpath = 'dataset/T_50/CT'
    
    for dirs, dirnames, filenames in os.walk(dirpath):

        for filename in filenames:

            path = os.path.join(dirs, filename)
            newpath = os.path.join(dirs, str(n)+'.dcm')

            if filename.endswith(str(x)+'.dcm'):
                os.rename(path, newpath)
                x += 1
                n += 1



if __name__ == '__main__':
    main(1, 1930)
    main(53, 1846)
