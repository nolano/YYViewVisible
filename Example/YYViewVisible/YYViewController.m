//
//  YYViewController.m
//  YYViewVisible
//
//  Created by yuyuan yue on 12/17/2021.
//  Copyright (c) 2021 yuyuan yue. All rights reserved.
//

#import "YYViewController.h"
#import <YYViewVisible/YYViewCycle.h>

@interface YYViewController ()

@end

@implementation YYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    YYViewAction *everyTimeAction = [YYViewAction actionWithLimit:0.5 handler:^(YYViewAction * _Nonnull action) {
        if (action.isAnswer) {
            NSLog(@"可见啦");
        }else {
            NSLog(@"不可见啦");
        }
    }];
    
    /// 此回调为状态改变时回调，当设置callBackTime == 0时，可以与上面的handler配合使用（比如停留需求）
    everyTimeAction.stateUpdateHandler = ^(YYViewAction * _Nonnull action) {
        if (action.isAnswer) {
            NSLog(@"可见啦");
        }else {
            NSLog(@"不可见啦");
        }
    };
    
    /// 设置为0，每次都会回调，设置为1，则状态改变回调
    everyTimeAction.callBackTime = 0;
    
    [[YYViewCycle shared] registerView:self.view actions:@[everyTimeAction]];
}


@end
