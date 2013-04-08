//
//  MPWaitingFriendRequestsViewController.h
//  myPlate
//
//  Created by Daniel Dinu on 4/2/13.
//  Copyright (c) 2013 Daniel Dinu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPWaitingFriendRequestsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
- (IBAction)toMainMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
