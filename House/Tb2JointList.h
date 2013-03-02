//
//  Tb2JointList.h
//  House
//
//  Created by Tao Yunfei on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TSimpleList.h"
#import "Box2D.h"

@interface Tb2JointList : TSimpleList{
    b2Joint** content;
}


- (b2Joint**)content;

- (void)addValue:(b2Joint*)value;
- (b2Joint*)getValue:(int)idx;


@end
