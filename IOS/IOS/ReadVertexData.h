//
//  ReadVertexData.h
//
//  Created by Thiago Guimaraes on 11/13/13.
//  Copyright (c) 2013 Thiago Guimaraes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "common.h"

@interface ReadVertexData : NSObject
    

@property int vertCount;

- (id)initWithVertexCount:(int)vertexCount;
- (void)readVertexData:(NSData *)vertexBuffer withDestinationArray:(NSMutableArray *)vertexArray;

@end