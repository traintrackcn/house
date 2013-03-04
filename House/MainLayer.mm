//
//  MainLayer.m
//  House
//
//  Created by Tao Yunfei on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainLayer.h"
#import "b2WorldManager.h"
#import "b2ActorController.h"
#import "b2VehicleActor.h"
#import "b2MapEngine.h"

#import "b2CellFactory.h"
#import "b2Cell.h"
#import "CellSkinPool.h"

#import "CellSkin.h"
#import "DayAndNightManager.h"

//#import "ske"
//#import "TDE"


@interface MainLayer(){
    b2MouseJoint* mouseJoint;
}
- (void)freeMouseJoint;
- (void)updateMouseJointTarget:(CGPoint)location;
@end


static MainLayer* _sharedMainLayer;

@implementation MainLayer

@synthesize bacground;
//@synthesize weatherSkin = _weatherSkin;

- (id)init{
    
    self = [super init];
    if (self) {

        [self setAnchorPoint:CGPointMake(0.0, 0.0)];
        
//        world = [b2WorldManager sharedb2World];
        
    }
    return self;
}




- (void)update:(ccTime)delta{

    b2WorldManager *worldM = [b2WorldManager sharedInstance];
    [worldM step:delta]; //更新b2World中的actor的位置
    
    CGPoint pos = [worldM pos];
    float scale = [worldM scale];
    
//    [worldM setPos:CGPointMake(pos.x+1, pos.y)];


    //只显示当前视野的Actor and land
    b2MapEngine* mEngine = [b2MapEngine sharedInstance];
    [mEngine update];    
    
    float targetX = (-pos.x*scale+[[TDeviceUtil sharedInstance] screenWidthHalf]);
//    float targetY = (-pos.y*scale+[screenUtil halfH]);
    float targetY = (-pos.y*scale+50.0);


    [self setPosition:CGPointMake(targetX,targetY)];
    
    
    CGPoint bgPos = ccp(pos.x, pos.y+[[TDeviceUtil sharedInstance] screenHeightHalf]-50);
//    CGPoint weatherPos = bgPos;
    
    if (bacground) [bacground setPosition:bgPos];
    
//    LOG_DEBUG(@"halfW -> %f",[screenUtil halfW]);
//    [self setPosition:CGPointMake(-pos.x+[screenUtil halfW], -pos.y+[screenUtil halfH])];
//    [self setPosition:CGPointMake((-pos.y+[screenUtil halfH])*scale,(-pos.x+[screenUtil halfW])*scale)];

//    LOG_DEBUG(@"targetX -> %f targetY -> %f",targetX,targetY);
    
//    CCLayer* layer = [SceneManager sharedLayer];
    [self setScale:scale];
    
    [[DayAndNightManager sharedInstance] updateCellsColor];

}


#pragma mark - update/draw session

-(void)draw{
    
    
    
//    [bgSkin visit];
//    [_weatherSkin visit];
//    
    [super draw];
    b2WorldManager* worldM = [b2WorldManager sharedInstance];
    
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	kmGLPushMatrix();
	[worldM drawDebugData];
    
    

	kmGLPopMatrix();
	
    //    ccDrawLine(CGPointMake(0.0, 0.0),CGPointMake(100.0, 100.0));
//    ccDrawColor4F(255, 255, 255,255);
//    ccDrawLine(CGPointMake(0.0, 0.0),CGPointMake(1000.0, 0.0));
//    ccDrawLine(CGPointMake(0.0, 0.0),CGPointMake(0.0, 1000.0));
    
//    ccBlendFunc
    
    
    CHECK_GL_ERROR_DEBUG();
}




- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    UITouch *touch = [touches anyObject]; 
//    CGPoint location = [touch locationInView:[touch view]];
    CGPoint loc = [touch locationInView:[touch view]];
    CGPoint glLoc = [[CCDirector sharedDirector] convertToGL:loc];
    int tapCount = [touch tapCount];
//    pt = [screenUtil convertClickedUIPos:pt];
    CGPoint layerLoc = [self position];
    b2WorldManager* worldM = [b2WorldManager sharedInstance];
    float scale = [worldM scale];
    CGPoint glLocInLayer = CGPointMake((glLoc.x-layerLoc.x)/scale, (glLoc.y-layerLoc.y)/scale);

