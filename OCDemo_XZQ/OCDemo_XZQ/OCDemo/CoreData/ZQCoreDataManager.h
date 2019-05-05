//
//  ZQCoreDataManager.h
//  OCDemo_XZQ
//
//  Created by 项正强 on 2018/1/12.
//  Copyright © 2018年 项正强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface ZQCoreDataManager : NSObject
+(ZQCoreDataManager *)shareInstance;
/**
 管理上下文
 */
@property(nonatomic,strong)NSManagedObjectContext *managedObjectContext;
/**
 模型对象
 */
@property(nonatomic,strong)NSManagedObjectModel *managedObjectModel;
/**
 存储调度器
 */
@property(nonatomic,strong)NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 保存操作
 */
-(void)save;
@end
