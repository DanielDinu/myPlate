//
//  MPFriendListViewController.h
//  myPlate
//
//  Created by Daniel Dinu on 1/30/13.
//  Copyright (c) 2013 Daniel Dinu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPFriendListViewController : UIViewController<UISearchBarDelegate, UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray * initialNames;
@property (nonatomic , strong) NSMutableArray * filteredNames;
@property BOOL isFiltered;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;

@end
