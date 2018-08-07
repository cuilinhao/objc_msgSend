//
//  NSMutableArray+Extension.m
//  Interview01-方法交换
//
//  Created by MJ Lee on 2018/5/31.
//  Copyright © 2018年 MJ Lee. All rights reserved.
//

#import "NSMutableArray+Extension.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Extension)

+ (void)load
{
    /*
     method_exchangeImplementations 方法
     
     NSMutableArray *aa = [NSMutableArray array];
     NSLog(@"----%@", [aa class]);// ----__NSArrayM
     真实类型是__NSArrayM，故交换的时候也要用__NSArrayM
     */
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 类簇：NSString、NSArray、NSDictionary，真实类型是其他类型
        Class cls = NSClassFromString(@"__NSArrayM");
        Method method1 = class_getInstanceMethod(cls, @selector(insertObject:atIndex:));
        Method method2 = class_getInstanceMethod(cls, @selector(mj_insertObject:atIndex:));
        method_exchangeImplementations(method1, method2);
    });
    
}

- (void)mj_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject == nil) return;
    
    [self mj_insertObject:anObject atIndex:index];
}

@end
