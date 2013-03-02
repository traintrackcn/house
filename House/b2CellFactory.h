//
//  b2CellFactory.h
//  House
//
//  Created by Tao Yunfei on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "Tb2VecList.h"


@class b2Cell;
@class b2CellPool;
@class b2WorldManager;


@interface b2CellFactory : NSObject{
    b2CellPool *cellPool;
    
//    b2WeldJointDef weldJointDef;
//    b2PrismaticJointDef prismaticJointDef;
//    b2GearJointDef gearJointDef;
    
//    b2EdgeShape edgeShape;
    b2PolygonShape polygonShape;
    b2ChainShape chainShape;
    
    b2World *_world;
    b2WorldManager *_worldM;
}



+ (id)sharedInstance;


#pragma mark - create cell

- (b2Cell*)createPolygonCell:(CGPoint)aPos vertices:(Tb2VecList*)vertices density:(float)density friction:(float)friction restitution:(float)restitution;
- (b2Cell*)createCircleCell:(CGPoint)aPos raidus:(float)radius density:(float)density friction:(float)friction restitution:(float)restitution;
- (b2Cell*)createOrientedBoxCell:(CGPoint)aPos halfW:(float)halfW halfH:(float)halfH radian:(float)radian density:(float)density friction:(float)friction restitution:(float)restitution;
- (b2Cell *)createEdgeCell:(CGPoint)aPos p1:(CGPoint)p1 p2:(CGPoint)p2 density:(float)density friction:(float)friction restitution:(float)restitution;


#pragma mark - operate joint

- (b2Joint *)createWeldJoint:(b2Cell *)cell1 cell2:(b2Cell *)cell2 anchor:(b2Vec2)anchor;


- (void)destoryJoint:(b2Joint *)list;


#pragma mark - create fixture

- (b2FixtureDef)createFixtureDefWithDensity:(float)desity friction:(float)friction restitution:(float)restitution;




#pragma mark - properties

- (b2World *)world;
- (b2WorldManager *)worldM;

@end
