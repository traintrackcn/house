//
//  MainLayer.h
//  House
//
//  Created by Tao Yunfei on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseLayer.h"
#import "cocos2d.h"

@class ScreenUtil;
@class CellSkin;
//@class b2MouseJoint;


@interface MainLayer : BaseLayer{
    ScreenUtil* screenUtil;
 
}

@property (nonatomic, strong) CellSkin* bacground;
//@property (nonatomic, strong) CellSkin* sun;
//@property (nonatomic, strong) CellSkin* moon;
//@property (nonatomic, strong) CellSkin* weatherSkin;

@end
