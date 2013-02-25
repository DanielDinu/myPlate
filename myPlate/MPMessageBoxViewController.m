//
//  MPMessageBoxViewController.m
//  myPlate
//
//  Created by Daniel Dinu on 2/6/13.
//  Copyright (c) 2013 Daniel Dinu. All rights reserved.
//

#import "MPMessageBoxViewController.h"
#import "MPMessagesViewController.h"
@interface MPMessageBoxViewController ()
{NSArray *foo;}
@end

@implementation MPMessageBoxViewController
@synthesize tableView;
@synthesize mySearchBar;
@synthesize initialNames,filteredNames,isFiltered;
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

NSString *temp;
NSArray *nume_prieteni;
int n=0;bool first_time=true;
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
    //NSLog(@"count prieteni: %lu",(unsigned long)[prieteni_user count]);
    
   //NSLog(@"prieteni useri: %@",prieteni_user);
    //cell.textLabel.text = [filteredCandyArray objectAtIndex:indexPath.row];
/*
    NSString *linie2 = [foo objectAtIndex:indexPath.row];
    NSArray *linie = [linie2 componentsSeparatedByString:@"~;~"];
    cell.textLabel.text = [linie objectAtIndex:1];
    //NSLog(@"Linie: %@",linie2);
    // cell.textLabel.text = [linie objectAtIndex:0];*/
    
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
    
    [[NSUserDefaults standardUserDefaults] setObject:[linie objectAtIndex:1] forKey:@"numePrieten"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"set: %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"numePrieten"]);
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    MPMessagesViewController *mpm = [storyboard instantiateViewControllerWithIdentifier:@"Messages"];
    [self.navigationController pushViewController:mpm animated:YES];

}
NSMutableArray *cdy1;
- (void)viewDidLoad
{
    initialNames = [[NSMutableArray alloc]init];
    [self setTitle:@"Messages"];

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
    prieteni_user = [replyString3 componentsSeparatedByString:@"*~*"];
    NSMutableArray* tempArray = [NSMutableArray array];
    [prieteni_user enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) { [tempArray addObject:obj]; }];
    foo = [tempArray copy];int i;
    cdy1 = [[NSMutableArray alloc]init];
    for(i=0;i<[foo count];i++){
    NSString *linie2 = [foo objectAtIndex:i];
        NSArray *linie = [linie2 componentsSeparatedByString:@"~;~"];
        [cdy1 addObject:[linie objectAtIndex:1]];}
    initialNames = [cdy1 copy];
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

#pragma mark - 
#pragma mark UISearchBarDelegate Methods

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
