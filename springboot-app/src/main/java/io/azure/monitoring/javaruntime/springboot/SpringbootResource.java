package io.azure.monitoring.javaruntime.springboot;

import io.azure.monitoring.javaruntime.commons.AIUtil;
import static io.azure.monitoring.javaruntime.commons.JavaRuntime.SPRINGBOOT;
import io.azure.monitoring.javaruntime.commons.LoadUtil;
import io.azure.monitoring.javaruntime.commons.Statistics;
import static java.lang.System.Logger.Level.INFO;
import static java.lang.invoke.MethodHandles.lookup;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.lang.System.Logger;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/springboot")
public class SpringbootResource {

    private static final Logger LOGGER = System.getLogger(lookup().lookupClass().getName());

    private final StatisticsRepository repository;

    public SpringbootResource(StatisticsRepository statisticsRepository) {
        this.repository = statisticsRepository;
    }

    /**
     * Says hello.
     * {@code curl 'localhost:8703/springboot'}
     *
     * @return hello
     */
    @GetMapping(produces = MediaType.TEXT_PLAIN_VALUE)
    public String hello() {
        LOGGER.log(INFO, "Spring Boot: hello");
        return "Spring Boot: hello";
    }

    /**
     * Simulates requests that use a lot of CPU.
     * {@code curl 'localhost:8703/springboot/load'}
     * {@code curl 'localhost:8703/springboot/load?cpu=10'}
     * {@code curl 'localhost:8703/springboot/load?cpu=10&memory=20&db=true&llm=true&desc=Native'}
     *
     * @param iterationForCpu the number of iterations to run (times 20,000).
     * @param bitesForMemory  the number of megabytes to eat
     * @return the result
     */
    @GetMapping(path = "/load", produces = MediaType.TEXT_PLAIN_VALUE)
    public String cpu(@RequestParam(value = "cpu", defaultValue = "1") Long iterationForCpu,
                      @RequestParam(value = "memory", defaultValue = "1") Integer bitesForMemory,
                      @RequestParam(value = "db", defaultValue = "false") Boolean db,
                      @RequestParam(value = "llm", defaultValue = "false") Boolean llm,
                      @RequestParam(value = "desc", defaultValue = "JVM") String desc) {
        String msg = "Spring Boot: load: %d Cpu Iterations - %d Memory Bites - DB %b - LLM %b - %s.".formatted(iterationForCpu, bitesForMemory, db, llm, desc);
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
            statistics.javaRuntime = SPRINGBOOT;
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
     * {@code curl 'localhost:8703/springboot/stats'}
     *
     * @return the list of Statistics.
     */
    @GetMapping(path = "/stats", produces = MediaType.APPLICATION_JSON_VALUE)
    public List<Statistics> stats() {
        LOGGER.log(INFO, "Spring Boot: retrieving statistics");
        List<Statistics> result = new ArrayList<>();
        for (Statistics stats : repository.findAll()) {
            result.add(stats);
        }
        return result;
    }
}
