import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

public class ProducerConsumer {

    static int BUFFER;
    static int ITEMS;
    static int PRODUCERS;
    static int CONSUMERS;

    static final int POISON = -1;

    public static void main(String[] args) throws Exception {

        if (args.length < 4) {
            System.out.println("Usage: java ProducerConsumer <buffer> <items> <producers> <consumers>");
            return;
        }

        BUFFER = Integer.parseInt(args[0]);
        ITEMS = Integer.parseInt(args[1]);
        PRODUCERS = Integer.parseInt(args[2]);
        CONSUMERS = Integer.parseInt(args[3]);

        BlockingQueue<Integer> queue = new ArrayBlockingQueue<>(BUFFER);

        long start = System.nanoTime();

        Thread[] producers = new Thread[PRODUCERS];
        Thread[] consumers = new Thread[CONSUMERS];

        int itemsPerProducer = ITEMS / PRODUCERS;

        // ---------------- PRODUCERS ----------------
        for (int i = 0; i < PRODUCERS; i++) {
            final int id = i;

            producers[i] = new Thread(() -> {
                int startItem = id * itemsPerProducer;
                int endItem = (id == PRODUCERS - 1) ? ITEMS : startItem + itemsPerProducer;

                try {
                    for (int j = startItem; j < endItem; j++) {
                        queue.put(j);
                    }
                } catch (InterruptedException ignored) {}
            });
        }

        // ---------------- CONSUMERS ----------------
        for (int i = 0; i < CONSUMERS; i++) {
            consumers[i] = new Thread(() -> {
                try {
                    while (true) {
                        int item = queue.take();
                        if (item == POISON) break;
                    }
                } catch (InterruptedException ignored) {}
            });
        }

        // start producers
        for (Thread t : producers) t.start();

        // start consumers
        for (Thread t : consumers) t.start();

        // wait producers
        for (Thread t : producers) t.join();

        // send poison pills to stop consumers
        for (int i = 0; i < CONSUMERS; i++) {
            queue.put(POISON);
        }

        // wait consumers
        for (Thread t : consumers) t.join();

        long end = System.nanoTime();

        double time = (end - start) / 1e9;

        System.out.println(
            "N=" + BUFFER +
            " M=" + PRODUCERS +
            " K=" + CONSUMERS +
            " ITEMS=" + ITEMS +
            " TIME=" + time
        );
    }
}
