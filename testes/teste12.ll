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
  %"a" = alloca i32
  store i32 0, i32* %"a"
  %"b" = alloca i32
  store i32 0, i32* %"b"
  %"resultado" = alloca i1
  store i1 false, i1* %"resultado"
  store i32 10, i32* %"a"
  store i32 5, i32* %"b"
  %".8" = load i32, i32* %"a"
  %".9" = load i32, i32* %"b"
  %".10" = icmp sgt i32 %".8", %".9"
  store i1 %".10", i1* %"resultado"
  %".12" = load i1, i1* %"resultado"
  %".13" = zext i1 %".12" to i32
  %".14" = call i32 @"robot_read_sensor"(i32 %".13")
  %"sensor_None" = alloca i32
  store i32 %".14", i32* %"sensor_None"
  %".16" = load i32, i32* %"a"
  %".17" = load i32, i32* %"b"
  %".18" = icmp slt i32 %".16", %".17"
  store i1 %".18", i1* %"resultado"
  %".20" = load i1, i1* %"resultado"
  %".21" = zext i1 %".20" to i32
  %".22" = call i32 @"robot_read_sensor"(i32 %".21")
  %"sensor_None.1" = alloca i32
  store i32 %".22", i32* %"sensor_None.1"
  %".24" = load i32, i32* %"a"
  %".25" = load i32, i32* %"b"
  %".26" = icmp eq i32 %".24", %".25"
  store i1 %".26", i1* %"resultado"
  %".28" = load i1, i1* %"resultado"
  %".29" = zext i1 %".28" to i32
  %".30" = call i32 @"robot_read_sensor"(i32 %".29")
  %"sensor_None.2" = alloca i32
  store i32 %".30", i32* %"sensor_None.2"
  %".32" = load i32, i32* %"a"
  %".33" = icmp sgt i32 %".32", true
  store i1 %".33", i1* %"resultado"
  %".35" = load i1, i1* %"resultado"
  %".36" = zext i1 %".35" to i32
  %".37" = call i32 @"robot_read_sensor"(i32 %".36")
  %"sensor_None.3" = alloca i32
  store i32 %".37", i32* %"sensor_None.3"
  ret i32 0
}
