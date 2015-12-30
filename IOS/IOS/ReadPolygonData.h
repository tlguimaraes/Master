//
//  ReadPolygonData.h
//
//  Created by Thiago Guimaraes on 11/13/13.
//  Copyright (c) 2013 Thiago Guimaraes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "common.h"

@interface ReadPolygonData : NSObject

@property   int      polygonCount;
@property   NSData*  UVBuffer;
@property   NSData*  polygonBuffer;

- (id)initWithPolygonCount:(int)polyCount :(NSData *)UVBuffer :(NSData *)polyBuffer;
- (void)buildPolygonsAndUVsWithDestArray:(NSMutableArray *)polygonArray destUVs0:(NSMutableArray *)UVArray0 destUVs1:(NSMutableArray *)UVArray0;

@end
