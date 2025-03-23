SELECT *
FROM PortfolioProject..covidvaccination
order by 3,4

SELECT *
FROM PortfolioProject..CovidDeaths$
where continent is not null
order by 3,4

SELECT Location, date, total_cases, new_cases, total_deaths,population
FROM PortfolioProject..CovidDeaths$
where continent is not null
order by 1,2

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your duty

SELECT Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
where continent is not null
AND location like '%state%'
order by 1,2


--Looking Total Cases vs Population
--Shows what percentage of population got covid

SELECT Location, date, population,total_cases,(total_cases/population)*100 as PercentPopualtionInfected
FROM PortfolioProject..CovidDeaths$
--where location like '%state%'
where continent is not null
order by 1,2


--Looking at Countries with Highest Infection Rate compared to Population

SELECT Location, population,MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopualtionInfected
FROM PortfolioProject..CovidDeaths$
--where location like '%state%'
where continent is not null
Group by location, population
order by PercentPopualtionInfected desc

--Showing Countries with Highest Death Count per population

SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
--where location like '%state%'
where continent is not null
Group by location
order by TotalDeathCount desc




-- LET'S BREAK THINGS DOWN BY CONTINENET


SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
--where location like '%state%'
where continent is not null
Group by continent
order by TotalDeathCount desc

--Showing continent with highest death count per population

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
--where location like '%state%'
where continent is not null
Group by continent
order by TotalDeathCount desc


--GLOBAL  NUMBERS

SELECT  SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
where continent is not null
--where location like '%state%'
--Group by date
order by 1,2


--looking at Total Population vs Vaccination

Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location,dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..covidvaccination vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
order by 2,3


--USE CTE

With PopvsVac (Continent,Location, Date, Population,new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location,dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..covidvaccination vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Dtae datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location,dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..covidvaccination vac
  on dea.location = vac.location
  and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




-- Creating view to store data for later visualiztion

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location,dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..covidvaccination vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
--order by 2,3


Select * 
From PercentPopulationVaccinated






































































































































































