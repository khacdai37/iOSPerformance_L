//
//  ViewController.m
//  GCDExample
//
//  Created by Dai Nguyen Khac on 3/29/18.
//  Copyright © 2018 Dai Nguyen Khac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSMutableArray *mutableArray;
    dispatch_queue_t _queue;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mutableArray = [NSMutableArray new];
    _queue = dispatch_queue_create("com.GCD.main", DISPATCH_QUEUE_CONCURRENT);
    [self performQueue];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnAction:(id)sender {
//    dispatch_resume(_queue);
}
- (void)performQueue {
    [self semaphoreDispatch];
}

- (void)semaphoreDispatch {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    for (int i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);// counter is decreased by one
            //The counter of the dispatch semaphore is always zero here.
            [array addObject:[NSNumber numberWithInt:i]];
            dispatch_semaphore_signal(semaphore);// increase the counter of the dispatch semaphore.
        });
    }
    NSLog(@"%ld", array.count);
    
}

- (void)resumeAndSubpendQueue {
    dispatch_suspend(_queue);
    dispatch_async(_queue, ^{
        [self dispatchApply];
    });
    dispatch_async(_queue, ^{
        NSLog(@"blk2");
    });
}

- (void)dispatchApply {
    dispatch_queue_t queue = dispatch_queue_create("com.GCD.dispatchApply", DISPATCH_QUEUE_CONCURRENT);
    dispatch_apply(10, queue, ^(size_t index) {
        NSLog(@"%zu", index);
    });
    NSLog(@"finish");
    
}
- (void)deadlockWithSync {
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        dispatch_sync(queue, ^{
            
        });
        
    });
}
- (void)dispatchGroupImplement {
    dispatch_queue_t queue = dispatch_queue_create("com.GCDEx", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        NSLog(@"blk0");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"blk1");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"blk2");
    });
    dispatch_group_notify(group, queue, ^{
        NSLog(@"done");
    });
    
//    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 2ull * NSEC_PER_SEC);
//    long result = dispatch_group_wait(group, time);
//    if (result == 0) {
//        NSLog(@"done");
//    }else {
//        NSLog(@"not done");
//    }
//    NSLog(@"hi there!");
    
}
- (void)compareAsyncAndSync {
    NSLog(@"1");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"2");
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });

}
- (void)useMultiQueue {
    dispatch_queue_t queue1 = dispatch_queue_create("concurrent_demo1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("concurrent_demo2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue3 = dispatch_queue_create("concurrent_demo3", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue4 = dispatch_queue_create("concurrent_demo4", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue5 = dispatch_queue_create("concurrent_demo5", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue1, ^{
        NSLog(@"1");
        [self doWithMutableArray];
    });
    dispatch_async(queue2, ^{
        NSLog(@"2");
        [self doWithMutableArray];
    });
    dispatch_async(queue3, ^{
        NSLog(@"3");
        [self doWithMutableArray];
    });
    dispatch_async(queue4, ^{
        NSLog(@"4");
        [self doWithMutableArray];
    });
    dispatch_async(queue5, ^{
        NSLog(@"5");
        [self doWithMutableArray];
    });
}
- (void)maxThreadCreateWithGCD {
    for (int i=1; i<30000; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval:100000];
        });
    }
}
- (void)doWithMutableArray {
    if (mutableArray.count > 0) {
        [mutableArray removeObjectAtIndex:0];
    }else {
        [mutableArray addObject:[NSObject new]];
    }
}
@end
