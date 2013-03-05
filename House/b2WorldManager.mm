//
//  b2WorldManager.m
//  House
//
//  Created by Tao Yunfei on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "b2WorldManager.h"
#import "b2ActorManager.h"
#import "b2ActorController.h"
#import "cocos2d.h"
#import "b2Actor.h"
#import "b2MapEngine.h"
#import "b2CellFactory.h"
#import "b2Cell.h"

#import "TDeviceUtil.h"
#import "HSDynamicTreeManager.h"


static b2WorldManager* _sharedb2WorldManager;


@interface b2WorldManager(){
    float screenW;
    float screenH;
//    float screenWHalf;
//    float screenHHalf;
    
    b2World* world;
	
    
    CGPoint targetPos;
    float targetScale;
    GLESDebugDraw* debugDraw;
}


@end


@implementation b2WorldManager



+ (b2WorldManager *)sharedInstance{
	if (!_sharedb2WorldManager) {
        _sharedb2WorldManager = [[self alloc] init];
	}
    
	return _sharedb2WorldManager;
}

+ (b2World *)sharedb2World{
    return [[b2WorldManager sharedInstance] world];
}

- (id)init{
    self = [super init];
    
    if (self!=nil) {
        
        _showDebugDraw = YES;
        
        screenW = [[TDeviceUtil sharedInstance] screenWidth];
        screenH = [[TDeviceUtil sharedInstance] screenHeight];
        
//        screenWHalf = [[TDeviceUtil sharedInstance] screenWidthHalf];
//        screenHHalf = [[TDeviceUtil sharedInstance] screenHeightHalf];
        
        [self createWorld];
        [self setScale:1.0];
    
    }
    
    return self;
}


- (b2World*)world{
    return world;
}

- (void)createWorld{
    
    b2Vec2 gravity = b2Vec2(0.0f,-10.0f);
    bool bAllowSleeping = true; //不参与碰撞时 则休眠
    world = new b2World(gravity);
    world->SetAllowSleeping(bAllowSleeping);
    
//    world->setde
    
//    world->SetContinuousPhysics(true);
//    [self setPos:b2Vec2(0.0,55.0)];
}





#pragma mark - convert position

//- (CGPoint)convertTo

- (CGPoint)convertToGLPosInWorldForB2Pos:(b2Vec2)b2Pos{
//    b2Vec2 v = body->GetPosition();
    //    body->SetLinearVelocity(b2Vec2(1.0,0.0));
    
//    LOG_DEBUG(@"convertToGLPosInWorldForB2Pos b2Pos x:%f y:%f", b2Pos.x, b2Pos.y);
    
    float x = b2Pos.x*PTM_RATIO;
    float y = b2Pos.y*PTM_RATIO;
    return CGPointMake(x, y);
}

- (b2Vec2)convertToB2PosForGLPosClickedInWorld:(CGPoint)glPosClickedInWorld{
//    b2WorldManager* worldM = [b2WorldManager sharedInstance];
    float scale = _scale;
    b2Vec2 b2PosClickedInWorld = b2Vec2(((glPosClickedInWorld.x)/scale)/PTM_RATIO, ((glPosClickedInWorld.y)/scale)/PTM_RATIO);
    LOG_DEBUG(@"b2LocClickedInWorld -> x %f y%f  ",b2PosClickedInWorld.x,b2PosClickedInWorld.y);
    return b2PosClickedInWorld;
}



#pragma mark - update;



- (void)step:(float)delta{
    
    
//    static double UPDATE_INTERVAL = 1.0f/60.0f;
//    static double MAX_CYCLES_PER_FRAME = 5;
//    static double timeAccumulator = 0;
//    
//    timeAccumulator += delta;    
//    if (timeAccumulator > (MAX_CYCLES_PER_FRAME * UPDATE_INTERVAL)) {
//        timeAccumulator = UPDATE_INTERVAL;
//    }    
    
//    int velocityIterations = 3;
//    int positionIterations = 2;
//    while (timeAccumulator >= UPDATE_INTERVAL) {        
//        timeAccumulator -= UPDATE_INTERVAL;      
    
    
    
        
        [self zoomAction];  //最新的scale
        [self moveAction];  //最新的pos
        [self moveByFocusedActor];
    
        world->Step(delta, 3, 2);


//    world->ClearForces();
//        world->Step(UPDATE_INTERVAL, 3, 2);
//    }    
    
    [[HSDynamicTreeManager sharedInstance] query];
   

}

