//
//  HSSingletonClass.m
//  Explore
//
//  Created by Sailaja Kamisetty on 10/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HSSingletonClass.h"

@implementation HSSingletonClass

static HSSingletonClass *shareSingleton;

#pragma mark - Singleton Methods

+ (HSSingletonClass *)sharedSingleton
{
    @synchronized(self)
    {
        if (!shareSingleton)
        {
            shareSingleton = [[HSSingletonClass alloc] init];
        }
        return shareSingleton;
    }
}

+ (id)allocWithZone:(NSZone *)zone
{
     @synchronized(self)
    {
        if (shareSingleton == nil) {
            shareSingleton = [super allocWithZone:zone];
        }
    }
    return shareSingleton;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (id)autorelease
{
    return self;
}

- (oneway void)release
{
    // do nothing
}

-(id)init
{
    self = [super init];
    if (self)
    {
        // Custom initialization
        storyLevel = 1;
        score = 0;
    }
    return self;
}


#pragma mark -
#pragma mark  Story helper Class methods
- (int)getStoryLevel
{
    return storyLevel;
}

- (void)incrementStoryLevel
{
    storyLevel = storyLevel +1;
}

- (void)updateScore:(int)value
{
    score = score+value;
}

- (int)getScore
{
    return score;
}
- (NSMutableDictionary *)loadPlistData
{
     NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Images" ofType:@"plist"]];
    return dict;
}

@end
