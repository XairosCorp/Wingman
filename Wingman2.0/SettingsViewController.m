//
//  SettingsViewController.m
//  Wingman2.0
//
//  Created by Zane Sheets on 2/24/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.emailLabel setText:[user objectForKey:@"email"]];
    [self.nameField setText:[user objectForKey:@"name"]];
    [self.cityField setText:[user objectForKey:@"city"]];
    PFFile *picFile = [user objectForKey:@"picture"];
    [picFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error){
            [self.profilePictureView setImage:[UIImage imageWithData:data]];
        }
    }];
    NSNumber *interestNum = [user objectForKey:@"interestedIn"];
    if ([interestNum isEqualToNumber:[NSNumber numberWithInt:1]]){
        self.guysSwitch.on = TRUE;
        self.girlsSwitch.on = TRUE;
    }
    else if([interestNum isEqualToNumber:[NSNumber numberWithInt:2]]){
        self.guysSwitch.on = FALSE;
        self.girlsSwitch.on = TRUE;
    }
    else if ([interestNum isEqualToNumber:[NSNumber numberWithInt:3]]){
        self.guysSwitch.on = TRUE;
        self.girlsSwitch.on = FALSE;
    }
    
    
    [self.view bringSubviewToFront:self.doneButton];
    [self.view bringSubviewToFront:self.menuButton];
    [self.view bringSubviewToFront:self.nameField];
    [self.view bringSubviewToFront:self.cityField];
    [self.view bringSubviewToFront:self.emailLabel];
    [self.view bringSubviewToFront:self.girlsSwitch];
    [self.view bringSubviewToFront:self.guysSwitch];
    [self.view bringSubviewToFront:self.profilePictureView];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUser:(PFObject *)object{
    user = object;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.nameField endEditing:YES];
    [self.cityField endEditing:YES];
}


- (IBAction)handleDone:(id)sender {
    int i = 0;
    if (self.guysSwitch.on && self.girlsSwitch.on){
        i = 1;
    }
    else if (!self.guysSwitch.on && self.girlsSwitch.on){
        i = 2;
    }
    else if (self.guysSwitch.on && !self.girlsSwitch.on){
        i = 3;
    }
    NSNumber *interests = [NSNumber numberWithInt:i];
    if (self.nameField.text.length > 0 && self.cityField.text.length > 0){
        [user setObject:self.nameField.text forKey:@"name"];
        [user setObject:interests forKey:@"interestedIn"];
        [user setObject:self.cityField.text forKey:@"city"];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error){
                NSLog(@"Success");
                [self performSegueWithIdentifier:@"doneBackToMenuSegue" sender:self];
            }
        }];
    }
    
}

- (IBAction)handleMenu:(id)sender {
    [self performSegueWithIdentifier:@"doneBackToMenuSegue" sender:self];
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     MenuViewController *newView = segue.destinationViewController;
     [newView setUser:user];
 }
 


@end
