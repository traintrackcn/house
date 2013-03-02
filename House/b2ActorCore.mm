//
//  b2ActorCore.m
//  House
//
//  Created by Tao Yunfei on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "b2ActorCore.h"

@implementation b2ActorCore

@synthesize type;
@synthesize pos;
@synthesize p1,p2;
@synthesize actorId;
@synthesize idx;
@synthesize isDynamic;
@synthesize angle;
@synthesize landOffset;
@synthesize z;
//@synthesize changeWithLight;

- (id)init{
    self = [super init];
    if (self) {
        isDynamic = NO;
//        changeWithLight = YES;
    }
    return self;
}

- (void)generateActorId{
    [self setActorId:RANDOM_INT];
}



- (void)reset{
    
    [self setActorId:0];

}

@end
