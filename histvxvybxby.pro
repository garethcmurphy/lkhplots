
set_plot, 'x'
cgdisplay, xs=1200, ys=1200
for i=0,nlast do begin
pload,i , /silent
sbq=1.5
sbomega=1e-3
sbomega=1.0d
sba=-0.5*sbq*sbomega
vsh=2*sba

xx=rebin(reform(x1,nx1,  1,  1),nx1,nx2,nx3) 
yy=rebin(reform(x2,  1,nx2,  1),nx1,nx2,nx3) 
zz=rebin(reform(x3,  1,  1,nx3),nx1,nx2,nx3) 
vshear=vsh*xx

vx=vx1
vy=vx2-vshear
bx=bx1
by=bx2

vec1=bx1
vec2=bx2
qtag='histvxvybxby'

a=reform(vec1, long(nx1)*long(nx2)*long(nx3))
b=reform(vec2, long(nx1)*long(nx2)*long(nx3))
mn1a=min(vec1)
mx1a=max(vec1)
mn2a=min(vec2)
mx2a=max(vec2)
nsize=512
bn1a=(mx1a-mn1a)/(nsize)
bn2a=(mx2a-mn2a)/(nsize)

ca=sqrt(bx1^2+bx2^2+bx3^2)/rho
vec1=vx1 ;/ca
vec2=(vx2-vshear) ;/ca
c=reform(vec1, long(nx1)*long(nx2)*long(nx3)) 
d=reform(vec2, long(nx1)*long(nx2)*long(nx3))


mn1=double(-6e-7)	
mx1=double( 6e-7)	
mn2=double(-6e-7)	
mx2=double( 6e-7)	
;print, min(vec1)
mn1=min(vec1)
mx1=max(vec1)
mn2=min(vec2)
mx2=max(vec2)
bn1=(mx1-mn1)/nsize
bn2=(mx2-mn2)/nsize

cx=findgen(nsize+1)*bn1+mn1
cy=findgen(nsize+1)*bn2+mn2

velocity_hist = HIST_2D(c,d,MIN1=mn1, MAX1=mx1,  MIN2=mn2, MAX2=mx2, BIN1=bn1, BIN2=bn2)
magnetic_hist = HIST_2D(a,b,MIN1=mn1a, MAX1=mx1a,  MIN2=mn2a, MAX2=mx2a, BIN1=bn1a, BIN2=bn2a)
;Result = HIST_2D(reform(vec1,128L*128L*64L),reform(vec2,128L*128L*64L), MIN1=-6e-7, MAX1=6e-7,  MIN2=-6e-7, MAX2=6e-7, BIN1=4e-9, BIN2=4e-9)      
cgloadct,0, /reverse
;cgimage, alog10(result+1e-1)
print, i
print, size(result), size(cx), size(cy)

maxx=max([max(bx),max(vx)]) 
maxy=max([max(by),max(vy)]) 
minx=min([min(bx),min(vx)]) 
miny=min([min(by),min(vy)]) 


sz=size(magnetic_hist, /dimensions)
cx=findgen(sz(0))*bn1a+mn1a
cy=findgen(sz(1))*bn2a+mn2a

fname="plutohistvxvybxby"+string(i, format='(I04)')
for usingps=0,1 do begin

if ( usingps ) then begin
set_plot,'ps'
cgps_open, fname+'.eps', /encapsulated, /color, tt_font='Times', /nomatch, xsize=4, ysize=4;, /quiet
!p.charsize=0.9

endif else begin
!p.font=-1
!p.color=0
!p.charsize=1.8
legchar=0.6
;window, xs=1100,ys=800
;device, Set_Resolution=[1100,800]
if ( keyword_set(zbuf) ) then begin
set_plot, 'z'
device, set_resolution=[1300,1100], Decomposed=1, Set_Pixel_Depth=24
endif else begin
legchar=1.1
set_plot, 'x'
;window, xs=xs, ys=ys
legchar=0.6
endelse
endelse


smax=0.004
smax=10.
cgcontour, alog10(magnetic_hist+1e-3),cx,cy,  color='green',  $
		;title="Scatter plots of B!Dr,!9f!X!N and V!Dr,!9f!X!N at t="+string(i, format='(I2)')+" orbits", $
		xtitle="B!Dx!N, V!Dx!N",$
		ytitle="B!Dy!N, V!Dy!N",$
	   xrange=[-smax,smax], $
		yrange=[-smax,smax], $
		xstyle=1,$
		ystyle=1

sz=size(velocity_hist, /dimensions)
c1x=findgen(sz(0))*bn1+mn1
c1y=findgen(sz(1))*bn2+mn2
cgcontour, alog10(velocity_hist+1e-3), c1x,c1y, axiscolor='black' , /overplot, color='blue'

items=['V','B']
lines=[0,0]
color=[cgcolor('blue'),cgcolor('green')]

al_legend, items,linestyle=lines, colors=color
;cgplot, a,b, psym=1, $
;		title="Scatter plots of B!DX,Y!N and V!DX,Y!N at t="+string(i)+" orbits", $
;		xtitle="B!DX!N, V!DX!N",$
;		ytitle="B!DY!N, V!DY!N"
;cgplot,c,d,psym=1,/overplot, color='red'

;stop



if ( usingps ) then begin
cgps_close, /jpeg,  Width=2048
print, 'in ps'
set_plot, 'x'
endif else begin
print, 'in x'
endelse

endfor
endfor

end


;Result = HIST_2D(reform(vec1,128L*128L*64L),reform(vec2,128L*128L*64L), MIN1=-6e-7, MAX1=6e-7,  MIN2=-6e-7, MAX2=6e-7, BIN1=4e-9, BIN2=4e-9)      
;Result = HIST_2D(reform(vec1,128L*128L*64L),reform(vec2,128L*128L*64L), MIN1=-6e-7, MAX1=6e-7,  MIN2=-6e-7, MAX2=6e-7, BIN1=4e-9, BIN2=4e-9)      


