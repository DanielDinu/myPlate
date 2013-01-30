//
//  MPFriendListViewController.h
//  myPlate
//
//  Created by Daniel Dinu on 1/30/13.
//  Copyright (c) 2013 Daniel Dinu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPFriendListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
