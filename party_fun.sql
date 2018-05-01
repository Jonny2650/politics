CREATE TABLE tw_match
  (
  tw_label VARCHAR(100), --what we're looking for in the text column
  tw_meaning VARCHAR(100), --what we would like to infer from matches
  )
INSERT INTO tw_match (tw_label, tw_meaning) 
VALUES
('labour', 'Labour'),
('tory', 'Conservative'),
('tories', 'Conservative'),
('Conservative', 'Conservative'),
('Conservatives', 'Conservative'),
('Lib dem', 'Liberal Democrats'),
('Lib dems', 'Liberal Democrats'),
('Libdems', 'Liberal Democrats'),
('Libdem', 'Liberal Democrats'),
('Liberal Democrats', 'Liberal Democrats'),
('UKIP', 'UKIP'),
('UK Independance Party', 'UKIP'),
('TheGreenParty', 'The Green Party'),
('greens', 'The Green Party')

SELECT * 
FROM
(
SELECT X.*,
COUNT(*) OVER (PARTITION BY tweetid) AS dupe_count
 FROM 
(
SELECT
	tw.tweetid AS tweetid,
	tw.[text] AS [text],
	ma.tw_meaning AS [meaning]
	--COUNT(*) OVER (PARTITION BY tw.tweetid, ma.tw_meaning) AS dupe_count
FROM [AdventureWorks12].[twitter].[tweets] tw
LEFT JOIN tw_match ma
	ON tw.[text] LIKE ma.tw_label + ' %'
	OR tw.[text] LIKE '% ' + ma.tw_label 
	OR tw.[text] LIKE '% ' + ma.tw_label + ' %'
	OR tw.[text] LIKE '% ' + ma.tw_label + ',%'
	OR tw.[text] LIKE '% ' + ma.tw_label + '.%'
	OR tw.[text] LIKE '% ' + ma.tw_label + ':%'
	OR tw.[text] LIKE '% ' + ma.tw_label + ';%'
	OR tw.[text] LIKE '% ' + ma.tw_label + '"%'
	OR tw.[text] LIKE '%#' + ma.tw_label + ' %'
	OR tw.[text] LIKE '%#Vote' + ma.tw_label + '%'
	OR tw.[text] LIKE '%@' + ma.tw_label + '%'
 GROUP BY tw.tweetid,
	tw.[text],
	ma.tw_meaning
) X
) XX
WHERE meaning IS NOT NULL
AND dupe_count = 1


---
SELECT 
/****** Script for SelectTopNRows command from SSMS  ******/
	   [text]		
      ,[party]
  FROM [AdventureWorks12].[twitter].[tweets]
