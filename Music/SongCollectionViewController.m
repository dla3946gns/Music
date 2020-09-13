//
//  CollectionViewController.m
//  Music
//
//  Created by ishiftApp on 2020/08/24.
//  Copyright © 2020 ishift. All rights reserved.
//

#import "SongCollectionViewController.h"
#import "TableViewController.h"
#import "LoginViewController.h"

// SongCollectionViewController 클래스를 선언
@interface SongCollectionViewController ()
@property (nonatomic, strong) NSMutableDictionary *totalData; // 모든 노래 정보들이 모여있는 JSON 데이터
@property (nonatomic, strong) NSMutableArray *musicGroupArr;  // musicGroup에 해당하는 value값들이 모여있는 JSON 데이터
@end

// SongCollectionViewController 클래스 안의 메서드들
@implementation SongCollectionViewController

// CollectionViewSubCell 안의 이미지와 라벨을 띄우기 위해 identifier 변수를 상수로 선언한다.
static NSString * const reuseIdentifier = @"CollectionViewSubCell";

// viewDidLoad 다음 실행되는 viewWillAppear은 자동 로그인 버튼을 누르고 로그인한 후 앱 종료 시 다시 앱을 실행시키면 오른쪽 상단의 로그인 버튼이 로그아웃으로 변하게 하기 위해 쓰인다.
- (void)viewWillAppear:(BOOL)animated
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"] && [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"] == true) {
        UIBarButtonItem *loginBtn = [[UIBarButtonItem alloc] initWithTitle:@"로그아웃" style:UIBarButtonItemStylePlain target:self action:@selector(logoutAction)];
        [self.navigationItem setRightBarButtonItem:loginBtn];
    } else {
        UIBarButtonItem *loginBtn = [[UIBarButtonItem alloc] initWithTitle:@"로그인" style:UIBarButtonItemStylePlain target:self action:@selector(moveToLogin)];
        [self.navigationItem setRightBarButtonItem:loginBtn];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//  화면 타이틀
    self.navigationItem.title = @"메인";
    
//    [self.collectionView registerClass:[CollectionViewSubCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
//  자동 로그인 체크 -> @"autoLogin"에 해당하는 값이 자동 로그인 버튼의 태그 값인데 회색은 0, 파란색은 1로 되게 설정했다. 따라서 1인 경우는 자동 로그인 버튼이 클릭된 경우이다.
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"autoLogin"] && [[NSUserDefaults standardUserDefaults] integerForKey:@"autoLogin"] == 1) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//          url에 맞는 데이터를 꺼내오는 코드
            NSURL *url = [NSURL URLWithString:@"http://demo1914380.mockable.io/api/login"];
            NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
            [urlRequest setHTTPMethod:@"POST"];
            
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
               
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                
                if (httpResponse.statusCode == 200) {
                    
                    NSError *err = nil;
                    NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
//                  자동 로그인한 user의 @"userName"에 해당하는 value를 name 변수에 저장한다.
                    NSString *name = responseJson[@"userName"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
//                        name 변수의 키는 loginName으로 해주고 isLogin의 value는 YES로 한 다음 synchronize해준다.
                        [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"loginName"];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
//                        만약 isLogin의 value가 YES이면 오른쪽 상단에 로그아웃을 띄워준다.
                        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"] && [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"] == YES) {
                            UIBarButtonItem *loginBtn = [[UIBarButtonItem alloc] initWithTitle:@"로그아웃" style:UIBarButtonItemStylePlain target:self action:@selector(logoutAction)];
                            [self.navigationItem setRightBarButtonItem:loginBtn];
                        } else {
//                            isLogin의 value가 YES가 아니면 오른쪽 상단에 로그인을 띄워준다.
                            UIBarButtonItem *loginBtn = [[UIBarButtonItem alloc] initWithTitle:@"로그인" style:UIBarButtonItemStylePlain target:self action:@selector(moveToLogin)];
                            [self.navigationItem setRightBarButtonItem:loginBtn];
                        }
//                      dispatch_async 메서드를 실행시키기 위해 return을 써준다.
                        return;
                    });
                    
                } else {
//                    url이 연결되지 않아서 실행이 잘 안 되면 autoLogin의 value는 0, loginName은 빈 데이터, isLogin의 value는 NO로 둔다.
                    NSLog(@"Error!");
                    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"autoLogin"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"loginName"];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    return;
                }
            }];
//            dataTask 실행
            [dataTask resume];
        });
    } else {
//        자동 로그인 버튼이 클릭되지 않은 상태에서 로그인했을 때 코드
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"autoLogin"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"loginName"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
//       오른쪽 상단에 로그인을 띄워준다.
        UIBarButtonItem *loginBtn = [[UIBarButtonItem alloc] initWithTitle:@"로그인" style:UIBarButtonItemStylePlain target:self action:@selector(moveToLogin)];
        [self.navigationItem setRightBarButtonItem:loginBtn];
        
    }
    
