//
//  PeopleInVenue.m
//  Wingman2.0
//
//  Created by Zane Sheets on 2/27/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import "PeopleInVenue.h"

@implementation PeopleInVenue




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
    PFQuery *query = [PFQuery queryWithClassName:@"Venue"];
    [query whereKey:@"location" equalTo:[venue objectForKey:@"location"]];
    PFObject *tempObject = [query getFirstObject];
    PFRelation *relation = [tempObject relationForKey:@"members"];
    PFQuery *query2 = [relation query];
    return query2;
    
    
    
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
    /*
     PFQuery *query = [PFQuery queryWithClassName:@"User"];
     [query orderByAscending:@"createdAt"];
     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
     if (!error){
     NSLog(@"Found");
     int i = 0;
     for (i = 0; i < objects.count; i++){
     NSLog(@"Name %d: %@", i, [objects[i] objectForKey:@"name"]);
     // [ar addObject:objects[i]];
     }
     ar = [[NSArray alloc] initWithArray:objects];
     }
     NSLog(@"\n T: %@\n", [[ar objectAtIndex:7] objectForKey:@"name"]);
     }];
     */
    PFQuery *query = [PFQuery queryWithClassName:@"Venue"];
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
}

- (IBAction)handleBack:(id)sender {
    [self performSegueWithIdentifier:@"backOutSegue" sender:self];
}

-(void)passUser:(PFObject *)the_user aVenue:(PFObject *)the_venue{
    user = the_user;
    venue = the_venue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGRect frame = self.backButton.frame;
    frame.origin.y = scrollView.contentOffset.y + self.tableView.frame.size.height - self.backButton.frame.size.height;
    self.backButton.frame = frame;
    [self.view bringSubviewToFront:self.backButton];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
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
}






@end
