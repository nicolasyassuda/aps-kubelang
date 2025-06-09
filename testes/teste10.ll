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
  %"resultado" = alloca i32
  store i32 0, i32* %"resultado"
  %".4" = mul i32 3, 4
  %".5" = add i32 2, %".4"
  store i32 %".5", i32* %"resultado"
  %".7" = load i32, i32* %"resultado"
  %".8" = call i32 @"robot_read_sensor"(i32 %".7")
  %"sensor_None" = alloca i32
  store i32 %".8", i32* %"sensor_None"
  %".10" = add i32 2, 3
  %".11" = mul i32 %".10", 4
  store i32 %".11", i32* %"resultado"
  %".13" = load i32, i32* %"resultado"
  %".14" = call i32 @"robot_read_sensor"(i32 %".13")
  %"sensor_None.1" = alloca i32
  store i32 %".14", i32* %"sensor_None.1"
  ret i32 0
}
