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
    
    NSString *post = [self.message objectForKey:@"fileContents"];
    int len = (int)post.length;

    //checks if string is HTML
    if ((len > 6 && [[post substringToIndex:6] isEqualToString:@"<HTML>"]) || (len > 6 && [[post substringToIndex:6] isEqualToString:@"<html>"])) {
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[post dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.yakLabel.attributedText = attrStr; //uses attributed text to set text to rendered HTML
    } else {
        self.yakLabel.text = [self.message objectForKey:@"fileContents"]; //display normal text
    }
}

@end
