//
//  ProfileViewController.h
//  Wingman2.0
//
//  Created by Zane Sheets on 2/21/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Messages.h"
#import "MatchesView.h"

@interface ProfileViewController : UIViewController{
    PFObject *user;
    PFObject *match;
}


@property (strong, nonatomic) IBOutlet UIButton *messagesButton;

@property (strong, nonatomic) IBOutlet UIButton *menuButton;

@property (strong, nonatomic) IBOutlet UILabel *nameField;

@property (strong, nonatomic) IBOutlet UILabel *cityField;

@property (strong, nonatomic) IBOutlet UILabel *emailField;

@property (strong, nonatomic) IBOutlet UILabel *girlsLabel;

@property (strong, nonatomic) IBOutlet UILabel *guysLabel;

@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImageView;

- (void)setUser:(PFObject *)object andMatch:(PFObject *)matchObject;

- (IBAction)handleMessagesClicked:(id)sender;

- (IBAction)handleBackClicked:(id)sender;

@end
