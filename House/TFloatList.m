//
//  TFloatList.m
//  House
//
//  Created by Tao Yunfei on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TFloatList.h"

@implementation TFloatList


- (id)initWithSize:(int)size{
    self = [super initWithSize:size];
    if (self) {
        content = malloc(sizeof(float) * size);
    }
    return self;
}

- (float*)content{
    return content;
}

- (void)addValue:(float)value{
    content[count] = value;
    [self countPP];
}

- (void)setValue:(float)value idx:(int)idx{
    content[idx] = value;
}

- (float)getValue:(int)idx{
    return content[idx];
}

- (void)free{
    free(content);
}

@end
