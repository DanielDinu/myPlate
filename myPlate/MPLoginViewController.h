//
//  MPLoginViewController.h
//  myPlate
//
//  Created by Daniel Dinu on 12/11/12.
//  Copyright (c) 2012 Daniel Dinu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPLoginViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UIScrollView *theScrollView;
    UITextField *activeTextField;
}
- (IBAction)dismissKeyboard:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)didChangeUsernameText:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *LogInButton;

- (IBAction)SignInButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *SignInButton;
- (IBAction)loginButtonClicked:(id)sender;


@end
