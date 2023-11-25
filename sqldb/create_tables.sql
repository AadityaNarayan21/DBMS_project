
CREATE TABLE Teams (
TeamID       INT NOT NULL
,TeamName    VARCHAR(100) NOT NULL
,TeamAbbr    VARCHAR(10)
,Location    VARCHAR(100)
,PRIMARY KEY(TeamID));

CREATE TABLE Coaches (
Name      VARCHAR(100)
,TeamID   INT REFERENCES Teams(TeamID)
,PRIMARY KEY(Name, TeamID));

CREATE TABLE Coach_Stats (
    Name      VARCHAR(100) NOT NULL,
    Team      VARCHAR(10),
    SeasG     INT,
    SeasW     INT,
    SeasL     INT,
    FranG     INT,
    FranW     INT,
    FranL     INT,
    CareW     INT,
    CareL     INT,
    CareWP    FLOAT,
    POSeasG   INT,
    POSeasW   INT,
    POSeasL   INT,
    POFranG   INT,
    POFranW   INT,
    POFranL   INT,
    POCareG   INT,
    POCareW   INT,
    POCareL   INT,
    FOREIGN KEY (Name) REFERENCES Coaches(Name)
);


CREATE TABLE Players (
Name      VARCHAR(100)
,Pos      VARCHAR(10)
,Age      INT
,TeamID   INT REFERENCES Teams(TeamID)
,PRIMARY KEY(Name)
);

CREATE TABLE Player_Stats ( 
Name    VARCHAR(100) NOT NULL
,TeamID   INT REFERENCES Teams(TeamID)
,Gms      INT
,Gstart   INT
,MP       FLOAT
,FG       FLOAT
,FGA      FLOAT
,FGP      FLOAT
,ThreeP   FLOAT
,ThreePA  FLOAT
,ThreePP  FLOAT
,TwoP     FLOAT
,TwoPA    FLOAT
,TwoPP    FLOAT
,FT       FLOAT
,FTA      FLOAT
,FTP      FLOAT
,ORB      FLOAT
,DRB      FLOAT
,TRB      FLOAT
,AST      FLOAT
,STL      FLOAT
,BLK      FLOAT
,TOV      FLOAT
,PF       FLOAT
,PTS      FLOAT
);


CREATE TABLE Team_Stats (
    TeamId    INT,
    G         INT,
    MP        INT,
    FG        INT,
    FGA       INT,
    FGP       FLOAT,
    ThreeP    INT,
    ThreePA   INT,
    ThreePP   FLOAT,
    TwoP      INT,
    TwoPA     INT,
    TwoPP     FLOAT,
    FT        INT,
    FTA       INT,
    FTP       FLOAT,
    ORB       INT,
    DRB       INT,
    TRB       INT,
    AST       INT,
    STL       INT,
    BLK       INT,
    TOV       INT,
    PF        INT,
    PTS       INT,
    FOREIGN KEY (TeamId) REFERENCES Teams(TeamID)
);


CREATE TABLE Top_Scorers (
Points        INT NOT NULL
,Name         VARCHAR(100) NOT NULL
,Year         INT
,TeamName     VARCHAR(100)
,OppTeamName  VARCHAR(100)
,TeamScore    INT
,OppTeamScore INT
,MinsPlayed   INT);

CREATE TABLE `user` (
  `userid` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL
);

ALTER TABLE `user`
  ADD PRIMARY KEY (`userid`);

DELIMITER //

CREATE PROCEDURE team_standings()
BEGIN
    CREATE TEMPORARY TABLE TempTeamStatsSummary (
        TeamName VARCHAR(100),
        TotalSeasG INT,
        TotalSeasW INT,
        TotalSeasL INT
    );

    INSERT INTO TempTeamStatsSummary
    SELECT
        Teams.TeamName,
        SUM(Coach_Stats.SeasG) AS TotalSeasG,
        SUM(Coach_Stats.SeasW) AS TotalSeasW,
        SUM(Coach_Stats.SeasL) AS TotalSeasL
    FROM
        Teams
    JOIN
        Coaches ON Teams.TeamID = Coaches.TeamID
    JOIN
        Coach_Stats ON Coaches.Name = Coach_Stats.Name
    GROUP BY
        Teams.TeamName
    ORDER BY
        TotalSeasW DESC; 

    SELECT * FROM TempTeamStatsSummary;

    DROP TEMPORARY TABLE IF EXISTS TempTeamStatsSummary;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE GetPlayerStats()
