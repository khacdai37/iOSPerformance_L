//
//  ThreadLockAppDelegate.m
//  ThreadLock
//
//  Created by vodkhang on 19/05/11.
//  Copyright 2011 KDLab. All rights reserved.
//

#import "ThreadLockAppDelegate.h"
#import "ThreadLockViewController.h"

@interface ClassM: NSObject
@end
@implementation ClassM
@end

@interface ClassA: NSObject
 @property (nonatomic, weak) id delegate;
-(void)printA;
@end
@implementation ClassA
-(void)printA {
    NSLog(@"Class A");
}
@end

@interface ClassB: NSObject
@property (nonatomic, weak) id delegate;
@end
@implementation ClassB
-(instancetype)init {
    self = [super init];
    if (self) {
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            NSLog(@"Delegate %@", self.delegate);
            [(ClassA*)self.delegate printA];
        });
    }
    return self;
}
@end





@interface ThreadLockAppDelegate()
@property (nonatomic, strong) ClassM *MC;
@end
@implementation ThreadLockAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

	// Set the view controller as the window's root view controller and display.
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    self.MC = [[ClassM alloc]init];
    
    [ThreadLockAppDelegate ac:self.MC];
    
    return YES;
}
+ (void)ac:(ClassM *) m {
    
    ClassA *a = [[ClassA alloc] init];
    a.delegate = m;
    
    ClassB *b = [[ClassB alloc]init];
    b.delegate = a;
}
@end




