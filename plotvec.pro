
pro plotvec, v1arr,v2arr,v3arr,b1arr,b2arr,b3arr, b3totarr, tnorm


CD, CURRENT=str & PRINT, str
dirpath=STRSPLIT(Str,'/',  /EXTRACT) 
 dirname=dirpath(size(dirpath, /dimensions)-1)


 titlstr='?D MRI + PI ?'
CASE dirname OF
   '2d_mri_pi_kx_ll_ky'	: titlstr='2D MRI + PI k!Dx!N << k!Dy!N'
	'2d_mri_pi_ky_0'		: titlstr='2D MRI + PI k!Dy!N = 0 '
	'3d_mri_pi_kx_ky'		: titlstr='3D MRI + PI k!Dx!N = k!Dy!N'
	'3d_mri_pi_ky_0'		: titlstr='3D MRI + PI k!Dy!N = 0'
	'3d_mri_wn_pi_wn'		: titlstr='3D MRI!DWN!N + PI !DWN!N =0 '
	'3d_mri_pi_wn'		: titlstr='3D MRI + PI!DWN!N =0 '
   ELSE: PRINT, 'Not one through four'
   ELSE: PRINT, 'Not one through four'
ENDCASE
 titlstr=' '



fname="growthrates"+dirname
for usingps=0,1 do begin
if ( usingps ) then begin
set_plot,'ps'
device,filename=fname+'.eps',/encapsulated
device, /color
!p.font=0
device, /times
;xs=12.-ar*6
;ys=6+ar*4
xsize=9
aspect_ratio=1.5 ;rectangle
device, xsize=xsize, ysize=xsize/aspect_ratio
!p.charsize=0.6
cbarchar=0.9
alchar=0.9
xyout=0.9
endif else begin
if ( keyword_set (zbuf) ) then begin
set_plot,'z'
ys=1200
xs=1800
!p.charsize=1.8
cbarchar=1.8
xyout=1.8
device, set_resolution=[xs,ys]
endif else begin
set_plot,'x'
!p.font=-1
!p.charsize=1.8
cbarchar=1.8
xyout=1.8
endelse
;device, set_resolution=[1100,800]
endelse



items=['v1','v2', 'v3', 'b1', 'b2', 'b3','growth=0.75' ]
linestyles=[0,0,0,3,2,2,1]
psym=[0,1,2,3,4,5,6]
colors=['red', 'blue', 'green', 'orange', 'turquoise', 'purple', 'black']

;device, set_font="-adobe-times-bold-r-normal--17-80-100-100-p-57-iso8859-14"
;device, set_font="
!p.thick=2

q2=5
q1=4
v1growthrate=(alog(b1arr[q2]) - alog(b1arr[q1]))/(tnorm[q2]-tnorm[q1])
v2growthrate=(alog(v2arr[q2]) - alog(v2arr[q1]))/(tnorm[q2]-tnorm[q1])
b1growthrate=(alog(b1arr[q2]) - alog(b1arr[q1]))/(tnorm[q2]-tnorm[q1])
b2growthrate=(alog(b2arr[q2]) - alog(b2arr[q1]))/(tnorm[q2]-tnorm[q1])


cgplot, tnorm, v1arr,  $
		/ylog, yrange=[1e-4,1e4], $
		title=titlstr +' , growth rate= ' + string(b1growthrate, format='(F8.5)'),$
		xtitle="Time, t [orbits]",$
		xstyle=1, $
		color=colors[0], linestyle=linestyles[0]


	cgplot, tnorm, v2arr, /overplot, color=colors[1], linestyle=linestyles[1]
	cgplot, tnorm, v3arr, /overplot, color=colors[2], linestyle=linestyles[2]
	cgplot, tnorm, b1arr, /overplot, color=colors[3], linestyle=linestyles[3]
	cgplot, tnorm, b2arr, /overplot, color=colors[4], linestyle=linestyles[4]
	cgplot, tnorm, b3arr, /overplot, color=colors[5], linestyle=linestyles[5]
	cgplot, tnorm, b3totarr, /overplot, color=colors[5], linestyle=linestyles[5]

	
	cgplot, tnorm, 0.2*exp(0.75*tnorm), /overplot, color=colors[6], linestyle=linestyles[6]

	al_legend, items, colors=colors, linestyle=linestyles


print,'v1 growth', v1growthrate
print,'v2 growth',  v2growthrate
print,'b1 growth',  b1growthrate
print,'b2 growth',  b2growthrate

if ( usingps ) then begin
device,/close
set_plot,'x'
endif else begin
;set_plot,'x'
fname2=fname
im=cgsnapshot(filename=fname2,/nodialog,/jpeg)
endelse



endfor

	end
