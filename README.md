# Data Cleaning in SQL
In this project, I extracted and cleansed a Nashville-Housing dataset that contained discrepancies in duplicate records, formatting errors, NULL values, etc.. In the cleansing process I made the necessary adjustments to reduce these inconsistencies using Microsoft SQL Server to increase the utility and overall readability in the dataset.
# Demonstrated Skills: 
* Converting Datatypes 
* Populate columns containing NULL values 
* Joins 
* String Functions (SUBSTRING & PARSENAME)
* ALTER/UPDATE TABLE Statements 
* Case Statements 
* Window Functions (ROW
* Common Table Expressions (CTE - WITH Clause)
# Objectives:
* Covert the Date column to have a Standardized Date format
* Populate columns containing NULL values 
* Use SUBSTRING and PARSENAME to break apart columns with full addresses 
* Standardize and replace fields with Y/N to Yes/No  
* Find and Remove Duplicates 
* Delete unused columns
# Queries:
## Convert the Column "SaleDate" from a DateTime Format to a Standardized Date Format "YYYY-MM-DD"
```TSQL
SELECT 
	SaleDate, 
	CONVERT(Date,SaleDate)
FROM 
	[Portfolio Project]..HousingData

-- Add a new column labeled "Date_of_Sale"
ALTER TABLE 
	HousingData
ADD 
	Date_of_Sale Date;

-- Populate Date_of_Sale with the new format
UPDATE 
	HousingData
SET 
	Date_of_Sale = CONVERT(Date,SaleDate)
```
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/SaleDate_Results.png">
</p>

* There is no timestamp recorded for when sales actually occur, so I converted the format to make it easier to read. 
## Discrepancies in the "PropertyAddress" Column
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/IDandAddress.png">
</p>

* Each Parcel-ID is assigned to a Property Address. 
* When the Parcel-ID is repeated with the same ID more than once, then the Property Address will do so as well.
    * However, there are some discrepancies where the Property Address generates a NULL address instead of a duplicate. 

### Replace All NULL addresses in "PropertyAddress" with Addresses that Have the Same Duplicated Parcel-ID
```TSQL
SELECT 
	a.ParcelID,
	a.PropertyAddress, 
	b.ParcelID,
	b.PropertyAddress,
	-- Use ISNULL to locate NULL addresses in a.PropertyAddress and replace with b.PropertyAddress
	ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM 
	[Portfolio Project]..HousingData a
JOIN 
	[Portfolio Project]..HousingData b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE 
	a.PropertyAddress IS NULL
```
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/ISNULL_Results.png">
</p>

### Populate Values and Update Table 
```TSQL
UPDATE a
SET 
	PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress) 
FROM 
	[Portfolio Project]..HousingData a
JOIN 
	[Portfolio Project]..HousingData b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE 
	a.PropertyAddress IS NULL
```
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/UpdateAddress.png">
</p> 

* To confirm that the addresses were populated, I ran the script, and it checks out that there are no longer any NULL values in the "PropertyAddress" column. 
## Separate the Address and City in the "PropertyAddress" Column 
```TSQL
SELECT 
	PropertyAddress,
	-- Starting from position 1 up to the comma to obtain the address
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
	-- Starting 1 position after the comma up to the end of the string to obtain the city
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City
FROM 
	[Portfolio Project]..HousingData

-- Create new columns
ALTER TABLE 
	HousingData
ADD
	Property_Address NVARCHAR(255),
	Property_City NVARCHAR(255);

-- Populate columns
UPDATE 
	HousingData
SET 
	Property_Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1),
	Property_City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));
```
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/Breakout_Results.png">
</p>

* Create new columns and populate them with values obtained from the SUBSTRINGS
## Separate the Address, City, and State in the "OwnerAddress" Column 
```TSQL
SELECT
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),  													
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2), 
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM 
	[Portfolio Project]..HousingData

-- Create new columns
ALTER TABLE 
	HousingData
ADD 
	Owner_Address NVARCHAR(255),
	Owner_City NVARCHAR(255),
	Owner_State NVARCHAR(255);

-- Populate the new columns
UPDATE 
	HousingData
SET 
	Owner_Address = PARSENAME(REPLACE(OwnerAddress,',','.'),3),
	Owner_City = PARSENAME(REPLACE(OwnerAddress,',','.'),2),
	Owner_State = PARSENAME(REPLACE(OwnerAddress,',','.'),1);
```
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/Owner_Results.png">
</p>

* PARESENAME is an alternative to SUBSTRING that does not recognize a comma(,) as a delimiter but instead recognizes a period(.) as one. 
   * Used REPLACE to substitute commas for periods 
## Use a CASE Statement to Change Y and N to Yes and No in the "SoldAsVacant" Column
```TSQL
SELECT DISTINCT
	(SoldAsVacant), COUNT(SoldAsVacant)
FROM 
	[Portfolio Project]..HousingData
GROUP BY 
	SoldAsVacant
ORDER BY 2;
```
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/YNBefore.png">
</p>

* Note that before making any changes, there are 52 occurrences where Y is displayed in the data and 399 occurrences where N is displayed.

```TSQL
-- Replace Y/N with Yes/No
SELECT 
	SoldAsVacant,
CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END;
FROM 
	[Portfolio Project]..HousingData;

-- Populate
UPDATE 
	HousingData
SET 
	SoldAsVacant = CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END;
```
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/YNAfter.png">
</p>

* Specify the condition and what you want returned once that condition is met
* Updates the HousingData table to reflect changes made in the CASE statement
* Note that there are now more occurrences when Yes and No are displayed in the dataset due to converting Y/N to Yes/No.
## Identify and Delete all Duplicate Values from the Dataset
```TSQL
WITH Rows_Duplicated
AS
(
--PARTITION BY columns that contain duplicates 
SELECT *, 
	   ROW_NUMBER() OVER (PARTITION BY 
	   ParcelID,
	   PropertyAddress,
	   SalePrice,
	   SaleDate,
	   LegalReference
	   ORDER BY UniqueID) AS row_num
FROM 
	[Portfolio Project]..HousingData
)
SELECT *
FROM 
	Rows_Duplicated
WHERE 
	row_num > 1;

--DELETE *
--FROM 
--	Rows_Duplicated
--WHERE 
--	row_num > 1
```

* 104 rows of duplicates were Identified 
## Drop Unused Columns
```TSQL
SELECT * 
FROM 
	[Portfolio Project]..HousingData

ALTER TABLE 
	[Portfolio Project]..HousingData
DROP COLUMN 
	OwnerAddress, 
	PropertyAddress,
	SaleDate;
```

* No longer need "PropertyAddress" and "OwnerAddress" because individual columns were created to represent address, city, and state.
* No longer need "SaleDate" because the new column "Date_of_Sale" was created for the purpose of re-formatting the date. 
