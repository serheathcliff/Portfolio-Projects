-- Creating table columns to import the dataset
alter TABLE covid_deaths
ADD COLUMN iso_code VARCHAR,
ADD COLUMN continent VARCHAR,
ADD COLUMN location VARCHAR,
ADD COLUMN date DATE,
ADD COLUMN population BIGINT,
ADD COLUMN total_cases BIGINT,
ADD COLUMN new_cases BIGINT,
ADD COLUMN new_cases_smoothed NUMERIC,
ADD COLUMN total_deaths BIGINT,
ADD COLUMN new_deaths BIGINT,
ADD COLUMN new_deaths_smoothed NUMERIC,
ADD COLUMN total_cases_per_million NUMERIC,
ADD COLUMN new_cases_per_million NUMERIC,
ADD COLUMN new_cases_smoothed_per_million NUMERIC,
ADD COLUMN total_deaths_per_million NUMERIC,
ADD COLUMN new_deaths_per_million NUMERIC,
ADD COLUMN new_deaths_smoothed_per_million NUMERIC,
ADD COLUMN reproduction_rate NUMERIC,
ADD COLUMN icu_patients BIGINT,
ADD COLUMN icu_patients_per_million NUMERIC,
ADD COLUMN hosp_patients BIGINT,
ADD COLUMN hosp_patients_per_million NUMERIC,
ADD COLUMN weekly_icu_admissions numeric, 
ADD COLUMN weekly_icu_admissions_per_million NUMERIC,
ADD COLUMN weekly_hosp_admissions numeric,
ADD COLUMN weekly_hosp_admissions_per_million NUMERIC,
ADD COLUMN new_tests BIGINT,
ADD COLUMN total_tests BIGINT,
ADD COLUMN total_tests_per_thousand NUMERIC,
ADD COLUMN new_tests_per_thousand NUMERIC,
ADD COLUMN new_tests_smoothed BIGINT,
ADD COLUMN new_tests_smoothed_per_thousand NUMERIC,
ADD COLUMN positive_rate NUMERIC,
ADD COLUMN tests_per_case NUMERIC,
ADD COLUMN tests_units VARCHAR(50),
ADD COLUMN total_vaccinations BIGINT,
ADD COLUMN people_vaccinated BIGINT,
ADD COLUMN people_fully_vaccinated BIGINT,
ADD COLUMN new_vaccinations BIGINT,
ADD COLUMN new_vaccinations_smoothed bigint,
ADD COLUMN total_vaccinations_per_hundred NUMERIC,
ADD COLUMN people_vaccinated_per_hundred NUMERIC,
ADD COLUMN people_fully_vaccinated_per_hundred NUMERIC,
ADD COLUMN new_vaccinations_smoothed_per_million bigint,
ADD COLUMN stringency_index NUMERIC,
ADD COLUMN population_density NUMERIC,
ADD COLUMN median_age NUMERIC,
ADD COLUMN aged_65_older NUMERIC,
ADD COLUMN aged_70_older NUMERIC,
ADD COLUMN gdp_per_capita NUMERIC,
ADD COLUMN extreme_poverty NUMERIC,
ADD COLUMN cardiovasc_death_rate NUMERIC,
ADD COLUMN diabetes_prevalence NUMERIC,
ADD COLUMN female_smokers NUMERIC,
ADD COLUMN male_smokers NUMERIC,
ADD COLUMN handwashing_facilities NUMERIC,
ADD COLUMN hospital_beds_per_thousand NUMERIC,
ADD COLUMN life_expectancy NUMERIC,
ADD COLUMN human_development_index NUMERIC;

select * from covid_deaths where continent is not null;

