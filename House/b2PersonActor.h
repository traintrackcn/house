//
//  b2PersonActor.h
//  House
//
//  Created by Tao Yunfei on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "b2Actor.h"

@class b2Cell;

@interface b2PersonActor : b2Actor{
    b2Cell* wheel1;
    b2Cell* wheel2;
    b2RevoluteJoint* engine;
}


- (void)stop;
- (void)forward;
- (void)backward;

@end
