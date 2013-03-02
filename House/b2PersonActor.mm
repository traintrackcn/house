//
//  b2PersonActor.m
//  House
//
//  Created by Tao Yunfei on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "b2PersonActor.h"
#import "b2CellFactory.h"
#import "b2Cell.h"
#import "b2ActorPoseManager.h"
#import "CellSkinPool.h"
#import "CellSkin.h"


@implementation b2PersonActor


- (id)initWithCore:(b2ActorCore *)aCore{
    self = [super initWithCore:aCore];
    if (self) {
        [self setFilterCategory:b2ActorCategoryPlayer mask:b2ActorMaskPlayer];
        [self create];
    }
    return self;
}

- (void)create{
    
    NSArray* poseArr = [actorPoseM getActorPoseArr:@"person_stand"];
    b2CellFactory* factory = [b2CellFactory sharedInstance];
    
    poseCount = [poseArr count];
    
//    b2Cell* cell;
    CGPoint pos = [core pos];
    pos.y += 5;
    
    int z = [core z];
//    int poseIdx = 0;

    NSArray* boneArr = [poseArr objectAtIndex:poseIdx];
    for (int i=0; i<[boneArr count]; i++) {
        NSArray* bone = [boneArr objectAtIndex:i];
//        float centerX = [[bone objectAtIndex:0] floatValue];
//        float centerY = [[bone objectAtIndex:1] floatValue];
//        float angle = [[bone objectAtIndex:2] floatValue];
//        float radian = [[bone objectAtIndex:3] floatValue];
        float len = round([[bone objectAtIndex:4] floatValue]); 
        NSString* skinKey = [NSString stringWithFormat:@"bone1_%.0f",len];
//        LOG_DEBUG(@"centerX:%f centerY:%f angle:%f radian:%f len:%f skinKey:%@",centerX,centerY,angle,radian,len,skinKey);        
//        cell = [factory createOrientedBoxCell:ccp(pos.x+centerX,pos.y+centerY) halfW:1.6 halfH:(len/2) radian:radian density:1.0 friction:0.3 restitution:0.0];
//        [self appendCell:cell filter:filter type:b2_staticBody];

        [self appendCellSkin:skinKey  z:z];
    }


    
    
    wheel1 = [factory createCircleCell:pos raidus:5.0 density:10.0 friction:10.0 restitution:0.0];
    [self appendCell:wheel1 filter:filter type:b2_dynamicBody];
    
    wheel2 = [factory createCircleCell:ccp(pos.x,pos.y+85) raidus:10.0 density:0.0 friction:0.0 restitution:0.0];
    [self appendCell:wheel2 filter:filter type:b2_dynamicBody];
    
    engine = [self createRevoluteJointAt:pos cell1:wheel1 cell2:wheel2 enableMotor:true enableLimit:false upperAngle:0.0 lowerAngle:0.0];



}




- (void)update{

    [self nextPose];
    
    NSArray* poseArr = [actorPoseM getActorPoseArr:@"person_stand"];
    NSArray* boneArr = [poseArr objectAtIndex:poseIdx];    
    
    //    return;
    for (int i=0; i<[cellSkinIdxList count]; i++) {
        int idx = [cellSkinIdxList getValue:i];
        CellSkin* skin = [cellSkinPool getValue:idx];
        NSArray* bone = [boneArr objectAtIndex:i];
        [self updateCellSkin:skin bone:bone];
    }
    
    [self updateCorePos];
}



- (b2Cell *)baseCell{
    return wheel1;
}


- (CGPoint)realPos{
    return [self convertToLayerPos:[wheel1 body]->GetPosition()];
}

- (void)forward{
    if (engine->GetMotorSpeed()) {
        [self stop];
    }else {
          engine->SetMotorSpeed(M_PI*3);
    }
}

- (void)backward{
    if (engine->GetMotorSpeed()) {
        [self stop];
    }else {
        engine->SetMotorSpeed(-M_PI*3);
    }  
}

- (void)stop{
    engine->SetMotorSpeed(0);
}

@end
