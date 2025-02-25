package io.azure.monitoring.javaruntime.micronaut;

import io.azure.monitoring.javaruntime.commons.Statistics;
import io.micronaut.data.annotation.Repository;
import io.micronaut.data.repository.CrudRepository;

@Repository
interface StatisticsRepository extends CrudRepository<Statistics, Long> {
}
