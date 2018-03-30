//
//  ThreadLockViewController.m
//  ThreadLock
//
//  Created by vodkhang on 19/05/11.
//  Copyright 2011 KDLab. All rights reserved.
//

#import "ThreadLockViewController.h"
@interface ThreadLockViewController()
{
    NSCondition *condition;
}
@end
@implementation ThreadLockViewController
@synthesize storages;
@synthesize lockedObj;

- (void)pushDataIn {
    @autoreleasepool {
        while (YES) {
            [condition lock];
//          [testlock lock];
//          @synchronized(lockedObj) {
            NSLog(@"pushDataIn Start");
            [self.storages addObject:[NSObject new]];
            [NSThread sleepForTimeInterval:0.1];
//         }
//          [testlock unlock];
            [condition signal];
            [condition unlock];
            NSLog(@"pushDataIn End");
        }
    }
}

- (void)popDataOut {
    @autoreleasepool {
        while (YES) {
            [condition lock];
//            [testlock lock];
//            if ([testlock tryLock]) {
//            @synchronized(lockedObj) {
            NSLog(@"popDataOut Start");
            while (self.storages.count <= 0) {
                [condition wait];
                NSLog(@"popDataOut Waiting...");
            }
            NSObject *object = [self.storages objectAtIndex:0];
            NSLog(@"object: %@", object);
            [self.storages removeObjectAtIndex:0];
//            }
//            [testlock unlock];
            [condition unlock];
            NSLog(@"popDataOut End");
            
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    condition = [[NSCondition alloc]init];
    testlock = [[NSLock alloc]init];
    self.storages = [NSMutableArray array];
    self.lockedObj = [NSObject new];
//    [NSThread detachNewThreadSelector:@selector(pushDataIn) toTarget:self withObject:nil];    
//    [NSThread detachNewThreadSelector:@selector(popDataOut) toTarget:self withObject:nil];
//    [NSThread detachNewThreadSelector:@selector(popDataOut) toTarget:self withObject:nil];
    
}
- (void)loadView {

    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
//            [super loadView];
    self.view.backgroundColor = [UIColor redColor];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
