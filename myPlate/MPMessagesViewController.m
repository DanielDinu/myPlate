//
//  MPMessagesViewController.m
//  myPlate
//
//  Created by Daniel Dinu on 2/18/13.
//  Copyright (c) 2013 Daniel Dinu. All rights reserved.
//
#define TABBAR_HEIGHT 10.0f
#define TEXTFIELD_HEIGHT 70.0f
#import "MPMessagesViewController.h"

@interface MPMessagesViewController ()

@end

@implementation MPMessagesViewController

@synthesize tableView,textMessage,chatData;
- (IBAction)textFieldDoneEditing:(id)sender {
}

-(void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) keyboardWasShown:(NSNotification*)aNotification
{
    //NSLog(@"Keyboard was shown");
    NSDictionary* info = [aNotification userInfo];
    
    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    // Move
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    //NSLog(@"frame..%f..%f..%f..%f",self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    //NSLog(@"keyboard..%f..%f..%f..%f",keyboardFrame.origin.x, keyboardFrame.origin.y, keyboardFrame.size.width, keyboardFrame.size.height);
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y- keyboardFrame.size.height+TABBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
   
    [UIView commitAnimations];
    
}

-(void) keyboardWillHide:(NSNotification*)aNotification
{
    //NSLog(@"Keyboard will hide");
    NSDictionary* info = [aNotification userInfo];
    
    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    // Move
   // [UIView beginAnimations:nil context:nil];
    //[UIView setAnimationDuration:animationDuration];
    //[UIView setAnimationCurve:animationCurve];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + keyboardFrame.size.height-TABBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
    [tableView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-TABBAR_HEIGHT)];
    [UIView commitAnimations];
}


