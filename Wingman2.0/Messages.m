//
//  Messages.m
//  Wingman2.0
//
//  Created by Zane Sheets on 2/28/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import "Messages.h"

@interface Messages ()

@end

@implementation Messages

- (void)viewDidLoad {
    [super viewDidLoad];
 /*
    NSArray *messagesArray = [self getMessages:user object2:match];
    numberOfMessages = messagesArray.count;
    int i = 0;
    for (i = 0; i < messagesArray.count; i++){
        if (i == 0){
            [self.text1View setText:[messagesArray[i] objectForKey:@"text"]];
            if ([[messagesArray[i] objectForKey:@"senderEmail"] isEqualToString:[user objectForKey:@"email"]]){
                [self.text1View setBackgroundColor:[UIColor yellowColor]];
            }
            else {
                [self.text1View setBackgroundColor:[UIColor orangeColor]];
            }
        }
        else if (i == 1){
            [self.text2View setText:[messagesArray[i] objectForKey:@"text"]];
            if ([[messagesArray[i] objectForKey:@"senderEmail"] isEqualToString:[user objectForKey:@"email"]]){
                [self.text2View setBackgroundColor:[UIColor yellowColor]];
            }
            else {
                [self.text2View setBackgroundColor:[UIColor orangeColor]];
            }
        }
        else if (i == 2){
            [self.text3View setText:[messagesArray[i] objectForKey:@"text"]];
            if ([[messagesArray[i] objectForKey:@"senderEmail"] isEqualToString:[user objectForKey:@"email"]]){
                [self.text3View setBackgroundColor:[UIColor yellowColor]];
            }
            else {
                [self.text3View setBackgroundColor:[UIColor orangeColor]];
            }
        }
        else if (i == 3){
            [self.text4View setText:[messagesArray[i] objectForKey:@"text"]];
            if ([[messagesArray[i] objectForKey:@"senderEmail"] isEqualToString:[user objectForKey:@"email"]]){
                [self.text4View setBackgroundColor:[UIColor yellowColor]];
            }
            else {
                [self.text4View setBackgroundColor:[UIColor orangeColor]];
            }
        }
    }
 */
    [self refreshAfterSend];
    [self.view bringSubviewToFront:self.text1View];
    [self.view bringSubviewToFront:self.text2View];
    [self.view bringSubviewToFront:self.text3View];
    [self.view bringSubviewToFront:self.text4View];
    [self.view bringSubviewToFront:self.currentTextView];
    [self.view bringSubviewToFront:self.backButton];
    [self.view bringSubviewToFront:self.sendButton];
    
    // UI Initializations
    _sendButton.layer.cornerRadius = 20;
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

- (IBAction)handleSend:(id)sender {
    if([self canSendMessage:user object2:match]){
        if (self.currentTextView.text.length > 0){
            PFObject *newMessage = [PFObject objectWithClassName:@"Message"];
            [newMessage setObject:[user objectForKey:@"email"] forKey:@"senderEmail"];
            [newMessage setObject:[match objectForKey:@"email"] forKey:@"receiverEmail"];
            [newMessage setObject:self.currentTextView.text forKey:@"text"];
            int messageCount = numberOfMessages;
            messageCount = messageCount + 1;
            NSNumber *newTextNumber = [NSNumber numberWithInt:messageCount];
            [newMessage setObject:newTextNumber forKey:@"number"];
            [newMessage save];
            
            PFRelation *relationSide1 = [user relationForKey:@"messages"];
            [relationSide1 addObject:newMessage];
            [user save];
            
            PFRelation *relationSide2 = [match relationForKey:@"messages"];
            [relationSide2 addObject:newMessage];
            [match save];
            
            [self refreshAfterSend];
            [self.currentTextView setText:@""];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nope!" message:@"Your conversation is limited to 4 exchanges, next time get to the point faster!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)handleBack:(id)sender {
    [self performSegueWithIdentifier:@"goBackToProfileSegue" sender:self];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.currentTextView endEditing:YES];
}

- (BOOL)canSendMessage:(PFObject *)userObject object2:(PFObject *)matchObject{
    
    BOOL result = YES;
    
    
    NSInteger count = 0;
    PFQuery *A_query = [PFQuery queryWithClassName:@"Message"];
    [A_query whereKey:@"senderEmail" equalTo:[userObject objectForKey:@"email"]];
    [A_query whereKey:@"receiverEmail" equalTo:[matchObject objectForKey:@"email"]];
    count = count + [A_query countObjects];
    
    PFQuery *B_query = [PFQuery queryWithClassName:@"Message"];
    [B_query whereKey:@"senderEmail" equalTo:[matchObject objectForKey:@"email"]];
    [B_query whereKey:@"receiverEmail" equalTo:[userObject objectForKey:@"email"]];
    count = count + [B_query countObjects];
    
    //   NSLog(@"\n\nAnd the final count is: %ld\n\n", (long)count);
    
    if (count >= 4){
        result = NO;
    }
    
    return result;
}

- (NSArray *)getMessages:(PFObject *)userObject object2:(PFObject *)matchObject{
    PFQuery *A_query = [PFQuery queryWithClassName:@"Message"];
    [A_query whereKey:@"senderEmail" equalTo:[userObject objectForKey:@"email"]];
    [A_query whereKey:@"receiverEmail" equalTo:[matchObject objectForKey:@"email"]];
    NSArray *user_to_match = [A_query findObjects];
    
    
    PFQuery *B_query = [PFQuery queryWithClassName:@"Message"];
    [B_query whereKey:@"senderEmail" equalTo:[matchObject objectForKey:@"email"]];
    [B_query whereKey:@"receiverEmail" equalTo:[userObject objectForKey:@"email"]];
    NSArray *match_to_user = [B_query findObjects];
    
    NSMutableArray *arrayBuilder = [[NSMutableArray alloc] initWithArray:user_to_match];
    [arrayBuilder addObjectsFromArray:match_to_user];
    
    
    NSMutableArray *orderedArray = [[NSMutableArray alloc] init];
    
    int i = 0;
    for (i = 0; i < arrayBuilder.count; i++){
        int j = 0;
        for (j = 0; j < arrayBuilder.count; j++){
            NSNumber *num2 = [arrayBuilder[j] objectForKey:@"number"];
            long temp = [num2 integerValue];
            if (temp == i+1){
                [orderedArray addObject:arrayBuilder[j]];
            }
        }
    }
    
    NSArray *returnArray = [NSArray arrayWithArray:orderedArray];
    
    return  returnArray;
}

-(void)refreshAfterSend{
    
    NSArray *messagesArray = [self getMessages:user object2:match];
    numberOfMessages = messagesArray.count;
    int i = 0;
    for (i = 0; i < messagesArray.count; i++){
        if (i == 0){
            [self.text1View setText:[messagesArray[i] objectForKey:@"text"]];
            if ([[messagesArray[i] objectForKey:@"senderEmail"] isEqualToString:[user objectForKey:@"email"]]){
                [self.text1View setBackgroundColor:[UIColor yellowColor]];
            }
            else {
                [self.text1View setBackgroundColor:[UIColor orangeColor]];
            }
        }
        else if (i == 1){
            [self.text2View setText:[messagesArray[i] objectForKey:@"text"]];
            if ([[messagesArray[i] objectForKey:@"senderEmail"] isEqualToString:[user objectForKey:@"email"]]){
                [self.text2View setBackgroundColor:[UIColor yellowColor]];
            }
            else {
                [self.text2View setBackgroundColor:[UIColor orangeColor]];
            }
        }
        else if (i == 2){
            [self.text3View setText:[messagesArray[i] objectForKey:@"text"]];
            if ([[messagesArray[i] objectForKey:@"senderEmail"] isEqualToString:[user objectForKey:@"email"]]){
                [self.text3View setBackgroundColor:[UIColor yellowColor]];
            }
            else {
                [self.text3View setBackgroundColor:[UIColor orangeColor]];
            }
        }
        else if (i == 3){
            [self.text4View setText:[messagesArray[i] objectForKey:@"text"]];
            if ([[messagesArray[i] objectForKey:@"senderEmail"] isEqualToString:[user objectForKey:@"email"]]){
                [self.text4View setBackgroundColor:[UIColor yellowColor]];
            }
            else {
                [self.text4View setBackgroundColor:[UIColor orangeColor]];
            }
        }
    }

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goBackToProfileSegue"]){
        ProfileViewController *newView = segue.destinationViewController;
        [newView setUser:user andMatch:match];
    }
}


@end
