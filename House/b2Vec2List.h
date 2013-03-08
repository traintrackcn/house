//
//  Tb2VecList.h
//  House
//
//  Created by Tao Yunfei on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TSimpleList.h"
#import "Box2D.h"

@interface b2Vec2List : TSimpleList{
    
}


- (void)addValue:(b2Vec2)value;
- (b2Vec2)getValueAt:(int)idx;


@end
