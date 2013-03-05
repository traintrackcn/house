//
//  AppDelegate.m
//  cocos2d_chipmunk_lib
//
//  Created by Tao Yunfei on 11-11-23.
//  Copyright __MyCompanyName__ 2011年. All rights reserved.
//
#import "cocos2DAppDelegate.h"
#import "SceneManager.h"
#import "HSMainLayer.h"
#import "OpenUDID.h"

@interface cocos2DAppDelegate()

@end

@implementation cocos2DAppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
//    [application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    LOG_DEBUG(@"UDID: %@", [OpenUDID value]);
    
    director = (CCDirectorIOS*)[CCDirector sharedDirector];
    
    [director setDelegate:self];
    
//    [CellSkinPool sharedInstance];
    
    if( ! [director enableRetinaDisplay:YES] ) {
        LOG_DEBUG(@"Retina Display Not supported");
    }else {
        LOG_DEBUG(@"Retina Display supported");
    }
    
    
    
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
	// When in iPhone RetinaDisplay, iPad, iPad RetinaDisplay mode, CCFileUtils will append the "-hd", "-ipad", "-ipadhd" to all loaded files
	// If the -hd, -ipad, -ipadhd files are not found, it will load the non-suffixed version
	[CCFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[CCFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "" (empty string)
	[CCFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"    
    
    
	[director setAnimationInterval:1.0/60.0];
    [director setDepthTest:NO];
    [director setDisplayStats:YES];
    
    
	// Create the CCGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBounds.size;
    
//    screenBounds = CGRectMake(60.0f, -10.0f, screenBounds.size.width - 60.0f, screenBounds.size.height -240.0f);
    
    LOG_DEBUG(@"screen size width->%f height->%f",screenSize.width,screenSize.height);    
	
    CCGLView* glView = [CCGLView viewWithFrame:screenBounds
                                   pixelFormat:kEAGLColorFormatRGBA8
                                   depthFormat:0 /* GL_DEPTH_COMPONENT24_OES */
                            preserveBackbuffer:NO
                                    sharegroup:nil
                                 multiSampling:NO
                               numberOfSamples:0
                        ];
    
    
    
    
    [director setView:glView];
    [director setWantsFullScreenLayout:YES];   
    
	window = [[UIWindow alloc] initWithFrame:screenBounds];

    [window setUserInteractionEnabled:YES];
//    [window setMultipleTouchEnabled:YES];
    
    
    [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];

//    ccp(10, 10);

    CCScene *scene = [SceneManager sharedScene];
    // Run the intro Scene
//    LOG_DEBUG(@"director runWithScene");
    [director pushScene:scene];
    LOG_DEBUG(@"after runWithScene");
    
//    CellSkin* bgSkin = [[CellSkinPool sharedInstance] pick];
//    [bgSkin showAs:@"bg1_afternoon" z:-2];
    //init
    [SceneManager sharedLayer];
    
//    [layer setBacground:bgSkin];
    
//    [[DayAndNightManager sharedInstance] run];
    
    [window setRootViewController:director];
    [window makeKeyAndVisible];
    
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
	[director pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[director resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[director purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[director stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
    LOG_DEBUG(@"applicationWillEnterForeground startAnimation");
    [director startAnimation];

	
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CC_DIRECTOR_END();
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[director setNextDeltaTimeZero:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    LOG_DEBUG(@"interfaceOrientation -> %d",interfaceOrientation);
//    [screenUtil update:interfaceOrientation];
    return YES;
}




@end
