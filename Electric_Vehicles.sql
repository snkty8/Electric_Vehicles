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
	where "VIN_(1-10)" = '1FADP3R40G';

--There are still mutiple values for each VIN because some of the cars switched owners. Filtering out to show the first sale. 


