//
//  TerrainUtil.m
//  House
//
//  Created by Tao Yunfei on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define kSegmentW 5.0

#import "b2MapEngine.h"
#import "cocos2d.h"
#import "b2WorldManager.h"
#import "b2LandActor.h"
#import "b2ActorManager.h"
#import "b2CellFactory.h"
#import "b2ActorCore.h"
#import "b2ActorController.h"
#import "b2ActorCoreManager.h"
#import "b2ActorEnum.h"


@interface b2MapEngine() {
    TFloatList* keyXList;   //static actor/ground x值
    TFloatList* keyYList; // actor/ground 对应key的 y值
    
    b2ActorCoreManager* actorCoreM;
}

@end


@implementation b2MapEngine

static b2MapEngine* _sharedb2MapEngine;

#pragma mark - static method

+ (b2MapEngine*)sharedInstance{
    if (!_sharedb2MapEngine) {
        _sharedb2MapEngine = [[b2MapEngine alloc] init];
    }
    return _sharedb2MapEngine;
}


#pragma mark - init

- (id)init{
    self = [super init];
    if (self) {
        [self genTerrainData];
    }
    return self;
}



#pragma mark - generate terrain data

- (void)genTerrainData{
    
    actorCoreM = [b2ActorCoreManager sharedInstance];
    
    keyXList = [[TFloatList alloc] initWithSize:MAX_TERRAIN_KEY_COUNT];
    keyYList = [[TFloatList alloc] initWithSize:MAX_TERRAIN_KEY_COUNT];
    
    int sign = -1; // +1 - going up, -1 - going  down
    int baseY = 50.0;
    
    float x = 0;
    float y = baseY;
    
    b2ActorController* actorC = [b2ActorController sharedInstance];
    
    for (int i=0; i<MAX_TERRAIN_KEY_COUNT; i++) {
        
        if(i!=0){
            x += TERRAIN_KEY_STEP;
        }
        
        if (i%20 <= 10) {
            y+= 4*sign;
        }else if(i%20<19){
            y+= 0;
        }else {
            sign*=-1;
        }

        [keyXList addValue:x];
        [keyYList addValue:y];

        
    }
    
    
    
    
    b2ActorCore* actorCore;
    //cars
//    if (i%20==15) {
    actorCore = [[b2ActorCore alloc] init];
    [actorCore setGlPos:CGPointMake(100.0f,50.0f)];
    [actorCore setCatagory:b2ActorCategoryVehicle];
    [actorCore setIsDynamic:YES];
    [actorCore setIdx:0];
    [actorCore setZ:1];
    [actorCoreM dynamicActorCoreListReplaceObjectAtIndex:0 withObject:actorCore];
    [actorC add:actorCore];
    [actorCoreM setDynamicActorInRange:0];
//    }
    
    
    
    //generate land actorCore
    for (int i=0; i<MAX_TERRAIN_KEY_COUNT; i++) {
        x = [keyXList getValue:i];
        y = [keyYList getValue:i];
        
        
//        LOG_DEBUG(@"keyX:%f keyY:%f", x, y);
        
        if (i+1==MAX_TERRAIN_KEY_COUNT) {
            return;
        }
        
        int iNext = i+1;
        
        float xNext;
        float yNext;
        float yResult;
        
        xNext = [keyXList getValue:iNext];
        yNext = [keyYList getValue:iNext];
        
        yResult = (yNext - y);
        
        b2ActorCore* actorCore; 
//        float angle;
    
        //land
        actorCore = [[b2ActorCore alloc] init];
        [actorCore setGlPos:CGPointMake(x,y)];
//        [actorCore setAngle:atanf(yResult/TERRAIN_KEY_STEP)];
        
        [actorCore setP1:CGPointMake(0.0, 0.0)];
        [actorCore setP2:CGPointMake(TERRAIN_KEY_STEP, 0)];
        [actorCore setLandOffset:yResult];
        [actorCore setCatagory:b2ActorCategoryLand];
        [actorCore setIsDynamic:NO];
//        [actorCore setChangreWithLight:NO];
        [actorCore setIdx:i];
        [actorCore setZ:0];
//        [landActorCoreList replaceObjectAtIndex:i withObject:actorCore];  
//        [actorCoreM landActorCoreListReplaceObjectAtIndex:i withObject:actorCore];
        [actorCoreM staticActorCoreListReplaceObjectAtIndex:i withObject:actorCore];
        [actorCoreM setStaticActorInRange:i];
    }
    
    [actorC focusCurrent];
//    [actorC s]
}

#pragma mark - properties

- (b2ActorManager *)actorM{
    return [b2ActorManager sharedInstance];
}


@end
