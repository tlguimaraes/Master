//
//  ShaderManager.h
//  Created by Thiago Guimaraes on 11/13/13.
//  Copyright (c) 2013 Thiago Guimaraes. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface ShaderManager : NSObject

- (id)initWithVertexShaderFilename:(NSString *)vShaderFilename fragmentShaderFilename:(NSString *)fShaderFilename;
- (void)use;

@end
