# Nashville Housing Data Analysis
The Nashville Housing Data Cleaning project aim to enhance the quality and structure of the Nashville Housing dataset, available from Kaggle. The dataset, sourced from [link](https://www.kaggle.com/datasets/tmthyjames/nashville-housing-data), contains valuable information about property sales in Nashville.

## Data Cleaning Steps
1. Standardize date
    * Extract the SaleDate from the NashvilleHousing dataset.
    * Alter the SaleDate column to ensure a standardized Date format.
2. Populate property address format
    * Identify and replace missing PropertyAddress entries by merging duplicate records based on ParcelID.
    * Update the PropertyAddress with a non-null value where it is currently missing.
3. Breaking the Address into different columns
    * Split the PropertyAddress into separate columns for Address and City.
4. Change values to make them discrete
    * Standardize the SoldAsVacant column values to 'Yes' or 'No'.
5. Remove duplicates 
    * Identify and remove duplicate records based on selected columns.
    * Save removed duplicates to a temporary table for reference.
6. Removing unused columns
    * Save selected columns to a temporary table before dropping them from the main table.
