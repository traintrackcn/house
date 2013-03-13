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
#import "b2Vec2List.h"
#import "HSActorGround.h"


@interface HSMapEngine() {
    TIntList *actorIdsGround; // index of ground
//    NSMutableArray *slotsGArr; // slots of ground
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

        actorIdsGround = [[TIntList alloc] initWithSize:10000];
//        slotsGArr = [NSMutableArray arrayWithCapacity:10000];
        
        //gen terrains
        float startGlX = 0;
        float startGlY = 0;
        for (int i=0; i<5; i++) {
            float glX = startGlX + 320*i;
            float glY = startGlY + 64*i;
            glY = 0;
            CGPoint glPosOffset = CGPointMake(glX, glY);
            HSActorBase *actor = [[HSActorGround alloc] initWithKey:kActorDescriptionTerrain1 glPosOffset:glPosOffset filter:[HSActorBase filterGround]];
            
            [actorIdsGround addValue:[actor actorId]];
            
            
            b2Vec2 b2Pos = [self getB2PosAtIndexGround:i indexSlot:10];
//            LOG_DEBUG(@"b2Pos  x:%f y:%f", b2Pos.x, b2Pos.y);
            [HSActorBase instanceWithKey:kActorDescriptionStationTiny b2PosOffset:b2Pos filter:[HSActorBase filterBackground]];
            
        }

//        [HSActorBase instanceWithKey:kActorDescriptionTerrain1 glPosOffset:CGPointMake(0, 0.0f) filter:filterGround];
//        [HSActorBase instanceWithKey:kActorDescriptionTerrain1 glPosOffset:CGPointMake(320, 64.0f) filter:filterGround];
//        for ( int i=0; i<5000; i++) {

        HSActorBase *actor = [HSActorBase instanceWithKey:kActorDescriptionCar1 glPosOffset:CGPointMake(100.0f,100.0f) filter:[HSActorBase filterVehicle]];
        [[HSActorController sharedInstance] focusActorById:[actor actorId]];

//        [[HSActorManager sharedInstance] removeValueById:[actor actorId]];
//        }
        
        
//        int indexG = 3;
//        for (int i=0; i<[self getSlotsCountAtIndexGround:indexG]; i++) {
//            b2Vec2 b2Pos = [self getB2PosAtIndexGround:indexG indexSlot:i];
//            LOG_DEBUG(@"b2Pos  x:%f y:%f", b2Pos.x, b2Pos.y);
//            [HSActorBase instanceWithKey:kActorDescriptionStationTiny b2PosOffset:b2Pos filter:[HSActorBase filterBackground]];
//        }
        
//        b2Vec2 b2Pos = [self getB2PosAtIndexGround:0 indexSlot:3];
//        LOG_DEBUG(@"b2Pos  x:%f y:%f", b2Pos.x, b2Pos.y);
//        [HSActorBase instanceWithKey:kActorDescriptionStationTiny b2PosOffset:b2Pos filter:[HSActorBase filterBackground]];
        
    }
    return self;
}



- (b2Vec2)getB2PosAtIndexGround:(int)indexG indexSlot:(int)indexS{
    int actorId = [actorIdsGround getValue:indexG];
    HSActorBase *actor = [[HSActorManager sharedInstance] getValueById:actorId];
    b2Vec2List *slotsG = [actor slotsGround];
    return [slotsG getValueAt:indexS];
}

- (int)getSlotsCountAtIndexGround:(int)indexG{
    int actorId = [actorIdsGround getValue:indexG];
    HSActorBase *actor = [[HSActorManager sharedInstance] getValueById:actorId];
    b2Vec2List *slotsG = [actor slotsGround];
    return [slotsG count];
}

//- (void)createActor:(NSString *)description indexGround:(int)indexG indexSlot:(int)indexS{
//    b2Vec2 b2Pos = [self getB2PosAtIndexGround:indexG indexSlot:indexS];
//    
//}

@end
