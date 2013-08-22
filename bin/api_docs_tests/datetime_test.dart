void main() {

/*
 * Snippets from top-level class docs
 */
DateTime now = new DateTime.now();
DateTime berlinWallFell = new DateTime(1989, 11, 9);
DateTime moonLanding = DateTime.parse("1969-07-20 20:18:00");  // 8:18pm


assert(berlinWallFell.month == 11);
assert(moonLanding.hour == 20);

//duplicate identifier, commented out
/*DateTime*/ berlinWallFell = new DateTime(1989, DateTime.NOVEMBER, 9);
assert(berlinWallFell.month == DateTime.SATURDAY);

DateTime dDay = new DateTime.utc(1944, 6, 6);

assert(berlinWallFell.isAfter(moonLanding) == true);
assert(berlinWallFell.isBefore(moonLanding) == false);

DateTime today = new DateTime.now();
DateTime sixtyDaysFromNow = today.add(new Duration(days: 60));

Duration difference = berlinWallFell.difference(dDay);
assert(difference.inDays == 16592);

/*
 * == operator
 */
DateTime dDayUtc   = new DateTime.utc(1944, DateTime.JUNE, 6);
DateTime dDayLocal = new DateTime(1944, DateTime.JUNE, 6);

assert(dDayUtc.isAtSameMomentAs(dDayLocal) == false);


/*
 * day property
 */
/*DateTime*/ moonLanding = DateTime.parse("1969-07-20 20:18:00");
assert(moonLanding.day == 20);


/*
 * hour property
 */
/*DateTime*/ moonLanding = DateTime.parse("1969-07-20 20:18:00");
assert(moonLanding.hour == 20);

/*
 * isUtc
 */
/*DateTime*/ dDay = new DateTime.utc(1944, 6, 6);
assert(dDay.isUtc);

/*
 * millisecond property
 */
/*DateTime*/ moonLanding = DateTime.parse("1969-07-20 20:18:00");
assert(moonLanding.millisecond == 0);

/*
 * minute property
 */
/*DateTime*/ moonLanding = DateTime.parse("1969-07-20 20:18:00");
assert(moonLanding.minute == 18);

/* 
 * month property
 */
/*DateTime*/ moonLanding = DateTime.parse("1969-07-20 20:18:00");
assert(moonLanding.month == 7);
assert(moonLanding.month == DateTime.JULY);

/*
 * second property
 */
/*DateTime*/ moonLanding = DateTime.parse("1969-07-20 20:18:00");
assert(moonLanding.second == 0);

/*
 * weekday property
 */
/*DateTime*/ moonLanding = DateTime.parse("1969-07-20 20:18:00");
assert(moonLanding.weekday == 7);
assert(moonLanding.weekday == DateTime.SUNDAY);

/*
 * year property
 */
/*DateTime*/ moonLanding = DateTime.parse("1969-07-20 20:18:00");
assert(moonLanding.year == 1969);

/*
 * constructors
 */
DateTime annularEclipse = new DateTime(2014, DateTime.APRIL, 29, 6, 4);

/*
 * now constructor
 */
DateTime thisInstant = new DateTime.now();

/*
 * utc constructor
 */
/*DateTime*/ dDay = new DateTime.utc(1944, DateTime.JUNE, 6);

/*
 * add method
 */
/*DateTime*/ today = new DateTime.now();
/*DateTime*/ sixtyDaysFromNow = today.add(new Duration(days: 60));

/*
 * different method
 */
/*DateTime*/ berlinWallFell = new DateTime(1989, DateTime.NOVEMBER, 9);
/*DateTime*/ dDay = new DateTime(1944, DateTime.JUNE, 6);

/*Duration*/ difference = berlinWallFell.difference(dDay);
assert(difference.inDays == 16592);

/*
 * isAfter method
 */
/*DateTime*/ berlinWallFell = new DateTime(1989, 11, 9);
/*DateTime*/ moonLanding    = DateTime.parse("1969-07-20 20:18:00");

assert(berlinWallFell.isAfter(moonLanding) == true);

/*
 * isAtSameMomentAs
 */
/*DateTime*/ berlinWallFell = new DateTime(1989, 11, 9);
/*DateTime*/ moonLanding    = DateTime.parse("1969-07-20 20:18:00");

assert(berlinWallFell.isAtSameMomentAs(moonLanding) == false);

/*
 * isBefore method
 */
/*DateTime*/ berlinWallFell = new DateTime(1989, 11, 9);
/*DateTime*/ moonLanding    = DateTime.parse("1969-07-20 20:18:00");

assert(berlinWallFell.isBefore(moonLanding) == false);

/*
 * subtract method
 */
/*DateTime*/ today = new DateTime.now();
DateTime sixtyDaysAgo = today.subtract(new Duration(days: 60));


/*
 * toLocal method
 */
/*
new DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch,
                                        isUtc: false);
*/

/*
 * toUtc method
 */
/*
new DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch,
                                        isUtc: true);
*/
}
