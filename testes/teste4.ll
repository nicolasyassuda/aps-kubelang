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
  %".3" = getelementptr [7 x i8], [7 x i8]* @"str_9", i32 0, i32 0
  call void @"robot_move"(i8* %".3", i32 5)
  %".5" = load i32, i32* %"stack_top"
  %".6" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_type", i32 0, i32 %".5"
  %".7" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_direction", i32 0, i32 %".5"
  %".8" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_value", i32 0, i32 %".5"
  store i32 0, i32* %".6"
  store i32 0, i32* %".7"
  store i32 5, i32* %".8"
  %".12" = add i32 %".5", 1
  store i32 %".12", i32* %"stack_top"
  %".14" = getelementptr [9 x i8], [9 x i8]* @"str_10", i32 0, i32 0
  call void @"robot_rotate"(i8* %".14", i32 90)
  %".16" = load i32, i32* %"stack_top"
  %".17" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_type", i32 0, i32 %".16"
  %".18" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_direction", i32 0, i32 %".16"
  %".19" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_value", i32 0, i32 %".16"
  store i32 1, i32* %".17"
  store i32 3, i32* %".18"
  store i32 90, i32* %".19"
  %".23" = add i32 %".16", 1
  store i32 %".23", i32* %"stack_top"
  %".25" = getelementptr [5 x i8], [5 x i8]* @"str_11", i32 0, i32 0
  call void @"robot_move"(i8* %".25", i32 3)
  %".27" = load i32, i32* %"stack_top"
  %".28" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_type", i32 0, i32 %".27"
  %".29" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_direction", i32 0, i32 %".27"
  %".30" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_value", i32 0, i32 %".27"
  store i32 0, i32* %".28"
  store i32 1, i32* %".29"
  store i32 3, i32* %".30"
  %".34" = add i32 %".27", 1
  store i32 %".34", i32* %"stack_top"
  %".36" = getelementptr [8 x i8], [8 x i8]* @"str_12", i32 0, i32 0
  call void @"robot_rotate"(i8* %".36", i32 45)
  %".38" = load i32, i32* %"stack_top"
  %".39" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_type", i32 0, i32 %".38"
  %".40" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_direction", i32 0, i32 %".38"
  %".41" = getelementptr [1000 x i32], [1000 x i32]* %"movement_stack_value", i32 0, i32 %".38"
  store i32 1, i32* %".39"
  store i32 2, i32* %".40"
  store i32 45, i32* %".41"
  %".45" = add i32 %".38", 1
  store i32 %".45", i32* %"stack_top"
  ret i32 0
}

@"str_9" = constant [7 x i8] c"frente\00"
@"str_10" = constant [9 x i8] c"esquerda\00"
@"str_11" = constant [5 x i8] c"tras\00"
@"str_12" = constant [8 x i8] c"direita\00"