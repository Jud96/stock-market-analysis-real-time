there are many time series databases available
Some of the most popular ones are:


### InfluxDB
InfluxDB is an open-source time series database developed by InfluxData. It is written in Go and optimized for fast, high-availability storage and retrieval of time series data in fields such as operations monitoring, application metrics, Internet of Things sensor data, and real-time analytics.
Attributes:
- high ingestion rate and query performance
- Schema-less
- SQL-like query language
- Retention Policies
- Continuous Queries / downsampling
- Data Compression
- Open-source 
- High Availability
- Clustering


### TimescaleDB
TimescaleDB is an open-source time-series database optimized for fast ingest and complex queries. It is built on top of PostgreSQL, and scales out horizontally by sharding data across multiple nodes. It is designed to scale for high-cardinality data and complex queries.
Attributes:
- Built on top of PostgreSQL
- SQL interface
- Supports complex queries
- High-cardinality data
- Continuous Aggregates
- Hypertables : hypertables are a way to partition data in TimescaleDB to improve query performance (Automatic partitioning)
- Compression : TimescaleDB supports data compression to reduce storage requirements and improve query performance
- Open-source
- Replication and Scaling : Provides multi-node and high-availability options in its enterprise version.
- Data Retention Policies
- Data Encryption


### Prometheus
Purpose: Monitoring and alerting time-series database, primarily used for system and application monitoring.
Attributes:
Metric Focused,Pull Model,PromQL,Built-in Alerting, Efficiency, Downsampling and Retention


### OpenTSDB
OpenTSDB is a distributed, scalable time series database written on top of **Apache HBase**. It is designed to store large amounts of time series data and query it in real-time.

- Scalability: Designed to scale horizontally across a distributed cluster of machines.
- High Availability: Supports high availability through HBase.
- Tagging: Supports tagging of time-series data, which improves query performance for multi-dimensional data
- REST API: Allows reading and writing time-series data via REST API.
also  Compression,Integrations with hadoop, Long-Term Storage and Retention Policies

### clickhouse
ClickHouse is an open-source column-oriented database management system that allows generating analytical data reports in real-time using SQL queries. It is optimized for high-performance analytics and is capable of processing hundreds of millions to more than a billion rows and tens of gigabytes of data per single server per second.

- Column-oriented storage
- SQL interface
- Distributed query processing
- Real-time data processing
- Compression and partitioning
- olap workloads / real-time analytics

### Druid
Druid is an open-source, distributed, column-oriented, real-time analytics data store that is commonly used to power exploratory dashboards in multi-tenant environments. It is designed for high-performance slice-and-dice analytics on large datasets.

- Real-time data ingestion
- Column-oriented storage
- SQL-like query language
- Multi-tenancy
- Scalability
- High availability
- Data retention policies
- Data summarization and rollup
- Approximate query processing
  


## Key Attributes to Compare Time-Series Databases

- **Data Ingestion**: The rate at which data can be ingested into the time series database.
  - Can the database ingest millions of data points per second?
  - Does it support batch and real-time ingestion?
- **Query Performance** : aggregate queries, filtering, and grouping operations (especially range data)
  - Can the database return query results in near real-time for large datasets?
  - How does it perform with time-range and aggregation queries?
  - Does it support downsampling or continuous queries to optimize long-term analysis?
- **scalability** : how well the database scales horizontally and vertically.
  - Does the database support horizontal scaling (i.e., adding more nodes)?
  - Can it handle distributed workloads across clusters?
  - How does it manage replication and sharding for fault tolerance?
- **Data Retention and Archiving Policies**
  - Does the database support retention policies (e.g., automatic deletion of older data)?
  - How does it handle data archiving or moving old data to cold storage?
  - Can it downsample older data to reduce storage costs while keeping aggregate data?
- **Data Compression**
  - Does the database use efficient compression techniques for time-series data?
  - How much storage savings can you expect with your data size and structure?
  - Is there any impact on query performance due to compression?

- **Data Model & Flexibility**
  - Does the database support a tagging or labeling system for organizing multi-dimensional time-series data?
  - How flexible is the schema? Can you change it without downtime?
  - Can you easily query by metadata, tags, or labels?
- **Integration with Existing Systems**
  -   Does the database support common data ingestion tools (e.g., Kafka, Telegraf, etc.)?
  -   Is it compatible with visualization platforms (e.g., Grafana)?
  -   Does it provide APIs or connectors for analytics tools like Hadoop, Spark, or TensorFlow?
- **High Availability and Fault Tolerance**
  - Does the database support replication and clustering for high availability?
  - How does it handle failover in case of a node failure?
  - Does it offer backup and restore features?
- **Ease of Use and Management**
  - Is the database easy to install and configure?
  - Does it provide intuitive management tools for monitoring performance?
  - Can it be deployed easily in cloud, on-premise, or hybrid environments?
- **cost**
  - Is the database open-source, freemium, or entirely proprietary?
  - What are the infrastructure and storage costs for your expected data volume?
  - Are there enterprise licensing costs for features like clustering, monitoring, and backups?


|Criteria|	Why Important|
|---|---|
|Data Ingestion Rate|	To handle large, fast incoming time-series data volumes.|
|Query Performance	|For efficient retrieval and analysis of time-series data.|
| Scalability       |To ensure the database can grow with your data needs.|
|Retention Policies	|To manage data expiration and storage optimization.|
|Data Compression	|To save storage costs while maintaining performance.|
|Data Model Flexibility	|For easier querying and organizing multi-dimensional data.|
|Integration	|To work seamlessly with your existing tools and platforms.|
|Downsampling	|For efficient long-term data storage with varying granularity.|
|Query Language	|Ease of use and support for advanced analytical queries.|
|High Availability	|For reliable uptime and data resilience in production environments.|
|Real-time Capabilities	|For low-latency, real-time data processing and alerting.|
|Ease of Management	|To minimize operational overhead and complexity.|
|Community Support	|To ensure help and extensions are available when needed.|
|Cost	|To balance between budget and performance/scalability needs.|


### useful links
- https://docs.timescale.com/getting-started/latest/
- https://docs.timescale.com/use-timescale/latest/continuous-aggregates/time/
- https://docs.timescale.com/self-hosted/latest/install/installation-linux/


