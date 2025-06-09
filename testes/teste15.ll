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
  %"i" = alloca i32
  store i32 0, i32* %"i"
  %"j" = alloca i32
  store i32 0, i32* %"j"
  %"continuar" = alloca i1
  store i1 false, i1* %"continuar"
  store i32 0, i32* %"i"
  store i32 0, i32* %"j"
  store i1 true, i1* %"continuar"
  br label %"while_cond"
while_cond:
  %".10" = load i32, i32* %"i"
  %".11" = icmp slt i32 %".10", 2
  br i1 %".11", label %"while_body", label %"while_end"
while_body:
  %"counter" = alloca i32
  store i32 0, i32* %"counter"
  br label %"loop_cond"
while_end:
  ret i32 0
loop_cond:
  %".15" = load i32, i32* %"counter"
  %".16" = icmp slt i32 %".15", 2
  br i1 %".16", label %"loop_body", label %"loop_end"
loop_body:
  %".18" = getelementptr [7 x i8], [7 x i8]* @"str_9", i32 0, i32 0
  call void @"robot_move"(i8* %".18", i32 1)
  %".20" = load i32, i32* %"stack_top"
  %".21" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_type", i32 0, i32 %".20"
  %".22" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_direction", i32 0, i32 %".20"
  %".23" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_value", i32 0, i32 %".20"
  store i32 0, i32* %".21"
  store i32 0, i32* %".22"
  store i32 1, i32* %".23"
  %".27" = add i32 %".20", 1
  store i32 %".27", i32* %"stack_top"
  %".29" = load i32, i32* %"j"
  %".30" = add i32 %".29", 1
  store i32 %".30", i32* %"j"
  %".32" = load i32, i32* %"counter"
  %".33" = add i32 %".32", 1
  store i32 %".33", i32* %"counter"
  br label %"loop_cond"
loop_end:
  %".36" = load i32, i32* %"i"
  %".37" = add i32 %".36", 1
  store i32 %".37", i32* %"i"
  %".39" = load i32, i32* %"j"
  %".40" = icmp eq i32 %".39", 4
  br i1 %".40", label %"if_body", label %"if_end"
if_body:
  store i1 false, i1* %"continuar"
  br label %"if_end"
if_end:
  br label %"while_cond"
}

@"str_9" = constant [7 x i8] c"frente\00"