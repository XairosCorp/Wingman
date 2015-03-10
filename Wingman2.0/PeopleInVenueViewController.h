//
//  PeopleInVenueViewController.h
//  Wingman2.0
//
//  Created by Zane Sheets on 2/21/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "VenuesViewController.h"

@interface PeopleInVenueViewController : UIViewController{
    PFObject *user;
    PFObject *venue;
}

@property (strong, nonatomic) IBOutlet UIButton *matchesButton;

@property (strong, nonatomic) IBOutlet UIButton *back_button;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;


- (IBAction)handleBack:(id)sender;

- (void)setUser:(PFObject *)object the_venue:(PFObject *)ven;





@end
