package io.azure.monitoring.javaruntime.commons;

import static java.lang.System.Logger.Level.DEBUG;

import java.lang.System.Logger;
import java.util.HashMap;

public class LoadUtil {

    private static final Logger LOGGER = System.getLogger(LoadUtil.class.getName());

    public static void loadCPU(Long iterationForCpu) {
        LOGGER.log(DEBUG, "Load CPU");

        if (iterationForCpu == null) {
            iterationForCpu = 20000L;
        } else {
            iterationForCpu *= 20000;
        }
        while (iterationForCpu > 0) {
            if (iterationForCpu % 20000 == 0) {
                try {
                    Thread.sleep(20);
                } catch (InterruptedException ie) {
                }
            }
            iterationForCpu--;
        }
    }

    public static void loadMemory(Integer bitesForMemory) {
        LOGGER.log(DEBUG, "Load Memory");

        if (bitesForMemory == null) {
            bitesForMemory = 1;
        }
        HashMap hunger = new HashMap<>();
        for (int i = 0; i < bitesForMemory * 1024 * 1024; i += 8192) {
            byte[] bytes = new byte[8192];
            hunger.put(i, bytes);
            for (int j = 0; j < 8192; j++) {
                bytes[j] = '0';
            }
        }
    }
}
