cd "/Users/aiyenggar/OneDrive/PatentsView/"
shp2dta using merged_usmsa_worldurban, data(ai_urban_data) coor(ai_urban_coor) genid(gid)
use ai_urban_data.dta, clear
