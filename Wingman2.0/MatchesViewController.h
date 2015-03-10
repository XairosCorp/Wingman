//
//  MatchesViewController.h
//  Wingman2.0
//
//  Created by Zane Sheets on 2/21/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface MatchesViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *menuButton;

@property (strong, nonatomic) IBOutlet UIButton *venueGridButton;

@property (strong, nonatomic) IBOutlet PFQueryTableViewController *matchesTable;








@end
