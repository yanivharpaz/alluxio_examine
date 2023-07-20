# PySpark basic sanity group by test:  
```
from pyspark.sql import SparkSession
from pyspark.sql.functions import rand

# Create Spark session
spark = SparkSession.builder.appName("LargeDataGenerator").getOrCreate()

# Generate 10 billion rows of data
df = spark.range(0, 10 ** 10).withColumn("value", rand())

# Group by every 10,000th row (10,000 groups in total)
df_grouped = df.withColumn("group", (df["id"] / 10000).cast("integer")).groupBy("group").count()

# Show the result
df_grouped.show()
```

