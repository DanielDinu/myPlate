//
//  MPSplashViewController.h
//  myPlate
//
//  Created by Daniel Dinu on 12/11/12.
//  Copyright (c) 2012 Daniel Dinu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPSplashViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *acceptButtonClicked;
- (IBAction)acceptButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *toaLabel;


@end
