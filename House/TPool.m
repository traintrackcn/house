//
//  TPool.m
//  House
//
//  Created by Tao Yunfei on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TPool.h"
#import "TIntList.h"

@implementation TPool



- (id)pick{
    NSArray *freeArr = [inFreeDic allKeys];
    int count = [freeArr count];
    
    if (count ==0) {
        return nil;
    }
    
    NSNumber *key = [freeArr objectAtIndex:0];
    [inUseDic setObject:key forKey:key];
    [inFreeDic removeObjectForKey:key];
    
    return [arr objectAtIndex:[key intValue]];
}

- (void)setFree:(int)idx{
    [[arr objectAtIndex:idx] free];
    NSNumber *key = [NSNumber numberWithInt:idx];
    [inUseDic removeObjectForKey:key];
    [inFreeDic setObject:key forKey:key];
}

- (void)setFreeIdxList:(TIntList*)idxList{
    int count = [idxList count];
    for (int i=0; i<count; i++) {
        int idx = [idxList getValue:i];
        [self setFree:idx];
    }
}

- (id)getValue:(int)idx{
    return [arr objectAtIndex:idx];
}


- (int)inUseCount{
    return [inUseDic count];
}


- (NSMutableArray *)inUseArr{
    NSMutableArray* tempArr = [[NSMutableArray alloc] init];
    NSNumber* key;
    NSArray* keys = [inUseDic allKeys];
    
    for (int i = 0; i<[keys count]; i++) {
        key = [keys objectAtIndex:i];
        [tempArr addObject:[self getValue:[key intValue]]];
    }
    return tempArr;
}

@end
