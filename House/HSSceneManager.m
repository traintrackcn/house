
//  RootScene.m
//  House
//
//  Created by Tao Yunfei on 12-1-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HSSceneManager.h"
#import "HSMainLayer.h"
#import "cocos2d.h"



static HSSceneManager *_sharedSceneManager;


@implementation HSSceneManager

@synthesize scene,layer;


+ (id)sharedInstance{
    if (!_sharedSceneManager) {
        _sharedSceneManager = [[HSSceneManager alloc] init];
    }
    return _sharedSceneManager;
}

+ (id)sharedScene{
    return [[HSSceneManager sharedInstance] scene];
}


+ (id)sharedLayer{
    return [[HSSceneManager sharedInstance] layer];
}

- (id)init{
    if (self = [super init]) {
        scene = [[CCScene alloc] init];    
        layer = [[HSMainLayer alloc] init];
        [layer setIsTouchEnabled:YES];
        [scene addChild:layer];
    }
    return self;
}




@end
