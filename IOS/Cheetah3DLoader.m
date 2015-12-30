//
//  Cheetah3DLoader.m
//
//  Created by Thiago Guimaraes on 11/13/13.
//  Copyright (c) 2013 Thiago Guimaraes. All rights reserved.
//

#import "Cheetah3DLoader.h"

@implementation Cheetah3DLoader

@synthesize triangleVertCount;
@synthesize vertexArray;
@synthesize vertexArrayBuffer;
@synthesize scale;
@synthesize rotation;
@synthesize position;


// Designated initializer
- (id)initWithJASFileName:(NSString *)filename
{
    self=[super init];
    
    if(self)
    {
        JASfileName = [[NSBundle mainBundle] pathForResource:filename ofType:@"jas"];
    }
    
    return self;
}

- (void)LoadCheetah3DModel:(NSString *)objectName{
    //This method reads both triangles and quads.
    // Read the Cheetah 3D plist file
    NSDictionary *cheetahFile = [NSDictionary dictionaryWithContentsOfFile:JASfileName];
    NSArray *objectArray = [cheetahFile objectForKey:@"Objects"];
    NSDictionary *model = [NSDictionary new];
    Boolean modelFound = false;
    // Find the object index by name
    for (int i= 1; i < [objectArray count]; i++) {//start at index 1 because the camera is always 0 so we can skip it
        model = [objectArray objectAtIndex:i];
        NSString *testString = model[@"name"];
        if ([testString isEqualToString:objectName]) {
            modelFound = true;
            break; //get out of the loop we found the right one
        }
    }
    if(modelFound == false){
        NSLog(@"Error: No model exists with the name: %@", objectName);
        exit(1);
    }
    cheetahFile = nil;//free up some memory
    objectArray = nil;//free up some memory
    GLuint originalPolyCount = [[model valueForKey:@"polygoncount"] intValue];
    GLuint vertexCount = [[model valueForKey:@"vertexcount"] intValue];
    
    scale.x = [[[model valueForKey:@"scale"]objectAtIndex:0]floatValue];
    scale.y = [[[model valueForKey:@"scale"]objectAtIndex:1]floatValue];
    scale.z = [[[model valueForKey:@"scale"]objectAtIndex:2]floatValue];
    
    rotation.y = [[[model valueForKey:@"rotation"]objectAtIndex:0]floatValue];
    rotation.x = [[[model valueForKey:@"rotation"]objectAtIndex:1]floatValue];
    rotation.z = [[[model valueForKey:@"rotation"]objectAtIndex:2]floatValue];
    
    position.x = [[[model valueForKey:@"position"]objectAtIndex:0]floatValue];
    position.y = [[[model valueForKey:@"position"]objectAtIndex:1]floatValue];
    position.z = [[[model valueForKey:@"position"]objectAtIndex:2]floatValue];
    
    // Load vertex array from file data
    NSData *vertexData = model[@"vertex"]; //get raw bytes
    NSMutableArray *vertArray = [[NSMutableArray alloc]init];
    ReadVertexData *vertexReader = [[ReadVertexData new] initWithVertexCount:vertexCount];
    [vertexReader readVertexData:vertexData withDestinationArray:vertArray];
    
    // Load polygon data into polygonArray - where each element is an array of indexes to vertexArray
    // We need to deal with UVs at the same time, because our tesselation will create more polys... each
    // new poly needs UVs... so the UV arrays need to align with the new polygon array
    NSData *polygonData = model[@"polygons"]; //raw bytes
    NSMutableArray *polygonArray = [[NSMutableArray alloc]init];
    NSData *UVData = model[@"uvcoords"]; //raw bytes
    NSMutableArray * UVArray0 = [[NSMutableArray alloc]init];
    NSMutableArray * UVArray1 = [[NSMutableArray alloc]init];
    ReadPolygonData *polyReader = [[ReadPolygonData new] initWithPolygonCount:originalPolyCount :UVData :polygonData];
    [polyReader buildPolygonsAndUVsWithDestArray:polygonArray destUVs0:UVArray0 destUVs1:UVArray1];//<--This is where tesselation happens
    GLuint polygonCount = (GLuint)[polygonArray count];//We now have more polygons
    
    NSMutableArray *faceNormalsArray = [[NSMutableArray alloc] init];
    NSMutableArray *vertexNormalsArray = [[NSMutableArray alloc] init];
    CalcNormals *buildNormals = [[CalcNormals new] initWithPolygonArray:polygonArray];
    [buildNormals buildNormalsWithVertexArray:vertArray destVertexNorms:vertexNormalsArray destFaceNorms:faceNormalsArray];
    
    triangleVertCount = polygonCount * 3;
    MeshVertex  meshVerts[triangleVertCount];
    int vert;
    int vertCounter = 0;
    
    for (int i = 0; i < polygonCount; i++) {
        
        for (int j = 0; j < 3; j++) {
            vert = (GLuint)[[[polygonArray objectAtIndex:i] objectAtIndex:j]integerValue];
            meshVerts[vertCounter].position.x = [[[vertArray objectAtIndex:vert] objectAtIndex:0]floatValue];
            meshVerts[vertCounter].position.y = [[[vertArray objectAtIndex:vert] objectAtIndex:1]floatValue];
            meshVerts[vertCounter].position.z = [[[vertArray objectAtIndex:vert] objectAtIndex:2]floatValue];
            
            meshVerts[vertCounter].normal.x = [[[vertexNormalsArray objectAtIndex:vert] objectAtIndex:0]floatValue];
            meshVerts[vertCounter].normal.y = [[[vertexNormalsArray objectAtIndex:vert] objectAtIndex:1]floatValue];
            meshVerts[vertCounter].normal.z = [[[vertexNormalsArray objectAtIndex:vert] objectAtIndex:2]floatValue];
            
            meshVerts[vertCounter].texCoords0.u = [[[UVArray0 objectAtIndex:vertCounter] objectAtIndex:0]floatValue];
            meshVerts[vertCounter].texCoords0.v = [[[UVArray0 objectAtIndex:vertCounter] objectAtIndex:1]floatValue];
            
            meshVerts[vertCounter].texCoords1.u = [[[UVArray1 objectAtIndex:vertCounter] objectAtIndex:0]floatValue];
            meshVerts[vertCounter].texCoords1.v = [[[UVArray1 objectAtIndex:vertCounter] objectAtIndex:1]floatValue];
            
            vertCounter++;
        }
        
    }
    
    
    glGenVertexArraysOES(1, &vertexArray);
    glBindVertexArrayOES(vertexArray);
    
    glGenBuffers(1, &vertexArrayBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexArrayBuffer);
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(meshVerts), meshVerts, GL_STATIC_DRAW);
}


@end
