//
//  AlterPhoneViewController1.m
//  SchoolExpress
//
//  Created by zsh tony on 15-5-8.
//  Copyright (c) 2015年 zsh-tony. All rights reserved.
//

#import "AlterPhoneViewController.h"
#import "MZTimerLabel.h"
#import "LPPopup.h"
#define kHeightMargin 10
#define kWidthMargin 35
#define kLabelHeight 30
#define kItemWidth 250
#define kTextWidth 150
#define kTimerWidth 80
#define kBtnHeight 40
#define kPwdMaxWords 16
#define kCodeMaxWords 4
@interface AlterPhoneViewController ()<MZTimerLabelDelegate,UITextFieldDelegate>
{
    MZTimerLabel *timer;
    UITableViewCell *phoneCell;
    UITableViewCell *codeCell;
    UILabel *alterLabel;
    UITextField *codeText;
    UITextField *keywordText;
    UITextField *ensureKeyword;
    UIButton *alterBtn;
    UIView *seperator3;
    UIButton *reSendCodeBtn;
    UILabel *alterCode;
    NSString *tmpPhone;
    LPPopup *popup;
}
@end

@implementation AlterPhoneViewController


//(self.view.bounds.size.width - 2*kWidthMargin)
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        

        
    }
    return self;
}

- (void)initTimer
{
    timer = [[MZTimerLabel alloc] init];
    timer.timerType = MZTimerLabelTypeTimer;
    timer.frame =CGRectMake(kWidthMargin+kItemWidth-kTimerWidth,7 , kTimerWidth, kLabelHeight);
    timer.layer.borderWidth = 0.5;
    timer.layer.cornerRadius = 5;
    timer.layer.borderColor = [kGetColor(200, 200, 200) CGColor];
    timer.timeLabel.textAlignment = NSTextAlignmentCenter;
    timer.timeLabel.font = [UIFont systemFontOfSize:13.0f];
    timer.timeLabel.textColor = [UIColor lightGrayColor];
    [timer setCountDownTime:60];
    //[self.view addSubview:timer];
    //[timer start];
    timer.timeFormat = @"ss";
    timer.delegate = self;
}
-(NSString*)timerLabel:(MZTimerLabel*)timerLabel customTextToDisplayAtTime:(NSTimeInterval)time
{
    
    return [NSString stringWithFormat:@"%d秒后重发",(int)time];
}
-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    //time is up, what should I do master?
    [timer removeFromSuperview];
    [reSendCodeBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
    [phoneCell.contentView addSubview:reSendCodeBtn];
    //self.tableView.tableHeaderView= nil;
}

