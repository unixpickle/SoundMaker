//
//  ANSampleOutput.h
//  SoundMaker
//
//  Created by Alex Nichol on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

@interface ANSampleOutput : NSObject {
    AudioStreamBasicDescription audioFormat;
	AudioQueueRef audioQueue;
	AudioQueueBufferRef buffers[1];
}

- (BOOL)startPlayer;
- (void)stopPlayer;

@end
