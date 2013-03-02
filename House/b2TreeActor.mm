//
//  b2FlowerActor.m
//  House
//
//  Created by Tao Yunfei on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "b2TreeActor.h"
#import "b2Cell.h"
#import "b2CellFactory.h"
#import "CellSkinPool.h"
#import "CellSkin.h"

@implementation b2TreeActor


- (id)initWithCore:(b2ActorCore *)aCore{
    self = [super initWithCore:aCore];
    if (self) {
        
        [self setFilterCategory:b2ActorCategoryBackground mask:b2ActorMaskBackground];
        [self create];
    }
    return self;
}


-(void)create{

//    b2Cell* cell;
//    b2CellFactory* factory = [b2CellFactory sharedInstance];
    CGPoint pos = [core pos];
    
    
//    LOG_DEBUG(@"create flower idx -> %d  x->%f y ->%f",[core idx],pos.x,pos.y);
        
//        cell = [cellFactory createOrientedBoxCell:CGPointMake(pos.x,pos.y+3.2*i) halfW:1.6 halfH:1.6 angle:0 density:1.0 friction:0.3 restitution:0];
//        [cell body]->GetFixtureList()->SetFilterData(filter);
//        
//        if (i==0) {
//            [cell setType:b2_staticBody];
//        }else{
//            [cell setType:b2_dynamicBody];
//        }
//        
//        [cellIdxList addValue:[cell idx]];
    int z = [core z];
        
        
        CellSkin* skin = [cellSkinPool pick];
        if (arc4random()%2==1) {
            [skin showAs:@"tree1_stand1" z:z];
        }else {
            [skin showAs:@"tree1_stand2" z:z];
        }
        
        CGSize size = [skin size];

        
        pos.y += size.height/2-1;
        [skin setPosition:pos]; 
        
        [cellSkinIdxList addValue:[skin idx]];
          
}





@end
