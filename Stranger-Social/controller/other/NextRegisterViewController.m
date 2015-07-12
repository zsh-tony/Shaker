//
//  NextRegisterViewController.m
//  SchoolExpress
//
//  Created by zsh tony on 15-5-2.
//  Copyright (c) 2015年 zsh-tony. All rights reserved.
//

#import "NextRegisterViewController.h"
#import "MZTimerLabel.h"
#import "MyIconCell.h"
#import "UILabelCell.h"
#import "UITextFieldCell.h"
#import "LPPopup.h"

#define kHeightMargin 10
#define kWidthMargin 35
#define kLabelHeight 44
#define kItemWidth 250
#define kTextWidth 150
#define kTimerWidth 80
#define kBtnHeight 40
#define kPwdMaxWords 16
#define kCodeMaxWords 6
#define kTableviewFrame CGRectMake(0, 64, 320, 568)
#define kUIViewFrame  CGRectMake(0, 0, 320, 568)


@interface NextRegisterViewController ()<MZTimerLabelDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    CGFloat frameHeight;
     LPPopup *popup;
    
    MZTimerLabel *timer;
    UILabel *alterLabel;
    
    UIButton *registerBtn;
   
    UIButton *rePassCodeBtn;
 
    UIButton *iconImage;
    UILabel *sexLabel;
    UITextField *nickName;
    
    NSString *selfCodeId;
    NSString *selfPhone;
    
    
    UIActionSheet* imageSheet;
    UIImagePickerController *imagePicker;
    UIActionSheet* sexSheet;
   
    UIlabelCell *sexCell;
    UITextFieldCell *codeCell;
    UITextFieldCell *pwdCell;
    UITextFieldCell *ensurePwdCell;
    UITextFieldCell *nickNameCell;
    NSString *boundary;
}
@end

@implementation NextRegisterViewController


//(self.view.bounds.size.width - 2*kWidthMargin)
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
         boundary = [NSString stringWithFormat:@"----------V2ymHFg03ehbqgZCaKO6jy"] ;
        alterLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, kLabelHeight)];
        alterLabel.font = [UIFont systemFontOfSize:13];
        alterLabel.backgroundColor = [UIColor clearColor];
        _passPhone = ^(NSString *phone){
            alterLabel.text = [NSString stringWithFormat:@"验证码短信已经发送到+86-%@",[self protectedPhone:phone]] ;
            selfPhone = phone;
        };
        alterLabel.textAlignment = NSTextAlignmentLeft;
        alterLabel.textColor = [UIColor lightGrayColor];
        //[self.view addSubview:alterLabel];
        
        _passCodeId = ^(NSString *codeId){
            selfCodeId = [NSString stringWithFormat:@"%@",codeId];
            NSLog(@"%@",selfCodeId);
        };
      
    }
    return self;
}
-(NSString*)protectedPhone:(NSString *)phoneNumber
{
    NSRange range1 = NSMakeRange(0, 3);
    NSRange range2 = NSMakeRange(7, 4);
    NSString *str = [NSString stringWithFormat:@"%@****%@",[phoneNumber substringWithRange:range1],[phoneNumber substringWithRange:range2]];
    return str;
    
}
- (void)initTimer
{
    timer = [[MZTimerLabel alloc] init];
    timer.timerType = MZTimerLabelTypeTimer;
    timer.frame =CGRectMake(kWidthMargin+kItemWidth-kTimerWidth,0 +5, kTimerWidth, kLabelHeight - kHeightMargin);
    timer.layer.borderWidth = 0.5;
    timer.layer.cornerRadius = 5;
    timer.layer.borderColor = [kGetColor(200, 200, 200) CGColor];
    timer.timeLabel.textAlignment = NSTextAlignmentCenter;
    timer.timeLabel.font = [UIFont systemFontOfSize:13.0f];
    timer.timeLabel.textColor = [UIColor lightGrayColor];
    [timer setCountDownTime:60];
    
    [timer start];
    timer.timeFormat = @"ss";
    timer.delegate = self;
}

