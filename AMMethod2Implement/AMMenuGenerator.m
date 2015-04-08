//
//  AMMenuGenerator.m
//  AMMethod2Implement
//
//  Created by JohnnyLiu on 15/4/1.
//  Copyright (c) 2015年 Tendencystudio. All rights reserved.
//

#import "AMMenuGenerator.h"

@implementation AMMenuGenerator

+ (void)generateMenuItems:(NSBundle *)bundle version:(NSString *)version target:(id)target
{
    NSString *dataPath = [bundle pathForResource:@"MenuItemData" ofType:@"plist"];
    NSDictionary *menuData = [NSDictionary dictionaryWithContentsOfFile:dataPath];
    
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:menuData[kMenuRootMenutitle]];
    
    if (menuItem) {
        
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSString *title            = menuData[kMenuTitle];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:title action:nil keyEquivalent:@""];
        [[menuItem submenu] addItem:actionMenuItem];
        
        for (NSDictionary *item in menuData[kMenuSubMenuItems]) {
            NSString *subMenuTitle = item[kMenuTitle];
            if ([subMenuTitle rangeOfString:@"%@"].length > 0) {
                subMenuTitle = [NSString stringWithFormat:subMenuTitle, version];
            }
            
            NSString *selectorString = item[kMenuSelector];
            SEL selector = nil;
            if (selectorString != nil && selectorString.length > 0) {
                selector = NSSelectorFromString(selectorString);
            }
            NSMenuItem *subMenuItem = [[NSMenuItem alloc] initWithTitle:subMenuTitle action:selector keyEquivalent:item[kMenuShortcut][kMenuKeyEquivalent]];
            NSArray *maskArray = item[kMenuShortcut][kMenuKeyMask];
            if (maskArray.count == 1) {
                subMenuItem.keyEquivalentModifierMask = [AMMenuGenerator getKeyEquivalentModifierMaskWithKey:maskArray[0]];
            }else if(maskArray.count == 2) {
                subMenuItem.keyEquivalentModifierMask = [AMMenuGenerator getKeyEquivalentModifierMaskWithKey:maskArray[0]] | [AMMenuGenerator getKeyEquivalentModifierMaskWithKey:maskArray[1]];
            }
            subMenuItem.target = target;
            [[actionMenuItem submenu] addItem:subMenuItem];
        }
        
    }
}

+ (NSUInteger)getKeyEquivalentModifierMaskWithKey:(NSString *)key
{
    NSDictionary *keyMaskMap = @{@"ctrl":@(NSControlKeyMask),
                                 @"shift":@(NSShiftKeyMask),
                                 @"command":@(NSCommandKeyMask),
                                 @"alt":@(NSAlternateKeyMask)};
    return keyMaskMap[key];
}

@end