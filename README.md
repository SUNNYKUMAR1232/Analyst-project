# 🏡 Housing Data Cleaning Project

This project demonstrates **data cleaning using SQL** on the *Housing Dataset*.  
It focuses on preparing raw housing data for analysis by applying best practices in SQL data transformation.

---

## 📂 Repository Structure

```text
Housing-Data-Cleaning/
│
├── README.md
├── data_cleaning.sql
└── data/
    └── Housing Data for Data Cleaning.xlsx
```

---

## 📋 Dataset

**File:** `Housing Data for Data Cleaning.xlsx`  
**Source:** Provided dataset for cleaning practice .

---

## 🧩 Objectives

1. Standardize date formats
2. Populate missing property addresses
3. Split address columns into multiple fields
4. Normalize categorical data (Yes/No values)
5. Remove duplicates
6. Drop unused columns

---

## ⚙️ Technologies Used

- Microsoft SQL Server
- SQL (T-SQL Syntax)
- SSMS (SQL Server Management Studio)

---

## 🧱 Data Cleaning Steps

### 1️⃣ Standardize Date Format

Converted `SaleDate` from datetime to date (`yyyy-mm-dd`).

```sql
UPDATE data
SET SaleDate = CONVERT(Date, SaleDate);
```

If direct conversion failed:

```sql
ALTER TABLE data ADD SaleDateConverted Date;
UPDATE data SET SaleDateConverted = CONVERT(Date, SaleDate);
```

### 2️⃣ Populate Missing Property Addresses

Used `ParcelID` to fill missing `PropertyAddress` from duplicate rows.

```sql
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM data a
JOIN data b
    ON a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;
```

### 3️⃣ Split Property Address into Components

```sql
ALTER TABLE data ADD PropertySplitAddress NVARCHAR(255);
ALTER TABLE data ADD PropertySplitCity NVARCHAR(255);

UPDATE data
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1),
    PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));
```

### 4️⃣ Split Owner Address into Components

Used `PARSENAME` with replaced commas for splitting into Address, City, and State.

```sql
ALTER TABLE data ADD OwnerSplitAddress NVARCHAR(255);
ALTER TABLE data ADD OwnerSplitCity NVARCHAR(255);
ALTER TABLE data ADD OwnerSplitState NVARCHAR(255);

UPDATE data
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
    OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
    OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);
```

### 5️⃣ Normalize "SoldAsVacant" Field

Converted inconsistent Y/N values to Yes/No.

```sql
UPDATE data
SET SoldAsVacant = CASE
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
END;
```

### 6️⃣ Remove Duplicates

Used a CTE with `ROW_NUMBER()` to identify and remove duplicate rows.

```sql
WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
            ORDER BY UniqueID
        ) row_num
    FROM data
)
DELETE FROM RowNumCTE WHERE row_num > 1;
```

### 7️⃣ Drop Unused Columns

Removed redundant columns after transformation.

```sql
ALTER TABLE data
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;
```

---

## 📊 Results

- Cleaned dataset ready for analysis
- Consistent formats across all key fields
- No duplicates or null address values remaining

---

## 🧠 Learning Outcomes

- Hands-on experience in SQL data transformation
- Understanding of real-world data cleaning workflow
- Best practices in SQL scripting and documentation

---

## 📁 Folder Guide

| Folder/File         | Description                               |
|---------------------|-------------------------------------------|
| data_cleaning.sql   | SQL script containing all transformations |
| data/               | Folder to store the original dataset      |
| README.md           | Documentation                |

---

## 👨‍💻 Author

**Sunny Kumar**  
Competitive Programmer & Full Stack Developer  
NIT Rourkela
# Analyst-project
