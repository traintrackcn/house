//
//  FrameCacheManager.h
//  House
//
//  Created by Tao Yunfei on 12-2-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCSpriteFrameCache;
@class CCSpriteFrame;

@interface CellSkinManager : NSObject{
    CCSpriteFrameCache* frameCache;    
    NSMutableDictionary* cache;
}


- (NSArray *)getFramesByCellSkinKey:(NSString *)cellSkinKey;

+(CellSkinManager *)sharedInstance;


@end
