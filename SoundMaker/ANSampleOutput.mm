//
//  ANSampleOutput.mm
//  SoundMaker
//
//  Created by Alex Nichol on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANSampleOutput.h"

@interface ANSampleOutput (Private)

- (void)queueToBuffer:(AudioQueueBufferRef)buffer;
- (void)configureChannelLayout;

@end

void ANSampleOutputBufferCallback (void * inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inCompleteAQBuffer);

@implementation ANSampleOutput

- (BOOL)startPlayer {
    audioFormat.mFormatID = kAudioFormatLinearPCM;
    audioFormat.mChannelsPerFrame = 1;
    audioFormat.mBitsPerChannel = 8 * sizeof(AudioSampleType);
    audioFormat.mFramesPerPacket = 1;
    audioFormat.mSampleRate = 11025;
    audioFormat.mBytesPerFrame = sizeof(AudioSampleType);
    audioFormat.mBytesPerPacket = sizeof(AudioSampleType);
    audioFormat.mFormatFlags = kAudioFormatFlagIsNonInterleaved |
                                kAudioFormatFlagIsPacked |
                                kAudioFormatFlagIsSignedInteger;
    
    OSStatus status = AudioQueueNewOutput(&audioFormat,
                                          ANSampleOutputBufferCallback,
                                          (__bridge void *)self, CFRunLoopGetCurrent(),
                                          kCFRunLoopDefaultMode, 0, &audioQueue);
    if (status != noErr) {
        return NO;
    }
    
    status = AudioQueueAllocateBuffer(audioQueue, 2 * 11025, &buffers[0]);
    if (status != noErr) {
        return NO;
    }
        
    ANSampleOutputBufferCallback((__bridge void *)self, audioQueue, buffers[0]); // error
    AudioQueueStart(audioQueue, NULL);
    AudioQueueSetParameter(audioQueue, kAudioQueueParam_Volume, 1.0);
    
    return YES;
}

- (void)stopPlayer {
    
}

- (void)queueToBuffer:(AudioQueueBufferRef)buffer {
    SInt16 * samples = (SInt16 *)buffer->mAudioData;
    for (NSUInteger i = 0; i < 11025; i++) {
        samples[i] = 0; // sample data here, please.
    }
    
    buffer->mAudioDataByteSize = audioFormat.mSampleRate * audioFormat.mBytesPerFrame;

    AudioQueueEnqueueBuffer(audioQueue, buffer, 0, NULL);
}

@end

void ANSampleOutputBufferCallback (void * inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inCompleteAQBuffer) {
    [(__bridge ANSampleOutput *)inUserData queueToBuffer:inCompleteAQBuffer];
}

