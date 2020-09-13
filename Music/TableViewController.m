//
//  TableViewController.m
//  Music
//
//  Created by ishiftApp on 2020/08/24.
//  Copyright © 2020 ishift. All rights reserved.
//

#import "TableViewController.h"
#import "DetailViewController.h"

@interface TableViewController ()
@property (nonatomic, assign) BOOL isAll;           // 모든 노래의 정보를 담고 있는지 아닌지 판단하는 논리형 변수이다.
@property (nonatomic, strong) NSMutableArray *list; // 동적 배열의 list 변수 선언
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

// bindingData 메서드는 메인 화면의 컬렉션 뷰에서 맨 처음 셀을 클릭하면 전체 노래가 나와야 하고 다른 셀을 클릭했을 때는 해당 카테고리의 노래들이 나와야 하니 받아온 데이터가 전체 노래 정보를 담고 있는지 아닌지 isAll 변수로 판단하는 메서드이다.
- (void)bindingData:(NSDictionary *)data isAll:(BOOL)isAll
{
//    위의 빈 동적 배열의 list를 초기화시킨다.
    self.list = [[NSMutableArray alloc] init];
//    위의 isAll은 NO로 초기화시킨다.
    self.isAll = NO;
//    만약 컬렉션 뷰에서 받아온 data가 존재하면
    if (data) {
//        받아온 isAll이 YES이면
        if (isAll) {
//            위의 isAll은 YES로 해주고
            self.isAll = YES;
//            빈 동적 배열 list에는 받아온 data 변수의 musicGroup에 해당하는 value 값을 넣어준다.
            self.list = data[@"musicGroup"];
//            테이블 뷰의 화면 타이틀은 전체라고 지정해준다. 컬렉션 뷰에서 전체를 클릭했기 때문이다.
            self.navigationItem.title = @"전체";
        } else {
//            컬렉션 뷰에서 전체를 클릭하지 않으면 data에 playList에 해당하는 value 값을 list에 넣어준다.
            self.list = data[@"playList"];
//            테이블 뷰의 타이틀은 받아온 data 변수의 groupName에 해당하는 문자열로 지정해준다.
            self.navigationItem.title = data[@"groupName"];
        }
//        아래 코드로 받아온 데이터들을 테이블 뷰에 띄워주도록 한다.
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//  isAll이 YES이면 '전체' Cell을 클릭한 것이니 전체 항목만큼의 수를 리턴한다.
    if (self.isAll) {
        return self.list.count;
    } else {
//      그게 아니면 한 개만 리턴한다.
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//  list가 nil이 아닐 때
    if (self.list && self.list.count > 0) {
//      isAll이 YES이면
        if (self.isAll) {
//          playList에 해당하는 모든 데이터를 배열에 담아 그 갯수를 리턴시킨다.
            NSArray *arr = self.list[section][@"playList"];
            return arr.count;
        } else {
//          isAll이 NO이면 특정 list의 개수만 리턴시킨다.
            return self.list.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewSubCell" forIndexPath:indexPath];
    
//  list가 nil이 아닐 때
    if (self.list && self.list.count > 0) {
//      indexPath.row는 초기값이 0이기에 1을 더해준다.
        cell.rankingLabel.text = [NSString stringWithFormat:@"%ld.", indexPath.row + 1];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//      만약 '전체' cell을 클릭했다면
        if (self.isAll) {
//          각 배열의 [@"playList"]에 해당하는 value를 arr에 담는다.
            NSArray *arr = self.list[indexPath.section][@"playList"];
//          임의의 변수 dic 안에 arr의 데이터들을 차례대로 넣어준다.
            dic = arr[indexPath.row];
        } else {
//          전체 cell이 아닌 다른 cell을 선택했을 때 dic에 해당 노래 정보들을 넣어준다.
            dic = self.list[indexPath.row];
        }
        
//      NSData 타입의 변수 imgData안에 @"albumImagePath50"에 해당하는 이미지 데이터를 넣어준다. dispatch_async(dispatch_get_global_queue(0, 0), ^{});는 멀티 스레드를 구현하기 위해 썼다. 
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:dic[@"albumImagePath50"]]];
//          dispatch_async(dispatch_get_main_queue(), ^{});는 UI를 띄울 땐 main 함수에 코드를 작성해야 하기 때문에 쓴 것이다.
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.albumImage.image = [UIImage imageWithData:imgData];
            });
            
        });
        
        cell.titleLabel.text = dic[@"title"];
        cell.singerLAbel.text = dic[@"singer"];
        
    }
    
    return cell;
}

// 해당 row를 클릭하면 그 노래의 상세 정보를 보여주는 화면으로 넘어가게 한다.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.list && self.list.count > 0) {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (self.isAll) {
            NSArray *arr = self.list[indexPath.section][@"playList"];
            dic = arr[indexPath.row];
        } else {
            dic = self.list[indexPath.row];
        }
        
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetailViewController *dvc = (DetailViewController *)[main instantiateViewControllerWithIdentifier:NSStringFromClass([DetailViewController class])];
        [dvc bindingData:dic];
        [self.navigationController pushViewController:dvc animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
//  만약 collectionView에서 전체 cell을 클릭했을 경우 Section을 전체 groupName의 개수만큼 리턴해준다.
    if (self.isAll) {
        return self.list[section][@"groupName"];
//  그렇지 않으면 아무것도 리턴하지 않는다.
    } else {
        return @"";
    }
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

@implementation TableViewSubCell

@end
