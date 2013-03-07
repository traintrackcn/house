//
//  b2BodyList.m
//  House
//
//  Created by traintrackcn on 13-3-6.
//
//

#import "b2BodyList.h"

@interface b2BodyList (){
    b2Body** arr;
    NSMutableDictionary *nameIdxMap;
}

@end


@implementation b2BodyList


- (id)initWithSize:(int)size{
    self = [super initWithSize:size];
    if (self) {
        arr = new b2Body*[size];
        nameIdxMap = [NSMutableDictionary dictionaryWithCapacity:size];
    }
    return self;
}

- (void)addValue:(b2Body *)value{
    int idx = count;
    arr[idx] = value;
    [self countPP];
}

- (void)addValue:(b2Body *)value withName:(NSString *)name{
    [nameIdxMap setObject:[NSNumber numberWithInt:count] forKey:name];
    [self addValue:value];
}

- (b2Body *)getValueAt:(int)idx{
    return arr[idx];
}

- (b2Body *)getValueByName:(NSString *)name{
    int idx = [[nameIdxMap objectForKey:name] intValue];
    return [self getValueAt:idx];
}

- (void)free{
    delete[] arr;    
}

@end
