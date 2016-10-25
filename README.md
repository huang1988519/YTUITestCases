# YTUITestCases
UI Dynamic Test For iOS.

YTUITestCases can perform all methods that included in `-(NSArray *)testCases`.
`-(NAArray *)autoTestCases.` can performed after `viewDidLoad`.

* Part of the unit test.
* Simulate different scenarios.

---
#### Demo:

<p align="center">
<img src="https://github.com/huang1988519/YTUITestCases/blob/master/images/UITest.gif" alt="pipaboy" title="YTUITestCases" width="400"/>

</p>


#### Install
##### manual

Copy `TBRTestDataSouce` and `UIViewController+TestCase` two classes to your project.

##### Cocoapods (Suggestion)

* Insert `pod 'YTUITestCases', :git=>"git@github.com:huang1988519/YTUITestCases.git"` to your Podfile
* open ternimal

  `cd ~/yourProjectlocation`  
  `pod update YTUITestCases --no-repo-update`

  wait complete.

#### Usage

* Select one of UIViewController or subClass that need to be tested.

* `#import <UIViewController+TestCase.h>`
* ```@interface YourSubClassOfUIViewController ()<UIViewControllerTestCaseProtocol>```
* Implement this protocol. Such as:
  ```
  -(NSArray<NSInvocation *> *)testCases {
    return @[
             [self invocationForSelector:@selector(showError) args:nil],
             [self invocationForSelector:@selector(refreshBtnClick:) args:nil],
             [self invocationForSelector:@selector(showEmptyError) args:nil],
             [self invocationForSelector:@selector(hideEmptyView) args:nil],
             [self invocationForSelector:@selector(loadMore) args:nil]
             ];
}
  ```

* Then run app.

> When you implement this protocol and methods, screen will display a tableview displaying some method names. Otherwise this tableview cannot be  showed.
