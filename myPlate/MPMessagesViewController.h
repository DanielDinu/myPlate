//
//  MPMessagesViewController.h
//  myPlate
//
//  Created by Daniel Dinu on 2/18/13.
//  Copyright (c) 2013 Daniel Dinu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "chatCell.h"

@interface MPMessagesViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource>
{
    UITextField *textMessage;
    IBOutlet UITableView *tableView;
    
   
}
@property (strong, nonatomic) IBOutlet UITextField *textMessage;
@property (retain, nonatomic) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *chatData;

-(void) registerForKeyboardNotifications;
-(void) freeKeyboardNotifications;
-(void) keyboardWasShown:(NSNotification*)aNotification;

@end
