//
//  b2ActorManager.m
//  House
//
//  Created by Tao Yunfei on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "b2ActorManager.h"
#import "b2Actor.h"
#import "b2TreeActor.h"
#import "b2VehicleActor.h"
#import "b2ActorCore.h"
#import "b2LandActor.h"
#import "b2PersonActor.h"

static b2ActorManager* _sharedb2ActorManager; 

@implementation b2ActorManager


+ (b2ActorManager*)sharedInstance{
    if (!_sharedb2ActorManager) {
        _sharedb2ActorManager = [[b2ActorManager alloc] init];
    }
    return _sharedb2ActorManager;
}


- (id)init{
    self = [super init];
    if (self) {
        staticActorDic = [[NSMutableDictionary alloc] initWithCapacity:500];
        dynamicActorDic = [[NSMutableDictionary alloc] initWithCapacity:500];
    }
    return self;
}


- (void)createActor:(b2ActorCore*)actorCore{

    int actorId = [actorCore actorId];
    NSNumber* key;
    
    
    if (actorId) return; //actorId==0  没创建 actorId!=0 已经创建

    b2Actor* actor;
    
    int type = [actorCore type];    
    switch (type) {
        case b2ActorTypeTree:
            actor = [[b2TreeActor alloc] initWithCore:actorCore];
            break;
        case b2ActorTypeCar:
            actor = [[b2VehicleActor alloc] initWithCore:actorCore];
            break;
        case b2ActorTypeLand:
            actor = [[b2LandActor alloc] initWithCore:actorCore];
            break;
        case b2ActorTypePerson:
            actor = [[b2PersonActor alloc] initWithCore:actorCore];
            break;
    }
    
    if (!actor)  LOG_ERROR(@"create actor failed");
    actorId = [actorCore actorId];
    key = [NSNumber numberWithInt:actorId];
    
//    LOG_DEBUG(@"create actor id -> %d   key -> %@",actorId,key);
    
    if ([actorCore isDynamic]) {
        [dynamicActorDic setObject:actor forKey:key];
    }else {
        [staticActorDic setObject:actor forKey:key];
    }
}


- (void)removeActor:(b2ActorCore*)actorCore{
    int actorId = [actorCore actorId];
    if (!actorId) return;
    NSNumber* key = [NSNumber numberWithInt:actorId];
    b2Actor* actor ;
    
    if ([actorCore isDynamic]) {
//        LOG_DEBUG(@"removeActor actor key -> %@  actorId -> %d",key,actorId);
        actor = [dynamicActorDic objectForKey:key];
//        LOG_DEBUG(@"removeActor actor -> %@  actorCore -> %@",actor,[actor core]);
        if (actor) [actor free];        
        [dynamicActorDic removeObjectForKey:key];
    }else {
        actor = [staticActorDic objectForKey:key];
//        LOG_DEBUG(@"removeActor actor -> %@",actor);
        if (actor) [actor free];
        [staticActorDic removeObjectForKey:key];
    }
    
    
}

- (b2Actor*)getActor:(b2ActorCore*)actorCore{
    NSNumber* key = [NSNumber numberWithInt:[actorCore actorId]];
//    LOG_DEBUG(@"getActor key -> %@",key);
    if ([actorCore isDynamic]) {
        return [dynamicActorDic objectForKey:key];
    }else {
        return [staticActorDic objectForKey:key];
    }
    
}


- (NSMutableDictionary *)dynamicActorDic{
    return dynamicActorDic;
}

- (int)count{
    return ([dynamicActorDic count]+[staticActorDic count]);
}


@end
