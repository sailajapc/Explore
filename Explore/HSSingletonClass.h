//
//  HSSingletonClass.h
//  Explore
//
//  Created by Sailaja Kamisetty on 10/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSSingletonClass : NSObject
{
    int storyLevel;
    int score;
}

+ (HSSingletonClass *)sharedSingleton;
- (NSMutableDictionary *)loadPlistData;
- (void)incrementStoryLevel;
- (int)getStoryLevel;
- (void)updateScore:(int)value;
- (int)getScore;
@end
