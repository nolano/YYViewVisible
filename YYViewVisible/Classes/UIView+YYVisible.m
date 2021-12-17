//
//  UIView+YYVisible.m
//
//  Created by last on 2021/10/14.
//

#import "UIView+YYVisible.h"

@implementation UIView (YYVisible)

- (CGFloat)visibleRate {
    
    /// 1.0 前后台
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        return 0;
    }
    
    /// 2.0 当前view
    if (self.isHidden || self.superview == nil || self.window == nil || self.alpha <= 0.1) {
        return 0;
    }
    
    /// 检查window是否可见
    NSArray<UIWindow *> *windows = UIApplication.sharedApplication.windows;
    BOOL windowVisible = [self isShowWithCurrentWindow:self.window windows:windows];
    if (windowVisible == NO) {
        return 0.0;
    }
    
    NSMutableArray *views = [NSMutableArray array];
    UIView *superView = self.superview;
    while (superView) {
        if (superView.isHidden || superView.alpha <= 0.1) {
            return 0;
        }
        if (![superView isKindOfClass:NSClassFromString(@"UITableViewWrapperView")]) {
            [views addObject:superView];
        }
        superView = superView.superview;
    }
    
    /// 默认可见
    __block CGRect intersectionRect = self.window.bounds;
    __block BOOL isvisible = YES;
    [views enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *parentView = self;
        if (idx != 0) {
            parentView = views[idx - 1];
        }
        if (![self isShowWithParentView:parentView subviews:obj.subviews]) {
            isvisible = NO;
            *stop = YES;
        }else {
            CGRect rect = [obj convertRect:obj.bounds toView:self.window];
            intersectionRect = CGRectIntersection(intersectionRect,rect);
        }
    }];
    
    if (isvisible) {
        CGRect viewRect = [self convertRect:self.bounds toView:self.window];
        if (!CGRectIntersectsRect(intersectionRect,viewRect)) {
            return 0;
        }
        CGRect interRect = CGRectIntersection(intersectionRect,viewRect);
        
        CGFloat rate = (interRect.size.width * interRect.size.height) / (viewRect.size.width * viewRect.size.height);
        return rate;
    }

    return 0;
}

/// 检查view层级的parentview与parent同层级的view是否可见
- (BOOL)isShowWithParentView:(UIView *)parentView subviews:(NSArray *)subviews{
    __block BOOL isvisible = YES;
    [subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == parentView) {
            *stop = YES;
        }else if (obj.isHidden == NO && obj.alpha > 0.1 && CGRectContainsRect(obj.superview.bounds, obj.frame)) {
            CGFloat colorAlpha = 0;
            [obj.backgroundColor getRed:nil green:nil blue:nil alpha:&colorAlpha];
            if (colorAlpha > 0.1) {
                CGRect intersectionRect1 = CGRectIntersection(obj.frame,parentView.frame);
                CGRect rect = [self convertRect:self.bounds toView:parentView.superview];
                if (CGRectContainsRect(obj.frame, parentView.frame) || CGRectContainsRect(intersectionRect1, rect)) {
                    isvisible = NO;
                    *stop = YES;
                }
            }
        }
    }];
    return isvisible;
}

/// 检查同window层级是否可见
- (BOOL)isShowWithCurrentWindow:(UIWindow *)window windows:(NSArray<UIWindow *> *)windows{
    __block BOOL isvisible = YES;
    [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == window) {
            *stop = YES;
        }else if (obj.isHidden == NO && obj.alpha > 0.1) {
            CGFloat colorAlpha = 0;
            [obj.backgroundColor getRed:nil green:nil blue:nil alpha:&colorAlpha];
            if (colorAlpha > 0.1 && CGRectContainsRect(obj.frame, window.frame)) {
                isvisible = NO;
                *stop = YES;
            }
        }
    }];
    return isvisible;
}

@end
