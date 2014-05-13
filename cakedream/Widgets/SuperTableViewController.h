//
//  SuperTableViewController.h
//  kaoyanbao
//
//  Created by 袁 章敬 on 13-11-8.
//  Copyright (c) 2013年 袁 章敬. All rights reserved.
//

#import "SuperViewController.h"
#import "SectionHeaderView.h"
//#import "mySearchDisplayController.h"
@interface SuperTableViewController : SuperViewController<UITableViewDataSource,UITableViewDelegate,SectionHeaderViewDelegate>
@property (strong,nonatomic) UITableView* subTableView;
@property (nonatomic) BOOL withSectionHeader;
@property (strong,nonatomic) NSArray* titleArray;
@property (strong,nonatomic) NSMutableArray* sectionArray;
@property (strong,nonatomic) NSArray* records;
//@property (strong,nonatomic) UISearchDisplayController* q;
//@property (strong,nonatomic) UISearchBar* searchBar;
//@property (strong,nonatomic) NSArray* array1;
//@property (strong,nonatomic) NSArray* array2;
@property (strong,nonatomic) NSMutableArray* recorddisplay;
@property (nonatomic) NSInteger openSectionIndex;
@end
