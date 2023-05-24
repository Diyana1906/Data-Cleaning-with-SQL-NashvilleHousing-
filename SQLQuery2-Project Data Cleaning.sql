/*

Cleaninng Data in SQl Queries

*/ 

Select*
From PORTPROJECT.dbo.NashvilleHousing

---------------------------------------------------------------------------

-- Standardize Date Format 

select SaledateConverted, convert(date, saledate)
from PORTPROJECT.dbo.NashvilleHousing

Update NashvilleHousing
Set SaleDate = convert(date, saledate)

alter table nashvilleHousing 
add SaledateConverted date ;

Update NashvilleHousing
set SaleDateconverted = Convert(date,saledate)

--Ceck this out 
select SaleDateconverted, convert(date, saledate)
from PORTPROJECT.dbo.NashvilleHousing --succseed

select *
from PORTPROJECT.dbo.NashvilleHousing


--------------------------------------------------------------------------

-- Population Property Addres data 

select*
from PORTPROJECT.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyAddress, b.PropertyAddress)
from PORTPROJECT.dbo.NashvilleHousing a
join PORTPROJECT.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 

Update a
set PropertyAddress = ISNULL(a.propertyAddress, b.PropertyAddress)
from PORTPROJECT.dbo.NashvilleHousing a
join PORTPROJECT.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 

select *
from PORTPROJECT.dbo.NashvilleHousing
where PropertyAddress is null 

--------------------------------------------------------------------------------------
-- Breaking out Adrres into Individual Columns (Adress, City, State)

select PropertyAddress
from PORTPROJECT.dbo.NashvilleHousing

-- in PROPERTY ADRRES
select 
--SUBSTRING (propertyaddress, 1, CHARINDEX(',',PropertyAddress) -1) as Adress ,
SUBSTRING (propertyaddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as Adress
from PORTPROJECT.dbo.NashvilleHousing

alter table PORTPROJECT.dbo.NashvilleHousing
add PropertySplitAdress nvarchar(255) ;

Update PORTPROJECT.dbo.NashvilleHousing
set PropertySplitAdress = SUBSTRING (propertyaddress, 1, CHARINDEX(',',PropertyAddress) -1)

alter table PORTPROJECT.dbo.NashvilleHousing
add PropertySplitCity nvarchar(255) ;

Update PORTPROJECT.dbo.NashvilleHousing
set PropertySplitCity = SUBSTRING (propertyaddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

--Ceck this out 

select *
from PORTPROJECT.dbo.NashvilleHousing --succeseed

-- B. OWNER ADRRES WITH PARSENAME FUNCTION 

select OwnerAddress
from PORTPROJECT.dbo.NashvilleHousing 

SELECT
PARSENAME(REPLACE(OwnerAddress, ',','.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
FROM PORTPROJECT.dbo.NashvilleHousing

alter table PORTPROJECT.dbo.NashvilleHousing
add OwnerSplitAdress nvarchar(255) ;

Update PORTPROJECT.dbo.NashvilleHousing
set OwnerSplitAdress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

alter table PORTPROJECT.dbo.NashvilleHousing
add OwnerSplitCity nvarchar(255) ;

Update PORTPROJECT.dbo.NashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

alter table PORTPROJECT.dbo.NashvilleHousing
add OwnerSplitState nvarchar(255) ;

Update PORTPROJECT.dbo.NashvilleHousing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

--Ceck this out 

select *
from PORTPROJECT.dbo.NashvilleHousing --succeseed


------------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant"

Select Distinct(SoldAsVacant), count(SoldAsVacant)
From PORTPROJECT.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

Select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		End
From PORTPROJECT.dbo.NashvilleHousing

Update PORTPROJECT.dbo.NashvilleHousing
set SoldAsVacant =  case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		End

--Ceck this out
Select Distinct(SoldAsVacant), count(SoldAsVacant)
From PORTPROJECT.dbo.NashvilleHousing
group by SoldAsVacant
order by 2


-------------------------------------------------------------------------------------------------------

-- Remove Duplicate 

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

From PORTPROJECT.dbo.NashvilleHousing
--Order by ParcelID
)
Delete 
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


Select*
From PORTPROJECT.dbo.NashvilleHousing

-----------------------------------------------------------------------------------------

-- Delete Unused Column 


Select*
From PORTPROJECT.dbo.NashvilleHousing

ALTER TABLE PORTPROJECT.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict

ALTER TABLE PORTPROJECT.dbo.NashvilleHousing
DROP COLUMN SaleDate

