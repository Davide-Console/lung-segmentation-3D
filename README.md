# Lung 3D-Segmentation in CT scans for 2021/2022 Medical Images course

## Abstract
Automated solutions to accelerate and standardize diagnostic processes are essential in many medical procedures. This project focuses on semantic segmentation for identifying specific regions within biomedical images. We developed an automatic algorithm for lung segmentation and boundary detection using CT volumes.

## Introduction
Computed Tomography (CT) is the primary tool for pulmonary imaging, providing high spatial and temporal resolution and excellent contrast. CT volumes allow for effective lung segmentation and boundary detection. Our method employs a series of steps for Region of Interest (ROI) detection and extraction.

## Materials and Methods

### Dataset
The dataset consists of ten CT scans of the same patient recorded at different time steps.

### Algorithm
The algorithm processes the 3D volume slice by slice and extracts the lungs by analyzing the entire volume. The core steps are:

1. Loading DICOM image
2. Noise reduction using filters
3. Contrast adjustment
4. Image binarization
5. Removing white elements inside the lungs using `imerode`
6. Extracting the largest component using `getLargestCc`
7. Converting lungs to 1 by complementing the image
8. Filling the background with zeros to keep only the lungs
9. Extracting lungs from the original image using the mask
10. Performing edge detection with Sobel kernel

![Algorithm Steps](path/to/algorithm_steps_image.png)
*Fig. 1: Algorithm steps*

## Results

Our algorithm achieves good and consistent lung segmentation using simple approaches without requiring expensive computations like deep learning techniques. It remains reliable across different time frames.

![3D Lungs Extraction](path/to/3d_lungs_extraction_image.png)
*Fig. 3: 3D-Lungs extraction visualization*

The algorithm performed best on the axial view due to higher spatial resolution. The robustness of the algorithm is demonstrated by consistent lung volume measurements across different time instances.

![Lungs Volume Variation](path/to/lungs_volume_variation_image.png)
*Fig. 2: Lungs volume variation along time*

## Conclusion

Future work could involve more complex preprocessing to adapt the algorithm to different diagnostic techniques.





<details>
    <summary>Instructions</summary>

## Setup 

- Open a command prompt and execute:
    ```console
    git clone https://github.com/RaffaeleBerzoini/lung-segmentation-3D.git
    cd lung-segmentation-3D/
    ```
- Go to the [dataset](https://data.kitware.com/#collection/579787098d777f1268277a27/folder/5aa313db8d777f0685786472
) page, select all the folder from _T_0_ to _T_90_ and download them
- The download should be named _Resources.zip_
- Move the zip file in the the `lung-segmentation-3D` folder that contains all the `.m` files.

The working directory should look similar to:

```text
lung-segmentation-3D   # your WRK_DIR
.
├── prepare_dataset.py
├── Resources.zip
└── .m files
```

- Open a command prompt and execute:
  ```console
    python prepare_dataset.py
  ```

Now your working directory should be:

```text
lung-segmentation-3D   # your WRK_DIR
.
├── prepare_dataset.py
├── Resources.zip
└── .m files
└── dataset
        ├── T_0
        ├── ...
        └── T_90
              ├── CT
              |    └── .dcm files
              └── liver segmentation
```  

## Execution

- Once the project has been downloaded and the dataset prepared, head into the project working directory and execute on the MATLAB command prompt: 
    ```shell
    >> main
    ```
    
The script will open and process all the CT scans and a plot of the lungs' volume will be shown at the end of the execution.

Once the script has been executed you will find on the MATLAB command prompt a short guide on how to access all the processed data with some examples for 3D visualization. 

</details>


## Authors
- Raffaele Berzoini  
- Aurora Anna Francesca Colombo  
- Davide Console  
