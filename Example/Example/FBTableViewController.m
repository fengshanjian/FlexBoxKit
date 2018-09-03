//
//  FBTableViewController.m
//  FBLayout
//
//  Created by 沈强 on 2017/1/11.
//  Copyright © 2017年 qiang.shen. All rights reserved.
//

#import "FBTableViewController.h"
#import "FBFeedModel.h"
#import "FlexBoxKit.h"
#import "FBKFeedView.h"
#import "FBFPSGraph.h"


@interface FBTableViewController ()

@property(nonatomic, strong)NSMutableArray *feeds;

@property(nonatomic, strong)NSMutableArray<NSMutableArray *> *sections;

@end

@implementation FBTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIRefreshControl *refreshControl = [UIRefreshControl new];
  [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
  self.refreshControl = refreshControl;
  FBFPSGraph *graph =  [[FBFPSGraph alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 30)
                               color:[UIColor lightGrayColor]];
  [[UIApplication sharedApplication].keyWindow addSubview:graph];
  [self loadData];
}

- (void)refresh {
  [self loadData];
  [self.refreshControl endRefreshing];
}

- (void)loadData {
  NSString *dataFilePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
  NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
  NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
  NSArray *feedDicts = rootDict[@"feed"];
  
  _feeds = @[].mutableCopy;
  
  [feedDicts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [_feeds addObject:[[FBFeedModel alloc] initWithDictionary:obj]];
  }];
  
  _sections = [NSMutableArray arrayWithCapacity:1];
  [_sections addObject:_feeds];
  
  __weak typeof(self)weakSelf = self;
  
  [self.tableView fb_setCellContnetViewBlockForIndexPath:^UIView *(NSIndexPath *indexPath) {
    return [[FBKFeedView alloc]initWithModel:weakSelf.sections[indexPath.section][indexPath.row]];
  }];
  
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.sections[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self.tableView fb_heightForIndexPath:indexPath];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self.tableView fb_cellForIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row%2==0) {
    [_sections insertObject:_feeds atIndex:indexPath.section];
    [tableView insertSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
  } else {
    [_sections removeObjectAtIndex:indexPath.section];
    [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
  }

}

@end
