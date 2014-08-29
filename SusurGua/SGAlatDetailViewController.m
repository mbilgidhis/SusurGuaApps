//
//  SGAlatDetailViewController.m
//  SusurGua
//
//  Created by Indra Purnama on 8/13/14.
//  Copyright (c) 2014 Indra Purnama. All rights reserved.
//

#import "SGAlatDetailViewController.h"
#import "SWRevealViewController.h"

@interface SGAlatDetailViewController ()

@end

@implementation SGAlatDetailViewController

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
    
    self.title = self.alatViewTitle;
    
    NSString *description = self.alatViewDesc;
    
    if(self.alatViewImage){
        [self.alatImage setImage:self.alatViewImage];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.alatDescription.text = [[NSString alloc] initWithString:(@"%@",description)];
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
