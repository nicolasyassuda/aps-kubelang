import sys
'''
Este codigo é destinado a um compilador de uma liguagem de programação propria para controle de um robô de limpeza.

A linguagem é composta por 4 tipos de comandos:
    - Comandos de movimento
    - Comandos de controle
    - Comandos de sistema
    - Comandos de limpeza
    
Os comandos de movimento são:
    - _move <direção> <distancia>
    - _rotate <direção> <angulo>

Os comandos de controle são:
    - _repeat <n> <comando>
    - _while <condição> <comando>
    - _if <condição> <comando>

Os comandos de sistema são:
    - _returndock
    - _cleanthrash
    - _readSensor <sensor>

Os comandos de limpeza são:
    - _stopclean
    - _startclean
    
E claro tambem é composto por declaração de variaveis, operações matematicas e operações logicas.

A linguagem é composta por 3 tipos de variaveis:
    - Inteiro (para evitar imprecisão em leituras de sensores).
    - Logico (para controle de fluxo).
    
A linguagem é composta por 4 operações matematicas:
    - Soma
    - Subtração
    - Multiplicação
    - Divisão

A linguagem é composta por 3 operações logicas:
    - E
    - Ou
    - Negação

A linguagem é composta por 3 operações de comparação:
    - Maior
    - Menor
    - Igual

A linguagem é composta por 3 operações de atribuição:
    - Atribuição
    - Incremento
    - Decremento

A linguagem é composta por 3 operações de leitura:
    - Leitura de sensor de distancia
    - Leitura de sensor de sujeira
    - Leitura de sensor de bateria

A EBNF da linguagem é a seguinte:

<programa> ::= {<comando>}
<comando> ::= <comando_movimento> | <comando_controle> | <comando_sistema> | <comando_limpeza> | <declaracao> | <atribuicao> | <leitura> | <operacao_matematica> | <operacao_logica> | <operacao_comparacao>

<comando_movimento> ::= "_move" <direcao> <expressao> | "_rotate" <rotacao> <expressao>

<comando_controle> ::= "_repeat" <expressao> <bloco> | "_while" <condicao> <bloco> | "_if" <condicao> <bloco>

<bloco> ::= "{" {<comando>} "}"

<comando_sistema> ::= "_returndock" | "_cleanthrash"
<comando_limpeza> ::= "_stopclean" | "_startclean"
<declaracao> ::= "int" <variavel> | "bool" <variavel>
<atribuicao> ::= <variavel> "=" <expressao> | <variavel> "++" | <variavel> "--"
<leitura> ::= "readdistance" | "readsujo" | "readbateria"

<expressao> ::= <termo> { ("+" | "-") <termo> }
<termo> ::= <fator> { ("*" | "/") <fator> }
<fator> ::= <numero> | <variavel> | "(" <expressao> ")"

<operacao_logica> ::= <variavel> "and" <variavel> | <variavel> "or" <variavel> | "!" <variavel>
<operacao_comparacao> ::= <expressao> ">" <expressao> | <expressao> "<" <expressao> | <expressao> "==" <expressao>

<direcao> ::= "frente" | "tras" 
<rotacao> ::= "esquerda" | "direita"
<condicao> ::= <variavel> | <operacao_comparacao> | <inversao>

<variavel> ::= <letra> {<letra> | <numero>}
<numero> ::= <digito> {<digito>}
<digito> ::= "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
<letra> ::= [a-zA-Z]
<inversao> ::= "!" <variavel> | "!" <condicao>

'''

class Token:
    def __init__(self, tipo, valor):
        self.tipo = tipo
        self.valor = valor

