//
//  SGJenisDetailViewController.h
//  SusurGua
//
//  Created by Indra Purnama on 8/13/14.
//  Copyright (c) 2014 Indra Purnama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGJenisDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITextView *jenisDescription;
@property (weak, nonatomic) IBOutlet UIImageView *jenisImg;


@property (nonatomic) NSString *jenisTitle;
@property (nonatomic) NSString *jenisDesc;
@property UIImage *jenisViewImg;
@end
