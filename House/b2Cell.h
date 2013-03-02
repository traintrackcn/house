//
//  b2ActorCell.h
//  House
//
//  Created by Tao Yunfei on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Box2D.h"

@class b2WorldManager;

@interface b2Cell : NSObject{
    b2Body* body;
//    b2Fixture* fixture;
    
    b2World *_world;
    b2WorldManager *_worldM;
}


//- (void)create:(b2Vec2)aPos withFixtureDef:(b2FixtureDef)fixtureDef;
- (void)createProxy;

- (void)setType:(b2BodyType)type;
- (void)setFixtureDef:(b2FixtureDef)fixtureDef;

- (void)free;

- (b2World *)world;
- (b2WorldManager *)worldM;
- (b2AABB) aabb;
- (b2Body *)body;

@property (nonatomic, assign) int proxyId;
@property (nonatomic, assign) bool overlap;
@property (nonatomic, assign) CGPoint pos;
@property (nonatomic, assign) int idx;


@end
