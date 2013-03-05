//
//  Actor.m
//  House
//
//  Created by Tao Yunfei on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "b2Actor.h"
#import "b2WorldManager.h"
#import "b2Cell.h"
#import "b2CellFactory.h"
#import "TIntList.h"
#import "b2CellPool.h"
#import "b2ActorCoreManager.h"


@interface b2Actor()


@end


@implementation b2Actor

#pragma mark - init session

- (id)init{
    self = [super init];
    if (self) {
        int size = 200;
        cellIdxList = [[TIntList alloc] initWithSize:size];
        cellSkinIdxList = [[TIntList alloc] initWithSize:size];
        jointList = [[Tb2JointList alloc] initWithSize:size];

        cellFactory = [b2CellFactory sharedInstance];
        cellPool = [b2CellPool sharedInstance];
    
        actorCoreM = [b2ActorCoreManager sharedInstance];
        
        poseIdx = 0;
        poseCount = 0;
        
    }
    return self;
}


- (id)initWithCore:(b2ActorCore *)aCore{
    self = [self init];
    if (self) {
        core = aCore;
        [core generateActorId];
    }
    return self;
}

#pragma mark - create session

- (void)create{

}

- (void)update{
    
}


- (CGPoint)glPos{
    return CGPointMake(0.0, 0.0);
}


#pragma mark - properties

- (b2ActorCore *)core{
    return core;
}


- (b2Cell *)baseCell{
    return nil;
}

- (CGPoint)convertToLayerPos:(b2Vec2)v{
    return CGPointMake(v.x*PTM_RATIO, v.y*PTM_RATIO);
}



- (float)convertToLayerAngle:(float)radian{
    return (radian/-M_PI)*180;
}

- (float)convertTob2Radian:(float)angle{
    return (angle*-M_PI)/180;
}

- (b2World *)world{
    if (!_world) {
        _world = [b2WorldManager sharedb2World];
    }
    return _world;
}

- (b2WorldManager *)worldM{
    if (!_worldM) {
        _worldM = [b2WorldManager sharedInstance];
    }
    return _worldM;
}

//- (b2AABB)aabb{
//    //    b2Fixture *fixture = body->GetFixtureList();
//    //    b2Fixture* fixture ;
//    b2AABB nilAABB;
//    
//    //Yeah every fixture has 1 to m child fixtures. For fixtures with a single child (circle, polygon, edge), the index is zero. For chain shapes, the index is 0 to m-1.
//    
//    return nilAABB;
//}

- (void)setFilterCategory:(int)category mask:(int)mask{
    filter.categoryBits = category;
    filter.maskBits = mask;
}

#pragma mark - destory

- (void)free{
    
//    LOG_DEBUG(@"destory core actorId -> %d",[core actorId]);
    
    //release reset
    [core reset];
//    core = nil;
 
    //destory joint
    for (int i=0; i<[jointList count]; i++) {
        b2Joint *joint = [jointList getValue:i];
        [self world]->DestroyJoint(joint);
    }  
    
    //free cell
//    b2CellPool* cellPool = [b2CellPool sharedInstance];
    [cellPool setFreeIdxList:cellIdxList];
    

    
    [cellIdxList free];
    [cellSkinIdxList free];
    [jointList free];
}


#pragma mark - light control

- (void)lightUp{
    
}

- (void)lightOff{
    
}

#pragma mark - update 

//- (void)update

- (b2Body*)getBodyAtIdx:(int)idx{
    b2Cell* cell = [cellPool getValue:[cellIdxList getValue:idx]];
    
    return [cell body];    
}

#pragma mark - operate cell

- (void)appendCell:(b2Cell*)cell filter:(b2Filter)aFilter type:(b2BodyType)type{
    [cell setType:type];
    [cell body]->GetFixtureList()->SetFilterData(aFilter);
    [cellIdxList addValue:[cell idx]];
}


#pragma mark - operate joint

- (b2RevoluteJoint*)createRevoluteJointAt:(CGPoint)aPos cell1:(b2Cell*)cell1 cell2:(b2Cell*)cell2 enableMotor:(bool)enableMotor             enableLimit:(bool)enableLimit upperAngle:(float)upperAngle lowerAngle:(float)lowerAngle{
    b2RevoluteJointDef jd;
    b2RevoluteJoint* jt;
    
    if (enableMotor) {
        jd.enableMotor = true;
        jd.maxMotorTorque = 100;
    }
    
    if (enableLimit) {
        jd.enableLimit= true;
        jd.upperAngle = upperAngle;
        jd.lowerAngle = lowerAngle;
    }
    
    
    
    jd.collideConnected = false;
    jd.Initialize([cell1 body], [cell2 body], b2Vec2(aPos.x/PTM_RATIO,aPos.y/PTM_RATIO));
    jt = (b2RevoluteJoint*)[self world]->CreateJoint(&jd);
    [jointList addValue:jt];    
    return jt;
}


#pragma mark - operate pose

- (void)nextPose{
    if (poseCount==0) return;
    if (poseIdx+1== poseCount) {
        poseIdx = 0;
        return;
    }
    
    poseIdx++;
    
}

- (void)previousPose{
    if (poseCount==0) return;
    if (poseIdx-1<0) {
        poseIdx = poseCount-1;
        return;
    }
    
    poseIdx --;
}

@end
