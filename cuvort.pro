pro cuvort, bx1,bx2,vx1,vx2, rho, prs, t , nlast, nx1,nx2,x1,x2, background,dx1,dx2, hires, plotgrowth, plotgrowthvortex, tag, doannotation, pl, doshift
pwd
growth=0
cg=0


ar=nx2*1.0/nx1
if (cg eq 1) then begin
cgwindow, xs=1500,ys=1100
;cgWindow
cgSet
endif else  begin
if (hires eq 1) then begin
xs=600-ar*400
ys=600+600*ar
xs=720
ys=880
window,xs=xs,ys=ys
endif else begin
window,xs=1000,ys=500
endelse
endelse
;loadct,33
;tvlct, 0,0,0,0
;tvlct, 255,255,255,1
pload,0
help, bx1

initvort= 0.0
initb1= 0.0
initb2= 0.0

;background=1
if ( background eq 1) then begin
initvort=getvort(bx1,bx2,x1,x2,nx1,nx2)
initb1=bx1
initb2=bx2
initv1=vx1
initv2=vx2

if ( doshift eq 1) then begin
initb1=shift(initb1,0,nx2/4)
initb2=shift(initb2,0,nx2/4)
initv1=shift(initv1,0,nx2/4)
initv2=shift(initv2,0,nx2/4)
endif

endif

nstart=1
nend=nlast
;nend=10
nstep=1
pload,0
totalb20=total(sqrt(bx1^2+bx2^2))
tbz2=fltarr(1)
tbx2=fltarr(1)
tbx2(*)=1
totvel1=fltarr(1)
totvel2=fltarr(1)
totprs=fltarr(1)

for nfile=nstart,nend,nstep do begin
print,'nfile= ', nfile

ll=6
zero=''
nts=strcompress(string(nfile),/remove_all)
lnt=strlen(nts)
for j=1,ll-lnt do zero=zero+'0'
           fname=tag+zero+nts

pload,nfile

if ( doshift eq 1) then begin
vx1=shift(vx1,0,nx2/4)
vx2=shift(vx2,0,nx2/4)
bx1=shift(bx1,0,nx2/4)
bx2=shift(bx2,0,nx2/4)
endif

!p.position=0
nx = nx1
nz = nx2
slice= 0


a=total(abs(bx2))/totalb20 ; total by^2
b=total(abs(bx1))/totalb20 ; total bx^2
qv1=total(abs(vx2))/totalb20 ; total by^2
qv2=total(abs(vx1))/totalb20 ; total bx^2
tbz2=[tbz2, a]
tbx2=[tbx2, b]
totvel1=[totvel1, qv1]
totvel2=[totvel2, qv2]
print, 'size tbz2', size(tbz2)

vort=getvort(bx1,bx2,x1,x2,nx1,nx2)
jy=-getvort(bx1-initb1,bx2-initb2,x1,x2,nx1,nx2)
vort3=getvort(vx1-initv1,vx2-initv2,x1,x2,nx1,nx2)
var=fltarr(9,nx1,nx2)
rho[0,0]=rho[0,0]+1e-6
var(0,*,*)=alog(prs)
;sndspd=sqrt(1.4*prs/rho)
;var(0,*,*)=sndspd
if ( background eq 1 ) then begin 
var(1,*,*)=vx1-initv1
var(2,*,*)=vx2-initv2
var(3,*,*)=vort3
var(4,*,*)=sqrt((bx1^2+bx2^2)/rho)
var(5,*,*)=bx1-initb1
var(6,*,*)=bx2-initb2
var(7,*,*)=jy
tag2="(backgr subtr)"
endif else begin
var(1,*,*)=vx1
var(2,*,*)=vx2
var(3,*,*)=vort3
var(4,*,*)=sqrt((bx1^2+bx2^2)/rho)
var(5,*,*)=bx1
var(6,*,*)=bx2
var(7,*,*)=jy
tag2="(backgr incl)"
endelse
str=strarr(9,20)
str(0,*)="prs"
str(1,*)="vx"
str(2,*)="vz"
str(3,*)="vort"
str(4,*)="Alfven speed"
str(5,*)="B!DX!N"
str(6,*)="B!DZ!N"
str(7,*)="Current"


