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
    if (buttonIndex == 0) 
    {
        exit(0);
    }
    else
    {
      [overLayView removeFromSuperview];
        
        timeDisplayLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 370, 44, 44)];
        [timeDisplayLabel setBackgroundColor:[UIColor redColor]];
        timeDisplayLabel.textAlignment = UITextAlignmentCenter;
        timeDisplayLabel.text = @"10";
        [self.view addSubview:timeDisplayLabel];
    }
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    UIImageView *selImage = (UIImageView *)[touch view];
    NSLog(@"touch recognized:%@",selImage);
    if ([array containsObject:selImage.image])
    {
        NSLog(@"touch recognized");
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
    }
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
