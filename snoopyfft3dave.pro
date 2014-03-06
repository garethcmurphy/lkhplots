   cgDisplay, WID=1,xs=1800, ys=700, xpos=100, ypos=700
; load some sheared data

nfile=2
nstart=400
nend=418
snoopyread, vx,vy, vz,bx,by,bz, xx3d,yy3d,zz3d,xx,yy,zz,nx,ny,nz,nfile, time
timeave=dblarr(nx,ny,nz)
tempim=dblarr(nx,ny,19)
for nfile=nstart,nend do begin
snoopyread, vx,vy, vz,bx,by,bz, xx3d,yy3d,zz3d,xx,yy,zz,nx,ny,nz,nfile, time
nx1=nx
nx2=ny
nx3=nz
x1=xx
x2=yy
x3=zz

t=findgen(nfile+1)
mytime=time
vec=vz
xx=x1
yy=x2
xx2d=rebin(reform(xx,nx1,1),nx1,nx2)
yy2d=rebin(reform(yy,1,nx2),nx1,nx2)
xx3d=rebin(reform(xx,nx1,1,1),nx1,nx2,nx3)
yy3d=rebin(reform(yy,1,nx2,1),nx1,nx2,nx3)

vfft=fft(vec,2)
vfft=abs(vfft)

ky=[findgen(nx2/2), -nx2/2+findgen(nx2/2)]
ky2d=rebin(reform(ky,1,nx2),nx1,nx2)
ky3d=rebin(reform(ky,1,nx2,1),nx1,nx2,nx3)


q=1.5d
omega=1.0
S=q*omega
time=mytime
; dt is difference in time between this, and the nearest shear periodic point
;
dt=mytime mod  2.0d
dt=mytime mod  0.666666666666666666666666666666666666d
time=dt
print, 'time=',time,' dt=',dt
Ly=2.0
qomegat_Ly=q*omega*time/Ly

cfft1=fft(vec,dimension=2)
jimag=complex(0,1)
cfft1shift=cfft1*exp ( -jimag * ky3d * xx3d *2 *!PI *qomegat_Ly ) 
cfft2=fft(cfft1shift, dimension=1)
cfft3=fft(cfft2, dimension=3)
timeave=timeave+abs(cfft3)
nim=nfile-400
tempim(*,*,nim)=shift(alog10(abs(cfft3(*,*,0))),nx1/2,nx2/2)


ffttot=complexarr(nx1,nx2)
 shearfft2d, vec, ffttot, qomegat_Ly,x2d, nx1,nx2, x1


ifftmy=fft(cfft2, -1)
 rcfft2=real_part(ifftmy)

ifftshear=fft(ffttot,-1)
final=real_part(ifftshear)

dataptr=ptrarr(18)

dataptr[ 0]=ptr_new(final(*,*,0) )
dataptr[ 1]=ptr_new(shift(alog10(timeave(*,*,0)),nx1/2,nx2/2))
dataptr[ 2]=ptr_new(shift(alog10(abs(cfft3(*,*,0))),nx1/2,nx2/2))
dataptr[ 3]=ptr_new(tempim(*,*,1))
dataptr[ 4]=ptr_new(tempim(*,*,2))
dataptr[ 5]=ptr_new(tempim(*,*,3))
dataptr[ 6]=ptr_new(xx2d)
dataptr[ 7]=ptr_new(final)
dataptr[ 8]=ptr_new(rcfft2)
dataptr[ 9]=ptr_new(rcfft2)
dataptr[10]=ptr_new(rcfft2)
dataptr[11]=ptr_new(final)
dataptr[12]=ptr_new(final)
dataptr[13]=ptr_new(final)
dataptr[14]=ptr_new(final)
dataptr[15]=ptr_new(final)

pos=[0.2,0.1,0.9,0.9]

titlestr=strarr(18,30)
titlestr[ 0,*]='vz'
titlestr[ 1,*]='Averaged DFT of vz'
titlestr[ 2,*]='DFT t+0.01 orbits'
titlestr[ 3,*]='DFT t+0.02 orbits'
titlestr[ 4,*]='DFT t+0.03 orbits'
titlestr[ 5,*]='DFT t+0.04 orbits'
titlestr[ 6,*]='xx2d'
titlestr[ 7,*]='bz'
titlestr[ 8,*]='bz'
titlestr[ 9,*]='bz'
titlestr[10,*]='bz'
titlestr[10,*]='bz'
titlestr[10,*]='bz'
titlestr[10,*]='bz'
titlestr[10,*]='bz'
titlestr[10,*]='bz(z,t)'


  
fname="sheartest"+string(nfile, format='(I03)')
for usingps=0,1 do begin
if (usingps eq 1) then begin
cgps_open, fname+'.eps', /encapsulated, /color, tt_font='Times', /quiet
endif else  begin
set_plot, 'x'
endelse





   cgLoadCT, 33
   pos = cglayout([3,2] , OXMargin=[4,12], OYMargin=[5,6], XGap=9, YGap=2)
   FOR j=0,5 DO BEGIN
     p = pos[*,j]
     d= *dataptr(j)
	r=cgscalevector(d, 1,254)
	imin=min(*dataptr[j])
	imax=max(*dataptr[j])
     cgImage, r, NoErase=j NE 0, Position=p
  cgcontour,xx#yy, xx,yy , /nodata, /noerase, xtitle='x', pos=p, title=titlestr(j), Charsize=cgDefCharsize()*0.5
     cgColorBar, position=[p[2]+0.06, p[1], p[2]+0.07, p[3]],range=[imin-1e-6,imax+1e-6], Charsize=cgDefCharsize()*0.5 , /vertical
   ENDFOR
;   cgText, 0.5, 0.9, /Normal,  'vz and DFT(vz), t='+string(mytime), Alignment=0.5, Charsize=cgDefCharsize()*1.25


if ( usingps ) then begin
;device,/close
cgps_close, /jpeg,  Width=2048
;set_plot,'x'
endif else begin
;set_plot,'x'
fname2=fname
;im=cgsnapshot(filename=fname2,/nodialog,/jpeg)
endelse

endfor


endfor



end