class Tokenizer:
    def __init__(self, source: str):
        self.source = source
        self.pos = 0
        self.next = None
    
    def next_token(self):
        # Ignora espaços em branco
        while self.pos < len(self.source) and self.source[self.pos] in " \n\t":
            self.pos += 1
        
        if self.pos >= len(self.source):
            self.next = Token("EOF", None)
            return
        
        char = self.source[self.pos]
        # Processamento de blocos
        if char == '{':
            self.pos += 1
            self.next = Token("LBRACE", '{')
            return
        elif char == '}':
            self.pos += 1
            self.next = Token("RBRACE", '}')
            return
        # Comandos que começam com '_'
        elif char == "_":
            self.pos += 1
            char = "_"
            while self.pos < len(self.source) and self.source[self.pos] not in " \n\t":
                char += self.source[self.pos]
                self.pos += 1    
            if char == "_move":
                self.next = Token("MOVE", char)
            elif char == "_rotate":
                self.next = Token("ROTATE", char)
            elif char == "_repeat":
                self.next = Token("REPEAT", char)
            elif char == "_while":
                self.next = Token("WHILE", char)
            elif char == "_if":
                self.next = Token("IF", char)
            elif char == "_returndock":
                self.next = Token("RETURNDOCK", char)
            elif char == "_cleanthrash":
                self.next = Token("CLEANTHRASH", char)
            elif char == "_stopclean":
                self.next = Token("STOPCLEAN", char)
            elif char == "_startclean":
                self.next = Token("STARTCLEAN", char)
            elif char == "_readSensor":
                self.next = Token("READING", char)
            else:
                raise ValueError(f"Token inválido: {char}")
            return
        
        # Identificadores, palavras-chave e direções
        elif char in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ":
            start_pos = self.pos
            while self.pos < len(self.source) and self.source[self.pos] in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789":
                self.pos += 1
            char = self.source[start_pos:self.pos]
            if char in ["frente", "tras", "esquerda", "direita"]:
                self.next = Token("DIRECAO", char)
            elif char in ["int", "bool"]:
                if(char == "int"):
                    self.next = Token("INT_TYPE", char)
                else:
                    self.next = Token("BOOL_TYPE", char)
            elif char in ["true", "false"]:
                self.next = Token("BOOL", char)
            elif char in ["and", "or"]:
                self.next = Token(char.upper(), char)
            else:
                self.next = Token("IDENT", char)
            return

        # Operadores matemáticos e incremento/decremento
        elif char in "+-*/":
            self.pos += 1
            if char == "+" and self.pos < len(self.source) and self.source[self.pos] == "+":
                self.pos += 1
                self.next = Token("INC", "++")
            elif char == "-" and self.pos < len(self.source) and self.source[self.pos] == "-":
                self.pos += 1
                self.next = Token("DEC", "--")
            else:
                self.next = Token({"+" : "SUM", "-" : "SUB", "*" : "MULT", "/" : "DIV"}[char], char)
            return

        # Operadores lógicos e de negação
        elif char == "!":
            self.pos += 1
            self.next = Token("NOT", "!")
            return

        # Operadores de comparação e atribuição
        elif char in "<>=":
            op_char = char
            self.pos += 1
            if op_char == "=" and self.pos < len(self.source) and self.source[self.pos] == "=":
                self.pos += 1
                self.next = Token("IGUAL", "==")
            else:
                self.next = Token({
                    "<": "MENOR",
                    ">": "MAIOR",
                    "=": "ATRIB"
                }[op_char], op_char)
            return

        # Números
        elif char in "0123456789":
            start_pos = self.pos
            while self.pos < len(self.source) and self.source[self.pos] in "0123456789":
                self.pos += 1
            char = self.source[start_pos:self.pos]
            self.next = Token("NUM", int(char))
            return
        elif char == "(":
            self.pos += 1
            self.next = Token("LPAREN", char)
            return
        elif char == ")":
            self.pos += 1
            self.next = Token("RPAREN", char)
            return

        else:
            raise ValueError(f"Token inválido: {char}")

class StackOfCommands:
    def __init__(self):
        self.stack = []
    
    def push(self, command):
        self.stack.append(command)
    
    def pop(self):
        return self.stack.pop()
    
    def top(self):
        return self.stack[-1]

    def __len__(self):
        return len(self.stack)
    

class SymbolTable:
    def __init__(self):
        self.variables = {}

    def getter(self, identifier):
        if identifier in self.variables:
            return self.variables[identifier]
        else:
            raise ValueError(f"Identificador '{identifier}' não encontrado")

    def setter(self, identifier, value_and_type):
        if identifier not in self.variables:
            raise ValueError(f"Variável '{identifier}' não declarada")
        self.variables[identifier] = value_and_type

    def declare(self, identifier, value_and_type):
        if identifier in self.variables:
            raise ValueError(f"Variável '{identifier}' já declarada")
        self.variables[identifier] = value_and_type
        return value_and_type
    
class Node:
    def evaluate(self, symbol_table: SymbolTable, stack_of_commands: StackOfCommands):
        pass

class MoveNode(Node):
    def __init__(self, direction, distance):
        self.direction = direction
        self.distance = distance

    def evaluate(self, symbol_table, stack_of_commands):
        distance_value = self.distance.evaluate(symbol_table, stack_of_commands)
        stack_of_commands.push((self.direction, distance_value))
        print(f"Movendo {self.direction} por {distance_value} unidades")

