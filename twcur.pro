pro twcur, background
little_endian = getendian()
;background=0
hires=1
doxwin=1
if ( hires eq 1) then begin
xs=1300
ys=1300
endif else begin
xs=800
ys=800
endelse 
if ( doxwin eq 1 ) then begin
set_plot, 'x'
window, xs=xs, ys=ys
endif else begin
set_plot, 'z'
device, set_resolution=[1300,1100]
endelse

qtag='with_background_'
if ( background eq 1) then begin
qtag='background_subtracted_'
endif
onefile=0
if ( onefile eq 1 ) then begin
qnumq=0
nend=5
nstart=nend
nstep=1
endif else begin
nend=400
nstart=1
if ( background eq 1) then begin
nstart=1
endif
nstep=1
endelse
t=findgen(1)
if( nend gt 0) then begin
t=findgen(nend)
endif

slice=0


   IF (little_endian) THEN $
f=rf(0) ELSE $
f=rf(0, /swap_endian)
nx=f.s.gn[0]
nz=f.s.gn[2]
xx=findgen(nx)
yy=findgen(nz)

vixinit=reform(f.v[*,slice,*,0,1]/f.d[*,slice,*,1])
viyinit=reform(f.v[*,slice,*,1,1]/f.d[*,slice,*,1])
vizinit=reform(f.v[*,slice,*,2,1]/f.d[*,slice,*,1])
vexinit=reform(f.v[*,slice,*,0,0]/f.d[*,slice,*,0])
veyinit=reform(f.v[*,slice,*,1,0]/f.d[*,slice,*,0])
vezinit=reform(f.v[*,slice,*,2,0]/f.d[*,slice,*,0])
bx0=reform(f.bx[*,slice,*],nx,nz)
by0=reform(f.by[*,slice,*],nx,nz)
bz0=reform(f.bz[*,slice,*],nx,nz)
ex0=reform(f.ex[*,slice,*],nx,nz)
ey0=reform(f.ey[*,slice,*],nx,nz)
ez0=reform(f.ez[*,slice,*],nx,nz)

;filter= butterworth(size(vixinit, /dimensions), order=2, cutoff=10)
filter= butterworth(size(vixinit, /dimensions), order=3, cutoff=1)
qsm=100
;vixsm=smooth(vixinit,qsm,/edge_wrap)
;vizsm=smooth(vizinit,qsm,/edge_wrap)
vixsm=FFT( FFT(vixinit, -1) * filter, 1 ) 
vizsm=FFT( FFT(vizinit, -1) * filter, 1 ) 
bxsm0=FFT( FFT(bx0, -1) * filter, 1 ) 
bysm0=FFT( FFT(by0, -1) * filter, 1 ) 
bzsm0=FFT( FFT(bz0, -1) * filter, 1 ) 


;initionvort = 0.5*(shift(vixsm,0,-1)-shift(vixsm,0,1) ) - 0.5*(shift(vizsm,-1,0) - shift(vizsm,1,0))
initionvort=getvort(vixsm,vizsm,xx,yy,nx,nz)
ux0=vixinit
uy0=viyinit
uz0=vizinit
jx0=ex0+uy0*bz0-uz0*by0
;jy0=ey0+uz0*bx0-ux0*bz0
;jy0=-uz0*bx0+ux0*bz0
jx0=getvort(bysm0,bzsm0,xx,yy,nx,nz)
jy0=getvort(bxsm0,bzsm0,xx,yy,nx,nz)
jz0=getvort(bxsm0,bysm0,xx,yy,nx,nz)
;jz0=ez0+ux0*by0-uy0*bx0
vixsm0=vixsm
vizsm0=vizsm

