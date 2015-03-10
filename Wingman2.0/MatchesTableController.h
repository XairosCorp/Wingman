//
//  MatchesTableController.h
//  Wingman2.0
//
//  Created by Zane Sheets on 2/27/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>

@interface MatchesTableController : PFQueryTableViewController{
    PFObject *user;
    NSArray *matchesArray;
    UIImage *im;
    NSString *name;
}

@end
