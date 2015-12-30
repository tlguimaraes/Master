//
//  Camera.h
//  Created by Thiago Guimaraes on 11/13/13.
//  Copyright (c) 2013 Thiago Guimaraes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "common.h"

@interface Camera : NSObject
{
    GLfloat       screenHeight;
    GLfloat       aspectRatio;
    NSString      *JASfileName;
}

@property GLKMatrix4 cameraTransformMatrix;
@property GLfloat FOVangle;
@property GLfloat screenWidth;
@property GLfloat clipNear;
@property GLfloat clipFar;
@property GLKVector3 cameraPosition;
@property GLKVector3 cameraRotation;
@property GLKVector3 target;
@property GLKVector3 up;

- (id)initAsLandscape:(BOOL)orientation;
- (id)initWithJASFileName:(NSString *)filename isLandscape:(BOOL)orientation;
- (void)LoadCameraNamed:(NSString *)cameraName;
- (GLKMatrix4)getProjectionMatrix;
- (GLKMatrix4)LookAt:(GLKVector3)aPosition;
- (void)scaleFOV:(GLfloat)scale;
- (void)SetCameraPosition:(GLKVector3)newPosition;
- (void)SetCameraUpDirection:(GLKVector3)thisIsUp;
- (void)CalculateCameraUp;

@end
