//
//  SGSearchTableViewController.h
//  SusurGua
//
//  Created by Indra Purnama on 8/18/14.
//  Copyright (c) 2014 Indra Purnama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGSearchTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) NSArray *listSearchGua;

@property NSString *guaID;


@end
