//
//  GSMaterialTextField.h
//  GSMaterialTextField
//
//  Created by Gantulga on 4/28/16.
//  Copyright © 2016 Airbook LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSLengthValidator.h"
#import "GSNameValidator.h"
#import <InputValidators/LKValidators.h>
@interface GSMaterialTextField : UIView
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *errorColor;

@property (nonatomic, strong) NSArray<LKValidator *> *validators;
@property (nonatomic, strong) UIView *shakeView;
@property (nonatomic, assign) BOOL checkCount;
@property (nonatomic, assign) int maxCount;
@property (nonatomic, assign) int minCount;

- (void) startEditing;
- (void) endEditing;

@end