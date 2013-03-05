//
//  b2ActorController.m
//  House
//
//  Created by Tao Yunfei on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "b2ActorController.h"
#import "b2ActorCore.h"
#import "b2WorldManager.h"
#import "b2ActorManager.h"
#import "b2VehicleActor.h"
#import "SceneManager.h"

static b2ActorController* _sharedb2ActorController;

@implementation b2ActorController

//@synthesize nowIdx;


+ (id)sharedInstance{
    if (!_sharedb2ActorController) {
        _sharedb2ActorController = [[b2ActorController alloc] init];
    }
    return _sharedb2ActorController;
}


#pragma mark - actor core list

- (id)init{
    self = [super init];
    if (self) {
        actorCoreList = [[NSMutableArray alloc] initWithCapacity:MAX_CONTROLLABLE_ACTOR_COUNT];
        currentIdx = 0;
        count = 0;
    }
    return self;
}

- (void)add:(b2ActorCore *)actorCore{
    [actorCoreList addObject:actorCore];
    count++;
}


#pragma mark - actorCore

- (b2ActorCore*)currentActorCore{
    if (!count) {
        return nil;
    }
    return [actorCoreList objectAtIndex:currentIdx];
}

- (b2ActorCore*)nextActorCore{
    currentIdx++;
    if (currentIdx == count) {
        currentIdx = 0;
    }
    return [self currentActorCore];
}

- (b2ActorCore *)previousActorCore{
    currentIdx--;
    if (currentIdx<0) {
        currentIdx = count - 1;
    }
    return [self currentActorCore];
}


- (void)focusCurrent{
//    LOG_DEBUG(@"")
    [[self worldM] moveTo:[[self currentActorCore] glPos]];
}

- (void)focusNext{
    [[self worldM] moveTo:[[self nextActorCore] glPos]];
    
    LOG_DEBUG(@"focusNext");
}

- (void)focusPrevous{
    [[self worldM] moveTo:[[self previousActorCore] glPos]];
    
    LOG_DEBUG(@"focusPrevous");
}

#pragma mark - actor

- (b2Actor*)currentActor{
    b2ActorManager* actorM = [b2ActorManager sharedInstance];
    return [actorM getActor:[self currentActorCore]];
}

#pragma mark - do

- (void)doForward{
    b2VehicleActor* actor = (b2VehicleActor*)[self currentActor];
//    LOG_DEBUG(@"actor -> %@",[[actor class] description]);

    if (!actor)  return;
//    [actor lightUp];
    [actor forward];
    
    [actor lightUp];
}

- (void)doBackward{
    b2VehicleActor* actor = (b2VehicleActor*)[self currentActor];
    if (!actor)  return; 
    [actor backward];
}

- (void)doStop{
    b2Actor* actor = [self currentActor];
    if (!actor)  return;
}

#pragma mark - properties

- (b2WorldManager*)worldM{
    return [b2WorldManager sharedInstance];
}


#pragma mark - HMainLayerDelegate

- (void)layerTouchedTopLeft{
//    [self focusPrevous];
}

- (void)layerTouchedTopRight{
//    [self focusNext];
}

- (void)layerTouchedBottomLeft{
    
}

- (void)layerTouchedBottomRight{
    
}

@end
