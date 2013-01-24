//
//  MPLoginViewController.m
//  myPlate
//
//  Created by Daniel Dinu on 12/11/12.
//  Copyright (c) 2012 Daniel Dinu. All rights reserved.
//

#import "MPLoginViewController.h"
#import "MPMainMenuViewController.h"
#import "Reachability.h"
#import "MPEditPersonalViewController.h"
#import "MPAppDelegate.h"

@interface MPLoginViewController ()

@end

@implementation MPLoginViewController
@synthesize usernameTextField;
@synthesize signUpButton;
@synthesize passwordTextField;
@synthesize SignInButton;
@synthesize tokenDev;

//pentru cand se schimba textul din casuta username
-(IBAction)didChangeUsernameText:(id)sender
{
    [self updateSignupButton];
       
}
- (void)applicationDidFinishLaunching:(UIApplication *)app {
    // other setup tasks here….
    
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//dupa ce apare tastatura la casuta , sa poti da return ca sa dispara
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    return NO;
    
}

-(IBAction) editingChanged:(UITextField*)sender
{
   
    if (sender == usernameTextField || sender ==passwordTextField)
    {
        
        // allow only alphanumeric chars
        NSString* newStr = [sender.text stringByTrimmingCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]];
        
        if ([newStr length] < [sender.text length])
        {
            sender.text = newStr;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention!"
                                                            message:@"Username and password must be alphanumerical !"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.location >= 10)
    {
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention!"
                                                        message:@"Username and password must be 10 characters max!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;

    }
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
  
        CGPoint scrollPoint = CGPointMake(0.0, activeTextField.frame.origin.y - (keyboardSize.height-70));
        [theScrollView setContentOffset:scrollPoint animated:YES];
    
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

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)){
        /// Create an alert if connection doesn't work
        UIAlertView *myAlert = [[UIAlertView alloc]
                                initWithTitle:@"No Internet Connection"
                                message:@"You require an internet connection via WiFi or cellular network for location finding to work."
                                delegate:self
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:@"Go to network settings",
                                nil];
        [myAlert show];  
         
    } else{  
        /// Whatever you want  
    }
     [[self navigationController] setNavigationBarHidden:NO animated:YES];
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
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//verificare casute sa nu fie goale
-(void)updateSignupButton
{
    self.SignInButton.enabled=self.usernameTextField.text.length>0 ;
    
    
}



-(void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:animated];
    [self updateSignupButton];
}
- (IBAction)SignInButtonClicked:(id)sender {
}


NSString *devToken;
NSString *user_id;
- (IBAction)loginButtonClicked:(id)sender {
    
    devToken = [((MPAppDelegate *)[UIApplication sharedApplication].delegate).devTtrimis description];
    NSLog(devToken);
    NSString *post2=[NSString stringWithFormat:@"user=%@&pass=%@&token=%@",usernameTextField.text,passwordTextField.text,devToken];
    NSLog(@"post string is :%@",post2);
    NSData *postData2 = [post2 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength2 = [NSString stringWithFormat:@"%d", [postData2 length]];
    
    NSMutableURLRequest *cerere2 = [[NSMutableURLRequest alloc] init];
    [cerere2 setURL:[NSURL URLWithString:@"http://thewebcap.com/dev/ios/login.php"]];
    [cerere2 setHTTPMethod:@"POST"];
    [cerere2 setValue:postLength2 forHTTPHeaderField:@"Content-Length"];
    [cerere2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [cerere2 setHTTPBody:postData2];
    NSURLResponse* response2 = nil;
    NSError* error2=nil;
    NSData *serverReply2 = [NSURLConnection sendSynchronousRequest:cerere2 returningResponse:&response2 error:&error2];
    NSString *replyString2 = [[NSString alloc] initWithBytes:[serverReply2 bytes] length:[serverReply2 length] encoding: NSASCIIStringEncoding];
    NSLog(@"reply string is : %@",replyString2);
    user_id = replyString2;
    
    NSArray* incoming = [replyString2 componentsSeparatedByString:@":"];
    NSString *output = [incoming objectAtIndex:0];
   
   
    if([output isEqualToString:@"SUCCESS"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"logat"];
        [[NSUserDefaults standardUserDefaults] synchronize];

         NSString *user_id_primit = [incoming objectAtIndex:1];
        [[NSUserDefaults standardUserDefaults] setObject:user_id_primit forKey:@"userid"];
        NSString *post=[NSString stringWithFormat:@"id=%@",user_id_primit];
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
        NSArray *date_user = [replyString componentsSeparatedByString:@"*~*"];
        [[NSUserDefaults standardUserDefaults] setObject:[date_user objectAtIndex:0] forKey:@"screen"];
        [[NSUserDefaults standardUserDefaults] setObject:[date_user objectAtIndex:1] forKey:@"age"];
        [[NSUserDefaults standardUserDefaults] setObject:[date_user objectAtIndex:2] forKey:@"gen"];
        [[NSUserDefaults standardUserDefaults] setObject:[date_user objectAtIndex:3] forKey:@"shortBio"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        
        NSString *post4=[NSString stringWithFormat:@"id=%@",user_id_primit];
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
        NSArray *date_user2 = [replyString4 componentsSeparatedByString:@"*~*"];
        [[NSUserDefaults standardUserDefaults] setObject:[date_user2 objectAtIndex:0] forKey:@"regNumber"];
        [[NSUserDefaults standardUserDefaults] setObject:[date_user2 objectAtIndex:1] forKey:@"make"];
        [[NSUserDefaults standardUserDefaults] setObject:[date_user2 objectAtIndex:2] forKey:@"model"];
        [[NSUserDefaults standardUserDefaults] setObject:[date_user2 objectAtIndex:3] forKey:@"engine"];
        [[NSUserDefaults standardUserDefaults] setObject:[date_user2 objectAtIndex:4] forKey:@"power"];
        [[NSUserDefaults standardUserDefaults] setObject:[date_user2 objectAtIndex:5] forKey:@"color"];
        [[NSUserDefaults standardUserDefaults] setObject:[date_user2 objectAtIndex:6] forKey:@"mods"];
        [[NSUserDefaults standardUserDefaults] setObject:[date_user2 objectAtIndex:7] forKey:@"picture"];

        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSegueWithIdentifier:@"LoginToMenu" sender:self];
       
    }
    else if([output isEqualToString:@"ERR"])
    { 
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention!"
                                                    message:@"Incorrect username and/or password or username not registered !"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
        [alert show];
        NSLog(@"user si parola gresite");
    
        
     }
    else
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection!"
                                                    message:@"Please check your internet connection !"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}
}
@end
