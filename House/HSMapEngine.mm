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
        float startGlX = 0;
        float startGlY = 0;
        b2Filter filterGround;
        filterGround.categoryBits  = b2ActorCategoryGround;
        filterGround.maskBits = b2ActorMaskGround;
        for (int i=0; i<40; i++) {
            float glX = startGlX + 320*i;
            float glY = startGlY + 64*i;
            glY = 0;
            [HSActorBase instanceWithKey:kActorDescriptionTerrain1 glPosOffset:CGPointMake(glX, glY) filter:filterGround];
        }

//        [HSActorBase instanceWithKey:kActorDescriptionTerrain1 glPosOffset:CGPointMake(0, 0.0f) filter:filterGround];
//        [HSActorBase instanceWithKey:kActorDescriptionTerrain1 glPosOffset:CGPointMake(320, 64.0f) filter:filterGround];
//        for ( int i=0; i<5000; i++) {
        
        b2Filter filterVeihcle;
        filterVeihcle.categoryBits  = b2ActorCategoryVehicle;
        filterVeihcle.maskBits = b2ActorMaskVehicle;
        HSActorBase *actor = [HSActorBase instanceWithKey:kActorDescriptionCar1 glPosOffset:CGPointMake(100.0f,100.0f) filter:filterVeihcle];
        [[HSActorController sharedInstance] focusActorById:[actor actorId]];

//        [[HSActorManager sharedInstance] removeValueById:[actor actorId]];
//        }
    }
    return self;
}






@end
