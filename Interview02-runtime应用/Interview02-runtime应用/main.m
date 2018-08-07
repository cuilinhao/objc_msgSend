//
//  main.m
//  Interview02-runtime应用
//
//  Created by MJ Lee on 2018/5/29.
//  Copyright © 2018年 MJ Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJPerson.h"
#import "MJStudent.h"
#import "MJCar.h"
#import <objc/runtime.h>
#import "NSObject+Json.h"


void run(id self, SEL _cmd)
{
    NSLog(@"%@----%@", self, NSStringFromSelector(_cmd));
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        MJPerson *person1 = [[MJPerson alloc] init];
        person1.name = @"123123";
        
        [person1 run];
        
        // 字典转模型
        NSDictionary *json = @{
                               @"id" : @20,
                               @"age" : @20,
                               @"weight" : @60,
                               @"name" : @"Jack"
                               // @"no" : @30
                               };
        
        /*
         最原始的写法
         MJPerson *person1 = [[MJPerson alloc] init];
         person1.age = [json[@"age"] intValue];
         person1.weight = [json[@"weight"] intValue];
         person1.name = json[@"name"];
         
         */
        
        
        
        
        MJPerson *person = [MJPerson mj_objectWithJson:json];
        
        
        
        NSLog(@"123");
    }
    return 0;
}

#pragma mark -  获取类
void mobtestGetClass()
{
    MJPerson *person1 = [[MJPerson alloc] init];
    [person1 run];
    
    //获取类
    id ss = object_getClass([MJPerson class]);
    NSLog(@"---ss---%@", ss);
    //修改isa指向 调用方法时，person1会调用MJCar 类中相同的方法
    object_setClass(person1, [MJCar class]);
    [person1 run];
    
}

#pragma mark - 字典转模型
void testDictionaryToModel()
{
    // 字典转模型
    NSDictionary *json = @{
                           @"id" : @20,
                           @"age" : @20,
                           @"weight" : @60,
                           @"name" : @"Jack"
                           // @"no" : @30
                           };
    
    /*
     最原始的写法
     MJPerson *person1 = [[MJPerson alloc] init];
     person1.age = [json[@"age"] intValue];
     person1.weight = [json[@"weight"] intValue];
     person1.name = json[@"name"];
     
     */
    
    MJPerson *person = [MJPerson mj_objectWithJson:json];
    
    //[MJCar mj_objectWithJson:json];
    //MJStudent *student = [MJStudent mj_objectWithJson:json];
    
    NSLog(@"123");
    
}



#pragma mark - 获取成员变量信息
void testIvars()
{
    // 获取成员变量信息
    Ivar ageIvar = class_getInstanceVariable([MJPerson class], "_age");
    NSLog(@"%s %s", ivar_getName(ageIvar), ivar_getTypeEncoding(ageIvar));

    //设置和获取成员变量的值
    Ivar nameIvar = class_getInstanceVariable([MJPerson class], "_name");

    MJPerson *person = [[MJPerson alloc] init];
    object_setIvar(person, nameIvar, @"123");
    object_setIvar(person, ageIvar, (__bridge id)(void *)10);
    NSLog(@"%@ %d", person.name, person.age);

    // 成员变量的数量
    unsigned int count;
    //返回的是一个数组
    Ivar *ivars = class_copyIvarList([MJPerson class], &count);
    for (int i = 0; i < count; i++) {
        // 取出i位置的成员变量
        Ivar ivar = ivars[i];
        NSLog(@"%s %s", ivar_getName(ivar), ivar_getTypeEncoding(ivar));
    }
    free(ivars);
}




#pragma mark - ---------动态创建类
void testClass()
{
    // 创建类
    Class newClass = objc_allocateClassPair([NSObject class], "MJDog", 0);
    class_addIvar(newClass, "_age", 4, 1, @encode(int));
    class_addIvar(newClass, "_weight", 4, 1, @encode(int));
    class_addMethod(newClass, @selector(run), (IMP)run, "v@:");
    // 注册类,一定要把类的成员变量放在注册类的前面，因为成员变量是只读的，方法可读可写的，无所谓
    objc_registerClassPair(newClass);
    
    //-----
    MJPerson *person = [[MJPerson alloc] init];
    object_setClass(person, newClass);
    [person run];//会打印出dog类型，因为isa执行newclass
    

    id dog = [[newClass alloc] init];
    [dog setValue:@10 forKey:@"_age"];
    [dog setValue:@20 forKey:@"_weight"];
    [dog run];

    NSLog(@"%@ %@", [dog valueForKey:@"_age"], [dog valueForKey:@"_weight"]);
    
    // 在不需要这个类时释放
    objc_disposeClassPair(newClass);
}


void test()
{
    MJPerson *person = [[MJPerson alloc] init];
    [person run];
    
    object_setClass(person, [MJCar class]);
    [person run];
    
    NSLog(@"%d %d %d",
          object_isClass(person),
          object_isClass([MJPerson class]),
          object_isClass(object_getClass([MJPerson class]))
          );
    
    //        NSLog(@"%p %p", object_getClass([MJPerson class]), [MJPerson class]);
}
