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
#import "MLNavigationController.h"
#import "DIYViewController.h"
#define Tag_LaunchView 1000

@interface HomeViewController ()


@end

@implementation HomeViewController
@synthesize subtableview;
@synthesize backLabel;
@synthesize todiylabel;
@synthesize cakedetailview;
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
//    NSArray * fontArrays = [[NSArray alloc] initWithArray:[UIFont familyNames]];
//    for (NSString * temp in fontArrays) {
//        NSLog(@"Font name  = %@", temp);
//    }
    
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
    subtableview.backgroundColor=[UIColor clearColor];
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
    {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame =  CGRectMake(0, 0, 65, 44);
        backButton.backgroundColor = [UIColor clearColor];
        [backButton addTarget:self action:@selector(todiy) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.rightBarButtonItem = backBarButton;
    }
    {
    todiylabel=[[UILabel alloc] initWithFrame:CGRectMake(8+320-80, 0, 50, 44)];
    todiylabel.text=@"DIY";
    todiylabel.textAlignment=UITextAlignmentCenter;
    todiylabel.backgroundColor=[UIColor clearColor];
    todiylabel.textColor=[UIColor whiteColor];
    todiylabel.font=[UIFont boldSystemFontOfSize:14.0f];
    [self.navigationController.navigationBar addSubview:todiylabel];
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
    [todiylabel removeFromSuperview];
}
-(void)todiy
{
    DIYViewController*view=[[DIYViewController alloc]init];
    [self.navigationController pushViewController:view animated:YES];


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
            image1.frame = CGRectMake(0, 250, 320, 1);
            [cell addSubview:image1];
    }
        
    CellChangeSelectedColor;
    {
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cellbg"] ];
    image.frame = CGRectMake(0, 0, 320, 250);
    [cell.contentView addSubview:image];
    }

       {
          UIImageView *cakeimage;
           UILabel*cakename=[[UILabel alloc]initWithFrame:CGRectMake(140, 20, 200, 60)];
           cakename.backgroundColor=[UIColor clearColor];
           cakename.textColor=[UIColor colorWithRed:0 green:182.0f/255.0f blue:193.0f/255.0f alpha:1];
           cakename.font=[UIFont fontWithName:@"RTWS DingDing Demo"  size:50];
    switch (indexPath.row) {
        case 0:
            cakeimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"起司蛋糕.jpg"] ];
            [cakename setText:@"起司蛋糕"];
//            cakedetailview.navtitle=[NSString stringWithFormat:@"起司蛋糕"];
            break;
        case 1:
            cakeimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"天使的帽子.jpg"] ];
            [cakename setText:@"天使的帽子"];
//            cakedetailview.navtitle=[NSString stringWithFormat:@"天使的帽子"];
            break;
        case 2:
            cakeimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"恶魔的帽子.jpg"] ];
            [cakename setText:@"恶魔的帽子"];

//            cakedetailview.navtitle=[NSString stringWithFormat:@"恶魔的帽子"];
            break;
        case 3:
            cakeimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"蛋糕卷.jpg"] ];
            [cakename setText:@"蛋糕卷"];
//            cakedetailview.navtitle=[NSString stringWithFormat:@"蛋糕卷"];
            break;
        case 4:
            cakeimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"起思金砖.jpg"] ];
            [cakename setText:@"起司金砖"];
//            cakedetailview.navtitle=[NSString stringWithFormat:@"起司金砖"];
            break;
        case 5:
            cakeimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"红豆起司.jpg"] ];
            [cakename setText:@"红豆起司"];

//            cakedetailview.navtitle=[NSString stringWithFormat:@"红豆起司"];
            break;
//        case 6:
//            cakeimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"爆浆蛋糕.jpg"] ];
////            cakedetailview.navtitle=[NSString stringWithFormat:@"爆浆蛋糕"];
//            break;
        case 6:
            cakeimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"卡仕达起司.jpg"] ];
            [cakename setText:@"卡仕达起司"];

