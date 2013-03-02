//
//  Tb2JointList.m
//  House
//
//  Created by Tao Yunfei on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Tb2JointList.h"

@implementation Tb2JointList

- (id)initWithSize:(int)size{
    self = [super initWithSize:size];
    if (self) {
        content = new b2Joint*[size];
    }
    return self;
}


- (b2Joint **)content{
    return content;
}

- (void)addValue:(b2Joint *)value{
    content[count] = value;
    [self countPP];
}

- (b2Joint*)getValue:(int)idx{
    return content[idx];
}

- (void)free{
    free(content);
}

@end
