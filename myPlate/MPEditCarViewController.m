//
//  MPEditCarViewController.m
//  myPlate
//
//  Created by Daniel Dinu on 1/8/13.
//  Copyright (c) 2013 Daniel Dinu. All rights reserved.
//

#import "MPEditCarViewController.h"

@interface MPEditCarViewController ()
@property (nonatomic, strong)UIImagePickerController *imagePicker;

@end

@implementation MPEditCarViewController

@synthesize resultLabel,fullName;
-(UIImagePickerController *) imagePicker
{
    if(_imagePicker == nil
       ) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}
@synthesize recipeName;
@synthesize cityPicker;
@synthesize txtText;
@synthesize modelText;
@synthesize modelPicker;
@synthesize powerText;
@synthesize modsText;
@synthesize engineText;
@synthesize colorText;
@synthesize regnumberText;
/*
 -(void)TakePhoto
 {
 
 }
 
 -(void)pickPhoto
 {
 
 }
 
 -(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
 {
 if(buttonIndex == actionSheet.cancelButtonIndex) return;
 
 switch (buttonIndex) {
 case 0:
 [self TakePhoto];
 break;
 
 case 1:
 [self pickPhoto];
 break;
 
 }
 }*/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

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
    //passing the id
    NSLog(@"received info %@", [self.infoRequest description]);
    recipeName = [self.infoRequest description];
    ////------------------------------
    self.navigationItem.hidesBackButton = YES;
    //resultLabel = userText;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //------------------------------------
    NSString *user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"];
    NSString *post4=[NSString stringWithFormat:@"id=%@",user_id];
    NSLog(@"post string is :%@",post4);
    NSData *postData4 = [post4 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength4 = [NSString stringWithFormat:@"%d", [postData4 length]];
    
    NSMutableURLRequest *cerere4 = [[NSMutableURLRequest alloc] init];
    [cerere4 setURL:[NSURL URLWithString:@"http://thewebcap.com/dev/ios/edit_car.php"]];
    [cerere4 setHTTPMethod:@"POST"];
    [cerere4 setValue:postLength4 forHTTPHeaderField:@"Content-Length"];
    [cerere4 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [cerere4 setHTTPBody:postData4];
    NSURLResponse* response4 = nil;
    NSError* error4=nil;
    NSData *serverReply4 = [NSURLConnection sendSynchronousRequest:cerere4 returningResponse:&response4 error:&error4];
    NSString *replyString4 = [[NSString alloc] initWithBytes:[serverReply4 bytes] length:[serverReply4 length] encoding: NSASCIIStringEncoding];
    NSLog(@"reply string is :%@",replyString4);
//---------------------------------------
    NSArray *date_user = [replyString4 componentsSeparatedByString:@"*~*"];
    regnumberText.text = [date_user objectAtIndex:0];
    txtText.text = [date_user objectAtIndex:1];
    modelText.text = [date_user objectAtIndex:2];
    engineText.text = [date_user objectAtIndex:3];
    powerText.text = [date_user objectAtIndex:4];
    colorText.text = [date_user objectAtIndex:5];
    modsText.text = [date_user objectAtIndex:6];
    //-------------------------------------------
    
    //HTPP POST-GET Request
    //make
    NSString *post=[NSString stringWithFormat:@"data=make"];
    NSLog(@"post string is :%@",post);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *cerere = [[NSMutableURLRequest alloc] init];
    [cerere setURL:[NSURL URLWithString:@"http://thewebcap.com/dev/ios/make.php"]];
    [cerere setHTTPMethod:@"POST"];
    [cerere setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [cerere setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [cerere setHTTPBody:postData];
    NSURLResponse* response = nil;
    NSError* error=nil;
    NSData *serverReply = [NSURLConnection sendSynchronousRequest:cerere returningResponse:&response error:&error];
    NSString *replyString = [[NSString alloc] initWithBytes:[serverReply bytes] length:[serverReply length] encoding: NSASCIIStringEncoding];
    NSLog(@"reply string is :%@",replyString);
    //--------------
    
    make = [replyString componentsSeparatedByString:@"*~*"];
    cities = make;
    cityPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    
    NSLog(@"%@",cities);
    cityPicker.delegate = self;
    cityPicker.dataSource = self;
    [cityPicker setShowsSelectionIndicator:YES];
    txtText.inputView = cityPicker;
    UIToolbar*  mypickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    mypickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [mypickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked)];
    [barItems addObject:doneBtn];
    [mypickerToolbar setItems:barItems animated:YES];
    txtText.inputAccessoryView = mypickerToolbar;
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self->txtText resignFirstResponder];
    [self->modelText resignFirstResponder];
    [self->powerText resignFirstResponder];
    [self->modsText resignFirstResponder];
    [self->colorText resignFirstResponder];
    [self->regnumberText resignFirstResponder];
    [self->engineText resignFirstResponder];
    return NO;
    
}

-(void)pickerDoneClicked2
{
    [modelPicker resignFirstResponder];
    [modelText resignFirstResponder];
    
}

//done make => model

-(void)pickerDoneClicked

{
    
    NSString *post3=[NSString stringWithFormat:@"make=%@",txtText.text];
    NSLog(@"post string is :%@",post3);
    NSData *postData3 = [post3 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength3 = [NSString stringWithFormat:@"%d", [postData3 length]];
    
    NSMutableURLRequest *cerere3 = [[NSMutableURLRequest alloc] init];
    [cerere3 setURL:[NSURL URLWithString:@"http://thewebcap.com/dev/ios/model.php"]];
    [cerere3 setHTTPMethod:@"POST"];
    [cerere3 setValue:postLength3 forHTTPHeaderField:@"Content-Length"];
    [cerere3 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [cerere3 setHTTPBody:postData3];
    NSURLResponse* response3 = nil;
    NSError* error3=nil;
    NSData *serverReply3 = [NSURLConnection sendSynchronousRequest:cerere3 returningResponse:&response3 error:&error3];
    NSString *replyString3 = [[NSString alloc] initWithBytes:[serverReply3 bytes] length:[serverReply3 length] encoding: NSASCIIStringEncoding];
    NSLog(@"reply string is :%@",replyString3);
    
    models=[replyString3 componentsSeparatedByString:@"*~*"];
    
    
    
    
    NSLog(@"Done Clicked");
    modelPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [txtText resignFirstResponder];
    NSLog(@"%@",models);
    modelPicker.delegate = self;
    modelPicker.dataSource = self;
    [modelPicker setShowsSelectionIndicator:YES];
    modelText.inputView = modelPicker;
    UIToolbar*  mypickerToolbar2 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    mypickerToolbar2.barStyle = UIBarStyleBlackOpaque;
    [mypickerToolbar2 sizeToFit];
    NSMutableArray *barItems2 = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems2 addObject:flexSpace2];
    UIBarButtonItem *doneBtn2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked2)];
    [barItems2 addObject:doneBtn2];
    [mypickerToolbar2 setItems:barItems2 animated:YES];
    modelText.inputAccessoryView = mypickerToolbar2;
    
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField == colorText){
        int length = [textField.text length] ;
        if (length >= 10 && ![string isEqualToString:@""]) {
            textField.text = [textField.text substringToIndex:10];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention!"
                                                            message:@"Color description should be 10 characters max !"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        return YES;}
    else if(textField == modsText){
        
        int length = [textField.text length] ;
        if (length >= 400 && ![string isEqualToString:@""]) {
            textField.text = [textField.text substringToIndex:140];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention!"
                                                            message:@"Mods description should be 400 characters max !"
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
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self->activeTextField = nil;
}
- (IBAction)dismissKeyboard:(id)sender
{
    [activeTextField resignFirstResponder];
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
    
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == modelPicker)
    {return models.count;}
    else return cities.count;
    
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == modelPicker)
    {return [models objectAtIndex:row];}
    else
        return [cities objectAtIndex:row];
    
}




- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component

{
    if (pickerView == modelPicker)
    {modelText.text = (NSString *) [models objectAtIndex:row];}
    else
        txtText.text = (NSString *)[cities objectAtIndex:row];
    
}

NSString *url;

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
	NSLog(@"idstr este: %@",recipeName);
	NSData *imageData = UIImageJPEGRepresentation(img, 1);
	NSString *user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"];
    
	NSString *urlString = @"http://thewebcap.com/dev/ios/test.php";
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	
	NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	NSString *contentHeader = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"ipodfile%@.jpg\"\r\n", user_id];
    [body appendData:[contentHeader dataUsingEncoding:NSUTF8StringEncoding]];
    
	[body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	url = returnString;
	NSLog(@"%@",returnString);
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
	[self  dismissModalViewControllerAnimated: YES];
	// need to show the upload image button now
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)uploadButtonClicked:(id)sender {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
}

- (IBAction)takePhotoButtonClicked:(id)sender {
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
}

//sending all the data to the server
- (IBAction)doneButtonClicked:(id)sender {
    
    NSString *user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"];
    NSString *post2=[NSString stringWithFormat:@"ID=%@&registration=%@&make=%@&model=%@&engine=%@&power=%@&color=%@&mods=%@&picture=%@",user_id,regnumberText.text,txtText.text,modelText.text,engineText.text,powerText.text,colorText.text,modsText.text,url];
    NSLog(@"post string is :%@",post2);
    NSData *postData2 = [post2 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength2 = [NSString stringWithFormat:@"%d", [postData2 length]];
    
    NSMutableURLRequest *cerere2 = [[NSMutableURLRequest alloc] init];
    [cerere2 setURL:[NSURL URLWithString:@"http://thewebcap.com/dev/ios/update.php?tip=masina"]];
    [cerere2 setHTTPMethod:@"POST"];
    [cerere2 setValue:postLength2 forHTTPHeaderField:@"Content-Length"];
    [cerere2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [cerere2 setHTTPBody:postData2];
    NSURLResponse* response2 = nil;
    NSError* error2=nil;
    NSData *serverReply2 = [NSURLConnection sendSynchronousRequest:cerere2 returningResponse:&response2 error:&error2];
    NSString *replyString2 = [[NSString alloc] initWithBytes:[serverReply2 bytes] length:[serverReply2 length] encoding: NSASCIIStringEncoding];
    NSLog(@"reply string is :%@",replyString2);
    
}
@end


