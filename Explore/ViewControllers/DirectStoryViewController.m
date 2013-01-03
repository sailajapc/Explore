//
//  DirectStoryViewController.m
//  Hide&Seek
//
//  Created by Sailaja Kamisetty on 23/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DirectStoryViewController.h"
#import "CustomBadge.h"
#import "HSSingletonClass.h"

#define KTIME @"Time : "
#define KSCORE @"Score : "
#define DEFAULTTIME 20
#define DEFAULTSCORE 0

@interface DirectStoryViewController()

- (void)createUI;
- (void)resetUI;
- (void)removeAddedImages;
- (void)createLabels;
- (void)createImages:(NSArray *)images inLocations:(NSArray *)locations;
- (void)animationEffectMethod:(UIImageView *)image;

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
        namesBackGround.tag = 1234;
        [self.view addSubview:namesBackGround];
        [namesBackGround release];
        
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
        scorelabel.text = [NSString stringWithFormat:@"%@%d",KSCORE,[[HSSingletonClass sharedSingleton] getScore]];
        [leftView addSubview:scorelabel];
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];
        self.navigationItem.leftBarButtonItem = leftItem;
        
        [rightView release];
        [rightItem release];
        [leftView release];
        [leftItem release];
    }
    return self;
}

- (void)dealloc
{
    [overLayView release];
    [scorelabel release];
    [timeDisplayLabel release];
    //[timer release];
    timer = nil;
    [super dealloc]; 
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
#pragma mark Display UI methods

/**
 * Display Images from plist 
 */

- (void)createUI
{
    playCount = playCount +1;
    if (playCount>3) {
        [[HSSingletonClass sharedSingleton]incrementStoryLevel];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
  if (playCount == 1) {
    //Get data from plist
    NSMutableDictionary *plist = [[HSSingletonClass sharedSingleton]loadPlistData];
   dataArray = [plist objectForKey:[NSString stringWithFormat:@"Screen %d",[[HSSingletonClass sharedSingleton] getStoryLevel]]];
  }
    NSMutableArray *locationArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [dataArray count]; i++) {
        NSMutableDictionary * data = [dataArray objectAtIndex:i];
        [imageArray addObject:[UIImage imageNamed:[data objectForKey:@"Image"]]];
        [locationArray addObject:[data objectForKey:@"Postion"]];
    }
    
    //Add images on game screen
    [self createImages:imageArray inLocations:locationArray];
    [imageArray release];
    [locationArray release];
    [self createLabels];
    }
}

/**
 * Adding images on game screen 
 */
- (void)createImages:(NSArray *)images inLocations:(NSArray *)locations
{
    for (int i = 0; i<[images count]; i++)
    {
        UIImageView * hiddenImage = [[UIImageView alloc]init];
        CGPoint position = CGPointFromString([locations objectAtIndex:i]);
        [hiddenImage setFrame:CGRectMake(position.x, position.y, 50, 50)];
        [hiddenImage setImage:[images objectAtIndex:i]];
        [hiddenImage setTag:i+100];
        [hiddenImage setUserInteractionEnabled:YES];
        [self.view addSubview:hiddenImage];
        hiddenImage.contentMode = UIViewContentModeScaleAspectFit;
        [hiddenImage release];
    }
 
}
/**
 * Reset the Time 
 */

- (void)resetUI
{
    timer = nil;
    time = DEFAULTTIME;
    timeDisplayLabel.textColor = [UIColor whiteColor];
    timeDisplayLabel.text = [NSString stringWithFormat:@"%@%d",KTIME,DEFAULTTIME];
    
    for (int j = 0; j< [labelNames count]; j++) {
         for (int m = 0; m< [dataArray count]; m++) {
             NSMutableDictionary * data = [dataArray objectAtIndex:m];
             if ([[labelNames objectAtIndex:j]isEqualToString:[data objectForKey:@"Name"] ]) {
                  NSLog(@"remove:%@",[data objectForKey:@"Name"]);
                 [dataArray removeObjectAtIndex:m];
             }
         }
    }
    labelNames = nil;
}

/**
 * Clear the Screen 
 */

- (void)removeAddedImages
{
    for(UIImageView *imageview in self.view.subviews)
    {
        NSLog(@"imageView:%@",imageview);
        if (imageview.tag >= 100 && imageview.tag <=100+[dataArray count]) {
            [imageview removeFromSuperview];
        }
    }
    [self resetUI];
}

/**
 * Display the Labels randomly 
 */

