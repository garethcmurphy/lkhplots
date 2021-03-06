
sload,0
vx0=vx[0:nx/2-1,0:ny/2-1,*]
vy0=vy[0:nx/2-1,0:ny/2-1,*]


myarr=dblarr(nx/2,nz,4)
myv1=dblarr(nx/2,nz,4)
myv2=dblarr(nx/2,nz,4)

;cgdisplay, xs=1600,ys=600

plotlist=[3,4,6,8]

for nplot=0,3 do begin
fname='vort'+string(nplot, format='(I04)')



sload,plotlist(nplot)
b1=max(vx)
b2=max(vy)
print, "background",max(vx), max(vy)
;amp=exp(0.07/2.*nfile )
amp=0.5*(b1+b2)/9.0d
amp=0.
print, "amp", amp
dvx=vx[0:nx/2-1,0:ny/2-1,*]-amp*vx0
dvy=vy[0:nx/2-1,0:ny/2-1,*]-amp*vy0
dvz=vz[0:nx/2-1,0:ny/2-1,*]

curl, dvx,dvy,dvz, cx,cy,cz


; vort projected into 45 and -135 degrees

th=!DPI/4.
vortproj=cy*cos(th)-cx*sin(th)
;vortpar= -cy*sin(th)+cx*cos(th)


uhp=  dvx*cos(th)+dvy*sin(th)
vhp= -dvx*sin(th)+dvy*cos(th)


usl=reform(uhp(*,0,*))
vsl=reform(vhp(*,0,*))
wsl=reform( dvz(*,0,*))
vortprojsl=reform( vortproj(*,0,*))



for i=0,nx/2-1 do begin
usl(i,*)=uhp(i,i,*)
vsl(i,*)=vhp(i,i,*)
wsl(i,*)= vz(i,i,*)
vortprojsl(i,*)= vortproj(i,i,*)
endfor

mx=0.1
if ( nplot lt 0 ) then begin
    for i=0,nx-1 do begin
    for j=0,nz-1 do begin
    if (vortprojsl(i,j) gt mx ) then begin
     vortprojsl(i,j)=mx
    endif
    if (vortprojsl(i,j) lt -mx ) then begin
     vortprojsl(i,j)=-mx
    endif
    endfor
    endfor
endif



myarr[*,*,nplot]=vortprojsl
myv1[*,*,nplot]=usl
myv2[*,*,nplot]=wsl

endfor

end
