//
//  ANAppDelegate.m
//  SoundMaker
//
//  Created by Alex Nichol on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANAppDelegate.h"

@interface ANAppDelegate (Private)

- (void)soundThread;

@end

@implementation ANAppDelegate

@synthesize window = _window;

- (void)awakeFromNib {
    [slider setNumberOfTickMarks:0];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    soundThread = [[NSThread alloc] initWithTarget:self
                                          selector:@selector(soundThread)
                                            object:nil];
    [soundThread start];
}

- (IBAction)frequencySliderChanged:(id)sender {
    NSInteger frequency = [sender integerValue];
    [self setFrequency:[NSNumber numberWithInteger:frequency]];
}

- (void)soundThread {
    @autoreleasepool {
        sampleOutput = [[ANSampleOutput alloc] initWithSampleRate:11025 bufferTime:0.1];
        [sampleOutput startPlayer];
        [[NSRunLoop currentRunLoop] run];
    }
}

- (void)setFrequency:(NSNumber *)aFrequency {
    if ([NSThread currentThread] != soundThread) {
        [self performSelector:@selector(setFrequency:)
                     onThread:soundThread withObject:aFrequency
                waitUntilDone:NO];
        return;
    }
    [sampleOutput setFrequency:[aFrequency integerValue]];
}

@end
