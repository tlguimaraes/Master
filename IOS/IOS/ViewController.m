//
//  ViewController.m
//  Created by Thiago Guimaraes on 10/29/14.
//  Copyright (c) 2014 Thiago Guimaraes. All rights reserved.
//

#import "ViewController.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

// Uniform index.
enum
{
    UNIFORM_PROJECTION_MATRIX,
    UNIFORM_MODEL_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    NUM_ATTRIBUTES
};

@interface ViewController () {
    GLuint _program;
    
    GLKMatrix4 _projectionMatrix;
    GLKMatrix4 _viewMatrix;
    GLKMatrix4 _modelMatrix;
    GLKMatrix3 _normalMatrix;
    float      _rotation;
}

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) TouchMatrix* transformations;

- (void)setupGL;
- (void)tearDownGL;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    // Initialize touch translations
    self.transformations = [[TouchMatrix alloc] initWithDepth:0.0f
                                                              Scale:1.0f
                                                        Translation:GLKVector2Make(0.0f, 0.0f)
                                                           Rotation:GLKVector3Make(0.0f, 0.0f, 0.0f)];
    
    [self setupGL];
}

- (void)dealloc
{    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
    // Dispose of any resources that can be recreated.
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    //---------------------------------------------------------------------------------------------------------------------
    // Load all the shaders...
    //---------------------------------------------------------------------------------------------------------------------
    
    lineShader = [[ShaderManager alloc] initWithVertexShaderFilename:@"drawLinesVertShader"
                                            fragmentShaderFilename:@"drawLinesFragShader"];
    
    
    textureShader = [[ShaderManager alloc] initWithVertexShaderFilename:@"Shader"
                                               fragmentShaderFilename:@"Shader"];

    //---------------------------------------------------------------------------------------------------------------------

    
    NSError *error;
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:GLKTextureLoaderOriginBottomLeft];
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"CrossoverNode" ofType:@"png"];
    //NSString* filePath = [[NSBundle mainBundle] pathForResource:@"UV_mapper" ofType:@"png"];
    texture = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:&error];
    if(error) {
        NSLog(@"Error loading texture from image: %@", error);
        exit(1);
    }
    
    //Load model
    myModel = [[Cheetah3DLoader new] initWithJASFileName:@"NodeFolder"];
    [myModel LoadCheetah3DModel:@"Soup Can"];
    //[myModel LoadCheetah3DModel:@"Torus"];
    
    //Load Camera
    myCamera = [[Camera new]initWithJASFileName:@"NodeFolder" isLandscape:YES];
    [myCamera LoadCameraNamed:@"Camera"];
    
    //Set the projection matrix after loading a camera.
    //It's likely we only need to do this once.
    //It can be called in the update function if needed
    _projectionMatrix = [myCamera getProjectionMatrix];
    
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(MeshVertex), BUFFER_OFFSET(0)); // positions
    
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(MeshVertex), BUFFER_OFFSET(12));  //normals
    
    // Color/diffuse map UVs
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(MeshVertex), BUFFER_OFFSET(24));// texcoords0
    
    // Normal/displacement map UVs
    glEnableVertexAttribArray(GLKVertexAttribTexCoord1);
    glVertexAttribPointer(GLKVertexAttribTexCoord1, 2, GL_FLOAT, GL_FALSE, sizeof(MeshVertex), BUFFER_OFFSET(32));// texcoords1
    
    //Bones
    
    //Bone Matrices
    
    glBindVertexArrayOES(0);
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    GLuint vertexBuffer = myModel.vertexArrayBuffer;
    GLuint vertexArray = myModel.vertexArray;
    
    glDeleteBuffers(1, &vertexBuffer);
    glDeleteVertexArraysOES(1, &vertexArray);
    
    //self.effect = nil;
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}


