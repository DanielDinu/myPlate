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
    UIColor     *strokeColor;
    UIColor     *rectColor;
    CGFloat     strokeWidth;
    CGFloat     cornerRadius;
    
    NSData *devToken;
    

    }


#define kDefaultStrokeColor         [UIColor whiteColor]
#define kDefaultRectColor           [UIColor whiteColor]
#define kDefaultStrokeWidth         1.0
#define kDefaultCornerRadius        30.0
@property(weak, nonatomic)  UITextField *activeTextField;
@property(strong, nonatomic)  UITextField *usernameTextField;
@property(strong, nonatomic)  UITextField *passwordTextField;
@property(weak, nonatomic) UIScrollView *theScrollView;

@property (nonatomic, retain) UIColor *strokeColor;
@property (nonatomic, retain) UIColor *rectColor;
@property CGFloat strokeWidth;
@property CGFloat cornerRadius;

- (IBAction)dismissKeyboard:(id)sender;
@property (strong, nonatomic) NSData *tokenDev;
//@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
- (IBAction)didChangeUsernameText:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *LogInButton;

- (IBAction)SignInButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *SignInButton;
- (IBAction)loginButtonClicked:(id)sender;


@end
