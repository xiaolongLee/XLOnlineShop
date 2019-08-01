//
//  CMMemberCell.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/19.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMMemberCell.h"
#import "XLGoodsCollectionViewCell.h"

@interface  CMMemberCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
/** 会员专享区 collectionView */
@property (nonatomic,strong) UICollectionView *collectionView;
/** 会员专享 数据源 */
@property (nonatomic,strong) NSMutableArray *dataCArray;
/** 会员专享 布局 */
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
/** 会员专享 显示行数 */
@property (nonatomic,assign) NSInteger lineNum;
@end

static NSString *GoodsCollctionID = @"GoodsCollctionID1";

@implementation CMMemberCell

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        /** 设置滚动方向 */
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat itemWidth = (__kWindow_Width - 10)/2;
        flowLayout.itemSize = CGSizeMake(itemWidth,itemWidth + 80);
        // 最小的列距
        flowLayout.minimumInteritemSpacing = 5;
        // 最小的行距
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _flowLayout = flowLayout;
    }
    
    return _flowLayout;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CMMemberCell";
    CMMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CMMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (CGFloat)cellHeight
{
    return self.flowLayout.itemSize.width*2 + self.flowLayout.minimumLineSpacing*2;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) { // 初始化子控件
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, __kWindow_Width, (self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing)*2) collectionViewLayout:self.flowLayout];
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        //        _collectionView.bounces = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"JNGoodsCollectionCell" bundle:nil] forCellWithReuseIdentifier:GoodsCollctionID];
        
        _collectionView.frame = CGRectMake(0, 0, __kWindow_Width, self.flowLayout.itemSize.width*2 + self.flowLayout.minimumLineSpacing*2);
        
        [self.contentView addSubview:_collectionView];
        
        // cell的设置
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)reloadCollectionData
{
    [self.collectionView reloadData];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XLGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsCollctionID forIndexPath:indexPath];
    //    cell.modelGoods = self.dataMArray[indexPath.row];
    return cell;
}

#pragma mark - 点击图片查看详情
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    JNGoodsModel *model = self.dataMArray[indexPath.row];
    //    GoodsDetailViewController *detailVc = [[GoodsDetailViewController alloc]init];
    //    detailVc.itemId = model._id;
    //    [self.navigationController pushViewController:detailVc animated:YES];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //    return self.dataMArray.count;
    return 4;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
