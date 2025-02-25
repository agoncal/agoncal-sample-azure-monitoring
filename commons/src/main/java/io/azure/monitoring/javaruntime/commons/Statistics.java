package io.azure.monitoring.javaruntime.commons;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.time.Duration;
import java.time.Instant;

@Entity
@Table(name = "Statistics_Quarkus")
public class Statistics {

    @GeneratedValue
    @Id
    private Long id;
    @Column(name = "DONE_AT")
    public Instant doneAt = Instant.now();
    public JavaRuntime javaRuntime;
    @Column(name = "ITERATION_FOR_CPU")
    public Long iterationForCpu;
    @Column(name = "BITES_FOR_MEMORY")
    public Integer bitesForMemory;
    public Duration duration;
    public String description;
}

