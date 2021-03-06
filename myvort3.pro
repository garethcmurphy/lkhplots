
cgdisplay, xs=1600,ys=600
for nfile=0,0 do begin
sload,nfile
fname='vort'+string(nfile, format='(I04)')

vx0=vx
vy0=vy

b1=max(vx)
b2=max(vy)
print, "background",max(vx), max(vy)
amp=9.*exp(0.07/2.*nfile )
;amp=0.5*(b1+b2)
print, "amp", amp
vx=vx-amp*sin(2*!DPI*zz3d)
vy=vy-amp*sin(2*!DPI*zz3d)

;curl, vx,vy,vz, cx,cy,cz

;dxvx=shift(vx,1,0,0) - shift(vx,-1,0,0)
dxvy=shift(vy,1,0,0) - shift(vy,-1,0,0)
dxvz=shift(vz,1,0,0) - shift(vz,-1,0,0)


dyvx=shift(vx,0,1,0) - shift(vx,0,-1,0)
;dyvy=shift(vy,0,1,0) - shift(vy,0,-1,0)
dyvz=shift(vz,0,1,0) - shift(vz,0,-1,0)

dzvx=shift(vx,0,0,1) - shift(vx,0,0,-1)
dzvy=shift(vy,0,0,1) - shift(vy,0,0,-1)
;dzvz=shift(vz,0,0,1) - shift(vz,0,0,-1)

cx=dyvz-dzvy
cy=-dxvz+dzvx
cz=dxvy-dzvy


; vort projected into 45 and -135 degrees

th=!DPI/4.
vortproj=cy*cos(th)-cx*sin(th)
;vortpar= -cy*sin(th)+cx*cos(th)


uhp=  vx*cos(th)+vy*sin(th)
vhp= -vx*sin(th)+vy*cos(th)


usl=reform(uhp(*,0,*))
vsl=reform(vhp(*,0,*))
wsl=reform( vz(*,0,*))
vortprojsl=reform( vortproj(*,0,*))

for i=0,nx-1 do begin
usl(i,*)=uhp(i,i,*)
vsl(i,*)=vhp(i,i,*)
wsl(i,*)= vz(i,i,*)
vortprojsl(i,*)= vortproj(i,i,*)
endfor

;vortprojsl=vortprojsl-9*exp(0.07*nfile/2)*sin(2*!PI*zz3d)

mx=0.2
if ( nfile lt 0 ) then begin
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

x=findgen(nx)
z=findgen(nz)
qx=congrid(usl,23,17)
qy=congrid(wsl,23,17)

qqx=congrid(x,23)
qqz=congrid(z,17)




for usingps=0,1 do begin
if (usingps eq 1) then begin
cgps_open, fname+'.eps', /encapsulated, /color, tt_font='Times', /quiet
endif else  begin
set_plot, 'x'
endelse





cgloadct,0
pos=[0.1,0.15,0.85,0.9]
cgloadct,33
var=vortprojsl
imin=min(var)
imax=max(var)
r=cgscalevector(vortprojsl,1,255) 
cgimage, r, pos=pos
cgcolorbar, range=[imin, imax] , pos=[pos[2]+0.07, pos[1], pos[2]+0.08, pos[3]], /vertical
cgcontour, cgscalevector(vortprojsl,1,455),x,z, /nodata,/noerase, pos=pos
velovect, qx,qy,qqx,qqz, color=cgcolor('white'), pos=pos, /overplot, thick=1.25, len=2.5 

if ( usingps ) then begin
cgps_close, /jpeg,  Width=2048, /nomessage
endif else begin
fname2=fname
;im=cgsnapshot(filename=fname2,/nodialog,/jpeg)
endelse

endfor



endfor
end
