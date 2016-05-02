//
//  GSMaterialTextField.m
//  GSMaterialTextField
//
//  Created by Gantulga on 4/28/16.
//  Copyright © 2016 Airbook LLC. All rights reserved.
//

#import "GSMaterialTextField.h"
#import <HexColors/HexColors.h>
#import <SCViewShaker/UIView+Shake.h>
#import <GSLocalization/GSLocalization.h>
@interface GSMaterialTextField () {
    BOOL isSelected;
}
@property (nonatomic, strong) UIView *seperatorView;
@end

@implementation GSMaterialTextField

static NSString *bundleName = @"GSMaterialTextField";

#ifndef GSMaterialLocalizedString
#define GSMaterialLocalizedString(key) \
    GSLocalizedString((key), bundleName)
#endif

//#define GSMaterialLocalizedString (key) GSLocalizedString((key), bundleName)

-(UIView *)seperatorView {
    if (!_seperatorView) {
        _seperatorView = [[UIView alloc] initWithFrame:CGRectMake(5, 45, self.bounds.size.width-10, 2)];
        _seperatorView.backgroundColor = self.normalColor;
    }
    return _seperatorView;
}

- (UIColor *)normalColor {
    if (!_normalColor) {
        _normalColor = [[UIColor blackColor] colorWithAlphaComponent:0.54];
    }
    return _normalColor;
}

- (UIColor *)selectedColor {
    if (!_selectedColor) {
        _selectedColor = [UIColor hx_colorWithHexRGBAString:@"3f51b5"];
    }
    return _selectedColor;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.bounds.size.width-10, 15)];
        _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, self.bounds.size.width-10, 30)];
        _hintLabel.font = [UIFont systemFontOfSize:17];
        _hintLabel.textColor = self.normalColor;
        _hintLabel.highlightedTextColor = self.selectedColor;
    }
    return _hintLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(5, 15, self.bounds.size.width-10, 30)];
        [_textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];

    }
    return _textField;
}

- (UILabel *)errorLabel {
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 47, self.bounds.size.width-100, 13)];
        _errorLabel.font = [UIFont systemFontOfSize:12];
        _errorLabel.textColor = [UIColor redColor];
        _errorLabel.numberOfLines = 2;
//        _errorLabel.highlightedTextColor = [UIColor redColor];
    }
    return _errorLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-95, 47, 90, 13)];
        _countLabel.font = [UIFont systemFontOfSize:12];
        _countLabel.textColor = self.normalColor;
        _countLabel.layer.borderWidth = 1;
        _countLabel.textAlignment = NSTextAlignmentRight;
//        _countLabel.highlightedTextColor = self.selectedColor;
    }
    return _countLabel;
}

- (UIView *)shakeView {
    if (!_shakeView) {
        _shakeView = self.superview;
    }
    return _shakeView;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.hintLabel];
        [self addSubview:self.textField];
        [self addSubview:self.seperatorView];
        [self addSubview:self.errorLabel];
        [self addSubview:self.countLabel];

        self.maxCount = -1;
        self.minCount = -1;
        isSelected = false;
        GSLocalizeAddBundle(bundleName);
//        [self addSubview:self.countLabel];
    }
    return self;
}

- (void) startEditing {
    isSelected = true;
    [self isValid];
    [UIView animateWithDuration:0.1 animations:^{
        self.hintLabel.frame = CGRectMake(5, 0, self.bounds.size.width-10, 15);
        self.hintLabel.font = [UIFont systemFontOfSize:12];
        self.hintLabel.highlighted = YES;
        self.seperatorView.backgroundColor = self.selectedColor;
    } completion:^(BOOL finished) {
        
    }];
}
- (void) endEditing {
    isSelected = false;
    [UIView animateWithDuration:0.1 animations:^{
        if ([self.textField.text length] == 0) {
            self.hintLabel.frame = CGRectMake(5, 15, self.bounds.size.width-10, 30);
            self.hintLabel.font = [UIFont systemFontOfSize:17];
        }
        else {
            
        }
        self.hintLabel.highlighted = NO;
    } completion:^(BOOL finished) {
        
    }];
}

