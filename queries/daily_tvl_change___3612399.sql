-- part of a query repo
-- query name: Daily TVL Change
-- query link: https://dune.com/queries/3612399


WITH daily_changes AS (
    SELECT
        dt,
        cumulative_btc_amount_usd,
        LAG(cumulative_btc_amount_usd) OVER (ORDER BY dt) AS prev_day_cumulative_usd
    FROM
        query_3600460
    WHERE
        dt < CURRENT_DATE  -- This condition excludes today's data
)
SELECT
    dt,
    cumulative_btc_amount_usd,
    (
        (cumulative_btc_amount_usd - prev_day_cumulative_usd) / prev_day_cumulative_usd
    ) * 100 AS daily_percentage_change
FROM
    daily_changes
WHERE
    prev_day_cumulative_usd IS NOT NULL
ORDER BY
    dt DESC;
