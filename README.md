# Lung 3D-Segmentation in CT scans for 2021/2022 Medical Images course


- ###  Raffaele Berzoini  ([@RaffaeleBerzoini](https://github.com/RaffaeleBerzoini)) <br> raffaele.berzoini@mail.polimi.it
- ###  Aurora Anna Francesca Colombo ([@AuroraColombo](https://github.com/AuroraColombo)) <br> auroraanna.colombo@mail.polimi.it
- ###  Davide Console ([@Davide-Console](https://github.com/Davide-Console)) <br> davide.console@mail.polimi.it



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
