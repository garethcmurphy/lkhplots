
readcol, 'pqshear/alphaall.dat', q, alpha
readcol, 'nirvq/alphaall.dat', q1, alpha1
alphanorm=alpha[3]
alphanorm=alpha[8]
;alphanorm=alpha[10]
alphanorm=alpha[6]
alphanorm1=alpha1[10]
alpha=alpha/alphanorm

cgloadct,33
fname="alphaqforced"
cgdisplay, wid=3, xs=800, ys=600
for usingps=0,1 do begin
if (usingps eq 1) then begin
cgps_open, fname+'.eps', /encapsulated,  tt_font='Times', /quiet, font=1
omega_str='!9W!X'
endif else  begin
set_plot, 'x'
omega_str='!7X!X'
endelse


psym=[-16,-17,-18]

cgloadct,33
items=['Forced','Kato+ (1995)']
lines=[0,0,0]
colors=['blue', 'green']

cgplot, q1,alpha1/alphanorm1, xtitle='Shear rate, q= -dln!9W!X/dlnr', ytitle='Normalized Turbulent Stress, T!Dr!9f!X!N/P', psym=psym[0], linestyle=0, xrange=[0,2], color=colors[0], yrange=[-1,7], pos=[0.1,0.2,.95,.95]

;cgplot, q, alpha, /overplot, psym=psym[1], color=colors[1]
;cgplot, q,alpha,   linestyle=0, /overplot
qexp=4.5
mystr=string(qexp, format='(F4.1)')
cgplot, q1, (q1^8)/(1.5^8),     linestyle=lines[0],color=colors[1], /overplot, psym=psym[1]
;cgplot, q, (q^qexp)/(1.5^qexp), linestyle=lines[1],color=colors[1], /overplot
nitems=1
al_legend,  items[0:nitems], lines=lines[0:nitems], color=colors[0:nitems], linsize=0.05, psym=psym[0:nitems]
if ( usingps ) then begin
cgps_close, /jpeg,  Width=1100, /nomessage, delete_ps=0
endif else begin
e=1
endelse
endfor


cgloadct,0
READ_JPEG, fname+'.jpg', a, TRUE=1 & cgimage, a

end
