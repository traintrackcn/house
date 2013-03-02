//
//  CellSkinFactory.h
//  House
//
//  Created by Tao Yunfei on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CellSkin;
@class CellSkinCore;

@interface CellSkinFactory : NSObject{
    
}

+ (CellSkinFactory*)sharedInstance;

- (CellSkin*)create:(CellSkinCore*)core;

@end
