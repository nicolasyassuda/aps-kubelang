#!/bin/bash

TEST_DIR="./testes"

for i in {1..15}
do
    ARQUIVO="$TEST_DIR/teste$i.txt"
    
    if [ -f "$ARQUIVO" ]; then
        echo "🚀 Executando $ARQUIVO..."
        python3 compilador.py "$ARQUIVO"
        echo "----------------------------------------"
        python3 llvm.py "$ARQUIVO"
        echo "----------------------------------------"
    else
        echo "❌ Arquivo $ARQUIVO não encontrado."
    fi
done