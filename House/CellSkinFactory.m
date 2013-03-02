//
//  CellSkinFactory.m
//  House
//
//  Created by Tao Yunfei on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CellSkinFactory.h"
#import "CellSkin.h"
#import "CellSkinCore.h"

static CellSkinFactory* _sharedCellSkinFactory;
@implementation CellSkinFactory

+ (CellSkinFactory *)sharedInstance{
    if (!_sharedCellSkinFactory) {
        _sharedCellSkinFactory = [[CellSkinFactory alloc] init];
    }
    return _sharedCellSkinFactory;
}

#pragma mark - init

- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - init

- (CellSkin*)create:(CellSkinCore*)core{
    
}

@end
