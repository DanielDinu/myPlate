//
//  MPAppDelegate.m
//  myPlate
//
//  Created by Daniel Dinu on 12/11/12.
//  Copyright (c) 2012 Daniel Dinu. All rights reserved.
//

#import "MPAppDelegate.h"
#import "Reachability.h"
#import "MPLoginViewController.h"
#import "MPFindScanViewController.h"
@implementation MPAppDelegate
@synthesize devTtrimis;

////////////////////////////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
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
        
        NSLog(@"se lanseaza mpwhoadded");//reset clicked
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
      
        MPFindScanViewController *mpwho = [storyboard instantiateViewControllerWithIdentifier:@"whoAddedYou"];
        _window.rootViewController = mpwho;}
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
{
    
    verifLogat = [[NSUserDefaults standardUserDefaults] valueForKey:@"logat"];
    if([verifLogat isEqualToString:@"yes"]){
        for (id key in userInfo) {
            NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
            
            
            NSDictionary *aps = [NSDictionary dictionaryWithDictionary:(NSDictionary *) [userInfo objectForKey:key] ];
            NSString *tip = [aps objectForKey:@"tip"];
            
            NSLog(@"%@",tip);
            if ([tip isEqualToString:@"friend"]) {
                NSLog(@"FRIEND!");
                id mesaj = [aps objectForKey:@"alert"];
                NSString *id_who_added = [aps objectForKey:@"id"];
                NSString *id_prietenie = [aps objectForKey:@"id_friend"];
                [[NSUserDefaults standardUserDefaults] setObject:id_who_added forKey:@"id_who_added_you"];
                [[NSUserDefaults standardUserDefaults] setObject:id_prietenie forKey:@"id_prietenie"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSLog(@"id = %@",id_who_added);
                NSLog(@"id prietenie = %@",id_prietenie);
                if([mesaj isKindOfClass:[NSString class]]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Friend Request! "
                                                                        message:mesaj  delegate:self
                                                              cancelButtonTitle:@"Close"
                                                              otherButtonTitles:@"Show", nil];
                    [alertView show];
                }}
                
/*------- */ else if([tip isEqualToString:@"message"]){
                    NSLog(@"MESSAGE!");
                    id mesaj = [aps objectForKey:@"alert"];
                    NSString *id_who_added = [aps objectForKey:@"id"];
                    NSString *id_prietenie = [aps objectForKey:@"id_friend"];
                    [[NSUserDefaults standardUserDefaults] setObject:id_who_added forKey:@"id_who_added_you"];
                    [[NSUserDefaults standardUserDefaults] setObject:id_prietenie forKey:@"id_prietenie"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    NSLog(@"id = %@",id_who_added);
                    NSLog(@"id prietenie = %@",id_prietenie);
                    if([mesaj isKindOfClass:[NSString class]]) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message !"
                                                                            message:mesaj  delegate:self
                                                                  cancelButtonTitle:@"Close"
                                                                  otherButtonTitles:@"Show", nil];
                        [alertView show];
 
                    }}
     
            
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
