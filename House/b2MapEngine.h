//
//  TerrainUtil.h
//  House
//
//  Created by Tao Yunfei on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "TIntList.h"
#import "Tb2VecList.h"
#import "TFloatList.h"
#import "b2ActorEnum.h"

@class B2WorldManager;
//@class b2LandActor;
@class b2ActorManager;
@class b2ActorCoreManager;

@interface b2MapEngine : NSObject{ 

    float scale;  //当前场景的缩放值
    
    float startKey; //场景的开始位置
    float endKey; //场景的结束位置
    
    int landStartIdx; //场景开始的idx
    int landEndIdx; //场景结束的idx
    
    int preLandStartIdx;
    int preLandEndIdx;
    
    int actorStartIdx;
    int actorEndIdx;
    
    TFloatList* keyXList;   //static actor/ground x值
    TFloatList* keyYList; // actor/ground 对应key的 y值
    
    b2ActorCoreManager* actorCoreM;
    
}
  

- (void)genTerrainData;

- (void)update;
- (void)calcuRange;
- (void)calcuInRange;
- (void)calcuOutOfRange;

- (void)setActorInRange:(int)idx;
- (void)setActorOutOfRange:(int)idx;

- (void)calcuDynamicActorIdx;

- (CGPoint)getKeyPos:(int)idx;

- (b2ActorManager*)actorM;

+ (b2MapEngine*)sharedInstance;



@end
