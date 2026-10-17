import pandas as pd
def select_data(df):
    df = pd.DataFrame(df)
    df = df[['foreign', 'mpg', 'rep78']]
    return df






def inspect_data(df):
    """Display basic information about the dataset."""
    print("Shape:", df.shape)
    print("\nColumns:")
    print(df.columns.tolist())
    print("\nData types:")
    print(df.dtypes)
    print("\nMissing values:")
    print(df.isna().sum())