//
//  SXTLiveCell.h
//  bjsxt-inke
//
//  Created by 大欢 on 16/9/2.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXTLive.h"
#import "SXTMiaoBoModel.h"

@interface SXTLiveCell : UITableViewCell

@property (nonatomic, strong) SXTLive * live;
//@property (nonatomic, strong) SXTMiaoBoModel *miaoBoModel;


- (void)setViewForMiaoBo:(SXTMiaoBoModel *)miaobo;

@end