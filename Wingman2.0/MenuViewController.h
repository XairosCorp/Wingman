//
//  MenuViewController.h
//  Wingman2.0
//
//  Created by Zane Sheets on 2/21/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TakePicture.h"
#import "VenuesViewController.h"
#import "ProfileViewController.h"
#import "SettingsViewController.h"
#import "MatchesView.h"

@interface MenuViewController : UIViewController{
    PFObject *user;
    NSString *userID;
}

@property (strong, nonatomic) IBOutlet UIButton *connectionsButton;

@property (strong, nonatomic) IBOutlet UIButton *venuesButton;

@property (strong, nonatomic) IBOutlet UIButton *photoshootButton;

@property (strong, nonatomic) IBOutlet UIButton *profileButton;

@property (strong, nonatomic) IBOutlet UIButton *settingsButton;

@property (strong, nonatomic) IBOutlet UIButton *logoutButton;

- (void)setUser:(PFObject *)object;

- (IBAction)handleGoTakePicture:(id)sender;

- (IBAction)handleGoToVenues:(id)sender;

- (IBAction)handleGoToSettings:(id)sender;

- (IBAction)handleGoToConnections:(id)sender;

- (IBAction)handleGoToProfile:(id)sender;



@end
