

#import <Foundation/Foundation.h>
#import "MJPerson.h"

// 消息转发：将消息转发给别人

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        MJPerson *person = [[MJPerson alloc] init];
        [person test];
    }
    return 0;
}
