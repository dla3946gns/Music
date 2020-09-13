//
//  LoginViewController.m
//  Music
//
//  Created by ishiftApp on 2020/08/24.
//  Copyright © 2020 ishift. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () <UITextFieldDelegate>         // 텍스트 필드에서 텍스트를 작성하고 리턴 버튼을 누르면 다음 텍스트 필드로 포커스를 변경하기 위해 UITextFieldDelegate 프로토콜을 사용한다.
@property (weak, nonatomic) IBOutlet UILabel *idLabel;          // 아이디 라벨 변수
@property (weak, nonatomic) IBOutlet UITextField *idTextField;  // 아이디 텍스트 필드 변수
@property (weak, nonatomic) IBOutlet UILabel *pwdLable;         // 비밀번호 라벨
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField; // 비밀번호 텍스트 필드 변수
@property (weak, nonatomic) IBOutlet UIButton *btnAutoLogin;    // 자동 로그인 버튼 변수
@property (weak, nonatomic) IBOutlet UILabel *labelAutoLogin;   // 자동 로그인 라벨 변수
@property (weak, nonatomic) IBOutlet UIButton *btnSaveId;       // 아이디 저장 버튼 변수
@property (weak, nonatomic) IBOutlet UILabel *labelSaveId;      // 아이디 저장 라벨 변수
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;        // 로그인 버튼 변수

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pwdTextField.delegate = self; // 위의 UITextFielddelegate 프로토콜을 사용할 때 아이디와 비밀번호 텍스트 필드의 delegate를 self로 지정해준다.
    self.idTextField.delegate = self;
    
    self.navigationItem.title = @"로그인"; // 위의 title을 로그인으로 한다.
    self.idLabel.text = @"아이디";         // 아이디 라벨에 '아이디'라는 문자열을 넣어준다.
    self.pwdLable.text = @"비밀번호";       // 비밀번호 라벨에 '비밀번호'라는 문자열을 넣어준다.
    
    self.labelAutoLogin.text = @"자동 로그인"; // 자동 로그인 라벨에 '자동 로그인' 문자열을 넣어준다.
    self.labelSaveId.text = @"아이디 저장";    // 아이디 저장 라벨에 '아이디 저장' 문자열을 넣어준다.
    [self.btnLogin setTitle:@"로그인" forState:UIControlStateNormal]; // 로그인 버튼에는 setTitle 메서드로 '로그인' 문자열을 가운데에 넣어주고 그 상태를 UIControlStateNormal로 하여 기본 상태로 해준다.
    self.btnLogin.layer.cornerRadius = 5.0f; // 로그인 버튼을 둥글게 만든다.
    
//  현재 User의 Key 상태가 "autoLogin"이고 그 값이 1이라면 자동 로그인 버튼을 클릭한 다음 로그인 버튼을 클릭한 것이므로 다시 실행했을 때 btnAutoLogin을 파란색으로 지정해준다.
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"autoLogin"] && [[NSUserDefaults standardUserDefaults] integerForKey:@"autoLogin"] == 1) {
        self.btnAutoLogin.tag = 1;
        [self.btnAutoLogin setImage:[UIImage imageNamed:@"checkbox_on.png"] forState:UIControlStateNormal];
//  if문의 조건이 아닌 경우는 자동 로그인 버튼을 클릭하지 않았을 때이므로 자동 로그인 버튼을 회색으로 바꿔준다.
    } else {
        self.btnAutoLogin.tag = 0;
        [self.btnAutoLogin setImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlStateNormal];
    }
        
//  아이디 저장 버튼을 클릭하고 로그인을 하였을 때 만약 "loginId"값의 value가 있다면
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"saveId"] && [[NSUserDefaults standardUserDefaults] integerForKey:@"saveId"] == 1) {
        if ([[NSUserDefaults standardUserDefaults] stringForKey:@"loginId"]) {
//          임의의 변수 tmpId에 "loginId"값의 value를 넣어주고
            NSString *tmpId = [[NSUserDefaults standardUserDefaults] stringForKey:@"loginId"];
//          tmpId가 nil이 아니라면
            if (tmpId && tmpId.length > 0) {
//              아이디 텍스트 필드에 tmpId를 지정하고 아이디 저장 버튼은 파란색으로 해주고 tag값은 1로 지정해준다.
                [self.idTextField setText:tmpId];
                self.btnSaveId.tag = 1;
                [self.btnSaveId setImage:[UIImage imageNamed:@"checkbox_on.png"] forState:UIControlStateNormal];
            }
        }
//  else문은 아이디 저장 버튼을 클릭하지 않고 회색인 상태로 로그인을 한 것이기에 그 후 로그인 페이지에는 아이디 텍스트는 비워두고 tag도 0, 아이디 저장 버튼은 회색으로 지정해준다.
    } else {
        self.idTextField.text = @"";
        self.btnSaveId.tag = 0;
        [self.btnSaveId setImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlStateNormal];
    }
}

