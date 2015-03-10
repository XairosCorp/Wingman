//
//  SettingsViewController.h
//  Wingman2.0
//
//  Created by Zane Sheets on 2/24/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MenuViewController.h"

@interface SettingsViewController : UIViewController {
    PFObject *user;
}


@property (strong, nonatomic) IBOutlet UIImageView *profilePictureView;

@property (strong, nonatomic) IBOutlet UITextField *nameField;

@property (strong, nonatomic) IBOutlet UITextField *cityField;

@property (strong, nonatomic) IBOutlet UILabel *emailLabel;


@property (strong, nonatomic) IBOutlet UISwitch *girlsSwitch;

@property (strong, nonatomic) IBOutlet UISwitch *guysSwitch;

@property (strong, nonatomic) IBOutlet UIButton *menuButton;

@property (strong, nonatomic) IBOutlet UIButton *doneButton;

- (IBAction)handleDone:(id)sender;

- (IBAction)handleMenu:(id)sender;



- (void)setUser:(PFObject *)object;

@end
