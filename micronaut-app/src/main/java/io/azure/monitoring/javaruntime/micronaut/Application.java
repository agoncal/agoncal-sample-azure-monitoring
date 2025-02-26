package io.azure.monitoring.javaruntime.micronaut;

import io.azure.monitoring.javaruntime.commons.Statistics;
import io.micronaut.core.annotation.Introspected;
import io.micronaut.runtime.Micronaut;
import io.micronaut.serde.annotation.SerdeImport;
import jakarta.persistence.Entity;

@Introspected(packages="io.azure.monitoring.javaruntime.commons", includedAnnotations= Entity.class)
@SerdeImport(Statistics.class)
public class Application {

    public static void main(String[] args) {
        Micronaut.run(Application.class, args);
    }
}
