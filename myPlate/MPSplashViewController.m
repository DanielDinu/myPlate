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
@end
