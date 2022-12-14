WITH comp2_aggregate_closed_cases_by_age AS (
    SELECT COUNT("Case ID") as "Total cases closed",
           "Age" as "Age (days)"
    FROM {{ ref('closed_cases') }}
    WHERE user_group = 'COMP2'
    GROUP BY "Age"
)

SELECT * FROM comp2_aggregate_closed_cases_by_age