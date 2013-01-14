//
//  MPPersonalDataViewController.m
//  myPlate
//
//  Created by Daniel Dinu on 12/11/12.
//  Copyright (c) 2012 Daniel Dinu. All rights reserved.
//

#import "MPPersonalDataViewController.h"
#import "MPCarDataViewController.h"
@interface MPPersonalDataViewController ()

@end

@implementation MPPersonalDataViewController

@synthesize someData;

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
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField==pickUserNameTextField)
    {
        NSString *post2=[NSString stringWithFormat:@"user=%@",pickUserNameTextField.text];
        NSLog(@"post string is :%@",post2);
        NSData *postData2 = [post2 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength2 = [NSString stringWithFormat:@"%d", [postData2 length]];
        
        NSMutableURLRequest *cerere2 = [[NSMutableURLRequest alloc] init];
        [cerere2 setURL:[NSURL URLWithString:@"http://thewebcap.com/dev/ios/unic.php"]];
        [cerere2 setHTTPMethod:@"POST"];
        [cerere2 setValue:postLength2 forHTTPHeaderField:@"Content-Length"];
        [cerere2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [cerere2 setHTTPBody:postData2];
        NSURLResponse* response2 = nil;
        NSError* error2=nil;
        NSData *serverReply2 = [NSURLConnection sendSynchronousRequest:cerere2 returningResponse:&response2 error:&error2];
        NSString *replyString2 = [[NSString alloc] initWithBytes:[serverReply2 bytes] length:[serverReply2 length] encoding: NSASCIIStringEncoding];
        NSLog(@"reply string is :%@",replyString2);
        if([replyString2 isEqualToString:@"TRUE"])
        {
                    }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention!"
                                                            message:@"Username already registered! Please pick a different one."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            pickUserNameTextField.text =@"";

                  }
    }
    self->activeTextField = nil;
}
- (IBAction)dismissKeyboard:(id)sender
{
    [activeTextField resignFirstResponder];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField == pickUserNameTextField){
        int length = [textField.text length] ;
        if (length >= 10 && ![string isEqualToString:@""]) {
            textField.text = [textField.text substringToIndex:10];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention!"
                                                            message:@"User must be 10 characters max!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        return YES;}
    
    if(textField == pickPasswordTextfield){
        int length = [textField.text length] ;
        if (length >= 10 && ![string isEqualToString:@""]) {
            textField.text = [textField.text substringToIndex:10];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention!"
                                                            message:@"Password must be 10 characters max!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        return YES;}
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
    
    else if(textField == repeatPickPasswordTextField){
        int length = [textField.text length] ;
        if (length >= 10 && ![string isEqualToString:@""]) {
            textField.text = [textField.text substringToIndex:10];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention!"
                                                            message:@"Password must be 10 characters max!"
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self->screenNameTextField resignFirstResponder];
    [self->ageTextField resignFirstResponder];
    [self->shortBioTextField resignFirstResponder];
    [self->pickUserNameTextField resignFirstResponder];
    [self->pickPasswordTextfield resignFirstResponder];
    [self->repeatPickPasswordTextField resignFirstResponder];
    return NO;}
    
-(IBAction)verifyPass
{
    if ([pickPasswordTextfield.text isEqualToString:repeatPickPasswordTextField.text]){}
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention!"
                                                        message:@"Password must be identical !"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        repeatPickPasswordTextField.text=@"";
        

    }
}

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
        [_nextButton setEnabled:NO];
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
    
    [super viewDidLoad];
    [_nextButton setEnabled:NO];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
NSString *DeTrimis;
- (IBAction)nextButtonClicked:(id)sender {
    
    NSString *post2=[NSString stringWithFormat:@"user=%@&pass=%@&screen=%@&age=%@&sex=%@&bio=%@",pickUserNameTextField.text,pickPasswordTextfield.text,screenNameTextField.text,ageTextField.text,segmentedString,shortBioTextField.text];
    NSLog(@"post string is :%@",post2);
    NSData *postData2 = [post2 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength2 = [NSString stringWithFormat:@"%d", [postData2 length]];
    
    NSMutableURLRequest *cerere2 = [[NSMutableURLRequest alloc] init];
    [cerere2 setURL:[NSURL URLWithString:@"http://thewebcap.com/dev/ios/registration.php?tip=personal"]];
    [cerere2 setHTTPMethod:@"POST"];
    [cerere2 setValue:postLength2 forHTTPHeaderField:@"Content-Length"];
    [cerere2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [cerere2 setHTTPBody:postData2];
    NSURLResponse* response2 = nil;
    NSError* error2=nil;
    NSData *serverReply2 = [NSURLConnection sendSynchronousRequest:cerere2 returningResponse:&response2 error:&error2];
    NSString *replyString2 = [[NSString alloc] initWithBytes:[serverReply2 bytes] length:[serverReply2 length] encoding: NSASCIIStringEncoding];
    NSLog(@"reply string is :%@",replyString2);
    [[NSUserDefaults standardUserDefaults] setObject:replyString2 forKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
   
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSLog(@"text : %@",DeTrimis);
    NSLog(@"%@", [segue identifier]);
    if ([[segue identifier] isEqualToString:@"TrimiteInfo"]) {
        
        MPCarDataViewController *detailViewController = [segue destinationViewController];
        
        NSLog(@"text : %@",DeTrimis);
        
        detailViewController.infoRequest = DeTrimis;
    }
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
@end
