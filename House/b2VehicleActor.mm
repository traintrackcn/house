//
//  b2VehicleActor.m
//  House
//
//  Created by Tao Yunfei on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "b2VehicleActor.h"
#import "b2CellFactory.h"
#import "b2Cell.h"
#import "b2CellPool.h"
#import "b2WorldManager.h"

@implementation b2VehicleActor

- (id)initWithCore:(b2ActorCore *)aCore{
    self = [super initWithCore:aCore];
    if (self) {
        [self setFilterCategory:b2ActorCategoryVehicle mask:b2ActorMaskVehicle];
        [self create];
    }
    return self;
}


- (void)create{
    b2Cell* wheel1;
    b2Cell* wheel2;
//    b2Cell* chassis;
    b2CellFactory* factory = [b2CellFactory sharedInstance];

    CGPoint pos = [core glPos];
//    LOG_DEBUG(@"create pos x->%f  y->%f",pos.x,pos.y);
    pos.y += 30;
    
    chassisCell = [factory createOrientedBoxCell:CGPointMake(pos.x, pos.y) halfW:48.0 halfH:20.0 radian:M_PI density:1.0 friction:0.3 restitution:0.0 ];
    [self appendCell:chassisCell filter:filter type:b2_dynamicBody];
//    [cellIdxList addValue:[chassis idx]];
//    [chassis setType:b2_dynamicBody];
//    [chassis body]->GetFixtureList()->SetFilterData(filter);
    
    float radius = 11.0;
    
    float wheelOffsetX = 31.0;
    float wheelOffsetY = 22;
    //wheel
    CGPoint wheel1Pos = CGPointMake(pos.x+wheelOffsetX,pos.y-wheelOffsetY);
    wheel1 = [factory createCircleCell:wheel1Pos raidus:radius density:1.0 friction:50.0 restitution:0.0];
    [self appendCell:wheel1 filter:filter type:b2_dynamicBody];
//    [cellIdxList addValue:[wheel1 idx]];
//    [wheel1 setType:b2_dynamicBody];
//    [wheel1 body]->GetFixtureList()->SetFilterData(filter);
    
    
    CGPoint wheel2Pos = CGPointMake(pos.x-wheelOffsetX,pos.y-wheelOffsetY);
    wheel2 = [factory createCircleCell:wheel2Pos raidus:radius density:1.0 friction:50.0 restitution:0.0];
    [self appendCell:wheel2 filter:filter type:b2_dynamicBody];
//    [cellIdxList addValue:[wheel2 idx]];
//    [wheel2 setType:b2_dynamicBody];
//    [wheel2 body]->GetFixtureList()->SetFilterData(filter);
//    [cell body]->ApplyForce(b2Vec2(1.0,0.0), [cell body]->GetPosition());
    
//    b2GearJointDef gearJointDef;
    
//    gearJointDef.
    
    b2RevoluteJointDef revoluteJointDef;
    revoluteJointDef.enableMotor = true;
    revoluteJointDef.Initialize([wheel1 body], [chassisCell body], b2Vec2((pos.x+wheelOffsetX)/PTM_RATIO,(pos.y-wheelOffsetY)/PTM_RATIO));

//    [chassis body]->ApplyTorque(15.0);
//    [wheel1 body]->ApplyTorque(15.0);
    
//    revoluteJointDef.motorSpeed = M_PI*5;
    revoluteJointDef.maxMotorTorque = 50;
    engine1 = (b2RevoluteJoint*)[self world]->CreateJoint(&revoluteJointDef);
    [jointList addValue:engine1];
    
    
//    revoluteJointDef.enableMotor = false;
    
    revoluteJointDef.Initialize([wheel2 body], [chassisCell body], b2Vec2((pos.x-wheelOffsetX)/PTM_RATIO,(pos.y-wheelOffsetY)/PTM_RATIO));
    engine2 = (b2RevoluteJoint*)[self world]->CreateJoint(&revoluteJointDef);
    [jointList addValue:engine2];

    
//    self.aabb =  [self chassisBody]->GetFixtureList()->GetAABB(0);
    
//    b2AABB nilAABB;
//    b2Fixture *fixture = body->GetFixtureList();
//    
//    if (fixture) {
//        self.aabb = fixture->GetAABB(0);
//    }
    //Yeah every fixture has 1 to m child fixtures. For fixtures with a single child (circle, polygon, edge), the index is zero. For chain shapes, the index is 0 to m-1.
    

    
    
//    [[HSDynamicTreeManager sharedInstance] createProxy:[self aabb] userData:nil];

}

- (b2Cell *)baseCell{
    return chassisCell;
}

- (b2Body *)chassisBody{
    return [self getBodyAtIdx:0];
}

- (b2Body *)wheel1Body{
    return [self getBodyAtIdx:1];
}

- (b2Body*)wheel2Body{
    return [self getBodyAtIdx:2];
}

- (void)stop{
    engine1->SetMotorSpeed(0);
    engine2->SetMotorSpeed(0);
}

- (void)backward{
    if (engine1->GetMotorSpeed()) {
        [self stop];
    }else{
        [self backwardAction];
    }
    
//    [self performSelector:@selector(backwardAction) withObject:self afterDelay:0.5];
}

- (void)backwardAction{
    engine1->SetMotorSpeed(-M_PI*3);
    engine2->SetMotorSpeed(-M_PI*3);  
}

- (void)forward{
    if (engine1->GetMotorSpeed()) {
        [self stop];
    }else {
        [self forwardAction];
    }
    
    
//    [self performSelector:@selector(forwardAction) withObject:self afterDelay:0.5];
}

- (void)forwardAction{
    engine1->SetMotorSpeed(M_PI*3);
    engine2->SetMotorSpeed(M_PI*3);    
}


- (void)update{
    LOG_DEBUG(@"update");
//    [self updateCellSkin:carBodySkin body:[self chassisBody]];
//    [self updateCellSkin:wheel1Skin body:[self wheel1Body]];
//    [self updateCellSkin:wheel2Skin body:[self wheel2Body]];
//    b2WorldManager *worldM = [b2WorldManager sharedInstance];
//    CGPoint layerPos = [worldM convertToLayerPos:[self chassisBody]];   //b2Pos
//    [core setPos:layerPos];
}


- (CGPoint)glPos{
//    LOG_DEBUG(@"_worldM %@":_worldM);
    b2WorldManager *worldM = [b2WorldManager sharedInstance];
    CGPoint pos = [worldM convertToGLPosInWorldForB2Pos:[self chassisBody]->GetPosition()];
    return pos;
}

- (void)lightUp{
//    [carBodySkin lightUp];
}

- (void)lightOff{
//    [carBodySkin lightOff];
}

@end