// actionAutoLogin 메서드는 자동 로그인 버튼을 누르면 파란색, 그 상태에서 누르면 회색으로 변하게 하는 메서드이다.
- (IBAction)actionAutoLogin:(id)sender {
//  View 안에서 _btnAutoLogin은 기본적으로 0의 tag값을 갖고 있기에 버튼을 누르면 if문 안에 들어가고 tag값을 1로 바꾼 다음 이미지를 바꿔준다.
    if (_btnAutoLogin.tag == 0) {
        _btnAutoLogin.tag = 1;
        [_btnAutoLogin setImage:[UIImage imageNamed:@"checkbox_on.png"] forState:UIControlStateNormal];
//  tag값이 1일 때 다시 누르게 되면 tag가 0이 아니니 else로 가게 되고 tag는 0으로 되며 버튼은 회색으로 변한다.
    } else {
        _btnAutoLogin.tag = 0;
        [_btnAutoLogin setImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlStateNormal];
    }
}

// actionSaveId도 actionAutoLogin과 마찬가지로 실행된다.
- (IBAction)actionSaveId:(id)sender {
    if (_btnSaveId.tag == 0) {
        _btnSaveId.tag = 1;
        [_btnSaveId setImage:[UIImage imageNamed:@"checkbox_on.png"] forState:UIControlStateNormal];
    } else {
        _btnSaveId.tag = 0;
        [_btnSaveId setImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlStateNormal];
    }
}

