-- Question 1:
select name as country_name 
from 
world.country;

-- Question 2:
select name as country_name 
from world.country
where region like "%Europe%";

-- Question 3:
select c.name as country_name
from world.country c
Join world.countrylanguage cl on c.code = cl.CountryCode
where cl.language like "%English" and cl.IsOfficial = "T" and cl.Percentage >= 70;

-- Question 4:
select country.name as country_name
from world.country 
where IndepYear between 1701 AND 1800;
 
 -- Question 5:
Select Name, CountryCode, District
from world.city
where CountryCode = "IND" and district in ("Delhi" , "Punjab")
