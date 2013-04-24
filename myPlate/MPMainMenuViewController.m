//
//  MPMainMenuViewController.m
//  myPlate
//
//  Created by Daniel Dinu on 12/18/12.
//  Copyright (c) 2012 Daniel Dinu. All rights reserved.
//

#import "MPMainMenuViewController.h"
#import "MPEditPersonalViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MPAppDelegate.h"
#import "MPLoginViewController.h"
@interface MPMainMenuViewController ()

@end

@implementation MPMainMenuViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationItem.title=@"Main Menu";
    self.navigationItem.hidesBackButton=YES;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
      		    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
    [[NSUserDefaults standardUserDefaults] synchronize];
   
    [FBSession.activeSession closeAndClearTokenInformation];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    MPMainMenuViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
    
    UINavigationController *navController = (UINavigationController *)self.navigationController;
    [navController.visibleViewController.navigationController pushViewController: myController animated:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];

}
@end
