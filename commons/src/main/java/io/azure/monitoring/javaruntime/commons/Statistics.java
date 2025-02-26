package io.azure.monitoring.javaruntime.commons;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.time.Duration;
import java.time.Instant;

@Entity
@Table(name = "TABLE_STATISTICS")
public class Statistics {

    @GeneratedValue
    @Id
    private Long id;
    @Column(name = "DONE_AT")
    public Instant doneAt = Instant.now();
    @Column(name = "JAVA_RUNTIME")
    @Enumerated(EnumType.STRING)
    public JavaRuntime javaRuntime;
    @Column(name = "ITERATION_FOR_CPU")
    public Long iterationForCpu;
    @Column(name = "BITES_FOR_MEMORY")
    public Integer bitesForMemory;
    public Duration duration;
    @Column(columnDefinition = "TEXT")
    public String description;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }
}

