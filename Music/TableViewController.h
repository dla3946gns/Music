//
//  TableViewController.h
//  Music
//
//  Created by ishiftApp on 2020/08/24.
//  Copyright © 2020 ishift. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewController : UITableViewController
// SongCollectionViewController로부터 받아온 데이터를 처리하는 메서드
- (void)bindingData:(NSDictionary *)data isAll:(BOOL)isAll;
@end

@interface TableViewSubCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rankingLabel; // 랭킹 라벨
@property (weak, nonatomic) IBOutlet UIImageView *albumImage; // 앨범 이미지
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;     // 노래 제목 라벨
@property (weak, nonatomic) IBOutlet UILabel *singerLAbel;    // 노래 가수 라벨

@end

NS_ASSUME_NONNULL_END
