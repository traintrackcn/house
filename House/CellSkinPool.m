//
//  CellSkinPool.m
//  House
//
//  Created by Tao Yunfei on 12-3-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CellSkinPool.h"
#import "CellSkin.h"

static CellSkinPool* _sharedCellSkinPool;

@implementation CellSkinPool

+ (CellSkinPool *)sharedInstance{
    if (!_sharedCellSkinPool) {
        _sharedCellSkinPool = [[CellSkinPool alloc] init];
    }
    return _sharedCellSkinPool;
}


- (id)init{
    self = [super init];
    if (self) {
        
        LOG_DEBUG(@"CELL_SKIN_POOL_SIZE -> %d",CELL_POOL_SIZE);
        
        inFreeDic = [[NSMutableDictionary alloc] initWithCapacity:CELL_POOL_SIZE];
        inUseDic = [[NSMutableDictionary alloc] initWithCapacity:CELL_POOL_SIZE];
        
        NSNumber *key;
        NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:CELL_POOL_SIZE];
        for (int i=0; i<CELL_POOL_SIZE; i++) {
            
            CellSkin *skin = [[CellSkin alloc] init];
            [skin setIdx:i];
            key = [NSNumber numberWithInt:i];
            [inFreeDic setObject:key forKey:key];
            [tempArr addObject:skin];
        }
        arr = [[NSArray alloc] initWithArray:tempArr];
    }
    return self;
}

@end
