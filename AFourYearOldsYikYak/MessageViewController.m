//
//  MessageViewController.m
//  AFourYearOldsYikYak
//
//  Created by Brexton Pham on 6/20/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.yakLabel.text = [self.message objectForKey:@"fileContents"]; //display yak in detail
    
}

@end
