#!/bin/bash

# Specify the year and month you want to download
year=2020
month=01  # January


for year in {2009..2022}; do
  # Loop over the months
  for month in {01..12}; do
    # Construct the download URL
    url="https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_${year}-${month}.parquet"
    # Use wget to download the file
    wget $url
    sleep 5
  done
  sleep 60
done
