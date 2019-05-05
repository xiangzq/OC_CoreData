//
//  AppDelegate.h
//  OCDemo_XZQ
//
//  Created by 项正强 on 2018/1/12.
//  Copyright © 2018年 项正强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong,readonly)NSManagedObjectContext *managedObjectContext;
@property(nonatomic,strong,readonly)NSManagedObjectModel *managedObjectModel;
@property(nonatomic,strong,readonly)NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

