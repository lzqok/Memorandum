//
//  EditViewController.m
//  Memorandum
//
//  Created by Empty Brain on 14/10/7.
//  Copyright (c) 2014年 www.lzqok.cn. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()<UITextViewDelegate>{
    NSString *dateString;
    BOOL isUpadte;
}

@end

@implementation EditViewController
@synthesize dataModel;
@synthesize db;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    db = [[DBUtils alloc]init];
    _editTextView.delegate = self;
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSinceNow:1];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    dateString = [formatter stringFromDate:date];
    
    if(dataModel!=nil){
        _editTextView.text = [dataModel content];
        _dateTimeLabel.text = [dataModel dateTime];
        isUpadte = YES;
        [_doneBtn setHidden:YES];
        [_editTextView resignFirstResponder];
    }else{
        _dateTimeLabel.text = dateString;
        isUpadte = NO;
        [_editTextView becomeFirstResponder];
    }
    //设置textView左上角定格输入
    _editTextView.contentInset = UIEdgeInsetsMake(-70, 0, 0, 0);
    
    if(dataModel.backupID==0){
        _navTitleBtn.titleLabel.text = @"添加备忘";
    }else{
        _navTitleBtn.titleLabel.text = @"修改备忘";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated{
    
  //  [_editTextView removeObserver:self forKeyPath:@"contentSize"  context:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    if([self checkValidityTextView])
        [self changeData];
    else{
        if([dataModel backupID]!=0){
            [db deletInfoWithName:[dataModel backupID]];
        }
    }
}




-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    _editTextView.contentOffset = (CGPoint){.x=0,.y=0};
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [_doneBtn setHidden:NO];
    return YES;
}


- (IBAction)editDoneAction:(id)sender {
    if([self checkValidityTextView]){
        [_doneBtn setHidden:YES];
       // [self changeData];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    if([_editTextView isFirstResponder])
        [_editTextView resignFirstResponder];

}

-(IBAction)EditBtnAction:(id)sender{
    [_editTextView becomeFirstResponder];
}
- (IBAction)shareBtnAction:(id)sender {
    
}

- (IBAction)deleteBtnAction:(id)sender {
    _editTextView.text = @"";
    [_editTextView becomeFirstResponder];
    if([dataModel backupID]!=0){
        [db deletInfoWithName:[dataModel backupID]];
    }
}

-(void)changeData{
    dataModel.content = self.editTextView.text;
    dataModel.dateTime = dateString;
    if(isUpadte){
        char *sql = "update memorandum set content=?,datetime = ? where backup_id=?";
        if([db excWithSql:sql withDataModel:dataModel]){
        }
    }else{
        if([db saveDataWithContent:_editTextView.text withTime:dateString]){
        }
    }
}

-(BOOL)checkValidityTextView{
    if(self.editTextView == nil || [self.editTextView.text isEqualToString:@""]){
        return NO;
    }
    return YES;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)textViewDidBeginEditing:(UITextView *)textView{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    static const CGFloat kKeyboardHeight = 360.0;
#else
    static const CGFloat kKeyboardHeight = 316.0;
#endif
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    CGRect textViewFrame = textView.frame;
    textViewFrame.size.height = self.view.bounds.size.height-kKeyboardHeight;
    textView.frame = textViewFrame;
    [UIView commitAnimations];
 }
 
 - (void)textViewDidEndEditing:(UITextView *)textView{
     [UIView beginAnimations:nil context:nil];
     [UIView setAnimationDuration:0.2];
     int x = textView.frame.origin.x;
     int w = textView.frame.size.width;
     CGRect textViewFrame = self.view.bounds;
     textViewFrame.origin.y = self.view.bounds.origin.y + self.navigationController.navigationBar.frame.origin.y+self.dateTimeLabel.frame.origin.y;
     textViewFrame.origin.x = x;
     textViewFrame.size.width = w;
     textViewFrame.size.height = self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.dateTimeLabel.frame.size.height-70;
     textView.frame = textViewFrame;
     [UIView commitAnimations];
 }
 
@end
