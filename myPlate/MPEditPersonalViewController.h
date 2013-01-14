//
//  MPPersonalDataViewController.h
//  myPlate
//
//  Created by Daniel Dinu on 12/11/12.
//  Copyright (c) 2012 Daniel Dinu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPCarDataViewController.h"
@interface MPEditPersonalViewController : UIViewController<UITextFieldDelegate>
{
    
    MPCarDataViewController *mpcardata;
    
    IBOutlet UITextField *screenNameTextField;
    IBOutlet UITextField *ageTextField;
    IBOutlet UITextField *shortBioTextField;
    
    __weak IBOutlet UITextField *pickUserNameTextField;
    __weak IBOutlet UISegmentedControl *segmentedControl;
    
    __weak IBOutlet UITextField *pickPasswordTextfield;
    IBOutlet UIScrollView *theScrollView;
    UITextField *activeTextField;
    __weak IBOutlet UITextField *repeatPickPasswordTextField;
    NSArray *date_user;
}

- (IBAction)saveEdit:(id)sender;

@property (nonatomic, strong) id infoRequest;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)segmentedControlIndexChanged:(id)sender;
@property(nonatomic) NSString *someData;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)nextButtonClicked:(id)sender;

@end
