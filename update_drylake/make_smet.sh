echo "SMET 1.1 ASCII" > drylake.smet
echo "[HEADER]" >> drylake.smet
echo "station_id    = drylake" >> drylake.smet
echo "station_name  = drylake" >> drylake.smet
echo "latitude      = 40.53333333333333" >> drylake.smet
echo "longitude     = 106.78333333333333" >> drylake.smet
echo "altitude      = 2560.32" >> drylake.smet
echo "nodata        = -999" >> drylake.smet
echo "tz            = -6" >> drylake.smet
echo "fields        = timestamp TA RH VW DW P PSUM_UNHEATED HS ISWR ILWR" >> drylake.smet
echo "units_multiplier = 1 1 1 1 1 1 1 1 1 1" >> drylake.smet
echo "units_offset = 0 0 0 0 0 0 0 0 0 0" >> drylake.smet
echo "[DATA]" >> drylake.smet
# Without filters:
#grep -h ^457 [0-9[0-9][0-9][0-9].csv | mawk -F, '{psum=($5>0)?($5*25.4*0.5):(0.); if(prev_sum>psum) {prev_sum=psum}; print substr($2,1,10) "T" substr($3,1,5), $7+273.15, $33/100, $30*0.44704, $32, ($8<0)?(0.):($8*0.0254), psum-prev_sum; prev_sum=psum}' >> drylake.smet
# With filters:
grep -h ^457 457_[0-9][0-9][0-9][0-9].csv | mawk -F, '{psum=($5>0)?($5*25.4*0.5):(0.); if(prev_sum>psum) {prev_sum=psum}; print substr($2,1,10) "T" substr($3,1,5), ($7>-50 && $7<50)?($7+273.15):(-999), ($33>2 && $33<=100)?($33/100):(-999), ($30>=0 && $30<=100)?($30*0.44704):(-999), -999, -999, psum-prev_sum, ($8<0)?(0.):($8*0.0254), ($32>=0 && $32<1500)?($32):(-999), -999; prev_sum=psum}' >> drylake.smet



echo "SMET 1.1 ASCII" > lakeeldora.smet
echo "[HEADER]" >> lakeeldora.smet
echo "station_id    = lakeeldora" >> lakeeldora.smet
echo "station_name  = lakeeldora" >> lakeeldora.smet
echo "latitude      = 40.53333333333333" >> lakeeldora.smet
echo "longitude     = 106.78333333333333" >> lakeeldora.smet
echo "altitude      = 2560.32" >> lakeeldora.smet
echo "nodata        = -999" >> lakeeldora.smet
echo "tz            = -6" >> lakeeldora.smet
echo "fields        = timestamp HS PSUM_UNHEATED" >> lakeeldora.smet
echo "units_offset  = 0         0  0" >> lakeeldora.smet
echo "[DATA]" >> lakeeldora.smet
grep -h ^564 564_[0-9][0-9][0-9][0-9].csv | mawk -F, '{psum=($5>0)?($5*25.4*0.5):(0.); if(prev_sum>psum) {prev_sum=psum}; print substr($2,1,10) "T" substr($3,1,5), ($7<0)?(0.):($7*0.0254), psum-prev_sum; prev_sum=psum}' >> lakeeldora.smet
