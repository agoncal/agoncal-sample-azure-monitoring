package io.azure.monitoring.javaruntime.commons;

import static java.lang.System.Logger.Level.DEBUG;

import java.lang.System.Logger;
import java.time.Instant;

public class AIUtil {

    private static final Logger LOGGER = System.getLogger(AIUtil.class.getName());

    private static final String AZURE_OPENAI_KEY = System.getenv("AZURE_OPENAI_KEY");
    private static final String AZURE_OPENAI_ENDPOINT = System.getenv("AZURE_OPENAI_ENDPOINT");
    private static final String AZURE_OPENAI_DEPLOYMENT_NAME = System.getenv("AZURE_OPENAI_DEPLOYMENT_NAME");

    private static final String PROMPT = """
        I've been monitoring my Java application for a while now, and I noticed that the CPU and Memory usage are quite high.
        Can you help me understand what might be causing this issue?
        I have %d iterations for CPU and %d bites for memory and it takes %d nano-seconds to finish.
        What do you think?
        """;

    public static String askForMonitoringHelp(Long iterationForCpu, Integer bitesForMemory, Instant start) {
        LOGGER.log(DEBUG, "ask for Monitoring Help");

//        AzureOpenAiChatModel model = AzureOpenAiChatModel.builder()
//            .apiKey(AZURE_OPENAI_KEY)
//            .endpoint(AZURE_OPENAI_ENDPOINT)
//            .deploymentName(AZURE_OPENAI_DEPLOYMENT_NAME)
//            .temperature(0.3)
//            .logRequestsAndResponses(true)
//            .build();
//
//        String prompt = PROMPT.formatted(iterationForCpu, bitesForMemory, Duration.between(start, Instant.now()).getNano());
//        LOGGER.log(DEBUG, prompt);
//
//        String completion = model.chat(prompt);
//        LOGGER.log(DEBUG, completion);

        return "toto";
    }

}