;for qiq = 1,7 do begin
;r=reform(var(qiq,*,*))
;r=shift(r,0,nx2/4 )
;var(qiq,*,*)=r
;endfor

for usingps=0,1 do begin

if ( usingps ) then begin
set_plot,'ps'
device,filename=fname+'.eps',/encapsulated
device, /color
!p.font=0
device, /times
xs=3.53
ys=7.46
xs=2.59
ys=2.98
!p.charsize=.7
cbarchar=.7
xychar=.7
legchar=.7
DEVICE, XSIZE=xs, YSIZE=ys, /INCHES
endif else begin
set_plot,'x'
!p.font=-1
;!p.color=0
!p.charsize=1.8
cbarchar=1.8
xychar=1.8
legchar=1.8
;device, set_resolution=[1100,800]
endelse

;window, xs=1100,ys=800
if ( plotgrowth eq 1 ) then begin
!p.multi=0
endif 
if ( plotgrowthvortex eq 1) then begin
!p.multi=0
endif 
!p.multi=[0,1,1]
!x.style=1
!y.style=1


xx=x1*2*!PI*ar
yy=x2*2*!PI

;p1 = !P & x1 = !X & y1 = !Y








 cgLoadCT, 33
;tvlct, 0,0,0,0
;tvlct, 255,255,255,1



if ( plotgrowthvortex eq 1 ) then begin
for i=pl,pl do begin


;r=scale_vector(var(i,*,*),4,255)
r=reform(var(i,*,*))
;r=shift(r,0,nx2/4 )
;contour, r, xx,yy,/nodata, title=str(i), xtitle='x', ytitle='y'
p = [0.2, 0.13, 0.98, 0.98]
  ;cgIMAGE, r, POSITION=p, /KEEP_ASPECT_RATIO ;, MISSING_INDEX=3 , scale=4, bottom=190, top=254, background='white'
  cgimage, r, POSITION=p ,background='white', scale=1 ;, /axis, xtitle='x ', ytitle='y'
;cgaxis,0.5,0.1, /xaxis, /normal, xrange=[1,20]
;cgaxis, /xaxis, xRANGE=[0, 100], $
;MINOR=0, MAJOR=3
  cgcontour, r, xx,yy,POSITION=p, /NOERASE, XSTYLE=1, $
      YSTYLE=1,  NLEVELS=10, /nodata, $
      ;title=str(i)+', '+string(min(r),format='(G8.2)')+','+string(max(r),format='(G8.2)') , $
      xtitle='K!DX!NX', ytitle='K!DZ!NZ',$
      color='white'
imin=min(r)-1e-6
imax=max(r)+1e-6
;cgcolorbar, Position=[p[0], p[1]-0.07, p[2], p[1]-0.05], range=[imin,imax], format='(F7.2)', charsize=cbarchar

pthick=1.9

if (i eq 7 ) then begin
q=23
if (background eq 1) then begin
cv1=congrid(bx1-initb1,q,q)
cv2=congrid(bx2-initb2,q,q)
endif else begin
cv1=congrid(bx1,q,q)
cv2=congrid(bx2,q,q)
endelse 
cx=congrid(xx,q)
cy=congrid(yy,q)
!p.thick=pthick
velovect, cv1,cv2, cx,cy, /noerase,/overplot, position=p , color=cgcolor('white'), len=2.5, thick=1.25
!p.thick=1
cgloadct,33
endif


