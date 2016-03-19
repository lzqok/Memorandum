//
//  DBUtils.h
//  Memorandum
//
//  Created by Empty Brain on 15/8/9.
//  Copyright (c) 2015年 www.lzqok.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "MemorandumDataModel.h"
@interface DBUtils : NSObject
@property sqlite3 *connectDB;
-(BOOL)openSQLDB;
-(BOOL) initDB;
-(BOOL)saveDataWithContent:(NSString *)content withTime:(NSString *)dateTime;
-(BOOL)excWithSql:(char *)inputsql withDataModel:(MemorandumDataModel *) dataModel;

-(NSMutableArray *)searchInfoFromDB;
-(BOOL)deletInfoWithName:(int)user_id;
@end
