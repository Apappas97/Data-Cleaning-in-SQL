/*

Project: Data Cleaning a Nasvhille Housing Dataset 

Sills Used: Converting Datatypes, Populate Empty Fields, Joins, String Functions, 
			ALTER TABLE Statements, Case Statements, Window Functions, CTE (WITH Clause)
			
*/

-- Dataset contains real estate information for Nashville

 --------------------------------------------------------------------------------------------------------------------------

	/* Standardize Date Format */

-- Convert the column "SaleDate" to have a Standardized Date format "YYYY-MM-DD"

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

 --------------------------------------------------------------------------------------------------------------------------

	/* Populate the "ProperyAddress" column where the Value are NULL */ 

SELECT *
FROM 
	[Portfolio Project]..HousingData
WHERE PropertyAddress IS NULL
ORDER BY 
	ParcelID

-- Display and Replace the All NULL values with an Address that shares the same Parcel-ID 
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

-- Populate NULL values with addresses 
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

 --------------------------------------------------------------------------------------------------------------------------

	/* Break apart the PropertyAddress column into two columns for the Address and City */

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


	/* Break apart the OwnerAddress column into three columns for the Address, City, and State */

-- Use PARSENAME instead of SUBSTRING to break out the full address into (address, city, state)
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

--------------------------------------------------------------------------------------------------------------------------

	/* Use a CASE statement to Change Y and N to Yes and No in "Sold as Vacant" field */

SELECT DISTINCT
	(SoldAsVacant), COUNT(SoldAsVacant)
FROM 
	[Portfolio Project]..HousingData
GROUP BY 
	SoldAsVacant
ORDER BY 2;


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

--------------------------------------------------------------------------------------------------------------------------

	/* Remove Unnecessary Duplicate Values from the Dataset */

WITH Rows_Duplicated
AS
(
--PARTITION BY columns that contain duplicates 
SELECT *, 
	   ROW_NUMBER() OVER (PARTITION BY ParcelID,
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

--There were 104 rows considered to be duplicates 

--------------------------------------------------------------------------------------------------------------------------

	/* Delete Unused Columns */

SELECT * 
FROM 
	[Portfolio Project]..HousingData

ALTER TABLE 
	[Portfolio Project]..HousingData
DROP COLUMN 
	OwnerAddress, 
	PropertyAddress,
	SaleDate;

--No longer need "PropertyAddress" and "OwnerAddress" because new columns were created to represent address, city, and state
--No longer need "SaleDate" because a new column was created to correct how the date was originally formatted