class RotateNode(Node):
    def __init__(self, direction, angle):
        self.direction = direction
        self.angle = angle

    def evaluate(self, symbol_table,stack_of_commands):
        angle_value = self.angle.evaluate(symbol_table,stack_of_commands)
        stack_of_commands.push((self.direction, angle_value))
        print(f"Rotacionando {self.direction} por {angle_value} graus")

class RepeatNode(Node):
    def __init__(self, times, block):
        self.times = times
        self.block = block

    def evaluate(self, symbol_table, stack_of_commands):
        times_value = self.times.evaluate(symbol_table,stack_of_commands)
        for _ in range(times_value):
            for command in self.block:
                command.evaluate(symbol_table,stack_of_commands)

class WhileNode(Node):
    def __init__(self, condition, block):
        self.condition = condition
        self.block = block

    def evaluate(self, symbol_table, stack_of_commands):
        while self.condition.evaluate(symbol_table,stack_of_commands):
            for command in self.block:
                command.evaluate(symbol_table,stack_of_commands)

class IfNode(Node):
    def __init__(self, condition, block):
        self.condition = condition
        self.block = block

    def evaluate(self, symbol_table, stack_of_commands):
        if self.condition.evaluate(symbol_table,stack_of_commands):
            for command in self.block:
                command.evaluate(symbol_table,stack_of_commands)

class ReturnDockNode(Node):
    
    def evaluate(self, symbol_table, stack_of_commands):
        while stack_of_commands.__len__() > 0:
            comando = stack_of_commands.pop()
            if comando[0] == "frente":
                print(f"Voltando {comando[1]} unidades")
            elif comando[0] == "tras":
                print(f"Avançando {comando[1]} unidades")
            elif comando[0] == "esquerda":
                print(f"Rotacionando {comando[1]} graus à direita")
            else:
                print(f"Rotacionando {comando[1]} graus à esquerda")
        print("Retornando à base de carregamento")

class CleanTrashNode(Node):
    def evaluate(self, symbol_table, stack_of_commands):
        print("Limpando o lixo")

class StopCleanNode(Node):
    def evaluate(self, symbol_table, stack_of_commands):
        print("Parando a limpeza")

class StartCleanNode(Node):
    def evaluate(self, symbol_table, stack_of_commands):
        print("Iniciando a limpeza")

class DeclarationNode(Node):
    def __init__(self, var_type, identifier):
        self.var_type = var_type
        self.identifier = identifier

    def evaluate(self, symbol_table,stack_of_commands):
        default_value = 0 if self.var_type == "INT_TYPE" else False
        symbol_table.declare(self.identifier, (default_value, self.var_type))

class AssignmentNode(Node):
    def __init__(self, identifier, value):
        self.identifier = identifier
        self.value = value

    def evaluate(self, symbol_table, stack_of_commands):
        if self.value in ["++", "INC"]:
            current_value, var_type = symbol_table.getter(self.identifier)
            symbol_table.setter(self.identifier, (current_value + 1, var_type))
        elif self.value in ["--", "DEC"]:
            current_value, var_type = symbol_table.getter(self.identifier)
            symbol_table.setter(self.identifier, (current_value - 1, var_type))
        elif isinstance(self.value, Node):
            value = self.value.evaluate(symbol_table, stack_of_commands)
            var_type = symbol_table.variables[self.identifier][1]
            symbol_table.setter(self.identifier, (value, var_type))
        else:
            raise ValueError(f"Valor de atribuição inválido para '{self.identifier}'")

class ReadingNode(Node):
    def __init__(self, sensor):
        self.sensor = sensor

    def evaluate(self, symbol_table,stack_of_commands):
        # Implementar a lógica de leitura do sensor
        valor = self.sensor.evaluate(symbol_table,stack_of_commands)
        print(f"Lendo o sensor {valor}")
        
        exemploSensor = {
            0: 0,
            1: 10,
            2: 20,
            3: 30,
            4: 40
        }
        
        return exemploSensor.get(valor, -1)
    
class ExpressionNode(Node):
    def __init__(self, value):
        self.value = value

    def evaluate(self, symbol_table, stack_of_commands):
        if isinstance(self.value, Node):
            return self.value.evaluate(symbol_table,stack_of_commands)
        else:
            return self.value

class IdentifierNode(Node):
    def __init__(self, name):
        self.name = name
        self.value = None

    def evaluate(self, symbol_table, stack_of_commands):
        value, var_type = symbol_table.getter(self.name)
        return value

