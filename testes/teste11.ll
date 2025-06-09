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
  %"contador" = alloca i32
  store i32 0, i32* %"contador"
  store i32 5, i32* %"contador"
  %".5" = load i32, i32* %"contador"
  %".6" = add i32 %".5", 1
  store i32 %".6", i32* %"contador"
  %".8" = load i32, i32* %"contador"
  %".9" = sub i32 %".8", 1
  store i32 %".9", i32* %"contador"
  %".11" = load i32, i32* %"contador"
  %".12" = sub i32 %".11", 1
  store i32 %".12", i32* %"contador"
  %".14" = load i32, i32* %"contador"
  %".15" = call i32 @"robot_read_sensor"(i32 %".14")
  %"sensor_None" = alloca i32
  store i32 %".15", i32* %"sensor_None"
  ret i32 0
}
