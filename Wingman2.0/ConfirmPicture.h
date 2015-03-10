//
//  ConfirmPicture.h
//  Wingman2.0
//
//  Created by Zane Sheets on 2/21/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ApplyFIlters.h"

@interface ConfirmPicture : UIViewController{
    PFObject *user;
    UIImage *userPicture;
}

@property (strong, nonatomic) IBOutlet UIButton *lookingGoodButton;

@property (strong, nonatomic) IBOutlet UIButton *tryAgainButton;

@property (strong, nonatomic) IBOutlet UIImageView *pictureView;


- (void)setUser:(PFObject *)object image:(UIImage *)picture;

- (IBAction)handleLookingGood:(id)sender;


@end
