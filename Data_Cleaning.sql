-- Cleaning Data in SQL Queries

Select * From [PortifolioProjects].[dbo].[Housing]

-- Standardize Date Format 
Select SaleDate, CONVERT(Date,SaleDate)
From  [PortifolioProjects].[dbo].[Housing]

ALTER TABLE [PortifolioProjects].[dbo].[Housing]
Add SalesDateConverted Date;

Update [PortifolioProjects].[dbo].[Housing]
SET SalesDateConverted = CONVERT(Date, SaleDate)

--POPULATE PROPERTY ADDRESS DATA
--- BY JOINING THE TABLE TO ITSELF 
Select * From [PortifolioProjects].[dbo].[Housing]
Order BY ParcelID 

Select A.ParcelID,A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM [PortifolioProjects].[dbo].[Housing] A
JOIN [PortifolioProjects].[dbo].[Housing] B
ON A.ParcelID =B.ParcelID 
AND A.[UniqueID ] <> B.[UniqueID ]
Where A. PropertyAddress is null

Update A
SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM [PortifolioProjects].[dbo].[Housing] A
JOIN [PortifolioProjects].[dbo].[Housing] B
ON A.ParcelID =B.ParcelID 
AND A.[UniqueID ] <> B.[UniqueID ]
Where A. PropertyAddress is null

-- Breaking out Address into individual columns (Address,City,State)

Select PropertyAddress From [PortifolioProjects].[dbo].[Housing] 

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as Adress
From [PortifolioProjects].[dbo].[Housing] 


ALTER TABLE [PortifolioProjects].[dbo].[Housing]
Add PropertySplitAddress Nvarchar(255);

Update [PortifolioProjects].[dbo].[Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE [PortifolioProjects].[dbo].[Housing]
Add PropertySplitCity Nvarchar(255);

Update [PortifolioProjects].[dbo].[Housing]
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

-- Breaking out OwnerAddress into individual columns(Address,City,State)

Select 
PARSENAME(REPLACE(OwnerAddress,',','.') ,3),
PARSENAME(REPLACE(OwnerAddress,',','.') ,2),
PARSENAME(REPLACE(OwnerAddress,',','.') ,1)
from [PortifolioProjects].[dbo].[Housing]

ALTER TABLE [PortifolioProjects].[dbo].[Housing]
Add OwnerSplitAddress Nvarchar(255);

Update [PortifolioProjects].[dbo].[Housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.') ,3)


ALTER TABLE [PortifolioProjects].[dbo].[Housing]
Add OwnerSplitCity Nvarchar(255);

Update [PortifolioProjects].[dbo].[Housing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.') ,2)

ALTER TABLE [PortifolioProjects].[dbo].[Housing]
Add OwnerSplitState Nvarchar(255);

Update [PortifolioProjects].[dbo].[Housing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.') ,1)


-- CHANGE Y AND N TO YES AND NO IN "SoldAsVacant"
Select SoldAsVacant
, CASE WHEN  SoldAsVacant ='Y'  THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM [PortifolioProjects].[dbo].[Housing]

Update  [PortifolioProjects].[dbo].[Housing]
SET SoldAsVacant =  CASE WHEN  SoldAsVacant ='Y'  THEN 'Yes'
                    WHEN SoldAsVacant = 'N' THEN 'No'
	                ELSE SoldAsVacant
	                END

--- REMOVE DUPLICATES 

WITH RowNumCTE AS(
Select *,
  ROW_NUMBER() OVER(PARTITION BY ParcelID,
                       PropertyAddress,
					   SalePrice,
					   SaleDate,
					   LegalReference
					   ORDER BY 
					   UniqueID 
					   ) row_num
From [PortifolioProjects].[dbo].[Housing]
)

/*Delete from RowNumCTE
where row_num >1 */

-- Delete Unused Columns 

Select * 

From [PortifolioProjects].[dbo].[Housing]

Alter Table [PortifolioProjects].[dbo].[Housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress 


Alter Table [PortifolioProjects].[dbo].[Housing]
Drop Column SaleDate 
