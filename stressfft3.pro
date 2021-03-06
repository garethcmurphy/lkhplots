
xs=1200
cgdisplay, xs=xs,ys=xs

nfile=4


nbeg=105
nbeg=10
nend=105
nstep=nend-nbeg
;nend=nlast
spawn,'uname', listing
if ( listing ne 'Darwin') then begin
neven=nlast- (nlast mod 2)
nbeg=neven-2
nend=neven
nstep=2
endif

for nfile=nbeg,nend,nstep do begin
pload,nfile, /xyassoc, /silent
print, nfile




pos= cglayout([3,2] , OXMargin=[30,1], OYMargin=[30,12], XGap=6, YGap=12)



bnorm=1.0
;vec=bx1^2+bx2^2+bx3^2
tag='b'
;vec=bx1*bx2
tag='stress'
;vecnorm=total(vec)/nx1/nx2/nx3
;vec=vec/vecnorm


nh1=3*nx3/4
nh1=7*nx3/8



;levh1=vec(*,*,nh1)
levh1=bx1(nh1)*bx2(nh1)
levh1=levh1/mean(levh1)
fh1=alog10(nx1*nx2*abs(fft(levh1,/center)))
qsm=2
fh1=smooth(fh1,qsm)
nh0=nx3/2
;levh0=vec(*,*,nh0)
levh0=bx1(nh0)*bx2(nh0)
levh0=levh0/mean(levh0)
fh0=alog10(nx1*nx2*abs(fft(levh0,/center)))
fh0=smooth(fh0,qsm)

datptr=ptrarr(12)
datptr(0)=ptr_new(alog10(abs(levh1)))
datptr(1)=ptr_new(fh1)
datptr(2)=ptr_new(fh0)
datptr(3)=ptr_new(alog10(abs(levh0)))
datptr(4)=ptr_new(fh0)
datptr(5)=ptr_new(fh1)

titstr=strarr(12)
titstr(2)='dummy'
h1tag=string(x3(nh1), format='(F4.2)')
h0tag=string(x3(nh0), format='(F4.2)')
titstr(0)='log!D10!N|B!U2!N(x,y,z='+h1tag+')|'
titstr(1)='log!D10!N|B!U2!N(k!Dx!N,k!Dy!N), z='+string(x3(nh1), format='(F4.2)')+'|'
titstr(5)='dummy'
titstr(3)='log!D10!N|B!U2!N(x,y,z='+h0tag+')|'
titstr(4)='log!D10!N|B!U2!N(k!Dx!N,k!Dy!N), z='+string(x3(nh0), format='(F4.2)')+'|'
titstr(6)='p6'
titstr(7)='p7'

xtitstr=strarr(12)
xtitstr(2)='dummy'
xtitstr(0)='x/H'
xtitstr(1)='k!Dx!N'
xtitstr(5)='dummy'
xtitstr(3)='x/H'
xtitstr(4)='k!Dx!N'


ytitstr=strarr(12)
ytitstr(2)='dummy'
ytitstr(0)='y/H'
ytitstr(1)='k!Dy!N'
ytitstr(5)='dummy'
ytitstr(3)='y/H'
ytitstr(4)='k!Dy!N'

xaxis1=fltarr(12)
xaxis1(2)=999.
xaxis1(0)=x1(nx1-1)-x1(0)
xaxis1(1)=nx2
xaxis1(5)=999.0
xaxis1(3)=x1(nx1-1)-x1(0)
xaxis1(4)=nx2

xaxis2=fltarr(12)
xaxis2(2)=999.0
xaxis2(0)=(x1(nx1-1)-x1(0))/2.
xaxis2(1)=nx2/2
xaxis2(5)=999.0
xaxis2(3)=(x1(nx1-1)-x1(0))/2.
xaxis2(4)=nx2/2

yaxis1=fltarr(12)
yaxis1(2)=999.0
yaxis1(0)=x2(nx2-1)-x2(0)
yaxis1(1)=nx2
yaxis1(5)=999.0
yaxis1(3)=x2(nx2-1)-x2(0)
yaxis1(4)=nx2

