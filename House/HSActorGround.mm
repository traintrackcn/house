//
//  HSActorGround.m
//  House
//
//  Created by traintrackcn on 13-3-9.
//
//

#import "HSActorGround.h"

@implementation HSActorGround

- (id)initWithKey:(NSString *)key glPosOffset:(CGPoint)glPosOffset{
    b2Filter filter;
    filter.categoryBits  = b2ActorCategoryGround;
    filter.maskBits = b2ActorMaskGround;
    self = [super initWithKey:key glPosOffset:glPosOffset filter:filter];
    if (self){
        
    }
    return self;
}

@end
