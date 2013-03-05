//
//  MainLayer.m
//  House
//
//  Created by Tao Yunfei on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HSMainLayer.h"
#import "b2WorldManager.h"
#import "b2ActorController.h"
#import "b2VehicleActor.h"
#import "b2MapEngine.h"

#import "b2CellFactory.h"
#import "b2Cell.h"


//#import "ske"
//#import "TDE"


@interface HSMainLayer(){
    b2MouseJoint* mouseJoint;
    
}

@end


//static MainLayer* _sharedMainLayer;

@implementation HSMainLayer



- (id)init{
    
    self = [super init];
    if (self) {
        
        [self setIsTouchEnabled:YES];
        [self scheduleUpdate];

        [self setAnchorPoint:CGPointMake(0.0, 0.0)];
        
//        world = [b2WorldManager sharedb2World];
        [b2MapEngine sharedInstance];
        
    }
    return self;
}




- (void)update:(ccTime)delta{
    
    b2WorldManager *worldM = [b2WorldManager sharedInstance];
    CGPoint pos = [worldM pos];
    float scale = [worldM scale];
    
//    LOG_DEBUG(@"world pos: %f %f", pos.x, pos.y);
    float targetX = (-pos.x*scale+[[TDeviceUtil sharedInstance] screenWidthHalf]);
    float targetY = (-pos.y*scale+[[TDeviceUtil sharedInstance] screenHeightHalf]);

    [self setPosition:CGPointMake(targetX,targetY)];
    [self setScale:scale];
    [worldM step:delta]; //更新b2World中的actor的位置

}


#pragma mark - update/draw session

-(void)draw{
//    [super draw];
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
    CGPoint vPosOnScreen = [touch locationInView:[touch view]];
    CGPoint glPosOnScreen = [[CCDirector sharedDirector] convertToGL:vPosOnScreen];
    CGPoint layerPos = [self position];
    CGPoint glPosClickedInWorld = CGPointMake(glPosOnScreen.x-layerPos.x, glPosOnScreen.y-layerPos.y);
    b2WorldManager* worldM = [b2WorldManager sharedInstance];
    
    LOG_DEBUG(@"vPosOnScreen -> x %f y %f",vPosOnScreen.x,vPosOnScreen.y);
    LOG_DEBUG(@"glPosOnScreen -> x %f y %f", glPosOnScreen.x,glPosOnScreen.y);
    LOG_DEBUG(@"layerPos -> x %f y %f", layerPos.x, layerPos.y);
    LOG_DEBUG(@"glPosClickedInWorld x %f y %f", glPosClickedInWorld.x,glPosClickedInWorld.y);
    
    [self calcuTouchAreaWithGLPosOnScreen:glPosOnScreen];

    b2Vec2 b2PosClickedInWorld = [worldM convertToB2PosForGLPosClickedInWorld:glPosClickedInWorld];
    [self startDragMouseJointWithB2PosClickedInWorld:b2PosClickedInWorld];
    
    if ([touch tapCount] == 2) {
        [self doZoom];
    }

}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject]; 
    CGPoint location = [touch locationInView:[touch view]];

    [self draggingMouseJointTarget:location];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [touches anyObject];
//    LOG_DEBUG(@"ccTouchesEnded  touch -> %@",touch);
    
    
//    LOG_DEBUG(@"ccTouchesEnded %@", touches);
    [self endDragMouseJoint];
    LOG_DEBUG(@"==========================");
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endDragMouseJoint];
    LOG_DEBUG(@"==========================");
}




#pragma mark - analyze touching area

- (void)calcuTouchAreaWithGLPosOnScreen:(CGPoint)glPosOnScreen{
    
    CGFloat glXOnScreen = glPosOnScreen.x;
    CGFloat glYOnScreen = glPosOnScreen.y;
    
    b2ActorController* actorC = [b2ActorController sharedInstance];
    float screenW = [[TDeviceUtil sharedInstance] screenWidth];
    float screenH = [[TDeviceUtil sharedInstance] screenHeight];
    float connerOffset = 50.0;
    if (glYOnScreen>(screenH-connerOffset)) { //上80.0屏幕
        //        LOG_DEBUG(@"上屏幕");
        if (glXOnScreen<connerOffset){ //左
            [actorC focusPrevous];
            return;
        }else if(glXOnScreen>(screenW-connerOffset)){ //右
            [actorC focusNext];
            return;
        }
    }else if(glYOnScreen<connerOffset){ //下半屏幕
        if (glXOnScreen<connerOffset){ //左
            [actorC doBackward];
            return;
        }else if(glXOnScreen>(screenW-connerOffset)){//右
            [actorC doForward];
            return;
        }
    }
}

#pragma mark - operate mouse joint

- (void)startDragMouseJointWithB2PosClickedInWorld:(b2Vec2) b2PosClickedInWorld{
    b2ActorController* actorC = [b2ActorController sharedInstance];
    b2Body* body = [[[actorC currentActor] baseCell] body];
    b2Vec2 b2LocTarget = body->GetPosition();
    LOG_DEBUG(@"b2LocTarget x%f y %f",b2LocTarget.x,b2LocTarget.y);
    
    if (body == NULL) {
        LOG_DEBUG(@"current controlled body is null");
        return;
    }
    
    if (body->GetFixtureList()->TestPoint(b2PosClickedInWorld)) {
        b2World* world = [b2WorldManager sharedb2World];
        b2BodyDef bodyDef;
        b2Body* tempBody = world->CreateBody(&bodyDef);
        
        b2MouseJointDef md;
//        md.dampingRatio = 0.0f;
        md.bodyA = tempBody;
        md.bodyB = body;
        md.target = b2PosClickedInWorld;
        md.collideConnected = NO;
        md.maxForce = 100000000.0f ;
//        md.frequencyHz = 60;
        
        mouseJoint =  (b2MouseJoint*) world->CreateJoint(&md);
    }
}

- (void)draggingMouseJointTarget:(CGPoint)location{
    if (mouseJoint) {
        CGPoint glPos = [[CCDirector sharedDirector] convertToGL:location];
        CGPoint layerPos = [self position];
        b2WorldManager* worldM = [b2WorldManager sharedInstance];
        float scale = [worldM scale];
        CGPoint glPosInLayer = CGPointMake((glPos.x-layerPos.x)/scale, (glPos.y-layerPos.y)/scale);
        
        b2Vec2 b2Loc = b2Vec2(glPosInLayer.x/PTM_RATIO, glPosInLayer.y/PTM_RATIO);
        
        mouseJoint->SetTarget(b2Loc);
    }
}

- (void)endDragMouseJoint{
    if (mouseJoint) {
        b2World* world = [b2WorldManager sharedb2World];
        world->DestroyJoint(mouseJoint);
        mouseJoint = NULL;
    }    
}



- (void)doZoom{
    b2WorldManager* worldM = [b2WorldManager sharedInstance];

    if ([worldM scale]==1.0) {
        [worldM zoomTo:0.5];
    }else if([worldM scale]==0.5){
        [worldM zoomTo:1.0];
    }  
         
    
}




@end
