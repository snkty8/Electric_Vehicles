select * from electric_vehicles;

--Remove duplicates
select * from electric_vehicles;

select *, 
	row_number() over(
	partition by "Clean_Alternative_Fuel_Vehicle_Type",
   				"VIN_(1-10)",
				"DOL_Vehicle_ID",
				"Model_Year",
				"Make",
				"Model",
				"Primary_Use",
				"Electric_Range",
				"Odometer_Reading",
				"Odometer_Reading_Description",
				"New_or_Used_Vehicle",
				"Sale_Price",
				"Sale_Date",
				"Transaction_Type",
				"Transaction_Date",
				"Year",
				"County",
				"City",
				"State",
				"Postal_Code",
				"Electric_Utility") as row_num  
from electric_vehicles;

with duplicate_cte as 
(select *, 
	row_number() over(
	partition by "Clean_Alternative_Fuel_Vehicle_Type",
   				"VIN_(1-10)",
				"DOL_Vehicle_ID",
				"Model_Year",
				"Make",
				"Model",
				"Primary_Use",
				"Electric_Range",
				"Odometer_Reading",
				"Odometer_Reading_Description",
				"New_or_Used_Vehicle",
				"Sale_Price",
				"Sale_Date",
				"Transaction_Type",
				"Transaction_Date",
				"Year",
				"County",
				"City",
				"State",
				"Postal_Code",
				"Electric_Utility") as row_num
from electric_vehicles
)
select * from duplicate_cte
where row_num > 1
order by "Transaction_Date";

--check a random value
select * from electric_vehicles where
"VIN_(1-10)" = '1G1RD6E40B'
and "Transaction_Date" = 'March 22 2018';

-- value above is definitely a duplicate

-- Create a new table with row_num column and to work off going forward so oringal table is kept
CREATE TABLE IF NOT EXISTS public.electric_vehicles_2
(
    "Clean_Alternative_Fuel_Vehicle_Type" text COLLATE pg_catalog."default",
    "VIN_(1-10)" text COLLATE pg_catalog."default",
    "DOL_Vehicle_ID" text COLLATE pg_catalog."default",
    "Model_Year" text COLLATE pg_catalog."default",
    "Make" text COLLATE pg_catalog."default",
    "Model" text COLLATE pg_catalog."default",
    "Primary_Use" text COLLATE pg_catalog."default",
    "Electric_Range" text COLLATE pg_catalog."default",
    "Odometer_Reading" text COLLATE pg_catalog."default",
    "Odometer_Reading_Description" text COLLATE pg_catalog."default",
    "New_or_Used_Vehicle" text COLLATE pg_catalog."default",
    "Sale_Price" text COLLATE pg_catalog."default",
    "Sale_Date" text COLLATE pg_catalog."default",
    "Transaction_Type" text COLLATE pg_catalog."default",
    "Transaction_Date" text COLLATE pg_catalog."default",
    "Year" text COLLATE pg_catalog."default",
    "County" text COLLATE pg_catalog."default",
    "City" text COLLATE pg_catalog."default",
    "State" text COLLATE pg_catalog."default",
    "Postal_Code" text COLLATE pg_catalog."default",
    "Electric_Utility" text COLLATE pg_catalog."default",
	"row_num" int
)

TABLESPACE pg_default;

select * from electric_vehicles_2;

--Insert same data into new table including new colums
insert into electric_vehicles_2
select *,
row_number() over(
	partition by
	"Clean_Alternative_Fuel_Vehicle_Type",
    "VIN_(1-10)",
    "DOL_Vehicle_ID",
    "Model_Year",
    "Make",
    "Model",
    "Primary_Use",
    "Electric_Range",
    "Odometer_Reading",
    "Odometer_Reading_Description",
    "New_or_Used_Vehicle",
    "Sale_Price",
    "Sale_Date",
    "Transaction_Type",
    "Transaction_Date",
    "Year",
    "County",
    "City",
    "State",
    "Postal_Code",
    "Electric_Utility")
 as row_num
from electric_vehicles;

--Delete the duplicates
delete from electric_vehicles_2
where "row_num" > 1;

select * from electric_vehicles_2
where "DOL_Vehicle_ID" = '322286492';

--just want rows with sales price and date
delete from electric_vehicles_2
where "Sale_Date" is null;
and "Sale_Price" = '0';

select * from electric_vehicles_2
	where "VIN_(1-10)" = '1G1RB6E42C'
	order by "Sale_Date";