//    LOG_DEBUG(@"ccTouchesBegan  tapCount -> %d",);
    float x = glLoc.x;
    float y = glLoc.y;    

    float screenW = [[TDeviceUtil sharedInstance] screenWidth];
    float screenH = [[TDeviceUtil sharedInstance] screenHeight];
    float connerOffset = 50.0;
    
  
    b2ActorController* actorC = [b2ActorController sharedInstance];

    b2Vec2 b2Loc = b2Vec2(glLocInLayer.x/PTM_RATIO, glLocInLayer.y/PTM_RATIO);
    b2Body* body = [[[actorC currentActor] baseCell] body];
    
    if (body == NULL) {
        LOG_DEBUG(@"current controlled body is null");
        return;
    }
    
    b2Vec2 targetLoc = body->GetPosition();
    
//    LOG_DEBUG(@"touch view -> %@",[touch view]);
    LOG_DEBUG(@"loc -> x %f y %f   glLoc -> x %f y %f  layerLoc -> x %f y %f   glLocInLayer x %f y %f",loc.x,loc.y,glLoc.x,glLoc.y,layerLoc.x,layerLoc.y,glLocInLayer.x,glLocInLayer.y);
    LOG_DEBUG(@"b2Loc -> x %f y%f   fixture x%f y %f",b2Loc.x,b2Loc.y,targetLoc.x,targetLoc.y);
    LOG_DEBUG(@"==============================");
    
    if (body->GetFixtureList()->TestPoint(b2Loc)) {
        b2World* world = [b2WorldManager sharedb2World];
        b2BodyDef bodyDef;
        b2Body* tempBody = world->CreateBody(&bodyDef);
    
        b2MouseJointDef md;
        md.bodyA = tempBody;
        md.bodyB = body;
        md.target = b2Loc;
        md.collideConnected = true;
        md.maxForce = 100000000000.0f ;
        
        mouseJoint =  (b2MouseJoint*) world->CreateJoint(&md);           
    }    
//    return;
    
    
    

    if (y>(screenH-connerOffset)) { //上80.0屏幕
//        LOG_DEBUG(@"上屏幕");
        if (x<connerOffset){ //左
            [actorC focusPrevous];
//            LOG_DEBUG(@"focusPrevous");
            return;
        }else if(x>(screenW-connerOffset)){ //右
            [actorC focusNext];
//            LOG_DEBUG(@"focusNext");
            return;
        }
    }else if(y<connerOffset){ //下半屏幕
        if (x<connerOffset){ //左
            [actorC doBackward];
            return;
        }else if(x>(screenW-connerOffset)){//右
            [actorC doForward];
            return;
        }
    }
    
    if (tapCount==2) {
        [self doZoom];
        return;
    }
    
    
    

}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject]; 
    CGPoint location = [touch locationInView:[touch view]];
//    location = [[CCDirector sharedDirector] convertToGL:location];
//    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
//    
//    mouseJoint->SetTarget(locationWorld);
    [self updateMouseJointTarget:location];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [touches anyObject];
//    LOG_DEBUG(@"ccTouchesEnded  touch -> %@",touch);
    
    
//    LOG_DEBUG(@"ccTouchesEnded %@", touches);
    [self freeMouseJoint];  
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self freeMouseJoint];
}


#pragma mark - operate mouse joint
- (void)freeMouseJoint{
    if (mouseJoint) {
        b2World* world = [b2WorldManager sharedb2World];
        world->DestroyJoint(mouseJoint);
        mouseJoint = NULL;
    }    
}

- (void)updateMouseJointTarget:(CGPoint)location{
    if (mouseJoint) {
        CGPoint glLoc = [[CCDirector sharedDirector] convertToGL:location];
        CGPoint layerLoc = [self position];
        b2WorldManager* worldM = [b2WorldManager sharedInstance];
        float scale = [worldM scale];
        CGPoint glLocInLayer = CGPointMake((glLoc.x-layerLoc.x)/scale, (glLoc.y-layerLoc.y)/scale);        
        
        b2Vec2 b2Loc = b2Vec2(glLocInLayer.x/PTM_RATIO, glLocInLayer.y/PTM_RATIO);
        
        mouseJoint->SetTarget(b2Loc);    
    }
}

- (void)doZoom{
    b2WorldManager* worldM = [b2WorldManager sharedInstance];

    if ([worldM scale]==1.0) {
        [worldM zoomTo:2.0];
    }else if([worldM scale]==2.0){
        [worldM zoomTo:1.0];
    }  
    
//    if ([worldM scale]==1.0) {
//        [worldM zoomTo:0.5];
//    }else if([worldM scale]==0.5){
//        [worldM zoomTo:1.0];
//    }      
    
}



@end
