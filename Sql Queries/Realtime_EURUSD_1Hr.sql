CREATE OR REPLACE VIEW v_eurusd_1h_realtime AS
WITH live AS (
    SELECT
        time_bucket('1 hour', time) AS bucket,
        first(price, time) AS open,
        max(price) AS high,
        min(price) AS low,
        last(price, time) AS close,
        count(*) AS ticks
    FROM ticks
    WHERE time >= now() - interval '3 hours'
      AND symbol='EURUSD'
    GROUP BY bucket
)
SELECT bucket, open, high, low, close, ticks
FROM cagg_eurusd_1h

UNION

SELECT bucket, open, high, low, close, ticks
FROM live

ORDER BY bucket DESC;

/*
   
   ----->To view output run below Queries<-----
   SELECT * FROM v_eurusd_1h_realtime;
   SELECT * FROM v_eurusd_1h_realtime ORDER BY bucket DESC LIMIT 10;

*/ 