- (void)initReSendCodeBtn
{
    reSendCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidthMargin+kItemWidth-kTimerWidth,7 , kTimerWidth, kLabelHeight)];
    reSendCodeBtn.backgroundColor = kGetColor(0,165,224);
    reSendCodeBtn.layer.borderWidth = 0.5;
    reSendCodeBtn.layer.cornerRadius = 5;
    reSendCodeBtn.layer.borderColor = [kGetColor(0,165,224) CGColor];
    reSendCodeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    reSendCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    //reSendCodeBtn.titleLabel.textColor = [UIColor blueColor];
    [reSendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [reSendCodeBtn addTarget:self action:@selector(reSendCode) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)reSendCode
{
    popup = [LPPopup popupWithText:@"短信验证码已发送到手机,请注意查收!"];
    popup.popupColor = [UIColor blackColor];
    popup.alpha = 0.8;
    popup.textColor = [UIColor whiteColor];
    popup.font = kDetailContentFont;
    [popup showInView:self.view
        centerAtPoint:self.view.center
             duration:3.0f
           completion:nil];
    
  //self.tableView.tableHeaderView = alterLabel;
    
    [reSendCodeBtn removeFromSuperview];
    [phoneCell.contentView addSubview:timer];
//    if (timer.counting) {
//        <#statements#>
//    }
    [timer reset];
    [timer start];
   // NSURLRequest *request = [NSURLRequest requestWithPath:nil params:@{@"phoneNumber":tmpPhone,                                                  }];
    //    NSLog(@"%@",self.phoneText.text);
    //    //[request setHTTPMethod:@"POST"];
    //
    //
    //    NSHTTPURLResponse *response = nil;
    //    NSError *error =nil;
    //    //NSError *jsonParseError = nil;
    //
    //    NSData *responeData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //    // NSDictionary *testdict= [NSJSONSerialization JSONObjectWithData:responeData options:0 error:&jsonParseError];
    //    // NSString *teststr1 = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    NSString *teststr = [[NSString alloc]initWithData:responeData encoding:NSUTF8StringEncoding];
    //    NSLog(@"----%@",teststr);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kGlobalBg;
    self.title = @"更改手机号";
    
    [self initTimer];
    [self initTableView];
    [self initReSendCodeBtn];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    
    tapGesture.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapGesture];
    
}
-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
- (void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.SectionFooterHeight =0;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.backgroundColor = kGlobalBg;
        UIView *footer = [[UIView alloc]init];
        footer.frame = CGRectMake(0, 0, 300, 70);
        UIButton *alter = [UIButton buttonWithType:UIButtonTypeCustom];
        [alter setAllStateBg:@"common_button_big_red.png"];
        [alter setTitle:@"更改" forState:UIControlStateNormal];
        alter.frame = CGRectMake(10, 10, 300, 44);//footview会自动延伸,处理方法，在底层加了个纯洁的uiview
        [alter addTarget:self action:@selector(alter) forControlEvents:UIControlEventTouchUpInside];
        [footer addSubview:alter];
        self.tableView.tableFooterView = footer;
    
        alterLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidthMargin, kHeightMargin, kItemWidth, kLabelHeight)];
        alterLabel.font = [UIFont systemFontOfSize:13];
        alterLabel.backgroundColor = [UIColor clearColor];
        alterLabel.textAlignment = NSTextAlignmentLeft;
        alterLabel.textColor = kTitleColor;
        alterLabel.text = @"短信验证码已发送到手机,请注意查收!";
    //self.tableView.tableHeaderView = alterLabel;
    [self.view addSubview:self.tableView];
}
-(void)alter
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (![keywordText.text isEqualToString:ensureKeyword.text]) {
        popup = [LPPopup popupWithText:@"两次密码输入不一致!"];
        popup.popupColor = [UIColor blackColor];
        popup.alpha = 0.8;
        popup.textColor = [UIColor whiteColor];
        popup.font = kDetailContentFont;
        [popup showInView:self.view
            centerAtPoint:self.view.center
                 duration:3.0f
               completion:nil];
    }
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    NSURLRequest *request = [NSURLRequest requestWithPath:kUpdateUserPath params:@{@"passwd":keywordText.text,                                                  }];
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
    
    if (code > 0){
        popup = [LPPopup popupWithText:@"修改成功!"];
        popup.popupColor = [UIColor blackColor];
        popup.alpha = 0.8;
        popup.textColor = [UIColor whiteColor];
        popup.font = kDetailContentFont;
        //popup.textInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        [popup showInView:self.view
            centerAtPoint:self.view.center
                 duration:3
               completion:nil];
    }else{
        popup = [LPPopup popupWithText:@"修改失败，再试一次!"];
        popup.popupColor = [UIColor blackColor];
        popup.alpha = 0.8;
        popup.textColor = [UIColor whiteColor];
        popup.font = kDetailContentFont;
        //popup.textInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        [popup showInView:self.view
            centerAtPoint:self.view.center
                 duration:3
               completion:nil];
    }}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *CellIdentifier1 = @"phoneCell";
         phoneCell = [tableView                               dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (phoneCell == nil) {
            phoneCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault                   reuseIdentifier:CellIdentifier1] ;
        }
        phoneCell.selectionStyle = UITableViewCellSelectionStyleNone;

        UITextField *phoneField = [[UITextField alloc]initWithFrame:CGRectMake(kWidthMargin, k10HeightMargin, kItemWidth, phoneCell.frame.size.height - 20)];
        [phoneCell.contentView addSubview:phoneField];
        phoneField.placeholder = @"请输入新的手机号";
        phoneField.font = k13Font;
        [phoneCell.contentView addSubview:reSendCodeBtn];
        return phoneCell;
    }else{
        static NSString *CellIdentifier2 = @"codeCell";
        codeCell = [tableView                               dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (codeCell == nil) {
            codeCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault                   reuseIdentifier:CellIdentifier2] ;
        }
        codeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITextField *phoneField = [[UITextField alloc]initWithFrame:CGRectMake(kWidthMargin, k10HeightMargin, kItemWidth, phoneCell.frame.size.height - 20)];
        phoneField.font = k13Font;
        [codeCell.contentView addSubview:phoneField];
        phoneField.placeholder = @"请输入短信验证码";
        
        return codeCell;
    }

}


//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    
//    //如果不加这个，每次都会换行了
//    return YES;
//}
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if ([textField isEqual:codeText]) {
//        if (textField.text.length  >= kCodeMaxWords && string.length > range.length) {
//            return NO;
//        }
//        
//    }else{
//        if (textField.text.length  >= kPwdMaxWords && string.length > range.length) {
//            return NO;
//        }
//    }
//    alterCode.hidden = YES;
//    return YES;
//}
//
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
