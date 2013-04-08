//
//  MPWaitingFriendRequestsViewController.m
//  myPlate
//
//  Created by Daniel Dinu on 4/2/13.
//  Copyright (c) 2013 Daniel Dinu. All rights reserved.
//

#import "MPWaitingFriendRequestsViewController.h"
#import "MPMainMenuViewController.h"
#import "MPWhoAddedYouViewController.h"

@interface MPWaitingFriendRequestsViewController ()
{
    NSMutableArray *idPrieteni;
    NSArray *lista;
}
@end

@implementation MPWaitingFriendRequestsViewController
@synthesize tableView;
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
    [[self navigationController] setTitle:@"Pending friend requests"];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Main Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(toMainMenu:)];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = item;    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toMainMenu:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    MPMainMenuViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
    
    UINavigationController *navController = (UINavigationController *)self.navigationController;
    [navController.visibleViewController.navigationController pushViewController:myController animated:YES];

    
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    if(replyString2 == (id)[NSNull null] || replyString2.length == 0){
        NSLog(@"nicio cerere");}
    else{
    idPrieteni = [[NSMutableArray alloc]init];
    lista = [replyString2 componentsSeparatedByString:@"*~*"];
    for (int i=0; i<[lista count]; i++) {
        NSString *itemLista = [lista objectAtIndex:i];
        NSArray *itemListaSpart = [itemLista componentsSeparatedByString:@"~;~"];
        [idPrieteni addObject:[itemListaSpart objectAtIndex:1]];
        NSLog(@"%@",idPrieteni);
        

    }return [idPrieteni count];}
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
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
    if(replyString2 == (id)[NSNull null] || replyString2.length == 0){
        NSLog(@"nicio cerere");
    }
    else{
    idPrieteni = [[NSMutableArray alloc]init];
    lista = [replyString2 componentsSeparatedByString:@"*~*"];
    
        NSString *itemLista = [lista objectAtIndex:indexPath.row];
        NSArray *itemListaSpart = [itemLista componentsSeparatedByString:@"~;~"];
   
    
        cell.textLabel.text = [itemListaSpart objectAtIndex:2];}
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *linie2 = [lista objectAtIndex:indexPath.row];
    NSArray *linie = [linie2 componentsSeparatedByString:@"~;~"];
    NSLog(@"%@",[linie objectAtIndex:1]);
    [[NSUserDefaults standardUserDefaults] setObject:[linie objectAtIndex:1] forKey:@"id_who_added_you"];
    [[NSUserDefaults standardUserDefaults] setObject:[linie objectAtIndex:0] forKey:@"id_prietenie"];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    MPWhoAddedYouViewController *mpf = [storyboard instantiateViewControllerWithIdentifier:@"whoAddedYou"];
    [self.navigationController pushViewController:mpf animated:YES];
}
@end
