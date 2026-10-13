#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>

#define THINKING 0
#define HUNGRY 1
#define EATING 2

int N, ROUNDS;

int *state;
pthread_mutex_t mutex;
pthread_cond_t *cond;

int left(int i) { return (i + N - 1) % N; }
int right(int i) { return (i + 1) % N; }

void test(int i) {
    if (state[i] == HUNGRY &&
        state[left(i)] != EATING &&
        state[right(i)] != EATING) {

        state[i] = EATING;
        pthread_cond_signal(&cond[i]);
    }
}

void take_forks(int i) {
    pthread_mutex_lock(&mutex);

    state[i] = HUNGRY;
    test(i);

    while (state[i] != EATING)
        pthread_cond_wait(&cond[i], &mutex);

    pthread_mutex_unlock(&mutex);
}

void put_forks(int i) {
    pthread_mutex_lock(&mutex);

    state[i] = THINKING;
    test(left(i));
    test(right(i));

    pthread_mutex_unlock(&mutex);
}

void *philosopher(void *arg) {
    int i = *(int *)arg;

    for (int r = 0; r < ROUNDS; r++) {
        take_forks(i);
        usleep(100);
        put_forks(i);
        usleep(50);
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
    state = malloc(N * sizeof(int));
    cond = malloc(N * sizeof(pthread_cond_t));

    pthread_mutex_init(&mutex, NULL);

    int *id = malloc(N * sizeof(int));

    for (int i = 0; i < N; i++) {
        state[i] = THINKING;
        pthread_cond_init(&cond[i], NULL);
    }

    for (int i = 0; i < N; i++) {
        id[i] = i;
        pthread_create(&t[i], NULL, philosopher, &id[i]);
    }

    for (int i = 0; i < N; i++)
        pthread_join(t[i], NULL);

    printf("Monitor done\n");

    return 0;
}
