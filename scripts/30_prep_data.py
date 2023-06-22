#%%

import os
import pyarrow         as pa
import pyarrow.parquet as pq

from   dotenv           import load_dotenv
# from   IPython.display  import display, HTML, JSON

def update_year_in_dataframe(df, datetime_col, new_year):
    # Update year in datetime column
    df[datetime_col] = df[datetime_col].apply(lambda dt: dt.replace(year=new_year))
    

def update_year_in_datetime(input_file, output_file, datetime_col, new_year):
    # Load parquet file into a PyArrow Table
    table = pq.read_table(input_file)

    # Convert PyArrow Table to pandas DataFrame
    df = table.to_pandas()

    # Update year in datetime column
    df[datetime_col] = df[datetime_col].apply(lambda dt: dt.replace(year=new_year))

    # Convert pandas DataFrame back to PyArrow Table
    updated_table = pa.Table.from_pandas(df)

    # Write updated PyArrow Table to a new parquet file
    pq.write_table(updated_table, output_file)


def format_path(path):
    return path if path.endswith("/") else path + "/"


def main():
    load_dotenv()
    DATA_PATH = format_path(os.getenv("DATA_PATH"))
    # if not os.getenv("DATA_PATH").endswith("/") else os.getenv("DATA_PATH")[:-1]

    input_file = f"{DATA_PATH}yellow_tripdata_2020-04.parquet"
    print(f"Reading {input_file=}")
    dTrips = pq.read_table(input_file)
    dTrips = dTrips.to_pandas()

    print(dTrips.head())
    print(f"{dTrips.shape=}")
    # trips.head()

    update_year_in_datetime(input_file, f"{DATA_PATH}/yellow_tripdata_2019-04.parquet", "tpep_pickup_datetime", 2019)
    # tpep_pickup_datetime
    
    input_file = f"{DATA_PATH}yellow_tripdata_2019-04.parquet"
    print(f"Reading {input_file=}")
    dTrips = pq.read_table(input_file)
    dTrips = dTrips.to_pandas()

    print(dTrips.head())


if __name__ == "__main__":
    main()


