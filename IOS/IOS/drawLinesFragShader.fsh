//
//  drawLinesFragShader.fsh
//  Created by Thiago Guimaraes on 11/13/13.
//  Copyright (c) 2013 Thiago Guimaraes. All rights reserved.
//

 varying lowp vec4 colorVarying;
 
 void main()
 {
     gl_FragColor = colorVarying;
 }
