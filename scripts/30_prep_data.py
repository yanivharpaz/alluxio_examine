#%%

from   dotenv           import load_dotenv
import pyarrow.parquet as pq
import os
# from   IPython.display  import display, HTML, JSON

load_dotenv()
DATA_PATH = os.getenv("DATA_PATH") 


trips = pq.read_table('trips.parquet')
trips = trips.to_pandas()