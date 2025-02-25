package io.azure.monitoring.javaruntime.quarkus;

import io.azure.monitoring.javaruntime.commons.Statistics;
import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.transaction.Transactional;

@ApplicationScoped
@Transactional
public class StatisticsRepository implements PanacheRepository<Statistics> {
}
