//
//  DayAndNightManager.m
//  House
//
//  Created by Tao Yunfei on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DayAndNightManager.h"
#import "cocos2d.h"
#import "CellSkinPool.h"
#import "CellSkin.h"
#import "SceneManager.h"
#import "MainLayer.h"


static DayAndNightManager* _sharedDayAndNightManager;



@interface DayAndNightManager()
- (void)runSunAction;
@end


@implementation DayAndNightManager

+ (DayAndNightManager *)sharedInstance{
    if (!_sharedDayAndNightManager) {
        _sharedDayAndNightManager = [[DayAndNightManager alloc] init];
    }
    return _sharedDayAndNightManager;
}

- (id)init{
    self = [super init];
    if (self) {
        
        
        LOG_DEBUG(@"set action");
        
        
        
        cellSkinPool = [CellSkinPool sharedInstance];
        
        layer = [SceneManager sharedLayer];
        [layer addChild:self z:-100];
        
        
        
       
        
        sun = [cellSkinPool pick];
        [sun showAs:@"sky1_sun1"];
        [[layer bacground] addChild:sun];
        
        [sun setChangeWithSunlight:NO];
        
        
        
        
        
    }
    return self;
}


- (void)run{
    
     [self unscheduleUpdate];
    
    CCSequence* sequenceAction = [CCSequence actions:
                                  [CCTintTo actionWithDuration:60 red:255 green:155 blue:0],
                                  [CCTintTo actionWithDuration:60 red:0 green:0 blue:255],
                                  [CCTintTo actionWithDuration:60 red:255 green:255 blue:255],
                                  nil];
    CCRepeatForever* repeatAction = [CCRepeatForever actionWithAction:sequenceAction];
    [self runAction:repeatAction];
    
    
   
    
    
    [self runSunAction];
}


- (void)runSunAction{
    //sun action
    float baseX = 240.0;
    float baseY = 160.0;
    float sunY = baseY + 200.0;
    
    CCSequence* sequenceAction = [CCSequence actions:
                                  [CCPlace actionWithPosition:ccp(baseX,sunY)],
                                  [CCMoveTo actionWithDuration:60 position:ccp(-50,sunY)], 
                                  [CCMoveTo actionWithDuration:60 position:ccp(-50,sunY)], 
                                  [CCPlace actionWithPosition:ccp(530,sunY)],
                                  [CCMoveTo actionWithDuration:60 position:ccp(baseX,sunY)],
                                  //                                                                    [CCMoveTo actionWithDuration:3 position:ccp(baseX,sunY)],
                                  nil];
    
    CCRepeatForever* repeatAction = [CCRepeatForever actionWithAction:sequenceAction];
    [sun runAction:repeatAction];
    
    
    sequenceAction = [CCSequence actions:
                      [CCRotateTo actionWithDuration:3.0 angle:30],
                      [CCRotateTo actionWithDuration:3.0 angle:-30],
                      nil];
    
    repeatAction = [CCRepeatForever actionWithAction:sequenceAction];
    [sun runAction:repeatAction];       
}

- (void)updateCellsColor{
    NSArray* arr = [cellSkinPool inUseArr];
    int count = [arr count];
    CellSkin* cellSkin;
    
    ccColor3B color = [self color];

    for (int i=0;i<count; i++) {
        cellSkin = [arr objectAtIndex:i];
        if ([cellSkin changeWithSunlight]) {
            [cellSkin setColor:color];
        }
        
//        [cellSkin settin]
    }
}


@end
