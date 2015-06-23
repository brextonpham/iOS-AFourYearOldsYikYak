//
//  HomeTableViewController.m
//  AFourYearOldsYikYak
//
//  Created by Brexton Pham on 6/19/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import "HomeTableViewController.h"
#import "MessageViewController.h"
#import "MSCellAccessory.h"
#import <CoreLocation/CoreLocation.h>
#import "RWBasicCellTableViewCell.h"

static NSString *const RWBasicCellIdentifier = @"RWBasicCell";

@interface HomeTableViewController ()

@end

@implementation HomeTableViewController

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.f
#define CELL_CONTENT_MARGIN 10.0f

CLLocationManager *locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //initialize locationManager
    locationManager = [[CLLocationManager alloc] init];
    
    //check to see if user is logged in already
    PFUser *currentUser = [PFUser currentUser];
    NSLog(@"%@",[[PFUser currentUser] objectId]);
    
    if (currentUser) {
        NSLog(@"Current user: %@", currentUser.username);
    } else {
        //initial segue is to login screen at launch
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    //refresh screen!
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(retrieveMessages) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO]; //show navigation bar
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"Current user: %@", currentUser.username);
    } else {
        //initial segue is to login screen at launch
        [self retrieveMessages];
    }
    
    //retrieve location of iphone
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    [locationManager requestAlwaysAuthorization];
    float Lat = locationManager.location.coordinate.latitude;
    float Long = locationManager.location.coordinate.longitude;
    NSLog(@"Lat : %f  Long : %f",Lat,Long);
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self basicCellAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForBasicCellAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //leading to detailed message view
    self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showYak" sender:self];
    }

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showLogin"]) { //go to login page
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    } else if ([segue.identifier isEqualToString:@"showYak"]) { // go to yak
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        MessageViewController *messageViewController = (MessageViewController *)segue.destinationViewController;
        messageViewController.message = self.selectedMessage;
        
    }
}

#pragma mark - helper methods

- (void)retrieveMessages {
    /* Retrieving all messages */
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    if ([[PFUser currentUser] objectId] == nil) {
        NSLog(@"No objectID");
    } else {
        NSLog(@"%@",[[PFUser currentUser] objectId]);
        [query whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];
        [query orderByDescending:@"createdAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            } else {
                self.messages = objects;
                [self.tableView reloadData];
                NSLog(@"Retrieved %d messages", [self.messages count]);
            }
        
            if ([self.refreshControl isRefreshing]) { //ENDS REFRESHING
            [self.refreshControl endRefreshing];
            }
        }];
    }
}

//method is called to get an RWBasicCellTableViewCell, dequeue it, and return configured cell
- (RWBasicCellTableViewCell *)basicCellAtIndexPath:(NSIndexPath *)indexPath {
    RWBasicCellTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:RWBasicCellIdentifier forIndexPath:indexPath];
    cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR color:[UIColor colorWithRed:0.373 green:0.855 blue:0.71 alpha:1]];
    [self configureBasicCell:cell atIndexPath:indexPath];
    return cell;
}

//you get a reference to the item at the indexPath, which then gets and sets the titleLabel and subtitleLabel texts on the cell
- (void)configureBasicCell:(RWBasicCellTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    NSString *text = [message objectForKey:@"fileContents"];
    [self setPostForCell:cell item:text];
}

//set labels
- (void)setPostForCell:(RWBasicCellTableViewCell *)cell item:(NSString *)item {
    NSString *post = item;
    
    if (post.length > 200) {
        post = [NSString stringWithFormat:@"%@...", [post substringToIndex:200]];
    }
    
    int len = (int)post.length;

    //checks if string is HTML
    if ((len > 6 && [[post substringToIndex:6] isEqualToString:@"<HTML>"]) || (len > 6 && [[post substringToIndex:6] isEqualToString:@"<html>"])) {
        //uses attributed text to render string in html
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[post dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        cell.postLabel.attributedText = attrStr;
    } else {
        [cell.postLabel setText:post];
    }
    
}

//instantiates a sizingCell using GCD to ensure it's created only once, configures cell
- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static RWBasicCellTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:RWBasicCellIdentifier];
    });
    
    [self configureBasicCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

//request cell to lay out its content by calling setNeedsLayout and layoutIfNeeded, ask auto layout to calculate the systemLayoutSizeFittingSize
- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; //Add 1.0f for the cell separator height
}


@end
