//
//  HSDynamicTreeManager.m
//  House
//
//  Created by traintrackcn on 13-3-5.
//
//

#import "HSDynamicTreeManager.h"
#import "b2WorldManager.h"


@interface HSDynamicTreeManager(){
    NSMutableDictionary *userDataDic;
    HSDynamicTreeManagerCInterface cInterface;
    b2WorldManager *worldM;
    b2DynamicTree tree;
    
    b2RayCastInput rayCastInput;
	b2RayCastOutput rayCastOutput;
    
    float screenWHalf;
    float screenHHalf;
}

@end


static HSDynamicTreeManager *____instanceHSDynamicTreeManager;

@implementation HSDynamicTreeManager

+ (HSDynamicTreeManager *)sharedInstance{
    if (____instanceHSDynamicTreeManager == nil) {
        ____instanceHSDynamicTreeManager = [[HSDynamicTreeManager alloc] init];
    }
    return ____instanceHSDynamicTreeManager;
}

- (id)init{
    self = [super init];
    if (self) {
        userDataDic = [NSMutableDictionary dictionary];
        worldM = [b2WorldManager sharedInstance];
        screenWHalf = [[TDeviceUtil sharedInstance] screenWidthHalf];
        screenHHalf = [[TDeviceUtil sharedInstance] screenHeightHalf];
    }
    return self;
}


#pragma mark - 


#pragma mark - b2DynamicTree function

- (int)createProxy:(b2AABB)aabb userData:(id)userData{
//    return 0;
    int proxyId = tree.CreateProxy(aabb, nil);
//    NSNumber *key = [NSNumber numberWithInt:proxyId];
//    [userDataDic setObject:userData forKey:key];
    return proxyId;
}


- (void)destoryProxy:(int)proxyId{
    tree.DestroyProxy(proxyId);
    
    NSNumber *key = [NSNumber numberWithInt:proxyId];
    
    [userDataDic removeObjectForKey:key];
    
}

- (id)getUserData:(int)proxyId{
    NSNumber *key = [NSNumber numberWithInt:proxyId];
    return [userDataDic objectForKey:key];
}

- (void)moveProxy:(int)proxyId{
    //    tree.MoveProxy(proxyId, <#const b2AABB &aabb1#>, <#const b2Vec2 &displacement#>);
    
    //    b2AABB aabb0 = actor->aabb;
    //    MoveAABB(&actor->aabb);
    //    b2Vec2 displacement = actor->aabb.GetCenter() - aabb0.GetCenter();
    //    m_tree.MoveProxy(actor->proxyId, actor->aabb, displacement);
    
}


#pragma mark - query section
static int numInView;
- (void)query{
    b2AABB queryAABB;
    
    float scale = [worldM scale];
    CGPoint pos = [worldM pos];
    
    queryAABB.lowerBound.Set((pos.x-screenWHalf/scale)/PTM_RATIO, (pos.y-screenHHalf/scale)/PTM_RATIO );
    queryAABB.upperBound.Set((pos.x+screenWHalf/scale)/PTM_RATIO, (pos.y+screenHHalf/scale)/PTM_RATIO );
    
    //    LOG_DEBUG(@"queryAABB lowerBound %f %f", queryAABB.lowerBound.x, queryAABB.lowerBound.y);
    //
    //    LOG_DEBUG(@"queryAABB upperBound %f %f", queryAABB.upperBound.x, queryAABB.upperBound.y);
    
    //    rayCastInput.p1.Set(-5.0, 5.0f );
    //    rayCastInput.p2.Set(7.0f, -4.0f );
    //    rayCastInput.maxFraction = 1.0f;
    
    numInView = 0;
    
    tree.Query(&cInterface, queryAABB);
    //    b2_nullNode
    
    //    LOG_DEBUG(@"query mid ............");
    
    //检测已经移出边界的actor
    
    //    NSArray *arr = [treeUserDataDic allValues];
    //    int num = [arr count];
    //    b2Actor *actor;
    //    for (int i=0;i<num;i++){
    //        actor = [arr objectAtIndex:i];
    //        if ([actor proxyId] == b2_nullNode) continue;
    //
    //        bool overlap = b2TestOverlap(queryAABB, [actor aabb]);
    //        if(!overlap) [actor setOverlap:overlap]; //已经移出边界
    //    }
    
//    LOG_DEBUG(@"query end ............  numInView -> %d",numInView);
    
}



- (bool)QueryCallback:(int)proxyId{
//    LOG_DEBUG(@"proxyId -> %d", proxyId);
    //    b2Actor *actor = [self treeGetUserData:proxyId];
    //    bool overlap = b2TestOverlap(queryAABB, [actor aabb]);
    //    if(!overlap) [actor setOverlap:overlap];
    //    LOG_DEBUG(@"proxyId -> %d", proxyId);
    //    [actor setOverlap:true];
//    LOG_DEBUG(@"QueryCallback proxyId -> %d", proxyId);
    numInView++;
    
    return YES;
}



//float32 RayCastCallback(const b2RayCastInput& input, int32 proxyId)
//{
//    Actor* actor = (Actor*)m_tree.GetUserData(proxyId);
//
//    b2RayCastOutput output;
//    bool hit = actor->aabb.RayCast(&output, input);
//
//    if (hit)
//    {
//        m_rayCastOutput = output;
//        m_rayActor = actor;
//        m_rayActor->fraction = output.fraction;
//        return output.fraction;
//    }
//    
//    return input.maxFraction;
//}



@end




bool HSDynamicTreeManagerCInterface::QueryCallback(int proxyId){
    
    //    LOG_DEBUG(@"proxyId -> %d", proxyId);
    
    HSDynamicTreeManager *dynamicTreeM  = [HSDynamicTreeManager sharedInstance];
    [dynamicTreeM QueryCallback:proxyId];
    
    return true;
}

