//
//  ContactCell.h
//  
//
//  Created by Denis Arsenault on 9/9/18.
//
#import <UIKit/UIKit.h>

typedef void (^ContactCellDidTapButtonBlock)();

@interface ContactCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIImageView *picture;

@property (copy, nonatomic) ContactCellDidTapButtonBlock didTapButtonBlock;

@end
