//
//  RootScene.h
//  House
//
//  Created by Tao Yunfei on 12-1-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//#import "CCLayer.h"

@class CCScene;
@class CCLayer;


@interface HSSceneManager : NSObject{
//    CCScene *scene;
}


+ (id)sharedInstance;

+ (id)sharedScene;

+ (id)sharedLayer;


@property (nonatomic, strong) CCScene *scene;
@property (nonatomic, strong) CCLayer *layer;

@end
