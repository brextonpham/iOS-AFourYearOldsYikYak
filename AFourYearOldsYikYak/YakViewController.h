//
//  YakViewController.h
//  AFourYearOldsYikYak
//
//  Created by Brexton Pham on 6/20/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface YakViewController : UIViewController

@property (nonatomic, strong) NSArray *allUsers; //all users
@property (weak, nonatomic) IBOutlet UITextView *messageField; //text box used to yak in
@property (nonatomic, strong) PFUser *currentUser; //current user
@property (nonatomic, strong) NSMutableArray *allUsersObjectIds; //objectIds from all users

- (IBAction)cancelButton:(id)sender;
- (IBAction)sendButton:(id)sender;

- (void)uploadYak; //"sending the yak" to back-end

@end
