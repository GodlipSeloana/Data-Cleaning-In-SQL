
SELECT *
  FROM [PotfolioProject].[dbo].[NashvilleHousing]


 --Populate property adress data
 Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
 isnull(a.PropertyAddress,b.PropertyAddress)
   FROM [PotfolioProject].[dbo].[NashvilleHousing] as a
   join [PotfolioProject].[dbo].[NashvilleHousing] as b
   on a.ParcelID = b.ParcelID
   and a.[UniqueID ] <> b.[UniqueID ]
   Where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from [PotfolioProject].[dbo].[NashvilleHousing] as a
join [PotfolioProject].[dbo].[NashvilleHousing] as b
   on a.ParcelID = b.ParcelID
   and a.[UniqueID ] <> b.[UniqueID ]
   Where a.PropertyAddress is null



--Breaking out address into different columns address, city, state  
Select PropertyAddress
from [PotfolioProject].[dbo].[NashvilleHousing]

Select 
substring(PropertyAddress, 1, charindex(',',PropertyAddress)) as Address,
substring(PropertyAddress, charindex(',',PropertyAddress) + 1, len(PropertyAddress)) as Address2
from [PotfolioProject].[dbo].[NashvilleHousing]

Alter table [PotfolioProject].[dbo].[NashvilleHousing]
Add PropertySplitAdress nvarchar(255);

Alter table [PotfolioProject].[dbo].[NashvilleHousing]
ALTER COLUMN PropertySplitAdress nvarchar(255);

Update [PotfolioProject].[dbo].[NashvilleHousing]
Set PropertySplitAdress = substring(PropertyAddress, 1, charindex(',',PropertyAddress))

Alter table [PotfolioProject].[dbo].[NashvilleHousing]
Add PropertySplitCity nvarchar(255);

Update [PotfolioProject].[dbo].[NashvilleHousing]
Set PropertySplitCity = substring(PropertyAddress, charindex(',',PropertyAddress) + 1, len(PropertyAddress))

UPDATE [PotfolioProject].[dbo].[NashvilleHousing]
SET PropertySplitAdress = TRIM(',' FROM PropertySplitAdress);

Select *
from [PotfolioProject].[dbo].[NashvilleHousing]

Select OwnerAddress
from [PotfolioProject].[dbo].[NashvilleHousing]

Select
PARSENAME(Replace(OwnerAddress, ',' , '.' ), 3),
PARSENAME(Replace(OwnerAddress, ',' , '.' ), 2),
PARSENAME(Replace(OwnerAddress, ',' , '.' ), 1)
From [PotfolioProject].[dbo].[NashvilleHousing]

Alter table [PotfolioProject].[dbo].[NashvilleHousing]
Add OwnerSplitAdress nvarchar(255);

Update [PotfolioProject].[dbo].[NashvilleHousing]
Set OwnerSplitAdress = PARSENAME(Replace(OwnerAddress, ',' , '.' ), 3)

Alter table [PotfolioProject].[dbo].[NashvilleHousing]
Add OwnerSplitCity nvarchar(255);

Update [PotfolioProject].[dbo].[NashvilleHousing]
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',' , '.' ), 2)

Alter table [PotfolioProject].[dbo].[NashvilleHousing]
Add OwnerSplitState nvarchar(255);

Update [PotfolioProject].[dbo].[NashvilleHousing]
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',' , '.' ), 1)

Select *
from [PotfolioProject].[dbo].[NashvilleHousing]



--Changing Y and N to Yes and No in SoldAsVacant field
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from [PotfolioProject].[dbo].[NashvilleHousing]
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, Case When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End
from [PotfolioProject].[dbo].[NashvilleHousing]

Update [PotfolioProject].[dbo].[NashvilleHousing]
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End



--Remove Duplicates
with RowNumCTE AS(
Select *,
Row_Number() Over (
Partition by parcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 Order by
			 UniqueID
			 ) as Row_num
from [PotfolioProject].[dbo].[NashvilleHousing]
--order by ParcelID
)

Select *
From RowNumCTE
where Row_num > 1
--order by PropertyAddress



--Delete Unused Columns

Select *
from [PotfolioProject].[dbo].[NashvilleHousing]


Alter Table [PotfolioProject].[dbo].[NashvilleHousing]
Drop column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table [PotfolioProject].[dbo].[NashvilleHousing]
Drop column SaleDate