//
//  HHTableViewController.m
//  TNews
//
//  Created by news365-macpro on 2018/10/18.
//  Copyright © 2018 Intelligent-earnings. All rights reserved.
//

#import "DXTablePageViewController.h"
#import "DXTablePageHeaderView.h"

@interface DXTablePageViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource, DXTablePageHeaderViewDelegate>

@property(nonatomic, strong) UIPageViewController * pageViewController;
@property(nonatomic, weak)   UIScrollView * pageScrollView;

@property(nonatomic, strong) NSArray<UIViewController<DXTablePageViewProtocol> *> * vcs;
@property(nonatomic, strong) NSArray * titles;

@property(nonatomic, strong) UIScrollView * cellSrcollView;

@property(nonatomic, assign) CGFloat oldTableViewOffsetY;
@property(nonatomic, assign) CGFloat contentH; // 底部内容的高度

@property(nonatomic, strong) DXTablePageHeaderView * headerView;

@end

@implementation DXTablePageViewController

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {}
    return self;
}

-(DXTablePageViewController *)initWithTitles:(NSArray<NSString *> *)titles viewControllers:(NSArray<UIViewController<DXTablePageViewProtocol> *> *)viewControllers contentH:(CGFloat)contentH
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        _vcs = viewControllers;
        _titles = titles;
        _contentH = contentH;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.scrollsToTop = YES;
    self.tableView.sectionHeaderHeight = 40;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"DXTablePageCellID"];
    
    if (_vcs.count > 0) {
        
        [self addChildViewController:self.pageViewController];
        _pageScrollView = [self findScrollView];
        if (_pageScrollView != nil) {
            _pageScrollView.delegate = self;
        }
        
        [self.pageViewController setViewControllers:@[_vcs.firstObject]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:nil];
        
        self.cellSrcollView = [_vcs.firstObject currentScrollView];
    }
}


#pragma mark - Delegate
#pragma mark - UIPageViewController

// 向左滚
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController<DXTablePageViewProtocol> *)viewController
{
    NSInteger index = [_vcs indexOfObject:viewController];
    if (index == 0 || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return _vcs[index];
    
}

// 向右滚
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController<DXTablePageViewProtocol> *)viewController
{
    NSInteger index = [_vcs indexOfObject:viewController];
    if (index == _vcs.count - 1 || (index == NSNotFound)) {
        return nil;
    }
    index++;
    return _vcs[index];
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController<DXTablePageViewProtocol> *> *)pendingViewControllers {
    
    UIViewController<DXTablePageViewProtocol> *nextVC = [pendingViewControllers firstObject];
    UIScrollView *scrollView = [nextVC currentScrollView];
    [self updateNextScrollViewContentOffset:scrollView];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController<DXTablePageViewProtocol> *> *)previousViewControllers transitionCompleted:(BOOL)completed {

    if (completed && finished) {
        
        UIViewController<DXTablePageViewProtocol> *vc = pageViewController.viewControllers.firstObject;
        if (vc != nil && [vc respondsToSelector:@selector(currentScrollView)]) {
            self.cellSrcollView = [vc currentScrollView];
        }else{
            self.cellSrcollView = nil;
        }
        _headerView.selectIndex = [_vcs indexOfObject:_pageViewController.viewControllers.firstObject];
    }
}

#pragma mark - Table view data source

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DXTablePageHeaderView *header = [[NSBundle mainBundle] loadNibNamed:@"DXTablePageHeaderView" owner:nil options:nil].firstObject;
    [header.leftButton setTitle:_titles.firstObject forState:UIControlStateNormal];
    [header.rightButton setTitle:_titles.lastObject forState:UIControlStateNormal];
    header.delegate = self;
    _headerView = header;
    return header;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:@"DXTablePageCellID" forIndexPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _contentH;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.pageViewController.view.frame = cell.bounds;
    [cell.contentView addSubview:self.pageViewController.view];
}


