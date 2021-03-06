SetWindowLayout(9)
import math
#OpenDatabase("mri3d.vtk")
OpenDatabase("localhost:./data.*.vtk database", 0)
DefineScalarExpression("v0", "0*(3D_Velocity_Field[1])")
OpenDatabase("localhost:./data.*.vtk database", 2)

pi=3.141592
theta=-pi/4.0
sliceq1 = math.cos(theta)
sliceq2 = math.sin(theta)
DefineScalarExpression("pi", "3.141592")
DefineScalarExpression("theta", "pi/4.0")

DefineScalarExpression("x", "coord(mesh)[0]")
DefineScalarExpression("y", "coord(mesh)[1]")
DefineScalarExpression("z", "coord(mesh)[2]")
DefineVectorExpression("velocity", "{u,v,w}")
DefineScalarExpression("sbq", "1.5")
DefineScalarExpression("sbomega", "1e-3")
DefineScalarExpression("sba", "-0.5*sbq*sbomega")
DefineScalarExpression("vsh", "2.0*sba")
DefineScalarExpression("vshear", "vsh*x")
DefineScalarExpression("vmri", "sin(pi*z)")
# simulation initial condition variables
DefineScalarExpression("u", "sin(pi*z)")
DefineScalarExpression("v", "sin(pi*z)")
DefineScalarExpression("w", "sin(pi*x)+sin(pi*y)")
DefineScalarExpression("u", "3D_Velocity_Field[0]")
DefineScalarExpression("v", "(3D_Velocity_Field[1]-vshear)")
DefineScalarExpression("w", "3D_Velocity_Field[2]")
# test variables
#DefineScalarExpression("u", "-cos(pi*z)*sin(pi*x)")
#DefineScalarExpression("v", "0*sin(pi*z)*cos(pi*x)")
#DefineScalarExpression("w", "sin(pi*z)*cos(pi*x)")
#DefineScalarExpression("v", "vshear")

DefineScalarExpression("vel_mag", "magnitude(velocity)")
DefineVectorExpression("curlv", "curl(velocity)")
DefineScalarExpression("curlvx", "curlv[0]")
DefineScalarExpression("curlvy", "curlv[1]")
DefineScalarExpression("curlvz", "curlv[2]")
DefineScalarExpression("phi", "pi/2.0")
# Project veloicty into plane, u,v with theta
# project vorticity into plane omegax + omegay dotted with kx ky
DefineScalarExpression("cos_theta", "cos(theta)*point_constant(mesh, 1.)")
DefineScalarExpression("sin_theta", "sin(theta)*point_constant(mesh, 1.)")
DefineScalarExpression("kz", "0*point_constant(mesh, 1.)")
DefineVectorExpression("kh", "{cos_theta,sin_theta,kz}")
DefineVectorExpression("kperp", "{-sin_theta,cos_theta,kz}")
DefineScalarExpression("vortproj", "dot(curlv,kperp)")
DefineScalarExpression("uhp", "dot(velocity,kh)")
DefineScalarExpression("vhp", "dot(velocity,kperp)")
DefineVectorExpression("velproj", "{uhp,vhp,w}")


SliceAtts = SliceAttributes()
SliceAtts.originType = SliceAtts.Point  # Point, Intercept, Percent, Zone, Node
SliceAtts.originPoint = (1, 1, 1)
SliceAtts.originIntercept = 0
SliceAtts.originPercent = 0
SliceAtts.originZone = 0
SliceAtts.originNode = 0
SliceAtts.normal = (sliceq1,sliceq2 , 0)
SliceAtts.axisType = SliceAtts.Arbitrary  # XAxis, YAxis, ZAxis, Arbitrary, ThetaPhi
SliceAtts.upAxis = (0, 0, 1)
SliceAtts.project2d = 0
SliceAtts.interactive = 1
SliceAtts.flip = 0
SliceAtts.originZoneDomain = 0
SliceAtts.originNodeDomain = 0
SliceAtts.meshName = "mesh"
SliceAtts.theta = 0
SliceAtts.phi = 0
SetOperatorOptions(SliceAtts, 1)


