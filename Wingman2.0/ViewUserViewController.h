//
//  ViewUserViewController.h
//  Wingman2.0
//
//  Created by Zane Sheets on 2/21/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PeopleInVenue.h"

@interface ViewUserViewController : UIViewController{
    PFObject *user;
    PFObject *viewedUser;
    PFObject *venue;
    UIImage *picture;
}

@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;

@property (strong, nonatomic) IBOutlet UIButton *yesButton;

@property (strong, nonatomic) IBOutlet UIButton *noButton;

@property (strong, nonatomic) IBOutlet UIImageView *userImageView;


-(void)passUser:(PFObject *)the_user other_user:(PFObject *)user2 aVenue:(PFObject *)the_venue userImage:(UIImage *)pic;

- (IBAction)handleYes:(id)sender;

- (IBAction)handleNo:(id)sender;



@end
