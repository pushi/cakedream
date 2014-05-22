//
//  DEMOMenuViewController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOMenuViewController.h"
#import "HomeViewController.h"
#import "TestViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "DIYViewController.h"
@implementation DEMOMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled=YES;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"show1.jpg"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        label.text = @"CakeDream";
        label.font = [UIFont fontWithName:@"RTWS DingDing Demo" size:30];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        UIImageView*img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menubackground"]];
        img.frame=CGRectMake(0, 20, 320, 164);
        [view addSubview:img];

        [view addSubview:imageView];
        [view addSubview:label];
        
        view;
    });
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
   cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:0 green:182.0f/255.0f blue:193.0f/255.0f alpha:1];
    cell.textLabel.font = [UIFont fontWithName:@"RTWS DingDing Demo" size:35];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"系统操作";
    label.font = [UIFont fontWithName:@"RTWS DingDing Demo" size:30];
    label.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        HomeViewController *homeViewController = [[HomeViewController alloc] init];
        navigationController.viewControllers = @[homeViewController];
    }else if(indexPath.section==0&&indexPath.row==3)
    {
       DIYViewController *cakedetail=[[DIYViewController alloc]init];
        navigationController.viewControllers=@[cakedetail];
    }
    else {
        TestViewController *secondViewController = [[TestViewController alloc] init];
        navigationController.viewControllers = @[secondViewController];
    }
    
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if(sectionIndex==0)
        return 4;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
	}else{
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    if (indexPath.section == 0) {
        NSArray *titles = @[@"主页", @"积分换礼", @"天天折扣", @"私人定制DIY"];
        cell.textLabel.text = titles[indexPath.row];
        if(indexPath.row==1||indexPath.row==3)
        {
            cell.contentView.backgroundColor=[UIColor colorWithRed:1 green:182.0f/255.0f blue:193.0f/255.0f alpha:1];
        }

    } else {
        NSArray *titles = @[@"设置", @"收藏"];
        cell.textLabel.text = titles[indexPath.row];
        if(indexPath.row==1)
        {
            cell.contentView.backgroundColor=[UIColor colorWithRed:1 green:182.0f/255.0f blue:193.0f/255.0f alpha:1];
        }

    }
    CellChangeSelectedColor;
        return cell;
}

@end
