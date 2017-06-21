typedef enum {
    YSWeekdayTypeSunday = 1 << 0,
    YSWeekdayTypeMonday = 1 << 1,
    YSWeekdayTypeTuesday = 1 << 2,
    YSWeekdayTypeWednesday = 1 << 3,
    YSWeekdayTypeThursday = 1 << 4,
    YSWeekdayTypeFriday = 1 << 5,
    YSWeekdayTypeSaturday = 1 << 6,
} YSWeekdayType;

@interface NSDate (Extras)

- (NSDateComponents*)dateAndTimeComponents;
- (NSArray*)oneWeekDateWithEnableWeekdayType:(YSWeekdayType)type;

@end