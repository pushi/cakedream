//
//  HomeViewController.m
//  cakedream
//
//  Created by cui yansong on 14-5-13.
//  Copyright (c) 2014年 pushi. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "TestViewController.h"
#import "CakeDetailViewController.h"
#import "MLNavigationController.h"

#define Tag_LaunchView 1000

@interface HomeViewController ()


@end

@implementation HomeViewController
@synthesize subtableview;
@synthesize backLabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame =  CGRectMake(0, 0, 65, 44);
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:(MLNavigationController *)self.navigationController action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButton;
    }

    [self LoadLauchView];
}
-(void)LoadLauchView
{

    {
        UIImageView* launchView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"启动界面底图"]];
//    if (IOS7) {
//        CGRect f=self.view.frame;
//        f.origin.y+=20;
//        f.size.height-=20;
//        launchView.frame=f;
//    }else{
//        CGSize s=self.view.frame.size;
//        launchView.frame=CGRectMake(0, 0, s.width, s.height);
//    }
    launchView.tag=Tag_LaunchView;
    [self.view addSubview:launchView];
    }
    
    
    {
    subtableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-44-24)
 style:UITableViewStylePlain];
    subtableview.delegate=self;
    subtableview.dataSource=self;
    subtableview.scrollEnabled=YES;
    subtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:subtableview];
    }
    
    
//    UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//    btn.backgroundColor=[UIColor redColor];
//    [btn addTarget:self action:@selector(theNext) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview: btn];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    ((MLNavigationController*)self.navigationController).titleLabel.text=@"CakeDream";
    backLabel=[[UILabel alloc] initWithFrame:CGRectMake(8, 0, 50, 44)];
    backLabel.text=@"主菜单";
    backLabel.textAlignment=UITextAlignmentCenter;
    backLabel.backgroundColor=[UIColor clearColor];
    backLabel.textColor=[UIColor whiteColor];
    backLabel.font=[UIFont boldSystemFontOfSize:14.0f];
    [self.navigationController.navigationBar addSubview:backLabel];


    {
//        UILabel* titlelabel=[(MLNavigationController*)self.navigationController backLabel];
//        CGRect f = titlelabel.frame;
//        f.origin.x=10;
//        titlelabel.frame=f;
//        titlelabel.text=@"Cake";
       
    }

}
//-(void)theNext
//{
////    AppDelegate*delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//    TestViewController*test=[[TestViewController alloc]init];
//    [self.navigationController pushViewController:test animated:YES];
//    
//}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [backLabel removeFromSuperview];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* titleCellIdentifier = [NSString stringWithFormat:@"cell:%d_%d",indexPath.section,indexPath.row];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:titleCellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:titleCellIdentifier];
	}else{
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    {
            UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"] ];
            image.frame = CGRectMake(0, 0, 320, 1);
            [cell addSubview:image];
            UIImageView *image1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"] ];
            image1.frame = CGRectMake(0, 120, 320, 1);
            [cell addSubview:image1];
    }
        
    CellChangeSelectedColor;
    
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;//result.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CakeDetailViewController*view=[[CakeDetailViewController alloc]init];
    view.navtitle=[NSString stringWithFormat:@"Cake详情"];
    [self.navigationController pushViewController:view animated:YES];

}
@end
