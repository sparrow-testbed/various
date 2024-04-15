//
/**
* 所属系统: component
* 所属模块:
* 功能描述:
* 创建时间: 2020/9/16
* 维护人:  王伟
* Copyright © 2020 杰人软件. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JROptionModuleViewController.h"
#import "JROptionsTableViewCell.h"
#import "JRUIKit.h"

static NSInteger bgViewTag = 1000;
static NSString *selectAll = @"全选";
@interface JROptionModuleViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,JRSearchViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
//搜索结果数组
@property(nonatomic,strong)NSMutableArray *searchArray;
//选中数组 下标
@property(nonatomic,strong)NSMutableArray *selectArray;
//确定按钮
@property(nonatomic,strong)UIButton *nextBtn;
//头部搜索框
@property (nonatomic,strong)UIView *tableHeaderView;

@property (nonatomic,strong)JRSearchView *searchView;

@property (nonatomic,strong)UILabel *hasChooseLabel;
@end

@implementation JROptionModuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor colorWithHex:@"0x000000"] colorWithAlphaComponent:0.6f];
    
    [self.selectArray removeAllObjects];
    [self.defaultList enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *keyString = [obj valueForKey:self.key];
        [self.selectArray addObject:keyString];
    }];
    [self analysisDataSource:[NSString string]];
    
    CGFloat height = 58*2 + 44*self.dataSource.count;
    BOOL scrollerEnable = NO;
    if (self.options == NO && self.isShowEnter == NO) {
        height = 58 + 26 + 44*self.dataSource.count;
    }
    if (height > SCREEN_HEIGHT*0.8) {
        scrollerEnable = YES;
        height = SCREEN_HEIGHT*0.8;
    }
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:cancleBtn];
    cancleBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    if (self.isCancle) {
        [cancleBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT, SCREEN_WIDTH-20, height)];
    bgView.tag = bgViewTag;
    [self.view addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 4;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(28, 26, SCREEN_WIDTH-100, 16)];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [bgView addSubview:titleLabel];
    titleLabel.textColor = [UIColor colorWithHex:@"#000000"];
    titleLabel.text = self.titleStr;
    
    if (self.isCheckAll || self.options) {
        [bgView addSubview:self.hasChooseLabel];
        [self.hasChooseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(titleLabel.mas_centerY);
            make.right.mas_equalTo(-25);
        }];
    }
    
    if (self.options == YES || self.isShowEnter == YES ) {
        self.nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [bgView addSubview:self.nextBtn];
        self.nextBtn.frame = CGRectMake((SCREEN_WIDTH-80)/2-10, bgView.frame.size.height-58+9, 80, 40);
        [self.nextBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.nextBtn setTitleColor:[UIColor colorWithHex:@"#0EA856"] forState:UIControlStateNormal];
        self.nextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self.nextBtn addTarget:self action:@selector(nextOption:) forControlEvents:UIControlEventTouchUpInside];
        if (self.defaultList.count > 0) {
            self.nextBtn.enabled = YES;
            self.nextBtn.alpha = 1;
        }else{
            self.nextBtn.enabled = NO;
            self.nextBtn.alpha = 0.3;
        }
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 58, SCREEN_WIDTH-20, height-116) style:UITableViewStylePlain];
    }else{
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 58, SCREEN_WIDTH-20, height- 60) style:UITableViewStylePlain];
    }
    
    [bgView addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.scrollEnabled = scrollerEnable;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    if (self.dataSource.count > 10) {
        self.tableView.tableHeaderView = self.tableHeaderView;
    }
    if (self.selectArray.count > 0 &&!scrollerEnable) {
        NSString *name = self.selectArray.firstObject;
        __block NSUInteger toRow = 0;
        [self.dataSource enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *keyString = [obj valueForKey:self.key];
            if ([keyString isEqualToString:name]) {
                toRow = idx;
                *stop = YES;
            }
        }];
        [self.tableView reloadData];
        [self.tableView layoutIfNeeded];
//        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:toRow inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
//        });
    }
    [[[[UIApplication sharedApplication] delegate] window] endEditing:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect backFrame = CGRectMake(10, SCREEN_HEIGHT-31-height, SCREEN_WIDTH-20, height);
        bgView.frame = backFrame;
    }];
    
    UISwipeGestureRecognizer * recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];

}
//解析是否添加全选按钮
- (void)analysisDataSource:(NSString *)searchKey{
    [self.searchArray removeAllObjects];
    //过滤数据
    if (searchKey.length) {
        for (NSDictionary *params in self.dataSource) {
            NSString *keyString = [params valueForKey:self.key];
            if ([keyString containsString:searchKey]) {
                [self.searchArray addObject:params];
            }
        }
    }else{
        [self.searchArray addObjectsFromArray:self.dataSource];
    }
    //如果搜索有结果
    if (self.searchArray.count) {
        //是否支持全选
        if (self.isCheckAll) {
            __block BOOL needAddAll = YES;
            [self.searchArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *keyString = [obj valueForKey:self.key];
                if (![self.selectArray containsObject:keyString]) {
                    needAddAll = NO;
                }
            }];
            if (needAddAll) {
                [self.selectArray addObject:selectAll];
            }else{
                [self.selectArray removeObject:selectAll];

            }
            NSMutableArray *sourceArray = [NSMutableArray arrayWithArray:self.searchArray];
            NSDictionary *keyValue = @{self.key:selectAll};
            [sourceArray insertObject:keyValue atIndex:0];
            self.searchArray = sourceArray;
        }else{
            if (self.selectArray.count == self.dataSource.count) {
                [self.selectArray addObject:selectAll];
            }
        }
    }
    if (self.searchArray.count) {
        [JRNoDataView hidNodataWithSuperView:self.view];
    }
    else{
        [JRNoDataView showNodataWithSuperView:self.view noDataImageName:nil noDataTitle:nil];
    }
    
    [self.tableView reloadData];
    [self changNextButtonStatus];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer*)recognizer{
    NSMutableArray *array = [NSMutableArray new];
    self.block(array,true);
    [self.view removeFromSuperview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"OptionsCell";
    JROptionsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[JROptionsTableViewCell alloc] initWithReuseIdentifier:ID];
    }
    if (indexPath.row < self.searchArray.count - 1) {
        cell.line.hidden = NO;
    }else{
        cell.line.hidden = YES;
    }
    cell.selectImage.tag = indexPath.row;
    //刷新cell
    NSDictionary *dic = [self.searchArray objectAtIndex:indexPath.row];
    NSString *value = [dic objectForKey:self.key];
    [cell updateView:value withOptions:self.options withidx:indexPath.row withSelect:self.selectArray.copy];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断是否是多选
    NSDictionary *dic = [self.searchArray objectAtIndex:indexPath.row];
    NSString *value = [dic objectForKey:self.key];
    if (self.options) {
        //如果包含全选状态
        if (self.isCheckAll) {
            //            如果点击全选按钮
            if (indexPath.row == 0) {
                if ([self.selectArray containsObject:value]) {
                    if (self.searchArray.count >= self.dataSource.count) {
                        //删除已选项
                        [self.selectArray removeAllObjects];
                    }else{
                        [self.searchArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            [self.selectArray removeObject:[obj valueForKey:self.key]];
                        }];
                    }
                }else{
                    if (self.searchArray.count >= self.dataSource.count) {
                        [self.selectArray removeAllObjects];
                    }
                    //所有数据添加到选中数组
                    [self.searchArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString *value = [obj valueForKey:self.key];
                        if (![self.selectArray containsObject:value]) {
                            [self.selectArray addObject:value];
                        }
                    }];
                }
            }
            else{
                NSDictionary *allKeyDic = [self.searchArray firstObject];
                NSString *allSelectValue = [allKeyDic objectForKey:self.key];
                //如果当前按钮之前已选 则改为未选 并且将全选按钮置为未选
                if ([self.selectArray containsObject:value]) {
                    [self.selectArray removeObject:value];
                    [self.selectArray removeObject:allSelectValue];
                    
                }else{
                    //                    如果当前按钮之前未选 则改为已选
                    [self.selectArray addObject:value];
                    __block BOOL addAllSelectValue = YES;
                    [self.searchArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString *value = [obj valueForKey:self.key];
                        if (![self.selectArray containsObject:value]&&![value isEqualToString:selectAll]) {
                            addAllSelectValue = NO;
                            *stop = YES;
                        }
                        
                    }];
                    if (addAllSelectValue) {
                        [self.selectArray addObject:allSelectValue];
                    }
                }
            }
            
        }else{
            if ([self.selectArray containsObject:value]) {
                [self.selectArray removeObject:value];
            }else{
                [self.selectArray addObject:value];
            }
        }
    }else{
        //单选，先移除后添加
        [self.selectArray removeAllObjects];
        [self.selectArray addObject:value];
        [self getSelectArrayData];
    }
    [self.tableView reloadData];
    
    [self changNextButtonStatus];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *searchKey = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self analysisDataSource:searchKey];
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self analysisDataSource:nil];
    return YES;
}

- (void)changNextButtonStatus{
    if (self.selectArray.count ) {
        self.nextBtn.enabled = YES;
        self.nextBtn.alpha = 1;
        NSInteger count = self.selectArray.count;
        if ([self.selectArray containsObject:selectAll]) {
            count -= 1;
        }
        if (!count) {
            self.nextBtn.enabled = NO;
            self.nextBtn.alpha = 0.3;
            self.hasChooseLabel.text  = nil;
        }else{
            self.hasChooseLabel.text = [NSString stringWithFormat:@"已选择%ld个",count];
        }

    }else{
        self.nextBtn.enabled = NO;
        self.nextBtn.alpha = 0.3;
        self.hasChooseLabel.text  = nil;
    }
}

//选中后的确定操作
- (void)nextOption:(UIButton*)sender{
    //block回调同时释放控制器
    [self getSelectArrayData];
}

- (void)getSelectArrayData {
    NSMutableArray *array = [NSMutableArray new];
    [self.selectArray enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataSource enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx1, BOOL * _Nonnull stop1) {
            NSString *value = [dic objectForKey:self.key];
            if ([name isEqualToString:value]) {
                [array addObject:dic];
                *stop1 = YES;
            }
        }];
    }];
    self.block(array,false);
    
    [self performSelector:@selector(removeView:) withObject:nil afterDelay:0.2];
}

- (void)removeView:(UIButton *)sender {
    [self.view removeFromSuperview];
}

- (void)cancleAction{
    [self.view removeFromSuperview];
//    NSMutableArray *array = [NSMutableArray new];
//    self.block(array,false);
}

- (UIView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 45)];
        [_tableHeaderView addSubview:self.searchView];
    }
    return _tableHeaderView;
}

- (JRSearchView *)searchView{
    if (!_searchView) {
        _searchView = [[JRSearchView alloc] initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH - 43, 45)];
        _searchView.searchType = JRSearchTypeGray;
        _searchView.searchBar.delegate = self;
    }
    return _searchView;
}

- (NSMutableArray *)searchArray{
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

- (NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (UILabel *)hasChooseLabel{
    if (!_hasChooseLabel) {
        _hasChooseLabel = [[UILabel alloc] init];
        _hasChooseLabel.textColor = [UIColor colorWithHex:@"#666666"];
        _hasChooseLabel.font = [UIFont systemFontOfSize:15];
    }
    return _hasChooseLabel;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
