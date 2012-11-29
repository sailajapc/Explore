//
//  DirectStoryViewController.m
//  Hide&Seek
//
//  Created by Sailaja Kamisetty on 23/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DirectStoryViewController.h"
#define KTIME @"Time : "
#define KSCORE @"Score : "
@implementation DirectStoryViewController

- (id)init {
    self = [super init];
    if (self) 
    {
        UIImageView *backGround = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dining.jpeg"]];
        [backGround setFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y - 60, self.view.frame.size.width,self.view.frame.size.height -60)];
        [backGround setUserInteractionEnabled:YES];
        [self.view addSubview:backGround];
        [backGround release];
        
        UIImageView *namesBackGround = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"namesLabel.jpg"]];
        [namesBackGround setFrame:CGRectMake(0,362,self.view.frame.size.width - 60,100)];
        [namesBackGround setUserInteractionEnabled:YES];
        [self.view addSubview:namesBackGround];
        [namesBackGround release];
        
        labelNamesarray = [[NSArray alloc]initWithObjects:@"flower",@"ball",@"bell",@"flower11",@"ball11",@"bell11", nil];
        
        int i=0,k=0; 
		
		while(i<6)
        {
			int y = k*32;
			int j=0;
            //Display num of images for each row
			for(j=0; j<2;j++){
				if (i>=6) break;
				UILabel *label = [[[UILabel alloc] init] autorelease];
                label.text=[labelNamesarray objectAtIndex:i];
                label.textColor = [UIColor blackColor];
				label.backgroundColor = [UIColor clearColor];
				label.textAlignment = UITextAlignmentCenter;
                [label setFrame:CGRectMake((40*(j+1)+90*j), y-10, 60, 50)];
                [namesBackGround addSubview:label];
                i++;
			}
			k = k+1;
		}

        UIButton *helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [helpButton setBackgroundImage:[UIImage imageNamed:@"helppress.jpeg"] forState:UIControlStateNormal];
        [helpButton setFrame:CGRectMake(262,362,55,97)];
        [helpButton addTarget:self action:@selector(helpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:helpButton];
        
        self.title = @"Hide & Seek";
        
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
        
        array = [[NSArray alloc]initWithObjects:[UIImage imageNamed:@"flower.jpeg"],[UIImage imageNamed:@"flower.jpg"],[UIImage imageNamed:@"ball.jpg"], nil];
        
        //Add images on game screen
        for (int i = 0; i<[array count]; i++)
        {
            UIImageView * hiddenImage = [[UIImageView alloc]init];
            [hiddenImage setFrame:CGRectMake(50, 50*(i+1), 30, 30)];
            [hiddenImage setImage:[array objectAtIndex:i]];
            [hiddenImage setTag:i];
            [hiddenImage setUserInteractionEnabled:YES];
            [self.view addSubview:hiddenImage];
            [hiddenImage release];
        }
        time = 20;
        score = 0;
        
        //Add time label on right side of navigation bar
        UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];

        timeDisplayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 80, 35)];
        [timeDisplayLabel setBackgroundColor:[UIColor clearColor]];
        timeDisplayLabel.textAlignment = UITextAlignmentCenter;
        timeDisplayLabel.textColor = [UIColor whiteColor];
        timeDisplayLabel.text = [NSString stringWithFormat:@"%@%d",KTIME,time];
        [rightView addSubview:timeDisplayLabel];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
        self.navigationItem.rightBarButtonItem = rightItem;
        
        //Add score label on right side of navigation bar
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
        
        scorelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 80, 35)];
        scorelabel.textAlignment = UITextAlignmentLeft;
        [scorelabel setBackgroundColor:[UIColor clearColor]];
        scorelabel.textColor = [UIColor whiteColor];
        scorelabel.text = [NSString stringWithFormat:@"%@%d",KSCORE,score];
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
    [array release];
    [timer release];
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
#pragma mark Gaming methods

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            exit(0);
            
            break;
        case 1:
            [overLayView removeFromSuperview];
            
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
        
         UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"Score" message:[NSString stringWithFormat:@"You got %d points \n Do you want to play again",score] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Quit",@"Play", nil];
        [alertview show];
        [alertview release];
    }
    else if(time == 5)
    {
        timeDisplayLabel.textColor = [UIColor redColor];

        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"***Alert***" message:@"Your time is elapsing" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertview show];
        [alertview release];
     }
}

- (void)helpButtonPressed
{
    NSLog(@"Help Button Pressed");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIImageView *selImage = (UIImageView *)[touch view];
      
    if ([array containsObject:selImage.image])
    {
        score = score + 10;
        scorelabel.text = [NSString stringWithFormat:@"%@%d",KSCORE,score];
        
        CGPoint location = CGPointMake(selImage.frame.origin.x, selImage.frame.origin.y);
        
        //Animate the image when user taps the hidden image
        [UIImageView beginAnimations:nil context:nil];
        [UIImageView setAnimationDelegate:self];
        [UIImageView setAnimationDuration:1.5f];
        [UIImageView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        CGAffineTransform scaleTrans = CGAffineTransformMakeScale(30,30);
        
        selImage.transform = CGAffineTransformInvert(scaleTrans);
        selImage.center = location;
        [UIImageView commitAnimations];
        
        //Display alert if user founds all hidden images
        if (score == [array count] *10)
        {
            [timer invalidate];

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