//  db와 연결하여 데이터 가져오기
    self.musicGroupArr = [[NSMutableArray alloc] init]; // musicGroupArr 초기화 -> 이 변수 안에 "musicGroup"에 해당하는 value들을 넣을 예정이다.
    
//  해당 url 변수 선언
    NSURL *url = [NSURL URLWithString:@"http://demo1914380.mockable.io/api/v2/playlist"];
//  어느 url에 요청할 것인지 urlReuqest에 해당 url로 초기화시켜준다.
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
//  요청 방식은 POST로 한다.
    [urlRequest setHTTPMethod:@"POST"];
    
//  받아온 데이터를 담아둘 session 변수를 선언
    NSURLSession *session = [NSURLSession sharedSession];
//  데이터를 받아오는 역할을 하는 dataTask 변수 선언 및 session에 urlRequest 요청에 따라 받아온 인자들인 data, response, error를 사용하여 실행시키는 completionHandler 메서드를 실행
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//      response는 urlRequest에 대한 응답이며 이를 해당 url에 요청을 한 response이니 NSHTTPURLResponse로 형변환시킨다.
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//      httpResponse.statusCode가 200이면
        if (httpResponse.statusCode == 200) {
//            일단 err 변수는 nil로 선언한다.
            NSError *err = nil;
//            responseJson 변수에 data에 있는 JSON 데이터로 초기화시킨다.
            NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
//            musicGroup 변수에 responseJson에 있는 키 값이 musicGroup인 value를 담아준다.
            NSMutableArray *musicGroup = responseJson[@"musicGroup"];
//            main 함수에 UI 작업을 해야 하니 dispatch_async 메서드에 dispatch_get_main_queue()를 넣어주고
            dispatch_async(dispatch_get_main_queue(), ^{
//                totalData는 responseJson으로 초기화해주고(전체 데이터) musicGroupArr에는 musicGroup을 넣어준다.
                self.totalData = [[NSMutableDictionary alloc] initWithDictionary:responseJson];
                self.musicGroupArr = musicGroup;
//                또한, collectionView에 url을 통해 가져온 데이터들을 사용하기 위해 reloadData 메서드를 써준다.
                [self.collectionView reloadData];
            });
        } else {
//            url이 연결되지 않으면 Error 로그를 띄워줌.
            NSLog(@"Error!");
        }
    }];
//    url을 통해 데이터를 가져오는 작업을 수행
    [dataTask resume];
    
//    메인 화면에는 기본적으로 오른쪽 상단에 로그인 버튼을 띄워준다. 또한, 로그인 버튼을 누룰 시 로그인 페이지로 가는 moveToLogin 메서드를 만들어서 전환시켜 준다.
    UIBarButtonItem *loginBtn = [[UIBarButtonItem alloc] initWithTitle:@"로그인" style:UIBarButtonItemStylePlain target:self action:@selector(moveToLogin)];
    [self.navigationItem setRightBarButtonItem:loginBtn];
}

// 로그인 화면으로 이동
- (void)moveToLogin {
//  UIStoryboard 타입의 main이라는 변수를 선언하는데 storyboardWithName이 Main인 이유는 로그인 페이지가 Main.storyboard에 있기 때문이다.
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    로그인 페이지는 LoginViewController 클래스와 연결되어 있기에 LoginViewController를 써준다.
    LoginViewController *lvc = (LoginViewController *)[main instantiateViewControllerWithIdentifier:NSStringFromClass([LoginViewController class])];
//  UIViewController의 조상인 navigationController로 메서드 pushViewController 사용해 페이지를 전환시켜준다.
    [self.navigationController pushViewController:lvc animated:YES];
}

// 로그아웃 버튼을 클릭했을 때 실행되는 코드들
- (void)logoutAction
{
//    userName 변수에 현재 NSUseDefaults 클래스에 저장된 loginName에 해당하는 value 값을 저장한다.
    NSString *userName = [[NSUserDefaults standardUserDefaults] stringForKey:@"loginName"];
//  logoutAction 메서드는 로그아웃 버튼을 클릭하면 실행되므로 alert를 띄워준다. 제목은 '로그아웃', 가운데 메시지는 'userName님 로그아웃하시겠습니까?'이다.
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"로그아웃" message:[NSString stringWithFormat:@"%@님 로그아웃하시겠습니까?", userName] preferredStyle:UIAlertControllerStyleAlert];
//    alert 창을 없앨 수 있는 취소 버튼을 alert창에 만들어준다.
    UIAlertAction *close = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:close];
    
//    로그아웃을 할 수 있는 확인 버튼을 만들어준다.
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        로그아웃하는 것이기에 NSUserDefaults에 autoLogin의 value는 0, loginName의 value는 빈 문자열, isLogin의 value는 NO로 하고 synchronize해준다.
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"autoLogin"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"loginName"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
//      isLogin에 대한 value값에 따라 오른쪽 상단 버튼을 로그아웃으로 할지 로그인으로 할지 판별한다.
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"] && [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"] == true) {
            UIBarButtonItem *loginBtn = [[UIBarButtonItem alloc] initWithTitle:@"로그아웃" style:UIBarButtonItemStylePlain target:self action:@selector(logoutAction)];
            [self.navigationItem setRightBarButtonItem:loginBtn];
        } else {
            UIBarButtonItem *loginBtn = [[UIBarButtonItem alloc] initWithTitle:@"로그인" style:UIBarButtonItemStylePlain target:self action:@selector(moveToLogin)];
            [self.navigationItem setRightBarButtonItem:loginBtn];
        }
