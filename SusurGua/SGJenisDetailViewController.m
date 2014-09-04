//
//  SGJenisDetailViewController.m
//  SusurGua
//
//  Created by Indra Purnama on 8/13/14.
//  Copyright (c) 2014 Indra Purnama. All rights reserved.
//

#import "SGJenisDetailViewController.h"
#import "SWRevealViewController.h"

@interface SGJenisDetailViewController ()

@end

@implementation SGJenisDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.title = self.jenisTitle;
    NSString *description = self.jenisDesc;
    
    if(self.jenisViewImg){
        [self.jenisImg setImage:self.jenisViewImg];
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.jenisDescription setTextContainerInset:UIEdgeInsetsMake(10, 12, 10, 12)];
    self.jenisDescription.text = [[NSString alloc] initWithString:(@"%@",description)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
