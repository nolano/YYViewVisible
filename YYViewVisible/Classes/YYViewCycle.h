//
//  YYViewCycle.h
//
//  Created by last on 2021/10/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YYViewAction;

typedef void(^YYViewActionBlock)(YYViewAction *action);

@interface YYViewAction : NSObject

///限制条件,范围0-1，出现多少会回调
@property (nonatomic, assign,readonly) CGFloat limit;

///回调次数， 默认1，状态改变回调，0每次设置状态都会回调
@property (nonatomic,assign) NSInteger callBackTime;

@property (nonatomic, assign,readonly) BOOL isAnswer;

@property (nonatomic, copy) YYViewActionBlock stateUpdateHandler;

+ (instancetype)actionWithLimit:(CGFloat)limit handler:(YYViewActionBlock)handler;

@end

@interface YYViewCycle : NSObject

+ (instancetype)shared;

- (void)registerView:(UIView *)view actions:(NSArray <YYViewAction *> *)actions;

- (void)unregisterView:(UIView * _Nullable)view;

@end




NS_ASSUME_NONNULL_END