# Begin spontaneous state
View3DAtts = View3DAttributes()
View3DAtts.viewNormal = (0.596332, -0.781887, 0.181771)
View3DAtts.focus = (1, 1, 1)
View3DAtts.viewUp = (-0.145957, 0.117053, 0.982342)
View3DAtts.viewAngle = 30
View3DAtts.parallelScale = 1.73205
View3DAtts.nearPlane = -3.4641
View3DAtts.farPlane = 3.4641
View3DAtts.imagePan = (0, 0)
View3DAtts.imageZoom = 1
View3DAtts.perspective = 1
View3DAtts.eyeAngle = 2
View3DAtts.centerOfRotationSet = 0
View3DAtts.centerOfRotation = (1, 1, 1)
View3DAtts.axis3DScaleFlag = 0
View3DAtts.axis3DScales = (1, 1, 1)
View3DAtts.shear = (0, 0, 1)
SetView3D(View3DAtts)
# End spontaneous state


SetActiveWindow(1)
text = CreateAnnotationObject("Text2D")
text.visible = 1
text.active = 1
text.position = (0.2, 0.88)
#text.width = 0.25
text.textColor = (0, 0, 0, 255)
text.useForegroundForTextColor = 1
text.text = "vx"
text.fontFamily = text.Times  # Arial, Courier, Times
text.fontBold = 0
text.fontItalic = 0
text.fontShadow = 0
AnnotationAtts = AnnotationAttributes()
AnnotationAtts.databaseInfoFlag = 0
AnnotationAtts.userInfoFlag = 0
SetAnnotationAttributes(AnnotationAtts)
theta=0.0
sliceq1 = math.cos(theta)
sliceq2 = math.sin(theta)
DefineScalarExpression("pi", "3.141592")
DefineScalarExpression("theta", "0.0")

DefineScalarExpression("x", "coord(mesh)[0]")
DefineScalarExpression("y", "coord(mesh)[1]")
DefineScalarExpression("z", "coord(mesh)[2]")
DefineVectorExpression("velocity", "{u,v,w}")
DefineScalarExpression("sbq", "1.5")
DefineScalarExpression("sbomega", "1e-3")
DefineScalarExpression("sba", "-0.5*sbq*sbomega")
DefineScalarExpression("vsh", "2.0*sba")
DefineScalarExpression("vshear", "vsh*x")
DefineScalarExpression("vmri", "sin(pi*z)")
# simulation initial condition variables
DefineScalarExpression("u", "sin(pi*z)")
DefineScalarExpression("v", "sin(pi*z)")
DefineScalarExpression("w", "sin(pi*x)+sin(pi*y)")
DefineScalarExpression("u", "3D_Velocity_Field[0]")
DefineScalarExpression("v", "(3D_Velocity_Field[1]-vshear)")
DefineScalarExpression("w", "3D_Velocity_Field[2]")
# test variables
#DefineScalarExpression("u", "-cos(pi*z)*sin(pi*x)")
#DefineScalarExpression("v", "0*sin(pi*z)*cos(pi*x)")
#DefineScalarExpression("w", "sin(pi*z)*cos(pi*x)")
#DefineScalarExpression("v", "vshear")
DefineScalarExpression("cos_theta", "cos(theta)*point_constant(mesh, 1.)")
DefineScalarExpression("sin_theta", "sin(theta)*point_constant(mesh, 1.)")
DefineScalarExpression("kz", "0*point_constant(mesh, 1.)")
DefineVectorExpression("kh", "{cos_theta,sin_theta,kz}")
DefineVectorExpression("kperp", "{-sin_theta,cos_theta,kz}")
DefineScalarExpression("vortproj", "dot(curlv,kperp)")
DefineScalarExpression("uhp", "dot(velocity,kh)")
DefineScalarExpression("vhp", "dot(velocity,kperp)")
DefineVectorExpression("velproj", "{uhp,vhp,w}")
AddPlot("Pseudocolor", "vortproj", 1, 1)
AddOperator("Slice", 1)
SliceAtts.normal = (1, 1, 0)
SliceAtts.normal = (sliceq1,sliceq2 , 0)
SliceAtts.originPoint = (1, 1, 1)
SliceAtts.project2d = 0
SetOperatorOptions(SliceAtts, 1)
DrawPlots()
ToggleLockViewMode()
ToggleLockTime()

