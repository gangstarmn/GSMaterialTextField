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

static NSString *bundleName = @"GSTextField";

#ifndef GSMaterialLocalizedString
#define GSMaterialLocalizedString(key) \
    GSLocalizedString((key), bundleName)
#endif

#pragma mark - Get Methods
- (UIColor *)errorColor {
    if (!_errorColor) {
        _errorColor = [UIColor redColor];
    }
    return _errorColor;
}
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
        _errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 47, self.bounds.size.width-10, 13)];
        _errorLabel.font = [UIFont systemFontOfSize:12];
        _errorLabel.textColor = self.errorColor;
        _errorLabel.numberOfLines = 2;
    }
    return _errorLabel;
}

- (UIView *)shakeView {
    return self;
}

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.hintLabel];
        [self addSubview:self.textField];
        [self addSubview:self.seperatorView];
        [self addSubview:self.errorLabel];

        isSelected = false;
    }
    return self;
}

#pragma mark - Set Methods

#pragma mark - Editing Events

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
        self.hintLabel.highlighted = NO;
        [self isValid];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - TextDid Change

- (void) textDidChange :(UITextField *)textField {
    [self isValid];
}

#pragma mark - View Change

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
                    GSLengthValidator *lenghtValidator = (GSLengthValidator *)validator;
                    if (lenghtValidator.validatorType == GSLengthValidatorTypeMoreThan) {
                        self.errorLabel.text = [NSString stringWithFormat:GSMaterialLocalizedString(@"error.length.morethan"),lenghtValidator.length];
                    }
                    else if (lenghtValidator.validatorType == GSLengthValidatorTypeLessThan) {
                        self.errorLabel.text = [NSString stringWithFormat:GSMaterialLocalizedString(@"error.length.lessthan"),lenghtValidator.length];
                    }
                    else if (lenghtValidator.validatorType == GSLengthValidatorTypeEqual) {
                        self.errorLabel.text = [NSString stringWithFormat:GSMaterialLocalizedString(@"error.length.equal"),lenghtValidator.length];
                    }
                    else if (lenghtValidator.validatorType == GSLengthValidatorTypeRange) {
                        self.errorLabel.text = [NSString stringWithFormat:GSMaterialLocalizedString(@"error.length.range"),lenghtValidator.length,lenghtValidator.maxLength];
                    }
                }
            }
            else {
                self.errorLabel.text = GSMaterialLocalizedString(@"error.error");
            }
            if (!isValid) {
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
    }
    else {
        self.seperatorView.backgroundColor = self.errorColor;
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

- (void)reloadViews {
    if ([self.textField.text length] > 0) {
        self.hintLabel.frame = CGRectMake(5, 0, self.bounds.size.width-10, 15);
        self.hintLabel.font = [UIFont systemFontOfSize:12];
    }
    else {
        self.hintLabel.frame = CGRectMake(5, 15, self.bounds.size.width-10, 30);
        self.hintLabel.font = [UIFont systemFontOfSize:17];
    }
    [self textDidChange:self.textField];
}

@end
