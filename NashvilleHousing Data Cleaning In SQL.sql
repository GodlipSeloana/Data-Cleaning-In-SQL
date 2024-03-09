SELECT *
  FROM [SqlPortfolioProject].[dbo].[NashvilleHousingData]


   --Populating property adress data
 Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
 isnull(a.PropertyAddress,b.PropertyAddress)
   FROM [SqlPortfolioProject].[dbo].[NashvilleHousingData] as a
   join [SqlPortfolioProject].[dbo].[NashvilleHousingData] as b
   on a.ParcelID = b.ParcelID
   and a.[UniqueID ] <> b.[UniqueID ]
   Where a.PropertyAddress is null


  -- Updating the 'PropertyAddress' column in table 'a' with values from column 'PropertyAddress' in table 'b' where 'PropertyAddress' in table 'a' is NULL
Update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
FROM [SqlPortfolioProject].[dbo].[NashvilleHousingData] as a
join [SqlPortfolioProject].[dbo].[NashvilleHousingData] as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--Breaking out address into different columns address, city, state  
Select 
substring(PropertyAddress, 1, charindex(',',PropertyAddress)) as Address,
substring(PropertyAddress, charindex(',',PropertyAddress) + 1, len(PropertyAddress)) as Address2
from [SqlPortfolioProject].[dbo].[NashvilleHousingData]

Alter table [SqlPortfolioProject].[dbo].[NashvilleHousingData]
Add PropertySplitAdress nvarchar(255);


   -- Altering the data type of the 'PropertySplitAdress' column
Alter table [SqlPortfolioProject].[dbo].[NashvilleHousingData]
ALTER COLUMN PropertySplitAdress nvarchar(255);


-- Updating the 'PropertySplitAdress' column with the first part of the address
Update [SqlPortfolioProject].[dbo].[NashvilleHousingData]
Set PropertySplitAdress = substring(PropertyAddress, 1, charindex(',',PropertyAddress))


-- Adding a new column 'PropertySplitCity' to the table
Alter table [SqlPortfolioProject].[dbo].[NashvilleHousingData]
Add PropertySplitCity nvarchar(255);


-- Updating the 'PropertySplitCity' column with the city part of the address
Update [SqlPortfolioProject].[dbo].[NashvilleHousingData]
Set PropertySplitCity = substring(PropertyAddress, charindex(',',PropertyAddress) + 1, len(PropertyAddress))


-- Removing leading commas from the 'PropertySplitAdress' column
UPDATE [SqlPortfolioProject].[dbo].[NashvilleHousingData]
SET PropertySplitAdress = TRIM(',' FROM PropertySplitAdress);


-- Retrieving all columns from the updated table
Select *
from [SqlPortfolioProject].[dbo].[NashvilleHousingData]


-- Extracting the owner's address from the 'OwnerAddress' column
Select OwnerAddress
from [SqlPortfolioProject].[dbo].[NashvilleHousingData]


-- Splitting the owner's address into 'OwnerSplitState', 'OwnerSplitCity', and 'OwnerSplitAdress' columns
Select
    PARSENAME(Replace(OwnerAddress, ',' , '.' ), 3) as OwnerSplitState,
    PARSENAME(Replace(OwnerAddress, ',' , '.' ), 2) as OwnerSplitCity,
    PARSENAME(Replace(OwnerAddress, ',' , '.' ), 1) as OwnerSplitAdress
From [SqlPortfolioProject].[dbo].[NashvilleHousingData]


-- Adding a new column 'OwnerSplitAdress' to the table
Alter table [SqlPortfolioProject].[dbo].[NashvilleHousingData$]
Add OwnerSplitAdress nvarchar(255);


-- Updating the 'OwnerSplitAdress' column with the state part of the owner's address
Update [SqlPortfolioProject].[dbo].[NashvilleHousingData]
Set OwnerSplitAdress = PARSENAME(Replace(OwnerAddress, ',' , '.' ), 3)


-- Adding a new column 'OwnerSplitCity' to the table
Alter table [SqlPortfolioProject].[dbo].[NashvilleHousingData]
Add OwnerSplitCity nvarchar(255);


-- Updating the 'OwnerSplitCity' column with the city part of the owner's address
Update [SqlPortfolioProject].[dbo].[NashvilleHousingData]
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',' , '.' ), 2)


-- Adding a new column 'OwnerSplitState' to the table
Alter table [SqlPortfolioProject].[dbo].[NashvilleHousingData]
Add OwnerSplitState nvarchar(255);


-- Updating the 'OwnerSplitState' column with the state part of the owner's address
Update [SqlPortfolioProject].[dbo].[NashvilleHousingData]
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',' , '.' ), 1)


-- Retrieving all columns from the updated table
Select *
from [SqlPortfolioProject].[dbo].[NashvilleHousingData]


--Changing Y and N to Yes and No in SoldAsVacant field
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from [SqlPortfolioProject].[dbo].[NashvilleHousingData]
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, Case When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End
from [SqlPortfolioProject].[dbo].[NashvilleHousingData]

Update [SqlPortfolioProject].[dbo].[NashvilleHousingData]
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
from [SqlPortfolioProject].[dbo].[NashvilleHousingData]
--order by ParcelID
)
Select *
From RowNumCTE
where Row_num > 1
--order by PropertyAddress


--Delete Unused Columns
Alter Table [SqlPortfolioProject].[dbo].[NashvilleHousingData$]
Drop column OwnerAddress, TaxDistrict, PropertyAddress

Select *
from [SqlPortfolioProject].[dbo].[NashvilleHousingData]