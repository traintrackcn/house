//
//  b2ActorController.m
//  House
//
//  Created by Tao Yunfei on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HSActorController.h"
#import "HSWorldManager.h"
#import "HSActorManager.h"
#import "HSActorBase.h"

static HSActorController* _sharedb2ActorController;

@interface HSActorController() {
    int focusedActorId;
}

@end

@implementation HSActorController

+ (id)sharedInstance{
    if (!_sharedb2ActorController) {
        _sharedb2ActorController = [[HSActorController alloc] init];
    }
    return _sharedb2ActorController;
}


#pragma mark - actor core list

- (id)init{
    self = [super init];
    if (self) {
        focusedActorId = -1;
    }
    return self;
}


#pragma mark -

- (void)focusActorById:(int)actorId{
    focusedActorId = actorId;
}

- (void)unfocusActor{
    focusedActorId = -1;
}

- (HSActorBase *)focusedActor{
    HSActorBase *actor = [[HSActorManager sharedInstance] getValueById:focusedActorId];
    if (!actor) focusedActorId = -1;
    
    return  actor;
}

- (BOOL)bHasFocuedActor{
    if (focusedActorId == -1) {
        return NO;
    }
    return YES;
}

#pragma mark - make actor do action

- (void)doForward{
//    b2VehicleActor* actor = (b2VehicleActor*)[self currentActor];
////    LOG_DEBUG(@"actor -> %@",[[actor class] description]);
//
//    if (!actor)  return;
////    [actor lightUp];
//    [actor forward];
//    
//    [actor lightUp];
}

- (void)doBackward{
//    b2VehicleActor* actor = (b2VehicleActor*)[self currentActor];
//    if (!actor)  return; 
//    [actor backward];
}

- (void)doStop{
//    b2Actor* actor = [self currentActor];
//    if (!actor)  return;
}



@end
