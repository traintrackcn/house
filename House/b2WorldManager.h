//
//  b2WorldManager.h
//  House
//
//  Created by Tao Yunfei on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "GLES-Render.h"






@interface b2WorldManager :NSObject{
    
}

+ (b2WorldManager*)sharedInstance;

+ (b2World*)sharedb2World;

//- (b2DynamicTree) tree;
- (b2World*)world;

- (void)step:(float)delta;
- (void)drawDebugData;




- (void)zoomTo:(float)aScale;
- (void)moveTo:(CGPoint)aPos;

- (CGPoint)convertToGLPosInWorldForB2Pos:(b2Vec2)b2Pos;
- (b2Vec2)convertToB2PosForGLPosClickedInWorld:(CGPoint)glPosClickedInWorld;


@property(nonatomic, assign) CGPoint pos;
@property(nonatomic, assign) float scale;

@property(nonatomic, assign) BOOL showDebugDraw;


@end
