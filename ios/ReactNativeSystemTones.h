
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNReactNativeSystemTonesSpec.h"

@interface ReactNativeSystemTones : NSObject <NativeReactNativeSystemTonesSpec>
#else
#import <React/RCTBridgeModule.h>

@interface ReactNativeSystemTones : NSObject <RCTBridgeModule>
#endif

@end
