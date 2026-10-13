#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>
#include <stdlib.h>
#include <unistd.h>

int N, ROUNDS, MODE;
sem_t *chopstick;

void *philosopher(void *arg) {
    int i = *(int *)arg;

    for (int r = 0; r < ROUNDS; r++) {

        if (MODE == 0) {
            // naive (can deadlock)
            sem_wait(&chopstick[i]);
            sem_wait(&chopstick[(i + 1) % N]);
        } else {
            // simple fix: ordering
            if (i % 2 == 0) {
                sem_wait(&chopstick[i]);
                sem_wait(&chopstick[(i + 1) % N]);
            } else {
                sem_wait(&chopstick[(i + 1) % N]);
                sem_wait(&chopstick[i]);
            }
        }

        usleep(100);

        sem_post(&chopstick[i]);
        sem_post(&chopstick[(i + 1) % N]);
    }

    return NULL;
}

int main(int argc, char *argv[]) {
    if (argc != 4) {
        printf("Usage: %s N ROUNDS MODE\n", argv[0]);
        return 1;
    }

    N = atoi(argv[1]);
    ROUNDS = atoi(argv[2]);
    MODE = atoi(argv[3]);

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

    printf("Semaphore done\n");

    return 0;
}
