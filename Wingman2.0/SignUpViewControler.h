//
//  SignUpViewControler.h
//  Wingman2.0
//
//  Created by Zane Sheets on 2/20/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SignUpViewControler : UIViewController


@property (strong, nonatomic) IBOutlet UITextField *nameField;

@property (strong, nonatomic) IBOutlet UITextField *emailField;

@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@property (strong, nonatomic) IBOutlet UITextField *passwordField2;

@property (strong, nonatomic) IBOutlet UIButton *signUpButton;

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (nonatomic, strong) PFObject *user;

- (IBAction)handleSignUp:(id)sender;




@end
