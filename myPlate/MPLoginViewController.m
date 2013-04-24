//
//  MPLoginViewController.m
//  myPlate
//
//  Created by Daniel Dinu on 12/11/12.
//  Copyright (c) 2012 Daniel Dinu. All rights reserved.
//
#define Waiting 1
#import "MPLoginViewController.h"
#import "MPMainMenuViewController.h"
#import "Reachability.h"
#import "MPEditPersonalViewController.h"
#import "MPAppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "MPWaitingFriendRequestsViewController.h"
#import "JFRandom.h"
#import <QuartzCore/QuartzCore.h>
#import "MPPersonalDataViewController.h"
@interface MPLoginViewController ()
{}
@end

@implementation MPLoginViewController

@synthesize tokenDev;
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize activeTextField;

-(void)didChangeUsernameText:(id)sender
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
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    return YES;
    
}

-(void) editingChanged:(UITextField*)sender
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
    _theScrollView.contentInset = contentInsets;
    _theScrollView.scrollIndicatorInsets = contentInsets;
    // Step 3: Scroll the target text field into view.
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    
    CGPoint scrollPoint = CGPointMake(0.0, activeTextField.frame.origin.y - (keyboardSize.height-70));
    [_theScrollView setContentOffset:scrollPoint animated:YES];
    
}

- (void) keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _theScrollView.contentInset = contentInsets;
    _theScrollView.scrollIndicatorInsets = contentInsets;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTextField = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    self.activeTextField = nil;
}
- (void)dismissKeyboard:(id)sender
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

