//
//  SGGuaDetailViewController.h
//  SusurGua
//
//  Created by Indra Purnama on 8/14/14.
//  Copyright (c) 2014 Indra Purnama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGGuaDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UITextView *description;
@property (weak, nonatomic) IBOutlet UILabel *jenis;
@property (weak, nonatomic) IBOutlet UILabel *longitude;
@property (weak, nonatomic) IBOutlet UILabel *latitude;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UITextView *gears;

@property (weak, nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) UIImage *pin;
@property (weak, nonatomic) IBOutlet UIImageView *pinView;

@property (weak, nonatomic) IBOutlet UILabel *kelurahan;
@property (weak, nonatomic) IBOutlet UILabel *kecamatan;
@property (weak, nonatomic) IBOutlet UILabel *kabupaten;

//@property NSArray *detailGua;

//get from area list
@property NSString *guaViewID;

@end
