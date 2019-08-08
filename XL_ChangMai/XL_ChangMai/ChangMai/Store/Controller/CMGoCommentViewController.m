//
//  CMGoCommentViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/8.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMGoCommentViewController.h"
#import "UIImageView+WebCache.h"
#import "UETextView.h"
#import "TZImagePickerController.h"
#import "RatingBar.h"
#define maxImageCount 3
#define imageLeftX 20
#define imageH 80
#define imageMargin 15
#define imageW 80
@interface CMGoCommentViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,RatingBarDelegate>
{
    NSMutableArray *_selectedPhotos;
    UETextView *refundDescr;
    UIButton *pickerImg;
    UIImage *selectImage;
    UIView *imageContentView;
}
@property (nonatomic,strong) RatingBar *ratingBar1;
@end

@implementation CMGoCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发表评价";
    _selectedPhotos = [NSMutableArray array];
    [self createUI];
}





-(void)createUI
{
    self.view.backgroundColor = __kViewBgColor;
    
    UIView *conView = [[UIView alloc] init];
    conView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:conView];
    
    UILabel *statisfy = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 60, 50)];
    statisfy.backgroundColor = [UIColor clearColor];
    statisfy.text = @"满意度:";
    statisfy.font = Font(17);
    statisfy.textColor = [UIColor blackColor];
    [conView addSubview:statisfy];
    
    
    //RatingBar1
    CGFloat width = 200;
    self.ratingBar1 = [[RatingBar alloc] initWithFrame:CGRectMake(statisfy.right + 10, statisfy.top + 7, width, statisfy.height + 10)];
    
    //添加到view中
    [conView addSubview:self.ratingBar1];
    //是否是指示器
    self.ratingBar1.isIndicator = NO;
    [self.ratingBar1 setImageDeselected:@"star_default" halfSelected:@"iconfont-banxing" fullSelected:@"star_selected" andDelegate:self];
    
    
    
    refundDescr = [[UETextView alloc] init];
    refundDescr.frame = CGRectMake(20, self.ratingBar1.bottom + 10, __kWindow_Width - 2*20, 100);
    refundDescr.layer.masksToBounds = YES;
    refundDescr.placeholder = @"宝贝还满意吗？说出你的想法吧！";
    [conView addSubview:refundDescr];
    
    UIView *line = [self createDefaultStyleLineFrame:CGRectMake(0, refundDescr.top, __kWindow_Width, __kLine_Width_Height)];
    [conView addSubview:line];
    
    UIView *line1 = [self createDefaultStyleLineFrame:CGRectMake(0, refundDescr.bottom - __kLine_Width_Height, __kWindow_Width, __kLine_Width_Height)];
    [conView addSubview:line1];
    
    UILabel *postImageLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,refundDescr.bottom, 100, 40)];
    postImageLabel.backgroundColor = [UIColor clearColor];
    postImageLabel.text = @"上传图片";
    postImageLabel.font = Font(17);
    postImageLabel.textColor = [UIColor blackColor];
    [conView addSubview:postImageLabel];
    
    
    imageContentView = [[UIView alloc] init];
    imageContentView.frame = CGRectMake(0, postImageLabel.bottom + 10, __kWindow_Width, imageH);
    imageContentView.backgroundColor = [UIColor clearColor];
    [conView addSubview:imageContentView];
    
    pickerImg = [[UIButton alloc] init];
    pickerImg.frame = CGRectMake(refundDescr.left,0, imageW, imageH);
    [pickerImg addTarget:self action:@selector(pickPhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [pickerImg setImage:[UIImage imageNamed:@"tapToAddImage-icon"] forState:UIControlStateNormal];
    [imageContentView addSubview:pickerImg];
    
    conView.frame = CGRectMake(0, __KViewY, __kWindow_Width, imageContentView.bottom + 10);
    
    
    CGFloat btnMargin = 60;
    CGFloat cornerRadius = 25;
    UIButton *_loginBtn = [[UIButton alloc] init];
    [_loginBtn setTitle:@"发表评价" forState:UIControlStateNormal];
    _loginBtn.frame = CGRectMake(btnMargin, conView.bottom + 30, __kWindow_Width - 2*btnMargin, 50);
    _loginBtn.layer.cornerRadius = cornerRadius;
    _loginBtn.layer.masksToBounds = YES;
    [_loginBtn setBackgroundColor:__kThemeColor forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
}


- (void)pickPhotoButtonClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    if (buttonIndex == 0 ) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self  presentViewController:picker animated:YES completion:nil];
        }
    }
    if (buttonIndex == 1 ) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxImageCount delegate:self];
        
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
            
        }];
        
        [self presentViewController:imagePickerVc animated:YES completion:nil];
        
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img =  [info objectForKey:UIImagePickerControllerOriginalImage];
    [_selectedPhotos addObject:img];
    [self reloadImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark TZImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    if (_selectedPhotos.count < 3) {
        [_selectedPhotos addObjectsFromArray:photos];
        [self reloadImage];
    }
    
}



