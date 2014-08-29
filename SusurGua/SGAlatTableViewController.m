//
//  SGAlatTableViewController.m
//  SusurGua
//
//  Created by Indra Purnama on 8/12/14.
//  Copyright (c) 2014 Indra Purnama. All rights reserved.
//

#import "SGAlatTableViewController.h"
#import "SWRevealViewController.h"
#import "SGAlatDetailViewController.h"

@interface SGAlatTableViewController ()
@property NSString *alatTitle;
@property NSString *alatDesc;
@property UIImage *alatImg;
@end

@implementation SGAlatTableViewController

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
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Peralatan Susur Gua";
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    //Get Alat Susur Gua from api
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://susurgua.com/gapi/public/getgearstype/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSDictionary *theReply = [NSJSONSerialization
                              JSONObjectWithData:POSTReply
                              
                              options:kNilOptions
                              error:nil];
    
    NSArray *data = [theReply objectForKey:@"data"];
    
    self.alat = [data copy];
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
    return [self.alat count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    //return cell;
    static NSString *CellIdentifier = @"Cell Identifier";
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //Fetch Author
    NSDictionary *alatSusur = [self.alat objectAtIndex:[indexPath row]];
    
    //Configure Cell
    [cell.textLabel setText:[alatSusur objectForKey:@"name"]];
    [cell setBackgroundColor:[UIColor colorWithRed:74/255.0 green:207/255.0 blue:221/255.0 alpha:0.5]];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Fetch jenis
    NSDictionary *alatGua = [self.alat objectAtIndex:[indexPath row]];
    self.alatTitle =  [alatGua objectForKey:@"name"];
    self.alatDesc = [alatGua objectForKey:@"description"];
    
    NSString *urlImg = [alatGua objectForKey:@"image"];
    self.alatImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlImg]]];
    
    // Perform Segue
    [self performSegueWithIdentifier:@"segue_alat" sender:self];
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
    if([segue.destinationViewController isKindOfClass:[SGAlatDetailViewController class]]){
        [(SGAlatDetailViewController *)segue.destinationViewController setAlatViewTitle:self.alatTitle];
        [(SGAlatDetailViewController *)segue.destinationViewController setAlatViewDesc:self.alatDesc];
        [(SGAlatDetailViewController *)segue.destinationViewController setAlatViewImage:self.alatImg];
        //Reset Boot Cover
        [self setAlatTitle:nil];
        [self setAlatDesc:nil];
        [self setAlatImg:nil];
    }
    
}

@end
