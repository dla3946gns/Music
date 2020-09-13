//
//  DetailViewController.m
//  Music
//
//  Created by ishiftApp on 2020/08/24.
//  Copyright © 2020 ishift. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *heartImage;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"상세";
    
}

- (void)bindingData:(NSDictionary *)data
{
    if (data) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:data[@"albumImagePath200"]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
//              main 함수 안에서 받아온 뷰로 띄울 값들을 저장하기
                self.albumImage.image = [UIImage imageWithData:imageData];
                self.songTitleLabel.text = data[@"title"];
                self.singerLabel.text = data[@"singer"];
                
                NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
                [nf setNumberStyle:NSNumberFormatterDecimalStyle];
                int value = [data[@"like"] intValue];
                NSString *like = [NSString stringWithFormat:@"%@", [nf stringFromNumber:[NSNumber numberWithUnsignedInt:value]]];
                self.likeLabel.text = like;
                
            });
            
        });
    }
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
