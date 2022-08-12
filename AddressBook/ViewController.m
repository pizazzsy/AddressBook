//
//  ViewController.m
//  AddressBook
//
//  Created by Mac on 2022/8/12.
//

#import "ViewController.h"
#import "NSString+SYUtil.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong)UISearchBar * searchBar;

@property(nonatomic,strong)NSArray * groupArr;
@property(nonatomic,strong)NSArray * addressBookArr;
@property(nonatomic,strong)NSDictionary * addressBookDic;


@end

@implementation ViewController
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-80) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 60;
    }
    return _tableView;
}
-(UISearchBar *)searchBar
{
    if (!_searchBar) {
        self.searchBar = [[UISearchBar alloc] init];
        _searchBar.backgroundColor = [UIColor whiteColor];
        _searchBar.placeholder = @"搜索";
        _searchBar.backgroundImage = [[UIImage alloc] init];
        _searchBar.delegate = self;
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:@"搜索"];
    }
    return _searchBar;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self initData];
}
-(void)creatUI{
    [self.view addSubview:self.tableView];
    [self.searchBar setFrame:CGRectMake(0, 20, self.view.frame.size.width, 60)];
    [self.view addSubview:self.searchBar];
}
-(void)initData{
    self.groupArr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    self.addressBookArr = @[@"张三",@"张思",@"李四",@"李武",@"王六",@"王琦",@"高密",@"周浩",@"林只",@"马六",@"郑八",@"施五",@"陈六",@"石六",@"高六",@"蔡六",@"a六",@"#六"];
    NSMutableDictionary *dataDict = @{}.mutableCopy;
    NSMutableArray *groupList = @[].mutableCopy;
    NSMutableArray *nonameList = @[].mutableCopy;
    for (NSString * nameStr in self.addressBookArr) {
        NSString *group = [[nameStr firstPinYin] uppercaseString];
        if (group.length == 0 || !isalpha([group characterAtIndex:0])) {
            [nonameList addObject:nameStr];
            continue;
        }
        NSMutableArray *list = [dataDict objectForKey:group];
        if (!list) {
            list = @[].mutableCopy;
            dataDict[group] = list;
            [groupList addObject:group];
        }
        [list addObject:nameStr];
    }
    [groupList sortUsingSelector:@selector(localizedStandardCompare:)];
    if (nonameList.count) {
        [groupList addObject:@"#"];
        dataDict[@"#"] = nonameList;
    }
    for (NSMutableArray *list in [dataDict allValues]) {
        NSLog(@"%@",list);
        [list sortUsingSelector:@selector(compare:)];
    }
    self.addressBookDic = dataDict;
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSString *group = self.groupArr[section];
    NSArray *list = self.addressBookDic[group];
    return list.count;

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groupArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    NSString *group = self.groupArr[indexPath.section];
    NSArray *list = self.addressBookDic[group];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = list[indexPath.row];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width, 50)];
    textLabel.font = [UIFont systemFontOfSize:16];
    textLabel.textColor = [UIColor grayColor];
    textLabel.text = self.groupArr[section];
    textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    headView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [headView addSubview:textLabel];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSArray * list = self.addressBookDic[self.groupArr[section]];
    return list.count >0 ? 25:0.01;;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]init];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *array = [NSMutableArray arrayWithObject:@""];
    [array addObjectsFromArray:self.groupArr];
    return array;
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return  [self.groupArr indexOfObject:title];
}

#pragma mark - - <TUISearchBarDelegate>
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSPredicate * predicate ;
    NSArray * tempArr = [NSMutableArray array];
    if (searchText.length<=0) {
        tempArr = [NSArray arrayWithArray:self.addressBookArr];
    }else{
        predicate = [NSPredicate predicateWithFormat:@"self contains[c] %@",searchText];
        tempArr = [_addressBookArr filteredArrayUsingPredicate:predicate];
    }
        NSMutableDictionary *dataDict = @{}.mutableCopy;
        NSMutableArray *groupList = @[].mutableCopy;
        NSMutableArray *nonameList = @[].mutableCopy;
        for (NSString * name in tempArr) {
            NSString *group = [[name firstPinYin] uppercaseString];
            if (group.length == 0 || !isalpha([group characterAtIndex:0])) {
                [nonameList addObject:name];
                continue;
            }
            NSMutableArray *list = [dataDict objectForKey:group];
            if (!list) {
                list = @[].mutableCopy;
                dataDict[group] = list;
                [groupList addObject:group];
            }
            NSAttributedString * attributeString = [[NSAttributedString alloc]initWithString:name];
            NSMutableAttributedString * mutableString = [[NSMutableAttributedString alloc]initWithAttributedString:attributeString];
            NSDictionary * dic = @{
                NSForegroundColorAttributeName:[UIColor redColor],
            };
            NSRange range = [name rangeOfString:searchText];
            [mutableString addAttributes:dic range:range];
            [list addObject:name];
        }
        [groupList sortUsingSelector:@selector(localizedStandardCompare:)];
        if (nonameList.count) {
            [groupList addObject:@"#"];
            dataDict[@"#"] = nonameList;
        }
        for (NSMutableArray *list in [dataDict allValues]) {
            [list sortUsingSelector:@selector(compare:)];
        }
        self.addressBookDic = dataDict;
        [_tableView reloadData];
}
@end
