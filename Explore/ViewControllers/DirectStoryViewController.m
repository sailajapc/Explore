//
//  DirectStoryViewController.m
//  Hide&Seek
//
//  Created by Sailaja Kamisetty on 23/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DirectStoryViewController.h"
#import "CustomBadge.h"
#define KTIME @"Time : "
#define KSCORE @"Score : "
#define DEFAULTTIME 20
#define DEFAULTSCORE 0

@interface DirectStoryViewController()
- (void)resetUI;
@end
@implementation DirectStoryViewController

- (id)init 
{
    self = [super init];
    if (self) 
    {
        playCount = 0;
        helpCount = 1;
        UIImageView *backGround = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dining.jpeg"]];
        [backGround setFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y - 60, self.view.frame.size.width,self.view.frame.size.height -60)];
        backGround.tag=98765;
        [backGround setUserInteractionEnabled:YES];
        [self.view addSubview:backGround];
        [backGround release];
        //Create a transparent screen
        overLayView = [[UIView alloc]init];
        [overLayView setFrame:CGRectMake(0, 20, 320, 460)];
        [overLayView setBackgroundColor:[UIColor lightGrayColor]];
        overLayView.alpha = 0.5;
        UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        [window addSubview:overLayView];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Do you want to play" message:@"Need to add the story description related to the story image & it changes from screen to screen" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Quit",@"Play", nil];
        [alert show];
        [alert release];
        
        namesBackGround = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"namesLabel.jpg"]];
        [namesBackGround setFrame:CGRectMake(0,362,self.view.frame.size.width - 60,100)];
        [namesBackGround setUserInteractionEnabled:YES];
        [self.view addSubview:namesBackGround];
        [namesBackGround release];
        
        labelNamesarray = [[NSArray alloc]initWithObjects:@"Flower",@"Ball",@"Candle",@"Rose",@"Pencil",@"Bag",nil];
        
        int i=0,k=0;
        while(i<[labelNamesarray count])
        {
            int y = k*32;
            int j=0;
            
            //Display num of images for each row
            for(j=0; j<2;j++){
                if (i>=[labelNamesarray count]) break;
                labelText = [[[UILabel alloc] init] autorelease];
                labelText.text=[labelNamesarray objectAtIndex:i];
                NSLog(@"label text is:%@",[labelNamesarray objectAtIndex:i]);
                labelText.textColor = [UIColor blackColor];
                labelText.backgroundColor = [UIColor clearColor];
                labelText.textAlignment = UITextAlignmentLeft;
                labelText.tag = 100 + i;
                NSLog(@"tag value is :%d",labelText.tag);
                [labelText setFrame:CGRectMake((40*(j+1)+90*j), y-10, 60, 50)];
                [namesBackGround addSubview:labelText];
                i++;
            }
            k = k+1;
        }
        
        UIButton *helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [helpButton setBackgroundImage:[UIImage imageNamed:@"help.jpeg"] forState:UIControlStateNormal];
        [helpButton setFrame:CGRectMake(262,362,55,97)];
        [helpButton addTarget:self action:@selector(helpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:helpButton];
        
        helpBadge = [[CustomBadge customBadgeWithString:@"1"
                                        withStringColor:[UIColor whiteColor]
                                         withInsetColor:[UIColor redColor]
                                         withBadgeFrame:YES
                                    withBadgeFrameColor:[UIColor whiteColor]
                                              withScale:0.8
                                            withShining:YES] retain];
        [helpBadge setFrame:CGRectMake(27, 20, 20, 20)];
        [helpButton addSubview:helpBadge];
        self.title = @"Hide & Seek";
        time = DEFAULTTIME;
        score = DEFAULTSCORE;
        
        //Add time label on right side of navigation bar
        UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
        
        timeDisplayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 80, 35)];
        [timeDisplayLabel setBackgroundColor:[UIColor clearColor]];
        timeDisplayLabel.textAlignment = UITextAlignmentCenter;
        timeDisplayLabel.textColor = [UIColor whiteColor];
        timeDisplayLabel.text = [NSString stringWithFormat:@"%@%d",KTIME,DEFAULTTIME];
        [rightView addSubview:timeDisplayLabel];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
        self.navigationItem.rightBarButtonItem = rightItem;
        
        //Add score label on right side of navigation bar
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
        
        scorelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 100, 35)];
        scorelabel.textAlignment = UITextAlignmentLeft;
        [scorelabel setBackgroundColor:[UIColor clearColor]];
        scorelabel.textColor = [UIColor whiteColor];
        scorelabel.text = [NSString stringWithFormat:@"%@%d",KSCORE,DEFAULTSCORE];
        [leftView addSubview:scorelabel];
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];
        self.navigationItem.leftBarButtonItem = leftItem;
        
        [rightView release];
        [rightItem release];
        [leftView release];
        [leftItem release];
        
        imageArray = [[NSMutableArray alloc]init];

    }
    return self;
}

