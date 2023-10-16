import pandas as pd
import numpy as np


PSI_matrix = pd.concat([PSI_matrix, PSI_value_matrix], axis = 1)
PSI_matrix.shape
PSI_matrix

PSI_matrix_filtered = PSI_matrix[PSI_matrix['Chr'] != "chrY"]
PSI_matrix_filtered = PSI_matrix_filtered[PSI_matrix_filtered['Chr'] != "chrX"]
PSI_matrix_filtered = PSI_matrix_filtered[PSI_matrix_filtered['Chr'] != "chrM"]
PSI_matrix_filtered.shape

NA_P = np.isnan(PSI_matrix_filtered.iloc[:,5:430]).sum(axis = 1)/125
PSI_matrix_filtered['NA_P'] = NA_P
PSI_matrix_filtered = PSI_matrix_filtered[PSI_matrix_filtered['NA_P'] < 0.4]

PSI_value_matrix_filtered = PSI_matrix_filtered.iloc[:,5:130]
m = PSI_value_matrix_filtered.mean(axis = 1)
for i, col in enumerate(PSI_value_matrix_filtered):
    PSI_value_matrix_filtered.iloc[:, i] = PSI_value_matrix_filtered.iloc[:,i].fillna(m)
    
PSI_matrix_filtered.iloc[:,5:430] = PSI_value_matrix_filtered
PSI_matrix_filtered = PSI_matrix_filtered.iloc[:,0:130]

S_value_Matrix = PSI_to_S(PSI_matrix_filtered)