//
//  SuperTableViewController.m
//  kaoyanbao
//
//  Created by 袁 章敬 on 13-11-8.
//  Copyright (c) 2013年 袁 章敬. All rights reserved.
//

#import "SuperTableViewController.h"
#define Tag_SectionHeader 700  //700~799的tag值禁止使用
@interface SuperTableViewController ()
{}

@end

@implementation SuperTableViewController
@synthesize subTableView;
@synthesize openSectionIndex;
@synthesize withSectionHeader;
@synthesize titleArray;
@synthesize sectionArray;
@synthesize records;
//@synthesize q;
//@synthesize array1;
//@synthesize array2;
@synthesize recorddisplay;
//@synthesize searchBar;

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
    self.openSectionIndex=-1; //正在打开的表格的section  没有则为-1
    if (self.withSectionHeader){
        self.sectionArray=[[NSMutableArray alloc] init];//如果带有section header，则初始化sectionArray，用来存储每个section的数组。数组的数组，相当于一个矩阵。
    }
    self.subTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460+SCREEN_INCREMENT-50) style:UITableViewStylePlain];
    self.subTableView.delegate=self;
    self.subTableView.dataSource=self;
    [self setExtraCellLineHidden:self.subTableView];
    [self.view addSubview:self.subTableView];
   
 
   // self.q.searchBar.showsScopeBar = YES;
    
    // searchBar.keyboardType=UIKeyboardTypeAlphabet;
   // searchBar.tag=TAG_SEARCHBAR;
   // searchBar.placeholder=[NSString stringWithCString:"请输入导师名、拼音"  encoding: NSUTF8StringEncoding];
  // self.subTableView.tableHeaderView=searchBar;
    //self.searchBar.hidden=YES;
    //CGRect frame=CGRectMake(0, 0, 320, 460+SCREEN_INCREMENT-50);
    //self.q.searchResultsTableView.frame=frame;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.subTableView deselectRowAtIndexPath:[self.subTableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setExtraCellLineHidden:(UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor=[UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark tableviewdatasource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* titleCellIdentifier = [NSString stringWithFormat:@"cell:%d_%d",indexPath.section,indexPath.row];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:titleCellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:titleCellIdentifier];
	}else{
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    if (self.withSectionHeader) {
        cell.textLabel.text=[[sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    } else{
    cell.textLabel.text=[NSString stringWithFormat:@"row=%d section=%d",indexPath.row,indexPath.section];
    }
    CellChangeSelectedColor;
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.withSectionHeader?sectionArray.count:1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.withSectionHeader) {
        if (self.openSectionIndex==-1) {
            return 0;
        }else{
            DebugLog(@"%d",[(SectionHeaderView*)[self.view viewWithTag:section+Tag_SectionHeader] open]);
            return [(SectionHeaderView*)[self.view viewWithTag:section+Tag_SectionHeader] open]?((NSArray*)[sectionArray objectAtIndex:section]).count:0;
        }
    }
   
    else{
        return 15;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.withSectionHeader?40:0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.withSectionHeader) {
        if ([self.view viewWithTag:section+Tag_SectionHeader]==nil) {
            SectionHeaderView* iv=[[SectionHeaderView alloc] init];
            iv.tag=section+Tag_SectionHeader;
            iv.delegate=self;
            iv.titleLabel.text=[titleArray objectAtIndex:section];
            iv.section=section;
            return iv;
        }else{
            return [self.view viewWithTag:section+Tag_SectionHeader];
        }
    }else{
        return nil;
    }
}

#pragma mark sectionheaderview delegate
-(void)sectionHeaderView:(SectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)section{
    
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [[sectionArray objectAtIndex:section] count]; i++) {
        NSLog(@"sectionArray  %d",[[sectionArray objectAtIndex:section] count]);
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    
    
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    if (self.openSectionIndex>=0) {
        [(SectionHeaderView*)[self.view viewWithTag:self.openSectionIndex+Tag_SectionHeader] toggleOpenWithUserAction:NO];
        for (NSInteger i = 0; i < [self.subTableView numberOfRowsInSection:self.openSectionIndex]; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:self.openSectionIndex]];
        }
    }
    
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (section<self.openSectionIndex||self.openSectionIndex==-1) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    self.openSectionIndex=section;
    // Apply the updates.
    [self.subTableView beginUpdates];
    [self.subTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.subTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.subTableView endUpdates];
}
-(void)sectionHeaderView:(SectionHeaderView *)sectionHeaderView sectionClosed:(NSInteger)section{
    
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [self.subTableView numberOfRowsInSection:self.openSectionIndex]; i++) {
        [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (section<self.openSectionIndex||self.openSectionIndex==-1) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // Apply the updates.
    [self.subTableView beginUpdates];
    [self.subTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.subTableView endUpdates];
    self.openSectionIndex=-1;
}




@end