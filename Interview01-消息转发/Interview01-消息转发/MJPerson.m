
#import "MJPerson.h"
#import <objc/runtime.h>
#import "MJCat.h"

@implementation MJPerson

/*
 消息转发:将消息转发给别人
 自己没有能力处理，就会进行消息转发
 
 */


- (id)forwardingTargetForSelector1:(SEL)aSelector
{
    if (aSelector == @selector(test)) {
        //这样会调用MJCat 的test方法
        return [[MJCat alloc] init];
    }
    
    return [super forwardingTargetForSelector:aSelector];
    
}


- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if (aSelector == @selector(test)) {
        //这样会调用MJCat 的test方法， 如果没有实现test，则会调用methodSignatureForSelector
        //返回为nil，则会调用methodSignatureForSelector ， 并在该方法中返回一个方法签名，如果方法签名为空，则是不想处理该方法，会调用doesNotRecongnizeSector
        return nil;
    }
    
    return [super forwardingTargetForSelector:aSelector];
    
}

// 方法签名， 返回值类型， 参数类型
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if (aSelector == @selector(test))
    {
        //8字节 两个8字节 16
        return [NSMethodSignature signatureWithObjCTypes:"v16@0:8"];
    }
    
    return [super methodSignatureForSelector:aSelector];
}

// NSInvocation封装了一个方法调用，包括：方法调用者、方法名、方法参数
//    anInvocation.target 方法调用者
//    anInvocation.selector 方法名
//    [anInvocation getArgument:NULL atIndex:0]
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
//    anInvocation.target = [[MJCat alloc] init];
//    [anInvocation invoke];

    [anInvocation invokeWithTarget:[[MJCat alloc] init]];
}

/*
 返回为nil，则会调用methodSignatureForSelector ， 并在该方法中返回一个方法签名，如果方法签名为空，则是不想处理该方法，会调用doesNotRecongnizeSector
 
 */


+(BOOL)resolveClassMethod:(SEL)sel
{
    
    if (sel == @selector(test)) {
    }
    
    return [super resolveClassMethod:sel];
}





//- (id)forwardingTargetForSelector:(SEL)aSelector
//{
//    if (aSelector == @selector(test)) {
//        // objc_msgSend([[MJCat alloc] init], aSelector)
//        return [[MJCat alloc] init];
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}

// 方法签名：返回值类型、参数类型
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
//{
//    if (aSelector == @selector(test)) {
//        return [NSMethodSignature signatureWithObjCTypes:"v16@0:8"];
//    }
//    return [super methodSignatureForSelector:aSelector];
//}



@end
