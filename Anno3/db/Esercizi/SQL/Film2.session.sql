-- SELECT F.Title
-- FROM FILM AS F
-- WHERE F.Director = 'Fellini' AND F.Year > 1960

-- Title of jap scifi after 1990 or french scifi
-- SELECT F.Title
-- FROM FILM AS F
-- WHERE F.Genre = 'scifi' AND (F.Country = 'France' OR (F.Country = 'Japan' AND F.Year > 1990))

-- Title and genre of films in LOndon last xmas
-- SELECT F.Title, F.Genre
-- FROM FILM AS F JOIN SCREENING AS S ON F.Code = S.Film JOIN ROOM AS R ON R.Code = S.Room
-- WHERE R.City = 'London' AND S.Date = '25/12/2024'

-- N of rooms in LNd with > 60 seats
-- SELECT COUNT(DISTINCT R.Code) AS NumBigRooms
-- FROM ROOM AS R
-- WHERE R.Seats > 60 AND R.City = 'London'

-- For each DIrector/actor pair show names and number of films toghether
-- SELECT A.Name, F.Director, COUNT(*)
-- FROM ACTOR AS A, RECITAL AS R, FILM AS F
-- WHERE A.Id = R.Actor AND F.Code = R.Film
-- GROUP BY F.Director, A.Id

-- Director and title with < 6 actors
-- SELECT F.Director, F.Title
-- FROM FILM AS F
-- WHERE 6 > (SELECT COUNT(*)
--     FROM RECITAL AS R
--     WHERE F.Code = R.Film)

-- Name and whole takings of rooms in rome that gained more than 20000 in jan 2005
-- SELECT R.Name, SUM(S.Profits)
-- FROM SCREENING AS S JOIN ROOM AS R ON S.Room = R.Code
-- WHERE R.City = 'Rome' AND S.Date >= 01/01/2005 AND S.Date <= 30/01/2005
-- GROUP BY R.Code
-- HAVING SUM(S.Profits) > 20000

-- Title of films never screened in Berlin
-- SELECT Title
-- FROM FILM
--     EXCEPT
-- SELECT F.Title
-- FROM FILM AS F JOIN SCREENING AS S ON F.Code = S.Film JOIN ROOM AS R ON R.Code = S.Room
-- WHERE R.City = 'Berlin'

-- Title of films with no screenings with rev > 500
SELECT F.Title
FROM FILM AS F
WHERE 500<ALL(SELECT S.Profits
    FROM SCREENING AS S
    WHERE S.Film = F.Code)