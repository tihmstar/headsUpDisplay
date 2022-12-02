// See http://iphonedevwiki.net/index.php/Logos

#include <objc/runtime.h>
#import <libactivator/libactivator.h>
#include <CoreFoundation/CoreFoundation.h>
#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#include <map>

static std::map<void*,int> views;

@interface HudActivator : NSObject<LAListener>
@end

@implementation HudActivator

+(void)load {
    @autoreleasepool {
        [[LAActivator sharedInstance] registerListener:[self new] forName:@"net.tihmstar.headsUpDisplay"];
    }
}
-(void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
    UIView * view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    int state = 0;
    try{
        state = views.at((__bridge void*)view);
    }catch(...){
        //
    }
    state = (state + 1) % 2;
    
    switch (state) {
        case 0:
            view.transform = CGAffineTransformMakeScale(1, 1);
            break;
        case 1:
            view.transform = CGAffineTransformMakeScale(-1, 1);
            break;
        case 2:
            view.transform = CGAffineTransformMakeScale(1, -1);
            break;
            
        default:
            state = -1;
            break;
    }

    views[(__bridge void*)view] = state;
}


- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName {
    return @"HUD mode";
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName {
    return @"Toggles a mirrored display";
}
- (NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)listenerName {
    return [NSArray arrayWithObjects:@"application", nil];
}

@end
%ctor{
    NSLog(@"HUD HeadsUpDisplay loaded!!");
}
