//
//  CalcNormals.h
//
//  Created by Thiago Guimaraes on 11/13/13.
//  Copyright (c) 2013 Thiago Guimaraes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalcNormals : NSObject{
    NSMutableArray *polyArray;
}

- (id)initWithPolygonArray:(NSMutableArray*)polygonArray;
- (void)buildNormalsWithVertexArray:(NSMutableArray *)vArray destVertexNorms:(NSMutableArray *)vnArray destFaceNorms:(NSMutableArray *)fnArray;
- (void)buildFlatNormalsWithVertexArray:(NSMutableArray *)vArray destVertexNorms:(NSMutableArray *)vnArray destFaceNorms:(NSMutableArray *)fnArray;

@end
