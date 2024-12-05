#import "SystemTones.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation SystemTones {
    SystemSoundID soundID;
}
RCT_EXPORT_MODULE()


- (NSArray<NSObject *> *)list:(NSString *)soundType {
    NSURL *directoryURL;
    if ([soundType isEqualToString:@"ringtone"]) {
        directoryURL = [NSURL URLWithString:@"/Library/Ringtones"];
    } else {
        directoryURL = [NSURL URLWithString:@"/System/Library/Audio/UISounds"];
    }
    
    NSMutableArray *audioFileList = [[NSMutableArray alloc] init];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
    
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
            NSString *fileName = [NSString stringWithFormat:@"%@", url.lastPathComponent];
            NSArray *title = [fileName componentsSeparatedByString:@"."];
            
            NSCharacterSet *notAllowedChars = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
            NSString *soundTitle = [[title[0] componentsSeparatedByCharactersInSet:notAllowedChars]
                                  componentsJoinedByString:@" "];
            
            CFURLRef cfUrl = (__bridge CFURLRef)url;
            SystemSoundID tempSoundID;
            AudioServicesCreateSystemSoundID(cfUrl, &tempSoundID);
            
            NSString *urlString = url.absoluteString;
            NSMutableDictionary *audioSound = [NSMutableDictionary dictionary];
            [audioSound setObject:soundTitle forKey:@"title"];
            [audioSound setObject:urlString forKey:@"url"];
            [audioSound setObject:[NSNumber numberWithInt:((int)tempSoundID)] forKey:@"soundID"];
            [audioFileList addObject:audioSound];
        }
    }
    
    return audioFileList;
}

- (void)play:(NSString *)soundUrl {
    NSURL *url = [NSURL URLWithString:soundUrl];
    AudioServicesDisposeSystemSoundID(self->soundID);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &self->soundID);
    AudioServicesPlaySystemSound(self->soundID);
    AudioServicesPlaySystemSoundWithCompletion(self->soundID, ^{
        AudioServicesRemoveSystemSoundCompletion(self->soundID);
        AudioServicesDisposeSystemSoundID(self->soundID);
    });
}

- (void)stop {
    AudioServicesRemoveSystemSoundCompletion(self->soundID);
    AudioServicesDisposeSystemSoundID(self->soundID);
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeSystemTonesSpecJSI>(params);
}

@end