#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    // The projection and modelview matrices are combined by the shader,
    // while the camera's viewMatrix and the touch transforms are combined
    // with the modelMatrix here to match the Cheetah 3D view and then
    // allow touches to change the view.
    
    //_projectionMatrix = [myCamera getProjectionMatrix];//uncomment if you want to update the _projectionMatrix
    
    //Set Camera Target
    GLKVector3 newTarget;
    newTarget = myModel.position;
    
    //Update camera
    _viewMatrix = [myCamera LookAt:newTarget];//point camera
    
    //Add matrix transforms from touches
    _viewMatrix = GLKMatrix4Multiply(_viewMatrix, [self.transformations getModelViewMatrix]);
    
    //Apply model translation and multiply the view matrix
    _modelMatrix = GLKMatrix4Translate(_viewMatrix, myModel.position.x, myModel.position.y, myModel.position.z);
    
    //Apply model rotation
    _modelMatrix = GLKMatrix4RotateY(_modelMatrix, GLKMathDegreesToRadians(myModel.rotation.y));
    _modelMatrix = GLKMatrix4RotateX(_modelMatrix, GLKMathDegreesToRadians(myModel.rotation.x));
    _modelMatrix = GLKMatrix4RotateZ(_modelMatrix, GLKMathDegreesToRadians(myModel.rotation.z));
    
    //Apply model scale
    _modelMatrix = GLKMatrix4Scale(_modelMatrix, myModel.scale.x, myModel.scale.y, myModel.scale.z);

    //Get model normal matrix
    _normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(_modelMatrix), NULL);
    
    _rotation += self.timeSinceLastUpdate * 0.5f;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.45f, 0.45f, 0.45f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(texture.target, texture.name);
    
    glUniformMatrix4fv(uniforms[UNIFORM_PROJECTION_MATRIX], 1, 0, _projectionMatrix.m);
    glUniformMatrix4fv(uniforms[UNIFORM_MODEL_MATRIX], 1, 0, _modelMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
    
    glBindVertexArrayOES(myModel.vertexArrayBuffer);
    
    [textureShader use];//call to ShaderManager object to load this shader in OpenGL
    //[lineShader use];
    glDrawArrays(GL_TRIANGLES, 0, myModel.triangleVertCount);
    
    //[lineShader use];
    //glDrawArrays(GL_LINES, 0, myModel.triangleVertCount); //draw as lines to see polys
    //glDrawArrays(GL_POINTS, 0, myModel.triangleVertCount); //draw as points to see vertices
}



#pragma mark - Gesture Recognizer methods

- (IBAction)iPadDoubleTap:(UITapGestureRecognizer *)sender {
    [self.transformations reset];
}

- (IBAction)DoubleTap:(UITapGestureRecognizer *)sender {
    [self.transformations reset];
}

- (IBAction)Pan:(UIPanGestureRecognizer *)sender {
    // Pan (1 Finger)
    if((sender.numberOfTouches == 2) &&
       ((self.transformations.state == S_NEW) || (self.transformations.state == S_TRANSLATION)))
    {
        CGPoint translation = [sender translationInView:sender.view];
        float x = translation.x/sender.view.frame.size.width;
        float y = translation.y/sender.view.frame.size.height;
        [self.transformations translate:GLKVector2Make(x, y) withMultiplier:5.0f];
    }
    
    // Pan (2 Fingers)
    else if((sender.numberOfTouches == 1) &&
            ((self.transformations.state == S_NEW) || (self.transformations.state == S_ROTATION)))
    {
        const float m = GLKMathDegreesToRadians(0.5f);
        CGPoint rotation = [sender translationInView:sender.view];
        [self.transformations rotate:GLKVector3Make(rotation.x, rotation.y, 0.0f) withMultiplier:m];
    }
}

- (IBAction)Pinch:(UIPinchGestureRecognizer *)sender {
    if((self.transformations.state == S_NEW) || (self.transformations.state == S_SCALE))
    {
        float scale = [sender scale];
        [self.transformations scale:scale];
    }
}

- (IBAction)Rotation:(UIRotationGestureRecognizer *)sender {
    // Rotation
    if((self.transformations.state == S_NEW) || (self.transformations.state == S_ROTATION))
    {
        float rotation = [sender rotation];
        [self.transformations rotate:GLKVector3Make(0.0f, 0.0f, rotation) withMultiplier:1.0f];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.transformations start];
}


@end
