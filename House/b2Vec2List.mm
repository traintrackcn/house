//
//  Tb2VecList.m
//  House
//
//  Created by Tao Yunfei on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "b2Vec2List.h"

@interface b2Vec2List(){
    b2Vec2* list;
}

@end

@implementation b2Vec2List

- (id)initWithSize:(int)size{
    self = [super initWithSize:size];
    if (self) {
        list = new b2Vec2[size];
    }
    return self;
}


- (void)addValue:(b2Vec2)value{
    list[count] = value;
    [self countPP];
}

- (b2Vec2)getValueAt:(int)idx{
    return list[idx];
}

- (void)free{
    delete[] list;
}

@end
