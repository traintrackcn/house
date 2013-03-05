//
//  b2TerrainActor.m
//  House
//
//  Created by Tao Yunfei on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "b2LandActor.h"
#import "b2CellFactory.h"
#import "b2MapEngine.h"
#import "b2Cell.h"

@interface b2LandActor(){
    b2AABB aabb;
}


@end

@implementation b2LandActor

- (id)initWithCore:(b2ActorCore *)aCore{
    self = [super initWithCore:aCore];
    if (self) {
        [self setFilterCategory:b2ActorCategoryLand mask:b2ActorMaskLand];
        [self create];
    }
    
    return self;
}


- (void)create{

    b2Vec2 v1,v2;
    CGPoint p1 = [core p1];
    CGPoint p2 = [core p2];
    CGPoint pos = [core glPos];
    v1.Set(p1.x/PTM_RATIO,p1.y/PTM_RATIO);
    v2.Set(p2.x/PTM_RATIO,p2.y/PTM_RATIO);
    
    b2EdgeShape shape;
    shape.Set(v1, v2);

    b2FixtureDef fixtureDef;
    fixtureDef.density = 1.0;
    fixtureDef.friction = 0.3;
    fixtureDef.restitution = 0.0;
  
    
    b2BodyDef bodyDef;
    b2Body *body = [self world]->CreateBody(&bodyDef);
    body->SetType(b2_staticBody);
    
    fixtureDef.shape = &shape;
    body->CreateFixture(&fixtureDef);
    body->SetTransform(b2Vec2(pos.x/PTM_RATIO,pos.y/PTM_RATIO), 0.0);

    b2AABB nilAABB;
    b2Fixture *fixture = body->GetFixtureList();
    
    if (fixture) {
        self.aabb = fixture->GetAABB(0);
        
        LOG_DEBUG(@"aabb %f %f", [self aabb].upperBound.x,[self aabb].upperBound.y);
         [[HSDynamicTreeManager sharedInstance] createProxy:[self aabb] userData:nil];
    }
    
    
    
//   
    
}





@end
