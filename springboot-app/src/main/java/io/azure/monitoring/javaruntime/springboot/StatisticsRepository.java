package io.azure.monitoring.javaruntime.springboot;

import io.azure.monitoring.javaruntime.commons.Statistics;
import org.springframework.data.repository.CrudRepository;

interface StatisticsRepository extends CrudRepository<Statistics, Long> {
}
