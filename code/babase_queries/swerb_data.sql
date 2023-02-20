-- Download swerb data from babase
-- Only download data related to groves and from gps period
-- Exclude UNK locations
-- Only keep observations that have not been entered to the swerb_loc_data_confidences table

SELECT s.swid, s.date, s.x, s.y, s.loc, s.event
FROM swerb s
--LEFT JOIN swerb_loc_data_confidences sldc ON sldc.swid = s.swid
WHERE XYSource = 'gps' 
       AND event IN ('B', 'E', 'W')
       AND loc NOT IN ('UNK')
--       AND confidence IS NULL
       ;
       
