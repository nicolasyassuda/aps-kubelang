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
  %"distancia" = alloca i32
  store i32 0, i32* %"distancia"
  %"sujeira" = alloca i32
  store i32 0, i32* %"sujeira"
  %"limpar" = alloca i1
  store i1 false, i1* %"limpar"
  store i32 5, i32* %"distancia"
  store i32 3, i32* %"sujeira"
  store i1 false, i1* %"limpar"
  %".9" = load i32, i32* %"distancia"
  %".10" = icmp slt i32 %".9", 10
  br i1 %".10", label %"if_body", label %"if_end"
if_body:
  %".12" = getelementptr [7 x i8], [7 x i8]* @"str_9", i32 0, i32 0
  %".13" = load i32, i32* %"distancia"
  call void @"robot_move"(i8* %".12", i32 %".13")
  %".15" = load i32, i32* %"stack_top"
  %".16" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_type", i32 0, i32 %".15"
  %".17" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_direction", i32 0, i32 %".15"
  %".18" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_value", i32 0, i32 %".15"
  store i32 0, i32* %".16"
  store i32 0, i32* %".17"
  store i32 %".13", i32* %".18"
  %".22" = add i32 %".15", 1
  store i32 %".22", i32* %"stack_top"
  br label %"if_end"
if_end:
  %".25" = load i32, i32* %"sujeira"
  %".26" = icmp sgt i32 %".25", 2
  br i1 %".26", label %"if_body.1", label %"if_end.1"
if_body.1:
  call void @"robot_clean_trash"()
  store i1 true, i1* %"limpar"
  br label %"if_end.1"
if_end.1:
  %".31" = load i1, i1* %"limpar"
  br i1 %".31", label %"if_body.2", label %"if_end.2"
if_body.2:
  call void @"robot_start_clean"()
  br label %"if_end.2"
if_end.2:
  ret i32 0
}

@"str_9" = constant [7 x i8] c"frente\00"