// actionLogin은 로그인 버튼을 누르면 실행되는 메서드이다.
- (IBAction)actionLogin:(id)sender {
    
    [self.view endEditing:YES]; // 로그인 버튼을 눌렀을 때 키보드를 자동으로 숨기게 해준다.
    
    NSString *userId = _idTextField.text; // 아이디 텍스트 필드에 적은 문자열을 userId 변수에 저장한다.
    
//  userId가 nil이 아니라면 해당 로그를 띄워준다.
    if (userId && userId.length > 0) {
        
        NSLog(@"아이디가 있습니다.!");
        
//  userId가 nil이면 해당 로그와 UIAlertController, UIAlertAction를 사용하여 경고창을 띄워준다.
    } else {
        
        NSLog(@"아이디가 없습니다.! 아이디를 입력하세요!");
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"로그인" message:@"아이디를 입력하세요." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *close = [UIAlertAction actionWithTitle:@"닫기" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:close];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
//  비밀번호 텍스트 필드에 적은 문자열을 userPw 변수에 저장한다.
    NSString *userPw = _pwdTextField.text;
    
//  userPw가 nil이 아니라면 해당 로그를 띄워준다.
    if (userPw && userPw.length > 0) {
        
        NSLog(@"비밀번호가 있습니다.!");
//  userPw가 nil이면 해당 로그와 UIAlertController, UIAlertAction를 사용하여 경고창을 띄워준다.
    } else {
        
        NSLog(@"비밀번호가 없습니다.! 비밀번호를 입력하세요!");
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"로그인" message:@"비밀번호를 입력하세요." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *close = [UIAlertAction actionWithTitle:@"닫기" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:close];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
//  url에 있는 데이터를 NSURL, NSMutableURLRequest, NSURLSession, NSURLSessionDataTask, NSHTTPURLResponse 클래스를 사용하여 가져오기
//  url 변수에 해당 주소의 문자열 값을 저장한다.
    NSURL *url = [NSURL URLWithString:@"http://demo1914380.mockable.io/api/login"];
//  NSMutableURLRequest는 NSURLRequest의 자식으로 request의 속성을 바꿀 수 있다. url 변수로 초기화해준다.
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
//  요청 방식은 POST로 해준다.
    [urlRequest setHTTPMethod:@"POST"];
    
//  NSURLSession은 네트워크 데이터 전송 작업 그룹을 조정하는 객체로 sharedSession으로 특정 URL의 내용을 페치할 수 있고 몇 있는 코드를 메모리(session 변수)에 저장할 수 있다.
    NSURLSession *session  = [NSURLSession sharedSession];
//  NSURLSessionDataTask는 다운로드된 데이터를 앱의 메모리에 직접 리턴하는 URL session Task이다. session에 저장된 데이터를 completionHandler의 인자에 저장한다.
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//      NSHTTPURLResponse는 HTTP 프로토콜 URL 로드 요청에 대한 응답과 관련된 메타데이터 클래스이다. httpResponse 변수 안에 요청에 대한 응답 데이터를 가진 NSURLResponse 타입의 변수 response를 NSHTTPURLResponse 타입으로 넣어준다.
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//      지정한 httpResponse의 HTTP 상태 코드인 statusCode가 200이면 아래의 코드를 실행한다.
        if (httpResponse.statusCode == 200) {
//          아래의 Json데이터를 가져올 때 error가 발생하면 NSJSONSerialization의 error 메서드에 err 변수를 넘겨준다. 그래서 아무것도 가져오지 못하게 된다.
            NSError *err = nil;
//          NSJSONSerialization을 사용하여 JSON 데이터를 Foundation 객체로 변환하거나 Foundation 객체를 JSON으로 변환할 수 있다.
//          option:은 만들당시에 option을 추가해서 유연하게 추후 여러 내용을 대응하려고 했지만 현재 사용할 내용이 없어서 우선 0으로 줘서 사용하라고 권고하고 있다.
            NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
//          name 변수에 responseJson안의 userName에 해당하는 value를 가져온다.
            NSString *name = responseJson[@"userName"];
//          UI 작업을 하고 싶을 땐 비동기 처리로 main 함수 안에서 코드를 써야 하는데 dispatch_get_main_queue가 그 역할을 한다.
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSUserDefaults standardUserDefaults] setInteger:self.btnAutoLogin.tag forKey:@"autoLogin"]; // autoLogin에 해당하는 tag값을 NSUserDefaults에 저장한다.
                [[NSUserDefaults standardUserDefaults] setInteger:self.btnSaveId.tag forKey:@"saveId"];       // saveId에 해당하는 tag값을 NSUserDefaults에 저장한다.
                [[NSUserDefaults standardUserDefaults] setObject:self.idTextField.text forKey:@"loginId"];    // loginId에 해당하는 text값을 NSUserDefaults에 저장한다.
                [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"loginName"];                   // loginName 문자열 값을 NSUserDefaults에 저장한다.
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];                        // isLogin에 해당하는 value 값을 YES로 하여 NSUserDefaults에 저장한다.
                [[NSUserDefaults standardUserDefaults] synchronize];                                          // 모든 NSUserDefaults에 공유시킨다.
                
//              로그인 성공 시 환영 Alert를 띄워줌
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"로그인" message:[NSString stringWithFormat:@"%@님 환영합니다.!",name] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
                    
//                  popToRootViewControllerAnimated로 메인 화면으로 돌아가게 한다.
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
//                  handler를 실행시키기 위해 return;을 써준다.
                    return;
                    
                }];
                
//              ok Alert를 추가시킨다.
                [alert addAction:ok];
//              현재 View에 나타나게 한다.
                [self presentViewController:alert animated:YES completion:nil];
//              dispatch_async를 실행시키기 위해 return;을 써준다.
                return;
                
            });
            
        } else {
            
            NSLog(@"error!");
            
        }
    }];
    
//  데이터를 받아오는 작업을 실행한다.
    [dataTask resume];
    
}

// 텍스트 필드의 포커스가 아이디 텍스트 필드에 맞춰지고 키보드의 return 버튼을 누르면
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.idTextField) {
//      비밀번호 텍스트 필드에 초점이 맞춰지게 한다.
        [self.pwdTextField becomeFirstResponder];
    }else{
//      비밀번호 텍스트 필드에 초점이 맞춰지면 textField == self.idTextField는 false여서 로그인이 실행된다.
        [self actionLogin:nil];
    }
//  리턴값은 YES로 고정시킨다.
    return YES;
}

@end
