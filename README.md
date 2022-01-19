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
<img width= "400" height="300" src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/Date_Converted.png">
</p>
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/SaleDate_Results.png">
</p>

* There is no timestamp recorded for when sales actually occur, so I converted the format to make it easier to read. 
## Populate the NULL Addresses
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/IDandAddress.png">
</p>

* The ParcelID and PropertyAddress are linked, however, sometimes when the ParcelID is duplicated the PropertyAddress generates a NULL value. 
#### Use a JOIN and ISNULL statement to locate and replace NULL values with addresses that come from another duplicated ParcelID like the ones you see above
<img width= "700" height="350" src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/ISNULL.png">
</p>
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/ISNULL_Results.png">
</p>

* 
