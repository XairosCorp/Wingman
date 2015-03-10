//
//  MatchesView.m
//  Wingman2.0
//
//  Created by Zane Sheets on 2/28/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import "MatchesView.h"

@interface MatchesView ()

@end

@implementation MatchesView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFRelation *relation = [user relationForKey:@"matches"];
    PFQuery *query = [relation query];
    NSArray *userMatches = [query findObjects];
    
    matchesArray = [[NSMutableArray alloc] init];
    
    int i = 0;
    int j = 0;
    for (i = 0; i < userMatches.count; i++){
        NSLog(@"Iterator %d\n", i);
        PFRelation *relation2 = [userMatches[i] relationForKey:@"matches"];
        PFQuery *query2 = [relation2 query];
        NSArray *result = [[NSArray alloc] initWithArray:[query2 findObjects]];
        
        for (j = 0; j < result.count; j++){
            NSLog(@"Temp::: %@\n\n", [result[j] objectForKey:@"email"]);
            if ([[result[j] objectForKey:@"email"] isEqualToString:[user objectForKey:@"email"]]){
                NSLog(@"User found for other user: %@", [userMatches[i] objectForKey:@"email"]);
                [matchesArray addObject:userMatches[i]];
            }
        }        
    }
    
    confirmedMatchesArray = [[NSArray alloc] initWithArray:matchesArray];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleGoBack:(id)sender {
    [self performSegueWithIdentifier:@"backToMenuFromMatchesSegue" sender:self];
}

- (void)setUser:(PFObject *)object{
    user = object;
    NSLog(@"\n\nTest\n\n");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return confirmedMatchesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:10];
    UIImageView *userImageView = (UIImageView *)[cell.contentView viewWithTag:5];
    
    [label setText:[[confirmedMatchesArray objectAtIndex:indexPath.row] objectForKey:@"email"]];
    PFFile *picFile = [[confirmedMatchesArray objectAtIndex:indexPath.row]
                       objectForKey:@"picture"];
    [picFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error){
            [userImageView setImage:[UIImage imageWithData:data]];
        }
        else {
            NSLog(@"ERROR");
        }
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //   NSLog(@"%@\n", indexPath);
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    matchSelection = [confirmedMatchesArray objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"goToProfile" sender:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGRect frame = self.backButton.frame;
    frame.origin.y = scrollView.contentOffset.y + self.tableView.frame.size.height - self.backButton.frame.size.height;
    self.backButton.frame = frame;
    [self.view bringSubviewToFront:self.backButton];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToProfile"]){
        ProfileViewController *newView = segue.destinationViewController;
        [newView setUser:user andMatch:matchSelection];
    }
    else if ([segue.identifier isEqualToString:@"backToMenuFromMatchesSegue"]){
        MenuViewController *newView = segue.destinationViewController;
        [newView setUser:user];
    }
}


@end
