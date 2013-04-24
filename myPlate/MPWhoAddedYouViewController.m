//
//  MPWhoAddedYouViewController.m
//  myPlate
//
//  Created by Daniel Dinu on 1/25/13.
//  Copyright (c) 2013 Daniel Dinu. All rights reserved.
//

#import "MPWhoAddedYouViewController.h"
#import "MPMainMenuViewController.h"
#import "MPFriendViewViewController.h"
@interface MPWhoAddedYouViewController ()

@end

@implementation MPWhoAddedYouViewController
@synthesize addFriendButton;
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
    
    NSString *id_who = [[NSUserDefaults standardUserDefaults] valueForKey:@"id_who_added_you"];
    NSString *post2=[NSString stringWithFormat:@"search=id&ID=%@",id_who];
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
    
    NSArray *date_user = [replyString2 componentsSeparatedByString:@"*~*"];
    [[NSUserDefaults standardUserDefaults] setObject:[date_user objectAtIndex:1] forKey:@"ageFriend"];
    [[NSUserDefaults standardUserDefaults] setObject:[date_user objectAtIndex:2] forKey:@"genderFriend"];
    [[NSUserDefaults standardUserDefaults] setObject:[date_user objectAtIndex:3] forKey:@"shortBioFriend"];
    [[NSUserDefaults standardUserDefaults] setObject:[date_user objectAtIndex:0] forKey:@"screenFriend"];
    [[NSUserDefaults standardUserDefaults] setObject:[date_user objectAtIndex:4] forKey:@"useridFriend"];
    [[NSUserDefaults standardUserDefaults] setObject:[date_user objectAtIndex:6] forKey:@"makeFriend"];
    [[NSUserDefaults standardUserDefaults] setObject:[date_user objectAtIndex:7] forKey:@"modelFriend"];
    [[NSUserDefaults standardUserDefaults] setObject:[date_user objectAtIndex:8] forKey:@"engineFriend"];
    [[NSUserDefaults standardUserDefaults] setObject:[date_user objectAtIndex:9] forKey:@"powerFriend"];
    [[NSUserDefaults standardUserDefaults] setObject:[date_user objectAtIndex:10] forKey:@"colorFriend"];
    [[NSUserDefaults standardUserDefaults] setObject:[date_user objectAtIndex:11] forKey:@"modsFriend"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    regNumberLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"regNumberFriend"];
    nameLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"screenFriend"];
    colorLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"colorFriend"];
    makeLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"makeFriend"];
    modelLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"modelFriend"];
    engineLabel.text = [[[NSUserDefaults standardUserDefaults] valueForKey:@"powerFriend"] stringByAppendingString:@" bhp"];
    ageLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"ageFriend"];
    genderLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"genderFriend"];
    shortbioLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"shortBioFriend"];
    NSString *id_path = [date_user objectAtIndex:12];
    NSURL *url = [NSURL URLWithString:id_path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    pozaFriend.image = img;
    self.title = [date_user objectAtIndex:0];
    [super viewDidLoad];
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
    
    /*if(exista)
    {[addFriendButton setTitle:@"Friend" forState:UIControlStateNormal];
        [addFriendButton setEnabled:NO];}*/
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)acceptFriend:(id)sender {
   
    NSString *post2=[NSString stringWithFormat:@"tip=accept&request_ID=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"id_prietenie"]];
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
           
    
    [self performSegueWithIdentifier:@"toMainMenu" sender:self];

}

- (IBAction)rejectFriend:(id)sender {
    NSString *post2=[NSString stringWithFormat:@"tip=delete&ID=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"id_prietenie"]];
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
    
    [self performSegueWithIdentifier:@"toMainMenu" sender:self];

    
}
@end
