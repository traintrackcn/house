//
//  b2BodyList.h
//  House
//
//  Created by traintrackcn on 13-3-6.
//
//

#import <Foundation/Foundation.h>
#import "TSimpleList.h"
#import "Box2D.h"

@interface b2BodyList : TSimpleList{
    
}


- (void)addValue:(b2Body *)value withName:(NSString *)name;
- (void)addValue:(b2Body*)value;
- (b2Body*)getValueAt:(int)idx;
- (b2Body *)getValueByName:(NSString *)name;

@end
