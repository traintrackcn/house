//
//  b2ActorEnum.h
//  House
//
//  Created by Tao Yunfei on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef House_b2ActorEnum_h
#define House_b2ActorEnum_h

typedef enum{
    b2ActorCategoryLand = 1,
    b2ActorCategoryPlayer = 2,
    b2ActorCategoryVehicle = 4,
    b2ActorCategoryBackground = 8,
    b2ActorCategoryTrain = 16,
    b2ActorCategoryAircraft = 32,
    b2ActorCategory4 = 64,
    b2ActorCategory5 = 128
}b2ActorCategory;


typedef enum{
    b2ActorMaskLand = b2ActorCategoryPlayer|b2ActorCategoryVehicle,
    b2ActorMaskPlayer = b2ActorCategoryLand,
    b2ActorMaskVehicle = b2ActorCategoryLand,
    b2ActorMaskBackground = 0,
    b2ActorMask2 = -1,
    b2ActorMask3 = -1,
    b2ActorMask4 = -1,
    b2ActorMask5 = -1
}b2ActorMask;

//typedef enum {
//    b2ActorTypeLand = 0,
//    b2ActorTypeTree,
//    b2ActorTypePerson,
//    b2ActorTypeCar,
//    b2ActorTypeTrain
//    //    b2ActorType
//}b2ActorType;

#endif
