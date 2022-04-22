SELECT as_of_date, 
    count(user_address) AS CNT_USERS,
    sum(case when churn_date = as_of_date then 1 else 0 end) as CHURNED_TODAY, 
    sum(case when has_churned = TRUE THEN 1 ELSE 0 end) as TOTAL_CHURNED,
    sum(total_deposits_usd) AS TOTAL_DEPOSITS, 
    sum(total_withdrawals_usd) as TOTAL_WITHDRAWALS, 
    sum(total_value_locked_USD) as TOTAL_VALUE_LOCKED,
    avg(tvl_delta_30_day) as AVG_30D_TVL_DELTA,
    APPROX_QUANTILES(tvl_delta_30_day, 4) as QUARTILES_30D_TVL_DELTA,
    avg(tvl_delta_60_day) as AVG_60D_TVL_DELTA,
    APPROX_QUANTILES(tvl_delta_60_day, 4) as QUARTILES_60D_TVL_DELTA,
    avg(tvl_delta_90_day) as AVG_90D_TVL_DELTA,
    APPROX_QUANTILES(tvl_delta_90_day, 4) as QUARTILES_90D_TVL_DELTA,
    SUM(CASE WHEN first_deposit_date = as_of_date then 1 else 0 end) as STARTED_DEPOSITING_TODAY,
    avg(avg(first_deposit_amount)) OVER (partition by as_of_date ROWS 30 PRECEDING) as R30D_AVG_FIRST_DEPOSIT_AMT,
    avg(avg(last_deposit_amt)) OVER (partition by as_of_date ROWS 30 PRECEDING) as R30D_AVG_LAST_DEPOSIT_AMT,
    SUM(CASE WHEN last_deposit_date = as_of_date then 1 else 0 end) as STOPPED_DEPOSITING_TODAY,
    avg(days_since_last_deposit) as PORTFOLIO_AVG_DAYS_SINCE_LAST_DEPOSIT,
    SUM(CASE WHEN first_withdrawal_date = as_of_date then 1 else 0 end) as STARTED_WITHDRAWING_TODAY,
    avg(avg(first_withdrawal_amount)) OVER (partition by as_of_date ROWS 30 PRECEDING) as R30D_AVG_FIRST_WTIHDRAWAL_AMT,
    avg(avg(last_withdrawal_amt)) OVER (partition by as_of_date ROWS 30 PRECEDING) as R30D_AVG_LAST_WITHDRAWAL_AMT,
    SUM(CASE WHEN last_withdrawal_date = as_of_date then 1 else 0 end) as STOPPED_WITHDRAWING_TODAY
from users.friktion_users 
where user_address in (SELECT user_address from users.friktion_users where as_of_date = '2022-04-09' and has_churned = TRUE)
group by 1 
order by 1;