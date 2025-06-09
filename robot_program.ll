; ModuleID = "robot_cleaner"
target triple = "unknown-unknown-unknown"
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
  %"x" = alloca i32
  store i32 0, i32* %"x"
  store i32 10, i32* %"x"
  %".5" = getelementptr [7 x i8], [7 x i8]* @"str_9", i32 0, i32 0
  %".6" = load i32, i32* %"x"
  call void @"robot_move"(i8* %".5", i32 %".6")
  %".8" = load i32, i32* %"stack_top"
  %".9" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_type", i32 0, i32 %".8"
  %".10" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_direction", i32 0, i32 %".8"
  %".11" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_value", i32 0, i32 %".8"
  store i32 0, i32* %".9"
  store i32 0, i32* %".10"
  store i32 %".6", i32* %".11"
  %".15" = add i32 %".8", 1
  store i32 %".15", i32* %"stack_top"
  %".17" = load i32, i32* %"x"
  %".18" = icmp sgt i32 %".17", 5
  br i1 %".18", label %"if_body", label %"if_end"
if_body:
  %".20" = getelementptr [8 x i8], [8 x i8]* @"str_10", i32 0, i32 0
  call void @"robot_rotate"(i8* %".20", i32 90)
  %".22" = load i32, i32* %"stack_top"
  %".23" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_type", i32 0, i32 %".22"
  %".24" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_direction", i32 0, i32 %".22"
  %".25" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_value", i32 0, i32 %".22"
  store i32 1, i32* %".23"
  store i32 2, i32* %".24"
  store i32 90, i32* %".25"
  %".29" = add i32 %".22", 1
  store i32 %".29", i32* %"stack_top"
  call void @"robot_start_clean"()
  br label %"if_end"
if_end:
  %"counter" = alloca i32
  store i32 0, i32* %"counter"
  br label %"loop_cond"
loop_cond:
  %".35" = load i32, i32* %"counter"
  %".36" = icmp slt i32 %".35", 3
  br i1 %".36", label %"loop_body", label %"loop_end"
loop_body:
  %".38" = getelementptr [7 x i8], [7 x i8]* @"str_11", i32 0, i32 0
  call void @"robot_move"(i8* %".38", i32 5)
  %".40" = load i32, i32* %"stack_top"
  %".41" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_type", i32 0, i32 %".40"
  %".42" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_direction", i32 0, i32 %".40"
  %".43" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_value", i32 0, i32 %".40"
  store i32 0, i32* %".41"
  store i32 0, i32* %".42"
  store i32 5, i32* %".43"
  %".47" = add i32 %".40", 1
  store i32 %".47", i32* %"stack_top"
  %".49" = load i32, i32* %"counter"
  %".50" = add i32 %".49", 1
  store i32 %".50", i32* %"counter"
  br label %"loop_cond"
loop_end:
  %".53" = load i32, i32* %"stack_top"
  %"return_counter" = alloca i32
  %".54" = sub i32 %".53", 1
  store i32 %".54", i32* %"return_counter"
  br label %"return_loop_cond"
return_loop_cond:
  %".57" = load i32, i32* %"return_counter"
  %".58" = icmp sge i32 %".57", 0
  br i1 %".58", label %"return_loop_body", label %"return_loop_end"
return_loop_body:
  %".60" = load i32, i32* %"return_counter"
  %".61" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_type", i32 0, i32 %".60"
  %".62" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_direction", i32 0, i32 %".60"
  %".63" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_value", i32 0, i32 %".60"
  %".64" = load i32, i32* %".61"
  %".65" = load i32, i32* %".62"
  %".66" = load i32, i32* %".63"
  %".67" = icmp eq i32 %".64", 0
  br i1 %".67", label %"is_move", label %"is_rotate"
return_loop_end:
  call void @"robot_return_dock_simple"()
  store i32 0, i32* %"stack_top"
  ret i32 0
is_move:
  switch i32 %".65", label %"end_move_switch" [i32 0, label %"reverse_move_frente" i32 1, label %"reverse_move_tras" i32 2, label %"reverse_move_direita" i32 3, label %"reverse_move_esquerda"]
is_rotate:
  switch i32 %".65", label %"end_rotate_switch" [i32 2, label %"reverse_rotate_direita" i32 3, label %"reverse_rotate_esquerda"]
continue_return:
  %".91" = load i32, i32* %"return_counter"
  %".92" = sub i32 %".91", 1
  store i32 %".92", i32* %"return_counter"
  br label %"return_loop_cond"
reverse_move_frente:
  %".70" = getelementptr [5 x i8], [5 x i8]* @"str_12", i32 0, i32 0
  call void @"robot_move"(i8* %".70", i32 %".66")
  br label %"end_move_switch"
reverse_move_tras:
  %".73" = getelementptr [7 x i8], [7 x i8]* @"str_13", i32 0, i32 0
  call void @"robot_move"(i8* %".73", i32 %".66")
  br label %"end_move_switch"
reverse_move_direita:
  %".76" = getelementptr [9 x i8], [9 x i8]* @"str_14", i32 0, i32 0
  call void @"robot_move"(i8* %".76", i32 %".66")
  br label %"end_move_switch"
reverse_move_esquerda:
  %".79" = getelementptr [8 x i8], [8 x i8]* @"str_15", i32 0, i32 0
  call void @"robot_move"(i8* %".79", i32 %".66")
  br label %"end_move_switch"
end_move_switch:
  br label %"continue_return"
reverse_rotate_direita:
  %".84" = getelementptr [9 x i8], [9 x i8]* @"str_16", i32 0, i32 0
  call void @"robot_rotate"(i8* %".84", i32 %".66")
  br label %"end_rotate_switch"
reverse_rotate_esquerda:
  %".87" = getelementptr [8 x i8], [8 x i8]* @"str_17", i32 0, i32 0
  call void @"robot_rotate"(i8* %".87", i32 %".66")
  br label %"end_rotate_switch"
end_rotate_switch:
  br label %"continue_return"
}

@"str_9" = constant [7 x i8] c"frente\00"
@"str_10" = constant [8 x i8] c"direita\00"
@"str_11" = constant [7 x i8] c"frente\00"
@"str_12" = constant [5 x i8] c"tras\00"
@"str_13" = constant [7 x i8] c"frente\00"
@"str_14" = constant [9 x i8] c"esquerda\00"
@"str_15" = constant [8 x i8] c"direita\00"
@"str_16" = constant [9 x i8] c"esquerda\00"
@"str_17" = constant [8 x i8] c"direita\00"