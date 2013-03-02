//
//  FrameCacheManager.m
//  House
//
//  Created by Tao Yunfei on 12-2-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CellSkinManager.h"
#import "cocos2d.h"


@interface CellSkinManager()
- (CCSpriteFrame*)spriteFrameByFrameNamePrefix:(NSString *)frameNamePrefix idx:(int)idx;
@end


static CellSkinManager *_sharedFrameCacheManager;

@implementation CellSkinManager



+ (CellSkinManager *)sharedInstance{
    if (!_sharedFrameCacheManager) {
        _sharedFrameCacheManager = [[CellSkinManager alloc] init];
    }
    
    return _sharedFrameCacheManager;
}


- (id)init{
    self = [super init];
    if (self != nil) {
        frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        cache  = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (NSArray *)getFramesByCellSkinKey:(NSString *)cellSkinKey{
    
    
    NSArray* arr = [cellSkinKey componentsSeparatedByString:@"_"];
    NSString* cellSkinFileKey = [arr objectAtIndex:0];
    NSString* cellSkinFile;
    
    BOOL inCache = [cache objectForKey:cellSkinFileKey]?YES:NO;
//    LOG_DEBUG(@"cellSkinFileKey -> %@",cellSkinFileKey);
    
    if (!inCache) {
        
//        LOG_DEBUG(@"load skin from file");
        cellSkinFile = [NSString stringWithFormat:@"%@.plist",cellSkinFileKey];        
        
//        LOG_DEBUG(@"cellSkinFileKey -> %@   cellSkinFile -> %@",cellSkinFileKey,cellSkinFile);
        
        [frameCache addSpriteFramesWithFile:cellSkinFile];
        [cache setValue:@"" forKey:cellSkinFileKey];          
    }
    
    
    
    CCSpriteFrame* frame;
    NSMutableArray* frames = [[NSMutableArray alloc] init];
    NSString* frameNamePrefix = [NSString stringWithFormat:@"%@.swf/",cellSkinKey];
    
    for (int i=0; i<1; i++) {
        frame = [self spriteFrameByFrameNamePrefix:frameNamePrefix idx:i];
        
        if (!inCache){ 
            [[frame texture]generateMipmap];
            ccTexParams texParams = { GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE };
            [[frame texture] setTexParameters:&texParams];
        }
        
        [frames addObject:frame];
    }
    
    
//    LOG_DEBUG(@"==========================================");
    
    return frames;
    
}



- (CCSpriteFrame*)spriteFrameByFrameNamePrefix:(NSString *)frameNamePrefix idx:(int)idx{
 
    NSString* frameName;
    
    if (idx>999) {
        frameName = [NSString stringWithFormat:@"%@%d",frameNamePrefix,idx];
    }else if (idx>99) {
        frameName = [NSString stringWithFormat:@"%@0%d",frameNamePrefix,idx];
    }else if(idx>9){
        frameName = [NSString stringWithFormat:@"%@00%d",frameNamePrefix,idx];
    }else{
        frameName = [NSString stringWithFormat:@"%@000%d",frameNamePrefix,idx];
    }    
    
//    LOG_DEBUG(@"frameName -> %@",frameName);

    return [frameCache spriteFrameByName:frameName];
}




@end
