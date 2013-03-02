//
//  YFList.h
//  House
//
//  Created by Tao Yunfei on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSimpleList : NSObject{
    int count;
    int maxCount;
}


- (id)initWithSize:(int)size;
- (void)reset;
- (int)count;
- (void)countPP;

- (void)free;

@end