if (i eq 3 ) then begin
q=23
if (background eq 1) then begin
cv1=congrid(vx1-initv1,q,q)
cv2=congrid(vx2-initv2,q,q)
endif else begin
cv1=congrid(vx1,q,q)
cv2=congrid(vx2,q,q)
endelse 
cx=congrid(xx,q)
cy=congrid(yy,q)
!p.thick=pthick
velovect, cv1,cv2, cx,cy, /noerase,/overplot, position=p , color=cgcolor('white'), len=2.5, thick=1.25
!p.thick=1
cgloadct,33
endif
endfor

endif

growth=0
dogrowth=0
maxgam=0.013
if ( max(tbz2) ge maxgam ) then begin 
dogrowth=1
endif

; estimate growth rate
tsndcr=1.0/10.0 ; should be kh /10?
tnorm=t
;tnorm=t/tsndcr
if (  dogrowth ) then begin 

nel=n_elements(tbz2)
gam2=[0.01, maxgam]
tam2=interpol( tnorm(0:nel-1),tbz2, gam2)

print,'tam2' , tam2
print, 'gam2 ',gam2
growth=(gam2[1]-gam2[0])/(tam2[1]-tam2[0])
growth=(alog10(gam2[1])-alog10(gam2[0]))/(tam2[1]-tam2[0])
endif

if (plotgrowth  ne 0) then begin
cgplot, tnorm, alog10(tbz2), title='Log (Total |B!DZ!N|)' ,   xrange=[0.1,24],yrange=[-5,0], xtitle='t / t!D(VK)!N', ytitle='Log Total B!DZ!N /B!N!Dt=0!N' ,  psym=-14, Color='black',linestyle=0, background='white', /xlog
cgplot, tnorm, alog10(tbx2), /overplot, PSym=-15, Color='red',linestyle=2
cgplot, tnorm, alog10(totvel1), /overplot,PSym=-16, Color='dodger blue', linestyle=3
cgplot, tnorm, alog10(totvel2), /overplot, PSym=-17, Color='green', linestyle=4
al_legend, ['bz!U2!N','bx!U2!N', 'v1!U2!N','v2!U2!N'], PSym=[-14,-15,-16,-17], $
      LineStyle=[0,2,3,4], Color=['black','red','dodger blue','green'], charsize=legchar, /left
if ( dogrowth ) then begin 
;oplot,t,exp(growth*t/0.1)*gam2[0]/exp(growth*tam2[0]/0.1)
cgplot, tnorm, growth*(tnorm-tam2[0])+alog10(gam2[0]) ,  /overplot
cgplot, tam2, alog10(gam2), psym=4, /overplot
endif

endif 
talfven=1./max((bx1^2+bx2^2)/rho)
tresis=1/1e-4
tsound=1/max(prs/rho)
aspectratio=max(x2+0.5*dx2[0])/max(x1+0.5*dx1[0])

if ( doannotation eq 1) then begin
xyouts, 0.01,0.01,$
   'TM PLUTO, t='+string(t(nfile),format='(F5.1)')+ $
     ', growth'+string(growth, format='(F7.4)')+$
      ', asp. ratio '+string(aspectratio, format='(F4.2)')+$
      ' , t!DA!N'+string(talfven, format='(F8.4)')+$
      ' , t!DR!N'+string(tresis, format='(F9.1)')+$
      ' , t!DS!N'+string(tsound, format='(F7.4)'),$
         color=cgcolor('black'), $
   /normal, charsize=xychar
endif

!p.position=0
!p.multi=0


if ( usingps ) then begin
device,/close
set_plot,'x'
endif else begin
;set_plot,'x'
fname2=fname
im=cgsnapshot(filename=fname2,/nodialog,/jpeg)
endelse

endfor
set_plot,'x'


endfor

print, tbz2
f2name='growthratemhd.dat'
OPENW,1,f2name
PRINTF,1, max(x2)/max(x1), growth,FORMAT='(F9.6 , F9.6)'
CLOSE,1
print, totalb20
PRINT, max(x2)/max(x1), ' growth ', growth
end
