//
//  SGSearchTableViewController.m
//  SusurGua
//
//  Created by Indra Purnama on 8/18/14.
//  Copyright (c) 2014 Indra Purnama. All rights reserved.
//

#import "SGSearchTableViewController.h"
#import "SWRevealViewController.h"
#import "SGGuaDetailViewController.h"

@interface SGSearchTableViewController ()

@end

@implementation SGSearchTableViewController

{
    NSArray *searchResults;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.title = @"Search";
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.leftBarButtonItem = _sidebarButton;
    self.navigationItem.rightBarButtonItem = nil;
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    //Get list Gua from api
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://susurgua.com/gapi/public/caves/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSDictionary *theReply = [NSJSONSerialization
                              JSONObjectWithData:POSTReply
                              
                              options:kNilOptions
                              error:nil];
    
    NSArray *data = [theReply objectForKey:@"data"];
    
    self.listSearchGua = [data copy];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    searchResults = [self.listSearchGua filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //return [self.listSearchGua count];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [self.listSearchGua count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell Identifier";
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [tableView setBackgroundColor:[UIColor colorWithRed:63/255.0 green:167/255.0 blue:178/255.0 alpha:1]];
    
    NSDictionary *lSearch = nil;
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        lSearch = [searchResults objectAtIndex:indexPath.row];
    }else{
        lSearch = [self.listSearchGua objectAtIndex:indexPath.row];
    }
    
    //Configure Cell
    [cell setBackgroundColor:[UIColor colorWithRed:74/255.0 green:207/255.0 blue:221/255.0 alpha:0.5]];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    [cell.textLabel setText:[lSearch objectForKey:@"name"]];
    return cell;
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *searchSegue = nil;
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        searchSegue = [searchResults objectAtIndex:indexPath.row];
    }else{
        searchSegue = [self.listSearchGua objectAtIndex:indexPath.row];
    }
    
    
    // Fetch Detail Gua
    //NSDictionary *detail = [self.listGuaProvinsi objectAtIndex:[indexPath row]];
    /*
     self.biotaTitle =  [biota objectForKey:@"name"];
     self.biotaDesc = [biota objectForKey:@"description"];
     
     NSString *urlImg = [biota objectForKey:@"image"];
     self.biotaImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlImg]]];
     */
    
    self.guaID = [searchSegue objectForKey:@"id"];
    
    // Perform Segue
    //[self performSegueWithIdentifier:@"segue_searchDetail" sender:self];
    if ((int)[[UIScreen mainScreen] bounds].size.height == 568)
    {
        // This is iPhone 5 screen
        // Perform Segue
        [self performSegueWithIdentifier:@"segue_searchDetail" sender:self];
    } else {
        // This is iPhone 4/4s screen
        [self performSegueWithIdentifier:@"segue_test" sender:self];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.destinationViewController isKindOfClass:[SGGuaDetailViewController class]]){
        [(SGGuaDetailViewController *)segue.destinationViewController setGuaViewID:self.guaID];
        
        
        //Reset Boot Cover
        [self setGuaID:nil];
        
    }
}


@end
