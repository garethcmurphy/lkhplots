

usingps=0
!p.multi=0
readcol,'id0/CylNewtZ8.hst' ,t      ,dt         ,mass       ,x1Mom    ,x2Mom    ,x3Mom    ,x1KE      ,x2KE      ,x3KE      ,x1ME      ,x2ME      ,x3ME      ,AngMom  ,Br  ,Bp  ,Bz  ,Mrp  ,Trp  ,MdotR1  ,MdotR2  ,MdotR3  ,MdotR4  ,Msub  ,Mrpsub  ,Bpsub  ,Bzsub  ,Pbsub 

; it,t,dt,ux2m,uy2m,uz2m,uxuym,rhom,rhomin,rhomax,bx2m,by2m,bz2m,bxbym,ndm,ndmin,ndmax
    fname="timeseries"

ux2m=(x1KE/x1Mom)^2
uy2m=(x2KE/x2Mom)^2
uz2m=(x3KE/x3Mom)^2
ux2m=x1KE
uy2m=x2KE
uz2m=x3KE
bx2m=x1ME
by2m=x2ME
bz2m=x3ME
t=t/2.0d/!DPI

items=['v1','v2', 'v3', 'b1', 'b2', 'b3','growth=0.75' ]
linestyles=[0,0,0,3,2,2,1]
psym=[0,1,2,3,4,5,6]
colors=['red', 'blue', 'green', 'orange', 'turquoise', 'purple', 'black']


maxall=max([ [sqrt(ux2m)] , [sqrt(uy2m)], [sqrt(uz2m)] , [sqrt(bx2m)] , [sqrt(by2m)] ,[sqrt(bz2m)]   ])
minall=min([ [sqrt(ux2m)] , [sqrt(uy2m)], [sqrt(uz2m)] , [sqrt(bx2m)] , [sqrt(by2m)] ,[sqrt(bz2m)]   ])
ymin=1e-3*maxall


fname="timeseries_"
for usingps=0,1 do begin
if (usingps eq 1) then begin
cgps_open, fname+'.eps', /encapsulated, /color, tt_font='Times', /quiet
endif else  begin
set_plot, 'x'
endelse



cgplot, t, sqrt(ux2m), color=colors[0], linestyle=linestyles[0], /ylog, yrange=[ymin, max(maxall)], ystyle=1, title="Incompressible growth rates" ;, xrange=[0,18]
cgplot, t, sqrt(uy2m), /overplot, color=colors[1], linestyle=linestyles[1]
cgplot, t, sqrt(uz2m), /overplot, color=colors[2], linestyle=linestyles[2]
cgplot, t, sqrt(bx2m), /overplot, color=colors[3], linestyle=linestyles[3]
cgplot, t, sqrt(by2m), /overplot, color=colors[4], linestyle=linestyles[4]
cgplot, t, sqrt(bz2m), /overplot, color=colors[5], linestyle=linestyles[5]
cgplot, t, sqrt(ux2m[1])*exp(0.75*t), /overplot, color=colors[6], linestyle=linestyles[6]
cgplot, t, abs(bz2m-bx2m[0]), /overplot, color=colors[5], linestyle=linestyles[5]


fit=sqrt(ux2m[0])*exp(0.75*t)
dat=sqrt(ux2m)

nlines=size(t, /dimensions)
if ( nlines gt 80 ) then begin
print,"growth rate theory", (alog(fit[nlines])-alog(fit[nlines-10])) / (t[nlines]-t[nlines-10])

print, "growth rate data", (alog(dat[nlines])-alog(dat[nlines-10])) / (t[nlines]-t[nlines-10])
endif

rho=1.d0
omega=1.d0
va=0.16437451
lfast=sqrt(15.d0/16.d0) *2.d0 *!DPI  /omega/sqrt(rho) 
print, '1 lfast', 1/lfast

	al_legend, items, colors=colors, linestyle=linestyles, charsize=0.9, /right

print, 'Saturation level', maxall




if ( usingps ) then begin
;device,/close
cgps_close, /jpeg,  Width=1100
;set_plot,'x'
endif else begin
;set_plot,'x'
fname2=fname
;im=cgsnapshot(filename=fname2,/nodialog,/jpeg)
endelse

endfor





end
