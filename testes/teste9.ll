; ModuleID = "robot_cleaner"
target triple = "x86_64-pc-linux-gnu"
target datalayout = ""

declare void @"robot_move"(i8* %".1", i32 %".2")

declare void @"robot_rotate"(i8* %".1", i32 %".2")

declare void @"robot_start_clean"()

declare void @"robot_stop_clean"()

declare void @"robot_clean_trash"()

declare void @"robot_return_dock_simple"()

declare i32 @"robot_read_sensor"(i32 %".1")

declare i32 @"printf"(i8* %".1", ...)

define i32 @"main"()
{
entry:
  %"movement_stack_type" = alloca [1000 x i32]
  %"movement_stack_value" = alloca [1000 x i32]
  %"movement_stack_direction" = alloca [1000 x i32]
  %"stack_top" = alloca i32
  store i32 0, i32* %"stack_top"
  %"a" = alloca i1
  store i1 false, i1* %"a"
  %"b" = alloca i1
  store i1 false, i1* %"b"
  %"c" = alloca i1
  store i1 false, i1* %"c"
  store i1 true, i1* %"a"
  store i1 false, i1* %"b"
  %".8" = load i1, i1* %"a"
  %".9" = load i1, i1* %"b"
  %".10" = and i1 %".8", %".9"
  store i1 %".10", i1* %"c"
  %".12" = load i1, i1* %"c"
  %".13" = zext i1 %".12" to i32
  %".14" = call i32 @"robot_read_sensor"(i32 %".13")
  %"sensor_None" = alloca i32
  store i32 %".14", i32* %"sensor_None"
  %".16" = load i1, i1* %"a"
  %".17" = load i1, i1* %"b"
  %".18" = or i1 %".16", %".17"
  store i1 %".18", i1* %"c"
  %".20" = load i1, i1* %"c"
  %".21" = zext i1 %".20" to i32
  %".22" = call i32 @"robot_read_sensor"(i32 %".21")
  %"sensor_None.1" = alloca i32
  store i32 %".22", i32* %"sensor_None.1"
  %".24" = load i1, i1* %"a"
  %".25" = xor i1 %".24", -1
  store i1 %".25", i1* %"c"
  %".27" = load i1, i1* %"c"
  %".28" = zext i1 %".27" to i32
  %".29" = call i32 @"robot_read_sensor"(i32 %".28")
  %"sensor_None.2" = alloca i32
  store i32 %".29", i32* %"sensor_None.2"
  %".31" = load i1, i1* %"a"
  %".32" = and i1 true, %".31"
  store i1 %".32", i1* %"c"
  %".34" = load i1, i1* %"c"
  %".35" = zext i1 %".34" to i32
  %".36" = call i32 @"robot_read_sensor"(i32 %".35")
  %"sensor_None.3" = alloca i32
  store i32 %".36", i32* %"sensor_None.3"
  ret i32 0
}