AddPlot("Vector", "velproj", 1, 1)
VectorAtts = VectorAttributes()
VectorAtts.glyphLocation = VectorAtts.AdaptsToMeshResolution  # AdaptsToMeshResolution, UniformInSpace
VectorAtts.useStride = 0
VectorAtts.stride = 1
VectorAtts.nVectors = 400
VectorAtts.lineStyle = VectorAtts.SOLID  # SOLID, DASH, DOT, DOTDASH
VectorAtts.lineWidth = 0
VectorAtts.scale = 0.25
VectorAtts.scaleByMagnitude = 1
VectorAtts.autoScale = 1
VectorAtts.headSize = 0.25
VectorAtts.headOn = 1
VectorAtts.colorByMag = 1
VectorAtts.useLegend = 1
VectorAtts.vectorColor = (0, 0, 0, 255)
VectorAtts.colorTableName = "Default"
VectorAtts.invertColorTable = 0
VectorAtts.vectorOrigin = VectorAtts.Tail  # Head, Middle, Tail
VectorAtts.minFlag = 0
VectorAtts.maxFlag = 0
VectorAtts.limitsMode = VectorAtts.OriginalData  # OriginalData, CurrentPlot
VectorAtts.min = 0
VectorAtts.max = 1
VectorAtts.lineStem = 1
VectorAtts.geometryQuality = VectorAtts.Fast  # Fast, High
VectorAtts.stemWidth = 0.08
VectorAtts.origOnly = 1
VectorAtts.glyphType = VectorAtts.Arrow  # Arrow, Ellipsoid
VectorAtts.nVectors = 400
SetPlotOptions(VectorAtts)
#AddOperator("Slice", 1)
DrawPlots()


SetActiveWindow(2)
text = CreateAnnotationObject("Text2D")
text.visible = 1
text.active = 1
text.position = (0.2, 0.88)
#text.width = 0.25
text.textColor = (0, 0, 0, 255)
text.useForegroundForTextColor = 1
text.text = "vy"
text.fontFamily = text.Times  # Arial, Courier, Times
text.fontBold = 0
text.fontItalic = 0
text.fontShadow = 0
AnnotationAtts = AnnotationAttributes()
AnnotationAtts.databaseInfoFlag = 0
AnnotationAtts.userInfoFlag = 0
SetAnnotationAttributes(AnnotationAtts)
#set2
theta=-pi/6.0
sliceq1 = math.cos(theta)
sliceq2 = math.sin(theta)
DefineScalarExpression("pi", "3.141592")
DefineScalarExpression("theta", "pi/6.0")

DefineScalarExpression("x", "coord(mesh)[0]")
DefineScalarExpression("y", "coord(mesh)[1]")
DefineScalarExpression("z", "coord(mesh)[2]")
DefineVectorExpression("velocity", "{u,v,w}")
DefineScalarExpression("sbq", "1.5")
DefineScalarExpression("sbomega", "1e-3")
DefineScalarExpression("sba", "-0.5*sbq*sbomega")
DefineScalarExpression("vsh", "2.0*sba")
DefineScalarExpression("vshear", "vsh*x")
DefineScalarExpression("vmri", "sin(pi*z)")
# simulation initial condition variables
DefineScalarExpression("u", "sin(pi*z)")
DefineScalarExpression("v", "sin(pi*z)")
DefineScalarExpression("w", "sin(pi*x)+sin(pi*y)")
DefineScalarExpression("u", "3D_Velocity_Field[0]")
DefineScalarExpression("v", "(3D_Velocity_Field[1]-vshear)")
DefineScalarExpression("w", "3D_Velocity_Field[2]")
# test variables
#DefineScalarExpression("u", "-cos(pi*z)*sin(pi*x)")
#DefineScalarExpression("v", "0*sin(pi*z)*cos(pi*x)")
#DefineScalarExpression("w", "sin(pi*z)*cos(pi*x)")
#DefineScalarExpression("v", "vshear")
DefineScalarExpression("cos_theta", "cos(theta)*point_constant(mesh, 1.)")
DefineScalarExpression("sin_theta", "sin(theta)*point_constant(mesh, 1.)")
DefineScalarExpression("kz", "0*point_constant(mesh, 1.)")
DefineVectorExpression("kh", "{cos_theta,sin_theta,kz}")
DefineVectorExpression("kperp", "{-sin_theta,cos_theta,kz}")
DefineScalarExpression("vortproj", "dot(curlv,kperp)")
DefineScalarExpression("uhp", "dot(velocity,kh)")
DefineScalarExpression("vhp", "dot(velocity,kperp)")
DefineVectorExpression("velproj", "{uhp,vhp,w}")
AddPlot("Pseudocolor", "vortproj", 1, 1)
AddOperator("Slice", 1)
SliceAtts.normal = (1, 1, 0)
SliceAtts.normal = (sliceq1,sliceq2 , 0)
SliceAtts.originPoint = (1, 1, 1)
SliceAtts.project2d = 0
SetOperatorOptions(SliceAtts, 1)
DrawPlots()
ToggleLockViewMode()
ToggleLockTime()

