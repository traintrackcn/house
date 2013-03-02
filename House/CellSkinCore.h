//
//  CharacterO.h
//  House
//
//  Created by Tao Yunfei on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//




typedef enum {
    CellSkinResourceTypeSWF,
    CellSkinResourceTypePNG
}CellSkinResourceType;

typedef enum {
    CellSkinFPS12 = 12,
    CellSkinFPS24 = 24,
    CellSkinFPS30 = 30,
    CellSkinFPS31 = 31,
    CellSkinFPS60 = 60
}CellSkinFPS;


#import <Foundation/Foundation.h>

@interface CellSkinCore : NSObject{

    NSMutableDictionary *actODic;
}


- (NSString *)frameName:(int)idx;
- (NSString *)resourcePlist;
- (NSString *)actKey;
- (NSString *)directionKey;
- (int)frameNum;


@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) CellSkinResourceType resourceType;
@property (nonatomic, assign) CellSkinFPS fps;
@property (nonatomic, assign) float delay;

@end