- (void)dealloc
{
    [overLayView release];
    [scorelabel release];
    [timeDisplayLabel release];
    [imageArray release];
    [timer release];
    timer = nil;
    [super dealloc]; 
}
- (void)createUI
{

    playCount = playCount +1;
    if (playCount>3) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [imageArray removeAllObjects];
    //Get data from plist
    NSMutableDictionary *plist = [[NSMutableDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Images" ofType:@"plist"]];
   NSMutableArray *locationArray = [[NSMutableArray alloc]init];
   NSArray * dataArray = [plist objectForKey:[NSString stringWithFormat:@"Screen %d",playCount]];
    for (int i = 0; i < [dataArray count]; i++) {
        NSMutableDictionary * data = [dataArray objectAtIndex:i];
        [imageArray addObject:[UIImage imageNamed:[data objectForKey:@"Image"]]];
        [locationArray addObject:[data objectForKey:@"Postion"]];
    }
        
    //Add images on game screen
    for (int i = 0; i<[imageArray count]; i++)
    {
        UIImageView * hiddenImage = [[UIImageView alloc]init];
        CGPoint position = CGPointFromString([locationArray objectAtIndex:i]);
        [hiddenImage setFrame:CGRectMake(position.x, position.y, 50, 50)];
        [hiddenImage setImage:[imageArray objectAtIndex:i]];
        [hiddenImage setTag:i+100];
        [hiddenImage setUserInteractionEnabled:YES];
        [self.view addSubview:hiddenImage];
        hiddenImage.contentMode = UIViewContentModeScaleAspectFit;
        [hiddenImage release];
    }
    [locationArray release];
    [self resetUI];
}

- (void)resetUI
{
    timer = nil;
    for(UILabel *label in [namesBackGround subviews])
    {
     label.textColor = [UIColor blackColor];
    }
    time = DEFAULTTIME;
    timeDisplayLabel.textColor = [UIColor whiteColor];
    timeDisplayLabel.text = [NSString stringWithFormat:@"%@%d",KTIME,DEFAULTTIME];
}
- (void)removeAddedImages
{
    for(UIImageView *imageview in self.view.subviews)
    {
        if ([imageArray containsObject:imageview.image]) {
            [imageview removeFromSuperview];
        }
    }
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark Gaming methods

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) 
    {
        case 0:
            exit(0);
            
            break;
        case 1:
            [overLayView removeFromSuperview];
            [self createUI];
            break;
        default:
            break;
    }
}

/**
 * Display the time 
 */

- (void) caliculateTime
{
    time = time - 1;
    timeDisplayLabel .text = [NSString stringWithFormat:@"%@%d",KTIME,time];
    if (time <= 0) 
    {
        [timer invalidate];
        [self removeAddedImages];

         UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"Score" message:[NSString stringWithFormat:@"You got %d points \n Do you want to play again",score] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Quit",@"Play", nil];
        [alertview show];
        [alertview release];
        
    }
    else if(time == 5)
    {
        timeDisplayLabel.textColor = [UIColor redColor];
//        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"***Alert***" message:@"Your time is elapsing" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertview show];
//        [alertview release];
     }
}

- (void)helpButtonPressed
{
    if (helpCount >0) {
        helpCount = helpCount -1;
        if (helpCount == 0) {
            [helpBadge setHidden:YES];
        }
    [helpBadge autoBadgeSizeWithString:[NSString stringWithFormat:@"%d",helpCount]];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIImageView *selImage = (UIImageView *)[touch view];
    NSLog(@"image %@",selImage);
    if ([imageArray containsObject:selImage.image])
    {
        if (selImage.tag%100 == 13) {
            helpCount = helpCount +1;
            [helpBadge setHidden:NO];
            [helpBadge autoBadgeSizeWithString:[NSString stringWithFormat:@"%d",helpCount]];
        }
        
        else{
        score = score + 10;
        scorelabel.text = [NSString stringWithFormat:@"%@%d",KSCORE,score];
            //Color changes when a image is selected.
            for(UILabel *label in [namesBackGround subviews])
            {
                int tagvalue=[label tag];
                if((tagvalue-100)==[[touch view]tag])
                {
                    label.textColor=[UIColor redColor];
                }
            }
        }
        CGPoint location = CGPointMake(selImage.frame.origin.x, selImage.frame.origin.y);
        
        //Animate the image when user taps the hidden image
        [UIImageView beginAnimations:nil context:nil];
        [UIImageView setAnimationDelegate:self];
        [UIImageView setAnimationDuration:0.5f];
        [UIImageView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        CGAffineTransform scaleTrans = CGAffineTransformMakeScale(30,30);
        
        selImage.transform = CGAffineTransformInvert(scaleTrans);
        selImage.center = location;
        [UIImageView commitAnimations];
                
                //Display alert if user founds all hidden images
        if (score == 60*playCount)
        {
            [timer invalidate];
            [self removeAddedImages];

            UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"Congratulations" message:[NSString stringWithFormat:@"You got %d points \n Do you want to play again",score] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Quit",@"Play", nil];
            [alertview show];
            [alertview release];
        }
    }
    //Create a timer
    if (!timer)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(caliculateTime) userInfo:nil repeats:YES];
    }  
}

@end
