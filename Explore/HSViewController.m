//
//  HSViewController.m
//  Hide&Seek
//
//  Created by Sailaja Kamisetty on 17/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HSViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface HSViewController ()

@end

@implementation HSViewController
@synthesize storyImage,storyLabelIn,storyLabelOut;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self.title = @"Hide & Seek";
        
        //Create Buttons
        UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
       [skipButton setFrame:CGRectMake(170, 390, 80, 35)];
        [skipButton setTitle:@"Skip" forState:UIControlStateNormal];
        [skipButton addTarget:self action:@selector(skipButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:skipButton];
        
        UIButton *playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [playButton setFrame:CGRectMake(50, 390, 80, 35)];
        [playButton setTitle:@"Continue" forState:UIControlStateNormal];
        [playButton addTarget:self action:@selector(ContinueStory) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:playButton];
        
        
        //Add data to story & label frames
        imageview = [[UIImageView alloc]initWithFrame:CGRectMake(16,16,288, 167)];
        [imageview setImage:[UIImage imageNamed:@"Sairam.jpg"]];
        [self.storyImage addSubview:imageview];
        [imageview release];
        
        
        description = [[UILabel alloc]initWithFrame:CGRectMake(15,0,240,100)];
       [description setBackgroundColor:[UIColor clearColor]];
        description.text = @"Need to add the story description related to the story image & it changes from screen to screen";
        description.numberOfLines = 5;
        [self.storyLabelIn addSubview:description];
        
        //Store the data of story & labels
        imageArray = [[NSMutableArray alloc]initWithObjects:@"Vishnu.jpg",@"amma.jpg",@"god.jpg",nil];
    
        labelArray = [[NSMutableArray alloc]initWithObjects:@"Vishnu Story",@"Durgamma Story",@"SitaRam Story", nil];
        
        
    }
    return self;
}

#pragma mark -
#pragma mark Animation methods

/**
 * Animation to present story & label frames
 */
- (void)easeIn
{
    if (tapCount < [imageArray count])
    {
        [imageview setImage:[UIImage imageNamed:[imageArray objectAtIndex:tapCount]]];
        description .text = [labelArray objectAtIndex:tapCount];
        tapCount++;
        if (tapCount == [imageArray count]) 
        {
            [self performSelector:@selector(skipButtonClicked)];
        }
    }
    
    if (tapCount == 0) {
    [self.storyImage setFrame:CGRectMake( -130.0f, 44.0f, 320.0f, 200.0f)]; //notice this is OFF screen!
    [UIView beginAnimations:@"animateStoryImage" context:nil];
    [UIView setAnimationDuration:2];
    [self.storyImage setFrame:CGRectMake( 0.0f, 44.0f, 320.0f, 200.0f)]; //notice this is ON screen!
    [UIView commitAnimations];
    }
    
    [self.storyLabelIn setFrame:CGRectMake( -130.0f, 272.0f, 268.0f,110.0f)]; //notice this is OFF screen!
    [UIView beginAnimations:@"animateStoryLabelIn" context:nil];
    [UIView setAnimationDuration:2];
    [self.storyLabelIn setFrame:CGRectMake( 26.0f, 272.0f, 268.0f, 110.0f)]; //notice this is ON screen!
    [UIView commitAnimations]; 
    
   }

/**
 * Animation to remove story & label frames
 */
- (void)easeOut
{
    self.storyLabelOut = self.storyLabelIn;
    
    [UIView beginAnimations:@"animateStoryLabelOut" context:nil];
    [UIView setAnimationDuration:2];
    [self.storyLabelOut setFrame:CGRectMake( 376.0f, 272.0f, 268.0f, 110.0f)]; //notice this is ON screen!
    [UIView commitAnimations]; 
    
 }

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self easeIn];
     tapCount = 0;
   	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.title = @"";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Button Action methods

- (void)ContinueStory
{
    [self easeOut];
    [self performSelector:@selector(easeIn) withObject:nil afterDelay:1.0];
}

- (void)skipButtonClicked
{
    DirectStoryViewController *directViewObject = [[DirectStoryViewController alloc]init];
    [self.navigationController pushViewController:directViewObject animated:NO];
    [directViewObject release];
}

@end
