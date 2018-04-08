## PostgreSQL syntax ##

## Creation of the table ##
CREATE TABLE domain (
  id serial PRIMARY KEY,
  date timestamp without time zone,
  domain VARCHAR(64)
);

## Creation of the function for generating domain names ##
CREATE FUNCTION random_domain()
  RETURNS VARCHAR(64) AS
$func$
DECLARE
  domain_names text[] = '{ai,af,ax,eq,ex,ez,ij,il,iz,oe,os,ov,ux,uy,ya,yt,yv}';
  domains text[] = '{gov,com,net,io}';
BEGIN
  RETURN domain_names[ceil(random() * 17)] ||
    '.' ||
  domains[ceil(random() * 4)]
;
END
$func$ LANGUAGE plpgsql VOLATILE;

## Inserting ##
INSERT INTO domain (id, date, domain)
SELECT x.id,
  timestamp '2016-01-01 00:00:00' + interval '1 hour' * x.id,
  random_domain()
  FROM generate_series(1, 10000) AS x(id)
;

## Dropping the above function ##
DROP FUNCTION random_domains();

SELECT DISTINCT COUNT(domain), date FROM (
  SELECT
    CAST(date AS DATE) AS date,
    domain
  FROM domain
  ORDER BY id
) AS intermediary
GROUP BY date;
