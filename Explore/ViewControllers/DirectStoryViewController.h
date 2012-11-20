//
//  DirectStoryViewController.h
//  Hide&Seek
//
//  Created by Sailaja Kamisetty on 23/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomBadge;
@interface DirectStoryViewController : UIViewController<UIAlertViewDelegate>
{
    UIView *overLayView;
    NSArray *array;
    NSArray *labelNamesarray;
    UILabel *timeDisplayLabel;
    UILabel *scorelabel;
    UIImageView *namesBackGround;
    
    UILabel *namesLabel;
    UILabel *labelText;
    
    int time;
    int score;
    int playCount;
    NSTimer *timer;
    CustomBadge *helpBadge;
}

@end
