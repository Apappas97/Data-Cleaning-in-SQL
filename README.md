# Data-Cleaning in SQL
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
<img width ="400" height="300" src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/Date_Converted.png">
</p>
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/SaleDate_Results.png">
</p>

* There is no timestamp recorded for when sales actually occur, so I converted the format to make it easier to read. 
## Discrepancies in the "PropertyAddress" Column
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/IDandAddress.png">
</p>

* Each Parcel-ID is assigned to a Property Address. 
* When the Parcel-ID is repeated with the same ID more than once, then the Property Address will do so as well.
    * However, there are some discrepancies where the Property Address generates a NULL value instead of duplicating the same address that was used before. 

### Display and Replace the All NULL Values with an Address that Shares the same Parcel-ID 
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/ISNULL.png">
</p>
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/ISNULL_Results.png">
</p>

### Populate Values and Update Table 
* To confirm that the addresses were populated, I ran the script and it checks out that there are no longer any NULL values in the "PropertyAddress" column. 
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/Update_property.png">
</p> 
## Seperate the Address and City in the "PropertyAddress" Column 
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/Breakout.png">
</p>
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/Breakout_Results.png">
</p>

* Starting from position 1 up to the comma to obtain only the address portion 
* Starting 1 position after the comma up to the end of the string will obtain the city
* Create new columns and populate them with values obtained from the SUBSTRINGS
## Seperate the Address, City, and State in the "OwnerAddress" Column 
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/Owner_Breakout.png">
</p>
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/Owner_Results.png">
</p>

* PARESENAME is an alternative to SUBSTRING that does not recognize a ',' as a delimiter but instead recognizes a period '.' as one. 
   * Used REPLACE to substitute commas for periods 
## Usa a CASE Statement to Change Y and N to Yes and No in the "SoldAsVacant" Column
<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/Y_N_Before.png">
</p>

* Note that before making any changes, there are 52 occurrences where Y is displayed in the data and 399 occurrences where N is displayed.

<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/Y_N_Case.png">
</p>

* Specify the condition and what you want returned once that condition is met
* Updates the HousingData table to reflect changes made in the CASE statement

<img src="https://github.com/Apappas97/Data-Cleaning-in-SQL/blob/main/Images/Y_N_After.png">
</p>

* Note that there are now more occurances when Yes and No are diplayed in the dataset due to converting Y/N to Yes/No.
