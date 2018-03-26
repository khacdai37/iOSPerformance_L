//
//  ThreadLockViewController.m
//  ThreadLock
//
//  Created by vodkhang on 19/05/11.
//  Copyright 2011 KDLab. All rights reserved.
//

#import "ThreadLockViewController.h"
@implementation ThreadLockViewController
@synthesize storages;
@synthesize lockedObj;

- (void)pushDataIn {
    @autoreleasepool {
        while (YES) {
            [testlock lock];
//            @synchronized(lockedObj) {
                [self.storages addObject:[NSObject new]];
                [NSThread sleepForTimeInterval:0.1];
//            }
            [testlock unlock];
        }
    }
}

- (void)popDataOut {
    @autoreleasepool {
        while (YES) {
//            [testlock lock];
            if ([testlock tryLock]) {
                
//            @synchronized(lockedObj) {
                if (self.storages.count > 0) {
                    NSObject *object = [self.storages objectAtIndex:0];
                    NSLog(@"object: %@", object);
                    [self.storages removeObjectAtIndex:0];
                }
                [testlock unlock];
            }
            
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    testlock = [[NSLock alloc]init];
    self.storages = [NSMutableArray array];
    self.lockedObj = [NSObject new];
    [NSThread detachNewThreadSelector:@selector(pushDataIn) toTarget:self withObject:nil];    
    [NSThread detachNewThreadSelector:@selector(popDataOut) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(popDataOut) toTarget:self withObject:nil];
}


@end
