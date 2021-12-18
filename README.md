# YYViewVisible

[![CI Status](https://img.shields.io/travis/yuyuan yue/YYViewVisible.svg?style=flat)](https://travis-ci.org/yuyuan yue/YYViewVisible)
[![Version](https://img.shields.io/cocoapods/v/YYViewVisible.svg?style=flat)](https://cocoapods.org/pods/YYViewVisible)
[![License](https://img.shields.io/cocoapods/l/YYViewVisible.svg?style=flat)](https://cocoapods.org/pods/YYViewVisible)
[![Platform](https://img.shields.io/cocoapods/p/YYViewVisible.svg?style=flat)](https://cocoapods.org/pods/YYViewVisible)


## 功能
一个工具，用来监测view是否可见，以及可见的比例


## Example
```
/// limit: 曝光比例，0-1
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
```



## Requirements

## Installation

YYViewVisible is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'YYViewVisible'
```

## Author

yuyuan yue, last_yearv@163.com

## License

YYViewVisible is available under the MIT license. See the LICENSE file for more info.
