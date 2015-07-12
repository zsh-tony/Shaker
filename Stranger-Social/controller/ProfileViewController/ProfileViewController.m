//
//  ProfileViewController.m
//  Stranger-Social
//
//  Created by lerrruby on 15/5/21.
//  Copyright (c) 2015年 lerruby.com. All rights reserved.
//

#import "ProfileViewController.h"
#import "MyIconCell.h"
#import "UILabelCell.h"
#import "AlterPhoneViewController.h"
#import "AlterPwdViewController.h"
#import "SPKitExample.h"


@interface ProfileViewController ()<UIAlertViewDelegate>
{
    UIActionSheet* imageSheet;
    UIImagePickerController *imagePicker;
    UIActionSheet* sexSheet;
    MyIconCell *myIconCell;
    UIlabelCell *sexCell;
    UIlabelCell *nickNameCell;
    UIAlertView *nickNameText;
    UIAlertView *changePhoneAlert;
    UIAlertView *offlineAlert;
    
    UIActivityIndicatorView *_indictor;
    UIlabelCell *campusCell;
    LPPopup *popup;
    NSString *boundary;
}

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         boundary = [NSString stringWithFormat:@"----------V2ymHFg03ehbqgZCaKO6jy"] ;
    }
    return self;
}
- (void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.SectionFooterHeight =0;
    self.tableView.sectionHeaderHeight = 0;
    self.view.backgroundColor = kGetColor(240, 255, 230);
    //    UIView *footer = [[UIView alloc]init];
    //    footer.frame = CGRectMake(0, 0, 300, 70);
    //    UIButton *send = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [send setAllStateBg:@"common_button_big_red.png"];
    //    [send setTitle:@"退出当前账号" forState:UIControlStateNormal];
    //    send.frame = CGRectMake(10, 10, 300, 44);//footview会自动延伸,处理方法，在底层加了个纯洁的uiview
    //    [send addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    //    [footer addSubview:send];
    //    self.tableView.tableFooterView = footer;
    [self.view addSubview:self.tableView];
}

#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex = [%d]",buttonIndex);
    
    if (actionSheet == sexSheet) {
        _indictor = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(140, 320, 40, 40 )];
        [self.view addSubview:_indictor];
        [_indictor startAnimating];
        NSString *tmpSex = nil;
        switch (buttonIndex) {
            case 0:
                
                tmpSex = @"男";
                break;
            case 1:
                tmpSex = @"女";
                
                break;
            default:
                break;
        }
        
        NSURLRequest *request = [NSURLRequest requestWithPath:kUpdateUserPath params:@{@"sex":tmpSex,@"phone":[[NSUserDefaults standardUserDefaults] objectForKey:kPhone]                                                  }];
        //
        NSHTTPURLResponse *response = nil;
        NSError *error =nil;
        NSLog(@"%@",request);
        NSData *responeData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *responesStr = [[NSString alloc]initWithData:responeData encoding:NSUTF8StringEncoding];
        //NSLog(@"%@----%@",teststr1,teststr);
        NSLog(@"responeStr%@",responesStr);
        
    
        
        if ([responesStr isEqualToString:@"success"]){
            [self refreshUser];
        }else{
            popup = [LPPopup popupWithText:@"修改失败，再试一次!"];
            popup.popupColor = [UIColor blackColor];
            popup.alpha = 0.8;
            popup.textColor = [UIColor whiteColor];
            popup.font = kDetailContentFont;
            //popup.textInsets = UIEdgeInsetsMake(10, 0, 0, 0);
            [popup showInView:self.view
                centerAtPoint:self.view.center
                     duration:1
                   completion:nil];
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
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
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
//
//    // NSError *imageError = nil;
//    NSData *imageData = UIImagePNGRepresentation(smallImage);
//    
//    NSData *data = [NSData dataWithData:imageData];
//    
//   
////    
////    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
////    NSString *urlStr = [NSString stringWithFormat:@"http://202.117.77.156:8088/AMEI/UploadImage?phone=1"];
////    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
////   // NSData *data = [NSData dataWithData:imageData];
////    NSURL *Url = [NSURL URLWithString:urlStr];
////    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:Url];
////    NSLog(@"req==%@",req);
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
//        
//        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//        
//        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
//        //body
//        NSData *body = [self prepareDataForUploadWith:imageFilePath];
//        //request
//         NSMutableURLRequest *imageRequest = [NSURLRequest mutableRequestWithPath:kUploadImagePath params:@{@"phone":[[NSUserDefaults standardUserDefaults] objectForKey:kPhone]}];
//        [imageRequest setHTTPMethod:@"POST"];
//        
//        // 以下2行是关键，NSURLSessionUploadTask不会自动添加Content-Type头
//        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
//        [imageRequest setValue:contentType forHTTPHeaderField: @"Content-Type"];
//        
//        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:imageRequest fromData:body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
//            
//            NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"message: %@", message);
//            if ([message isEqualToString:@"success"]) {
                myIconCell.iconImage.image = selfPhoto;
//            }
//            
//            [session invalidateAndCancel];
//        }];
//        
//        [uploadTask resume];
//    });
 
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
// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)viewWillAppear:(BOOL)animated
{
    [UserTool requestUserWithPath:kGetMyInfoPath UserPhone:[[NSUserDefaults standardUserDefaults] objectForKey:kPhone] success:^(User *user) {
        _selfUser = user;
        NSLog(@"nickNmae == %@",user.nickName);
        if (_tableView != nil) {
            [_tableView reloadData];
        }
    } fail:^{
        NSLog(@"加载信息失败");
    }];
   

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
    
    [self initTableView];
}


-(void)refreshUser
{
 
    [UserTool requestUserWithPath:kGetMyInfoPath UserPhone:[[NSUserDefaults standardUserDefaults] objectForKey:kPhone]  success:^(User *user) {
        _selfUser = user;
        NSLog(@"nickName = %@",_selfUser.nickName);
        [_indictor stopAnimating];
        popup = [LPPopup popupWithText:@"修改成功!"];
        popup.popupColor = [UIColor blackColor];
        popup.alpha = 0.8;
        popup.textColor = [UIColor whiteColor];
        popup.font = kDetailContentFont;
        //popup.textInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        [popup showInView:self.view
            centerAtPoint:self.view.center
                 duration:1
               completion:nil];
        [_tableView reloadData];
    } fail:^{
        NSLog(@"加载信息失败");
    }];
    
    
}


