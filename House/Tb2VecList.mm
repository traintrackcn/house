//
//  Tb2VecList.m
//  House
//
//  Created by Tao Yunfei on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Tb2VecList.h"

@implementation Tb2VecList

- (id)initWithSize:(int)size{
    self = [super initWithSize:size];
    if (self) {
        content = new b2Vec2[size];
    }
    return self;
}

- (b2Vec2*)content{
    return content;
}

- (void)addValue:(b2Vec2)value{
    content[count] = value;
    [self countPP];
}

- (b2Vec2)getValue:(int)idx{
    return content[idx];
}

- (void)free{
    free(content);
}

@end