- (void)initRePassCodeBtn
{
    rePassCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidthMargin+kItemWidth-kTimerWidth,5 , kTimerWidth,kLabelHeight- kHeightMargin)];
    rePassCodeBtn.backgroundColor = kGetColor(0, 172, 237);
    rePassCodeBtn.layer.borderWidth = 0.5;
    rePassCodeBtn.layer.cornerRadius = 5;
    rePassCodeBtn.layer.borderColor = [kGetColor(0, 172, 237) CGColor];
    rePassCodeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    rePassCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    rePassCodeBtn.titleLabel.textColor = [UIColor lightGrayColor];
    [rePassCodeBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
    [rePassCodeBtn addTarget:self action:@selector(rePassCode) forControlEvents:UIControlEventTouchUpInside];
}
-(void)rePassCode
{
    [rePassCodeBtn removeFromSuperview];
    [codeCell.contentView addSubview:timer];
    [timer reset];
    [timer start];
    
    NSURLRequest *request = [NSURLRequest requestWithPath:kRegistUserPath params:@{@"phone":selfPhone,                                                  }];
    
    NSHTTPURLResponse *response = nil;
    NSError *error =nil;
    NSLog(@"%@",request);
    NSData *responeData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *responesStr = [[NSString alloc]initWithData:responeData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@----%@",teststr1,teststr);
    NSLog(@"responeStr%@",responesStr);
    
    
    int code =   [responesStr intValue];
    
    if (code >0) {
        selfCodeId = [NSString stringWithFormat:@"%d",code];
        //alterLabel.hidden = NO;
    }else{
        //alterLabel.text = @"发送失败";
        //alterLabel.hidden = NO;
    }
    
}
- (void)addKeyobserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kGlobalBg;
    self.title = @"注册";
    
    [self addKeyobserver];
    //[self addSubviews];
    [self initTimer];
    [self initTableView];
    [self initRePassCodeBtn];
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


-(void)sendRegister
{
    
    if (![pwdCell.textField.text isEqualToString:ensurePwdCell.textField.text]) {
        
        popup = [LPPopup popupWithText:@"两次输入的密码不一致!"];
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
        
//        BOOL success;
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        NSError *error;
//        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
//        NSLog(@"imageFile->>%@",imageFilePath);
//        
//        NSLog(@"文件存在否%u",[fileManager fileExistsAtPath:imageFilePath]);
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
//            
//            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//            
//            NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
//            //body
//            NSData *body = [self prepareDataForUploadWith:imageFilePath];
//            //request
//            NSMutableURLRequest *imageRequest = [NSURLRequest mutableRequestWithPath:kUploadImagePath params:@{@"phone":selfPhone}];
//            [imageRequest setHTTPMethod:@"POST"];
//            
//            // 以下2行是关键，NSURLSessionUploadTask不会自动添加Content-Type头
//            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
//            [imageRequest setValue:contentType forHTTPHeaderField: @"Content-Type"];
//            
//            NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:imageRequest fromData:body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
//                
//                NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"message:== %@", message);
//              
//                
//                [session invalidateAndCancel];
//            }];
//            
//            [uploadTask resume];
//        });
//
//        NSData *imageData = UIImageJPEGRepresentation([iconImage backgroundImageForState:UIControlStateNormal], 1.0f);
//        
//        NSMutableURLRequest *imageRequest = [NSURLRequest mutableRequestWithPath:kUploadImagePath params:@{@"phone":selfPhone}];
////        NSString *imageUrlStr = [NSString stringWithFormat:@"http://202.117.77.156:8088/AEMI/UploadImage"];
////        imageUrlStr = [imageUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
////        
////        NSURL *imageUrl = [NSURL URLWithString:imageUrlStr];
//        //NSMutableURLRequest *imageRequest = [NSMutableURLRequest requestWithURL:imageUrl];
//          NSString *content=[[NSString alloc]initWithFormat:@"application/x-www-form-urlencoded; charset=utf-8"];
//        //设置HTTPHeader
//        [imageRequest setValue:content forHTTPHeaderField:@"Content-Type"];
//               [imageRequest setHTTPMethod:@"POST"];
//        [imageRequest setHTTPBody:imageData];
//        
//        NSHTTPURLResponse *imageResponse = nil;
//        NSError *imageError =nil;
//        NSData *imageResponeData = [NSURLConnection sendSynchronousRequest:imageRequest returningResponse:&imageResponse error:&imageError];
//        // NSDictionary *testdict= [NSJSONSerialization JSONObjectWithData:responeData options:0 error:&jsonParseError];
//        NSLog(@"%@",imageData);
//        NSString *teststr = [[NSString alloc]initWithData:imageResponeData encoding:NSUTF8StringEncoding];
//        NSLog(@"返回的---%@",teststr);

        
        
        NSLog(@"selfCodeid=%@",selfCodeId);
        NSDictionary *dict= @{@"codeId":selfCodeId,@"code":codeCell.textField.text,@"passwd":pwdCell.textField.text,@"nickName":nickNameCell.textField.text,@"sex":sexLabel.text};
        NSLog(@"%@",dict);
        
        NSLog(@"%hhd",[NSJSONSerialization isValidJSONObject:dict]);
        NSError *jsonWriteError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&jsonWriteError];
        
         NSMutableURLRequest *infoRequest = [NSURLRequest mutableRequestWithPath:kRegistUserPath params:nil];
 
//        NSString *infoUrlStr = [NSString stringWithFormat:@"http://202.117.77.156:8088/AMEI/RegistUser"];
//        infoUrlStr = [infoUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSURL *infoUrl = [NSURL URLWithString:infoUrlStr];
//        NSMutableURLRequest *infoRequest = [NSMutableURLRequest requestWithURL:infoUrl];
        
        [infoRequest setHTTPMethod:@"POST"];
        [infoRequest setHTTPBody:jsonData];
        
        NSHTTPURLResponse *infoResponse = nil;
        NSError *infoError =nil;
        NSData *infoResponeData = [NSURLConnection sendSynchronousRequest:infoRequest returningResponse:&infoResponse error:&infoError];
        NSString *teststr1 = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *infoResponesStr = [[NSString alloc]initWithData:infoResponeData encoding:NSUTF8StringEncoding];
        NSLog(@"%@----%@",teststr1,infoResponesStr);
        
        int code = [infoResponesStr intValue];
        
        if (code >0) {
            UIAlertView *aterView = [[UIAlertView alloc]initWithTitle:@"注册成功" message:nil delegate:self  cancelButtonTitle:nil otherButtonTitles:@"点击登录", nil];
            
            [aterView show];
            
            
        }
    }

}

