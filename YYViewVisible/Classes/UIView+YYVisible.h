//
//  UIView+YYVisible.h
//
//  Created by last on 2021/10/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (YYVisible)

/// 视图可见率，小于等于0表示不可见，大于0表示曝光
@property (nonatomic, assign, readonly) CGFloat visibleRate;

@end

NS_ASSUME_NONNULL_END
