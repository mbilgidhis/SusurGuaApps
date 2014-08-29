//
//  SGBiotaDetailViewController.h
//  SusurGua
//
//  Created by Indra Purnama on 8/13/14.
//  Copyright (c) 2014 Indra Purnama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGBiotaDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITextView *biotaDescription;

//@property UIImage *biotaImg;
@property (weak, nonatomic) IBOutlet UIImageView *biotaImage;


@property (nonatomic) NSString *biotaViewTitle;
@property (nonatomic) NSString *biotaViewDesc;
@property UIImage *biotaViewImg;
@end
