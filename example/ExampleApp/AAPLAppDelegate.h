/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Header for our iOS & tvOS application delegate
*/

#import <TargetConditionals.h>

#if TARGET_OS_IOS || TARGET_OS_TV
#import <UIKit/UIKit.h>

@interface AAPLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
#endif
