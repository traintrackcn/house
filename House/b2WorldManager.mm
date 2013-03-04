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
//#import "ScreenUtil.h"
//#import "GLES-Render.h"

static b2WorldManager* _sharedb2WorldManager;


@interface b2WorldManager()

- (void)createWorld;
- (void)zoomAction;
- (void)moveAction;
- (void)moveXAction;
- (void)moveYAction;
- (void)moveByFocusedActorCore;
- (void)query;

@end


@implementation b2WorldManager

@synthesize pos;
@synthesize scale;
@synthesize showDebugDraw;

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
        
//        screenUtil = [ScreenUtil sharedInstance];
        
        treeUserDataDic = [[NSMutableDictionary alloc] init];
        
//        showDebugDraw = YES;
        
        [self createWorld];
    
        [self setScale:1.0];
    }
    
    return self;
}


- (b2DynamicTree)tree{
    return tree;
}

- (b2World*)world{
    return world;
}

- (void)createWorld{
    
    b2Vec2 gravity = b2Vec2(0.0f,-10.0f);
    bool doSleep = true; //不参与碰撞时 则休眠
    world = new b2World(gravity);
    world->SetAllowSleeping(doSleep);
    
//    world->SetContinuousPhysics(true);
//    [self setPos:b2Vec2(0.0,55.0)];
}



#pragma mark - b2DynamicTree function 

- (int)treeCreateProxy:(b2AABB)aabb userData:(id)userData{
    int proxyId = tree.CreateProxy(aabb, nil);
    NSNumber *key = [NSNumber numberWithInt:proxyId];
    [treeUserDataDic setObject:userData forKey:key];
    return proxyId;
}


- (void)treeDeleteProxy:(int)proxyId{
    tree.DestroyProxy(proxyId);
    
    NSNumber *key = [NSNumber numberWithInt:proxyId];
    
    [treeUserDataDic removeObjectForKey:key];
    
}

- (id)treeGetUserData:(int)proxyId{
    NSNumber *key = [NSNumber numberWithInt:proxyId];
    return [treeUserDataDic objectForKey:key];
}

- (void)treeMoveProxy:(int)proxyId{
//    tree.MoveProxy(proxyId, <#const b2AABB &aabb1#>, <#const b2Vec2 &displacement#>);
    
//    b2AABB aabb0 = actor->aabb;
//    MoveAABB(&actor->aabb);
//    b2Vec2 displacement = actor->aabb.GetCenter() - aabb0.GetCenter();
//    m_tree.MoveProxy(actor->proxyId, actor->aabb, displacement);    
    
}

#pragma mark - convert position

//- (CGPoint)convertTo

- (CGPoint)convertToLayerPos:(b2Body *)body{
    
    b2Vec2 v = body->GetPosition();
    //    body->SetLinearVelocity(b2Vec2(1.0,0.0));
    float x = v.x*PTM_RATIO*scale;
    float y = v.y*PTM_RATIO*scale;
    
//    delete v;
    
    return CGPointMake(x, y);
}

#pragma mark - set pos


- (bool) QueryCallback:(int)proxyId{
    return YES;
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
        [self moveByFocusedActorCore];
    
        world->Step(delta, 3, 2); 
    
//    world->ClearForces();
//        world->Step(UPDATE_INTERVAL, 3, 2);
//    }    
    
    
   
  
}

#pragma mark - draw fn


- (void)drawDebugData{
    
    if (!showDebugDraw) {
        return;
    }

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
    scale = targetScale;
}

- (void)zoomTo:(float)aScale{
    targetScale = aScale;
}

- (void)zoomAction{

    if (scale!=targetScale) {
        float distanceScale = targetScale-scale;
        scale += distanceScale/5;
        if (distanceScale<0.001&&distanceScale>-0.001)  scale = targetScale;       
    }
    
//    LOG_DEBUG(@"scale -> %f  targetScale -> %f",scale,targetScale);
}


- (void)setPos:(CGPoint)aPos{
//    LOG_DEBUG(@"setPos x->%f y->%f",aPos.x,aPos.y);
    targetPos = aPos;
    pos = targetPos;
}

- (void)moveTo:(CGPoint)aPos{
//    LOG_DEBUG(@"moveTo x->%f y->%f    oldPos x ->%f  y->%f",aPos.x,aPos.y,pos.x,pos.y);
//    linearMove = linear;
    targetPos = aPos;
}

