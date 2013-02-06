//
//  MPMessageBoxViewController.m
//  myPlate
//
//  Created by Daniel Dinu on 2/6/13.
//  Copyright (c) 2013 Daniel Dinu. All rights reserved.
//

#import "MPMessageBoxViewController.h"

@interface MPMessageBoxViewController ()

@end

@implementation MPMessageBoxViewController
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
int n=0;bool first_time=true;
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(first_time){n=0;}
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSLog(@"count prieteni: %lu",(unsigned long)[prieteni_user count]);
    
    NSLog(@"prieteni useri: %@",prieteni_user);
    temp = [prieteni_user objectAtIndex:n];
    nume_prieteni = [temp componentsSeparatedByString:@"~;~"];
    
    NSLog(@"temp: %@",temp);
    cell.textLabel.text = [nume_prieteni objectAtIndex:1];
    n++; if(n==[prieteni_user count]){first_time =true;}else{first_time=false;}
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    NSString *post2=[NSString stringWithFormat:@"search=id&ID=%@",[nume_prieteni objectAtIndex:0]];
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
     NSArray *prieteni_user = [replyString2 componentsSeparatedByString:@"*~*"];
    [[NSUserDefaults standardUserDefaults] setObject:[prieteni_user objectAtIndex:4] forKey:@"useridFriend"];
           UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendView"];
        [self.navigationController pushViewController: myController animated:YES];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

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
