//
//  b2ActorManager.h
//  House
//
//  Created by Tao Yunfei on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"

@class b2Actor;
@class b2ActorCore;

@interface b2ActorManager : NSObject{
    NSMutableDictionary* staticActorDic;
    NSMutableDictionary* dynamicActorDic;
}

+ (b2ActorManager*)sharedInstance;
- (void)createActor:(b2ActorCore*)actorCore;
- (void)removeActor:(b2ActorCore*)actorCore;
- (b2Actor*)getActor:(b2ActorCore*)actorCore;

- (NSMutableDictionary*)dynamicActorDic;

- (int)count;

@end
