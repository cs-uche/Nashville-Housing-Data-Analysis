/*
-- Purpose: Data Cleaning of Nashville Housing data
-- Author: Sopuruchi Chisom
-- Data Source: https://www.kaggle.com/datasets/tmthyjames/nashville-housing-data
*/

/*
PLAN
1. Standardize date
2. Populate property address format
3. Breaking the Address into different columns
4. Change values to make them discrete
5. Remove duplicates 
6. Removing unused columns
*/

SELECT *
FROM [Portfolio Project]..[NashvilleHousing];

-- 1
SELECT SaleDate
FROM [Portfolio Project]..NashvilleHousing

ALTER TABLE [Portfolio Project]..NashvilleHousing
ALTER COLUMN SaleDate Date;


--2
SELECT *
FROM [Portfolio Project]..[NashvilleHousing]
ORDER BY ParcelID;


SELECT house_a.ParcelID, house_a.PropertyAddress, house_b.ParcelID, house_b.PropertyAddress, COALESCE(house_a.PropertyAddress,house_b.PropertyAddress) AS PropertyAddress_Replace
FROM [Portfolio Project]..NashvilleHousing AS house_a
JOIN [Portfolio Project]..[NashvilleHousing] AS house_b
	ON house_a.ParcelID=house_b.ParcelID AND house_a.[UniqueID ]<>house_b.[UniqueID ]
	WHERE house_a.PropertyAddress IS NULL;

UPdate house_a
SET PropertyAddress = COALESCE(house_a.PropertyAddress,house_b.PropertyAddress)
FROM [Portfolio Project]..NashvilleHousing AS house_a
JOIN [Portfolio Project]..[NashvilleHousing] AS house_b
	ON house_a.ParcelID=house_b.ParcelID AND house_a.[UniqueID ]<>house_b.[UniqueID ]
	WHERE house_a.PropertyAddress IS NULL;

--SELECT PropertyAddress
--FROM [Portfolio Project]..NashvilleHousing
--WHERE PropertyAddress IS NULL;


--3
SELECT PropertyAddress
FROM [Portfolio Project]..NashvilleHousing;

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) AS City
FROM [Portfolio Project]..NashvilleHousing;

ALTER TABLE [Portfolio Project]..NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255), PropertySplitCity NVARCHAR(255);

UPdate house_a
SET PropertyAddress = COALESCE(house_a.PropertyAddress,house_b.PropertyAddress)
FROM [Portfolio Project]..NashvilleHousing AS house_a
JOIN [Portfolio Project]..[NashvilleHousing] AS house_b
	ON house_a.ParcelID=house_b.ParcelID AND house_a.[UniqueID ]<>house_b.[UniqueID ]
	WHERE house_a.PropertyAddress IS NULL;

UPDATE NashvilleHousing
SET PropertySplitAddress=SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1),
	PropertySplitCity=SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))
FROM [Portfolio Project]..NashvilleHousing;

-- Validate change
--SELECT TOP 15 PropertySplitAddress, PropertySplitCity
--FROM [Portfolio Project]..NashvilleHousing;


--SELECT TOP(10) OwnerAddress
--FROM [Portfolio Project]..NashvilleHousing;

--SELECT PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
--	PARSENAME(REPLACE(OwnerAddress,',','.'),2),
--	PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
--FROM [Portfolio Project]..NashvilleHousing;

ALTER TABLE [Portfolio Project]..NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255), 
	OwnerSplitCity NVARCHAR(255),
	OwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
	OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2),
	OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
FROM [Portfolio Project]..NashvilleHousing;

--SELECT top(10) OwnerAddress, OwnerSplitAddress, OwnerSplitCity, OwnerSplitState
--FROM [Portfolio Project]..NashvilleHousing



--4
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [Portfolio Project]..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant,
CASE 
	WHEN SoldAsVacant='Y' THEN 'Yes'
	WHEN SoldAsVacant='N' THEN 'No'
	ELSE SoldAsVacant
END AS Standardized_Options
FROM [Portfolio Project]..NashvilleHousing;

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant='Y' THEN 'Yes'
						WHEN SoldAsVacant='N' THEN 'No'
						ELSE SoldAsVacant
					END
FROM [Portfolio Project]..NashvilleHousing;



-- 5
WITH row_num_cte AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	ORDER BY UniqueId) AS row_num
FROM [Portfolio Project].dbo.NashvilleHousing
--ORDER BY ParcelID
)
SELECT * 
INTO #removed_duplicates_nashville_housing
FROM row_num_cte
WHERE row_num>1
ORDER BY PropertyAddress;

WITH row_num_cte AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	ORDER BY UniqueId) AS row_num
FROM [Portfolio Project].dbo.NashvilleHousing
)
DELETE
FROM row_num_cte
WHERE row_num>1;



--6
--save the removed duplicates to a temp table 
SELECT *
FROM [Portfolio Project]..NashvilleHousing;

SELECT OwnerName, TaxDistrict, PropertyAddress
INTO #removed_columns_nashville_housing
FROM [Portfolio Project]..NashvilleHousing;

ALTER TABLE [Portfolio Project]..NashvilleHousing
DROP COLUMN OwnerName, TaxDistrict, PropertyAddress;


SELECT *
FROM [Portfolio Project]..NashvilleHousing
WHERE OwnerSplitState IS NULL;

SELECT DISTINCT OwnerSplitState
FROM [Portfolio Project]..NashvilleHousing;
