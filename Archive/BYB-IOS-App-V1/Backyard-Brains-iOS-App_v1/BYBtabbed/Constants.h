#define kNumPointsInWave 131072 // Must be power of two for efficient ring buffer.
#define kNumPointsInVertexBuffer 65536
#define kNumPointsInTriggerBuffer kNumPointsInVertexBuffer
#define kNumPointsInFirstBuffer 1024
#define kMaxWidthToShowWhenTriggeringInMilliseconds 200

#define kAudioCallbackContinuous 1
#define kAudioCallbackSingleShotTrigger 2
#define kAudioCallbackAverageTrigger 3

#define kNumSegmentsInTriggerAverage 100

#define kRecordingTimerIntervalInSeconds 0.1
#define kPlaybackTimerIntervalInSeconds 0.1

#define kVoltScaleFactor 24.5 // 2^15 * 1.5


typedef struct _ringBuffer {
	UInt32 lastWrittenIndex;
	UInt32 lastReadIndex;
	UInt32 sizeOfBuffer;
	float data[kNumPointsInWave];
} ringBuffer;
