

/*
Queries used for Tableau Project
*/



-- 1. 

Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(New_Cases)*100 as Death_Percentage
From [Portfolio.Project]..COVIDDeaths
--Where location like '%Nigeria%'
--Group By date
order by 1,2



-- 2. 

Select Continent, SUM(new_deaths) as Total_Death_Count
From [Portfolio.Project]..COVIDDeaths
--Where location like '%Nigeria%'
Group by Continent
order by Total_Death_Count desc


-- 3.

Select Location, Population, MAX(total_cases) as Highest_Infection_Count,  Max((total_cases/population))*100 as Percent_Population_Infected
From [Portfolio.Project]..COVIDDeaths
--Where location like '%Nigeria%'
Group by Location, Population
order by Percent_Population_Infected desc


-- 4.

Select Location, Population,date, MAX(total_cases) as Highest_Infection_Count,  Max((total_cases/population))*100 as Percent_Population_Infected
From [Portfolio.Project]..COVIDDeaths
--Where location like '%Nigeria%'
Group by Location, Population, date
order by Percent_Population_Infected desc


-- 5.

Select Continent, SUM(New_Cases) as Total_Confirmed_Cases
From [Portfolio.Project]..COVIDDeaths
--Where location like '%Nigeria%'
Group by Continent
order by Total_Confirmed_Cases desc


-- 6. 

Select Location, SUM(new_deaths) as Total_Death_Count
From [Portfolio.Project]..COVIDDeaths
--Where location like '%Nigeria%'
Group by Location
order by Total_Death_Count desc


-- 7. 

Select Location, Population,date, MAX(total_deaths) as Highest_Death_Count,  Max((Total_Deaths/population))*100 as Percent_Total_Deaths
From [Portfolio.Project]..COVIDDeaths
--Where location like '%Nigeria%'
Group by Location, Population, date
order by Percent_Total_Deaths desc