# Nome: Nicolas Enzo Yassuda
# Linguagem de Programação para Kubernetes
## Video: https://youtu.be/8ZaqlDwzlu0

---
## **Tipos de Comandos**
1. **Comandos de Deployment** - Para implantar aplicações no Kubernetes.
2. **Comandos de Service** - Para expor aplicações em um cluster Kubernetes.
3. **Comandos de Pod** - Para gerenciar pods individuais.
4. **Comandos de Configuração** - Para gerenciar configurações e segredos.
5. **Comandos de Monitoramento** - Para monitorar o estado do cluster e dos pods.
6. **Comandos de Escalonamento** - Para escalar aplicações em um cluster Kubernetes.
---

## **Características da Linguagem**

### **Tipos de Variáveis**
1. **Inteiro** (`int`) - Para armazenar números inteiros (declarar numeros de pods ou replicas por exemplo).
2. **Lógico** (`bool`) - Para controle das logicas de escalonamento.
3. **String** (`string`) - Para armazenar textos (nomes de serviços, imagens de containers, etc).
4. **Array** (`array`) - Para armazenar listas de valores (endereços IP, nomes de pods, etc).
5. **Dicionário** (`dict`) - Para armazenar pares chave-valor (configurações de ambiente, labels, etc).

### **Operações Matemáticas**
1. Soma (`+`)
2. Subtração (`-`)
3. Multiplicação (`*`)
4. Divisão (`/`)

### **Operações Lógicas**
1. E (`and`)
2. Ou (`or`)
3. Negação (`!`)

### **Operações de Comparação**
1. Maior (`>`)
2. Menor (`<`)
3. Igual (`==`)

### **Operações de Atribuição**
1. Atribuição (`=`)
2. Incremento (`++`)
3. Decremento (`--`)

---

## **EBNF da Linguagem**

A gramática da linguagem, definida usando a notação BNF estendida (EBNF), está detalhada abaixo:

```ebnf
program           = { statement } ;

statement         = resource_declaration | assignment ;

resource_declaration = resource_kind , identifier , ";" ;
resource_kind     = "POD" | "DEPLOYMENT" | "SERVICE" | "CONFIGMAP" | "SECRET" | "PERSISTENTVOLUMECLAIM" ;

assignment        = identifier , "." , identifier , "=" , value , ";" ;

value             = string_literal 
                  | number_literal 
                  | array 
                  | object 
                  | reference 
                  | boolean_literal ;

array             = "[" , [ value , { "," , value } ] , "]" ;
object            = "{" , [ key_value_pair , { "," , key_value_pair } ] , "}" ;
key_value_pair    = ( string_literal | identifier ) , "=" , value ;

reference         = identifier , "." , identifier ;

string_literal    = """" , { character - """ } , """" ;
number_literal    = integer | float ;
integer           = [ "-" ] , digit , { digit } ;
float             = integer , "." , digit , { digit } ;
boolean_literal   = "true" | "false" ;

identifier        = letter , { letter | digit | "_" | "-" } ;
letter            = "a" | "b" | ... | "z" | "A" | "B" | ... | "Z" ;
digit             = "0" | "1" | ... | "9" ;
```

---


