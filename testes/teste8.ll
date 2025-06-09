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
  %".4" = add i32 2, 3
  %".5" = mul i32 %".4", 4
  %".6" = sdiv i32 5, 5
  %".7" = sub i32 %".5", %".6"
  store i32 %".7", i32* %"resultado"
  %".9" = load i32, i32* %"resultado"
  %".10" = call i32 @"robot_read_sensor"(i32 %".9")
  %"sensor_None" = alloca i32
  store i32 %".10", i32* %"sensor_None"
  ret i32 0
}
