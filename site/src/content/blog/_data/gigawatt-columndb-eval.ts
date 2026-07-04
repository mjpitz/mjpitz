export const writeThroughput = [
    { platform: "Cassandra", metric: "min", wps: 7804.60 },
    { platform: "Cassandra", metric: "median", wps: 12710.63 },
    { platform: "Cassandra", metric: "max", wps: 17815.62 },
    { platform: "ClickHouse", metric: "min", wps: 165948.68 },
    { platform: "ClickHouse", metric: "median", wps: 1131799.95 },
    { platform: "ClickHouse", metric: "max", wps: 2050589.92 },
    { platform: "Iceberg", metric: "min", wps: 6657.79 },
    { platform: "Iceberg", metric: "median", wps: 57572.93 },
    { platform: "Iceberg", metric: "max", wps: 204109.52 },
    { platform: "TimescaleDB", metric: "min", wps: 76662.42 },
    { platform: "TimescaleDB", metric: "median", wps: 100521.82 },
    { platform: "TimescaleDB", metric: "max", wps: 148265.71 },
];

export const insertionTime = [
    { platform: "Cassandra", metric: "median", ms: 5963.54 },
    { platform: "Cassandra", metric: "p95", ms: 7329.98 },
    { platform: "Cassandra", metric: "p99", ms: 7049.62 },
    { platform: "ClickHouse", metric: "median", ms: 49.57 },
    { platform: "ClickHouse", metric: "p95", ms: 113.75 },
    { platform: "ClickHouse", metric: "p99", ms: 122.28 },
    { platform: "Iceberg", metric: "median", ms: 1324.89 },
    { platform: "Iceberg", metric: "p95", ms: 2670.27 },
    { platform: "Iceberg", metric: "p99", ms: 2801.19 },
    { platform: "TimescaleDB", metric: "median", ms: 485.40 },
    { platform: "TimescaleDB", metric: "p95", ms: 1060.59 },
    { platform: "TimescaleDB", metric: "p99", ms: 1336.77 },
];

export const readThroughput = [
    { platform: "Cassandra", metric: "min", qps: 11.03 },
    { platform: "Cassandra", metric: "median", qps: 2333.72 },
    { platform: "Cassandra", metric: "max", qps: 2357.33 },
    { platform: "ClickHouse", metric: "min", qps: 7.23 },
    { platform: "ClickHouse", metric: "median", qps: 101.33 },
    { platform: "ClickHouse", metric: "max", qps: 274.79 },
    { platform: "Iceberg", metric: "min", qps: 3.19 },
    { platform: "Iceberg", metric: "median", qps: 69.42 },
    { platform: "Iceberg", metric: "max", qps: 73.83 },
    { platform: "TimescaleDB", metric: "min", qps: 1.43 },
    { platform: "TimescaleDB", metric: "median", qps: 2653.11 },
    { platform: "TimescaleDB", metric: "max", qps: 6351.79 },
];

export const queryTime = [
    { platform: "Cassandra", metric: "median", ms: 1.69 },
    { platform: "Cassandra", metric: "p95", ms: 2.01 },
    { platform: "Cassandra", metric: "p99", ms: 2.28 },
    { platform: "ClickHouse", metric: "median", ms: 137.16 },
    { platform: "ClickHouse", metric: "p95", ms: 173.38 },
    { platform: "ClickHouse", metric: "p99", ms: 196.36 },
    { platform: "Iceberg", metric: "median", ms: 69.08 },
    { platform: "Iceberg", metric: "p95", ms: 87.56 },
    { platform: "Iceberg", metric: "p99", ms: 95.06 },
    { platform: "TimescaleDB", metric: "median", ms: 267.28 },
    { platform: "TimescaleDB", metric: "p95", ms: 342.23 },
    { platform: "TimescaleDB", metric: "p99", ms: 380.38 },
];

export const timescaleQueryBreakdown = [
    { scenario: "batch-lookup", metric: "median", ms: 533.883958 },
    { scenario: "batch-lookup", metric: "p95", ms: 683.412417 },
    { scenario: "batch-lookup", metric: "p99", ms: 759.16275 },
    { scenario: "opco-agg", metric: "median", ms: 1933.012792 },
    { scenario: "opco-agg", metric: "p95", ms: 5756.589084 },
    { scenario: "opco-agg", metric: "p99", ms: 5768.517625 },
    { scenario: "single-meter", metric: "median", ms: 0.6825 },
    { scenario: "single-meter", metric: "p95", ms: 1.055291 },
    { scenario: "single-meter", metric: "p99", ms: 1.599209 },
    { scenario: "version-history", metric: "median", ms: 0.621666 },
    { scenario: "version-history", metric: "p95", ms: 0.777625 },
    { scenario: "version-history", metric: "p99", ms: 0.878291 },
]
