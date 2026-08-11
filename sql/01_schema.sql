-- ============================================================
-- GeoVelocity
-- 01_schema.sql
--
-- Purpose:
-- Defines the relational structure for a synthetic
-- geographic and transaction-velocity fraud monitoring
-- prototype.
--
-- All customers, transactions, devices, IP addresses,
-- alerts, and investigations used in this project are synthetic.
-- ============================================================


-- ------------------------------------------------------------
-- TABLE 1: CUSTOMER_PROFILE
-- Stores the customer's expected geographic and transaction
-- behavior for comparison against observed activity.
-- ------------------------------------------------------------

CREATE TABLE customer_profile (
    customer_id              VARCHAR(10) PRIMARY KEY,
    customer_name            VARCHAR(100) NOT NULL,
    home_country             VARCHAR(50) NOT NULL,
    home_region              VARCHAR(50),
    customer_risk_rating     VARCHAR(10),
    expected_monthly_volume  DECIMAL(12,2),
    expected_txn_min         DECIMAL(12,2),
    expected_txn_max         DECIMAL(12,2)
);


-- ------------------------------------------------------------
-- TABLE 2: TRANSACTIONS
-- Stores synthetic observed transaction and location activity.
-- ------------------------------------------------------------

CREATE TABLE transactions (
    transaction_id        VARCHAR(12) PRIMARY KEY,
    customer_id           VARCHAR(10) NOT NULL,
    transaction_timestamp TIMESTAMP NOT NULL,
    transaction_amount    DECIMAL(12,2) NOT NULL,
    transaction_type      VARCHAR(30),
    ip_address            VARCHAR(45),
    ip_country            VARCHAR(50),
    ip_city               VARCHAR(50),
    latitude              DECIMAL(9,6),
    longitude             DECIMAL(9,6),
    device_id             VARCHAR(20),

    FOREIGN KEY (customer_id)
        REFERENCES customer_profile(customer_id)
);


-- ------------------------------------------------------------
-- TABLE 3: FRAUD_ALERTS
-- Stores alerts generated when monitoring rules identify
-- activity requiring analyst review.
-- ------------------------------------------------------------

CREATE TABLE fraud_alerts (
    alert_id          VARCHAR(12) PRIMARY KEY,
    customer_id       VARCHAR(10) NOT NULL,
    transaction_id    VARCHAR(12),
    alert_timestamp   TIMESTAMP,
    rule_code         VARCHAR(20),
    risk_score        INTEGER,
    alert_reason      VARCHAR(500),
    alert_status      VARCHAR(30),

    FOREIGN KEY (customer_id)
        REFERENCES customer_profile(customer_id),

    FOREIGN KEY (transaction_id)
        REFERENCES transactions(transaction_id)
);


-- ------------------------------------------------------------
-- TABLE 4: INVESTIGATIONS
-- Stores analyst assessments and dispositions.
-- ------------------------------------------------------------

CREATE TABLE investigations (
    investigation_id   VARCHAR(12) PRIMARY KEY,
    alert_id           VARCHAR(12) NOT NULL,
    analyst_assessment VARCHAR(1000),
    disposition        VARCHAR(50),
    review_timestamp   TIMESTAMP,

    FOREIGN KEY (alert_id)
        REFERENCES fraud_alerts(alert_id)
);
