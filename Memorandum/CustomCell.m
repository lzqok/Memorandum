//
//  ThirdCustomCell.m
//  FirstTabApp
//
//  Created by Empty Brain on 15/8/8.
//  Copyright (c) 2015年 www.lzqok.cn. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize dataModel;
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


- (void)setDataModel:(MemorandumDataModel *)d{
    if(![d isEqual:dataModel]){
        dataModel = d;
        self.contentLabel.text = [dataModel content];
        self.dateTimeLabel.text = [[dataModel dateTime]substringFromIndex:11];
    }
}


@end
