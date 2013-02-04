//
//  MPFriendListViewController.m
//  myPlate
//
//  Created by Daniel Dinu on 1/30/13.
//  Copyright (c) 2013 Daniel Dinu. All rights reserved.
//

#import "MPFriendListViewController.h"

@interface MPFriendListViewController ()

@end

@implementation MPFriendListViewController
@synthesize tableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
NSArray *prieteni_user;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //CATI PRIETENI
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
   prieteni_user = [replyString3 componentsSeparatedByString:@"*~*"];
   
    

    return [prieteni_user count];
    
    
}
NSString *temp;
NSArray *nume_prieteni;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
int i=0;
//////////////////////////////////////////////////////////////////////////////////////
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
       
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSLog(@"count prieteni: %lu",(unsigned long)[prieteni_user count]);
    
       //NSLog(@"prieteni useri: %@",prieteni_user);
       temp = [prieteni_user objectAtIndex:i];
    nume_prieteni = [temp componentsSeparatedByString:@"~;~"];

    NSLog(@"temp: %@",temp);
    cell.textLabel.text = [nume_prieteni objectAtIndex:1];
    i++;
        return cell;

}
////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
       [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
