# This directory **miniproject** contains the following subdirectories and contents:
### **code**
- **data_prep.R** - R script that wrangles the "../data/LogisticGrowthData.csv" file, outputting the "../data/data_modified.csv" file
- **model_fit.R** - R script that fits models to the data prepared above, and outputs results and figures of the fitted models
- **plots.R** - R script that plots the figure "combined.png" for the LaTeX report file.
- **report.tex** - The project report LaTeX file
- **compile.sh** - BASH script which compiles the report.tex file
- **run_MiniProject.sh** - BASH scipt which runs the above scripts when executed in the command line

### **data**
- **LogisticGrowthData.csv** - The raw data used in this analysis, containing 4387 rows of bacterial growth data, each with a citation of where the data originated from
- **LogisticGrowthMetaData.csv** - Metadata which explains the above dataset

### **results**
empty until code runs

### **sandbox**
empty, used for test files

# Software and Dependencies
### **R (version 4.1.2)**
- **tidyverse** - Improved data wrangling and plotting of data
- **patchwork** - Modification of plotted graphs
- **minpack.lm** - Improved modelling of NLLS models

# Author
- Tianle Shao
- ts920@ic.ac.uk