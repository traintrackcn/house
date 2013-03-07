//
//  HSActorDescriptionManager.h
//  House
//
//  Created by traintrackcn on 13-3-7.
//
//

#import <Foundation/Foundation.h>



#define kActorDescriptionTestCar @"testCar"
#define kActorDescriptionTerrain1 @"terrain1"


@interface HSActorDescriptionManager : NSObject

+ (HSActorDescriptionManager *)sharedInstance;

- (void)addValueForKey:(NSString *)key;
- (void)addValue:(id)value forKey:(NSString *)key;
- (id)getValueForKey:(NSString *)key;
- (void)deleteValueForKey:(NSString *)key;

@end