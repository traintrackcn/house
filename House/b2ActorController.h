//
//  b2ActorController.h
//  House
//
//  Created by Tao Yunfei on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class b2ActorCore;
@class b2WorldManager;
@class b2Actor;

@interface b2ActorController : NSObject{
    NSMutableArray* actorCoreList;
    int count;
    int currentIdx;
}

+ (id) sharedInstance;

- (void)add:(b2ActorCore*)actorCore;

- (b2ActorCore*)currentActorCore;
- (b2ActorCore*)nextActorCore;
- (b2ActorCore*)previousActorCore;

- (b2Actor*)currentActor;

- (void)focusCurrent;
- (void)focusNext;
- (void)focusPrevous;


// current focused
- (void)doForward;
- (void)doBackward;
- (void)doStop;

- (b2WorldManager*)worldM;

//@property (nonatomic, assign) int currentIdx;

@end
