// SystemTones.mm
#import "SystemTones.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation SystemTones {
    SystemSoundID soundId;
}

RCT_EXPORT_MODULE()

- (void)list:(NSString *)soundType resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    @try {
        NSURL *directoryURL;
        if ([soundType isEqualToString:@"ringtone"]) {
            directoryURL = [NSURL URLWithString:@"/Library/Ringtones"];
        } else {
            directoryURL = [NSURL URLWithString:@"/System/Library/Audio/UISounds"];
        }
        
        if (!directoryURL) {
            reject(@"directory_error", @"Invalid directory URL", nil);
            return ;
        }
        
        NSMutableArray *audioFileList = [[NSMutableArray alloc] init];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *keys = @[NSURLIsDirectoryKey];
        
        NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtURL:directoryURL
                                            includingPropertiesForKeys:keys
                                            options:0
                                            errorHandler:^(NSURL *url, NSError *error) {
            return YES;
        }];
        
        for (NSURL *url in enumerator) {
            NSError *error;
            NSNumber *isDirectory = nil;
            
            if (![url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
                continue;
            }
            
            if (![isDirectory boolValue]) {
                NSString *fileName = url.lastPathComponent;
                NSArray *title = [fileName componentsSeparatedByString:@"."];
                
                NSCharacterSet *notAllowedChars = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
                NSString *soundTitle = [[title[0] componentsSeparatedByCharactersInSet:notAllowedChars]
                                      componentsJoinedByString:@" "];
                
                SystemSoundID tempSoundID;
                OSStatus status = AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &tempSoundID);
                
                if (status == noErr) {
                    NSDictionary *audioSound = @{
                        @"title": soundTitle,
                        @"url": url.absoluteString,
                        @"soundId": @(tempSoundID)
                    };
                    [audioFileList addObject:audioSound];
                }
            }
        }
        
        resolve(audioFileList);
    } @catch (NSException *exception) {
        reject(@"list_error", exception.reason, nil);
    }
}

- (void)play:(JS::NativeSystemTones::Sound &)sound {
    @try {
        NSString *soundUrl = sound.url();
        if (!soundUrl) {
            return;
        }
        
        NSURL *url = [NSURL URLWithString:soundUrl];
        if (!url) {
            return;
        }
        
        AudioServicesDisposeSystemSoundID(self->soundId);
        OSStatus status = AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &self->soundId);
        
        if (status == noErr) {
            AudioServicesPlaySystemSound(self->soundId);
            AudioServicesPlaySystemSoundWithCompletion(self->soundId, ^{
                AudioServicesRemoveSystemSoundCompletion(self->soundId);
                AudioServicesDisposeSystemSoundID(self->soundId);
            });
        }
    } @catch (NSException *exception) {
        // Handle exception silently
    }
}

- (void)stop {
    @try {
        AudioServicesRemoveSystemSoundCompletion(self->soundId);
        AudioServicesDisposeSystemSoundID(self->soundId);
        self->soundId = 0;
    } @catch (NSException *exception) {
        // Handle exception silently
    }
}


- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeSystemTonesSpecJSI>(params);
}

@end
