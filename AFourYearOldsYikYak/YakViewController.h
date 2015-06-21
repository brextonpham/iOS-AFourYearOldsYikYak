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

@property (nonatomic, strong) NSArray *allUsers;
@property (weak, nonatomic) IBOutlet UITextView *messageField;
@property (nonatomic, strong) PFUser *currentUser; //MIGHT NEED THIS
@property (nonatomic, strong) NSMutableArray *allUsersObjectIds;

- (IBAction)cancelButton:(id)sender;
- (IBAction)sendButton:(id)sender;

- (void)uploadYak;

@end
