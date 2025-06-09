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
  %"iniciar" = alloca i1
  store i1 false, i1* %"iniciar"
  store i1 true, i1* %"iniciar"
  %".5" = load i1, i1* %"iniciar"
  br i1 %".5", label %"if_body", label %"if_end"
if_body:
  call void @"robot_start_clean"()
  %".8" = getelementptr [7 x i8], [7 x i8]* @"str_9", i32 0, i32 0
  call void @"robot_move"(i8* %".8", i32 3)
  %".10" = load i32, i32* %"stack_top"
  %".11" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_type", i32 0, i32 %".10"
  %".12" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_direction", i32 0, i32 %".10"
  %".13" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_value", i32 0, i32 %".10"
  store i32 0, i32* %".11"
  store i32 0, i32* %".12"
  store i32 3, i32* %".13"
  %".17" = add i32 %".10", 1
  store i32 %".17", i32* %"stack_top"
  call void @"robot_stop_clean"()
  br label %"if_end"
if_end:
  ret i32 0
}

@"str_9" = constant [7 x i8] c"frente\00"