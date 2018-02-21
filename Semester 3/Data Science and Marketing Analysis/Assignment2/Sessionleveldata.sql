SELECT session1 AS session, datedate AS date, datetime, views, carts, abandon, sale, remove, startyear, birthyear, lastorderdate, gender, segment, numbersearches, categorygroup, categoryunit, category, subcategory, maingroup, articlegroup, livedate, articletype, minprice, maxprice, avgprice, numberitems, minsales, maxsales, avgsales, totalsales
FROM (SELECT session_id AS session1, MIN(article_event_date) AS datedate, MIN(article_event_date_time) AS datetime, count(CASE WHEN article_event_type = '10' THEN 1 ELSE NULL END) AS views 
FROM articleevents
GROUP BY session_id) AS T1,
(SELECT session_id AS session2, MIN(article_event_date), count(CASE WHEN article_event_type = '20' THEN 1 ELSE NULL END) AS carts 
FROM articleevents
GROUP BY session_id) AS T2,
(SELECT session_id AS session3, MIN(article_event_date), count(CASE WHEN article_event_type = '30' THEN 1 ELSE NULL END) AS abandon 
FROM articleevents
GROUP BY session_id) AS T3,
(SELECT session_id AS session4, MIN(article_event_date), count(CASE WHEN article_event_type = '40' THEN 1 ELSE NULL END) AS sale 
FROM articleevents
GROUP BY session_id) AS T4,
(SELECT session_id AS session5, MIN(article_event_date), count(CASE WHEN article_event_type = '50' THEN 1 ELSE NULL END) AS remove 
FROM articleevents
GROUP BY session_id) AS T5,
(SELECT session_id AS session6, MIN(start_year) AS startyear, MIN(birth_year) AS birthyear, MIN(last_order_date) AS lastorderdate, MIN(sex) AS gender, MIN(marketing_segment) AS segment
FROM articleevents
LEFT JOIN customer
ON articleevents.customer_id = customer.customer_id
GROUP BY session_id) AS T6,
(SELECT sessionV AS session7, CASE WHEN numbersearches IS NULL THEN 0 ELSE numbersearches END as numbersearches
FROM
(SELECT articleevents.session_id AS sessionV FROM articleevents GROUP BY articleevents.session_id) AS TV
LEFT JOIN
(SELECT onsitesearches.session_id AS sessionW, count(search_term) AS numbersearches
FROM onsitesearches
GROUP BY onsitesearches.session_id) AS TW
ON sessionV = sessionW) AS T7,
(SELECT articleevents.session_id AS session8, MIN(article.category_group) AS categorygroup, MIN(category_unit) AS categoryunit, MIN(category) AS category, MIN(sub_category) AS subcategory, MIN(article_main_group) AS maingroup, MIN(article_group) AS articlegroup, MIN(live_date) AS livedate, MIN(article_type) AS articletype, MIN(current_price) AS minprice, MAX(current_price) AS maxprice, CAST(AVG(current_price) AS DECIMAL(6,2)) AS avgprice
FROM articleevents,article
WHERE articleevents.article_id = article.article_id
GROUP BY articleevents.session_id) AS T8,
(SELECT sessionX as session9, CASE WHEN numberitems IS NULL THEN 0 ELSE numberitems END as numberitems, CASE WHEN minsales IS NULL THEN 0 ELSE minsales END as minsales, CASE WHEN maxsales IS NULL THEN 0 ELSE maxsales END as maxsales,CASE WHEN avgsales IS NULL THEN 0 ELSE avgsales END as avgsales,CASE WHEN totalsales IS NULL THEN 0 ELSE totalsales END as totalsales
FROM
(SELECT  articleevents.session_id AS sessionX FROM articleevents GROUP BY articleevents.session_id) AS TX
LEFT JOIN 
(SELECT public.order.session_id AS sessionY, count(public.order.items) AS numberitems, MIN(public.order.sales_amount) AS minsales, MAX(public.order.sales_amount) AS maxsales, CAST(AVG(public.order.sales_amount) AS DECIMAL(6,2)) AS avgsales, SUM(public.order.sales_amount) AS totalsales
FROM public.order
GROUP BY public.order.session_id) AS TY
ON sessionX=sessionY) as T9
WHERE session1=session2 AND session1=session3 AND session1=session4 AND session1=session5 AND session1=session6 AND session1=session7 AND session1=session8 AND session1=session9