-(IBAction) backgroundTap:(id) sender
{
    [self.textMessage resignFirstResponder];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//NSLog(@"%@",chatData);
    return [chatData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
	chatCell *cell = (chatCell *)[tableView dequeueReusableCellWithIdentifier: @"chatCellIdentifier"];
    NSUInteger row = [chatData count]-[indexPath row]-1;
    
    if (row < chatData.count){
        NSString *chatText = [[chatData objectAtIndex:row] objectForKey:@"text"];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        UIFont *font = [UIFont systemFontOfSize:14];
        CGSize size = [chatText sizeWithFont:font constrainedToSize:CGSizeMake(225.0f, 1000.0f) lineBreakMode:UILineBreakModeCharacterWrap];
        cell.textString.frame = CGRectMake(75, 14, size.width +20, size.height + 20);
        cell.textString.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        cell.textString.text = chatText;
        [cell.textString sizeToFit];
        
        NSDate *theDate = [[chatData objectAtIndex:row] objectForKey:@"date"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm a"];
        NSString *timeString = [formatter stringFromDate:theDate];
        cell.timeLabel.text = timeString;
        
        cell.userLabel.text = [[chatData objectAtIndex:row] objectForKey:@"userName"];
    }

    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText = [[chatData objectAtIndex:chatData.count-indexPath.row-1] objectForKey:@"text"];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize constraintSize = CGSizeMake(225.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height + 40;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
   NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"screen"];
    if (textMessage.text.length>0) {
        //NSLog(@"scrii");
        // updating the table immediately
        NSArray *keys = [NSArray arrayWithObjects:@"text", @"userName", @"date", nil];
        NSArray *objects = [NSArray arrayWithObjects:textMessage.text, userName, [NSDate date], nil];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        [chatData addObject:dictionary];
        
        NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [insertIndexPaths addObject:newPath];
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
        [tableView endUpdates];
        //[tableView reloadData];
       
        NSString *post2=[NSString stringWithFormat:@"user_ID1=%@&user_ID2=%@&mes=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],[[NSUserDefaults standardUserDefaults] valueForKey:@"useridFriend"],textMessage.text];
        NSLog(@"post string is: %@",post2);
        NSData *postData2 = [post2 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength2 = [NSString stringWithFormat:@"%d", [postData2 length]];
        
        NSMutableURLRequest *cerere2 = [[NSMutableURLRequest alloc] init];
        [cerere2 setURL:[NSURL URLWithString:@"http://thewebcap.com/dev/ios/im.php"]];
        [cerere2 setHTTPMethod:@"POST"];
        [cerere2 setValue:postLength2 forHTTPHeaderField:@"Content-Length"];
        [cerere2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [cerere2 setHTTPBody:postData2];
        NSURLResponse* response2 = nil;
        NSError* error2=nil;
        NSData *serverReply2 = [NSURLConnection sendSynchronousRequest:cerere2 returningResponse:&response2 error:&error2];
        NSString *replyString2 = [[NSString alloc] initWithBytes:[serverReply2 bytes] length:[serverReply2 length] encoding: NSASCIIStringEncoding];
        NSLog(@"reply string is : %@",replyString2);
        //NSLog(@"reply string is : %@",replyString2);
           }
    textMessage.text = @"";

    return NO;

}

-(void)handleUpdatedData:(NSNotification *)notification {
    //NSLog(@"%@",notification);
    NSObject *mesaj = [notification object];

    NSDictionary *aps1 = [NSDictionary dictionaryWithDictionary:(NSDictionary *) mesaj ];
    NSDictionary *aps2 = [NSDictionary dictionaryWithDictionary:(NSDictionary *) [aps1 objectForKey:@"aps"] ];



    NSString *tip = [aps2 objectForKey:@"tip"];

        if ([tip isEqualToString:@"friend"]) {
            
        }
        
        else if([tip isEqualToString:@"message"]){
            id mesajPrimit = [aps2 objectForKey:@"alert"];
            NSString *id_who_added = [aps2 objectForKey:@"id"];
            [[NSUserDefaults standardUserDefaults] setObject:id_who_added forKey:@"id_who_added_you"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //NSLog(@"id = %@",id_who_added);
            if([mesajPrimit isKindOfClass:[NSString class]]) {
                
                
                NSString *post2=[NSString stringWithFormat:@"search=id&ID=%@",id_who_added];
                //NSLog(@"post string is: %@",post2);
                NSData *postData2 = [post2 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                
                NSString *postLength2 = [NSString stringWithFormat:@"%d", [postData2 length]];
                
                NSMutableURLRequest *cerere2 = [[NSMutableURLRequest alloc] init];
                [cerere2 setURL:[NSURL URLWithString:@"http://thewebcap.com/dev/ios/search.php"]];
                [cerere2 setHTTPMethod:@"POST"];
                [cerere2 setValue:postLength2 forHTTPHeaderField:@"Content-Length"];
                [cerere2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                [cerere2 setHTTPBody:postData2];
                NSURLResponse* response2 = nil;
                NSError* error2=nil;
                NSData *serverReply2 = [NSURLConnection sendSynchronousRequest:cerere2 returningResponse:&response2 error:&error2];
                NSString *replyString2 = [[NSString alloc] initWithBytes:[serverReply2 bytes] length:[serverReply2 length] encoding: NSASCIIStringEncoding];
                //NSLog(@"reply string is : %@",replyString2);
                NSArray *prieteni_user = [replyString2 componentsSeparatedByString:@"*~*"];
                NSString *numePrieten = [prieteni_user objectAtIndex:0];
                
                NSArray *keys = [NSArray arrayWithObjects:@"text", @"userName", @"date", nil];
                NSArray *objects = [NSArray arrayWithObjects:mesajPrimit, numePrieten, [NSDate date], nil];
                NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
                [chatData addObject:dictionary];
                
                NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
                NSIndexPath *newPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [insertIndexPaths addObject:newPath];
                [tableView beginUpdates];
                [tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
                [tableView endUpdates];
            }}
    }

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"inMessages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)viewWillAppear:(BOOL)animated
{

}
- (void)viewDidLoad
{
    consoleList = [[NSMutableArray alloc]init];
    [self setTitle:[[NSUserDefaults standardUserDefaults] stringForKey:@"numePrieten"]];

    [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"inMessages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdatedData:) name:@"mesajNotif" object:nil];

    [self registerForKeyboardNotifications];
    chatData  = [[NSMutableArray alloc] init];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
