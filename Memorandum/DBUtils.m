//
//  DBUtils.m
//  Memorandum
//
//  Created by Empty Brain on 15/8/9.
//  Copyright (c) 2015年 www.lzqok.cn. All rights reserved.
//

#import "DBUtils.h"
@implementation DBUtils
@synthesize connectDB;
-(BOOL)openSQLDB{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask,YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    NSString *dbName = @"backup.db";
    NSString *dataFilePath = [docDirectory stringByAppendingString:dbName];
    if(sqlite3_open([dataFilePath UTF8String],&connectDB)!=SQLITE_OK){
        sqlite3_close(connectDB);
        NSLog(@"连接失败");
        return NO;
    }
    NSLog(@"连接成功");
    return YES;
}

-(BOOL) initDB{
    char *errorMsg;
    NSString *sql = @"create table if not exists memorandum(backup_id integer primary key,content Text,datetime Text)";
    if(sqlite3_exec(connectDB, [sql UTF8String],NULL, NULL,&errorMsg)!= SQLITE_OK){
        sqlite3_close(connectDB);
        NSLog(@"初始化失败");
        return NO;
    }
    NSLog(@"初始化成功");
    return YES;
}

-(BOOL)saveDataWithContent:(NSString *)content withTime:(NSString *)dateTime{
    [self openSQLDB];
    [self initDB];
    char *insert = "insert into memorandum(content,datetime)values(?,?);";
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(connectDB, insert, -1, &statement, nil)==SQLITE_OK){
        sqlite3_bind_text(statement, 1, [content UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [dateTime UTF8String], -1, SQLITE_TRANSIENT);
    }
    
    if(sqlite3_step(statement)!=SQLITE_DONE){
        sqlite3_finalize(statement);
        sqlite3_close(connectDB);
        NSLog(@"添加失败");
        return NO;
    }else{
        [self searchInfoFromDB];
        sqlite3_finalize(statement);
        sqlite3_close(connectDB);
        NSLog(@"添加成功");
        return YES;
    }
}

-(BOOL)excWithSql:(char *)inputsql withDataModel:(MemorandumDataModel *) dataModel{
    [self openSQLDB];
    [self initDB];
    char *sql = inputsql;
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(connectDB, sql, -1, &statement, nil)==SQLITE_OK){
        sqlite3_bind_text(statement, 1, [[dataModel content] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [[dataModel dateTime] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 3, [dataModel backupID]);
    }
    
    if(sqlite3_step(statement)!=SQLITE_DONE){
        sqlite3_finalize(statement);
        sqlite3_close(connectDB);
        NSLog(@"更新失败");
        return NO;
    }else{
        [self searchInfoFromDB];
        sqlite3_finalize(statement);
        sqlite3_close(connectDB);
        NSLog(@"更新成功");
        return YES;
    }
}


-(NSMutableArray *)searchInfoFromDB{
    [self openSQLDB];
    [self initDB];
    sqlite3_stmt *statement = nil;
    char *sql = "select * from memorandum";
    if(sqlite3_prepare_v2(connectDB, sql, -1, &statement, NULL)!=SQLITE_OK){
        NSLog(@"error");
    }
    NSMutableArray *dataList = [[NSMutableArray alloc]init];
    while(sqlite3_step(statement)==SQLITE_ROW){
        NSLog(@"查询成功");
        int backup_id = sqlite3_column_int(statement, 0);
        char *content = (char *)sqlite3_column_text(statement, 1);
        char *dateTime = (char *)sqlite3_column_text(statement, 2);
        NSString *contentStr = [[NSString alloc]initWithUTF8String:content];
       // NSString *dateTimeStr = [NSString stringWithFormat:@"%s",dateTime];
        NSString *dateTimeStr = [[NSString alloc]initWithUTF8String:dateTime];
      //  NSString *backupIDStr = [NSString stringWithFormat:@"%i",backup_id];
       /* NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:backupIDStr forKey:@"backup_id"];
        [dict setObject:contentStr forKey:@"content"];
        [dict setObject:dateTimeStr forKey:@"dateTime"];
        [dataList addObject:dict];
       */
        MemorandumDataModel *dataModel = [[MemorandumDataModel alloc]init];
        dataModel.backupID = backup_id;
        dataModel.content = contentStr;
        dataModel.dateTime = dateTimeStr;
        [dataList addObject:dataModel];
    }
    sqlite3_finalize(statement);
    sqlite3_close(connectDB);
    return dataList;
}

-(BOOL)deletInfoWithName:(int)backup_id{
    [self openSQLDB];
    [self initDB];
    NSString *sql = @"delete from memorandum where backup_id = ?;";
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(connectDB, [sql UTF8String], -1,&statement, nil)==SQLITE_OK){
        sqlite3_bind_int(statement, 1, backup_id);
        NSLog(@"backu_id=%i",backup_id);
        // sqlite3_bind_int(statement, 1, user_id, -1, SQLITE_TRANSIENT);
    }
    if(sqlite3_step(statement)!=SQLITE_DONE){
        sqlite3_finalize(statement);
        sqlite3_close(connectDB);
        NSLog(@"删除失败");
        return NO;
    }else{
        sqlite3_finalize(statement);
        sqlite3_close(connectDB);
        NSLog(@"删除成功");
        return YES;
    }
}@end
