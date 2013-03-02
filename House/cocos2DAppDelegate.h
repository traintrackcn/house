//
//  AppDelegate.h
//  cocos2d_chipmunk_lib
//
//  Created by Tao Yunfei on 11-11-23.
//  Copyright __MyCompanyName__ 2011年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
//@class CCDirector;
@class ScreenUtil;

@interface cocos2DAppDelegate : NSObject <UIApplicationDelegate, CCDirectorDelegate> {
	UIWindow* window;
    CCDirector* director;
    ScreenUtil* screenUtil;
}

@property (nonatomic, retain) UIWindow *window;

@end
