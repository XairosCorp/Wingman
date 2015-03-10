//
//  PeopleInVenue.h
//  Wingman2.0
//
//  Created by Zane Sheets on 2/27/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "ViewUserViewController.h"
#import "VenuesViewController.h"

@interface PeopleInVenue : PFQueryTableViewController{
    UIImage *im;
    NSString *name;
    NSArray *ar;
    PFObject *user;
    PFObject *venue;
}

@property (strong, nonatomic) IBOutlet UIButton *backButton;

- (IBAction)handleBack:(id)sender;

-(void)passUser:(PFObject *)the_user aVenue:(PFObject *)the_venue;

@end
