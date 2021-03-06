
nend=nlast
pload,0, /silent

sbq=1.5
sbomega=1e-3
sbomega=1
sba=-0.5*sbq*sbomega
vsh=2*sba

xx=rebin(reform(x1,nx1,  1,  1),nx1,nx2,nx3) 
yy=rebin(reform(x2,  1,nx2,  1),nx1,nx2,nx3) 
zz=rebin(reform(x3,  1,  1,nx3),nx1,nx2,nx3) 
vshear=vsh*xx
bconst=xx
bmag=1.0
bconst(*,*,*)=0.16437451

v1arr=fltarr(1)
v2arr=fltarr(1)
v3arr=fltarr(1)
b1arr=fltarr(1)
b2arr=fltarr(1)
b3arr=fltarr(1)
b3totarr=fltarr(1)
thetabarr=fltarr(1)
thetavarr=fltarr(1)

nxtot=1.0d*nx1*nx2*nx3
v1arr(0)=total(abs(vx1))/nxtot
v2arr(0)=total(abs(vx2-vshear))/nxtot
v3arr(0)=total(abs(vx3))/nxtot
b1arr(0)=total(abs(bx1))/nxtot
b2arr(0)=total(abs(bx2))/nxtot
b3arr(0)=total(abs(bx3-bconst))/nxtot
b3totarr(0)=total(abs(bx3))/nxtot
thetab=atan(bx1/(bx2))*!radeg
thetav=atan(vx1/(vx2-vshear))*!radeg
thetabarr(0)=max(thetab, /absolute)
thetavarr(0)=max(thetav, /absolute)
thetab=atan(bx1,(bx2))*!radeg
thetav=atan(vx1,(vx2-vshear))*!radeg
thetabarr(0)=max(thetab, /absolute)
thetavarr(0)=max(thetav, /absolute)

for i=1,nend do begin
pload,i, /silent

v1tot=total(abs(vx1))/nxtot
v2tot=total(abs(vx2-vshear))/nxtot
v3tot=total(abs(vx3))/nxtot
b1tot=total(abs(bx1))/nxtot
b2tot=total(abs(bx2))/nxtot
b3tot=total(abs(bx3-bconst))/nxtot
b3tottot=total(abs(bx3))/nxtot

;thetab=atan(bx1/(bx2))*!radeg
;thetav=atan(vx1/(vx2-vshear))*!radeg
thetab=atan(bx1,(bx2))*!radeg
thetav=atan(vx1,(vx2-vshear))*!radeg
thetabmax=max(thetab, /absolute)
thetavmax=max(thetav, /absolute)

v1arr=[v1arr,v1tot]
v2arr=[v2arr,v2tot]
v3arr=[v3arr,v3tot]
b1arr=[b1arr,b1tot]
b2arr=[b2arr,b2tot]
b3arr=[b3arr,b3tot]
b3totarr=[b3totarr,b3tottot]
thetabarr=[thetabarr,thetabmax]
thetavarr=[thetavarr,thetavmax]



endfor

omega=sbomega
tnorm=t*omega

 plotvecs, v1arr,v2arr,v3arr,b1arr,b2arr,b3arr, b3totarr, tnorm[0:nend-1]


growtharr=[  [ v1arr] , [ v2arr] , [ v3arr] , [ b2arr] , [ b2arr] , [ b3arr]  , [tnorm] ]

idstr=[  " v1arr" , " v2arr" , " v3arr" , " b1arr" , " b2arr" , " b3arr"  , "tnorm" ]

 ;; add to hdf5 file
  ;h5growth, growtharr, idstr


end
