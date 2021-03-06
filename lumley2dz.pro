

cgdisplay, xs=1200, ys=800


nfile=1
nend=2000
nstart=10
nend=nstart+1
nend=152

nstart=14
nend=46
nstep=32

nstart=4
nend=48
nstep=1



vshear=1.0
for nfile=nstart,nend,nstep do begin


code='pluto'
code='snoopy'
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

invii=fltarr(nx,ny)
inviii=fltarr(nx,ny)



for i=0,nx-1 do begin
for j=0,ny-1 do begin

u1=0.0d
u2=0.0d
u3=0.0d
reyave=dblarr(3,3)
reyave(*,*)=0.0d

for k=0,nz-1 do begin
    dens=rho(i,j,k)
    u1=vx(i,j,k)
    u2=vy(i,j,k)
    u3=vz(i,j,k)
    a=[u1,u2,u3]
    rey=a#a
 reyave=reyave+rey
    endfor

 reystressanisotropytensor,  reyave,reyanis


invariants, reyanis, traa, det
invii(i,j)=traa
inviii(i,j)=determ(reyanis)

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

tag="lumley2dz"
tag2="z-ave  Reynolds"
histlumley3, invii, inviii, nfile, tag, tag2, time


idstr=['invii','inviii']

endfor


r=rey

detr= r(0,0)*(r(1,1)*r(2,2)-r(1,2)*r(2,1))- r(0,1)*(r(1,0)*r(2,2)-r(1,2)*r(2,0))+ r(0,2)*(r(1,0)*r(2,1)-r(1,1)*r(2,0))

end
