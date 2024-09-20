-- part of a query repo
-- query name: Daily Deposits Breakdown Split BTC/tBTC/wBTC v3.1
-- query link: https://dune.com/queries/3842151


WITH token_constants AS (
  SELECT
    0x18084fbA666a33d37592fA2633fD49a74DD93a88 AS tbtc_address,
    0x2260fac5e5542a773aa44fbcfedf7c193bc2c599 AS wbtc_address,
    0x1d50d75933b7b7c8ad94dbfb748b5756e3889c24 AS btc_from_address,
    0x7A56E1C57C7475CCf742a1832B028F0456652F97 AS solvbtc_address,
    0xd9D920AA40f578ab794426F5C90F6C731D159DEf AS solvbtc_bbn_address,
    1e18 AS tbtc_precision,
    1e8 AS wbtc_precision
), daily_net_transfers AS (
  SELECT
    DATE_TRUNC('day', evt_block_time) AS dt,
    SUM(
      CASE
        WHEN contract_address = tbtc_address
        AND "to" = 0xAB13B8eecf5AA2460841d75da5d5D861fD5B8A39
        AND "from" <> btc_from_address
        THEN value / tbtc_precision
        WHEN contract_address = tbtc_address
        AND "from" = 0xAB13B8eecf5AA2460841d75da5d5D861fD5B8A39
        THEN -value / tbtc_precision
        ELSE 0
      END
    ) AS net_tBTC_amount,
    SUM(
      CASE
        WHEN contract_address = wbtc_address
        AND "to" = 0xAB13B8eecf5AA2460841d75da5d5D861fD5B8A39
        THEN value / wbtc_precision
        WHEN contract_address = wbtc_address
        AND "from" = 0xAB13B8eecf5AA2460841d75da5d5D861fD5B8A39
        THEN -value / wbtc_precision
        ELSE 0
      END
    ) AS net_wBTC_amount,
    SUM(
      CASE
        WHEN "from" = btc_from_address
        AND "to" = 0xAB13B8eecf5AA2460841d75da5d5D861fD5B8A39
        THEN value / tbtc_precision
        WHEN "from" = 0xAB13B8eecf5AA2460841d75da5d5D861fD5B8A39
        AND "to" = btc_from_address
        THEN -value / tbtc_precision
        ELSE 0
      END
    ) AS net_nativeBTC_amount,
    SUM(
      CASE
        WHEN contract_address = solvbtc_address
        AND "to" = 0xAB13B8eecf5AA2460841d75da5d5D861fD5B8A39
        AND "from" <> btc_from_address
        THEN value / tbtc_precision
        WHEN contract_address = solvbtc_address
        AND "from" = 0xAB13B8eecf5AA2460841d75da5d5D861fD5B8A39
        THEN -value / tbtc_precision
        ELSE 0
      END
    ) AS net_solvBTC_amount,
    SUM(
      CASE
        WHEN contract_address = solvbtc_bbn_address
        AND "to" = 0xAB13B8eecf5AA2460841d75da5d5D861fD5B8A39
        AND "from" <> btc_from_address
        THEN value / tbtc_precision
        WHEN contract_address = solvbtc_bbn_address
        AND "from" = 0xAB13B8eecf5AA2460841d75da5d5D861fD5B8A39
        THEN -value / tbtc_precision
        ELSE 0
      END
    ) AS net_solvBTC_BBN_amount
  FROM erc20_ethereum.evt_Transfer, token_constants
  WHERE
    contract_address IN (tbtc_address, wbtc_address, solvbtc_address, solvbtc_bbn_address)
    AND (
      "to" = 0xAB13B8eecf5AA2460841d75da5d5D861fD5B8A39
      OR "from" = 0xAB13B8eecf5AA2460841d75da5d5D861fD5B8A39
      OR "from" = btc_from_address
      OR "to" = btc_from_address
    )
  GROUP BY
    1
), cumulative_transfers AS (
  SELECT
    dt,
    SUM(net_tBTC_amount) OVER (ORDER BY dt) AS cumulative_tBTC_amount,
    SUM(net_wBTC_amount) OVER (ORDER BY dt) AS cumulative_wBTC_amount,
    SUM(net_nativeBTC_amount) OVER (ORDER BY dt) AS cumulative_nativeBTC_amount,
    SUM(net_solvBTC_amount) OVER (ORDER BY dt) AS cumulative_solvBTC_amount,
    SUM(net_solvBTC_BBN_amount) OVER (ORDER BY dt) AS cumulative_solvBTC_BBN_amount
  FROM daily_net_transfers
), cumulative_totals AS (
  SELECT
    dt,
    cumulative_tBTC_amount,
    cumulative_wBTC_amount,
    cumulative_nativeBTC_amount,
    cumulative_solvBTC_amount,
    cumulative_solvBTC_BBN_amount,
    (
      cumulative_tBTC_amount + cumulative_wBTC_amount + cumulative_nativeBTC_amount + cumulative_solvBTC_amount + cumulative_solvBTC_BBN_amount
    ) AS cumulative_BTC_amount
  FROM cumulative_transfers
), wbtc_price AS (
  SELECT
    price AS usd_price
  FROM prices.usd_latest, token_constants
  WHERE
    contract_address = 0x2260fac5e5542a773aa44fbcfedf7c193bc2c599
    AND blockchain = 'ethereum'
  LIMIT 1
)
SELECT
  ct.dt,
  ct.cumulative_tBTC_amount,
  ct.cumulative_wBTC_amount,
  ct.cumulative_nativeBTC_amount,
  ct.cumulative_solvBTC_amount,
  ct.cumulative_solvBTC_BBN_amount,
  ct.cumulative_BTC_amount,
  p.usd_price,
  ct.cumulative_BTC_amount * p.usd_price AS cumulative_BTC_USDamount
FROM cumulative_totals AS ct
CROSS JOIN wbtc_price AS p
ORDER BY
  ct.dt DESC;