- (void)reloadImage
{
    for (UIView *sView in imageContentView.subviews) {
        if (sView.tag != 0) {
            [sView removeFromSuperview];
        }
    }
    
    CGFloat imageX = imageLeftX;
    CGFloat imageY = 0;
    NSInteger maxImage = _selectedPhotos.count <=3?_selectedPhotos.count:3;
    for (int i = 0;i < maxImage;i++) {
        UIImage *image = _selectedPhotos[i];
        UIButton *imageBtn = [[UIButton alloc] init];
        imageBtn.tag = i + 200;
        [imageBtn setImage:image forState:UIControlStateNormal];
        //        [imageBtn addTarget:self action:@selector(pickPhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if ((imageX + imageW) > (__kWindow_Width - imageLeftX)) {
            imageX = imageLeftX;
            imageY = imageY + imageH + imageMargin;
        }
        imageBtn.frame = CGRectMake(imageX, imageY, imageW, imageH);
        imageX = imageX + imageW + imageMargin;
        [imageContentView addSubview:imageBtn];
        
    }
    
    if ((imageX + imageW) > (__kWindow_Width - imageLeftX)) {
        imageX = imageLeftX;
        imageY = imageY + imageH + imageMargin;
    }
    if (_selectedPhotos.count < maxImageCount) {
        UIButton *addImageBtn = [[UIButton alloc] init];
        addImageBtn.tag = 888;
        [addImageBtn setImage:[UIImage imageNamed:@"tapToAddImage-icon"] forState:UIControlStateNormal];
        [addImageBtn addTarget:self action:@selector(pickPhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        addImageBtn.frame = CGRectMake(imageX, imageY, imageW, imageH);
        [imageContentView addSubview:addImageBtn];
    }
    
}


- (void)loginClick:(UIButton *)sender
{
    
    if (self.ratingBar1.rating <=0) {
        [MessageAlertView showWithMessage:@"请打分"];
        return;
    }
    sender.userInteractionEnabled = NO;
    NSDictionary *postDict = @{@"id":@(self.goodId),
                               @"content":refundDescr.text?refundDescr.text:@"",
                               @"star":@(self.ratingBar1.rating)};
    
    [[HttpManager shareInstance] post:@"deal_add_comment" parameter:postDict images:_selectedPhotos withHUDTitle:nil success:^(NSURLSessionDataTask *operation, id response) {
        
        NSLog(@"----返回数据：%@",response);
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MessageAlertView showWithMessage:@"评价成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        });
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            sender.userInteractionEnabled = YES;
            
        });
        
    }];
    
    
}



#pragma mark - RatingBar delegate
-(void)ratingBar:(RatingBar *)ratingBar ratingChanged:(float)newRating{
    if (self.ratingBar1 == ratingBar) {
        //        self.mLabel.text = [NSString stringWithFormat:@"第一个评分条的当前结果为:%.1f",newRating];
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
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
