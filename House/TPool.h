//
//  TPool.h
//  House
//
//  Created by Tao Yunfei on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TIntList;

@interface TPool : NSObject{
    NSArray* arr;
    NSMutableDictionary *inUseDic;
    NSMutableDictionary *inFreeDic;
}

- (id)pick;

- (void)setFree:(int)idx;
- (void)setFreeIdxList:(TIntList*)idxList;

- (id)getValue:(int)idx;

- (int)inUseCount;
- (NSMutableArray*)inUseArr;

@end
