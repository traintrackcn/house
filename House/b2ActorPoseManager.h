//
//  b2ActorPoseManager.h
//  House
//
//  Created by Tao Yunfei on 12-4-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface b2ActorPoseManager : NSObject{
    NSMutableDictionary* dic;
}

+ (b2ActorPoseManager*)sharedInstance;

- (NSArray*)getActorPoseArr:(NSString*)key;
- (void)loadActorPoseArr:(NSString*)fileKey;

@end
