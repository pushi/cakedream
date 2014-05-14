//
//  TestViewController.m
//  cakedream
//
//  Created by cui yansong on 14-5-13.
//  Copyright (c) 2014年 pushi. All rights reserved.
//

#import "TestViewController.h"
#import "DataStructure.h"
#import "NetWorkRequest.h"

@interface TestViewController ()

@end

@implementation TestViewController

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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIButton* button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(100, 100, 200, 50);
    [button setTitle:@"push" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self startLoad:@"加载中"];

}
-(void)loadDataFromServer{
    ResultData* result;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"9.2" ofType:@"json"];

    @try {
        
         result=[[ResultData alloc] initWithUrlData:[NSData dataWithContentsOfFile:path]];

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        DebugLog(@"aa%d",result.dataType);
    }
    if (self==self.navigationController.topViewController) {//判断当前页面是否消失
        DebugLog(@"页面正常，执行后续操作！");
    }else{
        DebugLog(@"页面消失，停止后续操作！");
    }
}

-(void)touchup{
    TestViewController* c=[[TestViewController alloc] init];
    [self.navigationController pushViewController:c animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

@end
