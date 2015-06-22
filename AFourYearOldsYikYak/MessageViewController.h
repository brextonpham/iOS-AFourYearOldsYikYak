//
//  MessageViewController.h
//  AFourYearOldsYikYak
//
//  Created by Brexton Pham on 6/20/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MessageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *yakLabel; //label displaying yak
@property (nonatomic, strong) PFObject *message; //passing in yak data

@end
