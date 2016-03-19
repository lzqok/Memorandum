//
//  EditViewController.h
//  Memorandum
//
//  Created by Empty Brain on 14/10/7.
//  Copyright (c) 2014年 www.lzqok.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBUtils.h"

@interface EditViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *editTextView;
@property (strong, nonatomic) MemorandumDataModel *dataModel;
@property (weak, nonatomic) IBOutlet UIButton *navTitleBtn;
@property DBUtils *db;
- (IBAction)editDoneAction:(id)sender;
- (IBAction)EditBtnAction:(id)sender;
- (IBAction)shareBtnAction:(id)sender;
- (IBAction)deleteBtnAction:(id)sender;

@end