AddPlot("Vector", "velproj", 1, 1)
VectorAtts = VectorAttributes()
VectorAtts.glyphLocation = VectorAtts.AdaptsToMeshResolution  # AdaptsToMeshResolution, UniformInSpace
VectorAtts.useStride = 0
VectorAtts.stride = 1
VectorAtts.nVectors = 400
VectorAtts.lineStyle = VectorAtts.SOLID  # SOLID, DASH, DOT, DOTDASH
VectorAtts.lineWidth = 0
VectorAtts.scale = 0.25
VectorAtts.scaleByMagnitude = 1
VectorAtts.autoScale = 1
VectorAtts.headSize = 0.25
VectorAtts.headOn = 1
VectorAtts.colorByMag = 1
VectorAtts.useLegend = 1
VectorAtts.vectorColor = (0, 0, 0, 255)
VectorAtts.colorTableName = "Default"
VectorAtts.invertColorTable = 0
VectorAtts.vectorOrigin = VectorAtts.Tail  # Head, Middle, Tail
VectorAtts.minFlag = 0
VectorAtts.maxFlag = 0
VectorAtts.limitsMode = VectorAtts.OriginalData  # OriginalData, CurrentPlot
VectorAtts.min = 0
VectorAtts.max = 1
VectorAtts.lineStem = 1
VectorAtts.geometryQuality = VectorAtts.Fast  # Fast, High
VectorAtts.stemWidth = 0.08
VectorAtts.origOnly = 1
VectorAtts.glyphType = VectorAtts.Arrow  # Arrow, Ellipsoid
VectorAtts.nVectors = 400
SetPlotOptions(VectorAtts)
#AddOperator("Slice", 1)
DrawPlots()

SetActiveWindow(3)
text = CreateAnnotationObject("Text2D")
text.visible = 1
text.active = 1
text.position = (0.2, 0.88)
#text.width = 0.25
text.textColor = (0, 0, 0, 255)
text.useForegroundForTextColor = 1
text.text = "vz"
text.fontFamily = text.Times  # Arial, Courier, Times
text.fontBold = 0
text.fontItalic = 0
text.fontShadow = 0
AnnotationAtts = AnnotationAttributes()
AnnotationAtts.databaseInfoFlag = 0
AnnotationAtts.userInfoFlag = 0
SetAnnotationAttributes(AnnotationAtts)
#set3
theta=-pi/5.0
sliceq1 = math.cos(theta)
sliceq2 = math.sin(theta)
DefineScalarExpression("pi", "3.141592")
DefineScalarExpression("theta", "pi/5.0")

DefineScalarExpression("x", "coord(mesh)[0]")
DefineScalarExpression("y", "coord(mesh)[1]")
DefineScalarExpression("z", "coord(mesh)[2]")
DefineVectorExpression("velocity", "{u,v,w}")
DefineScalarExpression("sbq", "1.5")
DefineScalarExpression("sbomega", "1e-3")
DefineScalarExpression("sba", "-0.5*sbq*sbomega")
DefineScalarExpression("vsh", "2.0*sba")
DefineScalarExpression("vshear", "vsh*x")
DefineScalarExpression("vmri", "sin(pi*z)")
# simulation initial condition variables
DefineScalarExpression("u", "sin(pi*z)")
DefineScalarExpression("v", "sin(pi*z)")
DefineScalarExpression("w", "sin(pi*x)+sin(pi*y)")
DefineScalarExpression("u", "3D_Velocity_Field[0]")
DefineScalarExpression("v", "(3D_Velocity_Field[1]-vshear)")
DefineScalarExpression("w", "3D_Velocity_Field[2]")
# test variables
#DefineScalarExpression("u", "-cos(pi*z)*sin(pi*x)")
#DefineScalarExpression("v", "0*sin(pi*z)*cos(pi*x)")
#DefineScalarExpression("w", "sin(pi*z)*cos(pi*x)")
#DefineScalarExpression("v", "vshear")
DefineScalarExpression("cos_theta", "cos(theta)*point_constant(mesh, 1.)")
DefineScalarExpression("sin_theta", "sin(theta)*point_constant(mesh, 1.)")
DefineScalarExpression("kz", "0*point_constant(mesh, 1.)")
DefineVectorExpression("kh", "{cos_theta,sin_theta,kz}")
DefineVectorExpression("kperp", "{-sin_theta,cos_theta,kz}")
DefineScalarExpression("vortproj", "dot(curlv,kperp)")
DefineScalarExpression("uhp", "dot(velocity,kh)")
DefineScalarExpression("vhp", "dot(velocity,kperp)")
DefineVectorExpression("velproj", "{uhp,vhp,w}")
AddPlot("Pseudocolor", "vortproj", 1, 1)
AddOperator("Slice", 1)
SliceAtts.normal = (1, 1, 0)
SliceAtts.normal = (sliceq1,sliceq2 , 0)
SliceAtts.originPoint = (1, 1, 1)
SliceAtts.project2d = 0
SetOperatorOptions(SliceAtts, 1)
DrawPlots()
ToggleLockViewMode()
ToggleLockTime()

