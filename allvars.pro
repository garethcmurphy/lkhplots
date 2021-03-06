
!p.charsize=2
!p.position=0
nx = f.s.gn[0]
nz = f.s.gn[2]
slice= f.s.gn[1]/2

bx=reform(f.bx[*,slice,*],nx,nz)
by=reform(f.by[*,slice,*],nx,nz)
bz=reform(f.bz[*,slice,*],nx,nz)
ex=reform(f.ex[*,slice,*],nx,nz)
ey=reform(f.ey[*,slice,*],nx,nz)
ez=reform(f.ez[*,slice,*],nx,nz)
vix=reform(f.v[*,slice,*,0,1],nx,nz)
viy=reform(f.v[*,slice,*,1,1],nx,nz)
viz=reform(f.v[*,slice,*,2,1],nx,nz)
vex=reform(f.v[*,slice,*,0,0],nx,nz)
vey=reform(f.v[*,slice,*,1,0],nx,nz)
vez=reform(f.v[*,slice,*,2,0],nx,nz)


loadct,0
window, xs=1100,ys=1300
;!p.multi=[0,3,4]
!x.style=1
!y.style=1
loadct,33
tvlct, 0,0,0,0
tvlct, 255,255,255,1

!p.background=1

xx=findgen(nx)
yy=findgen(nz)

p1 = !P & x1 = !X & y1 = !Y

dataptr=ptrarr(12)

dataptr[0]=ptr_new(vix)
dataptr[1]=ptr_new(viz)
dataptr[2]=ptr_new(viy)
dataptr[3]=ptr_new(vex)
dataptr[4]=ptr_new(vez)
dataptr[5]=ptr_new(vey)
dataptr[6]=ptr_new(bx)
dataptr[7]=ptr_new(by)
dataptr[8]=ptr_new(bz)
dataptr[9]=ptr_new(ex)
dataptr[10]=ptr_new(ey)
dataptr[11]=ptr_new(ez)

pos=[0.2,0.1,0.9,0.9]

titlestr=strarr(12,30)
titlestr[0,*,*]='vix'
titlestr[1,*]='viy'
titlestr[2,*]='viz'
titlestr[3,*]='vex'
titlestr[4,*]='vey'
titlestr[5,*]='vez'
titlestr[6,*]='bx'
titlestr[7,*]='by'
titlestr[8,*]='bz'
titlestr[9,*]='ex'
titlestr[10,*]='ey'
titlestr[11,*]='ez'



sz=size(bx, /dimensions)
nx=sz(0)
ny=sz(1)

xx=findgen(nx)
yy=findgen(ny)

time=f.s.time

   cgDisplay, WID=1,xs=1100, ys=1100
   cgLoadCT, 22, /Brewer, /Reverse
   pos = cglayout([3,4] , OXMargin=[5,5], OYMargin=[5,12], XGap=3, YGap=7)
   FOR j=0,11 DO BEGIN
     p = pos[*,j]
	r=scale_vector( *dataptr(j), 1,254)
	imin=min(*dataptr[j])
	imax=max(*dataptr[j])
     cgImage, r, NoErase=j NE 0, Position=p
  cgcontour,xx#yy, xx,yy , /nodata, /noerase, xtitle='x', pos=p, title=titlestr(j), Charsize=cgDefCharsize()*0.5
     cgColorBar, position=[p[0], p[1]-0.03, p[2], p[1]-0.02],range=[imin-1e-6,imax+1e-6], Charsize=cgDefCharsize()*0.5
   ENDFOR
   cgText, 0.5, 0.96, /Normal,  'time='+string(time), Alignment=0.5, Charsize=cgDefCharsize()*1.25

end

