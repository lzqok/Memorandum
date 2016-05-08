//
//  CustomTableViewController.m
//  Memorandum
//
//  Created by Empty Brain on 15/8/9.
//  Copyright (c) 2015年 www.lzqok.cn. All rights reserved.
//

#import "CustomTableViewController.h"
#import "CustomCell.h"
#import "EditViewController.h"
@interface CustomTableViewController ()
{
    NSMutableArray *dataList;
    NSMutableArray *searDataList;
}
@end

@implementation CustomTableViewController
@synthesize db;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationController.navigationBar.translucent = NO;
    //self.tabBarController.tabBar.translucent=NO;
 //   UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 35)];
    
    searDataList = [[NSMutableArray alloc]init];
    _searchBar = [[UISearchBar alloc]init];
    _searchBar.delegate = self;
    self.searchBar.showsScopeBar = YES;
    _searchBar.frame = CGRectMake(0, 0, 200, 35);
    
    self.tableView.tableHeaderView = _searchBar;
  //  [self.searchBar setBarTintColor:[UIColor redColor]];
   // [_searchBar setBackgroundColor:[UIColor clearColor]];
    /*
    _searchBar.layer.cornerRadius = 18;
    _searchBar.layer.masksToBounds = YES;
    [_searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_searchBar.layer setBorderWidth:8];
     */
   // [titleView addSubview:searchBar];
    [self.navigationItem.titleView sizeToFit];
    //self.navigationItem.titleView = titleView;
    _searchDisCtrl = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    _searchDisCtrl.delegate = self;
    _searchDisCtrl.searchResultsDataSource = self;
    _searchDisCtrl.searchResultsDelegate = self;
    
    db = [[DBUtils alloc]init];
  //  self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
   self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setExtraCellLineHidden:self.tableView];
    [self setbeginRefreshing];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.title = @"备忘录";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blueColor]}];
    self.navigationItem.backBarButtonItem = item;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   // [self.tableView setEditing:YES animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [self updateData];
    [_searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark  - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searDataList count];
    }
    else
        return [dataList count];
}

#pragma  mark  tableViewCell
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *customCellIdentifier = @"CustomCell";
    static BOOL nibsRegistered = NO;
    if(!nibsRegistered){
        UINib *nib = [UINib nibWithNibName:@"CustomCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:customCellIdentifier];
        nibsRegistered = YES;
    }
    
    CustomCell *cell = [self.tableView dequeueReusableCellWithIdentifier:customCellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    MemorandumDataModel *dataModel = nil;
    if(tableView == self.searchDisCtrl.searchResultsTableView){
        dataModel = [searDataList objectAtIndex:indexPath.row];
    }else if(tableView == self.tableView){
        dataModel = [dataList objectAtIndex:indexPath.row];
    }
    cell.dataModel = dataModel;
    return  cell;
}


-(void)setExtraCellLineHidden:(UITableView *)tableView{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return  indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditViewController *editViewController = [storyboard instantiateViewControllerWithIdentifier:@"EditStoryboard"];
    editViewController.dataModel = dataList[indexPath.row];
    [self.navigationController pushViewController:editViewController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return  YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger i = indexPath.row;
    int backup_id ;
    if(editingStyle == UITableViewCellEditingStyleDelete){
        if(tableView == self.searchDisCtrl.searchResultsTableView){
            backup_id = [searDataList[i] backupID];
            if([db deletInfoWithName:backup_id]){
                [dataList removeObject:searDataList[indexPath.row]];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];

            }
        }else if(tableView == self.tableView){
            backup_id = [dataList[i] backupID];
            if([db deletInfoWithName:backup_id]){
                [dataList removeObject:dataList[indexPath.row]];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            }
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"delete";
}


#pragma mark - refresh

-(void)setbeginRefreshing{
    _refresh = [[UIRefreshControl alloc]init];
    //刷新图形颜色
    _refresh.tintColor = [UIColor lightGrayColor];
    //刷新的标题
    _refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [_refresh addTarget:self action:@selector(refreshTableviewAction:) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = _refresh;
}

-(void)refreshTableviewAction:(UIRefreshControl *)refreshs{
    if(refreshs.refreshing){
        refreshs.attributedTitle = [[NSAttributedString alloc]initWithString:@"正在刷新"];
        [self performSelector:@selector(refreshData) withObject:nil afterDelay:2];
    }
}

-(void) refreshData{
    NSString *sysTime = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    sysTime = [formatter stringFromDate:[NSDate date]];
    NSString *lastUpdated = [NSString stringWithFormat:@"上一次更新时间为 %@", [formatter stringFromDate:[NSDate date]]];
    
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [self.refreshControl endRefreshing];
    [self updateData];
}

- (void) updateData{
    dataList = [NSMutableArray array];
    for (int i=0;i<[[db searchInfoFromDB] count]; i++) {
        dataList[i] = [db searchInfoFromDB][i];
    }
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    // 修改UISearchBar右侧的取消按钮文字、颜色及背景图片.
   
    for (UIView *searchbuttons in [searchBar.subviews[0] subviews]){
        if ([searchbuttons isKindOfClass:[UIButton class]]) {
            
            UIButton *cancelButton = (UIButton*)searchbuttons;
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            // 修改文字颜色
            [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            
            // 修改按钮背景
          //  [cancelButton setBackgroundColor:[UIColor whiteColor]];
          //  [cancelButton setBackgroundImage:nil forState:UIControlStateHighlighted];
            
        }
    }
}

/*- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    for (id cc in [searchBar subviews]) {
        if([cc isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton *)cc;
            btn.titleLabel.text = @"取消";
            //[btn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
    return YES;
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
 */

#pragma mark - searchDisplay
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [searDataList removeAllObjects];
    for (int i=0;i<[dataList count];i++){
        NSString *str1 = [dataList[i]content];
        NSString *str2 = _searchBar.text;
        if ([str1 rangeOfString:str2].location != NSNotFound)
        {
            [searDataList addObject:dataList[i]];
        }
    }
    return YES;
}

@end
