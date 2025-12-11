CREATE MATERIALIZED VIEW cagg_eurusd_1h
WITH (timescaledb.continuous) AS
SELECT
    time_bucket('1 hour', time) AS bucket,
    first(price, time) AS open,
    max(price) AS high,
    min(price) AS low,
    last(price, time) AS close,
    count(*) AS ticks
FROM ticks
WHERE symbol='EURUSD'
GROUP BY bucket;
