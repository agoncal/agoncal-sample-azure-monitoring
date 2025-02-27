package io.azure.monitoring.javaruntime.quarkus;

import static io.azure.monitoring.javaruntime.commons.JavaRuntime.QUARKUS;
import io.azure.monitoring.javaruntime.commons.LoadUtil;
import io.azure.monitoring.javaruntime.commons.Statistics;
import jakarta.ws.rs.DefaultValue;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.QueryParam;
import jakarta.ws.rs.core.MediaType;
import static java.lang.System.Logger.Level.INFO;

import java.lang.System.Logger;
import java.time.Duration;
import java.time.Instant;
import java.util.List;

@Path("/quarkus")
@Produces(MediaType.TEXT_PLAIN)
public class QuarkusResource {

    private static final Logger LOGGER = System.getLogger(QuarkusResource.class.getName());

    private final StatisticsRepository repository;
    private final ChatBot chatBot;

    public QuarkusResource(StatisticsRepository statisticsRepository, ChatBot chatBot) {
        this.repository = statisticsRepository;
        this.chatBot = chatBot;
    }

    /**
     * Says hello.
     * {@code curl 'localhost:8701/quarkus'}
     *
     * @return hello
     */
    @GET
    public String hello() {
        LOGGER.log(INFO, "Quarkus: hello");
        return "Quarkus: hello";
    }

    /**
     * Simulates requests that use a lot of CPU.
     * {@code curl 'localhost:8701/quarkus/load'}
     * {@code curl 'localhost:8701/quarkus/load?cpu=10'}
     * {@code curl 'localhost:8701/quarkus/load?cpu=10&memory=20&db=true&llm=true&desc=Native'}
     *
     * @param iterationForCpu the number of iterations to run (times 20,000).
     * @param bitesForMemory  the number of megabytes to eat
     * @return the result
     */
    @GET
    @Path("/load")
    public String cpu(@QueryParam("cpu") @DefaultValue("1") Long iterationForCpu,
                      @QueryParam("memory") @DefaultValue("1") Integer bitesForMemory,
                      @QueryParam("db") @DefaultValue("false") Boolean db,
                      @QueryParam("llm") @DefaultValue("false") Boolean llm,
                      @QueryParam("desc") @DefaultValue("JVM") String desc) {
        String msg = "Quarkus: load: %d Cpu Iterations - %d Memory Bites - DB %b - LLM %b - %s.".formatted(iterationForCpu, bitesForMemory, db, llm, desc);
        LOGGER.log(INFO, msg);
        Instant start = Instant.now();

        // Consume CPU
        LoadUtil.loadCPU(iterationForCpu);

        // Consume Memory
        LoadUtil.loadMemory(bitesForMemory);

        // Invoke LLM
        if (llm) {
            String answer = chatBot.askForMonitoringHelp(iterationForCpu, bitesForMemory, Duration.between(start, Instant.now()).getNano());
            msg += " The prompt has been received from the LLM:" + answer;
        }

        // Invoke DB
        if (db) {
            Statistics statistics = new Statistics();
            statistics.iterationForCpu = iterationForCpu;
            statistics.bitesForMemory = bitesForMemory;
            statistics.duration = Duration.between(start, Instant.now());
            statistics.javaRuntime = QUARKUS;
            statistics.description = msg;
            repository.persist(statistics);
            msg += " The result is persisted in the database.";
        }

        // Return statistics result
        msg += " All that in " + Duration.between(start, Instant.now()).getNano() + " nano-seconds.";
        return msg;
    }

    /**
     * Returns what's in the database.
     * {@code curl 'localhost:8701/quarkus/stats'}
     *
     * @return the list of Statistics.
     */
    @GET
    @Path("/stats")
    @Produces(MediaType.APPLICATION_JSON)
    public List<Statistics> stats() {
        LOGGER.log(INFO, "Quarkus: retrieving statistics");
        return repository.findAll().list();
    }
}
