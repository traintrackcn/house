//
//  IntList.m
//  House
//
//  Created by Tao Yunfei on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TIntList.h"

@implementation TIntList

- (id)initWithSize:(int)size{
    self = [super initWithSize:size];
    if (self) {
        content = malloc(sizeof(int) * size);
    }
    return self;
}

- (int*)content{
    return content;
}

- (void)addValue:(int)value{
    content[count] = value;
    [self countPP];
}

- (void)setValue:(int)value idx:(int)idx{
    content[idx] = value;
}

- (int)getValue:(int)idx{
    return content[idx];
}

- (void)free{
//    content = nil;
    free(content);
}

@end