#pragma mark - ScrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (scrollView == self.tableView) {
        _oldTableViewOffsetY = self.tableView.contentOffset.y;   
    }else if(scrollView == _pageScrollView){
        [self setAllScrollViewsScrollEnable:NO];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView == _pageScrollView && !decelerate) {
        [self setAllScrollViewsScrollEnable:YES];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == _pageScrollView) {
        [self setAllScrollViewsScrollEnable:YES];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        
        if (_cellSrcollView != nil) {
         
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            CGFloat maxY = cell.frame.origin.y;
            CGFloat tableViewOffsetY = scrollView.contentOffset.y;
            CGFloat cellTableViewOffsetY = _cellSrcollView.contentOffset.y;
            
            if (_oldTableViewOffsetY == 0) { // 底部，禁止弹簧之后 scroll 不会变
                if (tableViewOffsetY >= 0) {
                    _cellSrcollView.contentOffset = CGPointMake(0, 0);
                }
                
            }else if(_oldTableViewOffsetY == maxY){
                
                if (tableViewOffsetY >= maxY) {
                    
                    self.tableView.contentOffset = CGPointMake(0, maxY);
                    
                }else{
                    
                    if (_oldTableViewOffsetY > tableViewOffsetY) { // 向下
                        
                        if (cellTableViewOffsetY > 0) {
                            self.tableView.contentOffset = CGPointMake(0, maxY);
                        }else{
                            _cellSrcollView.contentOffset = CGPointMake(0, 0);
                        }
                    }else{
                        self.tableView.contentOffset = CGPointMake(0, maxY);
                    }
                }
                
            }else{
                
                if (tableViewOffsetY >= maxY) {
                    self.tableView.contentOffset = CGPointMake(0, maxY);
                }else{
                    _cellSrcollView.contentOffset = CGPointMake(0, 0);
                }
            }
            
        }
        _oldTableViewOffsetY = self.tableView.contentOffset.y;
        
    }
}

#pragma mark - DXTablePageHeaderViewDelegate
-(void)didClickItemInTablePageHeaderView:(DXTablePageHeaderView *)headerView
{
    UIViewController<DXTablePageViewProtocol> *vc = [_vcs objectAtIndex:headerView.selectIndex];
    UIScrollView *scrollView = [vc currentScrollView];
    [self updateNextScrollViewContentOffset:scrollView];
    NSInteger index = [_vcs indexOfObject:_pageViewController.viewControllers.firstObject];
    UIPageViewControllerNavigationDirection dir = headerView.selectIndex > index ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    
    __weak typeof(self) weakSelf = self;
    [self.pageViewController setViewControllers:@[vc]
                                      direction:dir
                                       animated:YES
                                     completion:^(BOOL finished) {
                                         weakSelf.cellSrcollView = scrollView;
                                     }];
}

#pragma mark - Private
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (object == _cellSrcollView) {
        
        if (_cellSrcollView.contentOffset.y != 0) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            CGFloat maxY = cell.frame.origin.y;
            CGFloat offsetY = self.tableView.contentOffset.y;
            if (offsetY < maxY && offsetY > 0) {
                _cellSrcollView.contentOffset = CGPointMake(0, 0);
            }
        }
    }
}

-(void)setCellSrcollView:(UIScrollView *)cellSrcollView
{
    if (_cellSrcollView != nil) {
        [_cellSrcollView removeObserver:self forKeyPath:@"contentOffset"];
    }
    
    _cellSrcollView = cellSrcollView;
    if (_cellSrcollView != nil) {
        [_cellSrcollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}

-(UIPageViewController *)pageViewController
{
    if (!_pageViewController) {
        
        NSDictionary *option = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:10]
                                                           forKey:UIPageViewControllerOptionInterPageSpacingKey];
        
        _pageViewController = [[UIPageViewController alloc]
                               initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                               options:option];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        
    }
    return _pageViewController;
}


-(void)setAllScrollViewsScrollEnable:(BOOL)enable
{
    for (UIViewController<DXTablePageViewProtocol> *vc in _vcs) {
        UIScrollView *subS = [vc currentScrollView];
        if (subS != nil) {
            [subS setScrollEnabled:enable];
        }
    }
}

-(void)updateNextScrollViewContentOffset:(UIScrollView *)scrollView
{
    if (scrollView != nil) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (self.tableView.contentOffset.y < cell.frame.origin.y) {
            [scrollView setContentOffset:CGPointMake(0, 0)];
        }
    }
}

-(void)dealloc
{
    _cellSrcollView = nil;
}

#pragma mark - TOOL
-(UIScrollView *)findScrollView{
   UIScrollView *scrollView;
   for(id subview in _pageViewController.view.subviews){
       if([subview isKindOfClass:UIScrollView.class]){
           scrollView=subview;
           break;
       }}
    return scrollView;
}

@end
