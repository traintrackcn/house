//
//  b2CellPool.h
//  House
//
//  Created by Tao Yunfei on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPool.h"

@interface b2CellPool : TPool{
}

+ (b2CellPool*)sharedInstance;


@end
