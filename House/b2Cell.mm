//
//  b2ActorCell.m
//  House
//
//  Created by Tao Yunfei on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "b2Cell.h"
#import "b2WorldManager.h"


@interface b2Cell()
- (void)destoryBody;
- (void)destoryFixture;
@end

@implementation b2Cell

@synthesize proxyId,overlap,pos,idx;
//@synthesize body;


- (id)init{
    self = [super init];
    if (self) {
        b2BodyDef bodyDef;
        body = [self world]->CreateBody(&bodyDef);
    }
    return self;
}


#pragma mark - create session


- (void)setFixtureDef:(b2FixtureDef)fixtureDef{
    [self destoryFixture];
    body->CreateFixture(&fixtureDef);
}

- (void)setPos:(CGPoint)aPos{
    pos = aPos;
    body->SetTransform(b2Vec2(pos.x/PTM_RATIO,pos.y/PTM_RATIO), 0.0);
}

- (void)setType:(b2BodyType)type{
    if (body) {
        body->SetType(type);
    }
}



#pragma mark - destory session

- (void)free{
//    body->SetTransform(b2Vec2(10.0,10.0), 0.0);
    [self destoryFixture];
    [self setType:b2_staticBody];
//    body->ResetMassData();
//    body->SetTransform(b2Vec2(10.0,10.0), M_PI/2.0);

//    [[self worldM] treeDeleteProxy:<#(int)#>]
}

- (void)destoryFixture{
    b2Fixture* fixture = body->GetFixtureList();
    if (fixture) {
        body->DestroyFixture(fixture);
    }    
}

- (void)destoryBody{
    if (body) {
        [self world]->DestroyBody(body);
    }
}

#pragma mark - properties

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


- (b2AABB)aabb{

    b2AABB nilAABB;
    b2Fixture *fixture = body->GetFixtureList();
    
    if (fixture) {
        return fixture->GetAABB(0);
    }
    //Yeah every fixture has 1 to m child fixtures. For fixtures with a single child (circle, polygon, edge), the index is zero. For chain shapes, the index is 0 to m-1.
    
    return nilAABB;
    
    //    for (fixture = body->GetFixtureList(); fixture; fixture = fixture->GetNext()){
    //        if (fixture) {
    //            return fixture->GetAABB(0);
    //        }
    //    }        
    
}

- (b2Body *)body{
    return body;
}

@end
