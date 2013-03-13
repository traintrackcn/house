//
//  HSActorDescriptionManager.m
//  House
//
//  Created by traintrackcn on 13-3-7.
//
//

#import "HSActorDescriptionManager.h"

static HSActorDescriptionManager * ____instanceHSActorDescriptionManager;

@interface HSActorDescriptionManager() {
    NSMutableDictionary *data;
}

@end

@implementation HSActorDescriptionManager

+ (HSActorDescriptionManager *)sharedInstance{
    if (____instanceHSActorDescriptionManager == nil) {
        ____instanceHSActorDescriptionManager = [[HSActorDescriptionManager alloc] init];
    }
    return ____instanceHSActorDescriptionManager;
}

- (id)init{
    self = [super init];
    if (self) {
        data = [NSMutableDictionary dictionary];
        
        
        //init actor descriptions
        NSArray *arr = [NSArray arrayWithObjects:
                        kActorDescriptionTerrain1,
                        kActorDescriptionCar1,
                        kActorDescriptionStationTiny,
                        nil];
        for (int i=0; i<[arr count]; i++ ) {
            NSString *key = [arr objectAtIndex:i];
            [self addValueForKey:key];
        }
        
       
        
    }
    return self;
}


#pragma mark - operations

- (void)addValueForKey:(NSString *)key{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:key ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];

    if (jsonData){
        id worldValue = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        [self addValue:worldValue forKey:key];
    }else{
         LOG_ERROR(@"load  file -> %@ error", filePath);
    }
}

- (void)addValue:(id)value forKey:(NSString *)key{
    
//    LOG_DEBUG(@"addValueForKey -> %@  value -> %@", key, value);
    
    [data setObject:value forKey:key];
}

- (id)getValueForKey:(NSString *)key{
    return [data objectForKey:key];
}

- (void)deleteValueForKey:(NSString *)key{
    [data removeObjectForKey:key];
}


@end
