//
//  HomeViewController.h
//  cakedream
//
//  Created by cui yansong on 14-5-13.
//  Copyright (c) 2014年 pushi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView*subtableview;
@property(strong,nonatomic) UILabel* backLabel;
@end
