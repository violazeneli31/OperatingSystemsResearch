#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>
#include <stdlib.h>
#include <unistd.h>

int N, ROUNDS;
sem_t *chopstick;

void *philosopher(void *arg) {
    int i = *(int *)arg;

    for (int r = 0; r < ROUNDS; r++) {

        int left = i;
        int right = (i + 1) % N;

        if (left > right) {
            int temp = left;
            left = right;
            right = temp;
        }

        sem_wait(&chopstick[left]);
        sem_wait(&chopstick[right]);

        usleep(100);

        sem_post(&chopstick[left]);
        sem_post(&chopstick[right]);
    }

    return NULL;
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Usage: %s N ROUNDS\n", argv[0]);
        return 1;
    }

    N = atoi(argv[1]);
    ROUNDS = atoi(argv[2]);

    pthread_t *t = malloc(N * sizeof(pthread_t));
    chopstick = malloc(N * sizeof(sem_t));

    for (int i = 0; i < N; i++)
        sem_init(&chopstick[i], 0, 1);

    int *id = malloc(N * sizeof(int));

    for (int i = 0; i < N; i++) {
        id[i] = i;
        pthread_create(&t[i], NULL, philosopher, &id[i]);
    }

    for (int i = 0; i < N; i++)
        pthread_join(t[i], NULL);

    printf("Hierarchy done\n");

    return 0;
}
