//
//  b2ActorCoreManager.h
//  House
//
//  Created by Tao Yunfei on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class b2ActorCore;
@class b2ActorManager;

@interface b2ActorCoreManager : NSObject{
    NSMutableArray* staticActorCoreList;
    NSMutableArray* dynamicActorCoreList;
    b2ActorManager* actorM;
}

+ (b2ActorCoreManager*)sharedInstance;

#pragma mark - modify core list
- (void)dynamicActorCoreListReplaceObjectAtIndex:(int)idx withObject:(b2ActorCore*)actorCore;
- (void)staticActorCoreListReplaceObjectAtIndex:(int)idx withObject:(b2ActorCore*)actorCore;
- (void)dynamicActorCoreListExchangeObjectAtIndex:(int)realIdx withObjectAtIndex:(int)idx;


// [dynamicActorCoreList exchangeObjectAtIndex:realCoreIdx withObjectAtIndex:coreIdx];
//[landActorCoreList replaceObjectAtIndex:i withObject:actorCore];   

#pragma mark -  in range /out of range operation

- (void)setStaticActorInRange:(int)idx;
- (void)setStaticActorOutOfRange:(int)idx;

- (void)setDynamicActorInRange:(int)idx;
- (void)setDynamicActorOutOfRange:(int)idx;

#pragma mark - get actor core
- (b2ActorCore*)getDynamicActorCore:(int)idx;

@end
