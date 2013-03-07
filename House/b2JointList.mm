//
//  Tb2JointList.m
//  House
//
//  Created by Tao Yunfei on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "b2JointList.h"



@interface b2JointList() {
    b2Joint** arr;
    NSMutableDictionary *nameIdxMap;
}

@end


@implementation b2JointList

- (id)initWithSize:(int)size{
    self = [super initWithSize:size];
    if (self) {
        arr = new b2Joint*[size];
        nameIdxMap = [NSMutableDictionary dictionaryWithCapacity:size];
    }
    return self;
}


- (void)addValue:(b2Joint *)value{
    int idx = count;
    arr[idx] = value;
    [self countPP];
}

- (void)addValue:(b2Joint *)value withName:(NSString *)name{
    [nameIdxMap setObject:[NSNumber numberWithInt:count] forKey:name];
    [self addValue:value];
}

- (b2Joint *)getValueAt:(int)idx{
    return arr[idx];
}

- (b2Joint *)getValueByName:(NSString *)name{
    int idx = [[nameIdxMap objectForKey:name] intValue];
    return [self getValueAt:idx];
}

- (void)free{
    //    free(content);
    delete[] arr;
}

@end
