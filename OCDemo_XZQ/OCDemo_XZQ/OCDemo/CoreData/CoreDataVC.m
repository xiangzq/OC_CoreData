//
//  ViewController.m
//  NewCoreData
//
//  Created by 项正强 on 2018/1/11.
//  Copyright © 2018年 项正强. All rights reserved.
//

#import "CoreDataVC.h"
#import "Student+CoreDataClass.h"
#import "ZQCoreDataManager.h"
@interface CoreDataVC ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) UITableView *myTable;
@property (strong, nonatomic) NSMutableArray *dataSourse;
@property(nonatomic,strong)NSFetchedResultsController *fetchedResultController;
@end

@implementation CoreDataVC
-(NSFetchedResultsController *)fetchedResultController{
    if (!_fetchedResultController) {
        NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Student"];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:true];
        request.sortDescriptors = @[sort];
        _fetchedResultController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:[ZQCoreDataManager shareInstance].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultController.delegate = self;
        [_fetchedResultController performFetch:nil];
    }
    return _fetchedResultController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"CoreData";
    [self createBtns];
    [self.view addSubview:self.myTable];
}

-(void)addAction{
    //读取所有学生的实体
    Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:[ZQCoreDataManager shareInstance].managedObjectContext];
    student.age = arc4random() % 20 + 15 ;
    student.sex = arc4random() % 2 == 0 ? 1 : 0;
    student.name = [NSString stringWithFormat:@"%d",arc4random() % 50];
    [[ZQCoreDataManager shareInstance] save];
}
-(void)deleteAction{
    //读取所有学生的实体
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:[ZQCoreDataManager shareInstance].managedObjectContext];
    //创建请求
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    //创建条件 年龄 = 10 的学生
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age=10"];
    [request setPredicate:predicate];
    //获取符合条件的结果
    NSArray *resultArray = [[ZQCoreDataManager shareInstance].managedObjectContext executeFetchRequest:request error:nil];
    if (resultArray.count > 0) {
        for (Student *stu in resultArray) {
            //删除实体
            [[ZQCoreDataManager shareInstance].managedObjectContext deleteObject:stu];
        }
        //保存结果
        [[ZQCoreDataManager shareInstance] save];
        NSLog(@"删除年龄为10的学生完成");
    }else{
        NSLog(@"没有符合条件的结果");
    }
    
}
-(void)updateAction{
    //读取所有学生的实体
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student"            inManagedObjectContext:[ZQCoreDataManager shareInstance].managedObjectContext];
    //创建请求
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    //创建条件 年龄 > 10 的学生
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age>10"];
    [request setPredicate:predicate];
    //获取符合条件的结果
    NSArray *resultArray = [[ZQCoreDataManager shareInstance].managedObjectContext executeFetchRequest:request error:nil];
    if (resultArray.count > 0) {
        for (Student *stu in resultArray) {
            //把年龄 * 2 岁
            stu.age = stu.age * 2;
            //并且把名字添加一个已改名
            stu.name = [NSString stringWithFormat:@"已改名：%@",stu.name];
        }
        //保存结果
        [[ZQCoreDataManager shareInstance] save];
        NSLog(@"修改学生信息完成");
    }else{
        NSLog(@"没有符合条件的结果");
    }
}
-(void)selectAtion{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:[ZQCoreDataManager shareInstance].managedObjectContext];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:true];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.sortDescriptors = @[sort];
    request.entity = entity;
    NSArray *arr = [[ZQCoreDataManager shareInstance].managedObjectContext executeFetchRequest:request error:nil];
    for (Student *stu in arr) {
        NSLog(@"查询到一个学生 名字是:%@ 性别是:%@ 年龄是:%hd",stu.name,stu.sex == YES ? @"男":@"女",stu.age);
    }
    [self.dataSourse addObjectsFromArray:arr];
}


-(void)createBtns{
    NSArray *butsNameArray = @[@"增",@"删",@"改",@"查"];
    int butW = 50;
    for (int i = 0; i < butsNameArray.count; i++) {
        ///btn name
        NSString * btnName = butsNameArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * butW + 10 * i, 50, butW, butW);
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button setTitle:btnName forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(clickBtnAction:)
         forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1000 + i;
        [self.view addSubview:button];
    }
}

-(void)clickBtnAction:(UIButton *)btn{
    NSInteger tag = btn.tag - 1000;
    switch (tag) {
        case 0:
            [self addAction];       //增
            break;
        case 1:
            [self deleteAction];    //删
            break;
        case 2:
            [self updateAction];    //改
            break;
        case 3:
            [self selectAtion];     //查
            
        default:
            break;
    }
}

- (UITableView *)myTable{
    if (!_myTable) {
        _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 100) style:UITableViewStylePlain];
        _myTable.delegate = self;
        _myTable.dataSource = self;
        _myTable.rowHeight = 50;
    }
    return _myTable;
}
- (NSMutableArray *)dataSourse{
    if (!_dataSourse) {
        _dataSourse = [NSMutableArray array];
    }
    return _dataSourse;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id <NSFetchedResultsSectionInfo> info = self.fetchedResultController.sections[section];
    return [info numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    Student *stu = [self.fetchedResultController objectAtIndexPath:indexPath];;
    cell.textLabel.text = [NSString stringWithFormat:@"姓名:学生%@ 性别:%@ 年龄:%hd",stu.name,stu.sex == YES ? @"男":@"女",stu.age];
    
    return cell;
}

//删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Student *contact = [self.fetchedResultController objectAtIndexPath:indexPath];
        //删除数据
        [[ZQCoreDataManager shareInstance].managedObjectContext deleteObject:contact];
        //保存结果
        [[ZQCoreDataManager shareInstance] save];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

//NSFetchedResultsController代理，当数据有变化时，会调用该函数
-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    switch (type) {
            //新增或插入数据时
        case NSFetchedResultsChangeInsert:{
            [self.myTable beginUpdates];
            [self.myTable insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.myTable reloadData];
            [self.myTable endUpdates];
        }
            break;
            //删除数据时
        case NSFetchedResultsChangeDelete:{
            [self.myTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        }
            break;
            //修改数据时
        case NSFetchedResultsChangeUpdate:{
            [self.myTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
            //移动数据时
        case NSFetchedResultsChangeMove:{
            [self.myTable moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
        }
            break;
            
        default:
            break;
    }
    
}
























- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

