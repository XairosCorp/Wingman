//
//  MatchesView.h
//  Wingman2.0
//
//  Created by Zane Sheets on 2/28/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ProfileViewController.h"
#import "MenuViewController.h"

@interface MatchesView : UITableViewController{
    NSMutableArray *matchesArray;
    NSArray *confirmedMatchesArray;
    PFObject *user;
    PFObject *matchSelection;
}

@property (strong, nonatomic) IBOutlet UIButton *backButton;

- (IBAction)handleGoBack:(id)sender;

- (void)setUser:(PFObject *)object;

@end
