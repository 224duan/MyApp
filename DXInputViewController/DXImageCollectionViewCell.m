//
//  DXImageCollectionViewCell.m
//  TNews
//
//  Created by news365-macpro on 2018/11/7.
//  Copyright © 2018 Intelligent-earnings. All rights reserved.
//

#import "DXImageCollectionViewCell.h"

@implementation DXImageCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.layer.cornerRadius = 13;
        _imageView.layer.masksToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}


@end
