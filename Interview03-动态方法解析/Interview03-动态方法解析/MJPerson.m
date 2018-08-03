//
//  MJPerson.m
//  Interview03-动态方法解析
//
//  Created by MJ Lee on 2018/5/22.
//  Copyright © 2018年 MJ Lee. All rights reserved.
//

#import "MJPerson.h"
#import <objc/runtime.h>

@implementation MJPerson

/*
 动态方法解析：当在自己的缓存和所有父类的缓存中都没有找到调用的方法，自己的rw_t和父类的rw_t都没有找到方法，则就会进行动态方法解析，
 */

void c_other(id self, SEL _cmd)
{
    NSLog(@"c_other - %@ - %@", self, NSStringFromSelector(_cmd));
}

- (void)other
{
    NSLog(@"%s", __func__);
}


#pragma mark - resolveInstanceMethod 动态添加方法实现

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(test)) {
        // 获取其他方法
        Method method = class_getInstanceMethod(self, @selector(other));

        // 动态添加test方法的实现
        //method_getImplementation 得到imp
        //method_getTypeEncoding  得到type
        class_addMethod(self, sel,
                        method_getImplementation(method),
                        method_getTypeEncoding(method));

        // 返回YES代表有动态添加方法
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

#pragma mark - 类方法 动态添加方法
+ (BOOL)resolveClassMethod:(SEL)sel
{
    if (sel == @selector(test)) {
        // 第一个参数是object_getClass(self) 类对象传进去 返回的就是元类
        class_addMethod(object_getClass(self), sel, (IMP)c_other, "v16@0:8");
        return YES;
    }
    return [super resolveClassMethod:sel];
}



/*
 如果没有实现test方法，则就会走到resolveInstanceMethod方法
 那么runtime允许我们可以动态添加方法，
 动态方法解析就是先判断是否解析，如果没有，则会调用resolveInstanceMethod
 如果没有实现resolveInstanceMethod，但是还会YES， 则goto rety
 再次进行进入if (resolver  &&  !triedResolver)， 条件不满足，则会进行消息转发
 
 */
+ (BOOL)resolveInstanceMethod1:(SEL)sel
{
    if (sel == @selector(test)) {
        //如果是test方法 动态添加test方法的实现
        //第一个参数是类对象
        //IMP 就是函数地址
        //第四个参数 types， 是字符串编码， v表示没有返回值c_other函数有两个参数，两个指针，一共16个字节，第一个参数id类型是从0开始，第二个参数_cmd 是从8这个字节开始的
    
        class_addMethod(self, sel, (IMP)c_other, "v16@0:8");
        
        //获取其他方法
        
        // 返回YES代表有动态添加方法
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}



@end
