
void main() {
  Duration fastestMarathon = new Duration(hours:2, minutes:3, seconds:2);
  assert(fastestMarathon.inMinutes == 123);
  Duration aLongWeekend = new Duration(hours:88);
  assert(aLongWeekend.inDays == 3);
}
