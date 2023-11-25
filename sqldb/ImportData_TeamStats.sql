\copy Team_Stats FROM 'team_stats.csv' WITH CSV HEADER;
\copy Teams FROM 'teams.csv' WITH CSV HEADER;
C:\ProgramData\MySQL\MySQL Server 8.1\Uploads


LOAD DATA INFILE '"C:/ProgramData/MySQL/MySQL Server 8.1/Uploads/Coach_Stats.csv"'
INTO TABLE Coach_Stats
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- This ignores the header row in the CSV file
