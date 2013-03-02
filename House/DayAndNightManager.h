//
//  DayAndNightManager.h
//  House
//
//  Created by Tao Yunfei on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CCSprite.h"

@class CellSkinPool;
@class MainLayer;
@class CellSkin;


@interface DayAndNightManager : CCSprite{
    CellSkinPool* cellSkinPool;
    MainLayer* layer;
    
    CellSkin* sun;
    CellSkin* moon;
}

+(DayAndNightManager *)sharedInstance;

- (void)updateCellsColor;
- (void)run;


@end