-- Need to change format of Sale_Date and Transacation Date to date format
update electric_vehicles_2 set "Sale_Date" = cast("Sale_Date" as date);

update electric_vehicles_2 set "Transaction_Date" = cast("Transaction_Date" as date);

alter table electric_vehicles_2 
alter column "Transaction_Date" type date
USING "Transaction_Date"::date;	

alter table electric_vehicles_2 
alter column "Sale_Date" type date
USING "Sale_Date"::date;

select * from electric_vehicles_2;

--drop row_num
alter table electric_vehicles_2
drop column row_num;

--There are still multiple rows for most VINs because the vechile was sold. Filtering out to the first sale Sale_Date.

--Rank Transaction_date and Sales_Price, then select those that have rank one
select * from (select *, dense_rank() over (partition by "VIN_(1-10)" order by "Transaction_Date", "Sale_Price") as rank_Tran
	from electric_vehicles_2)
	where rank_tran = 1;
	
--Create new table with ranking 
CREATE TABLE IF NOT EXISTS public.electric_vehicles_3
(
    "Clean_Alternative_Fuel_Vehicle_Type" text COLLATE pg_catalog."default",
    "VIN_(1-10)" text COLLATE pg_catalog."default",
    "DOL_Vehicle_ID" text COLLATE pg_catalog."default",
    "Model_Year" text COLLATE pg_catalog."default",
    "Make" text COLLATE pg_catalog."default",
    "Model" text COLLATE pg_catalog."default",
    "Primary_Use" text COLLATE pg_catalog."default",
    "Electric_Range" text COLLATE pg_catalog."default",
    "Odometer_Reading" text COLLATE pg_catalog."default",
    "Odometer_Reading_Description" text COLLATE pg_catalog."default",
    "New_or_Used_Vehicle" text COLLATE pg_catalog."default",
    "Sale_Price" text COLLATE pg_catalog."default",
    "Sale_Date" text COLLATE pg_catalog."default",
    "Transaction_Type" text COLLATE pg_catalog."default",
    "Transaction_Date" text COLLATE pg_catalog."default",
    "Year" text COLLATE pg_catalog."default",
    "County" text COLLATE pg_catalog."default",
    "City" text COLLATE pg_catalog."default",
    "State" text COLLATE pg_catalog."default",
    "Postal_Code" text COLLATE pg_catalog."default",
    "Electric_Utility" text COLLATE pg_catalog."default",
	"rank_info" int
)

TABLESPACE pg_default;

insert into electric_vehicles_3
select *,
dense_rank() over (partition by "VIN_(1-10)" order by "Transaction_Date", "Sale_Price") as rank_info
from electric_vehicles_2;

select * from electric_vehicles_3;

--Removes rows with ranking above 1
delete from electric_vehicles_3 
where rank_info > 1;

select * from electric_vehicles_3;

--Check for any duplicate VIN. Total rows equal 11629
select count( distinct "VIN_(1-10)") from electric_vehicles_3;

--Get 11491 VIN when counting the distinct so there are some duplicate VIN remaining

with dups as 
(select *, 
	row_number() over(
	partition by "Clean_Alternative_Fuel_Vehicle_Type",
	"VIN_(1-10)")
	as row_num  
from electric_vehicles_3)
select * from dups
where row_num > 1;

select * from electric_vehicles_3 where "VIN_(1-10)" = '1FTBW1XK6N'
--DOL Vehicle ID shows a difference, but likely will not use this column much

CREATE TABLE IF NOT EXISTS public.electric_vehicles_4
(
    "Clean_Alternative_Fuel_Vehicle_Type" text COLLATE pg_catalog."default",
    "VIN_(1-10)" text COLLATE pg_catalog."default",
    "DOL_Vehicle_ID" text COLLATE pg_catalog."default",
    "Model_Year" text COLLATE pg_catalog."default",
    "Make" text COLLATE pg_catalog."default",
    "Model" text COLLATE pg_catalog."default",
    "Primary_Use" text COLLATE pg_catalog."default",
    "Electric_Range" text COLLATE pg_catalog."default",
    "Odometer_Reading" text COLLATE pg_catalog."default",
    "Odometer_Reading_Description" text COLLATE pg_catalog."default",
    "New_or_Used_Vehicle" text COLLATE pg_catalog."default",
    "Sale_Price" text COLLATE pg_catalog."default",
    "Sale_Date" text COLLATE pg_catalog."default",
    "Transaction_Type" text COLLATE pg_catalog."default",
    "Transaction_Date" text COLLATE pg_catalog."default",
    "Year" text COLLATE pg_catalog."default",
    "County" text COLLATE pg_catalog."default",
    "City" text COLLATE pg_catalog."default",
    "State" text COLLATE pg_catalog."default",
    "Postal_Code" text COLLATE pg_catalog."default",
    "Electric_Utility" text COLLATE pg_catalog."default",
    rank_info integer,
	row_num int
)

