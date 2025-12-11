CREATE OR REPLACE VIEW v_eurusd_1d_realtime AS
WITH live AS (
    SELECT
        time_bucket('1 day', time) AS bucket,
        first(price, time) AS open,
        max(price) AS high,
        min(price) AS low,
        last(price, time) AS close,
        count(*) AS ticks
    FROM ticks
    WHERE time >= now() - interval '1 day'
      AND symbol='EURUSD'
    GROUP BY bucket
)
SELECT bucket, open, high, low, close, ticks
FROM cagg_eurusd_1d

UNION

SELECT bucket, open, high, low, close, ticks
FROM live

ORDER BY bucket DESC;

/*
   
   ----->To view output run below Queries<-----
   SELECT * FROM v_eurusd_1d_realtime;
   SELECT * FROM v_eurusd_1d_realtime ORDER BY bucket DESC LIMIT 5;

*/ 
