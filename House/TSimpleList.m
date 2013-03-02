//
//  YFList.m
//  House
//
//  Created by Tao Yunfei on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TSimpleList.h"

@implementation TSimpleList


- (id)initWithSize:(int)size{
    
    self = [super init];
    
    if (self) {
        maxCount = size;
    }
    
    return self;
}


- (void)reset{
    count = 0;
}

- (void)free{
    
}

- (int)count{
    return count;
}

- (void)countPP{
    count ++;
    if (count>maxCount) {
        [NSException raise:@"Out of capicity" format:@"%@ maxCount is %d",self,maxCount];
    }
//    [NSException raise:@"Out of capicity" format:@"%@ maxCount is %d",self,maxCount];
}

@end
