//
//  DXTextView.m
//  TNews
//
//  Created by news365-macpro on 2018/11/2.
//  Copyright © 2018 Intelligent-earnings. All rights reserved.
//

#import "DXTextView.h"
#import "DXImageCollectionViewCell.h"


#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"


@interface DXTextView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong) UILabel * placeholderLabel;

@property(nonatomic, strong) UICollectionView * collectionView;
@property(nonatomic, strong) UICollectionViewFlowLayout * flowLayout;

@property(nonatomic, strong) NSMutableArray<UIImage *> * dataSource;

@end

@implementation DXTextView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void)setup {
    
    _imageItemSize = CGSizeMake(80, 120);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewContentDidChange)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
}


#pragma mark - New

- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        _placeholderLabel = [UILabel new];
        _placeholderLabel.clipsToBounds = NO;
        _placeholderLabel.numberOfLines = 1;
        _placeholderLabel.autoresizesSubviews = NO;
        _placeholderLabel.font = self.font;
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.textColor = [UIColor lightGrayColor];
        _placeholderLabel.hidden = YES;
        _placeholderLabel.isAccessibilityElement = NO;
        [self addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
    [self layoutIfNeeded];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [super setTextAlignment:textAlignment];
    self.placeholderLabel.textAlignment = textAlignment;
}

- (BOOL)_shouldHidePlaceholder
{
    if (self.placeholder.length == 0 || self.text.length > 0) {
        return YES;
    }
    return NO;
}

- (CGRect)_placeholderRectThatFits:(CGRect)bounds
{
    CGFloat padding = self.textContainer.lineFragmentPadding;
    
    CGRect rect = CGRectZero;
    rect.size.height = [self.placeholderLabel sizeThatFits:bounds.size].height;
    rect.size.width = self.textContainer.size.width - padding*2.0;
    rect.origin = UIEdgeInsetsInsetRect(bounds, self.textContainerInset).origin;
    rect.origin.x += (padding + 2);
    return rect;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.placeholderLabel.hidden = [self _shouldHidePlaceholder];
    
    if (!self.placeholderLabel.hidden) {
        
        [UIView performWithoutAnimation:^{
            self.placeholderLabel.frame = [self _placeholderRectThatFits:self.bounds];
            [self sendSubviewToBack:self.placeholderLabel];
        }];
    }
}


#pragma mark - textViewContentDidChange
-(void)textViewContentDidChange
{
    if (_contentChangedBlock) {
        __weak typeof(self) weakSelf = self;
        _contentChangedBlock(weakSelf);
    }
    [self setNeedsLayout];
}


#pragma mark - collection View
-(void)addImage:(UIImage *)image
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithCapacity:4];
    }
    if (image != nil) {
        [_dataSource addObject:image];
        _images = [_dataSource copy];
        
        if (_collectionView == nil) {
            [self addCollectionView];
        }else{
            
            if (_collectionView.hidden) {
                _collectionView.hidden = NO;
                UIEdgeInsets inset = self.textContainerInset;
                inset.top += CGRectGetMaxY(_collectionView.frame);
                self.textContainerInset = inset;
            }
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataSource.count - 1 inSection:0];
            [_collectionView insertItemsAtIndexPaths:@[indexPath]];
            [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        }
        
        [self textViewContentDidChange];
    }
}


-(void)setImageItemSize:(CGSize)imageItemSize
{
    _imageItemSize = imageItemSize;
    
    if (_collectionView) {
        
        UIEdgeInsets inset = self.textContainerInset;
        inset.top -= CGRectGetMaxY(_collectionView.frame);
        
        CGRect frame = _collectionView.frame;
        frame.size.height = _imageItemSize.height;
        _collectionView.frame = frame;
        
        inset.top += CGRectGetMaxY(_collectionView.frame);
        self.textContainerInset = inset;
        
        _flowLayout.itemSize = _imageItemSize;
    }
    
    [self textViewContentDidChange];
}


-(void)addCollectionView
{
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.minimumLineSpacing = 5;
    _flowLayout.minimumInteritemSpacing = 0;
    _flowLayout.itemSize = _imageItemSize;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 5, self.frame.size.width, _imageItemSize.height) collectionViewLayout:_flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    [_collectionView registerClass:[DXImageCollectionViewCell class] forCellWithReuseIdentifier:@"CellID"];
    [self addSubview:_collectionView];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UIEdgeInsets inset = self.textContainerInset;
    inset.top += CGRectGetMaxY(_collectionView.frame);
    self.textContainerInset = inset;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DXImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellID" forIndexPath:indexPath];
    cell.imageView.image = _dataSource[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_dataSource removeObjectAtIndex:indexPath.row];
    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
    
    if (_dataSource.count > 0) {
        _images = [_dataSource copy];
        
    }else{
        _images = nil;
        UIEdgeInsets inset = self.textContainerInset;
        inset.top -= CGRectGetMaxY(_collectionView.frame);
        self.textContainerInset = inset;
        _collectionView.hidden = YES;
    }
    
    [self textViewContentDidChange];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
