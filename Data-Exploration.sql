select * from 
CovidDeaths order by 3,4;

--select * from 
--CovidVaccinations order by 3,4;

select Location, date,total_cases,new_cases,total_deaths,population
from CovidDeaths
order by 1,2;

--total cases vs total deaths
select location,date,total_cases,total_deaths,(total_deaths/total_cases) * 100 as DeathPercentage
from CovidDeaths
where location = 'INDIA'
order by 1,2;

--totalcases vs population
select location,date,total_cases,population,(total_cases/population)*100 as ChancesOfInfection
from CovidDeaths
--where location = 'INDIA'
order by 1,2;

--Countries with highest Infection rate
select location,MAX(total_cases) as max_cases,population,MAX((total_cases /population))*100 as PercentagePopulationInfected
from CovidDeaths
--where location = 'INDIA
group by location,population
order by PercentagePopulationInfected DESC;

--Countries with highest death percentage per Population
select location,population,max(total_deaths),max((total_deaths/population)) * 100 as PercentageDeath
from CovidDeaths
group by location,population
order by PercentageDeath DESC;

--Countries with highest death count
select location,max(cast (total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
group by location
order by TotalDeathCount DESC;

--Continents with highest death count
select continent,max(cast (total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount DESC;

--
select date,sum(new_cases) as TotalCases,sum(cast (new_deaths as int)) as TotalDeaths,sum(cast (new_deaths as int))/sum(new_cases) * 100 as DeathPercentage
from CovidDeaths
where continent is not null
group by date
order by 1,2;

-- joining covid deaths and covid vaccinations table
select *
from CovidDeaths dea
join CovidVaccinations vac
on dea.location=vac.location and
dea.date=vac.date;

--total population vs total vaccination *****57:00***
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,vac.total_vaccinations
from CovidDeaths dea
join CovidVaccinations vac
on dea.location=vac.location and
dea.date=vac.date
where dea.continent is not null
order by 2,3;

--partition
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert (bigint ,vac.new_vaccinations)) over (partition by dea.Location order by dea.Location,dea.date) 
as PeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location=vac.location and
dea.date=vac.date
where dea.continent is not null
order by 2,3;

--cte
with PopVsVac (Continent,location,date,population,new_vaccinations,PeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert (bigint ,vac.new_vaccinations)) over (partition by dea.Location order by dea.Location,dea.date) 
as PeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location=vac.location and
dea.date=vac.date
--where dea.continent is not null
--order by 2,3
)
select *,(PeopleVaccinated/Population) * 100 from PopVsVac


--temp table 
Drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
PeopleVaccinated numeric)


insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert (bigint ,vac.new_vaccinations)) over (partition by dea.Location order by dea.Location,dea.date) 
as PeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location=vac.location and
dea.date=vac.date
--where dea.continent is not null

select *,(PeopleVaccinated/Population) * 100 from #PercentPopulationVaccinated


--creating data to store for visualizations
create view PercentPopulationVaccinated as 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert (bigint ,vac.new_vaccinations)) over (partition by dea.Location order by dea.Location,dea.date) 
as PeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location=vac.location and
dea.date=vac.date
where dea.continent is not null
