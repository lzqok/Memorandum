//
//  MemorandumDataModel.h
//  Memorandum
//
//  Created by Empty Brain on 15/8/9.
//  Copyright (c) 2015年 www.lzqok.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemorandumDataModel : NSObject
@property (assign,nonatomic) int backupID;
@property (copy,nonatomic) NSString *content;
@property (copy,nonatomic) NSString *dateTime;
@end
