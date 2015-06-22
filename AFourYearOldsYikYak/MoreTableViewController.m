//
//  MoreTableViewController.m
//  AFourYearOldsYikYak
//
//  Created by Brexton Pham on 6/19/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import "MoreTableViewController.h"
#import <Parse/Parse.h>

@interface MoreTableViewController ()

@end

@implementation MoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//method hides tabs at login screen
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showLogin2"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}

- (IBAction)logout:(id)sender {
    [PFUser logOut]; //parse logout call
    [self performSegueWithIdentifier:@"showLogin2" sender:self]; //take user back to login screen
}

@end
