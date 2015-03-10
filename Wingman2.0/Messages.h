//
//  Messages.h
//  Wingman2.0
//
//  Created by Zane Sheets on 2/28/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ProfileViewController.h"

@interface Messages : UIViewController{
    PFObject *user;
    PFObject *match;
    NSUInteger numberOfMessages;
}


@property (strong, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) IBOutlet UITextView *text1View;

@property (strong, nonatomic) IBOutlet UITextView *text2View;

@property (strong, nonatomic) IBOutlet UITextView *text3View;

@property (strong, nonatomic) IBOutlet UITextView *text4View;

@property (strong, nonatomic) IBOutlet UITextView *currentTextView;

@property (strong, nonatomic) IBOutlet UIButton *sendButton;

- (void)setUser:(PFObject *)object andMatch:(PFObject *)matchObject;

- (IBAction)handleSend:(id)sender;

- (IBAction)handleBack:(id)sender;




@end
