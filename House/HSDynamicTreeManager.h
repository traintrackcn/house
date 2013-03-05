//
//  HSDynamicTreeManager.h
//  House
//
//  Created by traintrackcn on 13-3-5.
//
//

#import <Foundation/Foundation.h>
#import "Box2D.h"


class HSDynamicTreeManagerCInterface{
public:
    bool QueryCallback(int proxyId);
};



@interface HSDynamicTreeManager : NSObject

+ (HSDynamicTreeManager*)sharedInstance;

- (int)createProxy:(b2AABB)aabb userData:(id)userData;
- (void)destoryProxy:(int)proxyId;
- (id)getUserData:(int)proxyId;

- (void)query;

@end
