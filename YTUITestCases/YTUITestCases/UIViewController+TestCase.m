//
//  UIViewController+TestCase.m
//  taobaoreader
//
//  Created by huanwh on 2016/10/17.
//  Copyright © 2016年 AlibabaLiterature. All rights reserved.
//

#import "UIViewController+TestCase.h"
#import <objc/runtime.h>
#import "TBRTestDataSouce.h"


static NSString * kTBRTestCaseSelectorsArrayKey = @"kTBRTestCaseSelectorsArrayKey";
static NSString * kTBRPreTestCaseSelectorsArrayKey = @"kTBRPreTestCaseSelectorsArrayKey";
static NSString * kTBRHavePerformedArrayKey = @"kTBRPreHavePerformedArrayKey";




@implementation UIViewController (TestCase)

#pragma mark -  Method Swizzling

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleOriginSEL:@selector(viewDidLoad) swizzleSEL:@selector(tbr_test_viewDidLoad)];
        [self swizzleOriginSEL:@selector(viewWillAppear:) swizzleSEL:@selector(tbr_test_viewWillAppear:)];
        [self swizzleOriginSEL:@selector(viewWillDisappear:) swizzleSEL:@selector(tbr_test_viewWillDisappear:)];
    });
}

+(void)swizzleOriginSEL:(SEL)originSEL swizzleSEL:(SEL)swizzledSEL {
    Class class = [self class];

    SEL originSelector  = originSEL;
    SEL swizzledSelector= swizzledSEL;
    
    Method originMethod     = class_getInstanceMethod(class, originSelector);
    Method swizzledMethed   = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethed = class_addMethod(class,
                                        originSelector,
                                        method_getImplementation(swizzledMethed),
                                        method_getTypeEncoding(swizzledMethed));
    
    if (didAddMethed) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originMethod),
                            method_getTypeEncoding(originMethod));
    } else {
        method_exchangeImplementations(originMethod, swizzledMethed);
    }
}

-(void)tbr_test_viewDidLoad {
    [self tbr_test_viewDidLoad];
    NSLog(@"Caution!!  淘宝阅读 ：替换 viewDidLoad: 方法");
    
    self.performedList = [NSMutableArray array];
    
    if ([self conformsToProtocol:@protocol(UIViewControllerTestCaseProtocol)]) {
        
        NSString * preCasesName = [self performMethodForKey:@"preTestCases"];
        NSString * casesName    = [self performMethodForKey:@"testCases"];
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if (preCasesName) {
            SEL preSelector   = NSSelectorFromString(preCasesName);
            id preCases = [self performSelector:preSelector withObject:nil];

            if ([preCases isKindOfClass:[NSArray class]]) {
                self.preSelectors = [NSMutableArray arrayWithArray:preCases];
            }
        }
        if (casesName) {
            SEL casesSelector = NSSelectorFromString(casesName);
            id cases    = [self performSelector:casesSelector withObject:nil];
            if ([cases isKindOfClass:[NSArray class]]) {
                self.selectors = [NSMutableArray arrayWithArray:cases];
            }
        }
        
        [self performPreSelectors];
        
    }
        
#pragma clang diagnostic pop
}

-(void)tbr_test_viewWillAppear:(BOOL)animated {
    [self tbr_test_viewWillAppear:animated];

    [self reloadTable];

    if ([self conformsToProtocol:@protocol(UIViewControllerTestCaseProtocol)]) {
        [self startObserveMotion];
    }
}

-(void)tbr_test_viewWillDisappear:(BOOL)animated {
    [self tbr_test_viewWillDisappear:animated];
    
    if ([self conformsToProtocol:@protocol(UIViewControllerTestCaseProtocol)]) {
        [self endObserveMotion];
    }
}

#pragma mark - 执行
/// 执行需要在 ViewDidload 中执行的方法
-(void)performPreSelectors {
    for (NSInvocation * invocation in self.preSelectors) {
        [invocation invoke];
        
        NSString * seletorName = NSStringFromSelector(invocation.selector);
        [self.performedList addObject:seletorName];
    }
    
    [self.preSelectors removeAllObjects];
    
    NSLog(@"\n\n->预执行执行完成\n->\n%@\n\n",self.performedList);
}

