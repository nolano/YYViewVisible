//
//  YYViewCycle.m
//
//  Created by last on 2021/10/14.
//

#import "YYViewCycle.h"
#import "UIView+YYVisible.h"

@interface YYViewContainer : NSObject

@property (nonatomic, weak) UIView *view;

@property (nonatomic, strong) NSArray<YYViewAction *> *actions;

@end

@implementation YYViewContainer

@end


@interface YYViewAction ()

@property (nonatomic, copy) YYViewActionBlock handler;

@property (nonatomic, assign) CGFloat limit;//限制条件

@property (nonatomic, assign) BOOL isAnswer;
@end

@implementation YYViewAction

+ (instancetype)actionWithLimit:(CGFloat)limit handler:(YYViewActionBlock)handler{
    YYViewAction *action = [[YYViewAction alloc] init];
    action.callBackTime = 1;
    action.limit = limit;
    action.isAnswer = NO;
    if (handler) {
        action.handler = handler;
    }
    return action;
}

- (void)setIsAnswer:(BOOL)isAnswer {
    if (_callBackTime == 0) {
        if (_isAnswer != isAnswer) {
            _isAnswer = isAnswer;
            if (self.stateUpdateHandler) {
                self.stateUpdateHandler(self);
            }
        }
        if (self.handler) {
            self.handler(self);
        }
    }else {
        if (_isAnswer != isAnswer) {
            _isAnswer = isAnswer;
            if (self.handler) {
                self.handler(self);
            }
        }
    }
}


@end


@interface YYViewCycle ()

@property (nonatomic, strong) NSThread *thread;

@property (nonatomic, strong) NSMutableArray <YYViewContainer *> *viewContainer;

@property (nonatomic, strong) NSLock * lock;

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) NSRunLoop *currentRunLoop;

@end

@implementation YYViewCycle

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    static YYViewCycle * manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[YYViewCycle alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.viewContainer = [NSMutableArray array];

        self.lock = [[NSLock alloc] init];
        
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(loop)];
        /// 每秒10次
        self.displayLink.preferredFramesPerSecond = 10;
        [self.displayLink setPaused:YES];
        
        self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(livingThread) object:nil];
        
        [self.thread start];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
                
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)registerView:(UIView *)view actions:(NSArray <YYViewAction *> *)actions {
    if (nil == view) {
        return;
    }
    [self.lock lock];
    
    __block BOOL isExist = NO;
    [self.viewContainer enumerateObjectsUsingBlock:^(YYViewContainer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.view == view) {
            isExist = YES;
            *stop = YES;
        }
    }];
    if (NO == isExist) {
        YYViewContainer *container = [[YYViewContainer alloc] init];
        container.view = view;
        container.actions = actions;
        [self.viewContainer addObject:container];
    }
    [self.lock unlock];
    [self performSelector:@selector(loop) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (void)unregisterView:( UIView * _Nullable )view {
    NSMutableArray *unregisters = [NSMutableArray array];
    [self.viewContainer enumerateObjectsUsingBlock:^(YYViewContainer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (nil == obj.view || obj.view == view) {
            [unregisters addObject:obj];
        }
    }];
    if (unregisters.count > 0) {
        [self.viewContainer removeObjectsInArray:unregisters];
    }
    if (self.viewContainer.count == 0 && self.displayLink.isPaused == NO) {
        [self.displayLink setPaused:YES];
    }
}


#pragma mark -- app notification

- (void)applicationWillEnterForegroundNotification {
    
    if(self.viewContainer.count > 0 && self.displayLink.isPaused) {
        [self.displayLink setPaused:NO];
        
    }
}

- (void)applicationDidEnterBackgroundNotification {
    if (!self.displayLink.isPaused) {
        [self.displayLink setPaused:YES];
    }
}

#pragma mark -- private

- (void)loop {
    [self.lock lock];
    if (self.displayLink.paused) {
        [self.displayLink setPaused:NO];
    }
    [self.lock unlock];
    [self check];
}

- (void)check {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.lock lock];
        [self.viewContainer enumerateObjectsUsingBlock:^(YYViewContainer * obj, NSUInteger idx, BOOL *stop) {
            CGFloat exposureRate = [obj.view visibleRate];
            [obj.actions enumerateObjectsUsingBlock:^(YYViewAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
                if (exposureRate > action.limit) {
                    action.isAnswer = YES;
                }else {
                    action.isAnswer = NO;
                }
            }];
        }];
        [self.lock unlock];
        
        [self unregisterView:nil];
    });
}

- (void)livingThread {
    @autoreleasepool {
        [[NSThread currentThread] setName:@"YYLivingThead"];
        NSRunLoop  *runloop = [NSRunLoop currentRunLoop];
        [runloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        
        [self.displayLink addToRunLoop:runloop forMode:NSRunLoopCommonModes];
        [self.displayLink setPaused:YES];
        [runloop run];
    }
}


@end


