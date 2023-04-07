
-- This is to create summaries by two dimension
-- April 7, 2023
-- resource
--https://www.google.com/search?q=how+to+create+column+by+row+crosstab+form+values+from+the+column+table+in+sql&rlz=1C1SQJL_enUS773US773&source=lnms&tbm=vid&sa=X&ved=2ahUKEwjLyKar3Jb-AhVZElkFHXXOBE0Q0pQJegQIBhAC&biw=1080&bih=512&dpr=1.25#fpstate=ive&vld=cid:1e64f307,vid:4p-G7fGhqRk

-- Part one
-- This is to know the 2 digit codes of the NAICS
-- Data is Mergent Employment data
-- purpose is to summarize the data by different attributes

--use different methods of summarization


-- Part1.
--to know how many distinct 2 digit NAICS code are available
select distinct(LEFT([Primary.NAICS.Code], 2)) as NAICS
        
From [dbo].[MI18]
order by NAICS



--Part 2
-- This is to create summary of employment by listing the 2 digit NAICS

SELECT *
From 
	(
      SELECt  [Physical.City],
			left([Primary.NAICS.Code],2) as NAICS, --- get the leading two digit numbers and name them as NAICS
			cast (REPLACE([Employee.this.Site],',','') As INT) as jobs -- removing the comma from the number and change it to ingiger
			FROM[dbo].[MI18]
			--where [Physical.City] in ('SWISSVALE', 'PITTSBURGH') -- this is to select any city 

	) as Employe
pivot
	(
	 sum([jobs])
	 for NAICS in ([11],[21],[22],[23], [31],[32],[42],[45],[48],[49],[51],[52],[53],[54], [55],[56])  -- need to finish the list of numbers but often times diffiult to list all of them, hensce need othr method to overcome this

	) as Emplyesummary



--Part 3 
-- this is to first list of the 2 digit NNAICS code out of the 6 digit


DECLARE @cols AS NVARCHAR(MAX), @query AS NVARCHAR(MAX);

SELECT @cols = STUFF((SELECT DISTINCT ',' + QUOTENAME(LEFT([Primary.NAICS.Code], 2))
                      FROM [dbo].[MI18]
                      FOR XML PATH(''), TYPE
                     ).value('.', 'NVARCHAR(MAX)') 
                        ,1,1,'')



SELECT *
From 
	(
      SELECt  [Physical.City],
			left([Primary.NAICS.Code],2) as NAICS,
			cast (REPLACE([Employee.this.Site],',','') As INT) as jobs
			FROM[dbo].[MI18]

	) as Employe
pivot
	(
	 sum([jobs])
	 for NAICS in ('+ @cols +') --- this is not working. The way it should show is [number].not use why is doesn't work.
	 

	) as Emplyesummary








