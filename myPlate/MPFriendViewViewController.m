//
//  MPFriendViewViewController.m
//  myPlate
//
//  Created by Daniel Dinu on 1/10/13.
//  Copyright (c) 2013 Daniel Dinu. All rights reserved.
//

#import "MPFriendViewViewController.h"
#import "MPMainMenuViewController.h"
@interface MPFriendViewViewController ()

@end

@implementation MPFriendViewViewController
@synthesize addFriendButton,unfriendButton;

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
    
    
    
    ///////////////////////////////////////////////////////////////////////////////////
    
    NSString *post2=[NSString stringWithFormat:@"search=id&ID=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"useridFriend"]];
    NSLog(@"post string is: %@",post2);
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
    NSLog(@"reply string is : %@",replyString2);
    NSArray *prieteni_user1 = [replyString2 componentsSeparatedByString:@"*~*"];
    
    NSArray *date_user = [replyString2 componentsSeparatedByString:@"*~*"];
        [[NSUserDefaults standardUserDefaults] setObject:[date_user objectAtIndex:4] forKey:@"useridFriend"];
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    regNumberLabel.text = [date_user objectAtIndex:5];
    nameLabel.text = [date_user objectAtIndex:0];;
    colorLabel.text = [date_user objectAtIndex:10];
    makeLabel.text = [date_user objectAtIndex:6];
    modelLabel.text = [date_user objectAtIndex:7];
    engineLabel.text = [[date_user objectAtIndex:8] stringByAppendingString:@" bhp"];
    ageLabel.text = [date_user objectAtIndex:1];
    genderLabel.text = [date_user objectAtIndex:2];
    shortbioLabel.text = [date_user objectAtIndex:3];
    NSString *id_path = [date_user objectAtIndex:12];
    NSURL *url = [NSURL URLWithString:id_path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    pozaFriend.image = img;
    self.title = [date_user objectAtIndex:0];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    ///////////////////////////////////////////////////////////////////////////
    
    NSString *post3=[NSString stringWithFormat:@"ID=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]];
    NSLog(@"post string is :%@",post3);
    NSData *postData3 = [post3 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength3 = [NSString stringWithFormat:@"%d", [postData3 length]];
    
    NSMutableURLRequest *cerere3 = [[NSMutableURLRequest alloc] init];
    [cerere3 setURL:[NSURL URLWithString:@"http://thewebcap.com/dev/ios/list_friends.php"]];
    [cerere3 setHTTPMethod:@"POST"];
    [cerere3 setValue:postLength3 forHTTPHeaderField:@"Content-Length"];
    [cerere3 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [cerere3 setHTTPBody:postData3];
    NSURLResponse* response3 = nil;
    NSError* error3=nil;
    NSData *serverReply3 = [NSURLConnection sendSynchronousRequest:cerere3 returningResponse:&response3 error:&error3];
    NSString *replyString3 = [[NSString alloc] initWithBytes:[serverReply3 bytes] length:[serverReply3 length] encoding: NSASCIIStringEncoding];
    NSLog(@"reply string is : %@",replyString3);
    
    NSArray *prieteni_user = [replyString3 componentsSeparatedByString:@"*~*"];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"useridFriend"]);
    if ([replyString3 rangeOfString:[[NSUserDefaults standardUserDefaults] valueForKey:@"useridFriend"]].location != NSNotFound) {
        NSLog(@"Yes it does contain that word");
        addFriendButton.hidden = TRUE;
        unfriendButton.hidden = FALSE;
    }
    
    
    else {addFriendButton.hidden = FALSE;
        unfriendButton.hidden=TRUE;}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (IBAction)addFriend:(id)sender {
   

    NSString *post2=[NSString stringWithFormat:@"tip=request&user_ID1=%@&user_ID2=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],[[NSUserDefaults standardUserDefaults] valueForKey:@"useridFriend"]];
    NSLog(@"post string is :%@",post2);
    NSData *postData2 = [post2 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength2 = [NSString stringWithFormat:@"%d", [postData2 length]];
    
    NSMutableURLRequest *cerere2 = [[NSMutableURLRequest alloc] init];
    [cerere2 setURL:[NSURL URLWithString:@"http://thewebcap.com/dev/ios/friend.php"]];
    [cerere2 setHTTPMethod:@"POST"];
    [cerere2 setValue:postLength2 forHTTPHeaderField:@"Content-Length"];
    [cerere2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [cerere2 setHTTPBody:postData2];
    NSURLResponse* response2 = nil;
    NSError* error2=nil;
    NSData *serverReply2 = [NSURLConnection sendSynchronousRequest:cerere2 returningResponse:&response2 error:&error2];
    NSString *replyString2 = [[NSString alloc] initWithBytes:[serverReply2 bytes] length:[serverReply2 length] encoding: NSASCIIStringEncoding];
    NSLog(@"reply string is : %@",replyString2);
        if([replyString2 isEqualToString:@"Request Existent"]){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention!"
                                                            message:@"Friend request already sent!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        
        }
        
    }


- (IBAction)unfriend:(id)sender {
    NSString *post4=[NSString stringWithFormat:@"tip=check&user_ID1=%@&user_ID2=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],[[NSUserDefaults standardUserDefaults] valueForKey:@"useridFriend"]];
    NSLog(@"post string is :%@",post4);
    NSData *postData4 = [post4 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength4 = [NSString stringWithFormat:@"%d", [postData4 length]];
    
    NSMutableURLRequest *cerere4 = [[NSMutableURLRequest alloc] init];
    [cerere4 setURL:[NSURL URLWithString:@"http://thewebcap.com/dev/ios/friend.php"]];
    [cerere4 setHTTPMethod:@"POST"];
    [cerere4 setValue:postLength4 forHTTPHeaderField:@"Content-Length"];
    [cerere4 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [cerere4 setHTTPBody:postData4];
    NSURLResponse* response4 = nil;
    NSError* error4=nil;
    NSData *serverReply4 = [NSURLConnection sendSynchronousRequest:cerere4 returningResponse:&response4 error:&error4];
    NSString *replyString4 = [[NSString alloc] initWithBytes:[serverReply4 bytes] length:[serverReply4 length] encoding: NSASCIIStringEncoding];
    NSLog(@"reply string is : %@",replyString4);
    
    NSString *post2=[NSString stringWithFormat:@"tip=delete&ID=%@", replyString4];
    NSLog(@"post string is :%@",post2);
    NSData *postData2 = [post2 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength2 = [NSString stringWithFormat:@"%d", [postData2 length]];
    
    NSMutableURLRequest *cerere2 = [[NSMutableURLRequest alloc] init];
    [cerere2 setURL:[NSURL URLWithString:@"http://thewebcap.com/dev/ios/friend.php"]];
    [cerere2 setHTTPMethod:@"POST"];
    [cerere2 setValue:postLength2 forHTTPHeaderField:@"Content-Length"];
    [cerere2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [cerere2 setHTTPBody:postData2];
    NSURLResponse* response2 = nil;
    NSError* error2=nil;
    NSData *serverReply2 = [NSURLConnection sendSynchronousRequest:cerere2 returningResponse:&response2 error:&error2];
    NSString *replyString2 = [[NSString alloc] initWithBytes:[serverReply2 bytes] length:[serverReply2 length] encoding: NSASCIIStringEncoding];
    NSLog(@"reply string is : %@",replyString2);
    addFriendButton.hidden = FALSE;
    unfriendButton.hidden = TRUE;
}
- (void)viewDidUnload {
    [self setUnfriendButton:nil];
    [self setToMainMenu:nil];
    [super viewDidUnload];
}
- (IBAction)toMainMenu:(id)sender {
    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
    [self.navigationController pushViewController: myController animated:YES];
}
@end
