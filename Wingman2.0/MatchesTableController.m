//
//  MatchesTableController.m
//  Wingman2.0
//
//  Created by Zane Sheets on 2/27/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import "MatchesTableController.h"

@interface MatchesTableController ()

@end

@implementation MatchesTableController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 25;
    }
    return self;
}

- (PFQuery *)queryForTable {
    /*
     PFQuery *query = [PFQuery queryWithClassName:@"User"];
     if ([self.objects count] == 0){
     query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     }
     
     [query orderByAscending:@"createdAt"];
     return query;
     */
 
   
 /*
    PFQuery *query = [PFQuery queryWithClassName:@"Venue"];
    [query whereKey:@"location" equalTo:[venue objectForKey:@"location"]];
    PFObject *tempObject = [query getFirstObject];
    PFRelation *relation = [tempObject relationForKey:@"members"];
    PFQuery *query2 = [relation query];
    return query2;
*/
    PFQuery *getUserQuery = [PFQuery queryWithClassName:@"User"];
    [getUserQuery whereKey:@"email" equalTo:@"aa"];
    user = [getUserQuery getFirstObject];
    NSLog(@"Email: %@\n", [user objectForKey:@"email"]);
    
    PFRelation *relation = [user relationForKey:@"matches"];
    PFQuery *query = [relation query];
    NSArray *resultsArray = [query findObjects];
    NSMutableArray *emailArray = [[NSMutableArray alloc] init];
    NSMutableArray *relationArray = [[NSMutableArray alloc] init];
    int i = 0;
    for (i = 0; i < resultsArray.count; i++){
 //       NSLog(@"\n!!!!!!!!!!\nQuery Results: %@\n!!!!!!!!!!!\n", [resultsArray[i] objectForKey:@"email"]);
        [emailArray addObject:[resultsArray[i] objectForKey:@"email"]];
        
        ///////////////////////////////////////
        
        PFRelation *relation2 = [resultsArray[i] relationForKey:@"matches"];
        PFQuery *query_sub = [relation2 query];
        [query_sub whereKey:@"email" equalTo:[user objectForKey:@"email"]];
        NSArray *subResultsArray = [query_sub findObjects];
        int j = 0;
        for (j = 0; j < subResultsArray.count; j++){
   //         NSLog(@"\n**************\n*****\nRelation Results: %@\n****\n************\n", [subResultsArray[j] objectForKey:@"email"]);
            [relationArray addObject:subResultsArray[j]];
        }
        
        ///////////////////////////////////////
    }
    
    for (i = 0; i < emailArray.count; i++){
 //       NSLog(@"\n..........\n%@\n...........\n", emailArray[i]);
    }
    NSArray *queryArray = [[NSArray alloc] initWithArray:emailArray];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"User"];
    
    [query2 whereKey:@"email" containedIn:relationArray];
    return query2;
    
    
    /*
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            int i = 0;
            for (i = 0; i < objects.count; i++){
                PFRelation *findUserRelation = [objects[i] relationForKey:@"matches"];
                PFQuery *relationQuery = [findUserRelation query];
                [relationQuery whereKey:@"email" equalTo:[user objectForKey:@"email"]];
                [relationQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                    if (!error){
                        NSLog(@"Found");
                    }
                    else {
                        NSLog(@"error");
                    }
                }];
            }
        }
    }];
*/
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [object objectForKey:@"name"];
    PFFile *picFile = [object objectForKey:@"picture"];
    /*    [picFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
     if(!error){
     NSLog(@"Successfully got the image");
     cell.imageView.image = [UIImage imageWithData:data];
     }
     else {
     NSLog(@"Failed to get the image");
     }
     }];
     */
    NSData *picData = [picFile getData];
    UIImage *cellImage = [UIImage imageWithData:picData];
    cell.imageView.image = cellImage;
    //    cell.imageView.image = [UIImage imageNamed:@"sign_in_button.jpg"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //   NSLog(@"%@\n", indexPath);
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"\n\nThe cell's text: %@\n", cell.textLabel.text);
    im = cell.imageView.image;
    name = cell.textLabel.text;
    [self performSegueWithIdentifier:@"customSegue" sender:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFRelation *relation = [user relationForKey:@"matches"];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            int i = 0;
            for (i = 0; i < objects.count; i++){
                NSLog(@"Matches: %@\n", [objects[i] objectForKey:@"email"]);
                PFRelation *relation2 = [objects[i] relationForKey:@"matches"];
                PFQuery *query2 = [relation2 query];
                [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects2, NSError *error) {
                    if (!error){
                        int j = 0;
                        for (j = 0; j < objects.count; j++){
                            NSLog(@"Result: %@", [objects2[j] objectForKey:@"email"]);
                        }
                    }
                }];
            }
        }
    }];
/*
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    //    [query whereKey:@"name" equalTo:@"asdf"];
    [query whereKey:@"location" equalTo:[venue objectForKey:@"location"]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error){
            PFRelation *relation = [object relationForKey:@"members"];
            PFQuery *query2 = [relation query];
            [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error){
                    int i = 0;
                    for (i = 0; i < objects.count; i++){
                        NSLog(@"Here: %@", [objects[i] objectForKey:@"name"]);
                    }
                    ar = [[NSArray alloc] initWithArray:objects];
                }
            }];
        }
    }];
*/
}

- (IBAction)handleBack:(id)sender {
    [self performSegueWithIdentifier:@"backOutSegue" sender:self];
}

-(void)passUser:(PFObject *)the_user aVenue:(PFObject *)the_venue{
    user = the_user;
}
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGRect frame = self.backButton.frame;
    frame.origin.y = scrollView.contentOffset.y + self.tableView.frame.size.height - self.backButton.frame.size.height;
    self.backButton.frame = frame;
    [self.view bringSubviewToFront:self.backButton];
}
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 /* 
    if ([segue.identifier isEqualToString:@"customSegue"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ViewUserViewController *newView = segue.destinationViewController;
        PFObject *ob = [ar objectAtIndex:indexPath.row];
        [newView passUser:user other_user:ob aVenue:venue userImage:im];
    }
    else if ([segue.identifier isEqualToString:@"backOutSegue"]){
        VenuesViewController *newView = segue.destinationViewController;
        [newView setUser:user];
    }
*/
}





@end
