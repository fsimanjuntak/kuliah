import pandas as pd
import numpy as np

from sklearn.base import TransformerMixin

class DataFrameImputer(TransformerMixin):

    def __init__(self):
        """Impute missing values.

        Columns of dtype object are imputed with the most frequent value
        in column.

        Columns of other types are imputed with mean of column.

        """
    def fit(self, X, y=None):

        self.fill = pd.Series([X[c].value_counts().index[0]
            if X[c].dtype == np.dtype('O') else X[c].mean() for c in X],
            index=X.columns)

        return self

    def transform(self, X, y=None):
        return X.fillna(self.fill)


df = pd.read_csv('sessionleveldata.csv', sep=';')
#df['startyear'] = df['startyear'].astype(int)
#df['birthyear'] = df['birthyear'].astype(int)
#xt = DataFrameImputer().fit_transform(df)
#xt.to_csv("finaldataset_afterinputationofmissingvalue.csv", sep=';')
#df
df[['startyear','birthyear']] = df[['startyear','birthyear']].astype(int)