BEGIN
    SELECT
        Player_Stats.Name,
        Teams.TeamName,
        Player_Stats.Gms,
        Player_Stats.Gstart,
        Player_Stats.MP,
        Player_Stats.FG,
        Player_Stats.FGA,
        Player_Stats.FGP,
        Player_Stats.ThreeP,
        Player_Stats.ThreePA,
        Player_Stats.ThreePP,
        Player_Stats.TwoP,
        Player_Stats.TwoPA,
        Player_Stats.TwoPP,
        Player_Stats.FT,
        Player_Stats.FTA,
        Player_Stats.FTP,
        Player_Stats.ORB,
        Player_Stats.DRB,
        Player_Stats.TRB,
        Player_Stats.AST,
        Player_Stats.STL,
        Player_Stats.BLK,
        Player_Stats.TOV,
        Player_Stats.PF,
        Player_Stats.PTS
    FROM
        Player_Stats
    JOIN
        Teams ON Player_Stats.TeamID = Teams.TeamID
    WHERE
        Player_Stats.Gms > 10
    ORDER BY
        Player_Stats.PTS DESC;
END //

DELIMITER ;
CALL GetPlayerStats();

DELIMITER //

CREATE PROCEDURE GetTopPlayerStats()
BEGIN
    SELECT
        Player_Stats.Name,
        Teams.TeamName,
        Player_Stats.Gms,
        Player_Stats.Gstart,
        Player_Stats.MP,
        Player_Stats.FG,
        Player_Stats.FGA,
        Player_Stats.FGP,
        Player_Stats.ThreeP,
        Player_Stats.ThreePA,
        Player_Stats.ThreePP,
        Player_Stats.TwoP,
        Player_Stats.TwoPA,
        Player_Stats.TwoPP,
        Player_Stats.FT,
        Player_Stats.FTA,
        Player_Stats.FTP,
        Player_Stats.ORB,
        Player_Stats.DRB,
        Player_Stats.TRB,
        Player_Stats.AST,
        Player_Stats.STL,
        Player_Stats.BLK,
        Player_Stats.TOV,
        Player_Stats.PF,
        Player_Stats.PTS
    FROM
        Player_Stats
    JOIN
        Teams ON Player_Stats.TeamID = Teams.TeamID
    WHERE
        Player_Stats.Gms > 10
    ORDER BY
        Player_Stats.PTS DESC
    LIMIT 30;
END //

DELIMITER ;

CALL GetTopPlayerStats();

DELIMITER //

CREATE PROCEDURE GetTeamStatsWithTeamName()
BEGIN
    SELECT
        Teams.TeamName,
        Team_Stats.G,
        Team_Stats.MP,
        Team_Stats.FG,
        Team_Stats.FGA,
        Team_Stats.FGP,
        Team_Stats.ThreeP,
        Team_Stats.ThreePA,
        Team_Stats.ThreePP,
        Team_Stats.TwoP,
        Team_Stats.TwoPA,
        Team_Stats.TwoPP,
        Team_Stats.FT,
        Team_Stats.FTA,
        Team_Stats.FTP,
        Team_Stats.ORB,
        Team_Stats.DRB,
        Team_Stats.TRB,
        Team_Stats.AST,
        Team_Stats.STL,
        Team_Stats.BLK,
        Team_Stats.TOV,
        Team_Stats.PF,
        Team_Stats.PTS
    FROM
        Team_Stats
    JOIN
        Teams ON Team_Stats.TeamId = Teams.TeamID;
END //

DELIMITER ;
CALL GetTeamStatsWithTeamName();

CREATE TABLE Schedule (
    MatchID  INT PRIMARY KEY,
    Team1    INT,
    Team2    INT,
    Winner   INT,
    Loser    INT, 
    FOREIGN KEY (Team1) REFERENCES Teams(TeamID),
    FOREIGN KEY (Team2) REFERENCES Teams(TeamID)
);

DELIMITER //

CREATE TRIGGER update_coach_stats
AFTER UPDATE ON Schedule
FOR EACH ROW
BEGIN
    IF NEW.Winner != 0 AND NEW.Loser != 0 THEN
        UPDATE Coach_Stats
        SET
            SeasG = SeasG + 1,
            SeasW = SeasW + 1
        WHERE
            Name IN (SELECT Name FROM Coaches WHERE TeamID = NEW.Winner);
        UPDATE Coach_Stats
        SET
            SeasG = SeasG + 1,
            SeasL = SeasL + 1
        WHERE
            Name IN (SELECT Name FROM Coaches WHERE TeamID = NEW.Loser);
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE RemoveRowsFromSchedule()
BEGIN
    DELETE FROM Schedule WHERE Winner != 0;
END //

DELIMITER ;