-(NSString *)performMethodForKey:(NSString *)searchname {
    
    Class class = [self class];
    while (class) {
        
        unsigned int methodCount;
        Method * methodList = class_copyMethodList(class, &methodCount);
        
        unsigned int i = 0;
        for (; i< methodCount; i++) {
            NSString * methodName = [NSString stringWithCString:sel_getName(method_getName(methodList[i])) encoding:NSUTF8StringEncoding];
            
            if ([methodName isEqualToString:searchname]) {
                return methodName;
            }else {
                // 递归查找父类测试方法
                class = class_getSuperclass(class);
            }
        }
        
        free(methodList);
    }
    
    return nil;
}


#pragma mark - 添加摇晃手势

-(void)startObserveMotion {
#if DEBUG
    NSAssert([self conformsToProtocol:@protocol(UIViewControllerTestCaseProtocol)], @"集成此类目，需实现 UIViewControllerTestCaseProtocol 协议");
    
    if (!self.selectors) {
        self.selectors = [self performSelector:@selector(testCases) withObject:nil];
    }
#endif
    [self.view becomeFirstResponder];
}

-(void)endObserveMotion {
#if DEBUG
    NSAssert([self conformsToProtocol:@protocol(UIViewControllerTestCaseProtocol)], @"集成此类目，需实现 UIViewControllerTestCaseProtocol 协议");
#endif
    
    [self.view resignFirstResponder];
}

-(NSInvocation *)invocationForSelector:(SEL)selector args:(id)first, ... {
    NSMutableArray * params = [NSMutableArray array];
    
    va_list list;
    va_start(list, first);
    
    if (first) {
        [params addObject:first];
    }
    
    id arg = nil;
    while ((arg = va_arg(list, id))) {
        [params addObject:arg];
    }

    va_end(list);
    
    
    NSMethodSignature * signature = [[self class] instanceMethodSignatureForSelector:selector];
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    invocation.target = self;
    invocation.selector = selector;
    
    int index = 2;
    for (id p in params) {
        id temp = p;
        [invocation setArgument:&temp atIndex:index];
        index++;
    }
    
    return invocation;

}

#pragma mark - Set & Get

-(void)setSelectors:(NSMutableArray *)array  {
    objc_setAssociatedObject(self, (__bridge const void *)(kTBRTestCaseSelectorsArrayKey), array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSMutableArray *)selectors {
    return objc_getAssociatedObject(self, (__bridge const void *)(kTBRTestCaseSelectorsArrayKey));
}


-(void)setPreSelectors:(NSMutableArray *)preSelectors {
    objc_setAssociatedObject(self, (__bridge const void *)(kTBRPreTestCaseSelectorsArrayKey), preSelectors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSMutableArray *)preSelectors {
    return objc_getAssociatedObject(self, (__bridge const void *)(kTBRPreTestCaseSelectorsArrayKey));
}


-(void)setPerformedList:(NSMutableArray *)performedList {
    objc_setAssociatedObject(self, (__bridge const void *)(kTBRHavePerformedArrayKey), performedList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSMutableArray *)performedList {
    return objc_getAssociatedObject(self, (__bridge const void *)(kTBRHavePerformedArrayKey));
}


#pragma mark - 摇晃执行事件

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake && self.selectors.count > 0) {
#if DEBUG
        NSInvocation * invocation = self.selectors[0];
        [invocation invoke];
        
        [self.selectors removeObjectAtIndex:0];
        
        NSString * methodName = NSStringFromSelector(invocation.selector);
        [self.performedList addObject:methodName];
        
        NSString * desc = [NSString stringWithFormat:@"\n\n测试指令: %@ -> %@\n剩余：%d\n\n",[invocation.target class], methodName ,(int)self.selectors.count];
        NSLog(@"%@",desc);
        
        [[TBRTestDataSouce shareInstance] reloadData];
        
        if (self.performedList.count > 5) {
//            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.performedList.count - 1) inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        
    }else {
        NSLog(@"测试指令执行完成");
    }
#endif
}


#pragma mark - UITableView 
-(void)reloadTable {
    
    [[TBRTestDataSouce shareInstance] setNumberOfTableView:^NSUInteger{
        return self.selectors.count;
    }];
    
    [[TBRTestDataSouce shareInstance] setNameForIndex:^NSInvocation *(NSUInteger index) {
        return self.selectors[index];
    }];
    
    [[TBRTestDataSouce shareInstance] reloadData];
}


@end