- (void) textDidChange :(UITextField *)textField {
    NSLog(@"BLA BLa");
    [self isValid];
    [self checkCount];
    
}

- (void) checkCount {
    NSString *countChecker = @"";
    BOOL isValid = true;
    if (self.minCount >= 0) {
        if (self.maxCount >= 0) {
            countChecker = [NSString stringWithFormat:@"(%d - %d)",self.minCount, self.maxCount];
            if (self.textField.text >= self.minCount && self.textField.text <= self.maxCount) {
                isValid = true;
            }
            else{
                isValid = false;
            }
        }
        else {
            countChecker = [NSString stringWithFormat:@"%d+"];
            if (self.textField.text >= self.minCount) {
                isValid = true;
            }
            else{
                isValid = false;
            }
        }
    }
    else {
        if (self.maxCount >= 0) {
            countChecker = [NSString stringWithFormat:@"%d", self.maxCount];
            if (self.textField.text <= self.maxCount) {
                isValid = true;
            }
            else{
                isValid = false;
            }
        }
    }
    if (countChecker.length > 0) {
        self.countLabel.text = [NSString stringWithFormat:@"%d/%@",[self.textField.text length],countChecker];
    }
    
}
-(BOOL) isValid  {
    BOOL isValid = YES;
    
    NSError *error = nil;
    
    for (LKValidator *validator in self.validators) {
        if (![validator validate:self.textField.text error:&error]) {
            isValid = YES;
            if ([validator isKindOfClass:[LKRequiredValidator class]]) {
                isValid = NO;
                self.errorLabel.text = GSMaterialLocalizedString(@"error.required");
            }
            else if ([validator isKindOfClass:[LKAlphaValidator class]]) {
                if (self.textField.text.length > 0) {
                    isValid = NO;
                    self.errorLabel.text = GSMaterialLocalizedString(@"error.letter");
                }
            }
            else if ([validator isKindOfClass:[GSNameValidator class]]) {
                if (self.textField.text.length > 0) {
                    isValid = NO;
                    self.errorLabel.text = GSMaterialLocalizedString(@"error.letter.hyphen");
                }
            }
            else if ([validator isKindOfClass:[LKEmailValidator class]]) {
                if (self.textField.text.length > 0) {
                    isValid = NO;
                    self.errorLabel.text = GSMaterialLocalizedString(@"error.email");
                }
            }
            else if ([validator isKindOfClass:[LKNumericValidator class]]) {
                if (self.textField.text.length > 0) {
                    isValid = NO;
                    self.errorLabel.text = GSMaterialLocalizedString(@"error.number");
                }
            }
            else if ([validator isKindOfClass:[LKLengthValidator class]]) {
                if (self.textField.text.length > 0) {
                    isValid = NO;
                    self.errorLabel.text = GSMaterialLocalizedString(@"error.min.length");
                }
            }
            else if ([validator isKindOfClass:[GSLengthValidator class]]) {
                if (self.textField.text.length > 0) {
                    isValid = NO;
                    self.errorLabel.text = GSMaterialLocalizedString(@"error.length.error");
                }
            }
            else {
                ATLogError(@"error");
                self.errorLabel.text = GSMaterialLocalizedString(@"error.error");
            }
            if (!isValid) {
                ATLogError(@"Error ")
                break;
            }
        }
    }
    if (isValid) {
        self.errorLabel.text = @"";
        if (isSelected) {
            self.seperatorView.backgroundColor = self.selectedColor;
        }
        else {
            self.seperatorView.backgroundColor = self.normalColor;
        }
        self.countLabel.textColor = self.normalColor;
    }
    else {
        self.countLabel.textColor = [UIColor redColor];
        self.seperatorView.backgroundColor = [UIColor redColor];
    }
    return isValid;
}

-(BOOL) checkValid {
    if (![self isValid]) {
        [self.shakeView shakeWithOptions:SCShakeOptionsDirectionHorizontal force:0.01 duration:0.5 iterationDuration:0.03 completionHandler:nil];
        return false;
    }
    return true;
}
@end