AddPlot("Vector", "velproj", 1, 1)
VectorAtts = VectorAttributes()
VectorAtts.glyphLocation = VectorAtts.AdaptsToMeshResolution  # AdaptsToMeshResolution, UniformInSpace
VectorAtts.useStride = 0
VectorAtts.stride = 1
VectorAtts.nVectors = 400
VectorAtts.lineStyle = VectorAtts.SOLID  # SOLID, DASH, DOT, DOTDASH
VectorAtts.lineWidth = 0
VectorAtts.scale = 0.25
VectorAtts.scaleByMagnitude = 1
VectorAtts.autoScale = 1
VectorAtts.headSize = 0.25
VectorAtts.headOn = 1
VectorAtts.colorByMag = 1
VectorAtts.useLegend = 1
VectorAtts.vectorColor = (0, 0, 0, 255)
VectorAtts.colorTableName = "Default"
VectorAtts.invertColorTable = 0
VectorAtts.vectorOrigin = VectorAtts.Tail  # Head, Middle, Tail
VectorAtts.minFlag = 0
VectorAtts.maxFlag = 0
VectorAtts.limitsMode = VectorAtts.OriginalData  # OriginalData, CurrentPlot
VectorAtts.min = 0
VectorAtts.max = 1
VectorAtts.lineStem = 1
VectorAtts.geometryQuality = VectorAtts.Fast  # Fast, High
VectorAtts.stemWidth = 0.08
VectorAtts.origOnly = 1
VectorAtts.glyphType = VectorAtts.Arrow  # Arrow, Ellipsoid
VectorAtts.nVectors = 400
SetPlotOptions(VectorAtts)
#AddOperator("Slice", 1)
DrawPlots()

SetActiveWindow(4)
text = CreateAnnotationObject("Text2D")
text.visible = 1
text.active = 1
text.position = (0.2, 0.88)
#text.width = 0.25
text.textColor = (0, 0, 0, 255)
text.useForegroundForTextColor = 1
text.text = "vortx"
text.fontFamily = text.Times  # Arial, Courier, Times
text.fontBold = 0
text.fontItalic = 0
text.fontShadow = 0
AnnotationAtts = AnnotationAttributes()
AnnotationAtts.databaseInfoFlag = 0
AnnotationAtts.userInfoFlag = 0
SetAnnotationAttributes(AnnotationAtts)
#set4
theta=-pi/4.5
sliceq1 = math.cos(theta)
sliceq2 = math.sin(theta)
DefineScalarExpression("pi", "3.141592")
DefineScalarExpression("theta", "pi/4.5")

