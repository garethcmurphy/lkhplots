


nfile=1
nend=2000
nstart=5
;nstart=1000
;nend=nstart+1
nend=152
;nend=1170
nstep=1
;nstart=12
;nend=152
;nstart=61
;nend=68
sfile = 0
pfile = 0
sfile = FILE_TEST('v0000.vtk')
pfile = FILE_TEST('data.0000.dbl')
print, sfile, pfile
code='snoopy'
if (pfile eq 1 ) then begin
code='pluto'
nstart=nlast
nend=nlast
nstep=2000

endif
nfile = FILE_TEST('usr000000.h5')
if (nfile eq 1 ) then begin
code='nirvana'
nstart=790000
getlast, nstart
nend=nstart
nstep=2000
endif




vshear=1.0
for nfile=nstart,nend,nstep do begin


;code='snoopy'
case code OF 
'nirvana': begin
nirvanaread, rho, vx,vy, vz,bx,by,bz, xx3d,yy3d,zz3d,xx,yy,zz,nx,ny,nz,nfile, time
sbq=1.5
sbomega=1
sba=-0.5*sbq*sbomega
vsh=2*sba
vshear=vsh*xx3d
vy=vy;-vshear

end
'pluto': begin
plutoread, dens, vx,vy, vz,bx,by,bz, xx3d,yy3d,zz3d,xx,yy,zz,nx,ny,nz,nfile, time
sbq=1.5
sbomega=1
sba=-0.5*sbq*sbomega
vsh=2*sba
vshear=vsh*xx3d
vy=vy-vshear
break;
end
'snoopy':begin
snoopyread, vx,vy, vz,bx,by,bz, xx3d,yy3d,zz3d,xx,yy,zz,nx,ny,nz,nfile, time
sbq=1.5
sbomega=1
sba=-0.5*sbq*sbomega
vsh=2*sba
vshear=vsh*xx3d
;vy=vy+vshear
rho=vshear
rho(*,*,*)=1.0
end
end

kstart=nz*7/8
kend=nz-1
invii=fltarr(nx,nz)
inviii=fltarr(nx,nz)



for i=0,nx-1 do begin
for k=kstart,kend do begin

u1=0.0d
u2=0.0d
u3=0.0d
reyave=dblarr(3,3)
reyave(*,*)=0.0d

for j=0,ny-1 do begin
    dens=rho(i,j,k)
    u1=vx(i,j,k)
    u2=vy(i,j,k)
    u3=vz(i,j,k)
    a=[u1,u2,u3]
    rey=dens*(a#a)
 reyave=reyave+rey
    endfor

 reystressanisotropytensor,  reyave,reyanis

eigenvalues = EIGENQL(reyanis)

l1=eigenvalues(0)
l2=eigenvalues(1)
l3=eigenvalues(2)
c1c=l1-l2
c2c=2*(l2-l3)
c3c=3*l3+1
x1c=-1.0
y1c=0.0
x3c=0.0
y3c=1.734

x2c=1.0
y2c=0.0

xn=c1c*x1c+ c2c*x2c +c3c*x3c
yn=c1c*y1c+ c2c*y2c +c3c*y3c


invii(i,k)=xn
inviii(i,k)=yn




;print, trace(rey)^2-trace(rey^2), det

;print, invii(i,j,k)
;print, rey(0,0), trace(rey^2), determ(rey)

endfor
endfor

print, mean(-invii, /double), mean(inviii, /double), format='(F27.24,  F27.24)'
;print, min(-invii), min(inviii)

;pdf=histogram(invii, locations=xbin,binsize=0.001) 
;cgplot, xbin, pdf    

;cgplot, inviii, -invii, psym=2
spawn, 'basename $PWD', dirtag
tag="banervh1"+dirtag
tag2="Reynolds z1"
qtag=strmid(dirtag,1,2)
qq=fix(qtag)
q=qq[0]/10.
qstr="q="+string(q, format='(F4.1)')
tag2=qstr+' , '+'z/H=3'
tag3=qstr+' , '+'z/H=3'
histbaner, invii, inviii, nfile, tag, tag2, time, tag3


endfor




end
