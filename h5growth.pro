pro h5growth, growtharr, idstr
 ;; add to hdf5 file

file = 'hdf5_outx.h5'
;FILE_DELETE,  file
fid = H5F_CREATE(file)

for i=0,5 do begin
;; create data
data = reform(growtharr[*,i])
;; get data type and space, needed to create the dataset
datatype_id = H5T_IDL_CREATE(data)
dataspace_id = H5S_CREATE_SIMPLE(size(data,/DIMENSIONS))
;; create dataset in the output file
dataset_id = H5D_CREATE(fid,$
idstr[i],datatype_id,dataspace_id)
;; write data to dataset
H5D_WRITE,dataset_id,data
;; close all open identifiers
H5D_CLOSE,dataset_id
H5S_CLOSE,dataspace_id
H5T_CLOSE,datatype_id
delvar,dataset_id
delvar,dataspace_id
delvar,datatype_id

endfor

H5F_CLOSE,fid


end
