//
//  ThirdCustomCell.h
//  FirstTabApp
//
//  Created by Empty Brain on 15/8/8.
//  Copyright (c) 2015年 www.lzqok.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemorandumDataModel.h"
@interface CustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (copy,nonatomic) MemorandumDataModel *dataModel;
@end
