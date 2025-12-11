CREATE EXTENSION IF NOT EXISTS timescaledb;

DROP TABLE IF EXISTS ticks CASCADE;

CREATE TABLE ticks (
    time TIMESTAMPTZ NOT NULL,
    price NUMERIC(10,5) NOT NULL,
    symbol TEXT NOT NULL
);

SELECT create_hypertable('ticks', 'time');

CREATE INDEX ON ticks(symbol, time DESC);

