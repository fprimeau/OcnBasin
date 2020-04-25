module OcnBasin

export basin

using GZip, DelimitedFiles, Interpolations
cd(dirname(@__FILE__));
# WOCE Pacific Ocean Basin Boundaries
# Longitude band | Southern Latitude | Northern Latitude
#----------------+-------------------+-------------------
#  70ᵒ W -  80ᵒW |   80ᵒS            |   9ᵒN
#  80ᵒ W -  84ᵒW |   80ᵒS            |   9ᵒN
#  84ᵒ W -  90ᵒW |   80ᵒS	           |  14ᵒN
#  90ᵒ W - 100ᵒW |   80ᵒS	           |  18ᵒN
# 100ᵒ W - 145ᵒE |   80ᵒS	           |  66ᵒN
# 145ᵒ E - 100ᵒE |   0ᵒ              |  66ᵒN
# WOCE Indian Ocean Basin Boundaries
# Longitude band | Southern Latitude | Northern Latitude
#----------------|-------------------+-------------------
#  20ᵒE - 100ᵒE  |   80ᵒS            |  31ᵒN
# 100ᵒE - 145ᵒE  |   80ᵒS            |   0ᵒ
# Atlantic Ocean Basin Boundaries
# Longitude band | Southern Latitude | Northern Latitude
#----------------+-------------------+-------------------
# 100ᵒE -  20ᵒE  | 	31ᵒN             |	90ᵒN
#  20ᵒE -  70ᵒW	 |  80ᵒS	           |  90ᵒN
#  70ᵒW -  84ᵒW	 |   9ᵒN	           |  90ᵒN
#  84ᵒW -  90ᵒW	 |  14ᵒN	           |  90ᵒN
#  90ᵒW - 100ᵒW	 |  18ᵒN	           |  90ᵒN
# 100ᵒW - 100ᵒE	 |  66ᵒN	           |  90ᵒN
fh = GZip.open("basin_mask.txt.gz");
msk = readdlm(fh,',',Int);
itp = interpolate(msk,(BSpline(Constant()),BSpline(Constant())))
x = range(-180,stop = 180,length = 21601);
y = range(-90,stop = 90, length = 10801);
dx = x[3]-x[2];
dy = y[2]-y[1];
xx = x[1]-dx:dx:x[end]+dx;
yy = y[1]-dy:dy:y[end]+dy;
sitp = scale(itp,xx,yy);
"""
    b = basin(x,y)
    returns
      * b = 0 if (x,y) is a land point
      * b = 1 if (x,y) in Atlantic Basin
      * b = 2 if (x,y) in Indian Basin
      * b = 3 if (x,y) in Pacific Basin

"""
function basin(lon,lat)
  lon = atan(sin(lon*π/180),cos(lon*π/180))*180/π
  return sitp(lon,lat)
end
greet() = print("Hello World!")

end # module
