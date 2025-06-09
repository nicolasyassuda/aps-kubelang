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
  store i32 0, i32* %"contador"
  br label %"while_cond"
while_cond:
  %".6" = load i32, i32* %"contador"
  %".7" = icmp slt i32 %".6", 3
  br i1 %".7", label %"while_body", label %"while_end"
while_body:
  %".9" = getelementptr [7 x i8], [7 x i8]* @"str_9", i32 0, i32 0
  call void @"robot_move"(i8* %".9", i32 1)
  %".11" = load i32, i32* %"stack_top"
  %".12" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_type", i32 0, i32 %".11"
  %".13" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_direction", i32 0, i32 %".11"
  %".14" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_value", i32 0, i32 %".11"
  store i32 0, i32* %".12"
  store i32 0, i32* %".13"
  store i32 1, i32* %".14"
  %".18" = add i32 %".11", 1
  store i32 %".18", i32* %"stack_top"
  %".20" = load i32, i32* %"contador"
  %".21" = add i32 %".20", 1
  store i32 %".21", i32* %"contador"
  br label %"while_cond"
while_end:
  ret i32 0
}

@"str_9" = constant [7 x i8] c"frente\00"