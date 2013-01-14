//
//  MPCarDataViewController.h
//  myPlate
//
//  Created by Daniel Dinu on 12/12/12.
//  Copyright (c) 2012 Daniel Dinu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPCarDataViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSString *fullName;
    UITextField *activeTextField;
IBOutlet UIScrollView *theScrollView;
    __weak IBOutlet UITextField *txtText;
    NSString *userText;
    NSArray *cities;
    NSArray *models;
    __weak IBOutlet UITextField *modsText;
    __weak IBOutlet UITextField *modelText;
    __weak IBOutlet UITextField *colorText;
    NSArray *make;
    __weak IBOutlet UIButton *uploadButtonClicked;
   }
@property(nonatomic, retain) NSString *fullName;
@property(nonatomic) NSString *resultLabel;
@property(nonatomic) NSString *userText;
- (IBAction)doneButtonClicked:(id)sender;

@property (nonatomic, strong) NSString *recipeName;
@property (nonatomic, strong) id infoRequest;
@property (weak, nonatomic) IBOutlet UITextField *powerText;
@property (weak, nonatomic) IBOutlet UITextField *modsText;
@property (weak, nonatomic) IBOutlet UITextField *engineText;
@property (weak, nonatomic) IBOutlet UITextField *txtText;
@property (weak, nonatomic) IBOutlet UITextField *modelText;
@property (weak, nonatomic) IBOutlet UITextField *colorText;
@property (nonatomic,retain) IBOutlet UIPickerView *cityPicker;
@property (weak, nonatomic) IBOutlet UITextField *regnumberText;
- (IBAction)uploadButtonClicked:(id)sender;
- (IBAction)takePhotoButtonClicked:(id)sender;

@property (nonatomic,retain) IBOutlet UIPickerView *modelPicker;
@property (weak, nonatomic) IBOutlet UIButton *uploadButtonClicked;
@end