yaxis2=fltarr(12)
yaxis2(2)=999
yaxis2(0)=(x2(nx2-1)-x2(0))/2
yaxis2(1)=nx2/2
yaxis2(5)=999
yaxis2(3)=(x2(nx2-1)-x2(0))/2
yaxis2(4)=nx2/2

cgloadct,33




fname=tag+'slices'+string(nfile,format='(I03)')

for usingps=0,1 do begin
if (usingps eq 1) then begin
cgps_open, fname+'.eps', /encapsulated, /color, tt_font='Times', /quiet ;, /nomatch, xs=20, ys=5, /bold
charsize=cgdefcharsize()*0.6
pi_str='!9p!X'
   !P.CharThick = 8
endif else  begin
set_plot, 'x'
charsize=cgdefcharsize()*1.1
pi_str='!7p!X'
endelse



pload, nfile, x2range=[0,0], var="bx1", /silent
pload, nfile, x2range=[0,0], var="bx2", /silent
pload, nfile, x2range=[0,0], var="bx3", /silent
pload, nfile, x2range=[0,0], var="rho", /silent

cgerase
b2=reform(bx1(*,0,*)^2+bx2(*,0,*)^2+bx3(*,0,*)^2)
gmm=5./3.
p=reform(rho(*,0,*)^gmm)

a=b2/2.d/p

print,max(a),min(a)



;pos1=[pos[0,0],pos[1,3],pos[2,0],pos[3,0]]
pos1=[0.1,pos[1,3],0.25,pos[3,0]]
d=alog10(a)
imin=min(d)
imax=max(d)
r=cgscalevector(d,1,254)
cgimage,r, pos=pos1
sz=size(d,/dimensions)
x=findgen(sz(0))/sz(0)-0.5
z=findgen(sz(1))/sz(1)*3-1.5
cgcontour, d, x1,x3, /nodata, pos=pos1, color='black', /noerase, $
    ;title='!9r!X', $
    charsize=cgDefCharsize()*.6,$
    ;title='log!D10!N|2p/B!U2!N|', $
    xticks=3,$
    xtickinterval=1,$
    title='log!D10!N|B!U2!N/2p|', $
    xtitle='x/H', ytitle='z/H'
p=pos1
cgcolorbar, Position=[p[0], p[1]-0.07, p[2], p[1]-0.06], range=[imin,imax], format='(I5)', $
    charsize=cgDefCharsize()*.6

nplot=[0,1,3,4]

xtickinterval=[1,100,1,100]
ytickinterval=xtickinterval

for myc=0,3 do begin
i=nplot[myc]
d=*datptr(i)
r=cgscalevector(d,1,254)
imin=min(d)
imax=max(d)
cgimage, r, pos=pos[*,i], /noerase
sz=size(d,/dimensions)
x=findgen(sz(0))/sz(0)*xaxis1(i)-xaxis2(i)
y=findgen(sz(1))/sz(1)*yaxis1(i)-yaxis2(i)
cgcontour, d,x,y, /nodata, pos=pos[*,i], color='black', /noerase, $
    charsize=cgDefCharsize()*.6,$
    title=titstr(i),$
    xtitle=xtitstr(i),$
    xtickinterval=xtickinterval[myc],$
    ytickinterval=ytickinterval[myc],$
    ytitle=ytitstr(i)
p=pos[*,i]
cgcolorbar, Position=[p[0], p[1]-0.07, p[2], p[1]-0.06], range=[imin,imax], $
    format='(I5)',$
    charsize=cgDefCharsize()*.6

    if (  (myc eq 1 ) or (myc eq 3)) then begin
    gft=gauss2dfit(d^2, aa,/tilt)
    cgcontour, gft, x,y, /overplot, pos=p, color='Black', Charsize=cgDefCharsize()*0.9 , label=0
    
