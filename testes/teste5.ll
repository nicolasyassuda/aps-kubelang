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
  %"counter" = alloca i32
  store i32 0, i32* %"counter"
  br label %"loop_cond"
loop_cond:
  %".5" = load i32, i32* %"counter"
  %".6" = icmp slt i32 %".5", 3
  br i1 %".6", label %"loop_body", label %"loop_end"
loop_body:
  %".8" = getelementptr [7 x i8], [7 x i8]* @"str_9", i32 0, i32 0
  call void @"robot_move"(i8* %".8", i32 2)
  %".10" = load i32, i32* %"stack_top"
  %".11" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_type", i32 0, i32 %".10"
  %".12" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_direction", i32 0, i32 %".10"
  %".13" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_value", i32 0, i32 %".10"
  store i32 0, i32* %".11"
  store i32 0, i32* %".12"
  store i32 2, i32* %".13"
  %".17" = add i32 %".10", 1
  store i32 %".17", i32* %"stack_top"
  %".19" = getelementptr [8 x i8], [8 x i8]* @"str_10", i32 0, i32 0
  call void @"robot_rotate"(i8* %".19", i32 90)
  %".21" = load i32, i32* %"stack_top"
  %".22" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_type", i32 0, i32 %".21"
  %".23" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_direction", i32 0, i32 %".21"
  %".24" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_value", i32 0, i32 %".21"
  store i32 1, i32* %".22"
  store i32 2, i32* %".23"
  store i32 90, i32* %".24"
  %".28" = add i32 %".21", 1
  store i32 %".28", i32* %"stack_top"
  %".30" = load i32, i32* %"counter"
  %".31" = add i32 %".30", 1
  store i32 %".31", i32* %"counter"
  br label %"loop_cond"
loop_end:
  ret i32 0
}

@"str_9" = constant [7 x i8] c"frente\00"
@"str_10" = constant [8 x i8] c"direita\00"