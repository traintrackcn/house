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



class b2WorldManagerCInterface{
    public:
    bool QueryCallback(int proxyId);
};






@class b2TerrainManager;
@class b2ActorCore;
//@class GLESDebugDraw;
@class ScreenUtil;


@interface b2WorldManager :NSObject{
    b2World* world;   
    b2DynamicTree tree;
    b2AABB queryAABB;
	b2RayCastInput rayCastInput;
	b2RayCastOutput rayCastOutput;     
    b2WorldManagerCInterface cInterface;
    NSMutableDictionary *treeUserDataDic;
    int numInView;
    CGPoint targetPos;
    float targetScale;    
    ScreenUtil* screenUtil;
    GLESDebugDraw* debugDraw;
}

+ (b2WorldManager*)sharedInstance;

+ (b2World*)sharedb2World;

- (b2DynamicTree) tree;

- (b2WorldManager*)worldM;
- (b2World*)world;

- (void)step:(float)delta;
- (void)drawDebugData;

- (CGPoint)convertToLayerPos:(b2Body *)body;
- (int)treeCreateProxy:(b2AABB)aabb userData:(id)userData;
- (void)treeDeleteProxy:(int)proxyId;
- (id)treeGetUserData:(int)proxyId;
- (bool)QueryCallbackProcess:(int)proxyId;

- (void)zoomTo:(float)aScale;
- (void)moveTo:(CGPoint)aPos;

@property(nonatomic, assign) CGPoint pos;
@property(nonatomic, assign) float scale;

@property(nonatomic, assign) BOOL showDebugDraw;


@end
