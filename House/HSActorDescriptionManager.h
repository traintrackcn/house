//
//  HSActorDescriptionManager.h
//  House
//
//  Created by traintrackcn on 13-3-7.
//
//

#import <Foundation/Foundation.h>



#define kActorDescriptionCar1 @"car1"
#define kActorDescriptionTerrain1 @"terrain1"
#define kActorDescriptionStationTiny @"stationTiny"


@interface HSActorDescriptionManager : NSObject

+ (HSActorDescriptionManager *)sharedInstance;

- (void)addValueForKey:(NSString *)key;
- (void)addValue:(id)value forKey:(NSString *)key;
- (id)getValueForKey:(NSString *)key;
- (void)deleteValueForKey:(NSString *)key;




@end
