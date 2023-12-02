#!/bin/bash

# 1. Run data preparation script
Rscript data_prep.R

# 2. Run model fitting script
Rscript model_fit.R

# 3. Run plot script
Rscript plots.R

# 3. Run Latex compilation script
chmod +x compile.sh
./compile.sh report.tex