;vexsm=smooth(vexinit,qsm,/edge_wrap)
;vezsm=smooth(vezinit,qsm,/edge_wrap)
vexsm=FFT( FFT(vexinit, -1) * filter, 1 ) 
vezsm=FFT( FFT(vezinit, -1) * filter, 1 ) 
;initelecvort= 0.5*(shift(vexsm,0,-1)-shift(vexsm,0,1) ) - 0.5*(shift(vezsm,-1,0) - shift(vezsm,1,0))
initelecvort=getvort(vexsm,vezsm,xx,yy,nx,nz)
;vex0=vex
;vez0=vez
vexsm0=vexsm
vezsm0=vezsm

totalelecke0=total(vexinit^2+vezinit^2)
totalionke0=total(vixinit^2+vizinit^2)
gamma=fltarr(1)
tvx2=fltarr(1)
tvx2(*)=1

for nfile=nstart,nend,nstep do begin
print, ' nfile= ' , nfile

ll=6
zero=''
nts=strcompress(string(nfile),/remove_all)
lnt=strlen(nts)
for j=1,ll-lnt do zero=zero+'0'
           fname='ebvd_'+qtag+zero+nts


varfile='VAR1'
tag=zero+nts+'.dat'
varfile='fields-'+tag
path='Data/'

if (  file_test(path+varfile)  ne 1 ) then begin
print, varfile+' does not exist, exiting'
break
endif

   IF (little_endian) THEN $
f=rf(nfile) ELSE $
f=rf(nfile, /swap_endian)
;p=rp(nfile, /wrap)

!p.position=0
nx = f.s.gn[0]
nz = f.s.gn[2]
nx1=findgen(nx)
nx2=findgen(nz)
;print, nx,nz
slice= f.s.gn[1]/2

bx=reform(f.bx[*,slice,*],nx,nz)
by=reform(f.by[*,slice,*],nx,nz)
bz=reform(f.bz[*,slice,*],nx,nz)
ex=reform(f.ex[*,slice,*],nx,nz)
ey=reform(f.ey[*,slice,*],nx,nz)
ez=reform(f.ez[*,slice,*],nx,nz)
vix=reform(f.v[*,slice,*,0,1]/f.d[*,slice,*,1],nx,nz)
viy=reform(f.v[*,slice,*,1,1]/f.d[*,slice,*,1],nx,nz)
viz=reform(f.v[*,slice,*,2,1]/f.d[*,slice,*,1],nx,nz)
vex=reform(f.v[*,slice,*,0,0]/f.d[*,slice,*,0],nx,nz)
vey=reform(f.v[*,slice,*,1,0]/f.d[*,slice,*,0],nx,nz)
vez=reform(f.v[*,slice,*,2,0]/f.d[*,slice,*,0],nx,nz)

a=total(vex^2)/totalelecke0
b=total(vix^2)/totalionke0
gamma=[gamma, a]
tvx2=[tvx2, b]
;print, size(gamma)


for usingps=0,1 do begin

if ( usingps ) then begin
set_plot,'ps'
device,filename=fname+'.eps',/encapsulated
device, /color
!p.font=0
device, /times
xs=11.
ys=12
!p.charsize=1.8
DEVICE, XSIZE=xs, YSIZE=ys, /INCHES
endif else begin
set_plot,'x'
!p.font=-1
!p.color=0
!p.background=255
!p.charsize=1.8
;window, xs=1100,ys=800
;device, Set_Resolution=[1100,800]
endelse

;window, xs=1100,ys=800
dophasespace=0
!p.multi=[0,3,4]
 if ( dophasespace eq 1) then begin
!p.multi=[0,4,4]
endif
!x.style=1
!y.style=1


xx=findgen(nx)
yy=findgen(nz)

p1 = !P & x1 = !X & y1 = !Y


elec=0
ion=1
xdir=0
ydir=1
zdir=2
px=0
py=1
pz=2

;qnparq=n_Elements(p.r[*,xdir,elec])
;var=fltarr(16,qnparq)

titlstr=strarr(8,30)



;;
;;  
;;;

