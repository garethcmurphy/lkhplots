
cgdisplay, xs=1200, ys=1200


nstart=91
nend=219
nstep=2

sfile = 0
pfile = 0
sfile = FILE_TEST('v0000.vtk')
pfile = FILE_TEST('data.0000.dbl')
print, sfile, pfile
code='snoopy'
if (pfile eq 1 ) then begin
code='pluto'
endif

vshear=1.0
for nfile=nstart,nend,nstep do begin


;code='snoopy'
switch code OF 
'pluto': begin
pload,1
plutoread, dens, vx,vy, vz,bx,by,bz, xx3d,yy3d,zz3d,xx,yy,zz,nx,ny,nz,nfile, time
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

invii=fltarr(nx,nz)
inviii=fltarr(nx,nz)



for i=0,nx-1 do begin
for k=0,nz-1 do begin

u1=0.0d
u2=0.0d
u3=0.0d
reyave=dblarr(3,3)
reyave(*,*)=0.0d

for j=0,ny-1 do begin
    dens=rho(i,j,k)
    u1=bx(i,j,k)
    u2=by(i,j,k)
    u3=bz(i,j,k)
    b1=bx(i,j,k)
    b2=by(i,j,k)
    b3=bz(i,j,k)
    a=[b1,b2,b3]
    rey=a#a 
 reyave=reyave+rey
    endfor

 reystressanisotropytensor,  reyave,reyanis


invariants, reyanis, traa, det
invii(i,k)=traa
inviii(i,k)=determ(reyanis)

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
tag="lumley_b"
tag2="Maxwell"
histlumley3, invii, inviii, nfile, tag, tag2, time


endfor


r=rey

detr= r(0,0)*(r(1,1)*r(2,2)-r(1,2)*r(2,1))- r(0,1)*(r(1,0)*r(2,2)-r(1,2)*r(2,0))+ r(0,2)*(r(1,0)*r(2,1)-r(1,1)*r(2,0))

end
