-- Download data from swerb regading groves

SELECT swerb_gws.type, swerb_gws.loc, swerb_gw_loc_data.date, swerb_gw_loc_data.xysource, type, altname, 
       start, finish,
       swerb_gw_locs.x, swerb_gw_locs.y, swerb_gw_loc_data.notes
FROM swerb_gw_loc_data
INNER JOIN swerb_gws
ON swerb_gws.loc = swerb_gw_loc_data.loc
INNER JOIN swerb_gw_locs
ON swerb_gw_locs.loc = swerb_gw_loc_data.loc AND swerb_gw_locs.date = swerb_gw_loc_data.date;
