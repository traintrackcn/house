//
//  b2CellPool.m
//  House
//
//  Created by Tao Yunfei on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "b2CellPool.h"
#import "b2Cell.h"
#import "TIntList.h"

static b2CellPool* _sharedb2CellPool;

@implementation b2CellPool

+ (b2CellPool *)sharedInstance{
    if (!_sharedb2CellPool) {
        _sharedb2CellPool = [[b2CellPool alloc] init];
    }
    return _sharedb2CellPool;
}

- (id)init{
    self = [super init];
    if (self) {
        
        LOG_DEBUG(@"CELL_POOL_SIZE -> %d",CELL_POOL_SIZE);
        
        inFreeDic = [[NSMutableDictionary alloc] initWithCapacity:CELL_POOL_SIZE];
        inUseDic = [[NSMutableDictionary alloc] initWithCapacity:CELL_POOL_SIZE];
        
        NSNumber *key;
        NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:CELL_POOL_SIZE];
        for (int i=0; i<CELL_POOL_SIZE; i++) {

            b2Cell *cell = [[b2Cell alloc] init];
            [cell setIdx:i];
            key = [NSNumber numberWithInt:i];
            [inFreeDic setObject:key forKey:key];
            [tempArr addObject:cell];
        }
        arr = [[NSArray alloc] initWithArray:tempArr];
    }
    return self;
}




@end
