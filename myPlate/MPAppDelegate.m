//
//  MPAppDelegate.m
//  myPlate
//
//  Created by Daniel Dinu on 12/11/12.
//  Copyright (c) 2012 Daniel Dinu. All rights reserved.
//
#define AlertViewOne 1
#define AlertViewTwo 2
#import "MPAppDelegate.h"
#import "Reachability.h"
#import "MPLoginViewController.h"
#import "MPFindScanViewController.h"
#import "MPMessagesViewController.h"
#import "MPWhoAddedYouViewController.h"
@implementation MPAppDelegate

@synthesize devTtrimis;


-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //Your Stuff
}

////////////////////////////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = 100.0f; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    locationManager.headingFilter = 5;
    [locationManager startUpdatingLocation];
    
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"TermsAccepted"]!=YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"TermsAccepted"];
        
        
    }
    
  	[application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    // Let the device know we want to receive push notifications
    return YES;
}


////////////////////////////////////////////////////////////////////////////////
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        //cancel clicked ...do your action
    }else if (buttonIndex == 1){
        if(alertView.tag == AlertViewOne)
        {
        NSLog(@"se lanseaza mpwhoadded");//reset clicked
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
                  MPWhoAddedYouViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"whoAddedYou"];
            
            UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
            [navController.visibleViewController.navigationController pushViewController:myController animated:YES];          
        }
    else if(alertView.tag == AlertViewTwo
            ) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        
        MPMessagesViewController *mpm = [storyboard instantiateViewControllerWithIdentifier:@"Messages"];
        _window.rootViewController = mpm;
        
    }}
}

////////////////////////////////////////////////////////////////////////////////

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{ 
    
	NSLog(@"My token is: %@", deviceToken);
    devTtrimis = deviceToken;
}

////////////////////////////////////////////////////////////////////////////////
NSString *verifLogat;
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{NSLog(@"primit");
    verifLogat = [[NSUserDefaults standardUserDefaults] valueForKey:@"logat"];
    if([verifLogat isEqualToString:@"yes"]){
        for (id key in userInfo) {
            //NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
            
            
            NSDictionary *aps = [NSDictionary dictionaryWithDictionary:(NSDictionary *) [userInfo objectForKey:key] ];
            NSString *tip = [aps objectForKey:@"tip"];
            
            //NSLog(@"%@",tip);
            if ([tip isEqualToString:@"friend"]) {
                NSLog(@"FRIEND!");
                id mesaj = [aps objectForKey:@"alert"];
                NSString *id_who_added = [aps objectForKey:@"id"];
                NSString *id_prietenie = [aps objectForKey:@"id_friend"];
                [[NSUserDefaults standardUserDefaults] setObject:id_who_added forKey:@"id_who_added_you"];
                [[NSUserDefaults standardUserDefaults] setObject:id_prietenie forKey:@"id_prietenie"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
             //   NSLog(@"id = %@",id_who_added);
              //  NSLog(@"id prietenie = %@",id_prietenie);
                if([mesaj isKindOfClass:[NSString class]]) {
                    UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:@"Friend Request! "
                                                                        message:mesaj  delegate:self
                                                              cancelButtonTitle:@"Close"
                                                              otherButtonTitles:@"Show", nil];
                    alertView1.tag = AlertViewOne;
                    [alertView1 show];
                }}
                
/*------- */ else if([tip isEqualToString:@"message"]){
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mesajNotif"object:userInfo];
                    id mesaj = [aps objectForKey:@"alert"];
                    NSString *id_who_added = [aps objectForKey:@"id"];
                    NSString *id_prietenie = [aps objectForKey:@"id_friend"];
                    [[NSUserDefaults standardUserDefaults] setObject:id_who_added forKey:@"id_who_added_you"];
                    [[NSUserDefaults standardUserDefaults] setObject:id_prietenie forKey:@"id_prietenie"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                //    NSLog(@"id = %@",id_who_added);
                    if([mesaj isKindOfClass:[NSString class]]) {

                                                
                      
                        NSString *post2=[NSString stringWithFormat:@"search=id&ID=%@",id_who_added];
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
                        NSString *numePrieten = [prieteni_user objectAtIndex:0];
                        
                            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"inMessages"] isEqualToString:@"false"]) {
                                
                            
                        UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"Message !"
                                                                            message:[NSString stringWithFormat:@"%@: %@", numePrieten, mesaj]  delegate:self
                                                                  cancelButtonTitle:@"Close"
                                                                  otherButtonTitles:@"Show", nil];
                                alertView2.tag = AlertViewTwo;

                        [alertView2 show];
 
                            }}}
     
            
            }}}

////////////////////////////////////////////////////////////////////////////////


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

////////////////////////////////////////////////////////////////////////////////

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