TABLESPACE pg_default;

insert into electric_vehicles_4
select *, 
	row_number() over(
	partition by "Clean_Alternative_Fuel_Vehicle_Type",
	"VIN_(1-10)")
	as row_num  
from electric_vehicles_3;

select * from electric_vehicles_4
where row_num > 1;

delete from electric_vehicles_4
where row_num > 1;

select * from electric_vehicles_4
--Row count now equals 11491

select count(distinct "VIN_(1-10)") from electric_vehicles_4;
--Distinct VIN count also 11491

select * from electric_vehicles_4;

--Now make sure each column is set to correct data format

alter table electric_vehicles_4 
alter column "Electric_Range" type int
USING "Electric_Range"::int;	

alter table electric_vehicles_4 
alter column "Odometer_Reading" type int
USING "Odometer_Reading"::int;	

alter table electric_vehicles_4 
alter column "Sale_Price" type int
USING "Sale_Price"::int;	

alter table electric_vehicles_4
alter column "Transaction_Date" type date
USING "Transaction_Date"::date;	

alter table electric_vehicles_4
alter column "Sale_Date" type date
USING "Sale_Date"::date;	

select * from electric_vehicles_4;

--drop rank and row_num columns
alter table electric_vehicles_4
drop column row_num;

alter table electric_vehicles_4
drop column rank_info;

select distinct "State" from electric_vehicles_4

select * from electric_vehicles_4
where "Model" = 'F-150'

--Noticed there are a lot of rows with Electric Range as zero. May be best to removed those. 
select * from electric_vehicles_4
where "Electric_Range" = 0;

delete from electric_vehicles_4
where "Electric_Range" = 0;


--Moving back to electric_vehicles_2. Realizing it may be best to keep all values by VIN since the vehicle changed ownership
select * from electric_vehicles_2
where "Make" = 'TESLA'
and "VIN_(1-10)" = '5YJ3E1EA7P'
order by "Sale_Date"
	
select * from electric_vehicles_2
where "VIN_(1-10)" = 'JTMAB3FV8P'
order by "Sale_Date"

alter table electric_vehicles_2
alter column "Electric_Range" type int
USING "Electric_Range"::int;	

alter table electric_vehicles_2 
alter column "Odometer_Reading" type int
USING "Odometer_Reading"::int;	

alter table electric_vehicles_2 
alter column "Sale_Price" type int
USING "Sale_Price"::int;	

alter table electric_vehicles_2
alter column "Model_Year" type int
USING "Model_Year"::int;	

alter table electric_vehicles_2
alter column "Year" type int
USING "Year"::int;	
	
select * from electric_vehicles_2


--Running some exploratory queries to find insights
-- Sum of top sales by Make each year
with Make_Year ("Make", "Model", "Sale_Date", "Sale_Price") as 
(select "Make", "Model", extract(year from "Sale_Date") as test, sum("Sale_Price") as total_cost
from electric_vehicles_2
group by "Make", "Model", test
order by 3 DESC),
Make_Year_Rank as 
(select *, dense_rank() over (partition by "Sale_Date" order by "Sale_Price" DESC) as rank_years
	from Make_Year)
select * from Make_Year_Rank
where rank_years <= 3;

-- Avg Top Sale by Make each year
with Make_Year ("Make", "Model", "Sale_Date", "Sale_Price") as 
(select "Make", "Model", extract(year from "Sale_Date") as test, round(avg("Sale_Price"),2) as total_cost
from electric_vehicles_2
group by "Make", "Model", test
order by 3 DESC),
Make_Year_Rank as 
(select *, dense_rank() over (partition by "Sale_Date" order by "Sale_Price" DESC) as rank_years
	from Make_Year)
select * from Make_Year_Rank
where rank_years <= 3;

--New
with Make_Year ("Make", "Model", "Sale_Date", "Sale_Price") as 
(select "Make", "Model", extract(year from "Sale_Date") as test, round(avg("Sale_Price"),2) as total_cost
from electric_vehicles_2
	where "New_or_Used_Vehicle" = 'New'
group by "Make", "Model", test
order by 3 DESC),
Make_Year_Rank as 
(select *, dense_rank() over (partition by "Sale_Date" order by "Sale_Price" DESC) as rank_years
	from Make_Year)