angle=aa[6]
if ( (angle gt  !DPI/2.) and (angle lt  !DPI)) then angle = angle-!DPI/2.0d
if ( (angle lt   0) and (angle gt  -!DPI/2)) then angle = angle+!DPI/2.0d
if ( (angle lt -!DPI/2.) and (angle gt -!DPI)) then angle = angle+!DPI
angle=!PI/2-angle
print, 'angle=', angle*!RADEG
    endif
endfor

k=findgen(nx1/2)
fftarr1=*datptr(1)
sz=size(fftarr1, /dimensions)
  gft=gauss2dfit(fftarr1^2, aa,/tilt)

f1=fftarr1(nx1/2:nx1-1,sz(1)/2)

angle=aa[6]
if ( (angle gt  !DPI/2.) and (angle lt  !DPI)) then angle = angle-!DPI/2.0d
if ( (angle lt   0) and (angle gt  -!DPI/2)) then angle = angle+!DPI/2.0d
if ( (angle lt -!DPI/2.) and (angle gt -!DPI)) then angle = angle+!DPI
angle=!PI/2-angle
print, 'angle=', angle*!RADEG

;angle=!DPI/5.d

nxq=sz(0)
nyq=sz(1)
xq=findgen(nxq/2)*cos(angle)+nxq/2
yq= findgen(nyq/2)*sin(angle)+nyq/2

k1max=sqrt(  (  findgen(nxq/2)*cos(angle)  )^2+( findgen(nyq/2)*sin(angle) )^2)
   f1=interpolate (fftarr1 ,xq,yq)





cgplot, k,f1,pos=pos[*,2], /noerase, xtitle='k', /xlog, xrange=[1,max(k)], charsize=charsize, $
color='black',$
    title='log!D10!N|B!U2!N(k!Dx!N,k!Dy!N)|',$
    ytitle='log!D10!N|B!U2!N(k!Dx!N,k!Dy!N)|'
fftarr0=*datptr(4)
   f0=interpolate (fftarr0 ,xq,yq)
cgplot, k,f0,pos=pos[*,5], /noerase, xtitle='k', /xlog, xrange=[1,max(k)], charsize=charsize,$
color='red',$
    title='',$
    ytitle='log B(k!Dx!N,k!Dy!N)'
cgplot, k,f1,/overplot, color='black'
items=['z='+h1tag,'z='+h0tag]
al_legend, items, linestyle=[0,0], /bottom, color=['black','red'], charsize=charsize*0.8, linsize=0.25

readcol,'averages.dat',tn1,dt,b2,vx2,vy2,vz2,bx2,by2,bz2
tnorm=tn1/2.d/!DPI

ctime=t(nfile)
zz=where ( tn1 gt ctime)
lim=zz(0)

bx2s=bx2[0:lim]
by2s=by2[0:lim]
bz2s=bz2[0:lim]
ymax=max( [ bx2,by2, bz2] )
cgplot, tnorm, bx2s , pos=[0.1,0.1,0.98,0.2], /noerase, /ylog, yrange=[1e-2*ymax,ymax], color=['red'], ytitle='B!Dx,y,z!N', xtitle='time/2'+pi_str+'  (orbits)'
cgplot, tnorm, by2s , /overplot, color=['blue']
cgplot, tnorm, bz2s , /overplot, color=['green']
items=['B!Dx!N','B!Dy!N','B!Dz!N']
colors=['red','blue','green']
al_legend,items,linestyle=[0,0,0], color=colors, charsize=charsize*0.8, linsize=0.25, /right

cgtext, 0.2,0.95, "DFT at z="+h0tag+','+h1tag+", t/2"+pi_str+"="+string(t[nfile]/2/!DPI, format='(F4.1)')+' orbits', /normal


if ( usingps ) then begin
cgps_close, /jpeg,  Width=2048, /nomessage
endif else begin
fname2=fname
;im=cgsnapshot(filename=fname2,/nodialog,/jpeg)
endelse

endfor


endfor


end
