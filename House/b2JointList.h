//
//  Tb2JointList.h
//  House
//
//  Created by Tao Yunfei on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TSimpleList.h"
#import "Box2D.h"

@interface b2JointList : TSimpleList{
    
}


- (void)addValue:(b2Joint*)value;
- (void)addValue:(b2Joint *)value withName:(NSString *)name;

- (b2Joint*)getValueAt:(int)idx;
- (b2Joint *)getValueByName:(NSString *)name;


@end
