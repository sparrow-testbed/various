//
//  JRRefreshTableViewController.m
//  JRPodPrivate_Example
//
//  Created by 金煜祥 on 2021/4/9.
//  Copyright © 2021 wni. All rights reserved.
//

#import "JRRefreshTableViewController.h"
#import "JRRefreshHeader.h"
#import "JRRefreshFooter.h"
@interface JRRefreshTableViewController ()

@property (nonatomic,strong)NSMutableArray * dataArray;
//@property (nonatomic,assign)BOOL loadMore;
@end

@implementation JRRefreshTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray new];
    for (NSInteger i = 0; i < 20; i++) {
        [_dataArray addObject:@(i)];
    }
    
    self.tableView.mj_header = [JRRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [JRRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)loadNewData {
    
  
    [self.tableView.mj_header performSelector:@selector(endRefreshing) withObject:nil afterDelay:2];
    
}

- (void)loadMoreData {
    
    self.dataArray = [NSMutableArray new];
    for (NSInteger i = 0; i < 10; i++) {
        [_dataArray addObject:@(i)];
    }
//    [self.tableView.mj_footer performSelector:@selector(endRefreshing) withObject:nil afterDelay:2];
    [self.tableView.mj_footer performSelector:@selector(endRefreshingWithNoMoreData) withObject:nil afterDelay:2];
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    NSNumber * i =[_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [i stringValue];
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
