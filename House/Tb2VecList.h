//
//  Tb2VecList.h
//  House
//
//  Created by Tao Yunfei on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TSimpleList.h"
#import "Box2D.h"

@interface Tb2VecList : TSimpleList{
    b2Vec2* content;
}

- (b2Vec2*)content;
- (void)addValue:(b2Vec2)value;
- (b2Vec2)getValue:(int)idx;


@end
