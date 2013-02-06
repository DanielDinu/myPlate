//
//  MPMessageBoxViewController.h
//  myPlate
//
//  Created by Daniel Dinu on 2/6/13.
//  Copyright (c) 2013 Daniel Dinu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPMessageBoxViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
