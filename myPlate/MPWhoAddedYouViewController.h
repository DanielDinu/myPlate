//
//  MPWhoAddedYouViewController.h
//  myPlate
//
//  Created by Daniel Dinu on 1/25/13.
//  Copyright (c) 2013 Daniel Dinu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPWhoAddedYouViewController : UIViewController<UITextFieldDelegate>
{
    __weak IBOutlet UILabel *regNumberLabel;
    
    __weak IBOutlet UILabel *colorLabel;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *makeLabel;
    __weak IBOutlet UILabel *modelLabel;
    __weak IBOutlet UILabel *engineLabel;
    __weak IBOutlet UILabel *ageLabel;
    __weak IBOutlet UILabel *genderLabel;
    __weak IBOutlet UILabel *shortbioLabel;
    __weak IBOutlet UIImageView *pozaFriend;
    
}
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;
- (IBAction)acceptFriend:(id)sender;
- (IBAction)rejectFriend:(id)sender;
@property (strong, nonatomic) UIWindow *window;
@end
