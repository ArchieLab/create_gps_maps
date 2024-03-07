-- Get data about groves & water holes from the related SWERB tables

with max_locs AS (
                  -- Get only the most-recent coordinates, for locs that have
                  -- more than one row in SWERB_GW_LOCS
                  SELECT loc
                        , max(date::text
                                || ' '
                                || coalesce(time::text, '00:00:00'::text)
                              ) as maxdate
                    FROM swerb_gw_locs
                    GROUP BY loc
                  )
   , these_locs AS (SELECT swerb_gw_locs.*
                      FROM swerb_gw_locs
                      JOIN max_locs
                        ON max_locs.loc = swerb_gw_locs.loc
                           AND (swerb_gw_locs.date::text
                                  || ' '
                                  || coalesce(swerb_gw_locs.time::text
                                              , '00:00:00'::text)
                                ) = max_locs.maxdate
                    )
SELECT swerb_gws.type
     , swerb_gws.loc
     , these_locs.date
     , these_locs.xysource
-- David's original code had two "type" columns, so...okay
, swerb_gws.type
     , swerb_gws.altname
     , swerb_gws.start
     , swerb_gws.finish
     , these_locs.x
     , these_locs.y
     , these_locs.notes
  FROM these_locs
  JOIN swerb_gws
    ON swerb_gws.loc = these_locs.loc
  WHERE swerb_gws.finish IS NULL
    AND swerb_gws.type IN ('G', 'W');
