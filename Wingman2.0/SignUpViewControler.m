//
//  SignUpViewControler.m
//  Wingman2.0
//
//  Created by Zane Sheets on 2/20/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import "SignUpViewControler.h"
#import "TakePicture.h"

@interface SignUpViewControler ()

@end

@implementation SignUpViewControler

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view bringSubviewToFront:self.nameField];
    [self.view bringSubviewToFront:self.emailField];
    [self.view bringSubviewToFront:self.passwordField];
    [self.view bringSubviewToFront:self.passwordField2];
    [self.view bringSubviewToFront:self.signUpButton];
    [self.passwordField setSecureTextEntry:YES];
    [self.passwordField2 setSecureTextEntry:YES];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.nameField endEditing:YES];
    [self.emailField endEditing:YES];
    [self.passwordField2 endEditing:YES];
    [self.passwordField endEditing:YES];
 
 //   [super touchesBegan:touches withEvent:event];
}

- (IBAction)handleSignUp:(id)sender {
    if (self.nameField.text.length > 0 && self.emailField.text.length > 0 && self.passwordField.text.length > 0 && self.passwordField2.text.length > 0){
        NSLog(@"Something in each field");
        
        if ([self.passwordField2.text isEqualToString:self.passwordField.text]){
            NSLog(@"Passwords are equal");
            
            PFQuery *emailTakenQuery = [PFQuery queryWithClassName:@"User"];
            [emailTakenQuery whereKey:@"email" equalTo:self.emailField.text];
            [emailTakenQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (!error){
      //              NSLog(@"No error, that email is already taken");
                }
                else {
                    self.user = [PFObject objectWithClassName:@"User"];
                    [self.user setObject:self.nameField.text forKey:@"name"];
                    [self.user setObject:self.passwordField.text forKey:@"password"];
                    [self.user setObject:self.emailField.text forKey:@"email"];
                    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error){
                            NSLog(@"Save was successful");
                            [self performSegueWithIdentifier:@"signUp" sender:self];
                        }
                        else {
                            NSLog(@"Save wasn't successful");
                        }
                    }];
                }
            }];
            
            
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Passwords are not equal" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    TakePicture *picView = segue.destinationViewController;
    [picView setUser:self.user];
}

@end
