# CVD-mci

We developed a ML framework based on the NHANES database that enables mediation analysis and the identification of CVD mortality subgroups. This framework requires only 10 common clinical variables to predict CVD mortality risk over the next 10 years, stratify mortality risk, and uncover potential mechanisms underlying transitions between different CVD mortality subgroups. The identified mediation relationships and predictive performance were further validated in the UKB cohort, supporting the generalizability of the framework across populations. 

# Requirements

The main requirements are listed below:

* Python 3.11

* R 4.4

# The description of the CVD-mci source

* Consensus clustering and survival analysis.R

  This code is used for consensus clustering and survival analysis.

* Feature reduction model selection.ipynb

  This code is used for model construction after feature reduction and selection of the optimal model.

* Imputation.ipynb

  This code is used for imputation of missing values.

* CIT.R

  This code is used for mediation analysis.

* Model construction and ROC curve.ipynb

  This code is used for machine learning model construction and ROC curve plotting.

* NHANES data processing.ipynb

  This code is used for preprocessing NHANES data.

* Performance evaluation metrics.ipynb

  This code is used to calculate various model evaluation metrics.

* SHAP.ipynb

  This code is used to interpret machine learning models using the SHAP algorithm.

* Statistical analysis.ipynb

  This code is used for various statistical analyses.

* UKB data preprocessing.ipynb

  This code is used for preprocessing the UKB data.

