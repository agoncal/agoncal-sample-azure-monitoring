package io.azure.monitoring.javaruntime.quarkus;

import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import io.quarkiverse.langchain4j.RegisterAiService;

@RegisterAiService
public interface ChatBot {

    @SystemMessage("You are a professional Java performance engineer.")
    @UserMessage("""
        I've been monitoring my Java application for a while now, and I noticed that the CPU and Memory usage are quite high.
        Can you help me understand what might be causing this issue?
        I have {iterations} iterations for CPU and {bites} bites for memory and it takes {nanos} nano-seconds to finish.
        What do you think?
        """)
    String askForMonitoringHelp(Long iterations, Integer bites, Integer nanos);
}
