using NetCDF, DelimitedFiles
cd(dirname(@__FILE__));
fname = "ETOPO1_Ice_g_gmt4.grd";
x = ncread(fname,"x"); # longitude (degrees)
y = ncread(fname,"y"); # latitude (degrees)
z = ncread(fname,"z"); # depth (m)

# WOCE Pacific Ocean Basin Boundaries
# Longitude band | Southern Latitude | Northern Latitude
#----------------+-------------------+-------------------
#  70ᵒ W -  80ᵒW |   80ᵒS            |   9ᵒN
#  80ᵒ W -  84ᵒW |   80ᵒS            |   9ᵒN
#  84ᵒ W -  90ᵒW |   80ᵒS	           |  14ᵒN
#  90ᵒ W - 100ᵒW |   80ᵒS	           |  18ᵒN
# 100ᵒ W - 145ᵒE |   80ᵒS	           |  66ᵒN
# 145ᵒ E - 100ᵒE |   0ᵒ              |  66ᵒN
plon1 = findall((x.<-70).&(x.>=-80));plat1 = findall((y.>-85).&(y.<9));
plon2 = findall((x.<-80).&(x.>=-84));plat2 = plat1;
plon3 = findall((x.<-84).&(x.>=-90));plat3 = findall((y.>-85).&(y.<=14));
plon4 = findall((x.<-90).&(x.>=-100));plat4 = findall((y.>-85).&(y.<=18));
plon5 = findall((x.<=-100).|(x.>145));plat5 = findall((y.>-85).&(y.<=66));|
plon6 = findall((x.<145).&(x.>=100));plat6 = findall((y.>0).&(y.<=66));
plon7 = findall((x.<-175));plat7 = findall((y.>0).&(y.<69));
pmsk = z*0;
for j in plat1
  for i in plon1
    pmsk[i,j]=1;
  end
end
for j in plat2
  for i in plon2
    pmsk[i,j] = 1;
  end
end
for j in plat3
  for i in plon3
    pmsk[i,j] = 1;
  end
end
for j in plat4
  for i in plon4
    pmsk[i,j] = 1;
  end
end
for j in plat5
  for i in plon5
    pmsk[i,j] = 1;
  end
end
for i in plon6
  for j in plat6
    pmsk[i,j] = 1;
  end
end
pmsk = pmsk.*(z.<0);
imsk = z*0;
ilon1 = findall((x.>20).&(x.<=100)); ilat1 = findall((y.>-80).&(y.<=31));
ilon2 = findall((x.>100).&(x.<=145)); ilat2 = findall((y.>-80).&(y.<=0));
for j in ilat1
  for i in ilon1
    imsk[i,j] = 1;
  end
end
for j in ilat2
  for i in ilon2
    imsk[i,j] = 1;
  end
end
# WOCE Indian Ocean Basin Boundaries
# Longitude band | Southern Latitude | Northern Latitude
#----------------|-------------------+-------------------
#  20ᵒE - 100ᵒE  |   80ᵒS            |  31ᵒN
# 100ᵒE - 145ᵒE  |   80ᵒS            |   0ᵒ

imsk = imsk.*(z.<0);
# Atlantic Ocean Basin Boundaries
# Longitude band | Southern Latitude | Northern Latitude
#----------------+-------------------+-------------------
# 100ᵒE -  20ᵒE  | 	31ᵒN             |	90ᵒN
#  20ᵒE -  70ᵒW	 |  80ᵒS	           |  90ᵒN
#  70ᵒW -  84ᵒW	 |   9ᵒN	           |  90ᵒN
#  84ᵒW -  90ᵒW	 |  14ᵒN	           |  90ᵒN
#  90ᵒW - 100ᵒW	 |  18ᵒN	           |  90ᵒN
# 100ᵒW - 100ᵒE	 |  66ᵒN	           |  90ᵒN

amsk = (z.<0).-pmsk.-imsk;
msk = 3*pmsk+2*imsk+1*amsk;
msk = msk[[end;1:end;1],:];
msk = msk[:,[1;1:end;end]];
open("basin_mask.txt","w") do io
  writedlm(io,msk,',')
end;
