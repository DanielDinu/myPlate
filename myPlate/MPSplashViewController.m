//
//  MPSplashViewController.m
//  myPlate
//
//  Created by Daniel Dinu on 12/11/12.
//  Copyright (c) 2012 Daniel Dinu. All rights reserved.
//

#import "MPSplashViewController.h"

@interface MPSplashViewController ()

@end

@implementation MPSplashViewController
@synthesize toaLabel;
@synthesize acceptButtonClicked;

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    
   
       }

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
static NSString* const hasRunAppOnceKey = @"hasRunAppOnceKey";


- (void)viewDidLoad
{
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg-intro.png"]];
    self.view.backgroundColor = background;
   
    [toaLabel setBackgroundColor:[UIColor clearColor]];
    [toaLabel setFont:[UIFont fontWithName:@"PTSans-Bold" size:10.0]];
    [toaLabel setTextColor:[UIColor whiteColor]];
    [toaLabel setTextAlignment:UITextAlignmentCenter];
    [toaLabel setText:@"PLEASE READ CAREFULLY! \nPlease do not operate your mobile phone while driving.\nThis may result in severe injury or death.\nMyPlate takes no responsability for traffic disruptions."];
    [self.view addSubview:toaLabel];
    UIImage *enterButtonImage = [UIImage imageNamed:@"enter-button"];
    [acceptButtonClicked setImage:enterButtonImage forState:UIControlStateNormal];
    NSAttributedString *TOA;
    TOA = [[NSAttributedString alloc] initWithString:@"Read Terms of Service" attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:10], NSUnderlineStyleAttributeName : @1 , NSForegroundColorAttributeName:[UIColor grayColor]}];
    
    UIButton *onTOA = [UIButton buttonWithType:UIButtonTypeCustom];
    [onTOA addTarget:self
             action:@selector(onTOA)
   forControlEvents:UIControlEventTouchUpInside];
    [onTOA setAttributedTitle:TOA forState:UIControlStateNormal];
    onTOA.titleLabel.font = [UIFont systemFontOfSize:12];
    onTOA.frame = CGRectMake(self.view.frame.size.width  - 147, 302, 140, 40);
    [self.view addSubview:onTOA];
    
   [[self navigationController] setNavigationBarHidden:YES animated:YES];
              
    [super viewDidLoad];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        NSLog(@"aplicatia a mai rulat");
        // app already launched
        [self performSegueWithIdentifier:@"1" sender:self];
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // This is the first launch ever
        NSLog(@"aplicatia ruleaza prima data");
    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)acceptButtonClicked:(id)sender {
    
    
 }

- (void)onANPC
{
        
}

- (void)viewDidUnload {
    [self setToaLabel:nil];
    [self setToaLabel:nil];
    [super viewDidUnload];
}
@end
