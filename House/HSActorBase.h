//
//  b2ActorComplex.h
//  House
//
//  Created by traintrackcn on 13-3-5.
//
//

#import <Foundation/Foundation.h>
//#import "b2Actor.h"
#import "Box2D.h"



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

@interface HSActorBase : NSObject;


@property (nonatomic, assign) int proxyId;          // unique id of actor
@property (nonatomic, assign) int actorId;          // same as proxyId
@property (nonatomic, assign) b2AABB aabb;      // set aabb by specific fixture name
@property (nonatomic, assign) b2Filter filter;
@property (nonatomic, assign) CGPoint glPos;    // 0,0 in r.u.b.e cordinate
@property (nonatomic, assign) b2Vec2 b2Pos;



#pragma mark - initialize methods

//+ (id)instance;

- (id)initWithKey:(NSString *)key;

#pragma mark - properties

- (b2Body *)b2Bodyy;


#pragma mark - actions

- (void)actionForward;
- (void)actionBackward;
- (void)actionStop;


#pragma mark - 

- (void)setFilterCategory:(int)category mask:(int)mask;
- (void)free;

@end
