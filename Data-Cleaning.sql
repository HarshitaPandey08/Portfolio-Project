/*
Cleaning Data in SQL Queries
*/


Select *
From [PorjectPortfolio1].[dbo].[Housing]
--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

select SaleDateConverted,Convert(Date,SaleDate) from [PorjectPortfolio1].[dbo].[Housing];

update [PorjectPortfolio1].[dbo].[Housing]
Set SaleDate=Convert(Date,SaleDate)

--If it Doesnt work

Alter table housing
add SaleDateConverted date;

update [PorjectPortfolio1].[dbo].[Housing]
Set SaleDateConverted=Convert(Date,SaleDate)

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data
select *
from housing 
order by ParcelId

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from housing a
join housing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update  a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from housing a
join housing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
from housing

select 
substring(PropertyAddress,1,charindex(',',PropertyAddress)-1)
--substring(column_name,Starting Position,ending Position)
--charindex('search for ',Column_name) 
-- '-1' signifies to filter till one character before the result
,substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(propertyAddress))
from housing

Alter table housing
add PropertyAddressSplit nvarchar(255);

update [PorjectPortfolio1].[dbo].[Housing]
Set PropertyAddressSplit=substring(PropertyAddress,1,charindex(',',PropertyAddress)-1)

Alter table housing
add PropertyAddressCity nvarchar(255);

update [PorjectPortfolio1].[dbo].[Housing]
Set PropertyAddressCity=substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(propertyAddress))

Select *
from housing

--Alternate Method
Select OwnerAddress
from housing

select 
Parsename(Replace(ownerAddress,',','.'),3)
--Parsename(ownerAddress,3) will only return NULL values as PARSENAME only searches for '.'
--therefore '.' has to be replaced by ',' 
--Parsename filters from the oppsoite end so 3 will return the first part
,Parsename(Replace(ownerAddress,',','.'),2),
Parsename(Replace(ownerAddress,',','.'),1)
from housing

Alter table housing
add OwnerAddressSplit nvarchar(255);

update [PorjectPortfolio1].[dbo].[Housing]
Set OwnerAddressSplit=Parsename(Replace(ownerAddress,',','.'),3)

Alter table housing
add OwnerAddressCity nvarchar(255);

update [PorjectPortfolio1].[dbo].[Housing]
Set OwnerAddressCity=Parsename(Replace(ownerAddress,',','.'),2)

Alter table housing
add OwnerAddressState nvarchar(255);

update [PorjectPortfolio1].[dbo].[Housing]
Set OwnerAddressState=Parsename(Replace(ownerAddress,',','.'),1)

Select *
from housing

--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field
select distinct(SoldAsVacant),count(SoldAsVacant)
from housing
group by SoldAsVacant

update housing
set SoldAsVacant='No'
where SoldAsVacant='N'

update housing
set SoldAsVacant='Yes'
where SoldAsVacant='Y'

--Alternate method
Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

--select * from housing
WITH RowNumCTE AS
(Select *,
	ROW_NUMBER() OVER 
	(PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID)  row_num
From Housing)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


WITH RowNumCTE AS
(Select *,
	ROW_NUMBER() OVER 
	(PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID)  row_num
From Housing)

delete 
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


Select *
From Housing


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
From Housing


ALTER TABLE Housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
