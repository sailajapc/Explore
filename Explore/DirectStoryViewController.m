//
//  DirectStoryViewController.m
//  Hide&Seek
//
//  Created by Sailaja Kamisetty on 23/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DirectStoryViewController.h"

@implementation DirectStoryViewController

- (id)init {
    self = [super init];
    if (self) 
    {
        UIImageView *backGround = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dining.jpeg"]];
        [backGround setFrame:self.view.frame];
        [backGround setUserInteractionEnabled:YES];
        [self.view addSubview:backGround];
        
        self.title = @"Hide & Seek";
        
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
        
        UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];

        timeDisplayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 90, 35)];
        [timeDisplayLabel setBackgroundColor:[UIColor clearColor]];
        timeDisplayLabel.textAlignment = UITextAlignmentCenter;
        timeDisplayLabel.textColor = [UIColor whiteColor];
        timeDisplayLabel.text = [NSString stringWithFormat:@"Time : %d",time];
        [rightView addSubview:timeDisplayLabel];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
        self.navigationItem.rightBarButtonItem = rightItem;
        
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
        
        scorelabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 70, 35)];
        scorelabel.textAlignment = UITextAlignmentLeft;
        [scorelabel setBackgroundColor:[UIColor clearColor]];
        scorelabel.textColor = [UIColor whiteColor];
        scorelabel.text = [NSString stringWithFormat:@"Score : %d",score];
        [leftView addSubview:scorelabel];
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

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
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) caliculateTime
{
    time = time - 1;
    timeDisplayLabel .text = [NSString stringWithFormat:@"Time : %d",time];
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    UIImageView *selImage = (UIImageView *)[touch view];
    NSLog(@"touch recognized:%@",selImage);
     
//    UILabel *scorelabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 370, 60, 35)];
//    scorelabel.textAlignment = UITextAlignmentLeft;
 
    if ([array containsObject:selImage.image])
    {
        score = score + 10;
        NSLog(@"touch recognized");
        
        scorelabel.text = [NSString stringWithFormat:@"%d",score];
        
        CGPoint location = CGPointMake(selImage.frame.origin.x, selImage.frame.origin.y);
        
        [UIImageView beginAnimations:nil context:nil];
        [UIImageView setAnimationDelegate:self];
        [UIImageView setAnimationDuration:1.5f];
        [UIImageView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        CGAffineTransform scaleTrans = CGAffineTransformMakeScale(30,30);
//        CGAffineTransform rotateTrans = CGAffineTransformMakeRotation(1 * M_PI / 180);
        
       selImage.transform = CGAffineTransformInvert(scaleTrans);
        selImage.center = location;
        [UIImageView commitAnimations];
        
        if (score == [array count] *10) 
        {
            [timer invalidate];

            UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"Congratulations" message:[NSString stringWithFormat:@"You got %d points \n Do you want to play again",score] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Quit",@"Play", nil];
            [alertview show];
            [alertview release];

        }
    }
    if (!timer) 
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(caliculateTime) userInfo:nil repeats:YES];

    }  
       
    
//    scorelabel.text = [NSString stringWithFormat:@"%d",score];
//    [self.view addSubview:scorelabel];
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

@end
