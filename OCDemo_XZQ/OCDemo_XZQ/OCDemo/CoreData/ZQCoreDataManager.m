//
//  ZQCoreDataManager.m
//  OCDemo_XZQ
//
//  Created by 项正强 on 2018/1/12.
//  Copyright © 2018年 项正强. All rights reserved.
//

#import "ZQCoreDataManager.h"
static ZQCoreDataManager *manager = nil;
@implementation ZQCoreDataManager
+(ZQCoreDataManager *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZQCoreDataManager alloc]init];
    });
    return manager;
}

//获取数据库的路径
-(NSURL *)getDocumnetUrlpath{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(NSManagedObjectContext *)managedObjectContext{
    if (!_managedObjectContext) {
        /**
         参数:CoreData环境线程
         NSMainQueueConcurrencyType:主线程       储存无延迟
         NSPrivateQueueConcurrencyType:分支线程  存储有延迟
         */
        _managedObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
        //设置存储调度器
        _managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    return _managedObjectContext;
}

-(NSManagedObjectModel *)managedObjectModel{
    if (!_managedObjectModel) {
        /**
         初始化NSManagedObjectModel
         参数是:模型文件的路径
         后缀不能是xcdatamodeld  只能是momd
         _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Teacher" withExtension:@"momd"]];
         
         参数是模型文件的bundle数组  如果是nil  自动获取所有bundle的模型文件
         */
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    return _managedObjectModel;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    if (!_persistentStoreCoordinator) {
        /**
         参数：要存储的模型
         */
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.managedObjectModel];
        
        /**
         参数：
         * type:一般使用数据库存储方式NSSQLiteStoreType
         * configuration:配置信息  一般无需配置
         * URL:要保存的文件路径
         * options:参数信息 一般无需设置
         */
        NSURL *url = [[self getDocumnetUrlpath] URLByAppendingPathComponent:@"sqlit.db" isDirectory:true];
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:nil];
    }
    return _persistentStoreCoordinator;
}

-(void)save{
    [self.managedObjectContext save:nil];
}

@end