-(NSData*) prepareDataForUploadWith:(NSString*)uploadFilePath
{
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    NSString *uploadFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];<span class="comment" style="margin: 0px; padding: 0px; border: none; color: rgb(0, 130, 0); font-family: Consolas, 'Courier New', Courier, mono, serif; line-height: 17.600000381469727px; ">//将图片放在了documents中</span><span style="margin: 0px; padding: 0px; border: none; font-family: Consolas, 'Courier New', Courier, mono, serif; line-height: 17.600000381469727px; ">  </span>
    
    NSString *lastPathfileName = [uploadFilePath lastPathComponent];
    
    NSMutableData *body = [NSMutableData data];
    
    NSData *dataOfFile = [[NSData alloc] initWithContentsOfFile:uploadFilePath];
    
    
    if (dataOfFile) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", @"file", lastPathfileName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/zip\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:dataOfFile];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return body;
}

-(void)finalRegister
{
    
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    if ([[iconImage backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"上传头像.png"]]) {
        popup = [LPPopup popupWithText:@"请上传头像!"];
        popup.popupColor = [UIColor blackColor];
        popup.alpha = 0.8;
        popup.textColor = [UIColor whiteColor];
        popup.font = kDetailContentFont;
        //popup.textInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        [popup showInView:self.view
            centerAtPoint:self.view.center
                 duration:3
               completion:nil];
    }else if([nickNameCell.textField.text isEqualToString:@""]){
        popup = [LPPopup popupWithText:@"请设置昵称!"];
        popup.popupColor = [UIColor blackColor];
        popup.alpha = 0.8;
        popup.textColor = [UIColor whiteColor];
        popup.font = kDetailContentFont;
        //popup.textInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        [popup showInView:self.view
            centerAtPoint:self.view.center
                 duration:3
               completion:nil];
    }else if([sexLabel.text isEqualToString:@"设置性别"]){
        popup = [LPPopup popupWithText:@"请设置性别!"];
        popup.popupColor = [UIColor blackColor];
        popup.alpha = 0.8;
        popup.textColor = [UIColor whiteColor];
        popup.font = kDetailContentFont;
        //popup.textInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        [popup showInView:self.view
            centerAtPoint:self.view.center
                 duration:3
               completion:nil];
    }else if([codeCell.textField.text isEqualToString:@""]){
        popup = [LPPopup popupWithText:@"请输入短信验证码!"];
        popup.popupColor = [UIColor blackColor];
        popup.alpha = 0.8;
        popup.textColor = [UIColor whiteColor];
        popup.font = kDetailContentFont;
        //popup.textInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        [popup showInView:self.view
            centerAtPoint:self.view.center
                 duration:3
               completion:nil];
    }else if([pwdCell.textField.text isEqualToString:@""]){
        popup = [LPPopup popupWithText:@"请设置登录密码!"];
        popup.popupColor = [UIColor blackColor];
        popup.alpha = 0.8;
        popup.textColor = [UIColor whiteColor];
        popup.font = kDetailContentFont;
        //popup.textInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        [popup showInView:self.view
            centerAtPoint:self.view.center
                 duration:3
               completion:nil];
    }else if([ensurePwdCell.textField.text isEqualToString:@""]){
        popup = [LPPopup popupWithText:@"请确认登录密码!"];
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
        [self sendRegister];
    }
        
    
   
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
         [self.navigationController popToRootViewControllerAnimated:NO];
}
    
