//
//  MPMainMenuViewController.m
//  myPlate
//
//  Created by Daniel Dinu on 12/18/12.
//  Copyright (c) 2012 Daniel Dinu. All rights reserved.
//

#import "MPMainMenuViewController.h"
#import "MPEditPersonalViewController.h"
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
     self.navigationItem.hidesBackButton = YES;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
