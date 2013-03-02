//
//  Character.h
//  House
//
//  Created by Tao Yunfei on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//





#import "CCSprite.h"

@class MainLayer;

@interface CellSkin : CCSprite{
    NSString* key;
    CGSize size;
    MainLayer* layer;
}

- (void)showAs:(NSString *)cellSkinKey;
- (void)showAs:(NSString*)cellSkinKey z:(int)z;
//- (void)showAt:(int)timeIdx;
- (void)free;
- (CGSize)size;

- (void)lightUp;
- (void)lightOff;

@property (nonatomic, assign) int idx;
@property (nonatomic, assign) Boolean changeWithSunlight;

@end
