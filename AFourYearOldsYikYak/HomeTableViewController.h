//
//  HomeTableViewController.h
//  AFourYearOldsYikYak
//
//  Created by Brexton Pham on 6/19/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface HomeTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *allUsers;
@property (nonatomic, strong) PFObject *selectedMessage;
@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end
