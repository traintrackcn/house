//
//  TerrainUtil.m
//  House
//
//  Created by Tao Yunfei on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define kSegmentW 5.0

#import "HSMapEngine.h"
#import "cocos2d.h"
#import "HSWorldManager.h"
#import "HSActorManager.h"
#import "HSActorController.h"
#import "HSActorBase.h"
#import "HSActorDescriptionManager.h"


@interface HSMapEngine() {
    TFloatList* keyXList;   //static actor/ground x值
    TFloatList* keyYList; // actor/ground 对应key的 y值
}

@end


@implementation HSMapEngine

static HSMapEngine* _sharedb2MapEngine;

#pragma mark - static method

+ (HSMapEngine*)sharedInstance{
    if (!_sharedb2MapEngine) {
        _sharedb2MapEngine = [[HSMapEngine alloc] init];
    }
    return _sharedb2MapEngine;
}


#pragma mark - init

- (id)init{
    self = [super init];
    if (self) {

        keyXList = [[TFloatList alloc] initWithSize:MAX_TERRAIN_KEY_COUNT];
        keyYList = [[TFloatList alloc] initWithSize:MAX_TERRAIN_KEY_COUNT];
        
        //gen terrains
        
        [[HSActorBase alloc] initWithKey:kActorDescriptionTerrain1];
        
//        for ( int i=0; i<5000; i++) {
        
        
        HSActorBase *actor = [[HSActorBase alloc] initWithKey:kActorDescriptionTestCar];
        [[HSActorController sharedInstance] focusActorById:[actor actorId]];

//        [[HSActorManager sharedInstance] removeValueById:[actor actorId]];
//        }
    }
    return self;
}






@end
