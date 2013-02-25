//
//  MPMessageBoxViewController.h
//  myPlate
//
//  Created by Daniel Dinu on 2/6/13.
//  Copyright (c) 2013 Daniel Dinu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPMessageBoxViewController : UIViewController<UISearchBarDelegate , UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *mySearchBar;
@property (nonatomic , strong) NSMutableArray * initialNames;
@property (nonatomic , strong) NSMutableArray * filteredNames;
@property BOOL isFiltered;
@end
