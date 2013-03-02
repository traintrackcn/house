//
//  b2CellFactory.m
//  House
//
//  Created by Tao Yunfei on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "b2WorldManager.h"
#import "b2CellFactory.h"
#import "b2CellPool.h"
#import "b2Cell.h"

static b2CellFactory *_sharedB2CellFactory;

@interface b2CellFactory()
- (b2Cell*)createCell:(CGPoint)aPos shape:(b2Shape *)shape density:(float)density friction:(float)friction restitution:(float)restitution;
- (void)modifyCell:(int)cellIdx shape:(b2Shape*)shape density:(float)density friction:(float)friction restitution:(float)restitution;
- (void)modifyCell:(int)cellIdx pos:(CGPoint)aPos;


#pragma mark - create shape
- (b2EdgeShape)createEdgeShape:(CGPoint)p1 p2:(CGPoint)p2;

//- (b2ChainShape)createChainShape:(Tb2VecList*)vertices;
//- (void)modifyChainCell:(int)cellIdx vertices:(Tb2VecList*)vertices density:(float)density friction:(float)friction restitution:(float)restitution;

- (b2PolygonShape)createPolygonShape:(CGPoint *)pArr pCount:(int)pCount;
- (b2PolygonShape)createOrientedBoxShapeWithHalfW:(float)halfW halfH:(float)halfH radian:(float)radian;
- (b2CircleShape)createCircleShape:(float)radius;
@end


@implementation b2CellFactory

- (id)init{
    self = [super init];
    if (self) {
        cellPool = [b2CellPool sharedInstance];
    }
    return self;
}

+ (id)sharedInstance{
    if (!_sharedB2CellFactory) {
        _sharedB2CellFactory = [[b2CellFactory alloc] init];
    }
    return _sharedB2CellFactory;
}


#pragma mark - create cell

- (b2Cell*)createPolygonCell:(CGPoint)aPos vertices:(Tb2VecList*)vertices density:(float)density friction:(float)friction restitution:(float)restitution{
    b2PolygonShape shape = [self createPolygonShape:vertices];
    return [self createCell:aPos shape:&shape density:density friction:friction restitution:restitution];
}

- (b2Cell*)createOrientedBoxCell:(CGPoint)aPos halfW:(float)halfW halfH:(float)halfH radian:(float)radian density:(float)density friction:(float)friction restitution:(float)restitution{
    b2PolygonShape shape = [self createOrientedBoxShapeWithHalfW:halfW halfH:halfH radian:radian];
    return [self createCell:aPos shape:&shape density:density friction:friction restitution:restitution];
}

- (b2Cell*)createCircleCell:(CGPoint)aPos raidus:(float)radius density:(float)density friction:(float)friction restitution:(float)restitution{
    b2CircleShape shape = [self createCircleShape:radius];
    return [self createCell:aPos shape:&shape density:density friction:friction restitution:restitution];   
}

- (b2Cell *)createEdgeCell:(CGPoint)aPos p1:(CGPoint)p1 p2:(CGPoint)p2 density:(float)density friction:(float)friction restitution:(float)restitution{
    b2EdgeShape shape = [self createEdgeShape:p1 p2:p2];
    return [self createCell:aPos shape:&shape density:density friction:friction restitution:restitution];    
}


#pragma mark - create / modify cell base

- (b2Cell*)createCell:(CGPoint)aPos shape:(b2Shape *)shape density:(float)density friction:(float)friction restitution:(float)restitution{
    b2FixtureDef fixtureDef = [self createFixtureDefWithDensity:density friction:friction restitution:restitution];
    b2Cell* cell = [cellPool pick];
//    LOG_DEBUG(@"cellPool -> %@",cellPool);
    fixtureDef.shape = shape;
    [cell setFixtureDef:fixtureDef];
    [cell setPos:aPos];
    return cell;
}

- (void)modifyCell:(int)cellIdx shape:(b2Shape*)shape density:(float)density friction:(float)friction restitution:(float)restitution{
    b2FixtureDef fixtureDef = [self createFixtureDefWithDensity:density friction:friction restitution:restitution];
    b2Cell* cell = [cellPool getValue:cellIdx];
    fixtureDef.shape = shape;
    [cell setFixtureDef:fixtureDef];    
}

- (void)modifyCell:(int)cellIdx pos:(CGPoint)aPos{
    b2Cell* cell = [cellPool getValue:cellIdx];
    [cell setPos:aPos];
}

#pragma mark - createfixture

- (b2FixtureDef)createFixtureDefWithDensity:(float)desity friction:(float)friction restitution:(float)restitution{
    b2FixtureDef fixtureDef;
    fixtureDef.density = desity;
    fixtureDef.friction = friction;
    fixtureDef.restitution = restitution;    
    return fixtureDef;
}

#pragma mark - create joint

- (b2Joint *)createWeldJoint:(b2Cell *)cell1 cell2:(b2Cell *)cell2 anchor:(b2Vec2)anchor{
    b2WeldJointDef jointDef;
    jointDef.Initialize([cell1 body], [cell2 body], b2Vec2(anchor.x/PTM_RATIO,anchor.y/PTM_RATIO));
    return [self world]->CreateJoint(&jointDef);
}


//- (b2Joint *)createRevoluteJointCell1:(b2Cell *)cell1 cell2:(b2Cell *)cell2 anchor:(b2Vec2)anchor isMotor:(bool)isMortor{
//    b2RevoluteJointDef
//    b2WeldJointDef jointDef;
//    jointDef.Initialize([cell1 body], [cell2 body], b2Vec2(anchor.x/PTM_RATIO,anchor.y/PTM_RATIO));
//    return [self world]->CreateJoint(&jointDef);
//}


- (void)destoryJoint:(b2Joint *)list num:(int)num{
    for (int i=0; i<num; i++) {
        [self world]->DestroyJoint(&list[i]);
    }
}


#pragma mark - create shape


- (b2EdgeShape)createEdgeShape:(CGPoint)p1 p2:(CGPoint)p2{
//    b2EdgeShape shape;
    b2Vec2 v1,v2;
    v1.Set(p1.x/PTM_RATIO,p1.y/PTM_RATIO);
    v2.Set(p2.x/PTM_RATIO,p2.y/PTM_RATIO);

    b2EdgeShape shape;
    shape.Set(v1, v2);
    return shape;
}

//- (b2ChainShape)createChainShape:(Tb2VecList*)vertices{
//    b2ChainShape shape;
//    shape.CreateChain([vertices content], [vertices count]);
//    return shape;
//}

//- (void)makeChainShape:(Tb2VecList*)vertices{
//    LOG_DEBUG(@"vertices count -> %d",[vertices count]);
//    
//    chainShape.CreateChain([vertices content], [vertices count]);
//}

- (b2PolygonShape)createPolygonShape:(Tb2VecList*)vertices{
    b2PolygonShape shape;
    shape.Set([vertices content], [vertices count]);
    return shape;    
}

- (b2PolygonShape)createOrientedBoxShapeWithHalfW:(float)halfW halfH:(float)halfH radian:(float)radian{
    b2PolygonShape shape;
    shape.SetAsBox(halfW/PTM_RATIO, halfH/PTM_RATIO, b2Vec2(0.0,0.0), radian);
    return shape;
}

- (b2CircleShape)createCircleShape:(float)radius{
    b2CircleShape shape;
    shape.m_radius = radius/PTM_RATIO;
    return shape;
}

#pragma mark - usual properits

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


@end