#pragma mark - draw fn


- (void)drawDebugData{
    
    if (!_showDebugDraw) return;

    if (!debugDraw) {
        debugDraw = new GLESDebugDraw();
        uint32 flags = 0;
        flags += b2Draw::e_shapeBit;
        flags += b2Draw::e_jointBit;
//        flags += b2Draw::e_aabbBit;
//        flags += b2Draw::e_pairBit;
//        flags += b2Draw::e_centerOfMassBit;    
        debugDraw->SetFlags(flags);
        world->SetDebugDraw(debugDraw);      
        debugDraw->SetRatio(PTM_RATIO);
        LOG_DEBUG(@"create debugDraw");
    }
    
    
    
    world->DrawDebugData();

}

#pragma mark - scale and move animation


- (void)setScale:(float)aScale{
    targetScale = aScale;
    _scale = targetScale;
}

- (void)zoomTo:(float)aScale{
    targetScale = aScale;
}

- (void)zoomAction{

    if (_scale!=targetScale) {
        float distanceScale = targetScale-_scale;
        _scale += distanceScale/5;
        if (distanceScale<0.001&&distanceScale>-0.001)  _scale = targetScale;       
    }
    
//    LOG_DEBUG(@"scale -> %f  targetScale -> %f",scale,targetScale);
}


- (void)setPos:(CGPoint)aPos{
    LOG_DEBUG(@"setPos x->%f y->%f",aPos.x,aPos.y);
    targetPos = aPos;
    _pos = targetPos;
}

- (void)moveTo:(CGPoint)aPos{
//    LOG_DEBUG(@"moveTo x->%f y->%f    oldPos x ->%f  y->%f",aPos.x,aPos.y,_pos.x,_pos.y);
//    linearMove = linear;
    targetPos = aPos;
}

- (void)moveAction{

    float offset = screenW/_scale;
    float distanceX = _pos.x-targetPos.x;
    float distanceY = _pos.y-targetPos.y;
    
//    isMoving = NO;
    
    if (distanceX != 0){
            if (-WORLD_MOVE_MIN_OFFSET<distanceX&&distanceX<WORLD_MOVE_MIN_OFFSET) {
                _pos.x = targetPos.x;
                return;
            }
            
            if (distanceX<-offset) {
                _pos.x = targetPos.x - offset;
            }else if(distanceX>offset){
                _pos.x = targetPos.x + offset;
            }else{
                _pos.x -= distanceX/WORLD_MOVE_STEP_NUM;
//                pos.x = roundf(pos.x);
            }       
    }
    
    if (distanceY!=0) {
            if (-WORLD_MOVE_MIN_OFFSET<distanceY&&distanceY<WORLD_MOVE_MIN_OFFSET) {
                _pos.y = targetPos.y;
                return;
            }            
            
            if (distanceY<-offset) {
                _pos.y = targetPos.y - offset;
            }else if(distanceY>offset){
                _pos.y = targetPos.y + offset;
            }else{
                _pos.y -= distanceY/WORLD_MOVE_STEP_NUM;
//                pos.y = roundf(pos.y);
            }       
        }

}


//- (void)moveByClickedPos{
//     [self moveTo:CGPointMake(roundf(corePos.x),roundf(corePos.y))];
//}

- (void)moveByFocusedActor{
    b2ActorController* actorC = [b2ActorController sharedInstance];
    b2Actor* actor = [actorC currentActor];
    CGPoint pos = [actor glPos];
    
//    LOG_DEBUG(@"actor -> %@  pos: %f %f", actor, pos.x ,pos.y);
    
    if (actor) {
        [self moveTo:CGPointMake(roundf(pos.x),roundf(pos.y))];
    }
}

- (void)moveByFocusedActorCore{
    
    b2ActorController* actorC = [b2ActorController sharedInstance];
    b2ActorCore* focusedActorCore = [actorC currentActorCore];
//    b2MapEngine* mEngine = [b2MapEngine sharedInstance];
    
    if (!focusedActorCore) {
        return;
    }
    
    CGPoint corePos = [focusedActorCore glPos];
//    LOG_DEBUG(@"focusedActorCore actorId -> %d  pos x -> %f  y -> %f",[focusedActorCore actorId],corePos.x,corePos.y);
    
    if (focusedActorCore) {
        [self moveTo:CGPointMake(roundf(corePos.x),roundf(corePos.y))];
    }   
    
//    LOG_DEBUG(@"moveByFocusedActorCore end ============================================");
}





@end



