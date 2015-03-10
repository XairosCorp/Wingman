//
//  MatchesViewController.m
//  Wingman2.0
//
//  Created by Zane Sheets on 2/21/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import "MatchesViewController.h"

@interface MatchesViewController ()

@end

@implementation MatchesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.matchesTable = [[PFQueryTableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.matchesTable.pullToRefreshEnabled = YES;
    self.matchesTable.paginationEnabled = NO;
    self.matchesTable.objectsPerPage = 25;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //   NSLog(@"%@\n", indexPath);
    
/*
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"\n\nThe cell's text: %@\n", cell.textLabel.text);
    im = cell.imageView.image;
    name = cell.textLabel.text;
    [self performSegueWithIdentifier:@"customSegue" sender:self];
*/
}










/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
