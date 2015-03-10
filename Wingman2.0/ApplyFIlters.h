//
//  ApplyFIlters.h
//  Wingman2.0
//
//  Created by Zane Sheets on 2/21/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TakePicture.h"
#import "MenuViewController.h"

@interface ApplyFIlters : UIViewController{
    PFObject *user;
    UIImage *picture;
    UIImage *filteredPicture;
}

@property (strong, nonatomic) IBOutlet UIImageView *normalImageView;

@property (strong, nonatomic) IBOutlet UIImageView *marsImageView;

@property (strong, nonatomic) IBOutlet UIImageView *bwImageView;

@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;

@property (strong, nonatomic) IBOutlet UIButton *tryAgainButton;

@property (strong, nonatomic) IBOutlet UIButton *swagButton;

@property (strong, nonatomic) IBOutlet UIButton *normalButton;

@property (strong, nonatomic) IBOutlet UIButton *marsButton;

@property (strong, nonatomic) IBOutlet UIButton *bwButton;


- (IBAction)handleNormal:(id)sender;

- (IBAction)handleMars:(id)sender;

- (IBAction)handleBW:(id)sender;

- (IBAction)handleTryAgain:(id)sender;

- (IBAction)handleConfirm:(id)sender;

-(void)setUser:(PFObject *)object image:(UIImage *)pictureImage;


@end
