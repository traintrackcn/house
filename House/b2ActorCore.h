//
//  b2ActorCore.h
//  House
//
//  Created by Tao Yunfei on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface b2ActorCore : NSObject{
}


- (void)generateActorId;
- (void)reset;

@property (nonatomic, assign) int catagory;
@property (nonatomic, assign) CGPoint glPos;
@property (nonatomic, assign) CGPoint p1,p2;
@property (nonatomic, assign) int actorId;
@property (nonatomic, assign) BOOL isDynamic;
@property (nonatomic, assign) BOOL bAwake;
@property (nonatomic, assign) int idx;
@property (nonatomic, assign) float angle;
@property (nonatomic, assign) int landOffset;
@property (nonatomic, assign) int z;
//@property (nonatomic, assign) Boolean changeWithLight;
//@property (nonatomic, assign) int lightIdx;

@end
