//
//  SGPanduanTableViewController.h
//  SusurGua
//
//  Created by Indra Purnama on 8/12/14.
//  Copyright (c) 2014 Indra Purnama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGPanduanTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic, strong) NSArray *menuPanduans;

@end
