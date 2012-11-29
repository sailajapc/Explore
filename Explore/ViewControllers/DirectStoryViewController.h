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
    NSMutableArray *imageArray;
    NSMutableArray *labelNamesarray;
    UILabel *timeDisplayLabel;
    UILabel *scorelabel;
    UIImageView *namesBackGround;
    NSArray * dataArray;
    NSMutableArray *randomSelection;
    
    UILabel *namesLabel;    
    int time;
    int score;
    int playCount;
    int helpCount;
    NSTimer *timer;
    CustomBadge *helpBadge;
}

@end
