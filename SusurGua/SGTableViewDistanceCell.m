//
//  SGTableViewDistanceCell.m
//  SusurGua
//
//  Created by Indra Purnama on 8/25/14.
//  Copyright (c) 2014 Indra Purnama. All rights reserved.
//

#import "SGTableViewDistanceCell.h"

@implementation SGTableViewDistanceCell
@synthesize listGua = _listGua;
@synthesize jarak =_jarak;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