-(NSString*)timerLabel:(MZTimerLabel*)timerLabel customTextToDisplayAtTime:(NSTimeInterval)time
{
    
    return [NSString stringWithFormat:@"%d秒后重发",(int)time];
}
-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    //time is up, what should I do master?
    [timer removeFromSuperview];
    [codeCell.contentView addSubview:rePassCodeBtn];
    [alterLabel setHidden:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    //如果不加这个，每次都会换行了
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if ([textField isEqual:codeCell.textField]) {
        frameHeight = 390;
    }else if ([textField isEqual:pwdCell.textField]) {
        frameHeight = 430;
    }else if ([textField isEqual:ensurePwdCell.textField]) {
        frameHeight = 475;
    }else{
        frameHeight = 90;
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:codeCell.textField]) {
        if (textField.text.length  >= kCodeMaxWords && string.length > range.length) {
            return NO;
        }else{
            return YES;
        }

    }else if ([textField isEqual:pwdCell.textField]){
    if (textField.text.length  >= kPwdMaxWords && string.length > range.length) {
        return NO;
    }else{
        return YES;
    }
    }else if ([textField isEqual:ensurePwdCell.textField]){
        if (textField.text.length  >= kPwdMaxWords && string.length > range.length) {
            return NO;
        }else{
            return YES;
        }
    }else{
        return YES;
    }
    
    
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


////////////////////////////////////////////////////////////////////////////
- (void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.SectionFooterHeight =0;
    self.tableView.sectionHeaderHeight = 0;
    self.view.backgroundColor = kGetColor(240, 255, 230);
    
    //    UIButton *send = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [send setAllStateBg:@"common_button_big_red.png"];
    //    [send setTitle:@"退出当前账号" forState:UIControlStateNormal];
    //    send.frame = CGRectMake(10, 10, 300, 44);//footview会自动延伸,处理方法，在底层加了个纯洁的uiview
    //    [send addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    //    [footer addSubview:send];
    //    self.tableView.tableFooterView = footer;
    
    UIView *header = [[UIView alloc]init];
    header.frame = CGRectMake(0, 0, 320, 140);
    iconImage = [[UIButton alloc]initWithFrame:CGRectMake(100, 30, 120, 120)];
    [iconImage setBackgroundImage:[UIImage imageNamed:@"上传头像.png"] forState:UIControlStateNormal];
    [iconImage setBackgroundImage:[UIImage imageNamed:@"上传头像.png"] forState:UIControlStateHighlighted];
    [iconImage addTarget:self action:@selector(uploadIcon) forControlEvents:UIControlEventTouchUpInside];
    iconImage.layer.cornerRadius = 60;
    [iconImage.layer setMasksToBounds:YES];
    [header addSubview:iconImage];
    self.tableView.tableHeaderView = header;

    UIView *footer = [[UIView alloc]init];
    footer.frame = CGRectMake(0, 0, 300, 70);
    registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidthMargin, 10, kItemWidth, kBtnHeight)];
    registerBtn.backgroundColor = kGetColor(0, 172, 237);
    registerBtn.layer.cornerRadius = 5;
    [registerBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(finalRegister) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:registerBtn];
    self.tableView.tableFooterView = footer;
    [self.view addSubview:self.tableView];
}

