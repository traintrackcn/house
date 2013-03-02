//
//  CharacterO.m
//  House
//
//  Created by Tao Yunfei on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CellSkinCore.h"

@implementation CellSkinCore


@synthesize key;
@synthesize fps;
@synthesize resourceType;
@synthesize delay;


- (id)init{
    self = [super init];
    if (self != nil) {
    }
    return self;
}




#pragma mark - character properties

- (NSString *)resourcePlist{
    return [NSString stringWithFormat:@"%@.plist",key];
}

- (NSString *)frameName:(int)idx{
    NSString *frameNSuffix;
    NSString *frameN;
    
    if (idx>999) {
        frameNSuffix = [NSString stringWithFormat:@"%d",idx];
    }else if (idx>99) {
        frameNSuffix = [NSString stringWithFormat:@"0%d",idx];
    }else if(idx>9){
        frameNSuffix = [NSString stringWithFormat:@"00%d",idx];
    }else{
        frameNSuffix = [NSString stringWithFormat:@"000%d",idx];
    }
    
//    frameN = [NSString stringWithFormat:@"%@_%d_%d.swf/%@",key,act,direction,frameNSuffix];   
    
    return frameN;
}



- (int)frameNum{
    return 0;
}











@end