- (void)updateView {
    // get the app delegate, so that we can reference the session property
    MPAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen) {
        [FBSession setActiveSession:appDelegate.session];
        [FBRequestConnection
         startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                           id<FBGraphUser> user,
                                           NSError *error) {
             NSString *userInfo = @"";
             
             // Example: typed access (name)
             // - no special permissions required
             userInfo = [userInfo
                         stringByAppendingString:
                         [NSString stringWithFormat:@"Name: %@\n\n",
                          user.name]];
             
             // Example: typed access, (birthday)
             // - requires user_birthday permission
             userInfo = [userInfo
                         stringByAppendingString:
                         [NSString stringWithFormat:@"Birthday: %@\n\n",
                          user.birthday]];
             
             // Example: partially typed access, to location field,
             // name key (location)
             // - requires user_location permission
             userInfo = [userInfo
                         stringByAppendingString:
                         [NSString stringWithFormat:@"Location: %@\n\n",
                          [user.location objectForKey:@"name"]]];
             
             userInfo = [userInfo
                         stringByAppendingString:
                         [NSString stringWithFormat:@"email: %@\n\n",
                          [user objectForKey:@"email"]]];
             
             // Example: access via key (locale)
             // - no special permissions required
             userInfo = [userInfo
                         stringByAppendingString:
                         [NSString stringWithFormat:@"Locale: %@\n\n",
                          [user objectForKey:@"locale"]]];
             
             // Example: access via key for array (languages)
             // - requires user_likes permission
             if ([user objectForKey:@"languages"]) {
                 NSArray *languages = [user objectForKey:@"languages"];
                 NSMutableArray *languageNames = [[NSMutableArray alloc] init];
                 for (int i = 0; i < [languages count]; i++) {
                     [languageNames addObject:[[languages
                                                objectAtIndex:i]
                                               objectForKey:@"name"]];
                 }
                 userInfo = [userInfo
                             stringByAppendingString:
                             [NSString stringWithFormat:@"Languages: %@\n\n",
                              languageNames]];
             }
             NSLog(@"%@",userInfo);
             
             // Display the user info
         }];
        NSString *post2=[NSString stringWithFormat:@"mail=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"email"]];
        NSLog(@"post string is :%@",post2);
        NSData *postData2 = [post2 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength2 = [NSString stringWithFormat:@"%d", [postData2 length]];
        
        NSMutableURLRequest *cerere2 = [[NSMutableURLRequest alloc] init];
        [cerere2 setURL:[NSURL URLWithString:@"http://thewebcap.com/dev/ios/find_mail.php"]];
        [cerere2 setHTTPMethod:@"POST"];
        [cerere2 setValue:postLength2 forHTTPHeaderField:@"Content-Length"];
        [cerere2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [cerere2 setHTTPBody:postData2];
        NSURLResponse* response2 = nil;
        NSError* error2=nil;
        NSData *serverReply2 = [NSURLConnection sendSynchronousRequest:cerere2 returningResponse:&response2 error:&error2];
        NSString *replyString2 = [[NSString alloc] initWithBytes:[serverReply2 bytes] length:[serverReply2 length] encoding: NSASCIIStringEncoding];
        
        NSLog(@"reply string is : %@",replyString2);
        if(replyString2 == (id)[NSNull null] || replyString2.length == 0){
            int fbpass = (arc4random() % 100000) + 1;
            NSString *parola = [NSString stringWithFormat:@"%d", fbpass];
            [[NSUserDefaults standardUserDefaults] setObject:parola forKey:@"pass"];
            NSString *post2=[NSString stringWithFormat:@"user=%@&pass=%d&screen=%@&age=%@&sex=%@&bio=blabla&mail=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"numefb"],fbpass,[[NSUserDefaults standardUserDefaults] valueForKey:@"fbscreen"],[[NSUserDefaults standardUserDefaults] valueForKey:@"varstafb"],[[NSUserDefaults standardUserDefaults] valueForKey:@"sex"],[[NSUserDefaults standardUserDefaults] valueForKey:@"email"]];
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
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            
            MPMainMenuViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"CarData"];
            
            UINavigationController *navController = (UINavigationController *)self.navigationController;
            [navController.visibleViewController.navigationController pushViewController:myController animated:YES];
            [[self navigationController] setNavigationBarHidden:NO animated:YES];
            
        }
        else {
            
            [[NSUserDefaults standardUserDefaults] setObject:replyString2 forKey:@"userid"];
            NSString *user_id_primit = [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"];
            [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"logat"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
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
            
            NSString *post2=[NSString stringWithFormat:@"ID=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]];
            NSLog(@"post string is :%@",post2);
            NSData *postData2 = [post2 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSString *postLength2 = [NSString stringWithFormat:@"%d", [postData2 length]];
            
            NSMutableURLRequest *cerere2 = [[NSMutableURLRequest alloc] init];
            [cerere2 setURL:[NSURL URLWithString:@"http://thewebcap.com/dev/ios/list_requests.php"]];
            [cerere2 setHTTPMethod:@"POST"];
            [cerere2 setValue:postLength2 forHTTPHeaderField:@"Content-Length"];
            [cerere2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [cerere2 setHTTPBody:postData2];
            NSURLResponse* response2 = nil;
            NSError* error2=nil;
            NSData *serverReply2 = [NSURLConnection sendSynchronousRequest:cerere2 returningResponse:&response2 error:&error2];
            NSString *replyString2 = [[NSString alloc] initWithBytes:[serverReply2 bytes] length:[serverReply2 length] encoding: NSASCIIStringEncoding];
            
            NSLog(@"reply string is : %@",replyString2);
            if(replyString2 == (id)[NSNull null] || replyString2.length == 0)
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                
                MPMainMenuViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
                
                UINavigationController *navController = (UINavigationController *)self.navigationController;
                [navController.visibleViewController.navigationController pushViewController:myController animated:YES];
                [[self navigationController] setNavigationBarHidden:NO animated:YES];
                
            }
            else{
                NSMutableArray *idPrieteni = [[NSMutableArray alloc]init];
                NSArray *lista = [replyString2 componentsSeparatedByString:@"*~*"];
                for (int i=0; i<[lista count]; i++) {
                    NSString *itemLista = [lista objectAtIndex:i];
                    NSArray *itemListaSpart = [itemLista componentsSeparatedByString:@"~;~"];
                    [idPrieteni addObject:[itemListaSpart objectAtIndex:0]];
                    NSLog(@"%@",idPrieteni);
                    [[NSUserDefaults standardUserDefaults] setObject:idPrieteni forKey:@"idPrieteni"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                }
                if(idPrieteni)
                {
                    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Attention!"
                                                                     message:@"You have some waiting friend requests !"
                                                                    delegate:self
                                           
                                                           cancelButtonTitle:@"Close"
                                                           otherButtonTitles:@"Show",nil];
                    
                    //alert1.tag =Waiting;
                    [alert1 show];
                }
                
            }}

        // valid account UI is shown whenever the session is open
        NSLog(@"%@",appDelegate.session.accessTokenData.accessToken);
    } else {
       
        
    }
}


- (void)viewDidLoad
{
    
    //  CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [self updateView];
    
    MPAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                [self updateView];
            }];
        }
    }

    
    usernameTextField.text =@"dani";
    passwordTextField.text =@"daniel";
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    
    UIButton *signInButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *signInButtonImage = [UIImage imageNamed:@"button-blue.png"];
    [signInButton setBackgroundImage:signInButtonImage forState:UIControlStateNormal];
    NSAttributedString *signInAttributedText;
    signInAttributedText = [[NSAttributedString alloc] initWithString:@"SIGN IN" attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"PTSans-Bold" size:22], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [signInButton setAttributedTitle:signInAttributedText forState:UIControlStateNormal];
    signInButton.frame= CGRectMake(20.5, 300, 140, 31);
    [signInButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
    
    UIButton *signUpButton=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *signUpButtonImage = [UIImage imageNamed:@"button-black.png"];
    [signUpButton setBackgroundImage:signUpButtonImage forState:UIControlStateNormal];
    NSAttributedString *signUpAttributedText;
    signUpAttributedText = [[NSAttributedString alloc] initWithString:@"SIGN UP" attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"PTSans-Bold" size:22], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [signUpButton setAttributedTitle:signUpAttributedText forState:UIControlStateNormal];
    signUpButton.frame= CGRectMake(170, 300, 130, 51);
    [signUpButton addTarget:self action:@selector(SignInButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
    
    
    UIButton *facebookLogin=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imagineButonFacebook = [UIImage imageNamed:@"button-facebook.png"];
    [facebookLogin setBackgroundImage:imagineButonFacebook forState:UIControlStateNormal];
    facebookLogin.imageView.layer.borderWidth=5.0;
    facebookLogin.imageView.layer.borderColor=[UIColor blackColor].CGColor;
    //facebookLogin.layer.borderWidth=0;
    //facebookLogin.layer.borderColor=[UIColor blackColor].CGColor;
    NSAttributedString *facebookLogintext;
    facebookLogintext = [[NSAttributedString alloc] initWithString:@"FACEBOOK" attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"PTSans-Bold" size:20], NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
    [facebookLogin setAttributedTitle:facebookLogintext forState:UIControlStateNormal];
    [facebookLogin setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, -4, 0.0)];
    facebookLogin.layer.masksToBounds = NO;
    facebookLogin.clipsToBounds = NO;
    facebookLogin.frame= CGRectMake(16.5f, 60, 270, 37);
    facebookLogin.tag=1;
    [facebookLogin addTarget:self action:@selector(facebookLogin:) forControlEvents: UIControlEventTouchUpInside];
    
    
    
    
    UILabel *pleaseLoginLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 200, 40)];
    [pleaseLoginLabel setBackgroundColor:[UIColor clearColor]];
    [pleaseLoginLabel setFont:[UIFont fontWithName:@"PTSans-Regular" size:17.0]];
    [pleaseLoginLabel setTextColor:[UIColor darkGrayColor]];
    [pleaseLoginLabel setText:@"PLEASE LOGIN WITH"];
    
    
    UIView *outer = [[UIView alloc] initWithFrame:CGRectMake(8, 10, 300, 150)];
    outer.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.4 ];
    [self.view addSubview:outer];
    outer.layer.shadowRadius = 2.0;
    outer.layer.shadowColor = [UIColor blackColor].CGColor;
    outer.layer.shadowOpacity = 0.4;
    outer.layer.shadowOffset = CGSizeMake(2, 2);
    outer.layer.cornerRadius = 5.0;
    [outer addSubview:pleaseLoginLabel];
    [self.theScrollView addSubview:outer];
    [outer addSubview:facebookLogin];
    [self.theScrollView addSubview:signInButton];
    [self.theScrollView addSubview:signUpButton];
    
    /* cool effect
     headerView.layer.shadowColor = [[UIColor blackColor] CGColor];
     headerView.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
     headerView.layer.shadowOpacity = 1.0f;
     headerView.layer.shadowRadius = 10.0f;*/
    
    UIView *border = [[UIView alloc] initWithFrame:CGRectMake(9, 54, 285, 50)];
    border.backgroundColor=[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
    [outer insertSubview:border belowSubview:facebookLogin];
    border.layer.cornerRadius = 5.0;
    
    //22, 300, 130, 51
    UIView *borderSignIn = [[UIView alloc] initWithFrame:CGRectMake(7, 285, 140, 61)];
    borderSignIn.backgroundColor=[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
    [outer insertSubview:borderSignIn belowSubview:signInButton];
    borderSignIn.layer.cornerRadius = 5.0;
    
    UIView *borderSignUp = [[UIView alloc] initWithFrame:CGRectMake(156.5, 285, 140, 61)];
    borderSignUp.backgroundColor=[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
    [outer insertSubview:borderSignUp belowSubview:signUpButton];
    borderSignUp.layer.cornerRadius = 5.0;
    
    UIImage *imagine = [UIImage imageNamed: @"login-field.png"];
    usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 190, 300, 48)];
    usernameTextField.borderStyle = UITextBorderStyleNone;
    usernameTextField.font = [UIFont fontWithName:@"PTSans-Bold" size:20];
    usernameTextField.placeholder = @"   Username";
    usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    usernameTextField.keyboardType = UIKeyboardTypeDefault;
    usernameTextField.returnKeyType = UIReturnKeyDone;
    usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    usernameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    usernameTextField.delegate = self;
    usernameTextField.background = imagine;
    [self.theScrollView addSubview:usernameTextField];
    
    passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 230, 300, 48)];
    passwordTextField.borderStyle = UITextBorderStyleNone;
    passwordTextField.font = [UIFont fontWithName:@"PTSans-Bold" size:20];
    passwordTextField.placeholder = @"   Password";
    passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordTextField.keyboardType = UIKeyboardTypeDefault;
    passwordTextField.returnKeyType = UIReturnKeyDone;
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordTextField.delegate = self;
    passwordTextField.background = imagine;
    [self.theScrollView addSubview:passwordTextField];
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    passwordTextField.leftView = paddingView1;
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    usernameTextField.leftView = paddingView2;
    usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [usernameTextField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents: UIControlEventEditingDidEnd];
    [usernameTextField addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
    [usernameTextField addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [usernameTextField addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventEditingDidEnd];
    [usernameTextField addTarget:self action:@selector(updateSignupButton) forControlEvents:UIControlEventEditingDidEnd];
    
    [passwordTextField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents: UIControlEventEditingDidEnd];
    [passwordTextField addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
    [passwordTextField addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [passwordTextField addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventEditingDidEnd];
    [passwordTextField addTarget:self action:@selector(updateSignupButton) forControlEvents:UIControlEventEditingDidEnd];
    
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg-texture.png"]];
    self.view.backgroundColor = background;
    UIImage *image = [UIImage imageNamed: @"menu-bar.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],UITextAttributeTextColor,[UIColor blackColor],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset ,[UIFont fontWithName:@"PTSans-Bold" size:22],UITextAttributeFont  , nil]];
    [super viewWillAppear:animated];
    [self updateSignupButton];
    
}
- (void)SignInButtonClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    MPMainMenuViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"SendInfo"];
    
    UINavigationController *navController = (UINavigationController *)self.navigationController;
    [navController.visibleViewController.navigationController pushViewController:myController animated:YES];
}


NSString *devToken;
NSString *user_id;
- (void)loginButtonClicked:(id)sender {
    
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
        
        NSString *post2=[NSString stringWithFormat:@"ID=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]];
        NSLog(@"post string is :%@",post2);
        NSData *postData2 = [post2 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength2 = [NSString stringWithFormat:@"%d", [postData2 length]];
        
        NSMutableURLRequest *cerere2 = [[NSMutableURLRequest alloc] init];
        [cerere2 setURL:[NSURL URLWithString:@"http://thewebcap.com/dev/ios/list_requests.php"]];
        [cerere2 setHTTPMethod:@"POST"];
        [cerere2 setValue:postLength2 forHTTPHeaderField:@"Content-Length"];
        [cerere2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [cerere2 setHTTPBody:postData2];
        NSURLResponse* response2 = nil;
        NSError* error2=nil;
        NSData *serverReply2 = [NSURLConnection sendSynchronousRequest:cerere2 returningResponse:&response2 error:&error2];
        NSString *replyString2 = [[NSString alloc] initWithBytes:[serverReply2 bytes] length:[serverReply2 length] encoding: NSASCIIStringEncoding];
        
        NSLog(@"reply string is : %@",replyString2);
        if(replyString2 == (id)[NSNull null] || replyString2.length == 0)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            
            MPMainMenuViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
            
            UINavigationController *navController = (UINavigationController *)self.navigationController;
            [navController.visibleViewController.navigationController pushViewController:myController animated:YES];
        }
        else{
            NSMutableArray *idPrieteni = [[NSMutableArray alloc]init];
            NSArray *lista = [replyString2 componentsSeparatedByString:@"*~*"];
            for (int i=0; i<[lista count]; i++) {
                NSString *itemLista = [lista objectAtIndex:i];
                NSArray *itemListaSpart = [itemLista componentsSeparatedByString:@"~;~"];
                [idPrieteni addObject:[itemListaSpart objectAtIndex:0]];
                NSLog(@"%@",idPrieteni);
                [[NSUserDefaults standardUserDefaults] setObject:idPrieteni forKey:@"idPrieteni"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
            }
            if(idPrieteni)
            {
                UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Attention!"
                                                                 message:@"You have some waiting friend requests !"
                                                                delegate:self
                                       
                                                       cancelButtonTitle:@"Close"
                                                       otherButtonTitles:@"Show",nil];
                
                //alert1.tag =Waiting;
                [alert1 show];
            }
            
        }}
    
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

- (void)facebookLogin:(id)sender {
    MPAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.session closeAndClearTokenInformation];
        
    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
            [self updateView];
        }];
    }
    
}




- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        MPWaitingFriendRequestsViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"Waiting"];
        
        UINavigationController *navController = (UINavigationController *)self.navigationController;
        [navController.visibleViewController.navigationController pushViewController:myController animated:YES];
        
    }
    
    else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        MPMainMenuViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
        
        UINavigationController *navController = (UINavigationController *)self.navigationController;
        [navController.visibleViewController.navigationController pushViewController:myController animated:YES];
    }}

- (void)viewDidUnload {
    
    [super viewDidUnload];
}



@end
