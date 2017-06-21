//
//  InsetCell.m
//  Email
//
//  Created by Takuya Suenaga on 2014/05/29.
//  Copyright (c) 2014年 Takuya Suenaga. All rights reserved.
//

#import "InsetCell.h"
#import "SZFlatUI.h"

@implementation InsetCell

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
    self.inset = 15;
    self.textLabel.font = [UIFont flatFontOfSize:self.textLabel.font.pointSize];
    self.detailTextLabel.font = [UIFont flatFontOfSize:self.textLabel.font.pointSize];
    self.tintColor = [UIColor midnightBlueColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x += self.inset;
    frame.size.width -= 2 * self.inset;
//    [self setClipsToBounds:YES];
//    [[self layer] setCornerRadius:3.0f];
    [super setFrame:frame];
}

@end