- (void)moveAction{

//    float factor = 10.0;
    float screenW = [[TDeviceUtil sharedInstance] screenWidth];
    float offset = screenW/scale;
    float distanceX = pos.x-targetPos.x; 
    float distanceY = pos.y-targetPos.y;
    
//    isMoving = NO;
    
    if (distanceX != 0){
            if (-WORLD_MOVE_MIN_OFFSET<distanceX&&distanceX<WORLD_MOVE_MIN_OFFSET) {
                pos.x = targetPos.x;
                return;
            }
            
            if (distanceX<-offset) {
                pos.x = targetPos.x - offset;
            }else if(distanceX>offset){
                pos.x = targetPos.x + offset;
            }else{
                pos.x -= distanceX/WORLD_MOVE_STEP_NUM;
//                pos.x = roundf(pos.x);
            }       
    }
    
    if (distanceY!=0) {
            if (-WORLD_MOVE_MIN_OFFSET<distanceY&&distanceY<WORLD_MOVE_MIN_OFFSET) {
                pos.y = targetPos.y;
                return;
            }            
            
            if (distanceY<-offset) {
                pos.y = targetPos.y - offset;
            }else if(distanceY>offset){
                pos.y = targetPos.y + offset;
            }else{
                pos.y -= distanceY/WORLD_MOVE_STEP_NUM;
//                pos.y = roundf(pos.y);
            }       
        }

}




- (void)moveByFocusedActorCore{
    
    b2ActorController* actorC = [b2ActorController sharedInstance];
    b2ActorCore* focusedActorCore = [actorC currentActorCore];
//    b2MapEngine* mEngine = [b2MapEngine sharedInstance];
    
    if (!focusedActorCore) {
        return;
    }
    
    CGPoint corePos = [focusedActorCore pos];
//    LOG_DEBUG(@"focusedActorCore actorId -> %d  pos x -> %f  y -> %f",[focusedActorCore actorId],corePos.x,corePos.y);
    
    if (focusedActorCore) {
        [self moveTo:CGPointMake(roundf(corePos.x),roundf(corePos.y))];
    }   
    
//    LOG_DEBUG(@"moveByFocusedActorCore end ============================================");
}

#pragma mark - query section

- (void)query{
    
//    queryAABB.lowerBound.Set((pos.x)/PTM_RATIO, 0.0/PTM_RATIO );
//    queryAABB.upperBound.Set((pos.x+screenW/scale)/PTM_RATIO, (pos.y+screenH/scale)/PTM_RATIO );
    
//    rayCastInput.p1.Set(-5.0, 5.0f );
//    rayCastInput.p2.Set(7.0f, -4.0f );
//    rayCastInput.maxFraction = 1.0f;    
    
//    numInView = 0;
    
//    tree.Query(&cInterface, queryAABB);
//    b2_nullNode
    
//    LOG_DEBUG(@"query mid ............");
    
    //检测已经移出边界的actor
    
//    NSArray *arr = [treeUserDataDic allValues];
//    int num = [arr count];
//    b2Actor *actor;
//    for (int i=0;i<num;i++){
//        actor = [arr objectAtIndex:i];
//        if ([actor proxyId] == b2_nullNode) continue;
//
//        bool overlap = b2TestOverlap(queryAABB, [actor aabb]);
//        if(!overlap) [actor setOverlap:overlap]; //已经移出边界
//    }   
    
//     LOG_DEBUG(@"query end ............  numInView -> %d",numInView);
    
}



- (bool)QueryCallbackProcess:(int)proxyId{
//    b2Actor *actor = [self treeGetUserData:proxyId];
//    bool overlap = b2TestOverlap(queryAABB, [actor aabb]);
//    if(!overlap) [actor setOverlap:overlap]; 
//    LOG_DEBUG(@"proxyId -> %d", proxyId);
//    [actor setOverlap:true];
    
    numInView++;
    
    return YES;
}




//float32 RayCastCallback(const b2RayCastInput& input, int32 proxyId)
//{
//    Actor* actor = (Actor*)m_tree.GetUserData(proxyId);
//    
//    b2RayCastOutput output;
//    bool hit = actor->aabb.RayCast(&output, input);
//    
//    if (hit)
//    {
//        m_rayCastOutput = output;
//        m_rayActor = actor;
//        m_rayActor->fraction = output.fraction;
//        return output.fraction;
//    }
//    
//    return input.maxFraction;
//}

#pragma mark - properties




@end


bool b2WorldManagerCInterface::QueryCallback(int proxyId){
    
//    LOG_DEBUG(@"proxyId -> %d", proxyId);
    
    b2WorldManager *worldM  = [b2WorldManager sharedInstance];
    [worldM QueryCallbackProcess:proxyId];
    
    return true;
}
