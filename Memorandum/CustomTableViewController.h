//
//  CustomTableViewController.h
//  Memorandum
//
//  Created by Empty Brain on 15/8/9.
//  Copyright (c) 2015年 www.lzqok.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBUtils.h"
@interface CustomTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (strong,nonatomic) UIRefreshControl *refresh;
@property DBUtils *db;
@property UISearchDisplayController * searchDisCtrl;
@property UISearchBar *searchBar;
@end
