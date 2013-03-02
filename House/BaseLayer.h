//
//  BaseLayer.h
//  House
//
//  Created by Tao Yunfei on 12-2-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
//#import "Box2D.h"

@class b2Actor;

@interface BaseLayer : CCLayer{

//    NSMutableDictionary *actorDic;
}


//- (void)addActor:(b2Actor*)actor;
//- (void)removeActor:(b2Actor*)actor;

- (void)update:(ccTime)delta;


@end