ALTER TABLE covid_vaccinations
ADD COLUMN iso_code VARCHAR(10),
ADD COLUMN continent VARCHAR(50),
ADD COLUMN location VARCHAR(100),
ADD COLUMN date DATE,
ADD COLUMN new_tests BIGINT,
ADD COLUMN total_tests BIGINT,
ADD COLUMN total_tests_per_thousand NUMERIC,
ADD COLUMN new_tests_per_thousand NUMERIC,
ADD COLUMN new_tests_smoothed BIGINT,
ADD COLUMN new_tests_smoothed_per_thousand NUMERIC,
ADD COLUMN positive_rate NUMERIC,
ADD COLUMN tests_per_case NUMERIC,
ADD COLUMN tests_units VARCHAR(50),
ADD COLUMN total_vaccinations BIGINT,
ADD COLUMN people_vaccinated BIGINT,
ADD COLUMN people_fully_vaccinated BIGINT,
ADD COLUMN new_vaccinations BIGINT,
ADD COLUMN new_vaccinations_smoothed bigint,
ADD COLUMN total_vaccinations_per_hundred NUMERIC,
ADD COLUMN people_vaccinated_per_hundred NUMERIC,
ADD COLUMN people_fully_vaccinated_per_hundred NUMERIC,
ADD COLUMN new_vaccinations_smoothed_per_million bigint,
ADD COLUMN stringency_index NUMERIC,
ADD COLUMN population_density NUMERIC,
ADD COLUMN median_age NUMERIC,
ADD COLUMN aged_65_older NUMERIC,
ADD COLUMN aged_70_older NUMERIC,
ADD COLUMN gdp_per_capita NUMERIC,
ADD COLUMN extreme_poverty NUMERIC,
ADD COLUMN cardiovasc_death_rate NUMERIC,
ADD COLUMN diabetes_prevalence NUMERIC,
ADD COLUMN female_smokers NUMERIC,
ADD COLUMN male_smokers NUMERIC,
ADD COLUMN handwashing_facilities NUMERIC,
ADD COLUMN hospital_beds_per_thousand NUMERIC,
ADD COLUMN life_expectancy NUMERIC,
ADD COLUMN human_development_index NUMERIC;

select * from covid_vaccinations;

-- Selecting needed data
select location, date, total_cases, new_cases, total_deaths, population from covid_deaths order by 1,2;

-- Total cases vs total deaths
-- Likelihood of dying if you contract covid in different countries at different points in time
SELECT location, 
       date, 
       total_cases, 
       new_cases, 
       total_deaths, 
       population,
       (total_deaths::DECIMAL / total_cases) * 100 AS death_percentage
FROM covid_deaths
ORDER BY location, date;

-- Likelihood of dying if you contract covid in Europe at different points in time

SELECT location, 
       date, 
       total_cases, 
       new_cases, 
       total_deaths, 
       population,
       (total_deaths::DECIMAL / total_cases) * 100 AS death_percentage
FROM covid_deaths
where continent = 'Europe'
ORDER BY location, date;

-- Total cases vs population
SELECT location, date, population, total_cases,  
       (total_cases::DECIMAL/population)*100 AS death_percentage
FROM covid_deaths
ORDER BY location, date;

-- Percentage of the American population that contracted covid 19
SELECT location, date, population, total_cases,  
       (total_cases::DECIMAL/population)*100 AS percent_population_infected
FROM covid_deaths
where location like '%States'
ORDER BY location, date;

-- Looking at countries with highest infection rate compared to population
SELECT location, population, max(total_cases) as highest_infection_count,  
       max(total_cases::DECIMAL/population)*100 AS percent_population_infected
FROM covid_deaths
where population is not null and total_cases is not null
group by location, population
ORDER BY percent_population_infected desc;

-- Countries with highest death count per population
SELECT location,  max(total_deaths) as total_death_count  
FROM covid_deaths
where continent is not null and total_deaths is not null
group by location
ORDER BY total_death_count desc;

-- Breaking things down by continent
SELECT location,  max(total_deaths) as total_death_count  
FROM covid_deaths
where continent is null and total_deaths is not null
group by location
ORDER BY total_death_count desc;

SELECT continent,  max(total_deaths) as total_death_count  
FROM covid_deaths
where continent is not null and total_deaths is not null
group by continent
ORDER BY total_death_count desc;

__ Global numbers
SELECT date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, 
sum(new_deaths)/sum(new_cases) * 100 AS death_percentage
FROM covid_deaths
where continent is not null and total_cases is not null
group by date 
ORDER BY 1,2 desc;

SELECT  sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, 
sum(new_deaths)/sum(new_cases) * 100 AS death_percentage
FROM covid_deaths
where continent is not null and total_cases is not null
ORDER BY 1,2 desc;

-- Total_population vs total_vaccinations
--Joining the two tables
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date)
as rolling_people_vaccinated
FROM covid_deaths as dea
join covid_vaccinations as vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3;

-- Use CTE
with popvsvac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated) as
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date)
as rolling_people_vaccinated
FROM covid_deaths as dea
join covid_vaccinations as vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
)
select *, (rolling_people_vaccinated/population)*100 from popvsvac;

-- Temp table
create temp table percent_population_vaccinated
(continent varchar(255),
location varchar(255),
date date,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric);

insert into percent_population_vaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date)
as rolling_people_vaccinated
FROM covid_deaths as dea
join covid_vaccinations as vac
on dea.location = vac.location and dea.date = vac.date;

select *, (rolling_people_vaccinated/population)*100 from percent_population_vaccinated;

-- Creating view to store data for later visualizations
create view percent_population_vaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date)
as rolling_people_vaccinated
FROM covid_deaths as dea
join covid_vaccinations as vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null;
