## PostgreSQL syntax ##

## Creation of the table ##
CREATE TABLE cats (
  id serial PRIMARY KEY,
  cat varchar(32)
);

## Creation of the function random_cat() ##
CREATE FUNCTION random_cat()
  RETURNS varchar(32) AS
$func$
DECLARE
  cats text[] = '{news,school,cars,home,science}';
BEGIN
  RETURN cats[ceil(random() * 5)];
END
$func$ LANGUAGE plpgsql VOLATILE;

## Inserting of the rows ##
INSERT INTO cats (id, cat)
SELECT x.id,
  random_cat()
  FROM generate_series(1, 1000) AS x(id)
;

## Deleting of the function ##
DROP FUNCTION random_cat();

SELECT * FROM cats WHERE cat != 'cars'; ## <- Why it must be difficult?? Where is the catch? May be I understood it wrong.
