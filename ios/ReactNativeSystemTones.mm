#import "ReactNativeSystemTones.h"

#ifdef RCT_NEW_ARCH_ENABLED
#import "RNReactNativeSystemTonesSpec.h"
#endif

#import <AudioToolbox/AudioToolbox.h>

@implementation ReactNativeSystemTones
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(list: (NSString *)soundType
                resolve: (RCTPromiseResolveBlock)resolve
                reject: (__unused RCTPromiseRejectBlock)reject) {
  NSURL *directoryURL;
  if ([soundType isEqualToString:@"ringtone"]) {
    directoryURL = [NSURL URLWithString:@"/Library/Ringtones"];
  } else {
    directoryURL = [NSURL URLWithString:@"/System/Library/Audio/UISounds"];
  }

  NSMutableArray *audioFileList = [[NSMutableArray alloc] init];
  NSFileManager *fileManager = [[NSFileManager alloc] init];
  NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];

  NSDirectoryEnumerator *enumerator =
      [fileManager enumeratorAtURL:directoryURL
          includingPropertiesForKeys:keys
                             options:0
                        errorHandler:^(NSURL *url, NSError *error) {
                          // Handle the error.
                          // Return YES if the enumeration should continue after
                          // the error.
                          return YES;
                        }];

  for (NSURL *url in enumerator) {
    NSError *error;
    NSNumber *isDirectory = nil;

    if (![url getResourceValue:&isDirectory
                        forKey:NSURLIsDirectoryKey
                         error:&error]) {
      continue;
    }

    if (![isDirectory boolValue]) {
      NSString *fileName =
          [NSString stringWithFormat:@"%@", url.lastPathComponent];
      NSArray *title = [fileName componentsSeparatedByString:@"."];

      NSCharacterSet *notAllowedChars =
          [[NSCharacterSet alphanumericCharacterSet] invertedSet];
      NSString *soundTitle =
          [[title[0] componentsSeparatedByCharactersInSet:notAllowedChars]
              componentsJoinedByString:@" "];
      NSLog(@"Result: %@", soundTitle);
      CFURLRef cfUrl = (__bridge CFURLRef)url;
      SystemSoundID soundID;
      AudioServicesCreateSystemSoundID(cfUrl, &soundID);

      NSString *urlString = url.absoluteString;
      NSMutableDictionary *audioSound = [NSMutableDictionary dictionary];
      [audioSound setObject:soundTitle forKey:@"title"];
      [audioSound setObject:urlString forKey:@"url"];
      [audioSound setObject:[NSNumber numberWithInt:((int)soundID)]
                     forKey:@"soundID"];
      [audioFileList addObject:audioSound];
    }
  }

  resolve(audioFileList);
}

SystemSoundID soundID = 0;

RCT_EXPORT_METHOD(play: (NSString *)soundUrl) {
  NSURL *url = [NSURL URLWithString:soundUrl];
  AudioServicesDisposeSystemSoundID(soundID);
  AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
  AudioServicesPlaySystemSound(soundID);
  AudioServicesPlaySystemSoundWithCompletion(soundID, ^{
    AudioServicesRemoveSystemSoundCompletion(soundID);
    AudioServicesDisposeSystemSoundID(soundID);
  });
}

RCT_EXPORT_METHOD(stop) {
  AudioServicesRemoveSystemSoundCompletion(soundID);
  AudioServicesDisposeSystemSoundID(soundID);
}

// Don't compile this code when we build for the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params {
  return std::make_shared<facebook::react::NativeReactNativeSystemTonesSpecJSI>(
      params);
}
#endif

@end
