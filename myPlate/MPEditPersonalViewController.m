//
//  MPEditPersonalViewController.m
//  myPlate
//
//  Created by Daniel Dinu on 1/7/13.
//  Copyright (c) 2013 Daniel Dinu. All rights reserved.
//

#import "MPEditPersonalViewController.h"
#import "MPPersonalDataViewController.h"

@interface MPEditPersonalViewController ()

@end

@implementation MPEditPersonalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField == screenNameTextField){
        int length = [textField.text length] ;
        if (length >= 10 && ![string isEqualToString:@""]) {
            textField.text = [textField.text substringToIndex:10];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention!"
                                                            message:@"Screen name must be 10 characters max!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        return YES;}
    
       
    else if(textField == shortBioTextField){
        
        int length = [textField.text length] ;
        if (length >= 140 && ![string isEqualToString:@""]) {
            textField.text = [textField.text substringToIndex:140];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention!"
                                                            message:@"Short bio must be 140 characters max!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return NO;
        }}
    return YES;
    
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    // Step 1: Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    // Step 2: Adjust the bottom content inset of your scroll view by the keyboard height.
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    theScrollView.contentInset = contentInsets;
    theScrollView.scrollIndicatorInsets = contentInsets;
    // Step 3: Scroll the target text field into view.
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeTextField.frame.origin.y - (keyboardSize.height-15));
        [theScrollView setContentOffset:scrollPoint animated:YES];
    }
}
- (void) keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    theScrollView.contentInset = contentInsets;
    theScrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self->activeTextField = textField;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self->screenNameTextField resignFirstResponder];
    [self->ageTextField resignFirstResponder];
    [self->shortBioTextField resignFirstResponder];
    [self->pickUserNameTextField resignFirstResponder];
    [self->pickPasswordTextfield resignFirstResponder];
    [self->repeatPickPasswordTextField resignFirstResponder];
    return NO;}

- (IBAction)editingChanged {
    
    /////////////////////
    NSString* newStr = [pickUserNameTextField.text stringByTrimmingCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]];
    
    if ([newStr length] < [pickUserNameTextField.text length])
    {
        pickUserNameTextField.text = newStr;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention!"
                                                        message:@"Username and password must be alphanumerical !"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    //////////////////
    NSString* newStr1 = [pickPasswordTextfield.text stringByTrimmingCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]];
    
    if ([newStr1 length] < [pickPasswordTextfield.text length])
    {
        pickPasswordTextfield.text = newStr1;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention!"
                                                        message:@"Username and password must be alphanumerical !"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    ///////////////////////////////////
    
    NSString* newStr2 = [repeatPickPasswordTextField.text stringByTrimmingCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]];
    
    if ([newStr2 length] < [repeatPickPasswordTextField.text length])
    {
        repeatPickPasswordTextField.text = newStr2;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention!"
                                                        message:@"Username and password must be alphanumerical !"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    ///////////////////////////////////
    
    NSString* newStr3 = [screenNameTextField.text stringByTrimmingCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]];
    
    if ([newStr3 length] < [screenNameTextField.text length])
    {
        screenNameTextField.text = newStr3;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention!"
                                                        message:@"Username and password must be alphanumerical !"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    //////////////////
    
    if ([screenNameTextField.text length] != 0 && [ageTextField.text length] != 0 && [shortBioTextField.text length] != 0 && [pickUserNameTextField.text length] !=0 && [pickPasswordTextfield.text length] !=0 && [pickPasswordTextfield.text length] !=0) {
        [_nextButton setEnabled:YES];
    }
    else {
        //[_nextButton setEnabled:NO];
    }
}



- (void)viewDidLoad
{
    self.navigationItem.hidesBackButton = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.navigationItem.hidesBackButton = YES;
   // NSLog(@"received info %@", [self.editinfo description]);
    //id_user = [self.editinfo description];
    NSString *user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"];
    NSString *post=[NSString stringWithFormat:@"id=%@",user_id];
    NSLog(@"post string is :%@",post);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *cerere = [[NSMutableURLRequest alloc] init];
    [cerere setURL:[NSURL URLWithString:@"http://thewebcap.com/dev/ios/edit_personal.php"]];
    [cerere setHTTPMethod:@"POST"];
    [cerere setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [cerere setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [cerere setHTTPBody:postData];
    NSURLResponse* response = nil;
    NSError* error=nil;
    NSData *serverReply = [NSURLConnection sendSynchronousRequest:cerere returningResponse:&response error:&error];
    NSString *replyString = [[NSString alloc] initWithBytes:[serverReply bytes] length:[serverReply length] encoding: NSASCIIStringEncoding];
    NSLog(@"reply string is :%@",replyString);
    date_user = [replyString componentsSeparatedByString:@"*~*"];
    screenNameTextField.text = [date_user objectAtIndex:0];
    ageTextField.text = [date_user objectAtIndex:1];
    NSString *gen = [date_user objectAtIndex:2];
    if ([ gen isEqualToString:@"1" ])
    {
        [segmentedControl setSelectedSegmentIndex:1];
        
    }
    shortBioTextField.text = [date_user objectAtIndex:3];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

NSString *segmentedString;
- (IBAction)segmentedControlIndexChanged:(id)sender {
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            segmentedString=@"Male";            break;
        case 1:
            segmentedString=@"Female";
            break;
            
        default:
            break;
    }
}

- (IBAction)saveEdit:(id)sender {
    NSLog(@"se trimite");
    
    NSString *id_user = [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"];
    NSString *post=[NSString stringWithFormat:@"screen=%@&age=%@&sex=%@&bio=%@&ID=%@",screenNameTextField.text,ageTextField.text,segmentedString,shortBioTextField.text,id_user];
    NSLog(@"post string is :%@",post);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *cerere = [[NSMutableURLRequest alloc] init];
    [cerere setURL:[NSURL URLWithString:@"http://thewebcap.com/dev/ios/update.php?tip=personal"]];
    [cerere setHTTPMethod:@"POST"];
    [cerere setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [cerere setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [cerere setHTTPBody:postData];
    NSURLResponse* response = nil;
    NSError* error=nil;
    NSData *serverReply = [NSURLConnection sendSynchronousRequest:cerere returningResponse:&response error:&error];
    NSString *replyString = [[NSString alloc] initWithBytes:[serverReply bytes] length:[serverReply length] encoding: NSASCIIStringEncoding];
    NSLog(@"reply string is :%@",replyString);
    
}
@end
