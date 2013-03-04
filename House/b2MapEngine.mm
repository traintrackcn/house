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



//static TerrainUtil* _sharedTerrainUtil;
@interface b2MapEngine()
- (int)searchStartIdx;
- (int)searchEndIdx:(int)startIdx;
@end

@implementation b2MapEngine

//@synthesize startIdx,endIdx;


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
        
        actorCoreM = [b2ActorCoreManager sharedInstance];
        
        keyXList = [[TFloatList alloc] initWithSize:MAX_TERRAIN_KEY_COUNT];
        keyYList = [[TFloatList alloc] initWithSize:MAX_TERRAIN_KEY_COUNT];
        
//        preActorStartIdx = -1;
//        preActorEndIdx = -1;
        
        preLandStartIdx = -1;
        preLandEndIdx = -1;
        
        [self genTerrainData];
    }
    return self;
}



#pragma mark - generate terrain data

- (void)genTerrainData{
    
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

        b2ActorCore* actorCore; 
        
        //tree
        if (i%5==3) {
            actorCore = [[b2ActorCore alloc] init];
            [actorCore setPos:CGPointMake(x,y)];
            [actorCore setType:b2ActorTypeTree];
            [actorCore setIsDynamic:NO];
            [actorCore setIdx:i];
            [actorCore setZ:-1];
//        [staticActorCoreList replaceObjectAtIndex:i withObject:actorCore];
            [actorCoreM staticActorCoreListReplaceObjectAtIndex:i withObject:actorCore];
        }
        
        
        //person
        if (i%10==7) {
            actorCore = [[b2ActorCore alloc] init];
            [actorCore setPos:CGPointMake(x,y)];
            [actorCore setType:b2ActorTypePerson];
            [actorCore setIsDynamic:YES];
            [actorCore setIdx:i];
            [actorCore setZ:1];
            [actorCoreM dynamicActorCoreListReplaceObjectAtIndex:i withObject:actorCore];
            [actorC add:actorCore];
        }
        
        if (i%20==15) {
            actorCore = [[b2ActorCore alloc] init];
            [actorCore setPos:CGPointMake(x,y)];
            [actorCore setType:b2ActorTypeCar];
            [actorCore setIsDynamic:YES];
            [actorCore setIdx:i];
            [actorCore setZ:1];
            [actorCoreM dynamicActorCoreListReplaceObjectAtIndex:i withObject:actorCore];
            [actorC add:actorCore];
        }
    }
    
    float xNext;
    float yNext;
    float yResult;
    
    //generate land actorCore
    for (int i=0; i<MAX_TERRAIN_KEY_COUNT; i++) {
        x = [keyXList getValue:i];
        y = [keyYList getValue:i];
        
        
        
        if (i+1==MAX_TERRAIN_KEY_COUNT) {
            return;
        }
        
        int iNext = i+1;
        
        xNext = [keyXList getValue:iNext];
        yNext = [keyYList getValue:iNext];
        
        yResult = (yNext - y);
        
        b2ActorCore* actorCore; 
//        float angle;
    
        //land
        actorCore = [[b2ActorCore alloc] init];
        [actorCore setPos:CGPointMake(x,y)];
        [actorCore setAngle:atanf(yResult/TERRAIN_KEY_STEP)];
        [actorCore setP1:CGPointMake(0.0, 0.0)];
        [actorCore setP2:CGPointMake(TERRAIN_KEY_STEP, yResult)];
        [actorCore setLandOffset:yResult];
        [actorCore setType:b2ActorTypeLand];
        [actorCore setIsDynamic:NO];
//        [actorCore setChangeWithLight:NO];
        [actorCore setIdx:i];
        [actorCore setZ:0];
//        [landActorCoreList replaceObjectAtIndex:i withObject:actorCore];  
        [actorCoreM landActorCoreListReplaceObjectAtIndex:i withObject:actorCore];
    }
    
    [actorC focusCurrent];
    
    
    
}



#pragma mark - calcu current static actor in terrain