- (void)createLabels{
    NSMutableArray *labelNamesarray = [[NSMutableArray alloc]init];
    labelNames = [[NSMutableArray alloc]init];
    for(UILabel *label in [namesBackGround subviews])
    {
        [label removeFromSuperview];
    }
    //Get 6 random numbers 
    NSMutableArray *numbers = [NSMutableArray array];
    for (int k = 1; k < [dataArray count]-1; k++) {
        [numbers addObject:[NSString stringWithFormat:@"%d",k]];
    }
    result = [[NSMutableArray array]retain];
    while ([result count] <6) {
        int r = arc4random() % [numbers count];
        [result addObject:[numbers objectAtIndex:r]];
        [numbers removeObjectAtIndex:r];
    }
    for (int j = 0; j< [result count]; j++) {
        NSMutableDictionary * data = [dataArray objectAtIndex:[[result objectAtIndex:j]intValue]];
        [labelNamesarray addObject:[data objectForKey:@"Name"]];
    }
    int i=0,k=0;
    while(i<[labelNamesarray count])
    {
        int y = k*32;
        int j=0;
        
        //Display 6 labels
        for(j=0; j<2;j++){
            if (i>=[labelNamesarray count]) break;
            UILabel *labelText = [[[UILabel alloc] init] autorelease];
            labelText.text=[labelNamesarray objectAtIndex:i];
            labelText.textColor = [UIColor blackColor];
            labelText.font = [UIFont systemFontOfSize:14];
            labelText.backgroundColor = [UIColor clearColor];
            labelText.textAlignment = UITextAlignmentLeft;
            labelText.tag = 500 + [[result objectAtIndex:i]intValue];
            [labelText setFrame:CGRectMake((45*(j+1)+80*j), y-10, 80, 50)];
            [namesBackGround addSubview:labelText];
            i++;
        }
        k = k+1;
    }
    [labelNamesarray release];
}

#pragma mark -
#pragma mark Alert Delegate methods

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
        default:
            break;
    }
}

#pragma mark -
#pragma mark Gaming methods
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
       [[HSSingletonClass sharedSingleton] updateScore:score];
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
    if (helpCount >0 && [result count] > 0) {
        helpCount = helpCount -1;
        
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:[[result objectAtIndex:0]intValue]+ 100];
        imageView.layer.borderColor = [[UIColor greenColor]CGColor];
        
        CATransition *animation = [CATransition animation];
        [animation setDelegate:self];
        [animation setDuration:2.0f];
        [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
        [animation setType:@"rippleEffect" ];
        [animation setRepeatCount:2];
        [imageView.layer addAnimation:animation forKey:NULL];
        imageView.layer.borderWidth = 5.0;
        
        if (helpCount == 0) 
        {
            [helpBadge setHidden:YES];
        }
    [helpBadge autoBadgeSizeWithString:[NSString stringWithFormat:@"%d",helpCount]];
    }
}

- (void)animationEffectMethod:(UIImageView *)image
{
    CGPoint location = CGPointMake(image.frame.origin.x, image.frame.origin.y);
    
    //Animate the image when user taps the hidden image
    [UIImageView beginAnimations:nil context:nil];
    [UIImageView setAnimationDelegate:self];
    [UIImageView setAnimationDuration:0.5f];
    [UIImageView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    CGAffineTransform scaleTrans = CGAffineTransformMakeScale(30,30);
    
    image.transform = CGAffineTransformInvert(scaleTrans);
    image.center = location;
    [UIImageView commitAnimations];
    
}

#pragma mark -
#pragma mark Touch methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIImageView *selImage = (UIImageView *)[touch view];
    
    if (selImage.tag == 100 && selImage.tag != 1234) {
        [self animationEffectMethod:selImage];
        helpCount = helpCount +1;
        [helpBadge setHidden:NO];
        [helpBadge autoBadgeSizeWithString:[NSString stringWithFormat:@"%d",helpCount]];
        [dataArray removeObjectAtIndex:0];
    }
    
    else{
        
        for (int s= 0; s < [result count]; s++) 
        {
            if (selImage.tag%100 == [[result objectAtIndex:s]intValue] && selImage.tag != 1234)
            {
                [self animationEffectMethod:selImage];
                score = score + 10;
                scorelabel.text = [NSString stringWithFormat:@"%@%d",KSCORE,score];
                
                //Color changes when a image is selected.
                UILabel *label = (UILabel *)[namesBackGround viewWithTag:[[result objectAtIndex:s]intValue]+500];
                label.textColor = [UIColor cyanColor];
                [labelNames addObject:label.text];
                [result removeObjectAtIndex:s];
            }
        }
    }
    
    //Display alert if user founds all hidden images
    if (score == [[HSSingletonClass sharedSingleton] getScore]+60)
    {
        [timer invalidate];
        [self removeAddedImages];
        [[HSSingletonClass sharedSingleton] updateScore:score];
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"Congratulations" message:[NSString stringWithFormat:@"You got %d points \n Do you want to play again",score] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Quit",@"Play", nil];
        [alertview show];
        [alertview release];
    }
    //Create a timer
    if (!timer)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(caliculateTime) userInfo:nil repeats:YES];
    }  
}

@end
