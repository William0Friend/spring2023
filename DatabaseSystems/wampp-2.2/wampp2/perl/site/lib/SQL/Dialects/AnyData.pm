package SQL::Dialects::AnyData;

=pod

=head1 NAME

 SQL::Dialects::AnyData -- AnyData config file for SQL::Parse

=head1 SYNOPSIS

  see SQL::Parse, SQL::Squish

=head1 DESCRIPTION

 The makemaker police say i gotta have one of these

=cut

sub get_config {
return <<EOC;
[VALID COMMANDS]
CREATE
DROP
SELECT
INSERT
UPDATE
DELETE

[VALID OPTIONS]
SELECT_MULTIPLE_TABLES
SELECT_AGGREGATE_FUNCTIONS

[VALID COMPARISON OPERATORS]
=
<>
<
<=
>
>=
LIKE
NOT LIKE
CLIKE
NOT CLIKE
RLIKE
NOT RLIKE
IS
IS NOT

[VALID DATA TYPES]
CHAR
VARCHAR
REAL
INT
INTEGER
BLOB
TEXT

[RESERVED WORDS]
INTEGERVAL
STRING
REALVAL
IDENT
NULLVAL
PARAM
OPERATOR
IS
AND
OR
ERROR
INSERT
UPDATE
SELECT
DELETE
DROP
CREATE
ALL
DISTINCT
WHERE
ORDER
ASC
DESC
FROM
INTO
BY
VALUES
SET
NOT
TABLE
CHAR
VARCHAR
REAL
INTEGER
PRIMARY
KEY
BLOB
TEXT
EOC
}
1;