- (void)update{
    
    [self calcuRange];
    
    //calcu dynamic actor idx
    [self calcuDynamicActorIdx];
    
    if (landStartIdx == preLandStartIdx && landEndIdx == preLandEndIdx) {
        return;
    }else {
        //    LOG_DEBUG(@"landStartKey -> %f actorStartKey -> %f actorEndKey ->%f landEndKey ->%f",landStartKey,startKey,endKey,landEndKey);
//        LOG_DEBUG(@"landStartIdx -> %d actorStartIdx -> %d  actorEndIdx -> %d landEndIdx -> %d  ",landStartIdx,actorStartIdx,actorEndIdx,landEndIdx);   
        //    LOG_DEBUG(@"preActorStartIdx -> %d preActorEndIdx -> %d",preActorStartIdx,preActorEndIdx);
        
        
        
//        LOG_DEBUG(@"======================================");
        
        
    }
    
    [self calcuInRange];

//    LOG_DEBUG(@"after calcuInRange ====================================");

    if (preLandStartIdx!=-1&&preLandEndIdx!=-1) {
        [self calcuOutOfRange];
    }
    
//    LOG_DEBUG(@"after calcuOutOfRange ====================================");
    
    preLandStartIdx = landStartIdx;
    preLandEndIdx = landEndIdx;
    
    
//    b2ActorManager* actorM = [b2ActorManager sharedInstance];
//    b2World* world = [b2WorldManager sharedb2World];
//    b2CellFactory* factory = [b2CellFactory sharedInstance];
//    LOG_DEBUG(@"==============actorCount -> %d   cellInUseCount -> %d  jointCount -> %d  bodyCount -> %d",[actorM count],[factory cellInUseCount],world->GetJointCount(),world->GetBodyCount());

}



- (void)calcuRange{

    b2WorldManager *worldM = [b2WorldManager sharedInstance];

    CGPoint pos = [worldM pos];
    
    scale = [worldM scale];
    
    float offScreenW = 50.0/scale;
    float screenW = [[TDeviceUtil sharedInstance] screenWidth]/scale;
    float halfScreenW = screenW/2;
    
    
    //for offical
    
    startKey = (pos.x - offScreenW*2)  - halfScreenW ;
    endKey = (pos.x + offScreenW*2+screenW) - halfScreenW ;

    landStartIdx = [self searchStartIdx];
    landEndIdx = [self searchEndIdx:landStartIdx];    
    
    startKey = startKey + offScreenW;
    endKey = endKey - offScreenW;
    
    actorStartIdx = [self searchStartIdx];
    actorEndIdx = [self searchEndIdx:actorStartIdx];
    
    
    //for test only

//    startKey = (pos.x+offScreenW) - halfScreenW ;    //  观察land边界的计算情况
//    endKey = (pos.x-offScreenW) + screenW - halfScreenW ;     
//
////    startKey = (pos.x) - halfScreenW ;
////    endKey = (pos.x) + screenW - halfScreenW ;    
//    
//    landStartIdx = [self searchStartIdx];
//    landEndIdx = [self searchEndIdx:landStartIdx];    
//    
//    startKey = startKey + offScreenW;
//    endKey = endKey - offScreenW;
//    
//    actorStartIdx = [self searchStartIdx];
//    actorEndIdx = [self searchEndIdx:actorStartIdx];    
    
}


- (void)calcuInRange{
    for (int i=landStartIdx; i<=landEndIdx; i++) {
        [self setActorInRange:i];
     }     
}



- (void)calcuOutOfRange{
    
    if (preLandStartIdx<landStartIdx) {
        
        if (preLandEndIdx <landStartIdx) {
            for (int i=preLandStartIdx; i<=preLandEndIdx; i++) {
                [self setActorOutOfRange:i];
            }
        }else if (preLandEndIdx == landStartIdx){
            for (int i=preLandStartIdx; i<preLandEndIdx; i++) {
                [self setActorOutOfRange:i];
            }            
            
        }else if (preLandEndIdx > landStartIdx && preLandEndIdx <= landEndIdx){
            for (int i=preLandStartIdx; i<landStartIdx; i++) {
                [self setActorOutOfRange:i];
            }
        }else if(preLandEndIdx > landEndIdx){
            
            for (int i=preLandStartIdx; i<landStartIdx; i++) {
                [self setActorOutOfRange:i];
            }
            
            for (int i=landEndIdx+1; i<=preLandEndIdx; i++) {
                [self setActorOutOfRange:i];
            }
        }
    }else if(preLandStartIdx>= landStartIdx && preLandStartIdx<=landEndIdx  ){
        if (preLandEndIdx>landEndIdx) {
            for (int i=landEndIdx+1; i<=preLandEndIdx; i++) {
                [self setActorOutOfRange:i];
            }
        }
    }else if(preLandStartIdx>landEndIdx){
        if (preLandEndIdx>landEndIdx) {
            for (int i=landEndIdx; i<=preLandEndIdx; i++) {
                [self setActorOutOfRange:i];
            }    
        }
    }
    
    
    //    LOG_DEBUG(@"calcuOutOfRange end =================");
    
}


#pragma mark - search action