//        handler에 대한 return;
        return;
    }];
//  aelrt 창에 확인 버튼을 추가
    [alert addAction:ok];
//    presentViewController 메서드에 alert를 인자로 줘서 alert창을 실행시킨 후 현재 창으로 가게 만든다.
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark <UICollectionViewDataSource>
// numberOfSectionsInCollectionView에서 1을 리턴시키면 컬렉션 뷰 1개, 2면 2개가 된다. .count를 써서 특정 동적 배열의 크기만큼 리턴시킬 수 있다.
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// numberOfItemsInSection은 컬렉션 뷰 안의 섹션 안에 있는 item의 개수를 리턴시키는 메서드이다.
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//  musicGroupArr이 nil이 아니면
    if (self.musicGroupArr && self.musicGroupArr.count > 0) {
//      '전체' 아이콘도 띄워줘야 하기 때문에 +1을 해준다.
        return self.musicGroupArr.count + 1;
    }
//    그 이외의 경우는 아무 셀도 나오게 하지 않는다.
    return 0;
}

// cellForItemAtIndexPath 메서드는 셀 안에 이미지와 라벨을 띄우는 메서드이다. CollectionViewSubCell를 identifier로 갖고 클래스로 상속 받고 있는 컬렉션 뷰 안의 컬렉션 뷰 셀에 cell.으로 UI를 띄울 수 있다.
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//  musicGroupArr이 nil이면
    if (self.musicGroupArr && self.musicGroupArr.count > 0) {
//      contentView안의 테두리 컬러를 검은색으로 하고 폭 즉, 테두리의 굵기를 2.0으로 지정한다.
        cell.contentView.layer.borderColor = [UIColor blackColor].CGColor;
        cell.contentView.layer.borderWidth = 2.0;
//      collectionView의 row가 0번째일 땐 특정 이미지와 '전체'라는 라벨을 띄운다.
        if (indexPath.row == 0) {
            cell.imageIcon.image = [UIImage imageNamed:@"icon_all"];
            cell.labelIcon.text = @"전체";
        } else {
//          나머지 이미지와 라벨은 db안에 있는 데이터를 사용한다. 이는 JSON 형태로 되어있기에 임시 딕셔너리 변수를 선언하여 띄워준다.
            NSDictionary *dic = self.musicGroupArr[indexPath.row - 1];
            cell.labelIcon.text = dic[@"groupName"];
            cell.imageIcon.image = [UIImage imageNamed:dic[@"groupCode"]];
        }
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

// 컬렉션 뷰 안의 item 사이즈를 정하기(정적 또는 동적으로 정할 수 있다)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//  iOS, macOS, tvOS, Mac Catalyst에서는 double 타입이지만 watchOS는 float 타입이다.
//    [UIScreen mainScreen].bounds.size.width는 375.000000로 나오며 w는 182.500000로 나온다.ㄴ
    CGFloat w = ([UIScreen mainScreen].bounds.size.width / 2) - 5;
//    NSLog(@"%f", w);
    return CGSizeMake(w, w); // CGSizeMake 메서드로 셀의 폭과 높이를 설정해준다.
}

// 화면의 헤더 사이즈를 설정할 수 있다. 만약 CGSizeMake(0, 0)이면 헤더는 보이지 않는다.
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 10);
}

#pragma mark <UICollectionViewDelegate>

// didSelectItemAtIndexPath 메서드는 원하는 셀을 클릭했을 때 실행되게 한다.
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.musicGroupArr && self.musicGroupArr.count > 0) {
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TableViewController *tvc = (TableViewController *)[main instantiateViewControllerWithIdentifier:NSStringFromClass([TableViewController class])];
        
        if (indexPath.row == 0) {
//          row가 0번째인 것은 전체를 클릭했을 때이므로 TableView에선 전체 노래의 정보를 보여줘야 하기에 totalData를 보낸다.
            [tvc bindingData:self.totalData isAll:YES];
        } else {
//          나머지 노래들을 임의의 변수 dic에 저장한 다음 dic과 isAll메서드로 전체 노래가 아님을 의미하는 데이터 NO를 보낸다.
            NSDictionary *dic = self.musicGroupArr[indexPath.row - 1];
            [tvc bindingData:dic isAll:NO];
        }
//      위의 코드를 처리한 다음 테이블 뷰 컨트롤러로 넘겨주는 메서드를 써준다.
        [self.navigationController pushViewController:tvc animated:YES];
    }
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end

@implementation CollectionViewSubCell

@end
