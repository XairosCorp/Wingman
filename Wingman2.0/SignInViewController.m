//
//  SignInViewController.m
//  Wingman2.0
//
//  Created by Zane Sheets on 2/25/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view bringSubviewToFront:self.emailField];
    [self.view bringSubviewToFront:self.passwordField];
    [self.view bringSubviewToFront:self.signInButton];
    [self.passwordField setSecureTextEntry:YES];
    
    // UI Setup
    _signInButton.layer.cornerRadius = 20;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.emailField endEditing:YES];
    [self.passwordField endEditing:YES];
}

- (IBAction)handleSignIn:(id)sender {
    if (self.emailField.text.length > 0 && self.passwordField.text.length > 0){
        PFQuery *findUser = [PFQuery queryWithClassName:@"User"];
        [findUser whereKey:@"email" equalTo:self.emailField.text];
        [findUser whereKey:@"password" equalTo:self.passwordField.text];
        [findUser getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error){
                user = object;
                NSString *name = [user objectForKey:@"name"];
                NSLog(@"%@", name);
                [self performSegueWithIdentifier:@"signInSegue" sender:self];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Incorrect email or password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        
    }
}

- (IBAction)cancelSignIn:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"signInSegue"]){
         MenuViewController *newView = segue.destinationViewController;
         [newView setUser:user];
     }
 }


@end
