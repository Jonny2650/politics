	/****** Counting Number of rows in the tweet database ******/
SELECT
   Total_Rows= SUM(st.row_count)
FROM
   sys.dm_db_partition_stats st
WHERE
    object_name(object_id) = 'politics' AND (index_id < 2)

	--CREATE TABLE tw_match
	--  (
	--  tw_label VARCHAR(100), --what we're looking for in the text column
	--  tw_meaning VARCHAR(100), --what we would like to infer from matches
	--  )
	--INSERT INTO tw_match (tw_label, tw_meaning) 
	--VALUES
	--('labour', 'Labour'),
	--('tory', 'Conservative'),
	--('tories', 'Conservative'),
	--('Conservative', 'Conservative'),
	--('Conservatives', 'Conservative'),
	--('Lib dem', 'Liberal Democrats'),
	--('Lib dems', 'Liberal Democrats'),
	--('Libdems', 'Liberal Democrats'),
	--('Libdem', 'Liberal Democrats'),
	--('Liberal Democrats', 'Liberal Democrats'),
	--('UKIP', 'UKIP'),
	--('UK Independance Party', 'UKIP'),
	--('TheGreenParty', 'The Green Party'),
	--('greens', 'The Green Party')


	/****** Filtering by party ******/
SELECT * 
--INTO kubrick.clean_politics -- put into new clean table
FROM
(
SELECT X.*,
COUNT(*) OVER (PARTITION BY tweetid) AS dupe_count
 FROM 
(
SELECT
	tw.tweetid AS tweetid
   ,tw.[text] AS [text]
   ,tw.[sentiment]
   ,tw.[followers_count]
   ,tw.[favourites_count]
   ,tw.[verified]
   ,tw.[statuses_count]
   ,tw.[timestamp_ms]
   ,tw.[borough]
   ,ma.tw_meaning AS [party]
FROM [AdventureWorks2012].[kubrick].[politics] tw -- change source here please
LEFT JOIN dbo.tw_match ma
	ON tw.[text] LIKE ma.tw_label + ' %'
	OR tw.[text] LIKE '% ' + ma.tw_label 
	OR tw.[text] LIKE '% ' + ma.tw_label + ' %'
	OR tw.[text] LIKE '% ' + ma.tw_label + ',%'
	OR tw.[text] LIKE '% ' + ma.tw_label + '.%'
	OR tw.[text] LIKE '% ' + ma.tw_label + ':%'
	OR tw.[text] LIKE '% ' + ma.tw_label + ';%'
	OR tw.[text] LIKE '% ' + ma.tw_label + '!%'
	OR tw.[text] LIKE '% ' + ma.tw_label + '?%'
	OR tw.[text] LIKE '% ' + ma.tw_label + '"%'
	OR tw.[text] LIKE '%#' + ma.tw_label + ' %'
	OR tw.[text] LIKE '%#Vote' + ma.tw_label + '%'
	OR tw.[text] LIKE '%@' + ma.tw_label + '%'
 GROUP BY tw.tweetid,
	tw.[text]
   ,tw.[sentiment]
   ,tw.[followers_count]
   ,tw.[favourites_count]
   ,tw.[verified]
   ,tw.[statuses_count]
   ,tw.[timestamp_ms]
   ,tw.[borough]
   ,ma.tw_meaning
) X
) XX
WHERE [party] IS NOT NULL
AND dupe_count = 1



	/****** Alasdair's Super Secret Borough Script ******/
