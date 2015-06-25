//
//  YakViewController.m
//  AFourYearOldsYikYak
//
//  Created by Brexton Pham on 6/20/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import "YakViewController.h"

@interface YakViewController ()

@end

@implementation YakViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.allUsersObjectIds = [[NSMutableArray alloc] init]; //initializing mutable array to add objectIds
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    PFQuery *query = [PFUser query]; //queries all users by default
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else {
            self.allUsers = objects; //obtains all users and adds it to allUsers array
            NSLog(@"%@", self.allUsers);
            for (PFUser *user in self.allUsers) { //obtains all objectIds and puts it in separate array
                [self.allUsersObjectIds addObject:user.objectId];
            }
        }
    }];
    
    self.currentUser = [PFUser currentUser];
}

//"cancel" action
- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self.tabBarController setSelectedIndex:0];
}

//"send action"
- (IBAction)sendButton:(id)sender {
    [self uploadYak];
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.tabBarController setSelectedIndex:0];
}

#pragma mark - helper methods

/* Method used to upload yak to back end and save it in Parse*/
- (void)uploadYak {
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    NSString *yak = [self.messageField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //obtain data if yak actually exists
    if ([yak length] != 0) {
        fileData = [yak dataUsingEncoding:NSUTF8StringEncoding];
        fileName = @"yak";
        fileType = @"string";
    }
    
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) { //Alerts if yak doesn't save properly in Parse
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        } else {
            PFObject *message = [PFObject objectWithClassName:@"Messages"];
            [message setObject:file forKey:@"file"]; //Creating classes to save message to in parse
            [message setObject:yak forKey:@"fileContents"];
            [message setObject:fileType forKey:@"fileType"];
            [message setObject:self.allUsersObjectIds forKey:@"recipientIds"];
            [message setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
            [message setObject:[[PFUser currentUser] username] forKey:@"senderName"];
            [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                } else {
                    //IT WORKED.
                }
            }];
        }
    }];
}

@end
