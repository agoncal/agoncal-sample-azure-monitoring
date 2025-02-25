package io.azure.monitoring.javaruntime.springboot;

import org.springframework.boot.SpringApplication;

public class TestSpringbootApplication {

	public static void main(String[] args) {
		SpringApplication.from(SpringbootApplication::main).with(TestcontainersConfiguration.class).run(args);
	}

}
