# Data-Cleaning in SQL
In this project, I extracted a Nashville-Housing dataset in which I found inconsistencies in duplicate records, formatting errors, redundant data, empty fields, and more. In the cleansing process I made the necessary adjustments to reduce these inconsistencies using Microsoft SQL Server in order to boosts the efficiency, utility, and overall readability of the dataset.
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
<img width ="400" height="300" src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/Date_Converted.png">
</p>
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/SaleDate_Results.png">
</p>

* There is no timestamp recorded for when sales actually occur, so I converted the format to make it easier to read. 
## Discrepancies in the PropertyAddress Column
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/IDandAddress.png">
</p>

* Each Parcel-ID is assigned to a Property Address. 
* When the Parcel-ID is repeated with the same ID more than once, then the Property Address will do so as well.
    * However, there are some discrepancies where the Property Address generates a NULL value instead of duplicating the same address that was used before. 

### Display and Replace the All NULL values with an Address that shares the same Parcel-ID 
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/ISNULL.png">
</p>
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/ISNULL_Results.png">
</p>

### Populate Values and Update Table 
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/Update_property.png">
</p>

* To confirm that the addresses were populated, I ran the script and it checks out that there are no longer any NULL values in the PropertyAddress column. 

## Seperate the Address and City in the PropertyAddress Column 
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/Breakout.png">
</p>
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/Breakout_Results.png">
</p>

* Starting from position 1 up to the comma to obtain to obtain only the address portion 
* Starting 1 position after the comma up to the end of the string will obtain the city
* Create new columns and populate them with values obtained from the SUBSTRINGS
