//
//  b2ActorManager.m
//  House
//
//  Created by Tao Yunfei on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HSActorManager.h"
#import "HSActorBase.h"

@interface HSActorManager(){
//    NSMutableDictionary *data;
    NSMutableArray *list;
}

@end


static HSActorManager* _sharedb2ActorManager; 

@implementation HSActorManager


+ (HSActorManager *)sharedInstance{
    if (!_sharedb2ActorManager) {
        _sharedb2ActorManager = [[HSActorManager alloc] init];
    }
    return _sharedb2ActorManager;
}


- (id)init{
    self = [super init];
    if (self) {
        list = [NSMutableArray arrayWithCapacity:20000];
        for (int i=0; i<20000; i++) {
            [list addObject:[NSNull null]];
        }
    }
    return self;
}


- (void)setValue:(HSActorBase *)actor{
    int idx = [actor actorId];
    if (idx == -1) {
        LOG_ERROR(@"actor won't have any fixture named \"aabb\" , then actor Id will be -1 and will not be added");
        return;
    }
//    LOG_DEBUG(@"");
    LOG_DEBUG(@"========================\nactor %d was created\n========================", idx);
//    LOG_DEBUG(@"");
    
    [list replaceObjectAtIndex:idx withObject:actor];
}

- (HSActorBase *)getValueById:(int)actorId{
    if (actorId == -1) return nil;
    int idx = actorId;
    HSActorBase *actor = [list objectAtIndex:idx];
    if ([actor isEqual:[NSNull null]]) {
        return nil;
    }
    return actor;
}

- (void)removeValueById:(int)actorId{
    int idx = actorId;
    HSActorBase *actor = [self getValueById:actorId];
    if (actor) {
        [actor free];
    }
    
    [list replaceObjectAtIndex:idx withObject:[NSNull null]];

}




@end
