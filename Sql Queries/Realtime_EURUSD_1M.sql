CREATE OR REPLACE VIEW v_eurusd_1m_realtime AS
WITH live AS (
    SELECT
        time_bucket('1 minute', time) AS bucket,
        first(price, time) AS open,
        max(price) AS high,
        min(price) AS low,
        last(price, time) AS close,
        count(*) AS ticks
    FROM ticks
    WHERE time >= now() - interval '5 minutes'
      AND symbol='EURUSD'
    GROUP BY bucket
)
SELECT bucket, open, high, low, close, ticks
FROM cagg_eurusd_1m

UNION

SELECT bucket, open, high, low, close, ticks
FROM live

ORDER BY bucket DESC;

/*
   
   ----->To view output run below Queries<-----
   SELECT * FROM v_eurusd_1m_realtime
    WHERE bucket BETWEEN '2025-01-20 17:00' AND '2025-01-20 18:00'
    ORDER BY bucket;
   SELECT * FROM v_eurusd_1m_realtime;
   SELECT * FROM v_eurusd_1m_realtime ORDER BY bucket DESC LIMIT 20;

*/ 
