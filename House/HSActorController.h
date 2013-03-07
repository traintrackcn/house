//
//  b2ActorController.h
//  House
//
//  Created by Tao Yunfei on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Box2D.h"

@class HSActorBase;

@interface HSActorController : NSObject{

}

+ (id) sharedInstance;

- (void)focusActorById:(int)actorId;
- (void)unfocusActor;
- (HSActorBase *)focusedActor;
- (BOOL)bHasFocuedActor;


#pragma mark - make actor do actions
- (void)doForward;
- (void)doBackward;
- (void)doStop;




@end
