-- part of a query repo
-- query name: BTC Backed Stables Deposits
-- query link: https://dune.com/queries/3841847


WITH daily_totals AS (
  SELECT
    DATE_TRUNC('day', evt_block_time) AS dt,
    SUM(
      CASE
        WHEN contract_address = 0xCFC5BD99915AAA815401C5A41A927AB7A38D29CF
        AND "to" = 0xAB13B8EECF5AA2460841D75DA5D5D861FD5B8A39
        THEN value / 1e18
        ELSE 0
      END
    ) - SUM(
      CASE
        WHEN contract_address = 0xCFC5BD99915AAA815401C5A41A927AB7A38D29CF
        AND "from" = 0xAB13B8EECF5AA2460841D75DA5D5D861FD5B8A39
        THEN value / 1e18
        ELSE 0
      END
    ) AS daily_thUSD_amount,
    SUM(
      CASE
        WHEN contract_address = 0xF939E0A03FB07F59A73314E73794BE0E57AC1B4E
        AND "to" = 0xAB13B8EECF5AA2460841D75DA5D5D861FD5B8A39
        THEN value / 1e18
        ELSE 0
      END
    ) - SUM(
      CASE
        WHEN contract_address = 0xF939E0A03FB07F59A73314E73794BE0E57AC1B4E
        AND "from" = 0xAB13B8EECF5AA2460841D75DA5D5D861FD5B8A39
        THEN value / 1e18
        ELSE 0
      END
    ) AS daily_crvUSD_amount,
    SUM(
      CASE
        WHEN contract_address = 0x4C9EDD5852CD905F086C759E8383E09BFF1E68B3
        AND "to" = 0xAB13B8EECF5AA2460841D75DA5D5D861FD5B8A39
        THEN value / 1e18
        ELSE 0
      END
    ) - SUM(
      CASE
        WHEN contract_address = 0x4C9EDD5852CD905F086C759E8383E09BFF1E68B3
        AND "from" = 0xAB13B8EECF5AA2460841D75DA5D5D861FD5B8A39
        THEN value / 1e18
        ELSE 0
      END
    ) AS daily_USDe_amount,
    SUM(
      CASE
        WHEN contract_address = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
        AND "to" = 0xAB13B8EECF5AA2460841D75DA5D5D861FD5B8A39
        THEN value / 1e6
        ELSE 0
      END
    ) - SUM(
      CASE
        WHEN contract_address = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
        AND "from" = 0xAB13B8EECF5AA2460841D75DA5D5D861FD5B8A39
        THEN value / 1e6
        ELSE 0
      END
    ) AS daily_USDC_amount,
    SUM(
      CASE
        WHEN contract_address = 0xdAC17F958D2ee523a2206206994597C13D831ec7
        AND "to" = 0xAB13B8EECF5AA2460841D75DA5D5D861FD5B8A39
        THEN value / 1e6
        ELSE 0
      END
    ) - SUM(
      CASE
        WHEN contract_address = 0xdAC17F958D2ee523a2206206994597C13D831ec7
        AND "from" = 0xAB13B8EECF5AA2460841D75DA5D5D861FD5B8A39
        THEN value / 1e6
        ELSE 0
      END
    ) AS daily_USDT_amount,
    SUM(
      CASE
        WHEN contract_address = 0xCFC5BD99915AAA815401C5A41A927AB7A38D29CF
        AND "to" = 0xAB13B8EECF5AA2460841D75DA5D5D861FD5B8A39
        THEN value / 1e18
        ELSE 0
      END + CASE
        WHEN contract_address = 0xF939E0A03FB07F59A73314E73794BE0E57AC1B4E
        AND "to" = 0xAB13B8EECF5AA2460841D75DA5D5D861FD5B8A39
        THEN value / 1e18
        ELSE 0
      END + CASE
        WHEN contract_address = 0x4C9EDD5852CD905F086C759E8383E09BFF1E68B3
        AND "to" = 0xAB13B8EECF5AA2460841D75DA5D5D861FD5B8A39
        THEN value / 1e18
        ELSE 0
      END + CASE
        WHEN contract_address = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
        AND "to" = 0xAB13B8EECF5AA2460841D75DA5D5D861FD5B8A39
        THEN value / 1e6
        ELSE 0
      END + CASE
        WHEN contract_address = 0xdAC17F958D2ee523a2206206994597C13D831ec7
        AND "to" = 0xAB13B8EECF5AA2460841D75DA5D5D861FD5B8A39
        THEN value / 1e6
        ELSE 0
      END
    ) - SUM(
      CASE
        WHEN contract_address = 0xCFC5BD99915AAA815401C5A41A927AB7A38D29CF
        AND "from" = 0xAB13B8EECF5AA2460841D75DA5D5D861FD5B8A39
        THEN value / 1e18
        ELSE 0
      END + CASE
        WHEN contract_address = 0xF939E0A03FB07F59A73314E73794BE0E57AC1B4E
        AND "from" = 0xAB13B8EECF5AA2460841D75DA5D5D861FD5B8A39
        THEN value / 1e18
        ELSE 0
      END + CASE
        WHEN contract_address = 0x4C9EDD5852CD905F086C759E8383E09BFF1E68B3
        AND "from" = 0xAB13B8EECF5AA2460841D75DA5D5D861FD5B8A39
        THEN value / 1e18
        ELSE 0
      END + CASE
        WHEN contract_address = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
        AND "from" = 0xAB13B8EECF5AA2460841D75DA5D5D861FD5B8A39
        THEN value / 1e6
        ELSE 0
      END + CASE
        WHEN contract_address = 0xdAC17F958D2ee523a2206206994597C13D831ec7
        AND "from" = 0xAB13B8EECF5AA2460841D75DA5D5D861FD5B8A39
        THEN value / 1e6
        ELSE 0
      END
    ) AS daily_stables_amount
  FROM erc20_ethereum.evt_Transfer
  WHERE
    "to" = 0xAB13B8EECF5AA2460841D75DA5D5D861FD5B8A39
    OR "from" = 0xAB13B8EECF5AA2460841D75DA5D5D861FD5B8A39
  GROUP BY
    1
)
SELECT
  dt,
  SUM(daily_thUSD_amount) OVER (ORDER BY dt) AS cumulative_thUSD_amount,
  SUM(daily_crvUSD_amount) OVER (ORDER BY dt) AS cumulative_crvUSD_amount,
  SUM(daily_USDe_amount) OVER (ORDER BY dt) AS cumulative_USDe_amount,
  SUM(daily_USDC_amount) OVER (ORDER BY dt) AS cumulative_USDC_amount,
  SUM(daily_USDT_amount) OVER (ORDER BY dt) AS cumulative_USDT_amount,
  SUM(daily_stables_amount) OVER (ORDER BY dt) AS cumulative_stables_amount
FROM daily_totals
ORDER BY
  dt DESC