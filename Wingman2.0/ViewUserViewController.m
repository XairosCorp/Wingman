//
//  ViewUserViewController.m
//  Wingman2.0
//
//  Created by Zane Sheets on 2/21/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import "ViewUserViewController.h"

@interface ViewUserViewController ()

@end

@implementation ViewUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view bringSubviewToFront:self.userNameLabel];
    [self.view bringSubviewToFront:self.yesButton];
    [self.view bringSubviewToFront:self.noButton];
    [self.view bringSubviewToFront:self.userImageView];
    
    [self.userImageView setImage:picture];
    [self.userNameLabel setText:[user objectForKey:@"name"]];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)passUser:(PFObject *)the_user other_user:(PFObject *)user2 aVenue:(PFObject *)the_venue userImage:(UIImage *)pic{
    user = the_user;
    viewedUser = user2;
    venue = the_venue;
    picture = pic;
}

- (IBAction)handleYes:(id)sender {
    PFRelation *relation = [user relationForKey:@"matches"];
    [relation addObject:viewedUser];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error){
            NSLog(@"Save successful");
        }
        else {
            NSLog(@"Error");
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
    PeopleInVenue *newView = (PeopleInVenue *)self.presentingViewController;
    [newView passUser:user aVenue:venue];
}

- (IBAction)handleNo:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    PeopleInVenue *newView = (PeopleInVenue *)self.presentingViewController;
    [newView passUser:user aVenue:venue];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    /*if ([segue.identifier isEqualToString:@"goBackToVenueSegue"]){
        PeopleInVenue *newView = segue.destinationViewController;
        [newView passUser:user aVenue:venue];
    }*/
}


@end