DefineScalarExpression("x", "coord(mesh)[0]")
DefineScalarExpression("y", "coord(mesh)[1]")
DefineScalarExpression("z", "coord(mesh)[2]")
DefineVectorExpression("velocity", "{u,v,w}")
DefineScalarExpression("sbq", "1.5")
DefineScalarExpression("sbomega", "1e-3")
DefineScalarExpression("sba", "-0.5*sbq*sbomega")
DefineScalarExpression("vsh", "2.0*sba")
DefineScalarExpression("vshear", "vsh*x")
DefineScalarExpression("vmri", "sin(pi*z)")
# simulation initial condition variables
DefineScalarExpression("u", "sin(pi*z)")
DefineScalarExpression("v", "sin(pi*z)")
DefineScalarExpression("w", "sin(pi*x)+sin(pi*y)")
DefineScalarExpression("u", "3D_Velocity_Field[0]")
DefineScalarExpression("v", "(3D_Velocity_Field[1]-vshear)")
DefineScalarExpression("w", "3D_Velocity_Field[2]")
# test variables
#DefineScalarExpression("u", "-cos(pi*z)*sin(pi*x)")
#DefineScalarExpression("v", "0*sin(pi*z)*cos(pi*x)")
#DefineScalarExpression("w", "sin(pi*z)*cos(pi*x)")
#DefineScalarExpression("v", "vshear")
DefineScalarExpression("cos_theta", "cos(theta)*point_constant(mesh, 1.)")
DefineScalarExpression("sin_theta", "sin(theta)*point_constant(mesh, 1.)")
DefineScalarExpression("kz", "0*point_constant(mesh, 1.)")
DefineVectorExpression("kh", "{cos_theta,sin_theta,kz}")
DefineVectorExpression("kperp", "{-sin_theta,cos_theta,kz}")
DefineScalarExpression("vortproj", "dot(curlv,kperp)")
DefineScalarExpression("uhp", "dot(velocity,kh)")
DefineScalarExpression("vhp", "dot(velocity,kperp)")
DefineVectorExpression("velproj", "{uhp,vhp,w}")
AddPlot("Pseudocolor", "vortproj", 1, 1)
AddOperator("Slice", 1)
SliceAtts.normal = (1, 1, 0)
SliceAtts.normal = (sliceq1,sliceq2 , 0)
SliceAtts.originPoint = (1, 1, 1)
SliceAtts.project2d = 0
SetOperatorOptions(SliceAtts, 1)
DrawPlots()
ToggleLockViewMode()
ToggleLockTime()

AddPlot("Vector", "velproj", 1, 1)
VectorAtts = VectorAttributes()
VectorAtts.glyphLocation = VectorAtts.AdaptsToMeshResolution  # AdaptsToMeshResolution, UniformInSpace
VectorAtts.useStride = 0
VectorAtts.stride = 1
VectorAtts.nVectors = 400
VectorAtts.lineStyle = VectorAtts.SOLID  # SOLID, DASH, DOT, DOTDASH
VectorAtts.lineWidth = 0
VectorAtts.scale = 0.25
VectorAtts.scaleByMagnitude = 1
VectorAtts.autoScale = 1
VectorAtts.headSize = 0.25
VectorAtts.headOn = 1
VectorAtts.colorByMag = 1
VectorAtts.useLegend = 1
VectorAtts.vectorColor = (0, 0, 0, 255)
VectorAtts.colorTableName = "Default"
VectorAtts.invertColorTable = 0
VectorAtts.vectorOrigin = VectorAtts.Tail  # Head, Middle, Tail
VectorAtts.minFlag = 0
VectorAtts.maxFlag = 0
VectorAtts.limitsMode = VectorAtts.OriginalData  # OriginalData, CurrentPlot
VectorAtts.min = 0
VectorAtts.max = 1
VectorAtts.lineStem = 1
VectorAtts.geometryQuality = VectorAtts.Fast  # Fast, High
VectorAtts.stemWidth = 0.08
VectorAtts.origOnly = 1
VectorAtts.glyphType = VectorAtts.Arrow  # Arrow, Ellipsoid
VectorAtts.nVectors = 400
SetPlotOptions(VectorAtts)
#AddOperator("Slice", 1)
DrawPlots()

SetActiveWindow(5)
text = CreateAnnotationObject("Text2D")
text.visible = 1
text.active = 1
text.position = (0.2, 0.88)
#text.width = 0.25
text.textColor = (0, 0, 0, 255)
text.useForegroundForTextColor = 1
text.text = "vorty"
text.fontFamily = text.Times  # Arial, Courier, Times
text.fontBold = 0
text.fontItalic = 0
text.fontShadow = 0
AnnotationAtts = AnnotationAttributes()
AnnotationAtts.databaseInfoFlag = 0
AnnotationAtts.userInfoFlag = 0
SetAnnotationAttributes(AnnotationAtts)

SetActiveWindow(6)
text = CreateAnnotationObject("Text2D")
text.visible = 1
text.active = 1
text.position = (0.2, 0.88)
#text.width = 0.25
text.textColor = (0, 0, 0, 255)
text.useForegroundForTextColor = 1
text.text = "vortz"
text.fontFamily = text.Times  # Arial, Courier, Times
text.fontBold = 0
text.fontItalic = 0
text.fontShadow = 0
AnnotationAtts = AnnotationAttributes()
AnnotationAtts.databaseInfoFlag = 0
AnnotationAtts.userInfoFlag = 0
SetAnnotationAttributes(AnnotationAtts)
#set5
theta=-pi/4.0
sliceq1 = math.cos(theta)
sliceq2 = math.sin(theta)
DefineScalarExpression("pi", "3.141592")
DefineScalarExpression("theta", "pi/4.0")

