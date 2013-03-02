//
//  Character.m
//  House
//
//  Created by Tao Yunfei on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CellSkin.h"
#import "cocos2d.h"
#import "CellSkinManager.h"
#import "SceneManager.h"
#import "MainLayer.h"


@implementation CellSkin
@synthesize idx;
@synthesize changeWithSunlight;


- (id)init{
    self = [super init];
    if (self) {
        layer = [SceneManager sharedLayer];
        changeWithSunlight = YES;
    }
    return self;
}


- (void)showAsBlank:(CGRect)rect z:(int)z{
    
//    [self visit]
//
//    [layer addChild:self z:z];
//    
//    CCTexture2D* texture = [[CCTexture2D alloc] init];
    
//    CCRenderTexture* texture = [[CCRenderTexture alloc] initWithWidth:480 height:320 pixelFormat:kCCTexture2DPixelFormat_RGB888];
    
//    [self setTextureRect:rect];
////    [self setTexture:texture];
//    
}

- (void)lightUp{
    [self setColor:ccWHITE];
    [self setChangeWithSunlight:NO];
}

- (void)lightOff{
    [self setChangeWithSunlight:YES];
}

- (void)showAs:(NSString *)cellSkinKey{
    key  = cellSkinKey;
    [self unscheduleUpdate];
    CellSkinManager *cellSkinM = [CellSkinManager sharedInstance];
    NSArray* frames = [cellSkinM getFramesByCellSkinKey:key];
    int frameCount = [frames count];
    CCSpriteFrame* frame = [frames objectAtIndex:0];
    
    size = [frame rect].size;
    
    if (frameCount>1) {
        CCAnimation *animation = [CCAnimation animationWithSpriteFrames:frames delay:0.016];
        CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
        CCRepeatForever* repeat = [CCRepeatForever actionWithAction:animate];
        [self runAction:repeat];
    }else {
        [self setDisplayFrame:frame];
    }    
}

- (void)showAs:(NSString *)cellSkinKey z:(int)z{
    [layer addChild:self z:z];
    [self showAs:cellSkinKey];
    
//    self 
//    CGRectContainsPoint(<#CGRect rect#>, <#CGPoint point#>)
    
}


//- (void)showAt:(int)timeIdx{
//    CCSequence* sequenceAction = [CCSequence actions:
//                                  
//                                  [CCTintTo actionWithDuration:5 red:255 green:255 blue:255],
//                                  [CCTintTo actionWithDuration:5 red:128 green:128 blue:128],
//                                  nil];
//    CCRepeatForever* repeatAction = [CCRepeatForever actionWithAction:sequenceAction];
//    [self runAction:repeatAction];    
//}

- (CGSize)size{
    return size;
}


- (void)free{
    [self setRotation:0.0];
    [self setColor:ccWHITE];
    [self setChangeWithSunlight:YES];
    [[self parent] removeChild:self cleanup:YES];
}

@end
