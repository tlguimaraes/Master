//
//  ViewController.h
//  Created by Thiago Guimaraes on 10/29/14.
//  Copyright (c) 2014 Thiago Guimaraes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "Cheetah3DLoader.h"
#import "Camera.h"
#import "ShaderManager.h"
#import "TouchMatrix.h"

@interface ViewController : GLKViewController
{
    Cheetah3DLoader *myModel;
    Camera          *myCamera;
    GLKTextureInfo  *texture;
    ShaderManager   *lineShader;
    ShaderManager   *textureShader;
}

@end