ux=vix
uy=viy
uz=viz
;jx=ex+uy*bz-uz*by
;jy=ey+uz*bx-ux*bz
;jy=-uz*bx+ux*bz
;jz=ez+ux*by-uy*bx

var=fltarr(12,nx,nz)
;help,var, vex,vey,vez
var(0,*,*)=vix
var(1,*,*)=viz
;vixsm=smooth(vix,qsm,/edge_wrap)
;vizsm=smooth(viz,qsm,/edge_wrap)
vixsm=FFT( FFT(vix, -1) * filter, 1 ) 
vizsm=FFT( FFT(viz, -1) * filter, 1 ) 
bxsm=FFT( FFT(bx, -1) * filter, 1 ) 
bysm=FFT( FFT(by, -1) * filter, 1 ) 
bzsm=FFT( FFT(bz, -1) * filter, 1 ) 
jx=getvort(bysm,bzsm,xx,yy,nx,nz)
jy=getvort(bxsm,bzsm,xx,yy,nx,nz)
jz=getvort(bxsm,bysm,xx,yy,nx,nz)
if (background eq 1 ) then var(0,*,*)=vixsm-vixsm0
if (background eq 1 ) then var(1,*,*)=vizsm-vizsm0
;var(0,*,*)=smooth(var(0,*,*), qsm, /edge_wrap)
;var(1,*,*)=smooth(var(1,*,*), qsm, /edge_wrap)
var(0,*,*)= FFT( FFT( var(0,*,*) , -1) * filter, 1 ) 
var(1,*,*)= FFT( FFT( var(1,*,*) , -1) * filter, 1 ) 
;vixsm=vix
;vizsm=viz
vortion= 0.5*(shift(vixsm,0,-1)-shift(vixsm,0,1) ) - 0.5*(shift(vizsm,-1,0) - shift(vizsm,1,0))
;vortion=getvort(vixsm,vizsm,xx,yy,nx,nz)
;vortion=getvort(bx,bz,xx,yy,nx,nz)
if (background eq 1 ) then begin
var(2,*,*) = vortion-initionvort
var(2,*,*)=getvort(vixsm-vixsm0,vizsm-vizsm0,xx,yy,nx,nz) 
endif else begin
        var(2,*,*)= vortion
endelse

vexsm=FFT( FFT(vex, -1) * filter, 1 ) 
vezsm=FFT( FFT(vez, -1) * filter, 1 ) 
var(3,*,*)=vex
if (background eq 1 ) then var(3,*,*)=vexsm-vexsm0
;var(3,*,*)=smooth(var(3,*,*), qsm, /edge_wrap)
var(3,*,*)= FFT( FFT( var(3,*,*) , -1) * filter, 1 ) 
var(4,*,*)=vez
if (background eq 1 ) then var(4,*,*)=vezsm-vezsm0
;var(4,*,*)=smooth(var(4,*,*), qsm, /edge_wrap)
var(4,*,*)= FFT( FFT( var(4,*,*) , -1) * filter, 1 ) 
;vexsm=vex
;vezsm=vez
;vortelec= 0.5*(shift(vexsm,0,-1)-shift(vexsm,0,1) ) - 0.5*(shift(vezsm,-1,0) - shift(vezsm,1,0)) 
vortelec=getvort(vexsm,vezsm,xx,yy,nx,nz)
if (background eq 1 ) then begin
var(5,*,*)= vortelec-initelecvort
var(5,*,*)=getvort(vexsm-vexsm0,vezsm-vezsm0,xx,yy,nx,nz) 
endif else begin
var(5,*,*)= vortelec
endelse
var(6,*,*)=ex
var(7,*,*)=ey
var(8,*,*)=jy-jy0
var(9,*,*)=bxsm
var(10,*,*)=by
var(11,*,*)=bzsm
if (background eq 1 ) then begin
var(6,*,*)=ex-ex0
var(7,*,*)=ey-ey0
var(8,*,*)=jy-jy0
var(9,*,*)=bxsm-bxsm0
var(10,*,*)=by-by0
var(11,*,*)=bzsm-bzsm0
endif

