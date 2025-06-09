from compilador import AssignmentNode, BinOpNode, CleanTrashNode, DeclarationNode, ExpressionNode, IdentifierNode, IfNode, MoveNode, Parser, ReadingNode, RepeatNode, ReturnDockNode, RotateNode, StartCleanNode, StopCleanNode, Tokenizer, UnOpNode, WhileNode
import llvmlite.binding as llvm
import llvmlite.ir as ir
from typing import Dict, List, Any

class LLVMCodeGenerator:
    def __init__(self):
        self.module = ir.Module(name="robot_cleaner")
        self.builder = None
        self.func = None
        
        self.int_type = ir.IntType(32)
        self.bool_type = ir.IntType(1)
        self.void_type = ir.VoidType()
        
        self.variables: Dict[str, ir.AllocaInstr] = {}
        
        self.movement_stack_var = None
        self.stack_top_var = None
        self.stack_max_size = 1000 
        
        self._declare_external_functions()
        
    def _declare_external_functions(self):
        """Declara as funções externas que serão implementadas pelo sistema do robô"""
        move_func_type = ir.FunctionType(self.void_type, [ir.PointerType(ir.IntType(8)), self.int_type])
        self.move_func = ir.Function(self.module, move_func_type, name="robot_move")
        
        rotate_func_type = ir.FunctionType(self.void_type, [ir.PointerType(ir.IntType(8)), self.int_type])
        self.rotate_func = ir.Function(self.module, rotate_func_type, name="robot_rotate")

        clean_func_type = ir.FunctionType(self.void_type, [])
        self.start_clean_func = ir.Function(self.module, clean_func_type, name="robot_start_clean")
        self.stop_clean_func = ir.Function(self.module, clean_func_type, name="robot_stop_clean")
        self.clean_trash_func = ir.Function(self.module, clean_func_type, name="robot_clean_trash")
        
        self.return_dock_simple_func = ir.Function(self.module, clean_func_type, name="robot_return_dock_simple")
        
        read_sensor_func_type = ir.FunctionType(self.int_type, [self.int_type])
        self.read_sensor_func = ir.Function(self.module, read_sensor_func_type, name="robot_read_sensor")
        
        printf_type = ir.FunctionType(self.int_type, [ir.PointerType(ir.IntType(8))], var_arg=True)
        self.printf_func = ir.Function(self.module, printf_type, name="printf")
    
    def _init_movement_stack(self):
        """Inicializa a stack de movimentos para returndock"""
        stack_type = ir.ArrayType(self.int_type, self.stack_max_size)
        self.stack_type_var = self.builder.alloca(stack_type, name="movement_stack_type")
        
        stack_value = ir.ArrayType(self.int_type, self.stack_max_size)
        self.stack_value_var = self.builder.alloca(stack_value, name="movement_stack_value")
        
        stack_direction = ir.ArrayType(self.int_type, self.stack_max_size)
        self.stack_direction_var = self.builder.alloca(stack_direction, name="movement_stack_direction")
        
        self.stack_top_var = self.builder.alloca(self.int_type, name="stack_top")
        self.builder.store(ir.Constant(self.int_type, 0), self.stack_top_var)
    
    def _direction_to_code(self, direction: str) -> int:
        """Converte direção string para código numérico"""
        direction_map = {
            "frente": 0,
            "tras": 1, 
            "direita": 2,
            "esquerda": 3
        }
        return direction_map.get(direction.lower(), 0)
    
    def _code_to_direction(self, code: int) -> str:
        """Converte código numérico para direção string"""
        code_map = {
            0: "frente",
            1: "tras",
            2: "direita", 
            3: "esquerda"
        }
        return code_map.get(code, "frente")
    
    def _get_opposite_direction(self, direction: str) -> str:
        """Retorna a direção oposta para desfazer movimento"""
        opposite_map = {
            "frente": "tras",
            "tras": "frente",
            "direita": "esquerda",
            "esquerda": "direita"
        }
        return opposite_map.get(direction.lower(), direction)
    
    def _push_movement_to_stack(self, cmd_type: int, direction: str, value):
        """Adiciona um comando de movimento na stack"""
        stack_top = self.builder.load(self.stack_top_var)
        
        type_ptr = self.builder.gep(self.stack_type_var, [ir.Constant(self.int_type, 0), stack_top])
        direction_ptr = self.builder.gep(self.stack_direction_var, [ir.Constant(self.int_type, 0), stack_top])
        value_ptr = self.builder.gep(self.stack_value_var, [ir.Constant(self.int_type, 0), stack_top])
        
        self.builder.store(ir.Constant(self.int_type, cmd_type), type_ptr)
        self.builder.store(ir.Constant(self.int_type, self._direction_to_code(direction)), direction_ptr)
        self.builder.store(value, value_ptr)
        
        new_top = self.builder.add(stack_top, ir.Constant(self.int_type, 1))
        self.builder.store(new_top, self.stack_top_var)
    
    def _generate_return_stack_execution(self):
        """Gera código para executar a stack de movimentos de trás para frente"""
        stack_top = self.builder.load(self.stack_top_var)
        
        loop_cond = self.func.append_basic_block(name="return_loop_cond")
        loop_body = self.func.append_basic_block(name="return_loop_body")
        loop_end = self.func.append_basic_block(name="return_loop_end")
        
        counter = self.builder.alloca(self.int_type, name="return_counter")
        initial_counter = self.builder.sub(stack_top, ir.Constant(self.int_type, 1))
        self.builder.store(initial_counter, counter)
        
        self.builder.branch(loop_cond)
        
        self.builder.position_at_end(loop_cond)
        counter_val = self.builder.load(counter)
        cond = self.builder.icmp_signed('>=', counter_val, ir.Constant(self.int_type, 0))
        self.builder.cbranch(cond, loop_body, loop_end)
        
        self.builder.position_at_end(loop_body)
        
        counter_val = self.builder.load(counter)
        
        type_ptr = self.builder.gep(self.stack_type_var, [ir.Constant(self.int_type, 0), counter_val])
        direction_ptr = self.builder.gep(self.stack_direction_var, [ir.Constant(self.int_type, 0), counter_val])
        value_ptr = self.builder.gep(self.stack_value_var, [ir.Constant(self.int_type, 0), counter_val])
        
        cmd_type = self.builder.load(type_ptr)
        direction_code = self.builder.load(direction_ptr)
        value = self.builder.load(value_ptr)
        
        is_move_block = self.func.append_basic_block(name="is_move")
        is_rotate_block = self.func.append_basic_block(name="is_rotate")
        continue_block = self.func.append_basic_block(name="continue_return")
        
        is_move = self.builder.icmp_signed('==', cmd_type, ir.Constant(self.int_type, 0))
        self.builder.cbranch(is_move, is_move_block, is_rotate_block)
        
        self.builder.position_at_end(is_move_block)
        self._generate_reverse_move_switch(direction_code, value)
        self.builder.branch(continue_block)
        
        self.builder.position_at_end(is_rotate_block)
        self._generate_reverse_rotate_switch(direction_code, value)
        self.builder.branch(continue_block)
        
        self.builder.position_at_end(continue_block)
        counter_val = self.builder.load(counter)
        new_counter = self.builder.sub(counter_val, ir.Constant(self.int_type, 1))
        self.builder.store(new_counter, counter)
        self.builder.branch(loop_cond)
        
        self.builder.position_at_end(loop_end)
        
        self.builder.call(self.return_dock_simple_func, [])
        
        self.builder.store(ir.Constant(self.int_type, 0), self.stack_top_var)
    
    def _generate_reverse_move_switch(self, direction_code, value):
        """Gera switch para movimento reverso baseado no código de direção"""
        frente_block = self.func.append_basic_block(name="reverse_move_frente")
        tras_block = self.func.append_basic_block(name="reverse_move_tras")
        direita_block = self.func.append_basic_block(name="reverse_move_direita")
        esquerda_block = self.func.append_basic_block(name="reverse_move_esquerda")
        end_switch = self.func.append_basic_block(name="end_move_switch")
        
        switch = self.builder.switch(direction_code, end_switch)
        switch.add_case(ir.Constant(self.int_type, 0), frente_block)
        switch.add_case(ir.Constant(self.int_type, 1), tras_block)   
        switch.add_case(ir.Constant(self.int_type, 2), direita_block) 
        switch.add_case(ir.Constant(self.int_type, 3), esquerda_block)
        
        self.builder.position_at_end(frente_block)
        tras_str = self._create_string_constant("tras")
        self.builder.call(self.move_func, [tras_str, value])
        self.builder.branch(end_switch)
        
        self.builder.position_at_end(tras_block)
        frente_str = self._create_string_constant("frente")
        self.builder.call(self.move_func, [frente_str, value])
        self.builder.branch(end_switch)
        
        self.builder.position_at_end(direita_block)
        esquerda_str = self._create_string_constant("esquerda")
        self.builder.call(self.move_func, [esquerda_str, value])
        self.builder.branch(end_switch)
        
        self.builder.position_at_end(esquerda_block)
        direita_str = self._create_string_constant("direita")
        self.builder.call(self.move_func, [direita_str, value])
        self.builder.branch(end_switch)
        
        self.builder.position_at_end(end_switch)
    
    def _generate_reverse_rotate_switch(self, direction_code, value):
        """Gera switch para rotação reversa baseado no código de direção"""
        direita_block = self.func.append_basic_block(name="reverse_rotate_direita")
        esquerda_block = self.func.append_basic_block(name="reverse_rotate_esquerda")
        end_switch = self.func.append_basic_block(name="end_rotate_switch")
        
        switch = self.builder.switch(direction_code, end_switch)
        switch.add_case(ir.Constant(self.int_type, 2), direita_block)
        switch.add_case(ir.Constant(self.int_type, 3), esquerda_block)
        
        self.builder.position_at_end(direita_block)
        esquerda_str = self._create_string_constant("esquerda")
        self.builder.call(self.rotate_func, [esquerda_str, value])
        self.builder.branch(end_switch)
        
        self.builder.position_at_end(esquerda_block)
        direita_str = self._create_string_constant("direita")
        self.builder.call(self.rotate_func, [direita_str, value])
        self.builder.branch(end_switch)
        
        self.builder.position_at_end(end_switch)
    
    def generate_code(self, ast_nodes: List[Any]) -> str:
        """Gera o código LLVM a partir da AST"""
        main_func_type = ir.FunctionType(self.int_type, [])
        self.func = ir.Function(self.module, main_func_type, name="main")
        
        block = self.func.append_basic_block(name="entry")
        self.builder = ir.IRBuilder(block)
        
        self._init_movement_stack()
        
        for node in ast_nodes:
            self._generate_node(node)
        
        self.builder.ret(ir.Constant(self.int_type, 0))
        
        return str(self.module)
    
    def _generate_node(self, node):
        """Gera código LLVM para um nó específico da AST"""
        if isinstance(node, MoveNode):
            self._generate_move(node)
        elif isinstance(node, RotateNode):
            self._generate_rotate(node)
        elif isinstance(node, RepeatNode):
            self._generate_repeat(node)
        elif isinstance(node, WhileNode):
            self._generate_while(node)
        elif isinstance(node, IfNode):
            self._generate_if(node)
        elif isinstance(node, DeclarationNode):
            self._generate_declaration(node)
        elif isinstance(node, AssignmentNode):
            self._generate_assignment(node)
        elif isinstance(node, StartCleanNode):
            self._generate_start_clean()
        elif isinstance(node, StopCleanNode):
            self._generate_stop_clean()
        elif isinstance(node, CleanTrashNode):
            self._generate_clean_trash()
        elif isinstance(node, ReturnDockNode):
            self._generate_return_dock()
        else:
            raise ValueError(f"Tipo de nó não suportado: {type(node)}")
    
    def _generate_expression(self, expr_node):
        """Gera código para uma expressão e retorna o valor"""
        if isinstance(expr_node, ExpressionNode):
            if isinstance(expr_node.value, int):
                return ir.Constant(self.int_type, expr_node.value)
            elif isinstance(expr_node.value, bool):
                return ir.Constant(self.bool_type, expr_node.value)
            else:
                return self._generate_expression(expr_node.value)
        elif isinstance(expr_node, IdentifierNode):
            if expr_node.name in self.variables:
                return self.builder.load(self.variables[expr_node.name])
            else:
                raise ValueError(f"Variável não declarada: {expr_node.name}")
        elif isinstance(expr_node, BinOpNode):
            left = self._generate_expression(expr_node.left)
            right = self._generate_expression(expr_node.right)
            
            if expr_node.op_type == 'SUM':
                return self.builder.add(left, right)
            elif expr_node.op_type == 'SUB':
                return self.builder.sub(left, right)
            elif expr_node.op_type == 'MULT':
                return self.builder.mul(left, right)
            elif expr_node.op_type == 'DIV':
                return self.builder.sdiv(left, right)
            elif expr_node.op_type == 'MAIOR':
                return self.builder.icmp_signed('>', left, right)
            elif expr_node.op_type == 'MENOR':
                return self.builder.icmp_signed('<', left, right)
            elif expr_node.op_type == 'IGUAL':
                return self.builder.icmp_signed('==', left, right)
            elif expr_node.op_type == 'AND':
                return self.builder.and_(left, right)
            elif expr_node.op_type == 'OR':
                return self.builder.or_(left, right)
        elif isinstance(expr_node, UnOpNode):
            operand = self._generate_expression(expr_node.operand)
            if expr_node.op_type == 'NOT':
                return self.builder.not_(operand)
        elif isinstance(expr_node, ReadingNode):
            sensor_id = self._generate_expression(expr_node.sensor)
            return self.builder.call(self.read_sensor_func, [sensor_id])
        
        raise ValueError(f"Expressão não suportada: {type(expr_node)}")
    
    def _create_string_constant(self, text: str) -> ir.Constant:
        """Cria uma constante string no LLVM"""
        text_bytes = text.encode('utf-8') + b'\0'
        text_const = ir.Constant(ir.ArrayType(ir.IntType(8), len(text_bytes)), 
                                bytearray(text_bytes))
        text_global = ir.GlobalVariable(self.module, text_const.type, 
                                      name=f"str_{len(self.module.globals)}")
        text_global.initializer = text_const
        text_global.global_constant = True
        return self.builder.gep(text_global, [ir.Constant(self.int_type, 0), 
                                            ir.Constant(self.int_type, 0)])
    
    def _generate_move(self, node: 'MoveNode'):
        """Gera código para comando de movimento"""
        direction_str = self._create_string_constant(node.direction)
        distance = self._generate_expression(node.distance)
        
        self.builder.call(self.move_func, [direction_str, distance])
        
        self._push_movement_to_stack(0, node.direction, distance)
    
    def _generate_rotate(self, node: 'RotateNode'):
        """Gera código para comando de rotação"""
        direction_str = self._create_string_constant(node.direction)
        angle = self._generate_expression(node.angle)
        
        self.builder.call(self.rotate_func, [direction_str, angle])
        
        self._push_movement_to_stack(1, node.direction, angle)
    
    def _generate_repeat(self, node: 'RepeatNode'):
        """Gera código para comando repeat"""
        times = self._generate_expression(node.times)
        
        counter = self.builder.alloca(self.int_type, name="counter")
        self.builder.store(ir.Constant(self.int_type, 0), counter)
        
        loop_cond = self.func.append_basic_block(name="loop_cond")
        loop_body = self.func.append_basic_block(name="loop_body")
        loop_end = self.func.append_basic_block(name="loop_end")
        
        self.builder.branch(loop_cond)
        
        self.builder.position_at_end(loop_cond)
        counter_val = self.builder.load(counter)
        cond = self.builder.icmp_signed('<', counter_val, times)
        self.builder.cbranch(cond, loop_body, loop_end)
        
        self.builder.position_at_end(loop_body)
        for command in node.block:
            self._generate_node(command)
        
        counter_val = self.builder.load(counter)
        new_counter = self.builder.add(counter_val, ir.Constant(self.int_type, 1))
        self.builder.store(new_counter, counter)
        self.builder.branch(loop_cond)
        
        self.builder.position_at_end(loop_end)
    
    def _generate_while(self, node: 'WhileNode'):
        """Gera código para comando while"""
        loop_cond = self.func.append_basic_block(name="while_cond")
        loop_body = self.func.append_basic_block(name="while_body")
        loop_end = self.func.append_basic_block(name="while_end")
        
        self.builder.branch(loop_cond)
        
        self.builder.position_at_end(loop_cond)
        cond = self._generate_expression(node.condition)
        self.builder.cbranch(cond, loop_body, loop_end)
        
        self.builder.position_at_end(loop_body)
        for command in node.block:
            self._generate_node(command)
        self.builder.branch(loop_cond)
        
        self.builder.position_at_end(loop_end)
    
    def _generate_if(self, node: 'IfNode'):
        """Gera código para comando if"""
        cond = self._generate_expression(node.condition)
        
        if_body = self.func.append_basic_block(name="if_body")
        if_end = self.func.append_basic_block(name="if_end")
        
        self.builder.cbranch(cond, if_body, if_end)
        
        self.builder.position_at_end(if_body)
        for command in node.block:
            self._generate_node(command)
        self.builder.branch(if_end)
        
        self.builder.position_at_end(if_end)
    
    def _generate_declaration(self, node: 'DeclarationNode'):
        """Gera código para declaração de variável"""
        if node.var_type == "INT_TYPE":
            var_type = self.int_type
            default_value = ir.Constant(self.int_type, 0)
        else:
            var_type = self.bool_type
            default_value = ir.Constant(self.bool_type, False)
        
        alloca = self.builder.alloca(var_type, name=node.identifier)
        self.builder.store(default_value, alloca)
        self.variables[node.identifier] = alloca
    
    def _generate_assignment(self, node: 'AssignmentNode'):
        """Gera código para atribuição"""
        if node.identifier not in self.variables:
            raise ValueError(f"Variável não declarada: {node.identifier}")
        
        var_alloca = self.variables[node.identifier]
        
        if node.value == "INC":
            current = self.builder.load(var_alloca)
            new_value = self.builder.add(current, ir.Constant(self.int_type, 1))
            self.builder.store(new_value, var_alloca)
        elif node.value == "DEC":
            current = self.builder.load(var_alloca)
            new_value = self.builder.sub(current, ir.Constant(self.int_type, 1))
            self.builder.store(new_value, var_alloca)
        else:
            value = self._generate_expression(node.value)
            self.builder.store(value, var_alloca)
    
    def _generate_start_clean(self):
        """Gera código para iniciar limpeza"""
        self.builder.call(self.start_clean_func, [])
    
    def _generate_stop_clean(self):
        """Gera código para parar limpeza"""
        self.builder.call(self.stop_clean_func, [])
    
    def _generate_clean_trash(self):
        """Gera código para limpar lixo"""
        self.builder.call(self.clean_trash_func, [])
    
    def _generate_return_dock(self):
        """Gera código para retornar à base executando movimentos em ordem reversa"""
        self._generate_return_stack_execution()

def compile_to_llvm(source_code: str) -> str:
    """Compila o código fonte para LLVM IR"""
    tokenizer = Tokenizer(source_code)
    parser = Parser(tokenizer)
    ast = parser.parse()
    
    llvm_generator = LLVMCodeGenerator()
    llvm_ir = llvm_generator.generate_code(ast)
    
    return llvm_ir

if __name__ == "__main__":
    source_code = """
    int x
    x = 10
    
    _move frente x
    
    _if x > 5 {
        _rotate direita 90
        _startclean
    }
    
    _repeat 3 {
        _move frente 5
    }
    _returndock
    """
    
    try:
        llvm_ir = compile_to_llvm(source_code)
        print("Código LLVM IR gerado:")
        print(llvm_ir)
        
        # Salva o código em um arquivo
        with open("robot_program.ll", "w") as f:
            f.write(llvm_ir)
        print("\nCódigo salvo em 'robot_program.ll'")
        
    except Exception as e:
        print(f"Erro na compilação: {e}")