DefineScalarExpression("x", "coord(mesh)[0]")
DefineScalarExpression("y", "coord(mesh)[1]")
DefineScalarExpression("z", "coord(mesh)[2]")
DefineVectorExpression("velocity", "{u,v,w}")
DefineScalarExpression("sbq", "1.5")
DefineScalarExpression("sbomega", "1e-3")
DefineScalarExpression("sba", "-0.5*sbq*sbomega")
DefineScalarExpression("vsh", "2.0*sba")
DefineScalarExpression("vshear", "vsh*x")
DefineScalarExpression("vmri", "sin(pi*z)")
# simulation initial condition variables
DefineScalarExpression("u", "sin(pi*z)")
DefineScalarExpression("v", "sin(pi*z)")
DefineScalarExpression("w", "sin(pi*x)+sin(pi*y)")
DefineScalarExpression("u", "3D_Velocity_Field[0]")
DefineScalarExpression("v", "(3D_Velocity_Field[1]-vshear)")
DefineScalarExpression("w", "3D_Velocity_Field[2]")
# test variables
#DefineScalarExpression("u", "-cos(pi*z)*sin(pi*x)")
#DefineScalarExpression("v", "0*sin(pi*z)*cos(pi*x)")
#DefineScalarExpression("w", "sin(pi*z)*cos(pi*x)")
#DefineScalarExpression("v", "vshear")
DefineScalarExpression("cos_theta", "cos(theta)*point_constant(mesh, 1.)")
DefineScalarExpression("sin_theta", "sin(theta)*point_constant(mesh, 1.)")
DefineScalarExpression("kz", "0*point_constant(mesh, 1.)")
DefineVectorExpression("kh", "{cos_theta,sin_theta,kz}")
DefineVectorExpression("kperp", "{-sin_theta,cos_theta,kz}")
DefineScalarExpression("vortproj", "dot(curlv,kperp)")
DefineScalarExpression("uhp", "dot(velocity,kh)")
DefineScalarExpression("vhp", "dot(velocity,kperp)")
DefineVectorExpression("velproj", "{uhp,vhp,w}")
AddPlot("Pseudocolor", "vortproj", 1, 1)
AddOperator("Slice", 1)
SliceAtts.normal = (1, 1, 0)
SliceAtts.normal = (sliceq1,sliceq2 , 0)
SliceAtts.originPoint = (1, 1, 1)
SliceAtts.project2d = 0
SetOperatorOptions(SliceAtts, 1)
DrawPlots()
ToggleLockViewMode()
ToggleLockTime()

AddPlot("Vector", "velproj", 1, 1)
VectorAtts = VectorAttributes()
VectorAtts.glyphLocation = VectorAtts.AdaptsToMeshResolution  # AdaptsToMeshResolution, UniformInSpace
VectorAtts.useStride = 0
VectorAtts.stride = 1
VectorAtts.nVectors = 400
VectorAtts.lineStyle = VectorAtts.SOLID  # SOLID, DASH, DOT, DOTDASH
VectorAtts.lineWidth = 0
VectorAtts.scale = 0.25
VectorAtts.scaleByMagnitude = 1
VectorAtts.autoScale = 1
VectorAtts.headSize = 0.25
VectorAtts.headOn = 1
VectorAtts.colorByMag = 1
VectorAtts.useLegend = 1
VectorAtts.vectorColor = (0, 0, 0, 255)
VectorAtts.colorTableName = "Default"
VectorAtts.invertColorTable = 0
VectorAtts.vectorOrigin = VectorAtts.Tail  # Head, Middle, Tail
VectorAtts.minFlag = 0
VectorAtts.maxFlag = 0
VectorAtts.limitsMode = VectorAtts.OriginalData  # OriginalData, CurrentPlot
VectorAtts.min = 0
VectorAtts.max = 1
VectorAtts.lineStem = 1
VectorAtts.geometryQuality = VectorAtts.Fast  # Fast, High
VectorAtts.stemWidth = 0.08
VectorAtts.origOnly = 1
VectorAtts.glyphType = VectorAtts.Arrow  # Arrow, Ellipsoid
VectorAtts.nVectors = 400
SetPlotOptions(VectorAtts)
#AddOperator("Slice", 1)
DrawPlots()


