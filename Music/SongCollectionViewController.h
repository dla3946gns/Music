//
//  CollectionViewController.h
//  Music
//
//  Created by ishiftApp on 2020/08/24.
//  Copyright © 2020 ishift. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SongCollectionViewController : UICollectionViewController<UICollectionViewDelegateFlowLayout>

@end

@interface CollectionViewSubCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon; // 전체, 발라드 등의 아이콘 이미지
@property (weak, nonatomic) IBOutlet UILabel *labelIcon;     // 전체, 발라드 등의 라벨
@end

NS_ASSUME_NONNULL_END
