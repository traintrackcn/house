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
    b2ActorCategoryGround = 1,
    b2ActorCategoryAnimal = 2,
    b2ActorCategoryVehicle = 4,
    b2ActorCategory1 = 8,
    b2ActorCategory2 = 16,
    b2ActorCategory3 = 32,
    b2ActorCategory4 = 64,
    b2ActorCategory5 = 128
}b2ActorCategory;


typedef enum{
    b2ActorMaskGround = b2ActorCategoryVehicle,
    b2ActorMaskAnimal = b2ActorCategoryGround,
    b2ActorMaskVehicle = b2ActorCategoryGround,
    b2ActorMask1 = -1,
    b2ActorMask2 = -1,
    b2ActorMask3 = -1,
    b2ActorMask4 = -1,
    b2ActorMask5 = -1
}b2ActorMask;


@class b2Vec2List;

@interface HSActorBase : NSObject;


@property (nonatomic, assign) int proxyId;          // unique id of actor
@property (nonatomic, assign) int actorId;          // same as proxyId
@property (nonatomic, assign) b2AABB aabb;      // set aabb by specific fixture name
@property (nonatomic, assign) b2Filter filter;
@property (nonatomic, assign) CGPoint glPos;    // 0,0 in r.u.b.e cordinate
@property (nonatomic, assign) b2Vec2 b2Pos;

@property (nonatomic, strong) b2Vec2List *slotsG; //vertices of gournd ( when catagory is land, save )



#pragma mark - initialize methods

//+ (HSActorBase *)instanceWithKey:(NSString *)key;
//+ (HSActorBase *)instanceWithKey:(NSString *)key glPosOffset:(CGPoint)glPosOffset;
+ (HSActorBase *)instanceWithKey:(NSString *)key glPosOffset:(CGPoint)glPosOffset filter:(b2Filter)filter;


//- (id)initWithKey:(NSString *)key;
//- (id)initWithKey:(NSString *)key glPosOffset:(CGPoint)glPosOffset;
- (id)initWithKey:(NSString *)key glPosOffset:(CGPoint)glPosOffset filter:(b2Filter)filter;

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
