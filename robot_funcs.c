#include <stdio.h>

void robot_move(char* dir, int speed) {
    printf("Movendo para %s com velocidade %d\n", dir, speed);
}

void robot_rotate(char* dir, int angle) {
    printf("Rotacionando %s em %d graus\n", dir, angle);
}

void robot_start_clean() {
    printf("Iniciando limpeza...\n");
}

void robot_stop_clean() {
    printf("Parando limpeza.\n");
}

void robot_clean_trash() {
    printf("Limpando sujeira.\n");
}

void robot_return_dock_simple() {
    // Implementação fictícia ou real do movimento de retorno à base
    printf("Retornando à base...\n");
}

int robot_read_sensor(int sensor_id) {
    printf("Lendo sensor %d\n", sensor_id);
    return 0;
}