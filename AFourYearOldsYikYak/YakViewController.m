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
    // Do any additional setup after loading the view.
    self.allUsersObjectIds = [[NSMutableArray alloc] init];
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
            self.allUsers = objects;
            NSLog(@"%@", self.allUsers);
            for (PFUser *user in self.allUsers) {
                [self.allUsersObjectIds addObject:user.objectId];
            }
        }
    }];
    
    self.currentUser = [PFUser currentUser];
}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)sendButton:(id)sender {
    [self uploadYak];
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.tabBarController setSelectedIndex:0];
}

- (void)uploadYak {
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    NSString *yak = [self.messageField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([yak length] != 0) {
        fileData = [yak dataUsingEncoding:NSUTF8StringEncoding];
        fileName = @"yak";
        fileType = @"string";
    }
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        } else {
            PFObject *message = [PFObject objectWithClassName:@"Messages"];
            [message setObject:file forKey:@"file"];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
