
/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

Select*
From [Portfolio.Project]..COVIDDeaths
Where continent is not null 
order by 3,4


--Select*
--From [Portfolio.Project]..COVIDVaccinations
--Where continent is not null 
--order by 3,4


--Select Data to be used
Select Location, date, total_cases, new_cases, total_deaths, population
From [Portfolio.Project]..[COVIDDeaths]
order by 1,2


-- Total Cases vs Total Deaths
-- Possibility of dying when COVID is contracted
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From [Portfolio.Project]..[COVIDDeaths]
--Where location like '%Nigeria%'
order by 1,2


-- Total Cases vs Population
Select Location, date, total_cases,population, (total_cases/population)*100 as Percentage_of_Population_Infected
From [Portfolio.Project]..[COVIDDeaths]
-- Where location like '%Nigeria%'
order by 1,2


-- Countries with the highest infection rate compared to population
Select Location,population, MAX(total_cases) as Highest_Infection_Count, MAX(total_cases/population) *100 as Percentage_of_Population_Infected
From [Portfolio.Project]..[COVIDDeaths]
-- Where location like '%Nigeria%'
Group by location, population
order by Percentage_of_Population_Infected desc


-- Continent with the highest infection rate compared to population
Select continent,population, MAX(total_cases) as Highest_Infection_Count, MAX(total_cases/population) *100 as Percentage_of_Population_Infected
From [Portfolio.Project]..[COVIDDeaths]
-- Where location like '%Nigeria%'
Group by continent, population
order by Percentage_of_Population_Infected desc


-- Countries with the highest death count per population
Select Location, MAX(total_deaths) as Total_Death_Count
From [Portfolio.Project]..[COVIDDeaths]
-- Where location like '%Nigeria%'
Group by Location
order by Total_Death_Count desc


-- Continents with the highest death count per population
Select continent, MAX(total_deaths) as Total_Death_Count
From [Portfolio.Project]..[COVIDDeaths]
Where total_deaths is not null
Group by continent
order by Total_Death_Count desc

--Global Numbers
Select SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, SUM(new_deaths)/SUM(New_Cases) *100 as Death_Percentage
From [Portfolio.Project]..[COVIDDeaths]
--Where location like '%Nigeria%'
--Group By date
order by 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Rolling_People_Vaccinated
--, (Rolling_People_Vaccinated/population)*100
From [Portfolio.Project]..CovidDeaths dea
Join [Portfolio.Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query 
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, Rolling_People_Vaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Rolling_People_Vaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio.Project]..CovidDeaths dea
Join [Portfolio.Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date 
--order by 2,3
)
Select *, (Rolling_People_Vaccinated/Population)*100
From PopvsVac


-- Using Temp Table to perform Calculation on Partition By in previous query
DROP Table if exists #Percent_Population_Vaccinated
Create Table #Percent_Population_Vaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rolling_People_Vaccinated numeric
)

Insert into #Percent_Population_Vaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Rolling_People_Vaccinated
--, (Rolling_People_Vaccinated/population)*100
From [Portfolio.Project]..CovidDeaths dea
Join [Portfolio.Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date 
--where dea.continent is not null 
--order by 2,3

Select *, (Rolling_People_Vaccinated/Population)*100
From #Percent_Population_Vaccinated


-- Creating View to store data for later visualizations
Create View Percent_Population_Vaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Rolling_People_Vaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio.Project]..CovidDeaths dea
Join [Portfolio.Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 


Select*
From Percent_Population_Vaccinated

