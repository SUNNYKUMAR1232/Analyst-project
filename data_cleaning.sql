/*

Cleaning Data in SQL Queries
Housing Data
*/


Select *
From [SQL Practice].dbo.data

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format
-- Sale Date has formate date time convert to only date yy-mm-dd


Select SaleDate, CONVERT(Date,SaleDate)
From [SQL Practice].dbo.data


Update data
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE data
Add SaleDateConverted Date;

Update data
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data
-- parcelID same for both a and b , may be dublicate but be observe diffrent uniqueID so its not dublicate somthing update that is SalePrice
-- we copy b address to a address

Select *
From [SQL Practice].dbo.data
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [SQL Practice].dbo.data a
JOIN [SQL Practice].dbo.data b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [SQL Practice].dbo.data a
JOIN [SQL Practice].dbo.data b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)
-- 

Select PropertyAddress
From [SQL Practice].dbo.data

-- CHARINDEX gives char position number
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From [SQL Practice].dbo.data


ALTER TABLE data
Add PropertySplitAddress Nvarchar(255);

Update data
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE data
Add PropertySplitCity Nvarchar(255);

Update data
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From [SQL Practice].dbo.data





Select OwnerAddress
From [SQL Practice].dbo.data

-- PARSENAME seperate words around period '.' gives in reverse order

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [SQL Practice].dbo.data



ALTER TABLE data
Add OwnerSplitAddress Nvarchar(255);

Update data
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE data
Add OwnerSplitCity Nvarchar(255);

Update data
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE data
Add OwnerSplitState Nvarchar(255);

Update data
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From [SQL Practice].dbo.data




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field
-- in dataset SoldAsVacant colomun formate {Y,N,Yes,No} convert to {Yes,No} only

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [SQL Practice].dbo.data
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [SQL Practice].dbo.data


Update data
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
-- Find Dublicate using window function 

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [SQL Practice].dbo.data
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From [SQL Practice].dbo.data




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate





























