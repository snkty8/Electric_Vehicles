# Electric_Vehicles

## Overview 
Stake holder believes Electirc Vehicles are better for the environment over gas powered vehicles. He is interested in building a dealership that sells Electric powered vehicles and would like to see some stats of vehicles already on the market. 
Explored data set, [Electric Vehicle Title and Registration Activty](https://catalog.data.gov/dataset/electric-vehicle-title-and-registration-activity) , to find any pertinent information for the stakeholder. 

## ETL Process Using PgAdmin
### Checked for duplicates
Used row_number over  to assign number all columns, and created a new table to work off, leaving the orginal intact. A value greater than 2 in row_num column in the new table indicated a duplicate row. To validate, pulled a few VIN numbers to check:

<img width="762" alt="image" src="https://github.com/snkty8/Electric_Vehicles/assets/78936833/246d2998-39ae-4003-8804-d87f0c75c472">

### Dropped any unneccessary rows 
There were over 2 millions rows in the orginal data, more than half had zero for Sale Price and null Sales Date. These rows were removed. 

<img width="767" alt="image" src="https://github.com/snkty8/Electric_Vehicles/assets/78936833/7544fd71-29fc-485f-b6be-bbe3264fed57">

### Updated each column to correct data type
When moving the data from CSV to PgAdmin, data type for all columns came over as text. Updated columns containing dates, prices, odometer reading, and electric range to the appropriate data type. 

Before: 

<img width="355" alt="image" src="https://github.com/snkty8/Electric_Vehicles/assets/78936833/177f551a-a498-44cb-9997-15f3cee94a46">

After:

<img width="350" alt="image" src="https://github.com/snkty8/Electric_Vehicles/assets/78936833/b239ccbe-beb0-424b-a317-9df0573c9079">

Then dropped the row_num column.


## Exploratoy Analysis Using PgAdmin
Found Top Sales by Make over all years. Top 5:

<img width="190" alt="image" src="https://github.com/snkty8/Electric_Vehicles/assets/78936833/fdca5ad4-d9aa-4f46-adbe-7cfe17cf65fc">

Using these top 5 makes, drilled down to total sales by Model

<img width="226" alt="image" src="https://github.com/snkty8/Electric_Vehicles/assets/78936833/004c9991-eb11-43e2-ae86-d68936931b70">

Found Average Price for each Make and Model

<img width="263" alt="image" src="https://github.com/snkty8/Electric_Vehicles/assets/78936833/6c2ced10-a44f-47b9-b8e1-04f3e5a6b3f0">

Found Average Electric Range for vehicle 

<img width="275" alt="image" src="https://github.com/snkty8/Electric_Vehicles/assets/78936833/3f067f6f-1dc5-42d4-b1c4-66f8a72805e4">

Using this info, created Summary of Top Selling [Electric Vehicles](https://public.tableau.com/app/profile/sierra.knighten/viz/Electric_Vehicles_2/SummaryofTopSellingElectricVehiclesfrom2012to2024?publish=yes) to create a story using Tableau. 

Findings, TELSA is the best selling vehicle with one of the highest electric range per charge, average price per vehicle, and total sales. 

## Issue encountered during exploration
Dataset is primarily from the state of Washington. More data would be needed to get a clearer pictures of sales across the United States and other countries. 


