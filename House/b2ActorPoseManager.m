//
//  b2ActorPoseManager.m
//  House
//
//  Created by Tao Yunfei on 12-4-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "b2ActorPoseManager.h"



static b2ActorPoseManager* _sharedb2ActorPoseManager;

@implementation b2ActorPoseManager


+ (b2ActorPoseManager*)sharedInstance{
    if (!_sharedb2ActorPoseManager) {
        _sharedb2ActorPoseManager = [[b2ActorPoseManager alloc] init];
    }
    return _sharedb2ActorPoseManager;
}


- (id)init{
    self = [super init];
    if (self) {
        dic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSArray*)getActorPoseArr:(NSString *)key{
    NSArray* arr = [key componentsSeparatedByString:@"_"];
    NSString* fileKey = [arr objectAtIndex:0];    
    
    NSArray* poseArr = [dic objectForKey:fileKey];
    if (poseArr) {
        return poseArr;
    }
    
    [self loadActorPoseArr:fileKey];
    
    poseArr = [dic objectForKey:fileKey];
    
    return poseArr;
}

- (void)loadActorPoseArr:(NSString*)fileKey{
    NSError* err;
    NSString *fPath = [[NSBundle mainBundle] pathForResource:fileKey ofType:@"json"];
    LOG_DEBUG(@"fPath-> %@",fPath);
//    NSString* jsonStr = [[NSString alloc] initWithContentsOfFile:fPath encoding:NSUTF8StringEncoding error:&err];
    //    NSString* str = [NSString stringWithFormat:@"{\"hello\":\"hello\"}"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:fPath];
    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSArray* frames = [jsonObj objectForKey:@"data"];
    if (err) {
        LOG_DEBUG(@"err userInfo -> %@",[err userInfo]);
    }
    [dic setObject:frames forKey:fileKey];
}

//- (NSDictionary *)convertPose:(NSArray*)pose{
//    
//}

@end