select * from Make_Year_Rank
where rank_years <= 3;

--Used 
with Make_Year ("Make", "Model", "Sale_Date", "Sale_Price") as 
(select "Make", "Model", extract(year from "Sale_Date") as test, round(avg("Sale_Price"),2) as total_cost
from electric_vehicles_2
	where "New_or_Used_Vehicle" = 'Used'
group by "Make", "Model", test
order by 3 DESC),
Make_Year_Rank as 
(select *, dense_rank() over (partition by "Sale_Date" order by "Sale_Price" DESC) as rank_years
	from Make_Year)
select * from Make_Year_Rank
where rank_years <= 3;

-- Avg of Top Electric Range by Make
with Make_Year ("Make", "Model", "Sale_Date", "Electric_Range") as 
(select "Make", "Model", extract(year from "Sale_Date") as test, round(avg("Electric_Range"),2) as total_cost
from electric_vehicles_2
group by "Make", "Model", test
order by 3 DESC),
Make_Year_Rank as 
(select *, dense_rank() over (partition by "Sale_Date" order by "Electric_Range" DESC) as rank_years
	from Make_Year)
select * from Make_Year_Rank
where rank_years <= 3;

-- Top Sales by Make over all years
select "Make", sum("Sale_Price") as total_Sales
from electric_vehicles_2 
group by "Make"
order by total_Sales DESC;

-- Top Sales by Make over all years for New
select "Make", sum("Sale_Price") as total_Sales
from electric_vehicles_2 
where "New_or_Used_Vehicle" = 'New'
group by "Make"
order by total_Sales DESC;

-- Top Sales by Make over all years for Used
select "Make", sum("Sale_Price") as total_Sales
from electric_vehicles_2 
where "New_or_Used_Vehicle" = 'Used'
group by "Make"
order by total_Sales DESC;

-- Top Sales by Make and Model over all years for New
select "Make", "Model", sum("Sale_Price") as total_Sales
from electric_vehicles_2 
	where "New_or_Used_Vehicle" = 'New'
group by "Make", "Model"
order by total_Sales DESC;

-- Top Sales by Make and Model over all years for Used
select "Make", "Model", sum("Sale_Price") as total_Sales
from electric_vehicles_2 
	where "New_or_Used_Vehicle" = 'Used'
group by "Make", "Model"
order by total_Sales DESC;

-- Top Sales by Make and Model over all years
select "Make", "Model", sum("Sale_Price") as total_Sales
from electric_vehicles_2 
group by "Make", "Model"
order by total_Sales DESC;

-- Top Sales by Make and Model over all years for New
select "Make", "Model", sum("Sale_Price") as total_Sales
from electric_vehicles_2 
	where "New_or_Used_Vehicle" = 'New'
group by "Make", "Model"
order by total_Sales DESC;

-- Top Sales by Make and Model over all years for Used
select "Make", "Model", sum("Sale_Price") as total_Sales
from electric_vehicles_2 
	where "New_or_Used_Vehicle" = 'Used'
group by "Make", "Model"
order by total_Sales DESC;


-- Average Price by Make and Model over all years
select "Make", "Model", round(avg("Sale_Price"),2) as total_Sales
from electric_vehicles_2 
group by "Make", "Model"
order by total_Sales DESC;

-- Average Price by Make and Model over all years for New
select "Make", "Model", round(avg("Sale_Price"),2) as total_Sales
from electric_vehicles_2 
	where "New_or_Used_Vehicle" = 'New'
group by "Make", "Model"
order by total_Sales DESC;

-- Average Price by Make and Model over all years for Used
select "Make", "Model", round(avg("Sale_Price"),2) as total_Sales
from electric_vehicles_2 
	where "New_or_Used_Vehicle" = 'Used'
group by "Make", "Model"
order by total_Sales DESC;

-- Average Price by Make over all years
select "Make", round(avg("Sale_Price"),2) as total_Sales
from electric_vehicles_2 
group by "Make"
order by total_Sales DESC;

-- Average Price by Make over all years for New
select "Make", round(avg("Sale_Price"),2) as total_Sales
from electric_vehicles_2 
		where "New_or_Used_Vehicle" = 'New'
group by "Make"
order by total_Sales DESC;


-- Average Price by Make over all years for Used
select "Make", round(avg("Sale_Price"),2) as total_Sales
from electric_vehicles_2 
		where "New_or_Used_Vehicle" = 'Used'
group by "Make"
order by total_Sales DESC;