- (int)searchStartIdx{
    
    
    
    
    int first = 0;
    int count = [keyXList count];
    int last = count - 1;
    
    float midKey;
    float midNextKey;
    float midPreviousKey;
    
    
//    LOG_DEBUG(@"startKey -> %f",startKey);
    
    if (startKey<=0) {
        return first;
    }
    
    
    
    while (first <= last) {
        int mid = (first + last) / 2;  // compute mid point.
        
        midKey = [keyXList getValue:mid];
        
        if (startKey > midKey){ 
            
            if (mid+1>= count) {
                return mid;
            }
            
            midNextKey = [keyXList getValue:(mid+1)];
            
            if (startKey <= midNextKey) {
                return mid;
            }
            
            first = mid + 1;  // repeat search in top half.
            
        }else if (startKey < midKey){ 
            
            if (mid==0) {
                return mid;
            }

            midPreviousKey = [keyXList getValue:(mid-1)];

            if (startKey >= midPreviousKey) {
                return mid-1;
            }           
            
            
            last = mid - 1; // repeat search in bottom half.
        }else{
            return mid;     // found it. return position /////
        }
    }
    return -1;    // failed to find key
}


- (int)searchEndIdx:(int)startIdx{
    
    int key = startKey;
    int idx = startIdx;
    int count = [keyXList count];
    int last = count - 1;
    
//    if (endKey>=maxKey) {
//        return last;
//    }    
    
    while (idx < count) {
        if (key>=endKey) {
            return idx;
        }
        key = [keyXList getValue:idx++];
    }
    
    if (idx == count) {
        return last;
    }
    
    return -1;
    
}

#pragma mark - operate [in range/out of range]

- (void)setActorInRange:(int)idx{
    
    [actorCoreM setLandActorInRange:idx];
    
    if (idx<actorStartIdx||idx>actorEndIdx){
        [actorCoreM setStaticActorOutOfRange:idx];
        [actorCoreM setDynamicActorOutOfRange:idx];        
    }else {
        [actorCoreM setStaticActorInRange:idx];
        [actorCoreM setDynamicActorInRange:idx];
    }
    
    
}

- (void)setActorOutOfRange:(int)idx{
    [actorCoreM setLandActorOutOfRange:idx];
    [actorCoreM setStaticActorOutOfRange:idx];
    [actorCoreM setDynamicActorOutOfRange:idx];
}

- (void)calcuDynamicActorIdx{
//    return;

    b2ActorManager* actorM = [b2ActorManager sharedInstance];
//    b2ActorController* actorC = [b2ActorController sharedInstance];
    NSArray* arr = [[actorM dynamicActorDic] allValues];
    int num = [arr count];

    for (int i=0; i<num; i++) {
        b2Actor* actor = [arr objectAtIndex:i];
        [actor update]; //动作更新
        
//        b2ActorCore* actorCore = [actor core];
//        CGPoint corePos = [actorCore pos];
//        CGPoint realPos = [actor realPos];
//        if (corePos.x!=realPos.x||corePos.y!=realPos.y){
//            
//            [actorCore setPos:realPos];
//            
//            int realCoreIdx = roundf(corePos.x/TERRAIN_KEY_STEP);
//            int coreIdx = [actorCore idx];
////            LOG_DEBUG(@"realCoreIdx -> %d  coreIdx -> %d",realCoreIdx,coreIdx);
//            if (realCoreIdx == coreIdx) continue;
//            b2ActorCore* targetCore = [actorCoreM getDynamicActorCore:realCoreIdx];
//            Boolean targetCoreIsNull = [targetCore isEqual:[NSNull null]];
//            if (targetCoreIsNull) {
////                [dynamicActorCoreList exchangeObjectAtIndex:realCoreIdx withObjectAtIndex:coreIdx];
//                [actorCoreM dynamicActorCoreListExchangeObjectAtIndex:realCoreIdx withObjectAtIndex:coreIdx];
//                [actorCore setIdx:realCoreIdx];
////                LOG_DEBUG(@"realCoreIdx -> %d  coreIdx -> %d  targetCore -> %@ newCoreIdx -> %d",realCoreIdx,coreIdx,targetCore,[actorCore idx]);
//            }
//        }
        
    }
    
//    LOG_DEBUG(@"calcuDynamicActorIdx end =============================");
}

- (CGPoint)getKeyPos:(int)idx{
    return CGPointMake([keyXList getValue:idx],[keyYList getValue:idx]);
}

#pragma mark - properties

- (b2ActorManager *)actorM{
    return [b2ActorManager sharedInstance];
}


@end
