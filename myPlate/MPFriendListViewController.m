//
//  MPFriendListViewController.m
//  myPlate
//
//  Created by Daniel Dinu on 1/30/13.
//  Copyright (c) 2013 Daniel Dinu. All rights reserved.
//

#import "MPFriendListViewController.h"
#import "MPFriendViewViewController.h"

@interface MPFriendListViewController ()
{NSArray *foo;}
@end

@implementation MPFriendListViewController
@synthesize tableView,mySearchBar,isFiltered,initialNames,filteredNames;
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
    if(isFiltered == YES)
    {
        return filteredNames.count;
    }
    else
    {
        return [initialNames count];
        
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    
    if(isFiltered == YES)
    {
        cell.textLabel.text = [filteredNames objectAtIndex:indexPath.row];
    }
    else
    {
        cell.textLabel.text = [initialNames objectAtIndex:indexPath.row];
        
    }
    
    return cell;
    
}

NSString *temp;
NSArray *nume_prieteni;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    NSString *linie2 = [foo objectAtIndex:indexPath.row];
    NSArray *linie = [linie2 componentsSeparatedByString:@"~;~"];
    NSString *post2=[NSString stringWithFormat:@"search=id&ID=%@",[linie objectAtIndex:0]];
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

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    MPFriendViewViewController *mpf = [storyboard instantiateViewControllerWithIdentifier:@"FriendView"];
    [self.navigationController pushViewController:mpf animated:YES];
}
//////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////
NSMutableArray *cdy1;
- (void)viewDidLoad
{
    initialNames = [[NSMutableArray alloc]init];
    [self setTitle:@"Friend list"];
    
    NSString *post3=[NSString stringWithFormat:@"ID=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]];
    //NSLog(@"post string is :%@",post3);
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
    //NSLog(@"reply string is : %@",replyString3);
    
   if(replyString3 == (id)[NSNull null] || replyString3.length == 0)
   {NSLog(@"niciun prieten");}
   else{
    
    prieteni_user = [replyString3 componentsSeparatedByString:@"*~*"];
    NSMutableArray* tempArray = [NSMutableArray array];
    [prieteni_user enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) { [tempArray addObject:obj]; }];
    foo = [tempArray copy];int i;
    cdy1 = [[NSMutableArray alloc]init];
    for(i=0;i<[foo count];i++){
        NSString *linie2 = [foo objectAtIndex:i];
        NSArray *linie = [linie2 componentsSeparatedByString:@"~;~"];
        [cdy1 addObject:[linie objectAtIndex:1]];}
       initialNames = [cdy1 copy];}
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length == 0)
    {
        //Set isFiltered
        isFiltered = NO;
    }
    else
    {
        isFiltered = YES;
        filteredNames = [[NSMutableArray alloc]init];
        
        for (NSString * name in initialNames) {
            NSRange nameRange = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound)
            {
                [filteredNames addObject:name];
            }
        }
    }
    [tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMySearchBar:nil];
    [super viewDidUnload];
}
@end
