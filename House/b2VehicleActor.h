//
//  b2VehicleActor.h
//  House
//
//  Created by Tao Yunfei on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "b2Actor.h"

@class CellSkin;

@interface b2VehicleActor : b2Actor{
    b2RevoluteJoint* engine1;
    b2RevoluteJoint* engine2;
    
    CellSkin* wheel1Skin;
    CellSkin* wheel2Skin;
    CellSkin* carBodySkin;
    
    b2Cell* chassisCell;
}


- (b2Body*)chassisBody;


- (void)stop;
- (void)forward;
- (void)forwardAction;
- (void)backward;
- (void)backwardAction;

@end
