//
//  ViewController.m
//  NSThreadAndRunLoopDemo
//
//  Created by Cantoraz Chou on 8/1/16.
//  Copyright © 2016 Cantoraz Chou. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSPort* port;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self memoryTest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)memoryTest
{
    for (int i = 0; i < 100000; ++i) {
        NSThread* thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadMain) object:nil];
        [thread start];
        NSLog(@"%d - %@", i, thread);
        [self performSelector:@selector(stopThread) onThread:thread withObject:nil waitUntilDone:YES];
    }
}

- (void)threadMain
{
    @autoreleasepool {
        NSLog(@"Current Thread = %@", [NSThread currentThread]);
        NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
        if (!_port) {
            self.port = [NSMachPort port];
        }
        [runLoop addPort:_port forMode:NSDefaultRunLoopMode];
        
//        [runLoop run];
//        [runLoop runUntilDate:[NSDate distantFuture]];
//        [runLoop runMode:NSRunLoopCommonModes beforeDate:[NSDate distantFuture]];
        CFRunLoopRun();
    }
}

- (void)stopThread
{
    CFRunLoopStop(CFRunLoopGetCurrent());
//    NSThread* thread = [NSThread currentThread];
//    [thread cancel];
}

@end