SELECT *
FROM
(
SELECT [tweetid]
      ,[sentiment]
      ,[followers_count]
      ,[favourites_count]
      ,[verified]
      ,[statuses_count]
      ,[timestamp_ms]
      ,[text]
      ,[party]
	  ,CASE WHEN [text] LIKE '%camden%'
			OR [text] LIKE '% cam %' THEN 'Camden'
			WHEN [text] LIKE '%greenwich%'
			OR [text] LIKE '% gre %' THEN 'Greenwich'
			WHEN [text] LIKE '%hackney%'
			OR [text] LIKE '% hac %' THEN 'Hackney'
			WHEN [text] LIKE '%hammersmith%'
			OR [text] LIKE '%fulham%'
			OR [text] LIKE '% h&f %' THEN 'Hammersmith and Fulham'
			WHEN [text] LIKE '%islington%'
			OR [text] LIKE '% isl %' THEN 'Islington'
			WHEN [text] LIKE '%kensington and chelsea%'
			OR [text] LIKE '%kensington%'
			OR [text] LIKE '%chelsea%'
			OR [text] LIKE '% k&c %' THEN 'Kensington and Chelsea'
			WHEN [text] LIKE '%lambeth%'
			OR [text] LIKE '% lam %' THEN 'Lambeth'
			WHEN [text] LIKE '%lewisham%'
			OR [text] LIKE '% lew %' THEN 'Lewisham'
			WHEN [text] LIKE '%southwark%'
			OR [text] LIKE '% sou %' THEN 'Southwark'
			WHEN [text] LIKE '%tower hamlets%'
			OR [text] LIKE '% TH %' THEN 'Tower Hamlets'
			WHEN [text] LIKE '%wandsworth%'
			OR [text] LIKE '% wan %'THEN 'Wandsworth'
			WHEN [text] LIKE '%westminster%'
			OR [text] LIKE '% wes %'THEN 'Westminster'
			WHEN [text] LIKE '%barking%'
			OR [text] LIKE '% b&d %'
			OR [text] LIKE '%dagenham%'THEN 'Barking and Dagenham'
			WHEN [text] LIKE '%barnet%'
			OR [text] LIKE '% bar %'THEN 'Barnet'
			WHEN [text] LIKE '%bexley%'
			OR [text] LIKE '% bex %'THEN 'Bexley'
			WHEN [text] LIKE '%brent%'
			OR [text] LIKE '% bre %'THEN 'Brent'
			WHEN [text] LIKE '%bromley%'
			OR [text] LIKE '% bro %'THEN 'Bromley'
			WHEN [text] LIKE '%croydon%'
			OR [text] LIKE '% cro %'THEN 'Croydon'
			WHEN [text] LIKE '%ealing%'
			OR [text] LIKE '% eal %'THEN 'Ealing'
			WHEN [text] LIKE '%enfield%'
			OR [text] LIKE '% enf %'THEN 'Enfield'
			WHEN [text] LIKE '%haringey%'
			OR [text] LIKE '% hgy %'THEN 'Haringey'
			WHEN [text] LIKE '%harrow%'
			OR [text] LIKE '% hrw %'THEN 'Harrow'
			WHEN [text] LIKE '%havering%'
			OR [text] LIKE '% hav %'THEN 'Havering'
			WHEN [text] LIKE '%hillingdon%'
			OR [text] LIKE '% hil %'THEN 'Hillingdon'
			WHEN [text] LIKE '%hounslow%'
			OR [text] LIKE '% hou %'THEN 'Hounslow'
			WHEN [text] LIKE '%kingston%'
			OR [text] LIKE '% kin %'THEN 'Kingston upon Thames'
			WHEN [text] LIKE '%merton%'
			OR [text] LIKE '% mer %'THEN 'Merton'
			WHEN [text] LIKE '%newham%' THEN 'Newham'
			WHEN [text] LIKE '%redbridge%'
			OR [text] LIKE '% red %'THEN 'Redbridge'
			WHEN [text] LIKE '%richmond%'
			OR [text] LIKE '% ric %'THEN 'Richmond upon Thames'
			WHEN [text] LIKE '%sutton%'
			OR [text] LIKE '% sut %'THEN 'Sutton'
			WHEN [text] LIKE '%waltham%'
			OR [text] LIKE '% wf %'THEN 'Waltham Forest'
	  ELSE NULL
	  END as [borough]
	  ,AVG(sentiment) OVER (PARTITION BY borough, party) as Av_Sent
  FROM [AdventureWorks2012].[kubrick].[clean_politics]
)x

WHERE borough IS NOT NULL


ORDER BY [sentiment]