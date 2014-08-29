//
//  SGAlatDetailViewController.h
//  SusurGua
//
//  Created by Indra Purnama on 8/13/14.
//  Copyright (c) 2014 Indra Purnama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGAlatDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITextView *alatDescription;
@property (weak, nonatomic) IBOutlet UIImageView *alatImage;


@property (nonatomic) NSString *alatViewTitle;
@property (nonatomic) NSString *alatViewDesc;
@property UIImage *alatViewImage;
@end
