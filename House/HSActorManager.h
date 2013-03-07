//
//  b2ActorManager.h
//  House
//
//  Created by Tao Yunfei on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Box2D.h"


@class HSActorBase;
@interface HSActorManager : NSObject{

}

+ (HSActorManager *)sharedInstance;


- (void)setValue:(HSActorBase *)actor;
- (HSActorBase *)getValueById:(int)actorId;

- (void)removeValueById:(int)actorId;

@end
