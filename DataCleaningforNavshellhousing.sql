/*

Cleaning Data in SQL Queris
*/

Select *
From PortfolioProject.dbo.Navshellhousing

------------------------------------------------------------------

--Standardize Data Format

Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.Navshellhousing

Update Navshellhousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE Navshellhousing
Add SaleDateConverted Date;

Update Navshellhousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

----------------------------------------------------------------------------

--Populate Property Address Data


Select *
From PortfolioProject.dbo.Navshellhousing
--Where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.Navshellhousing a
JOIN PortfolioProject.dbo.Navshellhousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.Navshellhousing a
JOIN PortfolioProject.dbo.Navshellhousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-------------------------------------------------------------------------------

--Breaking out Address into	Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.Navshellhousing
--Where PropertyAddress is null
--order by ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
        
From PortfolioProject.dbo.Navshellhousing


ALTER TABLE Navshellhousing
Add PropertySplitAddress Nvarchar(255);

Update Navshellhousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


ALTER TABLE Navshellhousing
Add PropertySplitCity Nvarchar(255);

Update Navshellhousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))



Select *
From PortfolioProject.dbo.Navshellhousing


Select OwnerAddress
From PortfolioProject.dbo.Navshellhousing


Select
PARSENAME(REPLACE(OwnerAddress,',','.') ,3)
,PARSENAME(REPLACE(OwnerAddress,',','.') ,2)
,PARSENAME(REPLACE(OwnerAddress,',','.') ,1)
From PortfolioProject.dbo.Navshellhousing



ALTER TABLE Navshellhousing
Add OwnerSplitAddress Nvarchar(255);

Update Navshellhousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.') ,3)


ALTER TABLE Navshellhousing
Add OwnerSplitCity Nvarchar(255);

Update Navshellhousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.') ,2)

ALTER TABLE Navshellhousing
Add OwnerSplitstate Nvarchar(255);

Update Navshellhousing
SET OwnerSplitstate = PARSENAME(REPLACE(OwnerAddress,',','.') ,1)

Select *
From PortfolioProject.dbo.Navshellhousing

------------------------------------------------------------------------------------

--Chnge Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldasVacant)
From PortfolioProject.dbo.Navshellhousing
Group by SoldAsVacant
order by 2



Select SoldAsVacant
, CASE	when SoldAsVacant = 'Y' THEN 'Yes'
		when SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
From PortfolioProject.dbo.Navshellhousing


Update Navshellhousing
SET SoldAsVacant = CASE	when SoldAsVacant = 'Y' THEN 'Yes'
		when SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END

------------------------------------------------------------------------

--Remove Duplicates

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
From PortfolioProject.dbo.Navshellhousing
--order by ParcelID
)
Select *
from RowNumCTE
Where row_num > 1
Order by PropertyAddress

Select *
From PortfolioProject.dbo.Navshellhousing

------------------------------------------------------------------------------

--Delete Unused Columns

Select *
From PortfolioProject.dbo.Navshellhousing

ALTER TABLE PortfolioProject.dbo.Navshellhousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.Navshellhousing
DROP COLUMN SaleDate