//
//  VenuesViewController.h
//  Wingman2.0
//
//  Created by Zane Sheets on 2/21/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AddVenueViewController.h"
#import "PeopleInVenue.h"
#import "MenuViewController.h"

@interface VenuesViewController : UIViewController{
    PFObject *user;
    NSString *userID;
    PFObject *venue1;
    PFObject *venue2;
    PFObject *venue3;
}

@property (strong, nonatomic) IBOutlet UIButton *addVenueButton;

@property (strong, nonatomic) IBOutlet UIButton *menuButton;

@property (strong, nonatomic) IBOutlet UIImageView *venue1ImageView;

@property (strong, nonatomic) IBOutlet UIImageView *venue2ImageView;

@property (strong, nonatomic) IBOutlet UIImageView *venue3ImageView;

@property (strong, nonatomic) IBOutlet UILabel *venue1NameLabel;

@property (strong, nonatomic) IBOutlet UILabel *venue2NameLabel;

@property (strong, nonatomic) IBOutlet UILabel *venue3NameLabel;

@property (strong, nonatomic) IBOutlet UIButton *venue1Button;

@property (strong, nonatomic) IBOutlet UIButton *venue2Button;

@property (strong, nonatomic) IBOutlet UIButton *venue3Button;

- (IBAction)handleAddVenue:(id)sender;

- (IBAction)handleVenue1:(id)sender;

- (IBAction)handleVenue2:(id)sender;

- (IBAction)handleVenue3:(id)sender;

- (IBAction)handleMenuButton:(id)sender;


- (void)setUser:(PFObject *)object;

- (void)loadVenues;

@end
