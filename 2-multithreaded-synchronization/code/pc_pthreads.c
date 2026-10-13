#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <time.h>

int *buffer;
int N, ITEMS, M, K;

int in = 0, out = 0;
int produced_count = 0;
int consumed_count = 0;

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t empty = PTHREAD_COND_INITIALIZER;
pthread_cond_t full = PTHREAD_COND_INITIALIZER;

void *producer(void *arg)
{
    int id = *(int*)arg;

    while (1)
    {
        pthread_mutex_lock(&mutex);

        if (produced_count >= ITEMS)
        {
            pthread_mutex_unlock(&mutex);
            break;
        }

        while (((in + 1) % N) == out)
            pthread_cond_wait(&empty, &mutex);

        buffer[in] = produced_count;
        produced_count++;
        in = (in + 1) % N;

        pthread_cond_signal(&full);
        pthread_mutex_unlock(&mutex);
    }

    return NULL;
}

void *consumer(void *arg)
{
    while (1)
    {
        pthread_mutex_lock(&mutex);

        if (consumed_count >= ITEMS)
        {
            pthread_mutex_unlock(&mutex);
            break;
        }

        while (in == out)
            pthread_cond_wait(&full, &mutex);

        int item = buffer[out];
        out = (out + 1) % N;
        consumed_count++;

        pthread_cond_signal(&empty);
        pthread_mutex_unlock(&mutex);
    }

    return NULL;
}

int main(int argc, char *argv[])
{
    if (argc != 5)
    {
        printf("Usage: %s <buffer_size N> <items> <producers M> <consumers K>\n", argv[0]);
        return 1;
    }

    N = atoi(argv[1]);
    ITEMS = atoi(argv[2]);
    M = atoi(argv[3]);
    K = atoi(argv[4]);

    buffer = malloc(sizeof(int) * N);

    pthread_t producers[M], consumers[K];
    int ids[M];

    struct timespec start, end;

    clock_gettime(CLOCK_MONOTONIC, &start);

    // create producers
    for (int i = 0; i < M; i++)
    {
        ids[i] = i;
        pthread_create(&producers[i], NULL, producer, &ids[i]);
    }

    // create consumers
    for (int i = 0; i < K; i++)
    {
        pthread_create(&consumers[i], NULL, consumer, NULL);
    }

    // join producers
    for (int i = 0; i < M; i++)
        pthread_join(producers[i], NULL);

    // join consumers
    for (int i = 0; i < K; i++)
        pthread_join(consumers[i], NULL);

    clock_gettime(CLOCK_MONOTONIC, &end);

    double time_taken =
        (end.tv_sec - start.tv_sec) +
        (end.tv_nsec - start.tv_nsec) / 1e9;

    printf("N=%d M=%d K=%d ITEMS=%d TIME=%.6f\n",
           N, M, K, ITEMS, time_taken);

    return 0;
}
