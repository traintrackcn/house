//
//  BaseLayer.m
//  House
//
//  Created by Tao Yunfei on 12-2-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseLayer.h"




@interface BaseLayer()


@end


@implementation BaseLayer

- (id)init{
    self = [super init];
    if (self != nil) {
        
//        actorDic = [[NSMutableDictionary alloc] init];
        
        [self setIsTouchEnabled:YES];
        [self scheduleUpdate];
    }
    
    return self;
}




//-(void)draw{
//    [super draw];
//    
//    B2WorldManager *w = [B2WorldManager sharedInstance];
//
//    
//    glDisable(GL_TEXTURE_2D);
//    glDisableClientState(GL_COLOR_ARRAY);
//    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
//    
//    [w drawDebugData];
//    
//    // restore default GL states
//    glEnable(GL_TEXTURE_2D);
//    glEnableClientState(GL_COLOR_ARRAY);
//    glEnableClientState(GL_TEXTURE_COORD_ARRAY);            
//    
//    
////    LOG_METHOD;
//}
//
//
- (void)update:(ccTime)delta{

}

//- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
//    
////    [event set]
////    UITouch *touch = [touches anyObject]
////    NSObject *obj = [touch ]
//    
//    LOG_DEBUG(@"ccTouchBegan %@", touch);
//    
//    
//    return YES;
//}
//
//- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
//    LOG_DEBUG(@"ccTouchEnded %@", touch);
//    
//}
//
//- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
//    LOG_DEBUG(@"ccTouchMoved %@", touch);
//}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    LOG_DEBUG(@"ccTouchesBegan %@", touches);
//    UITouch *touch = [touches anyObject];
//    LOG_DEBUG(@"ccTouchesBegan  touch -> %@",touch);
    
    
//    CCArray *arr = [self children];
////    LOG_DEBUG(@"arr -> %@", arr);
//    DonkeyVC *donkey = [arr objectAtIndex:0];
//    [donkey testNextAct];
  
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    LOG_DEBUG(@"ccTouchesEnded %@", touches);
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    LOG_DEBUG(@"ccTouchesMoved %@", touches);
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
//    LOG_DEBUG(@"ccTouchesCancelled %@", touches);
}

//- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
//    LOG_DEBUG(@"touch %@", touch);
//}

//#pragma mark - actor

//- (void)addActor:(b2Actor *)actor{
//    [actorDic setObject:actor forKey:actor];
//}
//
//- (void)removeActor:(b2Actor *)actor{
//    [actorDic removeObjectForKey:actor];
//}


@end
