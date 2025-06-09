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
  %".3" = call i32 @"robot_read_sensor"(i32 1)
  %"sensor_1" = alloca i32
  store i32 %".3", i32* %"sensor_1"
  %".5" = call i32 @"robot_read_sensor"(i32 2)
  %"sensor_2" = alloca i32
  store i32 %".5", i32* %"sensor_2"
  %".7" = call i32 @"robot_read_sensor"(i32 3)
  %"sensor_3" = alloca i32
  store i32 %".7", i32* %"sensor_3"
  ret i32 0
}
