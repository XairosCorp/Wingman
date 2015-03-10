//
//  SignInViewController.h
//  Wingman2.0
//
//  Created by Zane Sheets on 2/25/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MenuViewController.h"

@interface SignInViewController : UIViewController{
    PFObject *user;
}

@property (strong, nonatomic) IBOutlet UITextField *emailField;

@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@property (strong, nonatomic) IBOutlet UIButton *signInButton;


- (IBAction)handleSignIn:(id)sender;





@end
