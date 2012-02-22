//
//  ANAppDelegate.h
//  SoundMaker
//
//  Created by Alex Nichol on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ANSampleOutput.h"

@interface ANAppDelegate : NSObject <NSApplicationDelegate> {
    ANSampleOutput * sampleOutput;
    NSThread * soundThread;
    IBOutlet NSSlider * slider;
}

@property (assign) IBOutlet NSWindow * window;

- (IBAction)frequencySliderChanged:(id)sender;

- (void)setFrequency:(NSNumber *)aFrequency;

@end
