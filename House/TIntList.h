//
//  IntList.h
//  House
//
//  Created by Tao Yunfei on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSimpleList.h"

@interface TIntList : TSimpleList{
    int* content;
}

- (int*)content;
- (void)addValue:(int)value;
- (void)setValue:(int)value idx:(int)idx;
- (int)getValue:(int)idx;

@end