-(void)uploadIcon
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    imageSheet = [[UIActionSheet alloc]
                  initWithTitle:nil
                  delegate:self
                  cancelButtonTitle:@"取消"
                  destructiveButtonTitle:nil
                  otherButtonTitles:@"照相机",@"本地相册",nil];
    
    [imageSheet showInView:self.view];
}

#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex = [%d]",buttonIndex);
    
    if (actionSheet == sexSheet) {
        switch (buttonIndex) {
            case 0:
                sexLabel.textColor = [UIColor blackColor];
                sexLabel.text = @"男";
                break;
            case 1:
                sexLabel.textColor = [UIColor blackColor];
                sexLabel.text = @"女";
                break;
            default:
                break;
        }
        
    }else{
        switch (buttonIndex) {
            case 0://照相机
            {
                if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
                    imagePicker = [[UIImagePickerController alloc] init];
                    imagePicker.delegate = self;
                    imagePicker.allowsEditing = YES;
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    
                    [self presentViewController:imagePicker animated:YES completion:nil];
                }else{
                    NSLog(@"没有摄像头");
                }
            }
                break;
            case 1://相册
            {
                imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //            [self presentModalViewController:imagePicker animated:YES];
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
    }
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(260, 7, 40, 30)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelPick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    [viewController.navigationItem setRightBarButtonItem:rightItem animated:NO];
    
}
-(void)cancelPick
{
    NSLog(@"sadf") ;
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(saveImage:)  withObject:image afterDelay:0.5];
    self.tableView.frame = CGRectMake(0, 0, 320, 568);
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    
        }];
}



- (void)saveImage:(UIImage *)image {
    //    NSLog(@"保存头像！");
    //    [userPhotoButton setImage:image forState:UIControlStateNormal];
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
    //UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(93, 93)];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    //    [userPhotoButton setImage:selfPhoto forState:UIControlStateNormal];
    
    // NSError *imageError = nil;
    
    //if ([teststr isEqualToString:@"success"]) {
    [iconImage  setBackgroundImage:selfPhoto forState:UIControlStateNormal];
    [iconImage  setBackgroundImage:selfPhoto forState:UIControlStateHighlighted];
    // }
    
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark - uitableviewdelegate 的实现
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return     2;
    // Return the number of sections.
    //return data.count;
    //return dataArray.count;//控制有几行显示
}
- ( CGFloat )tableView:( UITableView *)tableView heightForHeaderInSection:( NSInteger )section

{
    
    return 30.0 ;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
       
        return alterLabel.text;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
        return 44;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else{
    return 3;
    }
    
    
    // Return the number of rows in the section.
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *CellIdentifier3 = @"myCell";
            nickNameCell = [tableView                               dequeueReusableCellWithIdentifier:CellIdentifier3];
            if (nickNameCell == nil) {
                nickNameCell = [[UITextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault                   reuseIdentifier:CellIdentifier3] ;
            }
            nickNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
         
            nickNameCell.textField.placeholder = @"设置昵称";
            nickNameCell.textField.delegate = self;
          
            
            return nickNameCell;
        }else{
            static NSString *CellIdentifier2 = @"sexCell";
            sexCell = [tableView                               dequeueReusableCellWithIdentifier:CellIdentifier2];
            if (sexCell == nil) {
                sexCell = [[UIlabelCell alloc]initWithStyle:UITableViewCellStyleDefault                   reuseIdentifier:CellIdentifier2] ;
            }
            sexCell.selectionStyle = UITableViewCellSelectionStyleNone;
            sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidthMargin, 0, [UIScreen mainScreen].applicationFrame.size.width, kLabelHeight)];
            sexLabel.textColor = kGetColor(200, 200, 200);
            sexLabel.textAlignment = NSTextAlignmentLeft;
            sexLabel.backgroundColor = [UIColor clearColor];
            sexLabel.font = kDetailContentFont;
            sexLabel.text = @"设置性别";
            [sexCell.contentView addSubview:sexLabel];
