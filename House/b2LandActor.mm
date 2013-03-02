//
//  b2TerrainActor.m
//  House
//
//  Created by Tao Yunfei on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "b2LandActor.h"
#import "b2CellFactory.h"
#import "b2MapEngine.h"
#import "b2Cell.h"
#import "CellSkin.h"
#import "CellSkinPool.h"

@implementation b2LandActor

- (id)initWithCore:(b2ActorCore *)aCore{
    self = [super initWithCore:aCore];
    if (self) {
        [self setFilterCategory:b2ActorCategoryLand mask:b2ActorMaskLand];
        [self create];
    }
    
    return self;
}


- (void)create{

    b2Cell* cell;
    b2CellFactory* factory = [b2CellFactory sharedInstance];    

    cell = [factory createEdgeCell:[core pos] p1:[core p1] p2:[core p2] density:1.0 friction:0.3 restitution:0.0];
    [cellIdxList addValue:[cell idx]];
//    cell = [factory createOrientedBoxCell:[core pos] halfW:4.0 halfH:1.6 angle:[core angle] density:1.0 friction:0.3 restitution:0.0];    
//    [cellIdxList addValue:[cell idx]];
    
    
    
    int landOffset = [core landOffset];
    NSString* landKey = [NSString stringWithFormat:@"land1_%d",landOffset];
//    LOG_DEBUG(@"landKey -> %@",landKey);

    CellSkin* skin = [cellSkinPool pick];
    [skin showAs:landKey z:[core z]];

    
    CGSize size = [skin size];
    CGPoint pos = [core pos];
    
    pos.x += TERRAIN_KEY_STEP_HALF;
    pos.y -= size.height/2;
    if(landOffset>0) pos.y += landOffset;
    [skin setPosition:pos]; 
//    [skin setChangeWithLight:NO];
    
    [cellSkinIdxList addValue:[skin idx]];    
    
    
}





@end
