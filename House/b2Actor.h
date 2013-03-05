//
//  Actor.h
//  House
//
//  Created by Tao Yunfei on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Box2D.h"
#import "TIntList.h"
#import "Tb2JointList.h"
#import "b2ActorEnum.h"
#import "b2ActorCore.h"
#import "HSDynamicTreeManager.h"

@class b2WorldManager;
@class b2Cell;
@class b2CellFactory;
//@class TIntList;
//@class b2ActorCore;
//@class CellSkinPool;
//@class CellSkin;
@class b2CellPool;
@class b2ActorPoseManager;
@class b2ActorCoreManager;

@interface b2Actor : NSObject{

    b2WorldManager* _worldM;
    b2World* _world;    
    
    TIntList* cellIdxList;
    TIntList* cellSkinIdxList;
    Tb2JointList* jointList;
    b2Filter filter;
    b2ActorCore* core;
    
//    CellSkinPool* cellSkinPool;
    b2CellPool* cellPool;
    b2CellFactory* cellFactory;
    b2ActorPoseManager* actorPoseM;
    b2ActorCoreManager* actorCoreM;
        
    
    int poseIdx;
    int poseCount;
}


@property (nonatomic, assign) BOOL overlap;
@property (nonatomic, assign) b2AABB aabb;

- (id)initWithCore:(b2ActorCore*)aCore;
- (void)create;
- (void)free;
- (b2ActorCore*)core;

- (b2World*)world;
- (b2WorldManager*)worldM;


- (CGPoint)convertToLayerPos:(b2Vec2)v;
- (float)convertToLayerAngle:(float)radian;
- (float)convertTob2Radian:(float)angle;

- (b2Cell*)baseCell;

- (void)update;

- (CGPoint)glPos;

- (void)setFilterCategory:(int)category mask:(int)mask;
- (b2Body*)getBodyAtIdx:(int)idx;

- (void)lightUp;
- (void)lightOff;

- (void)appendCell:(b2Cell*)cell filter:(b2Filter)aFilter type:(b2BodyType)type;


- (b2RevoluteJoint*)createRevoluteJointAt:(CGPoint)aPos cell1:(b2Cell*)cell1 cell2:(b2Cell*)cell2 enableMotor:(bool)enableMotor             enableLimit:(bool)enableLimit upperAngle:(float)upperAngle lowerAngle:(float)lowerAngle;

#pragma mark - operate pose
- (void)nextPose;
- (void)previousPose;



@end