//            sexCell.titleLabel.textColor = [UIColor lightGrayColor];
//            sexCell.titleLabel.text = @"设置性别";
            
            return sexCell;
        }
    }else{
        if (indexPath.row == 0) {
            static NSString *CellIdentifier3 = @"codeCell";
         codeCell = [tableView                               dequeueReusableCellWithIdentifier:CellIdentifier3];
            if (codeCell == nil) {
                codeCell = [[UITextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault                   reuseIdentifier:CellIdentifier3] ;
            }
            codeCell.selectionStyle = UITableViewCellSelectionStyleNone;
           
            codeCell.textField.keyboardType = UIKeyboardTypeNumberPad;
         
            codeCell.textField.placeholder = @"请输入短信验证码";
        
            codeCell.textField.delegate = self;
          
            [codeCell.contentView addSubview:timer];
            return codeCell;
        }else if(indexPath.row== 1){
            static NSString *CellIdentifier4 = @"pwdCell";
            pwdCell = [tableView                               dequeueReusableCellWithIdentifier:CellIdentifier4];
            if (pwdCell == nil) {
                pwdCell = [[UITextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault                   reuseIdentifier:CellIdentifier4] ;
            }
            pwdCell.selectionStyle = UITableViewCellSelectionStyleNone;
          
        
            pwdCell.textField.placeholder = @"设置登录密码";

            pwdCell.textField.delegate = self;
            pwdCell.textField.keyboardType = UIKeyboardTypeNamePhonePad;
            pwdCell.textField.secureTextEntry = YES;
            
            return pwdCell;
            
        }else{
            static NSString *CellIdentifier4 = @"ensurePwdCell";
            ensurePwdCell = [tableView                               dequeueReusableCellWithIdentifier:CellIdentifier4];
            if (ensurePwdCell == nil) {
                ensurePwdCell = [[UITextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault                   reuseIdentifier:CellIdentifier4] ;
            }
            ensurePwdCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            ensurePwdCell.textField.placeholder = @"确认登录密码";

            ensurePwdCell.textField.secureTextEntry = YES;
            ensurePwdCell.textField.keyboardType = UIKeyboardTypeNamePhonePad;
            ensurePwdCell.textField.delegate = self;

            return ensurePwdCell;
        }
        
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            sexSheet = [[UIActionSheet alloc]
                        initWithTitle:nil
                        delegate:self
                        cancelButtonTitle:@"取消"
                        destructiveButtonTitle:nil
                        otherButtonTitles:@"男",@"女",nil];
            
            [sexSheet showInView:self.view];
            
        }
    }
}

#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    NSDictionary *userInfo = [notification userInfo];
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    CGFloat height = keyboardRect.size.height - (568-frameHeight);
    [animationDurationValue getValue:&animationDuration];
    [self.tableView setScrollEnabled:YES];
    NSLog(@"%f",height);
    if (height < 0) {//<0说明，界面不用升降，只用把tableview的大小调一下，以当滑动时，界面都能显示
        [UIView animateWithDuration:animationDuration animations:^{
            self.tableView.frame =CGRectMake(0, 0, 320, 568-keyboardRect.size.height-self.view.frame.origin.y);
            // self.tableView.frame =CGRectMake(0, 44, 320, 524-keyboardRect.size.height-self.view.frame.origin.y);不加self.view.frame.origin.y的话后面先点下面的再点上面的uitextview会导致不对
            
        }];
        
    }
    if (height > 0) {//大于0时说明界面要升降，
        [UIView animateWithDuration:animationDuration animations:^{
          
            
            self.tableView.frame =CGRectMake(0, 44, 320, 524-keyboardRect.size.height+height);
            
            self.view.frame = CGRectMake(0, -height, 320, 568);
            self.tableView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);
            
        }];
        
    }
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    //[self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    //[self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        [UIView animateWithDuration:0.2 animations:^{
            
            
            self.tableView.frame = kTableviewFrame;
            self.view.frame = kUIViewFrame;
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }];
        
        
    }];
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
