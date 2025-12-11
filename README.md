# TimescaleDB Real-Time OHLC Aggregation (EURUSD)

This project ingests **1-second EURUSD ticks** into TimescaleDB and produces **real-time OHLC candles** for:

* **1 minute**
* **1 hour**
* **1 day**
* Supports **custom daily open at 10 PM**

---

## **Flow Summary**

1. **Tick Stream → Hypertable**

   * Incoming ticks (timestamp, price, symbol) are stored in a Timescale hypertable.

2. **Continuous Aggregates (Historical OHLC)**

   * TimescaleDB auto-maintains historical 1m, 1h, 1d candles.

3. **Real-Time Views**

   * Each timeframe has a view that merges:

     * **Historical CAgg data** (closed buckets)
     * **Live bucket** from the latest ticks (still open)
   * Ensures accurate, up-to-date OHLC for any query.

4. **Usage**

   * `SELECT * FROM v_eurusd_1m_realtime;`
   * `SELECT * FROM v_eurusd_1h_realtime;`
   * `SELECT * FROM v_eurusd_1d_realtime;`

5. **Custom Daily Session (10 PM)**

   * Daily candles use a time-bucket offset so each “day” runs **10 PM → next 10 PM**.

---

## **What you get**

* Tick ingestion script
* Hypertable setup
* Continuous aggregates
* Real-time OHLC views
* Daily-offset support (10 PM session open)

---



