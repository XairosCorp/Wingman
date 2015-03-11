//
//  ProfileViewController.m
//  Wingman2.0
//
//  Created by Zane Sheets on 2/21/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import "ProfileViewController.h"


@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view bringSubviewToFront:self.messagesButton];
    [self.view bringSubviewToFront:self.menuButton];
    [self.view bringSubviewToFront:self.guysLabel];
    [self.view bringSubviewToFront:self.girlsLabel];
    
    [self.nameField setText:[match objectForKey:@"name"]];
    [self.cityField setText:[match objectForKey:@"city"]];
    
    PFFile *picFile = [match objectForKey:@"picture"];
    [picFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error){
            [self.profilePictureImageView setImage:[UIImage imageWithData:data]];
        }
    }];
    NSNumber *interestNum = [match objectForKey:@"interestedIn"];
    long int temp = [interestNum integerValue];
    
    if (temp == 1){
        [self.guysLabel setText:@"Yes"];
        [self.girlsLabel setText:@"Yes"];
    }
    else if(temp == 2){
        [self.guysLabel setText:@"No"];
        [self.girlsLabel setText:@"Yes"];
    }
    else if (temp == 3){
        [self.guysLabel setText:@"Yes"];
        [self.girlsLabel setText:@"No"];
    }

    
    
    [self.view bringSubviewToFront:self.nameField];
    [self.view bringSubviewToFront:self.cityField];
//    [self.view bringSubviewToFront:self.emailField];
    [self.view bringSubviewToFront:self.profilePictureImageView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUser:(PFObject *)object andMatch:(PFObject *)matchObject{
    user = object;
    match = matchObject;
}

- (IBAction)handleMessagesClicked:(id)sender {
    if (![[user objectForKey:@"email"] isEqualToString:[match objectForKey:@"email"]]){
        [self performSegueWithIdentifier:@"goToMessagesSegue" sender:self];
    }
}

- (IBAction)handleBackClicked:(id)sender {
    // If this profile does not belong to the user -> Accessed from "MatchesView"
    if (![[user objectForKey:@"email"] isEqualToString:[match objectForKey:@"email"]]){
        [self performSegueWithIdentifier:@"backToMatchesSegue" sender:self];
    }
    else {
        
        // If this profile is the users -> Accessed from "My Profile"
        [self dismissViewControllerAnimated:YES completion:nil];
        
        // Set User in menu (the presenting view), just in case
        MenuViewController *newView = (MenuViewController *)self.presentingViewController;
        [newView setUser:user];

    }
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToMessagesSegue"]){
        Messages *newView = segue.destinationViewController;
        [newView setUser:user andMatch:match];
    }
    else if ([segue.identifier isEqualToString:@"backToMatchesSegue"]){
        MatchesView *newView = segue.destinationViewController;
        [newView setUser:user];
    }
    
}


@end
