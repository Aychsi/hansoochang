#!/bin/bash
# Script to recreate the conda environment with all required packages

# Remove the corrupted environment
conda env remove -p "/Users/hansoochang/Library/CloudStorage/OneDrive-DrexelUniversity/Finance_Project/.conda" -y

# Create a new conda environment
conda create -p "/Users/hansoochang/Library/CloudStorage/OneDrive-DrexelUniversity/Finance_Project/.conda" python=3.11 -y

# Install required packages
conda install -p "/Users/hansoochang/Library/CloudStorage/OneDrive-DrexelUniversity/Finance_Project/.conda" \
    ipykernel jupyter pandas numpy scipy scikit-learn -y

# Register the kernel
"/Users/hansoochang/Library/CloudStorage/OneDrive-DrexelUniversity/Finance_Project/.conda/bin/python" -m ipykernel install --user --name=.conda --display-name "Python 3.11.14 (.conda)"

echo "Environment created successfully!"
