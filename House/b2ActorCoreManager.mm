//
//  b2ActorCoreManager.m
//  House
//
//  Created by Tao Yunfei on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "b2ActorCoreManager.h"
#import "b2ActorCore.h"
#import "b2ActorManager.h"

static b2ActorCoreManager* _sharedb2ActorCoreManager;

@implementation b2ActorCoreManager

+ (b2ActorCoreManager *)sharedInstance{
    if (!_sharedb2ActorCoreManager) {
        _sharedb2ActorCoreManager = [[b2ActorCoreManager alloc] init];
    }
    return _sharedb2ActorCoreManager;
}

#pragma mark - init

- (id)init{
    self = [super init];
    if (self) {
        
        actorM = [b2ActorManager sharedInstance];
        
        landActorCoreList = [[NSMutableArray alloc] initWithCapacity:MAX_TERRAIN_KEY_COUNT];
        staticActorCoreList = [[NSMutableArray alloc] initWithCapacity:MAX_TERRAIN_KEY_COUNT];
        dynamicActorCoreList = [[NSMutableArray alloc] initWithCapacity:MAX_TERRAIN_KEY_COUNT];
        
        //fill used slot
        for (int i=0; i<MAX_TERRAIN_KEY_COUNT; i++) {
            [landActorCoreList addObject:[NSNull null]];
            [staticActorCoreList addObject:[NSNull null]];
            [dynamicActorCoreList addObject:[NSNull null]];
        }       
        
    }
    return self;
}

#pragma mark - get actor core

- (b2ActorCore*)getDynamicActorCore:(int)idx{
    return [dynamicActorCoreList objectAtIndex:idx];
}



#pragma mark - modify actorCorelist elements

- (void)landActorCoreListReplaceObjectAtIndex:(int)idx withObject:(b2ActorCore *)actorCore{
    [landActorCoreList replaceObjectAtIndex:idx withObject:actorCore];
}

- (void)dynamicActorCoreListReplaceObjectAtIndex:(int)idx withObject:(b2ActorCore *)actorCore{
    [dynamicActorCoreList replaceObjectAtIndex:idx withObject:actorCore];
}

- (void)staticActorCoreListReplaceObjectAtIndex:(int)idx withObject:(b2ActorCore *)actorCore{
    [staticActorCoreList replaceObjectAtIndex:idx withObject:actorCore];
}

- (void)dynamicActorCoreListExchangeObjectAtIndex:(int)realIdx withObjectAtIndex:(int)idx{
    [dynamicActorCoreList exchangeObjectAtIndex:realIdx withObjectAtIndex:idx];
}

#pragma mark -  in range /out of range operation

- (void)setLandActorInRange:(int)idx{
    
    b2ActorCore* core = [landActorCoreList objectAtIndex:idx];
    //    LOG_DEBUG(@"core==null   %d",![core isEqual:[NSNull null]]);
    if (![core isEqual:[NSNull null]]) {
        //        LOG_DEBUG(@"create land %d in range ",idx);
        
        [actorM createActor:core];
    }
}

- (void)setLandActorOutOfRange:(int)idx{
    
    b2ActorCore* core = [landActorCoreList objectAtIndex:idx];
    
    if (![core isEqual:[NSNull null]]) {
        //        LOG_DEBUG(@"remove land %d in range ",idx);
        [actorM removeActor:core];
    }
}

//设定需要创建的actor id
- (void)setStaticActorInRange:(int)idx{
    
    b2ActorCore* core = [staticActorCoreList objectAtIndex:idx];
    //    LOG_DEBUG(@"core==null   %d",![core isEqual:[NSNull null]]);
    if (![core isEqual:[NSNull null]]) {
        [actorM createActor:core];
    }
}


//设定需要销毁的actor id
- (void)setStaticActorOutOfRange:(int)idx{
    
    b2ActorCore* core = [staticActorCoreList objectAtIndex:idx];
    
    if (![core isEqual:[NSNull null]]) {
        [actorM removeActor:core];
    }
}

- (void)setDynamicActorInRange:(int)idx{
    b2ActorCore* core = [dynamicActorCoreList objectAtIndex:idx];
    if (![core isEqual:[NSNull null]]) {
        
        //        LOG_DEBUG(@"create dynamic actor -> %d",[core idx]);
        
        [actorM createActor:core];
    }  
}

- (void)setDynamicActorOutOfRange:(int)idx{
    b2ActorCore* core = [dynamicActorCoreList objectAtIndex:idx];
    
    //    LOG_DEBUG(@"setDynamicActorOutOfRange core -> %@",core);
    
    if (![core isEqual:[NSNull null]]) {
        //        LOG_DEBUG(@"before remove dynamic core actorId-> %d",[core actorId]);
        [actorM removeActor:core];
        //        LOG_DEBUG(@"after remove dynamic core actorId -> %d",[core actorId]);
    }
}


@end