SetActiveWindow(7)
text = CreateAnnotationObject("Text2D")
text.visible = 1
text.active = 1
text.position = (0.2, 0.88)
#text.width = 0.25
text.textColor = (0, 0, 0, 255)
text.useForegroundForTextColor = 1
text.text = "kh"
text.fontFamily = text.Times  # Arial, Courier, Times
text.fontBold = 0
text.fontItalic = 0
text.fontShadow = 0
AnnotationAtts = AnnotationAttributes()
AnnotationAtts.databaseInfoFlag = 0
AnnotationAtts.userInfoFlag = 0
SetAnnotationAttributes(AnnotationAtts)


SetActiveWindow(8)
text = CreateAnnotationObject("Text2D")
text.visible = 1
text.active = 1
text.position = (0.2, 0.88)
#text.width = 0.25
text.textColor = (0, 0, 0, 255)
text.useForegroundForTextColor = 1
text.text = "vortproj"
text.fontFamily = text.Times  # Arial, Courier, Times
text.fontBold = 0
text.fontItalic = 0
text.fontShadow = 0
AnnotationAtts = AnnotationAttributes()
AnnotationAtts.databaseInfoFlag = 0
AnnotationAtts.userInfoFlag = 0
SetAnnotationAttributes(AnnotationAtts)
AddPlot("Pseudocolor", "vortproj", 1, 1)
AddOperator("Slice", 1)
SliceAtts.normal = (1, 1, 0)
SliceAtts.normal = (sliceq1,sliceq2 , 0)
SliceAtts.originPoint = (1, 1, 1)
SliceAtts.project2d = 0
SetOperatorOptions(SliceAtts, 1)
DrawPlots()
ToggleLockViewMode()
ToggleLockTime()

AddPlot("Vector", "velproj", 1, 1)
VectorAtts = VectorAttributes()
VectorAtts.glyphLocation = VectorAtts.AdaptsToMeshResolution  # AdaptsToMeshResolution, UniformInSpace
VectorAtts.useStride = 0
VectorAtts.stride = 1
VectorAtts.nVectors = 400
VectorAtts.lineStyle = VectorAtts.SOLID  # SOLID, DASH, DOT, DOTDASH
VectorAtts.lineWidth = 0
VectorAtts.scale = 0.25
VectorAtts.scaleByMagnitude = 1
VectorAtts.autoScale = 1
VectorAtts.headSize = 0.25
VectorAtts.headOn = 1
VectorAtts.colorByMag = 1
VectorAtts.useLegend = 1
VectorAtts.vectorColor = (0, 0, 0, 255)
VectorAtts.colorTableName = "Default"
VectorAtts.invertColorTable = 0
VectorAtts.vectorOrigin = VectorAtts.Tail  # Head, Middle, Tail
VectorAtts.minFlag = 0
VectorAtts.maxFlag = 0
VectorAtts.limitsMode = VectorAtts.OriginalData  # OriginalData, CurrentPlot
VectorAtts.min = 0
VectorAtts.max = 1
VectorAtts.lineStem = 1
VectorAtts.geometryQuality = VectorAtts.Fast  # Fast, High
VectorAtts.stemWidth = 0.08
VectorAtts.origOnly = 1
VectorAtts.glyphType = VectorAtts.Arrow  # Arrow, Ellipsoid
VectorAtts.nVectors = 400
SetPlotOptions(VectorAtts)
#AddOperator("Slice", 1)
DrawPlots()


SetActiveWindow(9)
text = CreateAnnotationObject("Text2D")
text.visible = 1
text.active = 1
text.position = (0.2, 0.88)
#text.width = 0.25
text.textColor = (0, 0, 0, 255)
text.useForegroundForTextColor = 1
text.text = "kperp"
text.fontFamily = text.Times  # Arial, Courier, Times
text.fontBold = 0
text.fontItalic = 0
text.fontShadow = 0
AnnotationAtts = AnnotationAttributes()
AnnotationAtts.databaseInfoFlag = 0
AnnotationAtts.userInfoFlag = 0
SetAnnotationAttributes(AnnotationAtts)
AddPlot("Vector", "kperp", 1, 1)
VectorAtts.glyphLocation = VectorAtts.UniformInSpace  # AdaptsToMeshResolution, UniformInSpace
VectorAtts.nVectors = 20
VectorAtts.scale = 2
VectorAtts.lineWidth = 3
VectorAtts.headSize = 0.1
SetPlotOptions(VectorAtts)
DrawPlots()
ToggleLockViewMode()
ToggleLockTime()



DrawPlots()