titlstr=strarr(12,30)
titlstr(0,*)="V!Dion, X!N"
titlstr(1,*)="V!Dion, Z!N"
titlstr(2,*)="Ion Vorticity"
titlstr(3,*)="V!Delec, X!N"
titlstr(4,*)="V!Delec, Z!N"
titlstr(5,*)="Electron Vorticity"
titlstr(6,*)="E!DX!N"
titlstr(7,*)="E!DY!N"
titlstr(8,*)="J!DY!N"
titlstr(9,*)="B!DX!N"
titlstr(10,*)="B!DY!N"
titlstr(11,*)="B!DZ!N"

for  qgmq = 0,11 do begin
mx=max(var(qgmq,*,*))
mn=min(var(qgmq,*,*))
titlstr(qgmq,*) = titlstr(qgmq,*)+' , ' +string(mn, format='(F8.5)')+string(mx , format='(F8.5)')

endfor



;contour, vez, xx,yy,/nodata, title='V!Delec, Z!N'
;tvimage, r, /overplot

 cgLoadCT, 33, CLIP=[5, 245]

for i=0,11 do begin
   pos = [0.02, 0.35, 0.98, 0.91]
localimagecopy=reform(var(i,*,*))
 cgIMAGE, localimagecopy, POSITION=pos, /KEEP_ASPECT_RATIO ,background='white', scale=1
 cgcontour, localimagecopy, xx,yy,POSITION=pos, /NOERASE, XSTYLE=1, $
      YSTYLE=1,  NLEVELS=10, /nodata, title=titlstr(i), $
       axiscolor='black',$
      xtitle='x ', ytitle='y'
imin=min(localimagecopy)-1e-6
imax=max(localimagecopy)+1e-6
cgcolorbar, Position=[pos[0], pos[1]-0.04, pos[2], pos[1]-0.03], range=[imin,imax], format='(G12.1)', annotatecolor='black'

q=25
if ( i eq 8 or i eq 2 or i eq 5) then begin
case i>2<8 of
2:    begin
        if ( background eq 1 ) then begin
        cv1=congrid(vixsm-vixsm0,q,q)
        cv2=congrid(vizsm-vizsm0,q,q)
        endif else begin
        cv1=congrid(vixsm,q,q)
        cv2=congrid(vizsm,q,q)
        endelse
      end
5: begin
        if ( background eq 1 ) then begin
        cv1=congrid(vexsm-vexsm0,q,q)
        cv2=congrid(vezsm-vezsm0,q,q)
        endif else begin
        cv1=congrid(vexsm,q,q)
        cv2=congrid(vezsm,q,q)
        endelse 
end
8: begin
        if ( background eq 1 ) then begin
        cv1=congrid(bxsm-bxsm0,q,q)
        cv2=congrid(bzsm-bzsm0,q,q)
        endif else begin
        cv1=congrid(bxsm,q,q)
        cv2=congrid(bzsm,q,q)
        endelse 
end
endcase
cx=congrid(xx,q)
cy=congrid(yy,q)

velovect, cv1,cv2, cx,cy, /noerase,/overplot, position=pos , color=cgcolor('white'), c_thick=4
cgloadct,33
endif
endfor


!x.range=0
!y.range=0
;cgplot,  gamma, title='Total x-kinetic energy',color='black' ;, /xlog, /ylog
;cgplot,  tvx2, /overplot, color='black'

qqtag=" backgr included"
if (background eq 1) then begin
qqtag=" backgr. subtracted"
endif
xyouts, 0.01,0.01,$
   't='+string(f.s.time,format='(F12.5)')+' , '+qqtag+' ncellsx '+string(f.s.gn[0])+' '+string(f.s.ds(0)),$
   /normal, charsize=3

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


var=0
print,a,b
endfor

cgloadct,0, /reverse
end
