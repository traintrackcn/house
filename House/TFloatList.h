//
//  TFloatList.h
//  House
//
//  Created by Tao Yunfei on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TSimpleList.h"

@interface TFloatList : TSimpleList{
    float* content;
}

- (float*)content;
- (void)addValue:(float)value;
- (void)setValue:(float)value idx:(int)idx;
- (float)getValue:(int)idx;

@end