class BinOpNode(Node):
    def __init__(self, op_type, left, right):
        self.op_type = op_type
        self.left = left
        self.right = right

    def evaluate(self, symbol_table, stack_of_commands):
        left_val = self.left.evaluate(symbol_table,stack_of_commands)
        right_val = self.right.evaluate(symbol_table,stack_of_commands)
        if self.op_type == 'SUM':
            return left_val + right_val
        elif self.op_type == 'SUB':
            return left_val - right_val
        elif self.op_type == 'MULT':
            return left_val * right_val
        elif self.op_type == 'DIV':
            return left_val // right_val
        elif self.op_type == 'MAIOR':
            return int(left_val > right_val)
        elif self.op_type == 'MENOR':
            return int(left_val < right_val)
        elif self.op_type == 'IGUAL':
            return int(left_val == right_val)
        elif self.op_type == 'AND':
            return int(left_val and right_val)
        elif self.op_type == 'OR':
            return int(left_val or right_val)
        else:
            raise ValueError(f"Operador desconhecido '{self.op_type}'")

class UnOpNode(Node):
    def __init__(self, op_type, operand):
        self.op_type = op_type
        self.operand = operand

    def evaluate(self, symbol_table, stack_of_commands):
        operand_val = self.operand.evaluate(symbol_table,stack_of_commands)
        if self.op_type == 'NOT':
            return int(not operand_val)
        else:
            raise ValueError(f"Operador unário desconhecido '{self.op_type}'")

