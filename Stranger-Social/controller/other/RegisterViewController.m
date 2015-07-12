//
//  registerViewController.m
//  SchoolExpress
//
//  Created by zsh tony on 15-4-23.
//  Copyright (c) 2015年 zsh-tony. All rights reserved.
//

#import "RegisterViewController.h"
#import "NextRegisterViewController.h"
#import "LPPopup.h"
#define kphoneLimitWords 11
#define kPwdMaxWords 20
#define kPwdMinWords 6
#define kWidthMargin 20
#define kHeightMargin 30
#define kLabelWidth 60
#define kLabelHeight 50
#define kBtnHeight 40
#define kBtnWidth 260

@interface RegisterViewController ()
{
    LPPopup *popup;
}
@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kGlobalBg;
    [self addSubViews];
    self.title = @"注册";
//       self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithBg:@"navigationbar_back.png" title:@"取消" size:CGSizeMake(80, 30) target:self action:@selector(popVC)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithIcon:@"navigationbar_back.png" target:self action:@selector(popVC)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    
        tapGesture.cancelsTouchesInView = NO;
    
        [self.view addGestureRecognizer:tapGesture];
    
}
-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
-(void)popVC
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addSubViews
{
    
    // Do any additional setup after loading the view.
    self.phoneLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, kHeightMargin, kLabelWidth, kLabelHeight)];
    self.phoneLabel.text = @"+86";
    self.phoneLabel.textAlignment = NSTextAlignmentRight;
//    self.phoneLabel.layer.borderWidth = 0.5;
//    self.phoneLabel.layer.cornerRadius = 5;
//    self.phoneLabel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.phoneLabel.font = k18Font;
    self.phoneLabel.backgroundColor = [UIColor whiteColor];
    self.phoneLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.phoneLabel];
    
  
    
    
    self.note =[[UILabel alloc]initWithFrame:CGRectMake(kWidthMargin, _phoneLabel.frame.size.height + _phoneLabel.frame.origin.y +kHeightMargin, 260, 20)];
    self.note.text = @"点击“下一步”表示您已阅读并遵守“免责声明”";
    self.note.font = [UIFont systemFontOfSize:13];
    //[self.note sizeToFit];
    self.note.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.note];
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(_phoneLabel.frame.size.width + _phoneLabel.frame.origin.x , _phoneLabel.frame.origin.y, 20, kLabelHeight)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    self.phoneText =[[UITextField alloc]initWithFrame:CGRectMake(whiteView.frame.size.width +whiteView.frame.origin.x, _phoneLabel.frame.origin.y, 260, kLabelHeight)];
    self.phoneText.font = k18Font;
    self.phoneText.placeholder = @"请输入手机号";

    self.phoneText.keyboardType = UIKeyboardTypePhonePad;
    self.phoneText.backgroundColor = [UIColor whiteColor];
    self.phoneText.delegate = self;
    [self.view addSubview:self.phoneText];


    UIView *seperator = [[UIView alloc]initWithFrame:CGRectMake(0, _phoneLabel.frame.origin.y, [UIScreen mainScreen].applicationFrame.size.width, 0.5)];
    seperator.backgroundColor = kSeperatorDarkColor;
    [self.view addSubview:seperator];
    
    UIView *seperator1 = [[UIView alloc]initWithFrame:CGRectMake(0, _phoneLabel.frame.origin.y +_phoneLabel.frame.size.height, [UIScreen mainScreen].applicationFrame.size.width, 0.5)];
    seperator1.backgroundColor = kSeperatorDarkColor;
    [self.view addSubview:seperator1];
    
    UIView *seperator2 = [[UIView alloc]initWithFrame:CGRectMake(_phoneLabel.frame.size.width +_phoneLabel.frame.origin.x, _phoneLabel.frame.origin.y , 0.5, kLabelHeight)];
    seperator2.backgroundColor = kSeperatorDarkColor;
    [self.view addSubview:seperator2];
    
    
    
    self.loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].applicationFrame.size.width - kBtnWidth)/2, kHeightMargin +_note.frame.origin.y+_note.frame.size.height, kBtnWidth, kBtnHeight)];
        self.loginBtn.layer.borderWidth = 0.5;
        self.loginBtn.layer.cornerRadius = 5;
        self.loginBtn.layer.borderColor = [kGetColor(0,165,224) CGColor];
    self.loginBtn.backgroundColor = kGetColor(0,165,224);
    [self.loginBtn setTitle:@"获取短信验证码" forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
    
}
-(void)next
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
   UIActivityIndicatorView *indictor = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(140, 320, 40, 40 )];
    [self.view addSubview:indictor];
    [indictor startAnimating];


    
    if (![self checkTel:self.phoneText.text]) {
        NSLog(@"sijdfosjid");
   
        
    }else{
     
        NSURLRequest *request = [NSURLRequest requestWithPath:kRegistUserPath params:@{@"phone":self.phoneText.text,                                                  }];
                //
        NSHTTPURLResponse *response = nil;
        NSError *error =nil;
        NSLog(@"%@",request);
        NSData *responeData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *responesStr = [[NSString alloc]initWithData:responeData encoding:NSUTF8StringEncoding];
        //NSLog(@"%@----%@",teststr1,teststr);
        NSLog(@"responeStr%@",responesStr);
        
         int code =   [responesStr intValue];
        NSLog(@"code=%d",code);
        
        if (code > 0) {
            [indictor stopAnimating];
            NextRegisterViewController *next = [[NextRegisterViewController alloc]init];
            if (next.passCodeId) {
                next.passCodeId([NSString stringWithFormat:@"%d",code]);
            }
            if (next.passPhone) {
                next.passPhone(self.phoneText.text);
            }
            [self.navigationController pushViewController:next animated:YES];
        }else{
            popup = [LPPopup popupWithText:@"用户已存在!"];
            popup.popupColor = [UIColor blackColor];
            popup.alpha = 0.8;
            popup.textColor = [UIColor whiteColor];
            popup.font = kDetailContentFont;
            //popup.textInsets = UIEdgeInsetsMake(10, 0, 0, 0);
            [popup showInView:self.view
                centerAtPoint:self.view.center
                     duration:3
                   completion:nil];
        }

    }

}


- (BOOL)checkTel:(NSString *)str

{
    
    if ([str length] == 0) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"手机号为空", nil) message:NSLocalizedString(@"请输入手机号码", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        
        return NO;
        
    }
    
    //1[0-9]{10}
    
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    //    NSString *regex = @"[0-9]{11}";
    
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        
        return NO;
        
    }
    
    
    
    return YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( [string isEqualToString:@"\n"] ) {
        //Do whatever you want
        
        [textField resignFirstResponder];
        
        //如果不加这个，每次都会换行了
    }
    if (textField.text.length  >= kphoneLimitWords && string.length > range.length) {
        return NO;
    }
    return YES;

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    if ( [text isEqualToString:@"\n"] ) {
        //Do whatever you want
        
        [textView resignFirstResponder];
        
        //如果不加这个，每次都会换行了
    }
    if (textView.text.length  >= kphoneLimitWords && text.length > range.length) {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