#pragma mark - uitableviewdelegate 的实现
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return     3;
    // Return the number of sections.
    //return data.count;
    //return dataArray.count;//控制有几行显示
}

- ( CGFloat )tableView:( UITableView *)tableView heightForHeaderInSection:( NSInteger )section

{
    
    return 20.0 ;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0&&indexPath.row == 0) {
        
        return 120;
        
        
        
    }else{
        return 44;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        return 2;
    
    
    
    // Return the number of rows in the section.
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *CellIdentifier1 = @"myIconCell";
            myIconCell = [tableView                               dequeueReusableCellWithIdentifier:CellIdentifier1];
            if (myIconCell == nil) {
                myIconCell = [[MyIconCell alloc]initWithStyle:UITableViewCellStyleDefault                   reuseIdentifier:CellIdentifier1] ;
            }
            myIconCell.selectionStyle = UITableViewCellSelectionStyleNone;
            myIconCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return myIconCell;
        }else{
            static NSString *CellIdentifier2 = @"sexCell";
            sexCell = [tableView                               dequeueReusableCellWithIdentifier:CellIdentifier2];
            if (sexCell == nil) {
                sexCell = [[UIlabelCell alloc]initWithStyle:UITableViewCellStyleDefault                   reuseIdentifier:CellIdentifier2] ;
            }
            sexCell.selectionStyle = UITableViewCellSelectionStyleNone;
            sexCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
     
            sexCell.titleLabel.text = @"性别 :";
            sexCell.contentLabel.text = _selfUser.sex;
            return sexCell;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            static NSString *CellIdentifier3 = @"myCell";
            nickNameCell = [tableView                               dequeueReusableCellWithIdentifier:CellIdentifier3];
            if (nickNameCell == nil) {
                nickNameCell = [[UIlabelCell alloc]initWithStyle:UITableViewCellStyleDefault                   reuseIdentifier:CellIdentifier3] ;
            }
            nickNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
            nickNameCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            nickNameCell.titleLabel.text = @"昵称 :";
            nickNameCell.contentLabel.text = _selfUser.nickName;
            return nickNameCell;
        }else{
            static NSString *CellIdentifier4 = @"phoneNumberCell";
            UIlabelCell *phoneNumberCell = [tableView                               dequeueReusableCellWithIdentifier:CellIdentifier4];
            if (phoneNumberCell == nil) {
                phoneNumberCell = [[UIlabelCell alloc]initWithStyle:UITableViewCellStyleDefault                   reuseIdentifier:CellIdentifier4] ;
            }
            phoneNumberCell.selectionStyle = UITableViewCellSelectionStyleNone;
            phoneNumberCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            phoneNumberCell.titleLabel.text = @"电话 :";
            phoneNumberCell.contentLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:kPhone];
            return phoneNumberCell;

        }
    }else{
        if (indexPath.row == 0) {
            static NSString *CellIdentifier5 = @"alterpwdCell";
            UIlabelCell *alterpwdCell = [tableView                               dequeueReusableCellWithIdentifier:CellIdentifier5];
            if (alterpwdCell == nil) {
                alterpwdCell = [[UIlabelCell alloc]initWithStyle:UITableViewCellStyleDefault                   reuseIdentifier:CellIdentifier5] ;
            }
            alterpwdCell.selectionStyle = UITableViewCellSelectionStyleNone;
            alterpwdCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            alterpwdCell.titleLabel.text = @"修改密码";
            //alterphoneCell.contentLabel.text = @"13259807852";
            return alterpwdCell;
        }else{
            static NSString *CellIdentifier6 = @"offlineCell";
            UIlabelCell *offlineCell = [tableView                               dequeueReusableCellWithIdentifier:CellIdentifier6];
            if (offlineCell == nil) {
                offlineCell = [[UIlabelCell alloc]initWithStyle:UITableViewCellStyleDefault                   reuseIdentifier:CellIdentifier6] ;
            }
            offlineCell.selectionStyle = UITableViewCellSelectionStyleNone;
            offlineCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            offlineCell.titleLabel.text = @"退出账号";
            
            return offlineCell;
        }
        
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSLog(@"sdfsf");
            
            imageSheet = [[UIActionSheet alloc]
                          initWithTitle:nil
                          delegate:self
                          cancelButtonTitle:@"取消"
                          destructiveButtonTitle:nil
                          otherButtonTitles:@"照相机",@"本地相册",nil];
            
            [imageSheet showInView:self.view];
        }else{
            sexSheet = [[UIActionSheet alloc]
                        initWithTitle:nil
                        delegate:self
                        cancelButtonTitle:@"取消"
                        destructiveButtonTitle:nil
                        otherButtonTitles:@"男",@"女",nil];
            
            [sexSheet showInView:self.view];
            
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            nickNameText = [[UIAlertView alloc]init];
            nickNameText.alertViewStyle = UIAlertViewStylePlainTextInput;
            nickNameText.title = @"请输入新昵称";
            nickNameText.delegate = self;
            [nickNameText addButtonWithTitle:@"取消"];
            [nickNameText addButtonWithTitle:@"确定"];
            [nickNameText show];
        }else{
            if (indexPath.row == 1) {
                changePhoneAlert = [[UIAlertView alloc]initWithTitle:nil message:@"确定更改绑定号码吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [changePhoneAlert show];
                
            }        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
        AlterPwdViewController *alterPwd = [[AlterPwdViewController alloc]init];
        [self.navigationController pushViewController:alterPwd animated:YES];
        }else{
            offlineAlert = [[UIAlertView alloc]initWithTitle:nil message:@"确定当前账号吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [offlineAlert show];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView ==  nickNameText) {
        if (buttonIndex == 1) {
            _indictor = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(140, 320, 40, 40 )];
            [self.view addSubview:_indictor];
            [_indictor startAnimating];
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
            NSURLRequest *request = [NSURLRequest requestWithPath:kUpdateUserPath params:@{@"nickName":[nickNameText textFieldAtIndex:0].text,@"phone":[[NSUserDefaults standardUserDefaults] objectForKey:kPhone]                                                  }];
            //
            NSHTTPURLResponse *response = nil;
            NSError *error =nil;
            NSLog(@"%@",request);
            NSData *responeData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            NSString *responesStr = [[NSString alloc]initWithData:responeData encoding:NSUTF8StringEncoding];
            //NSLog(@"%@----%@",teststr1,teststr);
            NSLog(@"responeStr----%@",responesStr);
         
            
            if ([responesStr isEqualToString:@"success"]){
                [_indictor stopAnimating];
                [self refreshUser];
            }else{
                popup = [LPPopup popupWithText:@"修改失败，再试一次!"];
                popup.popupColor = [UIColor blackColor];
                popup.alpha = 0.8;
                popup.textColor = [UIColor whiteColor];
                popup.font = kDetailContentFont;
                //popup.textInsets = UIEdgeInsetsMake(10, 0, 0, 0);
                [popup showInView:self.view
                    centerAtPoint:self.view.center
                         duration:1
                       completion:nil];
            }

        }
        
    }

    else  if(alertView == changePhoneAlert){
        AlterPhoneViewController  *alter = [[AlterPhoneViewController alloc]init];
        [self.navigationController pushViewController:alter animated:YES];
    }else{
        if (buttonIndex == 1) {
        [[SPKitExample sharedInstance] exampleLogout];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"logOut" object:nil];
        }
    }
    NSLog(@"%d",buttonIndex);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
