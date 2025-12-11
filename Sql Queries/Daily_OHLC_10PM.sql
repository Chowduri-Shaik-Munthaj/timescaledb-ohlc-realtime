CREATE OR REPLACE VIEW v_eurusd_1d_10pm AS
WITH live AS (
    SELECT
        time_bucket('24 hours', time - interval '2 hours') AS bucket,
        first(price, time) AS open,
        max(price) AS high,
        min(price) AS low,
        last(price, time) AS close,
        count(*) AS ticks
    FROM ticks
    WHERE time >= now() - interval '26 hours'
      AND symbol='EURUSD'
    GROUP BY bucket
)
SELECT * FROM live
ORDER BY bucket DESC;


/*
   ----->To view output run below Queries<-----
   SELECT * FROM v_eurusd_1d_10pm;

*/ 