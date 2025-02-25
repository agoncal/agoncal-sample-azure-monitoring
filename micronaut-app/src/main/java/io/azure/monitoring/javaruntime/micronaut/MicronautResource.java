package io.azure.monitoring.javaruntime.micronaut;

import io.azure.monitoring.javaruntime.commons.AIUtil;
import static io.azure.monitoring.javaruntime.commons.JavaRuntime.MICRONAUT;
import io.azure.monitoring.javaruntime.commons.LoadUtil;
import io.azure.monitoring.javaruntime.commons.Statistics;
import io.micronaut.http.MediaType;
import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import io.micronaut.http.annotation.QueryValue;
import static java.lang.System.Logger.Level.INFO;
import static java.lang.invoke.MethodHandles.lookup;

import java.lang.System.Logger;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

@Controller("/micronaut")
public class MicronautResource {

    private static final Logger LOGGER = System.getLogger(lookup().lookupClass().getName());

    private final StatisticsRepository repository;

    public MicronautResource(StatisticsRepository statisticsRepository) {
        this.repository = statisticsRepository;
    }

    /**
     * Says hello.
     * {@code curl 'localhost:8702/micronaut'}
     *
     * @return hello
     */
    @Get(produces = MediaType.TEXT_PLAIN)
    public String hello() {
        LOGGER.log(INFO, "Micronaut: hello");
        return "Micronaut: hello";
    }

    /**
     * Simulates requests that use a lot of CPU.
     * {@code curl 'localhost:8702/micronaut/load'}
     * {@code curl 'localhost:8702/micronaut/load?cpu=10'}
     * {@code curl 'localhost:8702/micronaut/load?cpu=10&memory=20&db=true&llm=true&desc=Native'}
     *
     * @param iterationForCpu the number of iterations to run (times 20,000).
     * @param bitesForMemory  the number of megabytes to eat
     * @return the result
     */
    @Get(uri = "/load", produces = MediaType.TEXT_PLAIN)
    public String cpu(@QueryValue(value = "cpu", defaultValue = "1") Long iterationForCpu,
                      @QueryValue(value = "memory", defaultValue = "1") Integer bitesForMemory,
                      @QueryValue(value = "db", defaultValue = "false") Boolean db,
                      @QueryValue(value = "llm", defaultValue = "false") Boolean llm,
                      @QueryValue(value = "desc", defaultValue = "JVM") String desc) {
        String msg = "Quarkus: load: %d Cpu Iterations - %d Memory Bites - DB %b - LLM %b - %s.".formatted(iterationForCpu, bitesForMemory, db, llm, desc);
        LOGGER.log(INFO, msg);
        Instant start = Instant.now();

        // Consume CPU
        LoadUtil.loadCPU(iterationForCpu);

        // Consume Memory
        LoadUtil.loadMemory(bitesForMemory);

        // Invoke LLM
        if (llm) {
            String answer = AIUtil.askForMonitoringHelp(iterationForCpu, bitesForMemory, start);
            msg += " The prompt has been received from the LLM:" + answer;
        }

        // Invoke DB
        if (db) {
            Statistics statistics = new Statistics();
            statistics.iterationForCpu = iterationForCpu;
            statistics.bitesForMemory = bitesForMemory;
            statistics.duration = Duration.between(start, Instant.now());
            statistics.javaRuntime = MICRONAUT;
            statistics.description = msg;
            repository.save(statistics);
            msg += " The result is persisted in the database.";
        }

        // Return statistics result
        msg += " All that in " + Duration.between(start, Instant.now()).getNano() + " nano-seconds.";
        return msg;
    }

    /**
     * Returns what's in the database.
     * {@code curl 'localhost:8702/micronaut/stats'}
     *
     * @return the list of Statistics.
     */
    @Get(uri = "/stats", produces = MediaType.APPLICATION_JSON)
    public List<Statistics> stats() {
        LOGGER.log(INFO, "Micronaut: retrieving statistics");
        List<Statistics> result = new ArrayList<Statistics>();
        for (Statistics stats : repository.findAll()) {
            result.add(stats);
        }
        return result;
    }
}
