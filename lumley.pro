


nfile=1
nend=2000
nstart=20
nend=nstart+1

vshear=1.0
for nfile=nstart,nend do begin


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

invii=fltarr(nx,ny,nz)
inviii=fltarr(nx,ny,nz)



for i=0,nx-1 do begin
for j=0,ny-1 do begin
for k=0,nz-1 do begin


    dens=rho(i,j,k)
    u1=vx(i,j,k)
    u2=vy(i,j,k)

    u3=vz(i,j,k)

 ;reystresstensor, u1,u2,u3, rey
 reystressanisotropytensor,  u1,u2,u3, rey


invariants, rey, traa, det
invii(i,j,k)=traa
inviii(i,j,k)=determ(rey)

;print, trace(rey)^2-trace(rey^2), det

;print, invii(i,j,k)
;print, rey(0,0), trace(rey^2), determ(rey)

endfor
endfor
endfor

print, mean(-invii, double), mean(inviii, /double), format='(F27.24,  F27.24)'
;print, min(-invii), min(inviii)

pdf=histogram(invii, locations=xbin,binsize=0.001) 
cgplot, xbin, pdf    

endfor


r=rey

detr= r(0,0)*(r(1,1)*r(2,2)-r(1,2)*r(2,1))- r(0,1)*(r(1,0)*r(2,2)-r(1,2)*r(2,0))+ r(0,2)*(r(1,0)*r(2,1)-r(1,1)*r(2,0))

end
