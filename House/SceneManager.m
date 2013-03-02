
//  RootScene.m
//  House
//
//  Created by Tao Yunfei on 12-1-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SceneManager.h"
#import "MainLayer.h"
#import "cocos2d.h"



static SceneManager *_sharedSceneManager;


@implementation SceneManager

@synthesize scene,layer;


+ (id)sharedInstance{
    if (!_sharedSceneManager) {
        _sharedSceneManager = [[SceneManager alloc] init];
    }
    return _sharedSceneManager;
}

+ (id)sharedScene{
    return [[SceneManager sharedInstance] scene];
}


+ (id)sharedLayer{
    return [[SceneManager sharedInstance] layer];
}

- (id)init{
    if (self = [super init]) {
        scene = [[CCScene alloc] init];    
        layer = [[MainLayer alloc] init];
        [layer setIsTouchEnabled:YES];
        [scene addChild:layer];
    }
    return self;
}




@end
