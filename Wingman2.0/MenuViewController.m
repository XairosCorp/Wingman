//
//  MenuViewController.m
//  Wingman2.0
//
//  Created by Zane Sheets on 2/21/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view bringSubviewToFront:self.connectionsButton];
    [self.view bringSubviewToFront:self.venuesButton];
    [self.view bringSubviewToFront:self.photoshootButton];
    [self.view bringSubviewToFront:self.profileButton];
    [self.view bringSubviewToFront:self.settingsButton];
    [self.view bringSubviewToFront:self.logoutButton];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUser:(PFObject *)object{
    user = object;
    NSLog(@"Menu: %@", [user objectForKey:@"name"]);
}

- (IBAction)handleGoTakePicture:(id)sender {
    [self performSegueWithIdentifier:@"photoShoot" sender:self];
}

- (IBAction)handleGoToVenues:(id)sender {
    [self performSegueWithIdentifier:@"goToVenues" sender:self];
}

- (IBAction)handleGoToSettings:(id)sender {
    [self performSegueWithIdentifier:@"goToEditProfile" sender:self];
}

- (IBAction)handleGoToConnections:(id)sender {
    [self performSegueWithIdentifier:@"connectionsSegue" sender:self];
}

- (IBAction)handleGoToProfile:(id)sender {
    [self performSegueWithIdentifier:@"menuToProfileSegue" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToEditProfile"]){
        SettingsViewController *settings = segue.destinationViewController;
        [settings setUser:user];
    }
    else if ([segue.identifier isEqualToString:@"photoShoot"]){
        TakePicture *takePicView = segue.destinationViewController;
        [takePicView setUser:user];
    }
    else if ([segue.identifier isEqualToString:@"goToVenues"]){
        VenuesViewController *newView = segue.destinationViewController;
        [newView setUser:user];
    }
    else if ([segue.identifier isEqualToString:@"connectionsSegue"]){
        MatchesView *newView = segue.destinationViewController;
        [newView setUser:user];
    }
    else if ([segue.identifier isEqualToString:@"menuToProfileSegue"]){
        ProfileViewController *newView = segue.destinationViewController;
        [newView setUser:user andMatch:user];
    }
    
}


@end
