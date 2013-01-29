//
//  MPLoginViewController.h
//  myPlate
//
//  Created by Daniel Dinu on 12/11/12.
//  Copyright (c) 2012 Daniel Dinu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPFindScanViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UIScrollView *theScrollView;
    UITextField *activeTextField;
}
- (IBAction)dismissKeyboard:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *scanTextfield;

@property (weak, nonatomic) IBOutlet UIButton *sendScan;
- (IBAction)sendScan:(id)sender;

-(IBAction) editingChanged:(UITextField*)sender;

@end