//            cakedetailview.navtitle=[NSString stringWithFormat:@"卡仕达起司"];
            break;
        case 7:
            cakeimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"巧酥饼干.jpg"] ];
            [cakename setText:@"巧酥饼干"];

//            cakedetailview.navtitle=[NSString stringWithFormat:@"巧酥饼干"];
            break;
        case 8:
            cakeimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"手工鲜奶油布丁.jpg"] ];
            [cakename setText:@"手工鲜奶油布丁"];

//            cakedetailview.navtitle=[NSString stringWithFormat:@"手工鲜奶油布丁"];
            break;
        case 9:
            cakeimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"盆栽蛋糕.jpg"] ];
            [cakename setText:@"蜂蜜起司"];

//            cakedetailview.navtitle=[NSString stringWithFormat:@"盆栽蛋糕"];
            break;
            
        default:
            break;
    }
    
    cakeimage.frame = CGRectMake(5, 5, 125, 125);
        
           cakeimage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
           cakeimage.layer.masksToBounds = YES;
           cakeimage.layer.cornerRadius = 50.0;
           cakeimage.layer.borderColor = [UIColor whiteColor].CGColor;
           cakeimage.layer.borderWidth = 3.0f;
           cakeimage.layer.rasterizationScale = [UIScreen mainScreen].scale;
           cakeimage.layer.shouldRasterize = YES;
           cakeimage.clipsToBounds = YES;
           
    [cell.contentView addSubview:cakeimage];
    [cell.contentView addSubview:cakename];

    }
    
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;//result.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    cakedetailview=[[CakeDetailViewController alloc]init];
    UIImageView *cakeimage;
    switch (indexPath.row) {
        case 0:
            cakeimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"起司蛋糕.jpg"] ];
            cakedetailview.navtitle=[NSString stringWithFormat:@"起司蛋糕"];
            break;
        case 1:
            cakeimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"天使的帽子.jpg"] ];
            cakedetailview.navtitle=[NSString stringWithFormat:@"天使的帽子"];
            break;
        case 2:
            cakeimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"恶魔的帽子.jpg"] ];
            cakedetailview.navtitle=[NSString stringWithFormat:@"恶魔的帽子"];
            break;
        case 3:
            cakeimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"蛋糕卷.jpg"] ];
            cakedetailview.navtitle=[NSString stringWithFormat:@"蛋糕卷"];
            break;
        case 4:
            cakeimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"起思金砖.jpg"] ];
            cakedetailview.navtitle=[NSString stringWithFormat:@"起司金砖"];
            break;
        case 5:
            cakeimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"红豆起司.jpg"] ];
            cakedetailview.navtitle=[NSString stringWithFormat:@"红豆起司"];
            break;
//        case 6:
//            cakeimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"爆浆蛋糕.jpg"] ];
//            cakedetailview.navtitle=[NSString stringWithFormat:@"爆浆蛋糕"];
//            break;
        case 6:
            cakeimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"卡仕达起司.jpg"] ];
            cakedetailview.navtitle=[NSString stringWithFormat:@"卡仕达起司"];
            break;
        case 7:
            cakeimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"巧酥饼干.jpg"] ];
            cakedetailview.navtitle=[NSString stringWithFormat:@"巧酥饼干"];
            break;
        case 8:
            cakeimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"手工鲜奶油布丁.jpg"] ];
            cakedetailview.navtitle=[NSString stringWithFormat:@"手工鲜奶油布丁"];
            break;
        case 9:
            cakeimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"盆栽蛋糕.jpg"] ];
            cakedetailview.navtitle=[NSString stringWithFormat:@"蜂蜜起司"];
            break;
            
        default:
            break;
    }
    cakedetailview.cakeimg=cakeimage;
    [self.navigationController pushViewController:cakedetailview animated:YES];

}

@end