class Parser:
    def __init__(self, tokenizer: Tokenizer):
        self.tokenizer = tokenizer
        self.current_token = None
        self.advance()

    def advance(self):
        self.tokenizer.next_token()
        self.current_token = self.tokenizer.next

    def parse(self):
        return self.programa()

    def programa(self):
        commands = []
        while self.current_token.tipo != "EOF":
            command = self.comando()
            commands.append(command)
        return commands

    def comando(self):
        if self.current_token.tipo in ["MOVE", "ROTATE"]:
            return self.comando_movimento()
        elif self.current_token.tipo in ["REPEAT", "WHILE", "IF"]:
            return self.comando_controle()
        elif self.current_token.tipo in ["RETURNDOCK", "CLEANTHRASH"]:
            return self.comando_sistema()
        elif self.current_token.tipo in ["STOPCLEAN", "STARTCLEAN"]:
            return self.comando_limpeza()
        elif self.current_token.tipo in ["INT_TYPE", "BOOL_TYPE"]:
            return self.declaracao()
        elif self.current_token.tipo == "IDENT":
            return self.atribuicao()
        elif self.current_token.tipo == "READING":
            return self.leitura()
        else:
            raise SyntaxError(f"Comando inesperado: {self.current_token.tipo}")

    def comando_movimento(self):
        if self.current_token.tipo == "MOVE":
            self.advance()
            direcao = self.match("DIRECAO")
            distancia = self.expr()
            return MoveNode(direcao.valor, distancia)
        elif self.current_token.tipo == "ROTATE":
            self.advance()
            direcao = self.match("DIRECAO")
            angulo = self.expr()
            return RotateNode(direcao.valor, angulo)

    def comando_controle(self):
        if self.current_token.tipo == "REPEAT":
            self.advance()
            n = self.expr()
            bloco = [self.comando()] if self.current_token.tipo != "LBRACE" else self.bloco()
            return RepeatNode(n, bloco)
        elif self.current_token.tipo == "WHILE":
            self.advance()
            condicao = self.condicao()
            bloco = [self.comando()] if self.current_token.tipo != "LBRACE" else self.bloco()
            return WhileNode(condicao, bloco)
        elif self.current_token.tipo == "IF":
            self.advance()
            condicao = self.condicao()
            bloco = [self.comando()] if self.current_token.tipo != "LBRACE" else self.bloco()
            return IfNode(condicao, bloco)

    def comando_sistema(self):
        if self.current_token.tipo == "RETURNDOCK":
            self.advance()
            return ReturnDockNode()
        elif self.current_token.tipo == "CLEANTHRASH":
            self.advance()
            return CleanTrashNode()

    def comando_limpeza(self):
        if self.current_token.tipo == "STOPCLEAN":
            self.advance()
            return StopCleanNode()
        elif self.current_token.tipo == "STARTCLEAN":
            self.advance()
            return StartCleanNode()

    def declaracao(self):
        var_type = self.current_token.tipo
        self.advance()
        ident = self.match("IDENT")
        return DeclarationNode(var_type, ident.valor)

    def atribuicao(self):
        ident = self.current_token.valor
        self.advance()
        if self.current_token.tipo == "ATRIB":
            self.advance()
            valor = self.expr()
            return AssignmentNode(ident, valor)
        elif self.current_token.tipo in ["INC", "DEC"]:
            op = self.current_token.tipo
            self.advance()
            return AssignmentNode(ident, op)
        else:
            raise SyntaxError(f"Esperado '=' ou operador de incremento/decremento após '{ident}'")

    def bloco(self):
        self.match("LBRACE")
        commands = []
        while self.current_token.tipo != "RBRACE":
            command = self.comando()
            commands.append(command)
        self.match("RBRACE")
        return commands

    def leitura(self):
        if self.current_token.tipo == "READING":
            self.advance()
            sensor = self.expr()
            return ReadingNode(sensor)
        else:
            raise SyntaxError(f"Comando de leitura inválido: {self.current_token.tipo}")

    def condicao(self):
        left = self.expr()
        if self.current_token.tipo in ["MAIOR", "MENOR", "IGUAL"]:
            op = self.current_token.tipo
            self.advance()
            right = self.expr()
            return BinOpNode(op, left, right)
        elif self.current_token.tipo == "NOT":
            self.advance()
            cond = self.condicao()
            return UnOpNode("NOT", cond)
        else:
            return left  # Retorna a expressão diretamente se não houver operador de comparação

    def expr(self):
        left = self.and_expr()
        while self.current_token.tipo == "OR":
            op = self.current_token.tipo
            self.advance()
            right = self.and_expr()
            left = BinOpNode(op, left, right)
        return left

    def and_expr(self):
        left = self.comparison_expr()
        while self.current_token.tipo == "AND":
            op = self.current_token.tipo
            self.advance()
            right = self.comparison_expr()
            left = BinOpNode(op, left, right)
        return left

    def comparison_expr(self):
        left = self.arithmetic_expr()
        while self.current_token.tipo in ["MAIOR", "MENOR", "IGUAL"]:
            op = self.current_token.tipo
            self.advance()
            right = self.arithmetic_expr()
            left = BinOpNode(op, left, right)
        return left

    def arithmetic_expr(self):
        left = self.term()
        while self.current_token.tipo in ["SUM", "SUB"]:
            op = self.current_token.tipo
            self.advance()
            right = self.term()
            left = BinOpNode(op, left, right)
        return left

    def term(self):
        left = self.factor()
        while self.current_token.tipo in ["MULT", "DIV"]:
            op = self.current_token.tipo
            self.advance()
            right = self.factor()
            left = BinOpNode(op, left, right)
        return left

    def factor(self):
        if self.current_token.tipo == "NUM":
            num = self.current_token.valor
            self.advance()
            return ExpressionNode(num)
        elif self.current_token.tipo == "IDENT":
            ident = self.current_token.valor
            self.advance()
            return IdentifierNode(ident)
        elif self.current_token.tipo == "LPAREN":
            self.advance()
            expr = self.expr()
            self.match("RPAREN")
            return expr
        elif self.current_token.tipo == "NOT":
            op = self.current_token.tipo
            self.advance()
            factor = self.factor()
            return UnOpNode(op, factor)
        elif self.current_token.tipo == "BOOL":
            bool_value = self.current_token.valor == "true"
            self.advance()
            return ExpressionNode(bool_value)
        elif self.current_token.tipo == "READING":
            return self.leitura()
        else:
            raise SyntaxError(f"Invalid factor: {self.current_token.tipo}")

    def match(self, expected_type):
        if self.current_token.tipo == expected_type:
            token = self.current_token
            self.advance()
            return token
        else:
            raise SyntaxError(f"Esperado {expected_type}, Encontrado {self.current_token.tipo}")

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
"""

if len(sys.argv) != 2:
    print("Uso: python main.py <caminho_do_arquivo.txt>")
    sys.exit(1)

try:
    with open(sys.argv[1], "r", encoding="utf-8") as file:
        source_code = file.read()
except FileNotFoundError:
    print(f"Erro: O arquivo '{sys.argv[1]}' não foi encontrado.")
    sys.exit(1)
except Exception as e:
    print(f"Erro ao ler o arquivo: {e}")
    sys.exit(1)

tokenizer = Tokenizer(source_code)
parser = Parser(tokenizer)
ast = parser.parse()
symbol_table = SymbolTable()
stack_of_commands = StackOfCommands()

for command in ast:
    command.evaluate(symbol_table, stack_of_commands)