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
  %"status" = alloca i32
  store i32 0, i32* %"status"
  store i32 1, i32* %"status"
  %".5" = load i32, i32* %"status"
  %".6" = icmp eq i32 %".5", 1
  br i1 %".6", label %"if_body", label %"if_end"
if_body:
  %".8" = load i32, i32* %"stack_top"
  %"return_counter" = alloca i32
  %".9" = sub i32 %".8", 1
  store i32 %".9", i32* %"return_counter"
  br label %"return_loop_cond"
if_end:
  ret i32 0
return_loop_cond:
  %".12" = load i32, i32* %"return_counter"
  %".13" = icmp sge i32 %".12", 0
  br i1 %".13", label %"return_loop_body", label %"return_loop_end"
return_loop_body:
  %".15" = load i32, i32* %"return_counter"
  %".16" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_type", i32 0, i32 %".15"
  %".17" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_direction", i32 0, i32 %".15"
  %".18" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_value", i32 0, i32 %".15"
  %".19" = load i32, i32* %".16"
  %".20" = load i32, i32* %".17"
  %".21" = load i32, i32* %".18"
  %".22" = icmp eq i32 %".19", 0
  br i1 %".22", label %"is_move", label %"is_rotate"
return_loop_end:
  call void @"robot_return_dock_simple"()
  store i32 0, i32* %"stack_top"
  br label %"if_end"
is_move:
  switch i32 %".20", label %"end_move_switch" [i32 0, label %"reverse_move_frente" i32 1, label %"reverse_move_tras" i32 2, label %"reverse_move_direita" i32 3, label %"reverse_move_esquerda"]
is_rotate:
  switch i32 %".20", label %"end_rotate_switch" [i32 2, label %"reverse_rotate_direita" i32 3, label %"reverse_rotate_esquerda"]
continue_return:
  %".46" = load i32, i32* %"return_counter"
  %".47" = sub i32 %".46", 1
  store i32 %".47", i32* %"return_counter"
  br label %"return_loop_cond"
reverse_move_frente:
  %".25" = getelementptr [5 x i8], [5 x i8]* @"str_9", i32 0, i32 0
  call void @"robot_move"(i8* %".25", i32 %".21")
  br label %"end_move_switch"
reverse_move_tras:
  %".28" = getelementptr [7 x i8], [7 x i8]* @"str_10", i32 0, i32 0
  call void @"robot_move"(i8* %".28", i32 %".21")
  br label %"end_move_switch"
reverse_move_direita:
  %".31" = getelementptr [9 x i8], [9 x i8]* @"str_11", i32 0, i32 0
  call void @"robot_move"(i8* %".31", i32 %".21")
  br label %"end_move_switch"
reverse_move_esquerda:
  %".34" = getelementptr [8 x i8], [8 x i8]* @"str_12", i32 0, i32 0
  call void @"robot_move"(i8* %".34", i32 %".21")
  br label %"end_move_switch"
end_move_switch:
  br label %"continue_return"
reverse_rotate_direita:
  %".39" = getelementptr [9 x i8], [9 x i8]* @"str_13", i32 0, i32 0
  call void @"robot_rotate"(i8* %".39", i32 %".21")
  br label %"end_rotate_switch"
reverse_rotate_esquerda:
  %".42" = getelementptr [8 x i8], [8 x i8]* @"str_14", i32 0, i32 0
  call void @"robot_rotate"(i8* %".42", i32 %".21")
  br label %"end_rotate_switch"
end_rotate_switch:
  br label %"continue_return"
}

@"str_9" = constant [5 x i8] c"tras\00"
@"str_10" = constant [7 x i8] c"frente\00"
@"str_11" = constant [9 x i8] c"esquerda\00"
@"str_12" = constant [8 x i8] c"direita\00"
@"str_13" = constant [9 x i8] c"esquerda\00"
@"str_14" = constant [8 x i8] c"direita\00"